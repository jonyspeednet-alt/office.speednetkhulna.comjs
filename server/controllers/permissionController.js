const pool = require('../utilities/db'); // Your PostgreSQL connection pool

/**
 * Update User Permission
 * Replaces: update_permission_ajax.php
 */
const updatePermission = async (req, res) => {
  try {
    // 1. Security Check
    // Assuming auth middleware populates req.user with { id, role }
    const { role } = req.user;
    const currentRole = role ? role.toLowerCase() : '';

    if (currentRole !== 'admin' && currentRole !== 'super admin') {
      return res.status(403).json({ message: 'Unauthorized Access' });
    }

    const { user_id, column, value } = req.body;

    // 2. Dynamic Validation
    // Check if key starts with 'p_' and contains only alphanumeric/underscores
    if (column.startsWith('p_') && /^[a-zA-Z0-9_]+$/.test(column)) {
      
      if (parseInt(value) === 1) {
        // Grant Permission (Insert)
        // Postgres equivalent of INSERT IGNORE requires a unique constraint on (user_id, permission_key)
        const insertQuery = `
          INSERT INTO user_permissions (user_id, permission_key) 
          VALUES ($1, $2) 
          ON CONFLICT (user_id, permission_key) DO NOTHING
        `;
        await pool.query(insertQuery, [user_id, column]);
      } else {
        // Revoke Permission (Delete)
        const deleteQuery = `
          DELETE FROM user_permissions 
          WHERE user_id = $1 AND permission_key = $2
        `;
        await pool.query(deleteQuery, [user_id, column]);
      }

      return res.status(200).json({ message: 'Success' });
    } else {
      return res.status(400).json({ message: 'Invalid Permission Key' });
    }

  } catch (error) {
    console.error('Database Error:', error);
    return res.status(500).json({ message: 'Database Error' });
  }
};

/**
 * Get Data for Permission Management Page
 * Replaces logic in manage_permissions.php
 */
const getManagePermissionsData = async (req, res) => {
  try {
    const currentUserId = req.user.id;
    const { role_name, permissions } = req.user;

    // 1. Authorization Check (using RBAC)
    const isSuperAdmin = (role_name || '').toLowerCase() === 'super admin';
    const canManagePerms = permissions && permissions['p_manage_permissions'];

    if (!isSuperAdmin && !canManagePerms) {
      return res.status(403).json({ message: 'Unauthorized Access' });
    }

    // 2. Fetch Permission Columns (Dynamic from sidebar_menus)
    const permQuery = `
      SELECT permission_column, MAX(menu_name) as menu_name 
      FROM sidebar_menus 
      WHERE permission_column LIKE 'p_%' 
      GROUP BY permission_column 
      ORDER BY permission_column ASC
    `;
    const permResult = await pool.query(permQuery);

    // 3. Fetch Users (Include role_id)
    const userQuery = `
      SELECT id, employee_id, full_name, role, role_id 
      FROM users 
      WHERE role NOT ILIKE 'super admin' AND id != $1
      ORDER BY full_name ASC
    `;
    const userResult = await pool.query(userQuery, [currentUserId]);

    // 4. Fetch Active Permissions Map (for legacy or direct user overrides)
    const activePermQuery = `SELECT user_id, permission_key FROM user_permissions`;
    const activePermResult = await pool.query(activePermQuery);

    const activePermissions = {};
    activePermResult.rows.forEach(row => {
      if (!activePermissions[row.user_id]) activePermissions[row.user_id] = {};
      activePermissions[row.user_id][row.permission_key] = true;
    });

    res.json({ columns: permResult.rows, users: userResult.rows, activePermissions });
  } catch (error) {
    console.error('Get Permissions Data Error:', error);
    res.status(500).json({ message: 'Server Error' });
  }
};

module.exports = { updatePermission, getManagePermissionsData };