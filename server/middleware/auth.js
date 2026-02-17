const jwt = require('jsonwebtoken');
const pool = require('../utilities/db');
const { getAuthSecret } = require('../utilities/authSecret');

/**
 * Authentication Middleware
 * Replaces: auth_check.php (Backend Logic)
 */
const authMiddleware = async (req, res, next) => {
  try {
    // 1. Get token from cookie or header
    const token = (req.cookies && req.cookies.token) || (req.headers.authorization && req.headers.authorization.split(' ')[1]);

    if (!token) {
      console.log('Auth Failed: No token found');
      return res.status(401).json({ message: 'Authentication required' });
    }

    // 2. Verify Token
    const authSecret = getAuthSecret();
    if (!authSecret) {
      console.error('Auth Middleware Error: JWT_SECRET/SESSION_SECRET is missing in environment');
      return res.status(500).json({ message: 'Server configuration error: JWT secret missing' });
    }

    const decoded = jwt.verify(token, authSecret);
    console.log('Auth: Token verified for user ID:', decoded.id);

    // 3. Fetch User, Role and Permissions
    const userQuery = `
      SELECT u.*, r.name as role_name, r.permissions as role_permissions 
      FROM users u 
      LEFT JOIN roles r ON u.role_id = r.id 
      WHERE u.id = $1
    `;
    const userResult = await pool.query(userQuery, [decoded.id]);
    
    if (userResult.rows.length === 0) {
      console.log('Auth Failed: User not found in DB for ID:', decoded.id);
      return res.status(401).json({ message: 'User no longer exists' });
    }

    const userData = userResult.rows[0];
    const { password, role_permissions, ...user } = userData;

    // Legacy support for user_permissions table
    const permQuery = 'SELECT permission_key FROM user_permissions WHERE user_id = $1';
    const permResult = await pool.query(permQuery, [decoded.id]);
    
    const effectiveRole = user.role_name || user.role || '';
    const isSuperAdmin = ['super admin', 'superadmin'].includes(effectiveRole.toLowerCase());
    const permissions = { ...(role_permissions || {}) };
    permResult.rows.forEach(row => {
      permissions[row.permission_key] = true;
    });
    if (isSuperAdmin) {
      permissions.all_access = true;
    }
    const permissionFlags = {};
    Object.keys(permissions).forEach((key) => {
      permissionFlags[key] = permissions[key] === true || permissions[key] === 1 || permissions[key] === '1';
    });

    // 4. Attach to request
    req.user = {
      ...user,
      ...permissionFlags,
      role: effectiveRole,
      role_name: effectiveRole,
      is_super_admin: isSuperAdmin,
      permissions
    };
    console.log(`[Auth] User: ${user.full_name} (${user.id}), Role: ${effectiveRole}, Permissions Keys: ${Object.keys(permissions)}`);
    next();

  } catch (error) {
    console.error('Auth Middleware Error:', error);
    if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
      return res.status(401).json({ message: 'Invalid or expired token. Please login again.' });
    }
    return res.status(500).json({ message: 'Internal Server Error during Authentication' });
  }
};

module.exports = authMiddleware;
