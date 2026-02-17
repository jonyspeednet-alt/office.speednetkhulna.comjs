import React, { useEffect, useMemo, useState, useCallback } from 'react';
import { getManagePermissionsData, updatePermission } from '../services/permissionService';
import { getRoles, saveRole, deleteRole, assignRoleToUser } from '../services/roleService';
import '../styles/AdminDashboard.css';
import '../styles/ManagePermissions.css';

const ManagePermissions = () => {
  const [loading, setLoading] = useState(true);
  const [users, setUsers] = useState([]);
  const [columns, setColumns] = useState([]);
  const [roles, setRoles] = useState([]);
  const [activePermissions, setActivePermissions] = useState({}); // User specific overrides
  const [activeTab, setActiveTab] = useState('roles'); // 'roles', 'users', 'overrides'
  const [search, setSearch] = useState('');
  const [message, setMessage] = useState(null);

  const permissionGroups = {
    'User Management': ['p_manage_users', 'p_manage_permissions', 'p_employees'],
    'Leave Management': ['p_manage_leaves', 'p_leave_submission', 'p_my_leaves', 'p_approvals', 'p_entitlements'],
    'System': ['p_manage_menus', 'p_reports', 'p_notices', 'p_calendar', 'p_phone_directory']
  };

  useEffect(() => {
    fetchInitialData();
  }, []);

  const fetchInitialData = async () => {
    try {
      setLoading(true);
      const [permData, rolesData] = await Promise.all([
        getManagePermissionsData(),
        getRoles()
      ]);
      
      setUsers(Array.isArray(permData.users) ? permData.users : []);
      setColumns(Array.isArray(permData.columns) ? permData.columns : []);
      setActivePermissions(permData.activePermissions || {});
      setRoles(rolesData || []);
    } catch (error) {
      setMessage({ type: 'danger', text: 'Failed to load data.' });
    } finally {
      setLoading(false);
    }
  };

  const handleRoleToggle = async (role, permissionKey) => {
    const updatedPermissions = { ...role.permissions };
    if (updatedPermissions[permissionKey]) {
      delete updatedPermissions[permissionKey];
    } else {
      updatedPermissions[permissionKey] = true;
    }

    try {
      const updatedRole = { ...role, permissions: updatedPermissions };
      await saveRole(updatedRole);
      setRoles(roles.map(r => r.id === role.id ? { ...r, permissions: updatedPermissions } : r));
    } catch (error) {
      setMessage({ type: 'danger', text: 'Failed to update role permission.' });
    }
  };

  const handleUserOverrideToggle = async (userId, column, currentValue) => {
    const newValue = currentValue ? 0 : 1;
    
    // Optimistic Update
    setActivePermissions(prev => ({
      ...prev,
      [userId]: {
        ...prev[userId],
        [column]: newValue === 1
      }
    }));

    try {
      await updatePermission(userId, column, newValue);
    } catch (error) {
      // Revert on error
      setActivePermissions(prev => ({
        ...prev,
        [userId]: {
          ...prev[userId],
          [column]: currentValue
        }
      }));
      setMessage({ type: 'danger', text: 'Failed to update user override.' });
    }
  };

  const handleAssignRole = async (userId, roleId) => {
    try {
      await assignRoleToUser(userId, roleId);
      setUsers(users.map(u => u.id === userId ? { ...u, role_id: roleId } : u));
      setMessage({ type: 'info', text: 'Role assigned successfully.' });
    } catch (error) {
      setMessage({ type: 'danger', text: 'Failed to assign role.' });
    }
  };

  const filteredUsers = useMemo(() =>
    users.filter(user =>
      user.full_name.toLowerCase().includes(search.toLowerCase()) ||
      user.employee_id.toLowerCase().includes(search.toLowerCase())
    ), [users, search]);

  const getColumnName = (colKey) => {
    const colObj = columns.find(c => c.permission_column === colKey);
    return colObj ? colObj.menu_name : colKey.replace('p_', '').replace(/_/g, ' ');
  };

  return (
    <div className="manage-permissions-page">
      <section className="mp-hero">
        <div>
          <span className="mp-chip">
            <i className="fas fa-shield-halved"></i>
            Hybrid RBAC Control
          </span>
          <h1>Access Management</h1>
          <p>Control system-wide roles or set specific individual user overrides.</p>
        </div>
        <div className="mp-metrics">
          <article><span>Roles</span><strong>{roles.length}</strong></article>
          <article><span>Users</span><strong>{users.length}</strong></article>
        </div>
      </section>

      <section className="mp-toolbar">
        <div className="d-flex flex-wrap gap-2">
            <button 
                className={`btn btn-sm ${activeTab === 'roles' ? 'btn-primary' : 'btn-light'}`}
                onClick={() => setActiveTab('roles')}
            >
                <i className="fas fa-user-shield me-2"></i>Global Roles
            </button>
            <button 
                className={`btn btn-sm ${activeTab === 'users' ? 'btn-primary' : 'btn-light'}`}
                onClick={() => setActiveTab('users')}
            >
                <i className="fas fa-users-gear me-2"></i>Role Assignments
            </button>
            <button 
                className={`btn btn-sm ${activeTab === 'overrides' ? 'btn-primary' : 'btn-light'}`}
                onClick={() => setActiveTab('overrides')}
            >
                <i className="fas fa-user-pen me-2"></i>Individual Overrides
            </button>
        </div>
        {(activeTab === 'users' || activeTab === 'overrides') && (
          <div className="mp-search">
            <i className="fas fa-search"></i>
            <input
              type="text"
              placeholder="Search users..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>
        )}
      </section>

      {message && (
        <section className={`mp-alert ${message.type === 'danger' ? 'danger' : 'info'} mt-3`}>
          <i className="fas fa-circle-info"></i>
          <span>{message.text}</span>
          <button className="ms-auto border-0 bg-transparent" onClick={() => setMessage(null)}>
            <i className="fas fa-times"></i>
          </button>
        </section>
      )}

      <div className="tab-content mt-4">
        {activeTab === 'roles' && (
          <div className="roles-section">
            {roles.map(role => (
              <div key={role.id} className="mp-table-card mb-4">
                <header>
                  <h2>{role.name} Permissions</h2>
                  <span className="badge bg-primary rounded-pill px-3">Role ID: {role.id}</span>
                </header>
                <div className="p-3">
                  {Object.entries(permissionGroups).map(([groupName, perms]) => (
                    <div key={groupName} className="mb-4">
                      <h6 className="text-muted text-uppercase small fw-bold mb-3">{groupName}</h6>
                      <div className="d-flex flex-wrap gap-2">
                        {perms.map(pKey => (
                          <div key={pKey} className="permission-toggle-item">
                            <label className="mp-switch">
                              <input
                                type="checkbox"
                                checked={!!role.permissions?.[pKey]}
                                onChange={() => handleRoleToggle(role, pKey)}
                              />
                              <span className="mp-slider"></span>
                            </label>
                            <span className="small">{getColumnName(pKey)}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            ))}
          </div>
        )}

        {activeTab === 'users' && (
          <section className="mp-table-card">
            <header>
              <h2>Assign Roles to Users</h2>
              <p>Quickly change roles for multiple employees.</p>
            </header>
            <div className="table-responsive">
              <table className="table align-middle mp-table">
                <thead>
                  <tr>
                    <th>Employee</th>
                    <th>Current Role</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map(user => (
                    <tr key={user.id}>
                      <td className="mp-user-col">
                        <strong>{user.full_name}</strong>
                        <small>{user.employee_id}</small>
                      </td>
                      <td>
                        <span className="badge bg-light text-dark border px-3 py-2">
                          {roles.find(r => r.id === user.role_id)?.name || 'Default'}
                        </span>
                      </td>
                      <td>
                        <select 
                          className="form-select form-select-sm"
                          style={{ width: '180px' }}
                          value={user.role_id || ''}
                          onChange={(e) => handleAssignRole(user.id, e.target.value)}
                        >
                          <option value="">Select Role</option>
                          {roles.map(r => (
                            <option key={r.id} value={r.id}>{r.name}</option>
                          ))}
                        </select>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        )}

        {activeTab === 'overrides' && (
          <section className="mp-table-card">
            <header>
              <h2>Individual Permission Overrides</h2>
              <p>Grant extra permissions to specific users regardless of their role.</p>
            </header>
            <div className="table-responsive">
              <table className="table align-middle mp-table override-table">
                <thead>
                  <tr>
                    <th className="sticky-col">Employee</th>
                    {columns.map(col => (
                      <th key={col.permission_column} className="text-center small px-2">
                        {getColumnName(col.permission_column)}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {filteredUsers.map(user => {
                    const userRole = roles.find(r => r.id === user.role_id);
                    return (
                      <tr key={user.id}>
                        <td className="mp-user-col sticky-col">
                          <strong>{user.full_name}</strong>
                          <span className="x-small text-muted">{userRole?.name || 'Staff'}</span>
                        </td>
                        {columns.map(col => {
                          const roleHasIt = !!userRole?.permissions?.[col.permission_column];
                          const userHasOverride = !!activePermissions[user.id]?.[col.permission_column];
                          const isActive = roleHasIt || userHasOverride;
                          
                          return (
                            <td key={col.permission_column} className="text-center">
                              <label className={`mp-switch ${roleHasIt ? 'role-inherited' : ''}`}>
                                <input
                                  type="checkbox"
                                  checked={isActive}
                                  disabled={roleHasIt} // Cannot toggle off inherited role permissions here
                                  onChange={() => handleUserOverrideToggle(user.id, col.permission_column, userHasOverride)}
                                />
                                <span className="mp-slider"></span>
                              </label>
                            </td>
                          );
                        })}
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </section>
        )}
      </div>
    </div>
  );
};

export default ManagePermissions;
