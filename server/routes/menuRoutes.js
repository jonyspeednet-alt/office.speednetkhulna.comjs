const express = require('express');
const router = express.Router();
const menuController = require('../controllers/menuController');
const authMiddleware = require('../middleware/auth');

// Middleware to check for Super Admin role
const superAdminCheck = (req, res, next) => {
  if (req.user && req.user.role && req.user.role.toLowerCase() === 'super admin') {
    next();
  } else {
    res.status(403).json({ message: 'Access Denied: Super Admin only' });
  }
};

router.get('/', authMiddleware, superAdminCheck, menuController.getMenus);
router.post('/', authMiddleware, superAdminCheck, menuController.saveMenu);
router.post('/order', authMiddleware, superAdminCheck, menuController.updateMenuOrder);
router.delete('/:id', authMiddleware, superAdminCheck, menuController.deleteMenu);

module.exports = router;