const express = require('express');
const router = express.Router();
const adminDashboardController = require('../controllers/adminDashboardController');
const authMiddleware = require('../middleware/auth');

// Route: GET /api/dashboard/admin
router.get('/', authMiddleware, adminDashboardController.getAdminDashboardData);

module.exports = router;