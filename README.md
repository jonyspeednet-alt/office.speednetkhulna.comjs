# 🏢 Office Management System

A comprehensive PERN Stack (PostgreSQL, Express, React, Node.js) office management application for managing employees, leaves, approvals, and administrative tasks.

## 🚀 Features

- **Employee Management**: Add, edit, and manage employee records
- **Leave Management**: Submit, approve, and track leave requests
- **Calendar Integration**: View and manage organizational events
- **Role-Based Access Control**: Admin and user role permissions
- **Dashboard**: Admin and user-specific dashboards with analytics
- **Reports**: Generate and export various reports
- **Notice Board**: Post and manage organizational notices
- **Phone Directory**: Employee contact directory
- **Profile Management**: Update user profiles and settings

## 🛠️ Tech Stack

### Frontend
- **React 18** - UI library
- **React Router v7** - Routing
- **React Bootstrap** - UI components
- **Bootstrap 5** - CSS framework
- **Vite** - Build tool
- **Axios** - HTTP client
- **FullCalendar** - Calendar component
- **Recharts** - Charts and analytics

### Backend
- **Node.js v20** - Runtime
- **Express.js** - Web framework
- **PostgreSQL** - Database
- **JWT** - Authentication
- **Multer** - File uploads
- **bcrypt** - Password hashing

### DevOps
- **PM2** - Process manager
- **GitHub Actions** - CI/CD automation
- **Git** - Version control

## 📋 Prerequisites

- Node.js v20 or higher
- PostgreSQL database
- npm or yarn package manager
- Git

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/office-management-system.git
cd office-management-system
```

### 2. Setup Backend

```bash
cd server
npm install

# Create .env file
cp .env.example .env
# Edit .env with your database credentials
```

### 3. Setup Frontend

```bash
cd ../client
npm install
```

### 4. Database Setup

```sql
-- Create database
CREATE DATABASE office_db;

-- Import schema (if you have a SQL dump)
psql -U postgres -d office_db -f database_schema.sql
```

### 5. Run Development Servers

**Backend** (Terminal 1):
```bash
cd server
npm start
# Runs on http://localhost:5000
```

**Frontend** (Terminal 2):
```bash
cd client
npm run dev
# Runs on http://localhost:5173
```

### 6. Access Application

Open browser: `http://localhost:5173`

## 🔧 Environment Variables

Create `.env` file in `server/` directory:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=your_password
DB_NAME=office_db

# Server Configuration
PORT=5000
NODE_ENV=development

# JWT & Session
JWT_SECRET=your_jwt_secret_key_here
SESSION_SECRET=your_session_secret_key_here

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:5173
```

## 📦 Production Deployment

### Automated Deployment (Recommended)

This project supports automated deployment using GitHub Actions.

**Quick Setup:**
1. Read [QUICK_START.md](./QUICK_START.md) for step-by-step commands
2. See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed documentation

**Benefits:**
- ⚡ Automatic deployment on `git push`
- 🔄 No manual file uploads
- 📊 Deployment logs and monitoring
- 🔙 Easy rollback capability

### Manual Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for manual deployment instructions.

## 📁 Project Structure

```
office-management-system/
├── client/                      # Frontend React application
│   ├── src/
│   │   ├── components/         # Reusable components
│   │   ├── pages/              # Page components
│   │   ├── services/           # API service calls
│   │   ├── styles/             # CSS files
│   │   ├── App.jsx            # Root component
│   │   └── index.jsx          # Entry point
│   ├── public/                 # Static assets
│   ├── package.json
│   └── vite.config.js
│
├── server/                      # Backend Express application
│   ├── controllers/            # Route controllers
│   ├── middleware/             # Custom middleware
│   ├── routes/                 # API routes
│   ├── utilities/              # Helper functions
│   ├── index.js               # Server entry point
│   └── package.json
│
├── uploads/                     # User uploaded files
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions workflow
├── .gitignore
├── DEPLOYMENT.md               # Deployment guide
├── QUICK_START.md              # Quick deployment reference
└── README.md                   # This file
```

## 🔐 Security

- Passwords are hashed using bcrypt
- JWT tokens for authentication
- Session management with express-session
- CORS configured for specific origins
- Environment variables for sensitive data
- SQL injection prevention with parameterized queries

## 🧪 Testing

```bash
# Frontend tests
cd client
npm test

# Backend tests (if configured)
cd server
npm test
```

## 📝 Development Workflow

### Making Changes

```bash
# Create a new branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "feat: your feature description"

# Push to GitHub
git push origin feature/your-feature-name

# Create Pull Request on GitHub
```

### Deploying to Production

```bash
# Merge to main branch
git checkout main
git merge feature/your-feature-name
git push origin main

# GitHub Actions will automatically deploy! 🚀
```

## 🐛 Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:5000 | xargs kill -9
```

**Database connection error:**
- Check PostgreSQL is running
- Verify `.env` database credentials
- Ensure database exists

**Frontend not connecting to backend:**
- Check CORS settings in `server/index.js`
- Verify proxy configuration in `client/vite.config.js`

For more issues, see [DEPLOYMENT.md](./DEPLOYMENT.md) Troubleshooting section.

## 📚 Documentation

- [DEPLOYMENT.md](./DEPLOYMENT.md) - Complete deployment guide
- [QUICK_START.md](./QUICK_START.md) - Quick deployment commands
- [API Documentation](./API.md) - API endpoints (if available)

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

ISC License

## 👨‍💻 Author

**Mehedi Hasan**

## 🙏 Acknowledgments

- React Bootstrap for UI components
- FullCalendar for calendar functionality
- PostgreSQL for robust database
- PM2 for process management

---

**For deployment help, see [QUICK_START.md](./QUICK_START.md)**

**Made with ❤️ by Ahadix**
