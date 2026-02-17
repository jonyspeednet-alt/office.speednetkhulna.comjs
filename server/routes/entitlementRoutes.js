const express = require('express');
const router = express.Router();
const entitlementController = require('../controllers/entitlementController');
const authMiddleware = require('../middleware/auth');

router.get('/', authMiddleware, entitlementController.getEntitlementsData);
router.post('/', authMiddleware, entitlementController.addEntitlement);
router.put('/:id', authMiddleware, entitlementController.updateEntitlement);
router.delete('/:id', authMiddleware, entitlementController.deleteEntitlement);

module.exports = router;