/**
 * Middleware to check if user has a specific permission
 * @param {string} permission - The permission key to check
 */
const checkPermission = (permission) => {
  return (req, res, next) => {
    const { permissions, role_name } = req.user;

    // Super Admin has all access
    if (role_name && (role_name.toLowerCase() === 'super admin' || role_name.toLowerCase() === 'superadmin')) {
      return next();
    }

    // Check if permission exists and is true
    if (permissions && permissions[permission]) {
      return next();
    }

    // Special case for "all_access" permission in role JSONB
    if (permissions && permissions['all_access']) {
        return next();
    }

    return res.status(403).json({ 
      message: `Unauthorized: You do not have the required permission (${permission})` 
    });
  };
};

module.exports = checkPermission;
