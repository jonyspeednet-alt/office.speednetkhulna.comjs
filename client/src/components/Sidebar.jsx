import React, { useEffect, useState, useRef, useMemo } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { getSidebarMenus } from '../services/sidebarService';
import ImageWithFallback from './ImageWithFallback';
import '../styles/Sidebar.css';

const Sidebar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isCollapsed, setIsCollapsed] = useState(() => {
    return localStorage.getItem('sidebarCollapsed') === 'true';
  });
  const [isDarkMode, setIsDarkMode] = useState(() => {
    return localStorage.getItem('darkMode') === 'true';
  });
  const [searchQuery, setSearchQuery] = useState('');
  const [openSubMenus, setOpenSubMenus] = useState({});
  const [showSearch, setShowSearch] = useState(false);
  const searchRef = useRef(null);
  const location = useLocation();

  const [notificationCount] = useState(3);

  // Use React Query for sidebar menus - Add userId to queryKey to prevent cache leakage between users
  const { data: sidebarData } = useQuery({
    queryKey: ['sidebarMenus', user?.id],
    queryFn: getSidebarMenus,
    staleTime: 1000 * 60 * 30, // 30 minutes
    enabled: !!user?.id, // Only run query if we have a user ID
  });

  const menuData = sidebarData?.menuData || {};
  const userRole = sidebarData?.role || '';

  // Get user from localStorage
  const user = useMemo(() => {
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      try {
        const parsedUser = JSON.parse(storedUser);
        return {
          name: parsedUser.full_name || 'User',
          role: parsedUser.role || 'Staff'
        };
      } catch (e) {
        console.error('Error parsing user data', e);
      }
    }
    return { name: 'User', role: 'Staff' };
  }, []);

  // Apply theme on mount and change
  useEffect(() => {
    document.body.setAttribute('data-theme', isDarkMode ? 'dark' : 'light');
    localStorage.setItem('darkMode', isDarkMode);
  }, [isDarkMode]);

  // Apply collapsed state
  useEffect(() => {
    localStorage.setItem('sidebarCollapsed', isCollapsed);
  }, [isCollapsed]);

  // Focus search input when shown
  useEffect(() => {
    if (showSearch && searchRef.current) {
      searchRef.current.focus();
    }
  }, [showSearch]);

  const isActive = (path) => {
    if (!path) return false;
    const currentPath = location.pathname;
    const targetPath = getCleanLink(path);
    return currentPath === targetPath || (targetPath !== '/' && currentPath.startsWith(targetPath));
  };

  const getCleanLink = (link) => {
    if (!link) return '#!';
    if (link.startsWith('http')) return link;
    
    // Ensure leading slash and remove .php
    let cleanPath = link.trim().replace(/\.php$/, '');
    
    // If it's a full path from DB like 'reseller_mgnt/list', take only the last part or keep as is?
    // Since we updated DB to /reseller-list, we should just ensure it starts with /
    if (!cleanPath.startsWith('/')) {
      cleanPath = '/' + cleanPath;
    }
    
    // Replace underscores with hyphens for React consistency
    cleanPath = cleanPath.replace(/_/g, '-');
    
    // Special case for dashboard
    if (cleanPath === '/dashboard' || cleanPath === '/index' || cleanPath === '/') return '/dashboard';
    
    return cleanPath;
  };

  const toggleSidebar = () => setIsOpen(!isOpen);

  const toggleCollapse = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsCollapsed(!isCollapsed);
  };

  const toggleTheme = (e) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDarkMode(!isDarkMode);
  };

  const toggleSubMenu = (id) => {
    setOpenSubMenus(prev => ({ ...prev, [id]: !prev[id] }));
  };

  const toggleSearch = () => {
    setShowSearch(!showSearch);
    if (!showSearch) {
      setTimeout(() => searchRef.current?.focus(), 100);
    }
  };

  // Filter menus based on search query
  const filterMenus = (menus, query) => {
    if (!query) return menus;
    const filtered = {};
    Object.keys(menus).forEach(category => {
      const categoryMenus = menus[category].filter(menu => 
        menu.menu_name.toLowerCase().includes(query.toLowerCase()) ||
        (menu.children && menu.children.some(child => 
          child.menu_name.toLowerCase().includes(query.toLowerCase())
        ))
      );
      if (categoryMenus.length > 0) {
        filtered[category] = categoryMenus;
      }
    });
    return filtered;
  };

  const filteredMenuData = filterMenus(menuData, searchQuery);

  const renderSideLink = (item, isSub = false) => {
    const hasChildren = item.children && item.children.length > 0;
    const isChildActive = hasChildren && item.children.some(child => isActive(child.link));
    const isMenuOpen = openSubMenus[item.id] || isChildActive;

    if (hasChildren) {
      return (
        <React.Fragment key={item.id}>
          <a 
            href="#!" 
            className={`side-link d-flex justify-content-between align-items-center ${isChildActive ? 'active' : ''} ${isCollapsed ? 'collapsed-link' : ''}`}
            onClick={(e) => { e.preventDefault(); toggleSubMenu(item.id); }}
            title={isCollapsed ? item.menu_name : undefined}
          >
            <span>
              <i className={`fa-solid ${item.icon}`}></i> 
              {!isCollapsed && <span>{item.menu_name}</span>}
            </span>
            {!isCollapsed && (
              <i className={`fa-solid fa-chevron-${isMenuOpen ? 'up' : 'down'}`} style={{ fontSize: '10px', opacity: 0.5 }}></i>
            )}
          </a>
          {!isCollapsed && (
            <div className={`collapse-wrapper ${isMenuOpen ? 'show' : ''}`} style={{ 
              maxHeight: isMenuOpen ? '500px' : '0', 
              overflow: 'hidden', 
              transition: 'max-height 0.4s ease-in-out' 
            }}>
              <div className="sub-menu-container">
                {item.children.map(child => (
                  <Link 
                    key={child.id} 
                    to={getCleanLink(child.link)} 
                    className={`side-link sub-link ${isActive(child.link) ? 'active' : ''}`}
                  >
                    <i className={`fa-solid ${child.icon}`} style={{ fontSize: '10px' }}></i> 
                    {child.menu_name}
                  </Link>
                ))}
              </div>
            </div>
          )}
        </React.Fragment>
      );
    }

    return (
      <Link 
        key={item.id}
        to={getCleanLink(item.link)} 
        className={`side-link ${isActive(item.link) ? 'active' : ''} ${isCollapsed ? 'collapsed-link' : ''} ${isSub ? 'sub-link' : ''}`}
        title={isCollapsed ? item.menu_name : undefined}
      >
        <i className={`fa-solid ${item.icon}`}></i>
        {!isCollapsed && <span>{item.menu_name}</span>}
      </Link>
    );
  };

  return (
    <>
      {/* Mobile Toggle Button */}
      <button className="mobile-toggle" onClick={toggleSidebar}>
        <i className="fa-solid fa-bars"></i>
      </button>

      {/* Overlay */}
      <div 
        className={`sidebar-overlay ${isOpen ? 'active' : ''}`} 
        onClick={toggleSidebar}
      ></div>

      {/* Sidebar Container */}
      <div 
        className={`sidebar ${isOpen ? 'active' : ''} ${isCollapsed ? 'collapsed' : ''} ${isDarkMode ? 'dark-mode' : ''}`} 
        id="sidebar"
      >
        {/* Collapse Toggle Button */}
        <button className="collapse-toggle" onClick={toggleCollapse} title={isCollapsed ? 'Expand' : 'Collapse'}>
          <i className={`fa-solid fa-chevron-${isCollapsed ? 'right' : 'left'}`}></i>
        </button>

        {/* Brand */}
        <div className="sidebar-brand">
          <ImageWithFallback 
            src="https://speednetkhulna.com/assets/img/logo-b.png" 
            className="brand-logo" 
            alt="Speed Net" 
            type="other"
          />
          {!isCollapsed && (
            <div className="role-badge">
              {userRole || 'Speed Net'} Portal
            </div>
          )}
        </div>

        {/* User Profile Section */}
        {!isCollapsed && (
          <div className="user-profile-section">
            <div className="user-avatar-container">
              <ImageWithFallback 
                src={null} 
                fallbackName={user.name}
                className="user-avatar" 
                alt={user.name}
                width="40px"
                height="40px"
              />
              <span className="status-indicator online"></span>
            </div>
            <div className="user-info">
              <p className="user-name">{user.name}</p>
              <p className="user-role">{user.role}</p>
            </div>
          </div>
        )}

        {/* Search Bar */}
        <div className={`search-container ${isCollapsed ? 'collapsed' : ''}`}>
          {isCollapsed ? (
            <button className="quick-action-btn" onClick={toggleSearch} title="Search">
              <i className="fa-solid fa-magnifying-glass"></i>
            </button>
          ) : (
            <div className="search-input-wrapper">
              <i className="fa-solid fa-magnifying-glass search-icon"></i>
              <input
                ref={searchRef}
                type="text"
                className="search-input"
                placeholder="Search menus..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
              {searchQuery && (
                <button className="search-clear-btn" onClick={() => setSearchQuery('')}>
                  <i className="fa-solid fa-times"></i>
                </button>
              )}
            </div>
          )}
        </div>

        {/* Navigation */}
        <div className="nav-menu">
          {!isCollapsed && searchQuery && (
            <div className="search-results-info" style={{ fontSize: '12px', color: 'var(--side-text)', padding: '0 12px 10px', opacity: 0.7 }}>
              {Object.keys(filteredMenuData).length > 0 
                ? `Found results for "${searchQuery}"`
                : `No results for "${searchQuery}"`
              }
            </div>
          )}

          <Link 
            to="/dashboard" 
            className={`side-link ${isActive('dashboard') ? 'active' : ''} ${isCollapsed ? 'collapsed-link' : ''}`}
            title="Dashboard"
          >
            <i className="fa-solid fa-chart-pie"></i>
            {!isCollapsed && <span>ড্যাশবোর্ড</span>}
          </Link>

          {Object.keys((isCollapsed ? menuData : filteredMenuData) || {}).map((category) => (
            <div key={category}>
              {!isCollapsed && <div className="nav-label">{category}</div>}
              {(isCollapsed ? menuData[category] : filteredMenuData[category]).map((menu) => renderSideLink(menu))}
            </div>
          ))}

          {!isCollapsed && <div className="nav-label">Account</div>}
          <Link 
            to="/profile" 
            className={`side-link ${isActive('profile') ? 'active' : ''} ${isCollapsed ? 'collapsed-link' : ''}`}
            title={isCollapsed ? 'Profile' : undefined}
          >
            <i className="fa-solid fa-user-astronaut"></i>
            {!isCollapsed && <span>Profile</span>}
          </Link>
          <Link 
            to="/logout" 
            className={`side-link text-danger ${isCollapsed ? 'collapsed-link' : ''}`}
            title={isCollapsed ? 'Logout' : undefined}
          >
            <i className="fa-solid fa-power-off"></i>
            {!isCollapsed && <span>Logout</span>}
          </Link>
        </div>

        {/* Quick Actions */}
        <div className="quick-actions">
          <button className="quick-action-btn" title="Notifications">
            <i className="fa-solid fa-bell"></i>
            {notificationCount > 0 && <span className="notification-badge">{notificationCount}</span>}
          </button>
          <button className="quick-action-btn" title="Theme Toggle" onClick={toggleTheme}>
            <i className={`fa-solid fa-${isDarkMode ? 'sun' : 'moon'}`}></i>
          </button>
          {!isCollapsed && (
            <button className="quick-action-btn" title="Settings">
              <i className="fa-solid fa-cog"></i>
            </button>
          )}
        </div>

        {/* Sidebar Footer */}
        {!isCollapsed && (
          <div className="sidebar-footer">
            <p className="footer-text">© 2024 Speed Net Khulna</p>
          </div>
        )}
      </div>
    </>
  );
};

export default Sidebar;
