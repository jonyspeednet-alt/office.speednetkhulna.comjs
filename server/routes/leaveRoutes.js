const express = require('express');
const router = express.Router();
const leaveController = require('../controllers/leaveController');
const authMiddleware = require('../middleware/auth'); // Your auth middleware

// Route: GET /api/leaves
router.get('/', authMiddleware, leaveController.getLeaveRequests);

// Route: PUT /api/leaves/:id/status
// Replaces the GET request logic from update_status.php
router.put('/:id/status', authMiddleware, leaveController.updateLeaveStatus);

module.exports = router;