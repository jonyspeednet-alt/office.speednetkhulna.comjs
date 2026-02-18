import React, { useMemo, useState } from 'react';
import { Link } from 'react-router-dom';
import { Modal } from 'react-bootstrap';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import Swal from 'sweetalert2';
import ImageWithFallback from '../components/ImageWithFallback';
import { getEmployees, getDepartments, getNextEmployeeId, addEmployee } from '../services/employeeService';
import '../styles/AdminDashboard.css';
import '../styles/Employees.css';

const Employees = () => {
  const queryClient = useQueryClient();
  const [filters, setFilters] = useState({ search: '', dept: '' });
  
  // Debounce search
  const [debouncedSearch, setDebouncedSearch] = useState(filters.search);
  React.useEffect(() => {
    const handler = setTimeout(() => setDebouncedSearch(filters.search), 400);
    return () => clearTimeout(handler);
  }, [filters.search]);

  const [showModal, setShowModal] = useState(false);
  const [generatedId, setGeneratedId] = useState('Generating...');
  const [formData, setFormData] = useState({
    role: 'Staff',
    blood_group: '',
    emergency_phone: '',
    present_address: '',
    permanent_address: '',
    nid_number: ''
  });

  // Fetch departments
  const { data: departments = [] } = useQuery({
    queryKey: ['departments'],
    queryFn: getDepartments,
  });

  // Fetch employees with filters
  const { data: employees = [], isLoading: loading } = useQuery({
    queryKey: ['employees', debouncedSearch, filters.dept],
    queryFn: () => getEmployees({ search: debouncedSearch, dept: filters.dept }),
    placeholderData: (previousData) => previousData,
  });

  // Add employee mutation
  const addMutation = useMutation({
    mutationFn: addEmployee,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['employees'] });
      setShowModal(false);
      Swal.fire('Success', 'Employee added successfully!', 'success');
    },
    onError: (error) => {
      Swal.fire('Error', error.response?.data?.message || 'Failed to add employee.', 'error');
    }
  });

  const stats = useMemo(() => {
    const active = employees.filter((emp) => String(emp.status || 'Active').toLowerCase() === 'active').length;
    return {
      total: employees.length,
      active,
      inactive: Math.max(employees.length - active, 0)
    };
  }, [employees]);

  const handleFilterChange = (event) => {
    setFilters((prev) => ({ ...prev, [event.target.name]: event.target.value }));
  };

  const handleReset = () => {
    setFilters({ search: '', dept: '' });
  };

  const openAddModal = async () => {
    setShowModal(true);
    setGeneratedId('Generating...');
    try {
      const nextId = await getNextEmployeeId();
      setGeneratedId(nextId);
      setFormData((prev) => ({
        ...prev,
        employee_id: nextId,
        role: 'Staff',
        joining_date: new Date().toISOString().split('T')[0]
      }));
    } catch (error) {
      setGeneratedId('Error');
    }
  };

  const handleInputChange = (event) => {
    setFormData((prev) => ({ ...prev, [event.target.name]: event.target.value }));
  };

  const handleFileChange = (event) => {
    setFormData((prev) => ({ ...prev, [event.target.name]: event.target.files[0] }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const payload = new FormData();
    Object.keys(formData).forEach((key) => {
      if (formData[key] !== undefined && formData[key] !== null) {
        payload.append(key, formData[key]);
      }
    });
    addMutation.mutate(payload);
  };

  return (
    <>
      <section className="emp-hero">
          <div>
            <span className="emp-chip">
              <i className="fas fa-users-cog"></i>
              Human Resources
            </span>
            <h1>Employee Directory</h1>
            <p>Manage employee records, office profiles, and HR data from one dashboard.</p>
          </div>
          <div className="emp-hero-side">
            <div className="emp-metrics">
              <article>
                <span>Total</span>
                <strong>{stats.total}</strong>
              </article>
              <article>
                <span>Active</span>
                <strong>{stats.active}</strong>
              </article>
              <article>
                <span>Inactive</span>
                <strong>{stats.inactive}</strong>
              </article>
            </div>
            <button className="emp-add-btn" onClick={openAddModal}>
              <i className="fas fa-user-plus"></i>
              Add Employee
            </button>
          </div>
        </section>

        <section className="emp-filter-card">
          <form onSubmit={(e) => e.preventDefault()} className="emp-filter-form">
            <div className="emp-input with-icon">
              <i className="fas fa-search"></i>
              <input
                type="text"
                name="search"
                placeholder="Search by employee name or ID"
                value={filters.search}
                onChange={handleFilterChange}
              />
              {filters.search && (
                <button type="button" className="clear-btn" onClick={() => setFilters((prev) => ({ ...prev, search: '' }))}>
                  <i className="fas fa-times"></i>
                </button>
              )}
            </div>

            <select name="dept" value={filters.dept} onChange={handleFilterChange}>
              <option value="">All Departments</option>
              {departments.map((dept) => (
                <option key={dept.id} value={dept.dept_name}>
                  {dept.dept_name}
                </option>
              ))}
            </select>

            <button type="button" className="emp-btn secondary" onClick={handleReset}>
              <i className="fas fa-rotate"></i>
              Reset
            </button>
          </form>
        </section>

        <section className="emp-table-card">
          <header>
            <h2>Employee List</h2>
            <p>{loading ? 'Loading records...' : `${employees.length} employee(s) found`}</p>
          </header>

          <div className="table-responsive">
            <table className="table align-middle mb-0 emp-table">
              <thead>
                <tr>
                  <th>Member Details</th>
                  <th>Contact</th>
                  <th>Office Info</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan="5" className="text-center py-5">
                      <div className="spinner-border text-primary" role="status"></div>
                    </td>
                  </tr>
                )}

                {!loading && employees.length === 0 && (
                  <tr>
                    <td colSpan="5" className="text-center py-5 text-muted">
                      No employees found.
                    </td>
                  </tr>
                )}

                {!loading &&
                  employees.map((user) => (
                    <tr key={user.id}>
                      <td>
                        <Link to={`/profile/${user.id}`} className="text-decoration-none emp-user-cell">
                          <ImageWithFallback
                            src={user.profile_pic && user.profile_pic !== 'default.png' ? `/uploads/${user.profile_pic}` : null}
                            fallbackName={user.full_name}
                            className="emp-avatar"
                            alt="Profile"
                            width="44px"
                            height="44px"
                          />
                          <div>
                            <strong>{user.full_name}</strong>
                            <small>{user.designation || 'Position N/A'}</small>
                            <span>ID: {user.employee_id}</span>
                          </div>
                        </Link>
                      </td>
                      <td>
                        <div className="emp-contact">
                          <div>
                            <i className="fas fa-phone"></i>
                            {user.phone || 'N/A'}
                          </div>
                          <div>
                            <i className="fas fa-droplet"></i>
                            Blood: {user.blood_group || 'Unknown'}
                          </div>
                        </div>
                      </td>
                      <td>
                        <div className="emp-office">
                          <strong>{user.department || 'General'}</strong>
                          <span>{user.role || 'Staff'}</span>
                        </div>
                      </td>
                      <td>
                        <span className={`emp-status ${String(user.status || 'Active').toLowerCase() === 'active' ? 'active' : 'inactive'}`}>
                          {user.status || 'Active'}
                        </span>
                      </td>
                      <td>
                        <div className="emp-actions">
                          <Link title="View Profile" to={`/profile/${user.id}`}>
                            <i className="fas fa-eye"></i>
                          </Link>
                          <Link title="Edit Employee" to={`/edit-employee/${user.id}`} className="edit">
                            <i className="fas fa-user-edit"></i>
                          </Link>
                        </div>
                      </td>
                    </tr>
                  ))}
              </tbody>
            </table>
          </div>
        </section>

        <Modal show={showModal} onHide={() => setShowModal(false)} size="lg" centered className="emp-modal">
          <Modal.Header closeButton className="border-0 pt-4 px-4 bg-white rounded-top-4">
            <Modal.Title className="fw-bold">
              <i className="fas fa-user-plus text-primary me-2"></i>
              Add New Employee
            </Modal.Title>
          </Modal.Header>
          <Modal.Body className="p-4 bg-white rounded-bottom-4">
            <form onSubmit={handleSubmit}>
              <div className="row g-3">
                <div className="col-12">
                  <div className="emp-form-section">Basic Information</div>
                </div>

                <div className="col-md-4">
                  <label className="emp-form-label">Employee ID</label>
                  <input type="text" name="employee_id" className="emp-form-input bg-light fw-bold text-primary" value={generatedId} readOnly />
                </div>
                <div className="col-md-8">
                  <label className="emp-form-label">Full Name</label>
                  <input type="text" name="full_name" className="emp-form-input" onChange={handleInputChange} required />
                </div>
                <div className="col-md-6">
                  <label className="emp-form-label">Email</label>
                  <input type="email" name="email" className="emp-form-input" onChange={handleInputChange} />
                </div>
                <div className="col-md-6">
                  <label className="emp-form-label">Phone Number</label>
                  <input type="text" name="phone" className="emp-form-input" onChange={handleInputChange} required />
                </div>

                <div className="col-12 mt-2">
                  <div className="emp-form-section">Official Information</div>
                </div>

                <div className="col-md-4">
                  <label className="emp-form-label">Department</label>
                  <select name="department" className="emp-form-input" onChange={handleInputChange} required>
                    <option value="">Select Department</option>
                    {departments.map((dept) => (
                      <option key={dept.id} value={dept.dept_name}>
                        {dept.dept_name}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="col-md-4">
                  <label className="emp-form-label">Designation</label>
                  <input type="text" name="designation" className="emp-form-input" onChange={handleInputChange} />
                </div>
                <div className="col-md-4">
                  <label className="emp-form-label">Role</label>
                  <select name="role" className="emp-form-input" onChange={handleInputChange}>
                    <option value="Staff">Staff</option>
                    <option value="Admin">Admin</option>
                    <option value="HR">HR</option>
                    <option value="Manager">Manager</option>
                  </select>
                </div>
                <div className="col-md-4">
                  <label className="emp-form-label">Status</label>
                  <select name="status" className="emp-form-input" onChange={handleInputChange}>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                  </select>
                </div>

                <div className="col-12 mt-2">
                  <div className="emp-form-section">Additional Information</div>
                </div>

                <div className="col-md-4">
                  <label className="emp-form-label">Blood Group</label>
                  <select name="blood_group" className="emp-form-input" onChange={handleInputChange}>
                    <option value="">Select</option>
                    {['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].map((blood) => (
                      <option key={blood} value={blood}>
                        {blood}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="col-md-4">
                  <label className="emp-form-label">Emergency Phone</label>
                  <input type="text" name="emergency_phone" className="emp-form-input" onChange={handleInputChange} />
                </div>
                <div className="col-md-4">
                  <label className="emp-form-label">NID Number</label>
                  <input type="text" name="nid_number" className="emp-form-input" onChange={handleInputChange} />
                </div>
                <div className="col-md-6">
                  <label className="emp-form-label">Present Address</label>
                  <textarea name="present_address" className="emp-form-input" rows="2" onChange={handleInputChange}></textarea>
                </div>
                <div className="col-md-6">
                  <label className="emp-form-label">Permanent Address</label>
                  <textarea name="permanent_address" className="emp-form-input" rows="2" onChange={handleInputChange}></textarea>
                </div>

                <div className="col-md-6">
                  <label className="emp-form-label">Joining Date</label>
                  <input
                    type="date"
                    name="joining_date"
                    className="emp-form-input"
                    defaultValue={new Date().toISOString().split('T')[0]}
                    onChange={handleInputChange}
                  />
                </div>
                <div className="col-md-6">
                  <label className="emp-form-label">Profile Picture</label>
                  <input type="file" name="profile_pic" className="emp-form-input" onChange={handleFileChange} accept="image/*" />
                </div>
              </div>

              <div className="mt-4 text-end">
                <button type="button" className="emp-btn secondary me-2" onClick={() => setShowModal(false)}>
                  Cancel
                </button>
                <button type="submit" className="emp-btn primary">
                  Save Employee
                </button>
              </div>
            </form>
          </Modal.Body>
        </Modal>
    </>
  );
};

export default Employees;
