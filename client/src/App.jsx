import React, { lazy, Suspense } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import PrivateRoute from './components/PrivateRoute';
import Layout from './components/Layout';

// Lazy load page imports
const Login = lazy(() => import('./pages/Login'));
const Dashboard = lazy(() => import('./pages/Dashboard'));
const AdminDashboard = lazy(() => import('./components/AdminDashboard'));
const Employees = lazy(() => import('./pages/Employees'));
const MyLeaves = lazy(() => import('./pages/MyLeaves'));
const ManageLeaves = lazy(() => import('./pages/ManageLeaves'));
const ManageEntitlements = lazy(() => import('./pages/ManageEntitlements'));
const ManageMenus = lazy(() => import('./pages/ManageMenus'));
const ManagePermissions = lazy(() => import('./pages/ManagePermissions'));
const Profile = lazy(() => import('./pages/Profile'));
const PhoneDirectory = lazy(() => import('./pages/PhoneDirectory'));
const LeaveReport = lazy(() => import('./pages/LeaveReport'));
const UserDashboard = lazy(() => import('./pages/UserDashboard'));
const ApprovalLetter = lazy(() => import('./pages/ApprovalLetter'));
const Logout = lazy(() => import('./components/Logout'));
const ApplyLeave = lazy(() => import('./components/ApplyLeave'));
const LeaveCalendar = lazy(() => import('./components/LeaveCalendar'));
const EditEmployee = lazy(() => import('./components/EditEmployee'));

// Loading spinner component
const LoadingSpinner = () => (
  <div className="d-flex justify-content-center align-items-center vh-100">
    <div className="spinner-border text-primary" role="status">
      <span className="visually-hidden">Loading...</span>
    </div>
  </div>
);

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
      <Suspense fallback={<LoadingSpinner />}>
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
              <Route path="/reports" element={<LeaveReport />} />
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
      </Suspense>
    </Router>
  );
}

export default App;