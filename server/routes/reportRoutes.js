const express = require('express');
const router = express.Router();
const reportController = require('../controllers/reportController');
const authMiddleware = require('../middleware/auth');

// Route: GET /api/reports/leave-summary
router.get('/leave-summary', authMiddleware, reportController.getLeaveSummaryReport);

module.exports = router;