import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import PrivateRoute from './components/PrivateRoute';
import Layout from './components/Layout';

// Page imports
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import AdminDashboard from './components/AdminDashboard';
import Employees from './pages/Employees';
import MyLeaves from './pages/MyLeaves';
import ManageLeaves from './pages/ManageLeaves';
import ManageEntitlements from './pages/ManageEntitlements';
import ManageMenus from './pages/ManageMenus';
import ManagePermissions from './pages/ManagePermissions';
import Profile from './pages/Profile';
import PhoneDirectory from './pages/PhoneDirectory';
import LeaveReport from './pages/LeaveReport';
import UserDashboard from './pages/UserDashboard';
import ApprovalLetter from './pages/ApprovalLetter';
import Logout from './components/Logout';

import ApplyLeave from './components/ApplyLeave';
import LeaveCalendar from './components/LeaveCalendar';
import EditEmployee from './components/EditEmployee';

// Placeholder for unmigrated pages
const UnderConstruction = () => (
  <div className="d-flex flex-column justify-content-center align-items-center vh-100">
    <h2 className="text-warning"><i className="fas fa-tools me-2"></i>Under Construction</h2>
    <p className="text-muted">This page is currently being migrated to React.</p>
    <a href="/" className="btn btn-primary mt-3">Back to Dashboard</a>
  </div>
);

function App() {
  return (
    <Router future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/logout" element={<Logout />} />
        
        {/* Protected Routes */}
        <Route element={<PrivateRoute />}>
          <Route element={<Layout />}>
            <Route path="/" element={<Dashboard />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="/admin-dashboard" element={<AdminDashboard />} />
            <Route path="/employees" element={<Employees />} />
            <Route path="/edit-employee/:id" element={<EditEmployee />} />
            <Route path="/my-leaves" element={<MyLeaves />} />
            <Route path="/manage-leaves" element={<ManageLeaves />} />
            <Route path="/manage-entitlements" element={<ManageEntitlements />} />
            <Route path="/manage-menus" element={<ManageMenus />} />
            <Route path="/manage-permissions" element={<ManagePermissions />} />
            <Route path="/profile" element={<Profile />} />
            <Route path="/profile/:id" element={<Profile />} />
            <Route path="/phone-directory" element={<PhoneDirectory />} />
            <Route path="/leave-report" element={<LeaveReport />} />
            <Route path="/user-dashboard" element={<UserDashboard />} />
            <Route path="/approval/:id" element={<ApprovalLetter />} />
            
            {/* Newly Added Routes from DB */}
            <Route path="/apply-leave" element={<ApplyLeave />} />
            <Route path="/leave-calendar" element={<LeaveCalendar />} />
            
            {/* Placeholder routes for unmigrated pages */}
            <Route path="/reseller-status-noc" element={<UnderConstruction />} />
            <Route path="/reseller-list" element={<UnderConstruction />} />
            <Route path="/tasks-engineer" element={<UnderConstruction />} />
            <Route path="/billing-logs" element={<UnderConstruction />} />
            <Route path="/create-po" element={<UnderConstruction />} />
            <Route path="/view-pos" element={<UnderConstruction />} />
          </Route>
        </Route>

        {/* Catch-all Route (404 Not Found) */}
        <Route path="*" element={
          <div className="d-flex flex-column justify-content-center align-items-center vh-100">
            <h1 className="display-1 fw-bold text-primary">404</h1>
            <p className="lead">Page Not Found</p>
            <a href="/" className="btn btn-primary mt-3">Go Home</a>
          </div>
        } />
      </Routes>
    </Router>
  );
}

export default App;
