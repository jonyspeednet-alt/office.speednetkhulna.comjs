import React from 'react';
import { Outlet } from 'react-router-dom';
import Sidebar from './Sidebar';
import '../styles/AdminDashboard.css'; // This contains the wrapper styles

const Layout = () => {
  return (
    <div className="admin-wrapper">
      <Sidebar />
      <main className="main-content admin-dashboard-page">
        <Outlet />
      </main>
    </div>
  );
};

export default Layout;
