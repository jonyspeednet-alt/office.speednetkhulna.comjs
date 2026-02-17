const express = require('express');
const router = express.Router();
const approvalController = require('../controllers/approvalController');
const authMiddleware = require('../middleware/auth');

// Route: GET /api/approval/:id
router.get('/:id', authMiddleware, approvalController.getApprovalData);

module.exports = router;