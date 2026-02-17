const express = require('express');
const router = express.Router();
const permissionController = require('../controllers/permissionController');
const authMiddleware = require('../middleware/auth'); // Your auth middleware

// Route: POST /api/permissions/update
router.post('/update', authMiddleware, permissionController.updatePermission);

// Route: GET /api/permissions/manage
router.get('/manage', authMiddleware, permissionController.getManagePermissionsData);

module.exports = router;