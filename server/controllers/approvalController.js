const pool = require('../utilities/db');
const { getCleanDays, getDayName } = require('../utilities/leaveUtils');

/**
 * Get Approval Letter Data
 * Replaces logic in generate_approval.php
 */
const getApprovalData = async (req, res) => {
  try {
    const requestId = parseInt(req.params.id);
    const { id: currentUserId, role } = req.user;

    // 1. Fetch Basic Info
    const query = `
      SELECT lr.*, 
             u.full_name, u.employee_id, u.designation, u.department, u.weekly_off, 
             lt.name as type_name, 
             adm.full_name as admin_name, adm.digital_seal 
      FROM leave_requests lr 
      JOIN users u ON lr.user_id = u.id 
      JOIN leave_types lt ON lr.leave_type_id = lt.id 
      LEFT JOIN users adm ON lr.approved_by = adm.id
      WHERE lr.id = $1 AND lr.status = 'Approved'
    `;
    
    const result = await pool.query(query, [requestId]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Approval letter not found or not approved.' });
    }

    const data = result.rows[0];

    // Security Check: Only Admin or the owner can view
    if (role !== 'Admin' && role !== 'Super Admin' && data.user_id !== currentUserId) {
      return res.status(403).json({ message: 'Unauthorized access.' });
    }

    // 2. Fetch Grouped Requests (Same User, Same Applied Time)
    // Using ISO string for comparison might be tricky with timezones, so we use the exact timestamp from DB
    const groupQuery = `
      SELECT lr.*, lt.name as type_name 
      FROM leave_requests lr
      JOIN leave_types lt ON lr.leave_type_id = lt.id
      WHERE lr.user_id = $1 AND lr.applied_at = $2 AND lr.status = 'Approved'
      ORDER BY lr.start_date ASC, lr.id ASC
    `;
    
    const groupResult = await pool.query(groupQuery, [data.user_id, data.applied_at]);
    const leaves = groupResult.rows.length > 0 ? groupResult.rows : [data];

    // 3. Process Leaves & Calculate Joining Date
    const userOffDay = data.weekly_off || 'Friday';
    let maxEndForJoining = null;
    let forceNextDayJoin = false;

    const processedLeaves = leaves.map(lv => {
      const isHalf = parseInt(lv.leave_type_id) === 3;
      let dayCount = 0;
      
      if (isHalf) {
        dayCount = 0.5;
      } else {
        dayCount = getCleanDays(lv.start_date, lv.end_date, userOffDay);
      }

      // Joining Logic
      const endRef = new Date(lv.end_date);
      let requiresNextDay = true;
      
      if (isHalf && lv.half_day_period === 'Morning') {
        requiresNextDay = false; // Joins same day afternoon
      }

      if (!maxEndForJoining || endRef > maxEndForJoining) {
        maxEndForJoining = endRef;
        forceNextDayJoin = requiresNextDay;
      } else if (maxEndForJoining && endRef.getTime() === maxEndForJoining.getTime()) {
        if (requiresNextDay) forceNextDayJoin = true;
      }

      return {
        ...lv,
        day_count: dayCount,
        is_half: isHalf
      };
    });

    // 4. Calculate Final Joining Date
    let joiningDate = null;
    let joiningTimeDesc = '';

    if (maxEndForJoining) {
      const joiningDayObj = new Date(maxEndForJoining);
      
      if (!forceNextDayJoin) {
        // Same day joining (Second Half)
        joiningDate = joiningDayObj;
        joiningTimeDesc = 'Second Half';
      } else {
        // Next working day
        joiningDayObj.setDate(joiningDayObj.getDate() + 1);
        
        // Skip off-days
        // Safety counter to prevent infinite loop
        let safety = 0;
        while (getDayName(joiningDayObj) === userOffDay && safety < 7) {
          joiningDayObj.setDate(joiningDayObj.getDate() + 1);
          safety++;
        }
        joiningDate = joiningDayObj;
        joiningTimeDesc = 'Regular';
      }
    }

    res.json({
      info: data,
      leaves: processedLeaves,
      joining_info: {
        date: joiningDate,
        desc: joiningTimeDesc
      }
    });

  } catch (error) {
    console.error('Approval Data Error:', error);
    res.status(500).json({ message: 'Server Error' });
  }
};

module.exports = { getApprovalData };