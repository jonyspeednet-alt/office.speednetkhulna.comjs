import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { logoutUser } from '../services/authService';

const Logout = () => {
  const navigate = useNavigate();

  useEffect(() => {
    const performLogout = async () => {
      await logoutUser();
      // Redirect to login page after cleanup
      navigate('/login', { replace: true });
    };
    
    performLogout();
  }, [navigate]);

  return (
    <div className="d-flex justify-content-center align-items-center vh-100">
      <div className="spinner-border text-primary" role="status">
        <span className="visually-hidden">Logging out...</span>
      </div>
    </div>
  );
};

export default Logout;