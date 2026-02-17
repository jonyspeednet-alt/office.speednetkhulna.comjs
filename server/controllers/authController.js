const pool = require('../utilities/db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

/**
 * Login User
 * Replaces logic in login_action.php
 */
const login = async (req, res) => {
  try {
    // 0. Input Validation & Debugging
    console.log('--- Login Request Received ---');
    console.log('Request Body:', req.body);

    const { identifier, password } = req.body;

    if (!identifier || !password) {
      console.log('Error: Missing identifier or password');
      return res.status(400).json({ message: 'Email/ID and Password are required' });
    }

    const cleanIdentifier = identifier.trim();
    // Normalize employee ID inputs so Unicode dashes/spaces do not break matching.
    const normalizedEmployeeIdentifier = cleanIdentifier
      .replace(/[\u2010-\u2015\u2212]/g, '-')
      .replace(/\s+/g, '')
      .toLowerCase();
    console.log(`Processing Login for: '${cleanIdentifier}'`);

    // 1. Find User by Email or Employee ID (Case Insensitive & Safe Cast)
    const query = `
      SELECT * FROM users 
      WHERE LOWER(TRIM(email)) = LOWER($1) 
      OR LOWER(REGEXP_REPLACE(REPLACE(TRIM(CAST(employee_id AS TEXT)), '-', ''), '[\\s\\u2010-\\u2015\\u2212-]', '', 'g')) = $2
      LIMIT 1
    `;
    const result = await pool.query(query, [
      cleanIdentifier,
      normalizedEmployeeIdentifier.replace(/-/g, '')
    ]);
    const user = result.rows[0];

    if (!user) {
      console.log(`Login Failed: User '${cleanIdentifier}' not found in DB`); 
      return res.status(401).json({ message: 'User not found' });
    }

    // 2. Verify Password
    let isMatch = false;
    // ডাটাবেস পাসওয়ার্ড ক্লিন করা (স্পেস রিমুভ)
    const dbPassword = user.password ? user.password.trim() : '';

    // ডিবাগিং লগ: সার্ভার কনসোলে পাসওয়ার্ড চেক করার জন্য
    console.log('--- Password Verification ---');
    console.log(`Input Password: '${password}'`);
    console.log(`DB Password:    '${dbPassword}'`);

    // First try bcrypt if it looks like a hash
    if (dbPassword.startsWith('$2')) {
      try {
        isMatch = await bcrypt.compare(password, dbPassword);
        console.log(`Method: Bcrypt | Match: ${isMatch}`);
      } catch (err) {
        console.error('Bcrypt Error:', err);
        isMatch = false;
      }
    }

    // If still not matched, try plain text fallback
    if (!isMatch) {
      isMatch = (password === dbPassword);
      console.log(`Method: Plain Text | Match: ${isMatch}`);
    }
    console.log('-------------------');

    if (!isMatch) {
      console.log('Login Failed: Password mismatch'); 
      return res.status(401).json({ message: 'Invalid password' });
    }

    // 3. Generate Token
    const token = jwt.sign(
      { id: user.id, role: user.role, emp_id: user.employee_id, full_name: user.full_name },
      process.env.JWT_SECRET,
      { expiresIn: '1d' }
    );

    // 4. Set Cookie
    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 24 * 60 * 60 * 1000 // 1 day
    });

    // 5. Return User Info (excluding password)
    const { password: _, ...userInfo } = user;
    res.json({ 
      message: 'Login successful',
      user: userInfo,
      token // টোকেন পাঠানো হলো যাতে ফ্রন্টএন্ড localStorage এ রাখতে পারে
    });

  } catch (error) {
    console.error('Login Error:', error);
    res.status(500).json({ message: 'Server Error' });
  }
};

/**
 * Logout User
 * Replaces logic in logout.php
 */
const logout = (req, res) => {
  // Clear the authentication cookie (assuming 'token' is used)
  res.clearCookie('token', {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict'
  });
  
  res.status(200).json({ message: 'Logged out successfully' });
};

module.exports = { login, logout };
