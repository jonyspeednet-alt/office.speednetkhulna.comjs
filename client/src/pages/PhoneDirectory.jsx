import React, { useState, useEffect } from 'react';
import { getPhones, getUsers, addPhone, updatePhone, deletePhone, exportPhonesCSV } from '../services/phoneDirectoryService';
import { Modal, Button } from 'react-bootstrap'; // Assuming react-bootstrap is installed

const PhoneDirectory = () => {
  const [phones, setPhones] = useState([]);
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalRecords, setTotalRecords] = useState(0);
  const [message, setMessage] = useState(null);

  // Modal State
  const [showModal, setShowModal] = useState(false);
  const [isEdit, setIsEdit] = useState(false);
  const [formData, setFormData] = useState({
    id: '', desk_name: '', assign_to: '', extension: '', phone_number: '', device_model: '', ip_address: ''
  });

  useEffect(() => {
    fetchPhones();
    fetchUsers();
    // eslint-disable-next-line
  }, [page, search]);

  const fetchPhones = async () => {
    setLoading(true);
    try {
      const data = await getPhones(page, search);
      setPhones(data.phones);
      setTotalPages(data.totalPages);
      setTotalRecords(data.totalRecords);
    } catch (error) {
      console.error('Error fetching phones', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchUsers = async () => {
    try {
      const data = await getUsers();
      setUsers(data);
    } catch (error) {
      console.error('Error fetching users', error);
    }
  };

  const handleSearch = (e) => {
    e.preventDefault();
    setPage(1); // Reset to page 1 on search
    fetchPhones();
  };

  const handleDelete = async (id) => {
    if (window.confirm('Are you sure you want to delete this phone?')) {
      try {
        await deletePhone(id);
        setMessage({ type: 'warning', text: 'Phone deleted successfully.' });
        fetchPhones();
      } catch (error) {
        setMessage({ type: 'danger', text: 'Failed to delete phone.' });
      }
    }
  };

  const handleModalSubmit = async (e) => {
    e.preventDefault();
    try {
      if (isEdit) {
        await updatePhone(formData.id, formData);
        setMessage({ type: 'success', text: 'Phone updated successfully!' });
      } else {
        await addPhone(formData);
        setMessage({ type: 'success', text: 'New phone added successfully!' });
      }
      setShowModal(false);
      fetchPhones();
    } catch (error) {
      setMessage({ type: 'danger', text: 'Operation failed.' });
    }
  };

  const openAddModal = () => {
    setIsEdit(false);
    setFormData({ id: '', desk_name: '', assign_to: '', extension: '', phone_number: '', device_model: '', ip_address: '' });
    setShowModal(true);
  };

  const openEditModal = (phone) => {
    setIsEdit(true);
    setFormData({
      id: phone.id,
      desk_name: phone.desk_name,
      assign_to: phone.assign_to,
      extension: phone.extension,
      phone_number: phone.phone_number,
      device_model: phone.device_model,
      ip_address: phone.ip_address
    });
    setShowModal(true);
  };

  return (
    <div className="container-fluid p-4">
      <div className="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
        <div>
          <h3 className="fw-bold mb-1">Office Phone Directory</h3>
          <p className="text-muted small mb-0">PABX and Hello Tel Phone Tracking</p>
        </div>
        
        <div className="d-flex gap-2 align-items-center d-print-none">
          <form onSubmit={handleSearch} className="d-flex">
            <div className="input-group">
              <span className="input-group-text bg-white border-end-0 rounded-start-pill ps-3"><i className="fas fa-search text-muted"></i></span>
              <input 
                type="text" 
                className="form-control border-start-0 rounded-end-pill" 
                placeholder="Search..." 
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />
            </div>
          </form>
          <button onClick={() => exportPhonesCSV(search)} className="btn btn-success shadow-sm rounded-circle p-2" title="Download CSV"><i className="fas fa-file-csv"></i></button>
          <button onClick={() => window.print()} className="btn btn-light shadow-sm rounded-circle p-2" title="Print"><i className="fas fa-print text-secondary"></i></button>
          <button className="btn btn-primary px-4 shadow-sm rounded-pill fw-bold text-nowrap" onClick={openAddModal}><i className="fas fa-plus me-2"></i> New</button>
        </div>
      </div>

      {message && (
        <div className={`alert alert-${message.type} border-0 shadow-sm rounded-4 mb-4`}>
          <i className={`fas fa-${message.type === 'success' ? 'check-circle' : 'exclamation-circle'} me-2`}></i> {message.text}
        </div>
      )}

      <div className="card border-0 shadow-sm rounded-4 p-4 bg-white">
        <div className="table-responsive">
          <table className="table align-middle table-hover">
            <thead>
              <tr>
                <th className="bg-light text-uppercase small fw-bold text-muted border-0 p-3">Desk Name</th>
                <th className="bg-light text-uppercase small fw-bold text-muted border-0 p-3">Assign To</th>
                <th className="bg-light text-uppercase small fw-bold text-muted border-0 p-3">Ext</th>
                <th className="bg-light text-uppercase small fw-bold text-muted border-0 p-3">Phone Number</th>
                <th className="bg-light text-uppercase small fw-bold text-muted border-0 p-3">Device Model</th>
                <th className="bg-light text-uppercase small fw-bold text-muted border-0 p-3">IP Address</th>
                <th className="bg-light text-end border-0 p-3 d-print-none">Action</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan="7" className="text-center py-4 text-muted">Loading...</td></tr>
              ) : phones.length === 0 ? (
                <tr><td colSpan="7" className="text-center py-4 text-muted">No data found.</td></tr>
              ) : (
                phones.map(phone => (
                  <tr key={phone.id}>
                    <td className="fw-bold text-dark">{phone.desk_name}</td>
                    <td>
                      {phone.full_name ? (
                        <div className="d-flex align-items-center">
                          <img 
                            src={phone.profile_pic ? `/uploads/${phone.profile_pic}` : `https://ui-avatars.com/api/?name=${phone.full_name}&background=random`} 
                            className="rounded-circle me-2 border border-white shadow-sm" 
                            style={{ width: '35px', height: '35px', objectFit: 'cover' }} 
                            alt="Profile"
                          />
                          <div>
                            <div className="fw-bold small">{phone.full_name}</div>
                            <div className="text-muted" style={{ fontSize: '10px' }}>{phone.designation}</div>
                          </div>
                        </div>
                      ) : (
                        <span className="text-muted">Unassigned</span>
                      )}
                    </td>
                    <td><span className="badge bg-light text-primary fw-bold px-2 py-1 rounded">{phone.extension}</span></td>
                    <td>{phone.phone_number || '-'}</td>
                    <td className="small text-muted">{phone.device_model || '-'}</td>
                    <td className="small text-muted">{phone.ip_address || '-'}</td>
                    <td className="text-end d-print-none">
                      <button className="btn btn-sm btn-warning bg-opacity-10 text-warning border-0 me-1" onClick={() => openEditModal(phone)}>
                        <i className="fas fa-edit"></i>
                      </button>
                      <button className="btn btn-sm btn-danger bg-opacity-10 text-danger border-0" onClick={() => handleDelete(phone.id)}>
                        <i className="fas fa-trash"></i>
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="d-flex justify-content-between align-items-center pt-3 border-top d-print-none">
            <div className="text-muted small">
              Showing {((page - 1) * 10) + 1} - {Math.min(page * 10, totalRecords)} of {totalRecords} records
            </div>
            <nav>
              <ul className="pagination pagination-sm mb-0">
                <li className={`page-item ${page <= 1 ? 'disabled' : ''}`}>
                  <button className="page-link rounded-start-pill" onClick={() => setPage(page - 1)}>Previous</button>
                </li>
                {[...Array(totalPages)].map((_, i) => (
                  <li key={i + 1} className={`page-item ${page === i + 1 ? 'active' : ''}`}>
                    <button className="page-link" onClick={() => setPage(i + 1)}>{i + 1}</button>
                  </li>
                ))}
                <li className={`page-item ${page >= totalPages ? 'disabled' : ''}`}>
                  <button className="page-link rounded-end-pill" onClick={() => setPage(page + 1)}>Next</button>
                </li>
              </ul>
            </nav>
          </div>
        )}
      </div>

      {/* Add/Edit Modal */}
      <Modal show={showModal} onHide={() => setShowModal(false)} centered>
        <Modal.Header closeButton className="border-0 px-4 pt-4">
          <Modal.Title className="fw-bold">{isEdit ? 'Update Phone Info' : 'Add New Phone'}</Modal.Title>
        </Modal.Header>
        <Modal.Body className="px-4">
          <form onSubmit={handleModalSubmit}>
            <div className="mb-3">
              <label className="form-label small fw-bold text-muted">Desk Name</label>
              <input type="text" className="form-control rounded-3" value={formData.desk_name} onChange={(e) => setFormData({...formData, desk_name: e.target.value})} placeholder="e.g. Front Desk" />
            </div>
            <div className="mb-3">
              <label className="form-label small fw-bold text-muted">Assign To</label>
              <select className="form-select rounded-3" value={formData.assign_to} onChange={(e) => setFormData({...formData, assign_to: e.target.value})} required>
                <option value="">Select User...</option>
                {users.map(u => (
                  <option key={u.id} value={u.id}>{u.full_name} ({u.designation})</option>
                ))}
              </select>
            </div>
            <div className="row g-3 mb-3">
              <div className="col-6">
                <label className="form-label small fw-bold text-muted">Extension</label>
                <input type="text" className="form-control rounded-3" value={formData.extension} onChange={(e) => setFormData({...formData, extension: e.target.value})} placeholder="101" />
              </div>
              <div className="col-6">
                <label className="form-label small fw-bold text-muted">Phone Number</label>
                <input type="text" className="form-control rounded-3" value={formData.phone_number} onChange={(e) => setFormData({...formData, phone_number: e.target.value})} required />
              </div>
            </div>
            <div className="row g-3 mb-3">
              <div className="col-6">
                <label className="form-label small fw-bold text-muted">Device Model</label>
                <input type="text" className="form-control rounded-3" value={formData.device_model} onChange={(e) => setFormData({...formData, device_model: e.target.value})} />
              </div>
              <div className="col-6">
                <label className="form-label small fw-bold text-muted">IP Address</label>
                <input type="text" className="form-control rounded-3" value={formData.ip_address} onChange={(e) => setFormData({...formData, ip_address: e.target.value})} />
              </div>
            </div>
            <div className="text-end pb-2">
              <Button variant="light" className="rounded-pill me-2" onClick={() => setShowModal(false)}>Close</Button>
              <Button type="submit" variant="primary" className="rounded-pill px-4">{isEdit ? 'Update' : 'Save'}</Button>
            </div>
          </form>
        </Modal.Body>
      </Modal>
    </div>
  );
};

export default PhoneDirectory;