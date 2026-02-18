// PERN Stack Express API Server
const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const cors = require('cors');
const compression = require('compression');
const path = require('path');
const fs = require('fs');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

const db = require('./utilities/db');

const app = express();
const PORT = process.env.PORT || 5000;
const authSecretConfigured = Boolean(process.env.JWT_SECRET || process.env.SESSION_SECRET);

if (!authSecretConfigured) {
    console.warn('⚠️  JWT_SECRET/SESSION_SECRET is missing. Login/auth will fail until one is configured.');
}

// ============================================
// MIDDLEWARE SETUP
// ============================================

// Enable Gzip compression
app.use(compression());

// CORS Configuration - Allow React frontend
const allowedOrigins = [
    'http://localhost:3000',
    'http://localhost:5173',
    'http://localhost:5174',
    'http://127.0.0.1:5173',
    'http://127.0.0.1:5174',
    process.env.FRONTEND_URL
].filter(Boolean);

app.use(cors({
    origin: (origin, callback) => {
        if (!origin || allowedOrigins.includes(origin)) {
            return callback(null, true);
        }
        return callback(new Error('CORS blocked for this origin'));
    },
    credentials: true
}));

app.use(cookieParser());
// Body Parser Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Serve Static Files (Uploads)
app.use('/uploads', express.static(path.join(__dirname, '../uploads'), {
    maxAge: '1d',
    etag: true
}));

// Simple Request Logger
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

// Session Setup (for JWT token management)
app.use(session({
    secret: process.env.SESSION_SECRET || 'speednet_secret_key_123',
    resave: false,
    saveUninitialized: true,
    cookie: { 
        secure: false,
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000
    }
}));

// API Cache Control
app.use('/api', (req, res, next) => {
    res.set('Cache-Control', 'no-store');
    next();
});

// ============================================
// API ROUTES
// ============================================

// Import API routes
// ফাইলের নাম অনুযায়ী সঠিক ইম্পোর্ট
const authRoutes = require('./routes/auth'); 
const adminDashboardRoutes = require('./routes/adminDashboardRoutes');
const userDashboardRoutes = require('./routes/userDashboardRoutes');
const sidebarRoutes = require('./routes/sidebarRoutes');
const menuRoutes = require('./routes/menuRoutes');
const employeeRoutes = require('./routes/employeeRoutes');
const profileRoutes = require('./routes/profileRoutes');
const leaveRoutes = require('./routes/leaveRoutes');
const leaveSubmissionRoutes = require('./routes/leaveSubmissionRoutes');
const myLeavesRoutes = require('./routes/myLeavesRoutes');
const approvalRoutes = require('./routes/approvalRoutes');
const calendarRoutes = require('./routes/calendarRoutes');
const entitlementRoutes = require('./routes/entitlementRoutes');
const permissionRoutes = require('./routes/permissionRoutes');
const phoneDirectoryRoutes = require('./routes/phoneDirectoryRoutes');
const reportRoutes = require('./routes/reportRoutes');
const noticeRoutes = require('./routes/noticeRoutes');
const roleRoutes = require('./routes/roleRoutes');

// Mount API routes with /api prefix
app.use('/api/auth', authRoutes);
app.use('/api/dashboard/admin', adminDashboardRoutes);
app.use('/api/dashboard', userDashboardRoutes);
app.use('/api/sidebar', sidebarRoutes);
app.use('/api/admin/menus', menuRoutes);
app.use('/api/employees', employeeRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/leaves', leaveRoutes);
app.use('/api/leaves', leaveSubmissionRoutes);
app.use('/api/my-leaves', myLeavesRoutes);
app.use('/api/approvals', approvalRoutes);
app.use('/api/calendar', calendarRoutes);
app.use('/api/entitlements', entitlementRoutes);
app.use('/api/permissions', permissionRoutes);
app.use('/api/phone-directory', phoneDirectoryRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/notices', noticeRoutes);
app.use('/api/roles', roleRoutes);

// Serve frontend bundle when available (same-domain deployment).
const frontendDistPath = path.resolve(__dirname, '../client/dist');
const frontendIndexPath = path.join(frontendDistPath, 'index.html');

// Serve static files if directory exists
if (fs.existsSync(frontendDistPath)) {
    app.use(express.static(frontendDistPath));
}

// Handle all non-API routes by serving the frontend or providing a clear error
app.get(/^\/(?!api\/).*/, (req, res, next) => {
    if (fs.existsSync(frontendIndexPath)) {
        res.sendFile(frontendIndexPath, (err) => {
            if (err) next(err);
        });
    } else {
        // If it's just the root path, we can provide a more friendly message
        if (req.path === '/') {
            return res.status(200).json({
                status: 'OK',
                message: 'Speednet Office Management API is running',
                frontend: 'Frontend bundle not found. Please run "npm run build" in the client directory to serve the UI.',
                check_path: frontendIndexPath,
                health_check: '/api/health'
            });
        }
        
        // For other paths, return 404 with a helpful message
        res.status(404).json({ 
            error: 'Not Found',
            message: 'The requested endpoint does not exist',
            path: req.path,
            frontend_status: 'Missing client/dist/index.html'
        });
    }
});

// ============================================
// HEALTH CHECK ENDPOINT
// ============================================

app.get('/api/health', async (req, res) => {
    try {
        await db.query('SELECT 1');
        const usersTableCheck = await db.query(
            "SELECT to_regclass('public.users') AS users_table"
        );
        const hasUsersTable = Boolean(usersTableCheck.rows[0]?.users_table);
        let usersCount = null;

        if (hasUsersTable) {
            const userCountResult = await db.query('SELECT COUNT(*) FROM users');
            usersCount = userCountResult.rows[0].count;
        }

        res.json({ 
            status: 'OK',
            message: 'Server is running',
            database: 'Connected',
            users_table_exists: hasUsersTable,
            users_count: usersCount,
            timestamp: new Date().toISOString()
        });
    } catch (err) {
        res.status(500).json({ 
            status: 'Error',
            message: 'Server is running but database is not reachable',
            error: err.message,
            code: err.code || null,
            detail: err.detail || null,
            timestamp: new Date().toISOString()
        });
    }
});

// ============================================
// ERROR HANDLING - 404
// ============================================

app.use((req, res) => {
    res.status(404).json({ 
        error: 'Not Found',
        message: 'The requested endpoint does not exist',
        path: req.path
    });
});

// ============================================
// ERROR HANDLING - Global Error Handler
// ============================================

app.use((err, req, res, next) => {
    console.error('Server Error:', err);
    res.status(err.status || 500).json({ 
        error: 'Internal Server Error',
        message: err.message || 'Something went wrong'
    });
});

// ============================================
// SERVER START
// ============================================

process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`\n✅ Express API Server running on http://localhost:${PORT}`);
    console.log(`📊 Health Check: http://localhost:${PORT}/api/health`);
    console.log(`⚛️  React Frontend: http://localhost:5173`);
    console.log(`\n🔗 CORS enabled for localhost:3000, localhost:5173\n`);
});
