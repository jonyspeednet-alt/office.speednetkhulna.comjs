const express = require('express');
const router = express.Router();
const { getRoles, saveRole, deleteRole, assignRoleToUser } = require('../controllers/roleController');
// const { authenticate } = require('../middleware/authMiddleware'); // Assuming this exists

router.get('/', getRoles);
router.post('/save', saveRole);
router.delete('/:id', deleteRole);
router.post('/assign', assignRoleToUser);

module.exports = router;
