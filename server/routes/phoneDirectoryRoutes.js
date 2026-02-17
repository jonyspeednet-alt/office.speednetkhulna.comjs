const express = require('express');
const router = express.Router();
const controller = require('../controllers/phoneDirectoryController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, controller.getPhones);
router.post('/', authMiddleware, controller.addPhone);
router.put('/:id', authMiddleware, controller.updatePhone);
router.delete('/:id', authMiddleware, controller.deletePhone);
router.get('/export', authMiddleware, controller.exportPhones);
router.get('/users', authMiddleware, controller.getUsersForDropdown);

module.exports = router;