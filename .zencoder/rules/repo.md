---
description: Repository Information Overview
alwaysApply: true
---

# Office Management System Information

## Repository Summary
A comprehensive **PERN Stack** (PostgreSQL, Express, React, Node.js) office management application designed for managing employees, leave requests, approvals, and administrative tasks. It features a modern React frontend and a robust Express backend with PostgreSQL for data persistence.

## Repository Structure
The project is organized into two main subprojects:
- **client/**: Frontend React application built with Vite and Bootstrap.
- **server/**: Backend Express.js application providing RESTful API endpoints.
- **uploads/**: Storage for user-uploaded files and documents.
- **.github/workflows/**: CI/CD configurations for automated deployment.

### Main Repository Components
- **Client**: React-based UI with features like FullCalendar integration, Recharts for analytics, and role-based access control.
- **Server**: Express.js API handling authentication (JWT), employee management, and leave processing.
- **Deployment**: Automated via GitHub Actions, targeting a production server with PM2 process management.

## Projects

### Client (Frontend)
**Configuration File**: [`./client/package.json`](./client/package.json)

#### Language & Runtime
**Language**: JavaScript (React)  
**Version**: Node.js >= 14.0.0  
**Build System**: Vite  
**Package Manager**: npm

#### Dependencies
**Main Dependencies**:
- `react` (^18.2.0)
- `react-router-dom` (^6.18.0)
- `axios` (^1.6.2)
- `bootstrap` (^5.3.2)
- `@fullcalendar/react` (^6.1.10)
- `recharts` (^3.7.0)

**Development Dependencies**:
- `vite` (^5.4.21)
- `eslint` (^8.54.0)
- `vitest` (Used for testing)

#### Build & Installation
```bash
cd client
npm install
npm run dev   # Development server
npm run build # Production build
```

#### Testing
**Framework**: Vitest  
**Test Location**: Throughout `client/src` (typically matching file patterns)  
**Naming Convention**: `*.test.js` or `*.spec.js`  
**Run Command**:
```bash
cd client
npm test
```

### Server (Backend)
**Configuration File**: [`./server/package.json`](./server/package.json)

#### Language & Runtime
**Language**: JavaScript (Node.js)  
**Version**: Node.js v20 (Recommended)  
**Build System**: Node.js (Runtime)  
**Package Manager**: npm

#### Dependencies
**Main Dependencies**:
- `express` (^5.2.1)
- `pg` (^8.18.0) (PostgreSQL client)
- `jsonwebtoken` (^9.0.0)
- `bcrypt` (^6.0.0)
- `multer` (^2.0.2)
- `cors` (^2.8.5)

**Development Dependencies**:
- `nodemon` (^3.1.11)

#### Build & Installation
```bash
cd server
npm install
npm start # Starts with nodemon
```

#### Usage & Operations
**Main Entry Point**: [`./server/index.js`](./server/index.js)  
**Database Setup**: Requires a PostgreSQL database (`office_db`). Schema can be imported from `database_schema.sql` (if provided).

#### Deployment
**Strategy**: Automated via GitHub Actions ([`./.github/workflows/deploy.yml`](./.github/workflows/deploy.yml)).  
**Process Manager**: PM2 is used on the production server to manage the Node.js process.

#### Testing
**Framework**: Not explicitly configured (placeholder in `package.json`).  
**Run Command**:
```bash
cd server
npm test
```
