import React, { useEffect, useMemo, useState } from 'react';
import moment from 'moment';
import Swal from 'sweetalert2';
import ImageWithFallback from '../components/ImageWithFallback';
import { getLeaveRequests, updateLeaveStatus } from '../services/leaveService';
import '../styles/AdminDashboard.css';
import '../styles/ManageLeaves.css';

const STATUS_TABS = ['All', 'Pending', 'Approved', 'Rejected'];

const ManageLeaves = () => {
  const [requests, setRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeStatus, setActiveStatus] = useState('All');
  const [expandedGroups, setExpandedGroups] = useState({});
  const [filters, setFilters] = useState({ search: '', month: '', year: '' });

  useEffect(() => {
    fetchData();
  }, []);

  const stats = useMemo(
    () =>
      requests.reduce(
        (acc, group) => {
          const currentStatus = String(group.status || '').toLowerCase();
          if (currentStatus === 'pending') acc.pending += 1;
          if (currentStatus === 'approved') acc.approved += 1;
          if (currentStatus === 'rejected') acc.rejected += 1;
          acc.total += 1;
          return acc;
        },
        { pending: 0, approved: 0, rejected: 0, total: 0 }
      ),
    [requests]
  );

  const filteredRequests = useMemo(() => {
    if (activeStatus === 'All') return requests;
    return requests.filter((request) => request.status === activeStatus);
  }, [requests, activeStatus]);

  const fetchData = async (overrideFilters = null) => {
    const appliedFilters = overrideFilters || filters;
    setLoading(true);
    setError('');
    try {
      const data = await getLeaveRequests(appliedFilters);
      setRequests(Array.isArray(data) ? data : []);
    } catch (fetchError) {
      const message = fetchError?.response?.data?.message || fetchError?.message || 'Could not load leave requests.';
      setError(message);
      setRequests([]);
    } finally {
      setLoading(false);
    }
  };

  const handleFilterChange = (event) => {
    setFilters((prev) => ({ ...prev, [event.target.name]: event.target.value }));
  };

  const handleSearch = (event) => {
    event.preventDefault();
    fetchData();
  };

  const handleReset = () => {
    const defaultFilters = { search: '', month: '', year: '' };
    setFilters(defaultFilters);
    setActiveStatus('All');
    fetchData(defaultFilters);
  };

  const toggleGroup = (groupId) => {
    setExpandedGroups((prev) => ({ ...prev, [groupId]: !prev[groupId] }));
  };

  const getStatusClass = (status) => {
    const normalized = String(status || '').toLowerCase();
    if (normalized === 'approved') return 'approved';
    if (normalized === 'rejected') return 'rejected';
    return 'pending';
  };

  const openReasonModal = (text) => {
    Swal.fire({
      title: 'Leave Reason',
      text: text || 'No reason added.',
      icon: 'info',
      confirmButtonColor: '#1756d9'
    });
  };

  const handleStatusUpdate = async (id, status) => {
    const actionLabel = status === 'Approved' ? 'approve' : status === 'Rejected' ? 'reject' : 'move to pending';
    const confirmColor = status === 'Approved' ? '#0f9d58' : status === 'Rejected' ? '#dc3545' : '#f59f00';

    const result = await Swal.fire({
      title: 'Confirm Status Change',
      text: `Do you want to ${actionLabel} this leave group?`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: confirmColor,
      confirmButtonText: 'Yes, continue',
      cancelButtonText: 'Cancel'
    });

    if (!result.isConfirmed) return;

    try {
      await updateLeaveStatus(id, status);
      await Swal.fire({
        title: 'Updated',
        text: 'Leave status updated successfully.',
        icon: 'success',
        timer: 1400,
        showConfirmButton: false
      });
      fetchData();
    } catch (updateError) {
      Swal.fire({
        title: 'Update Failed',
        text: updateError?.message || 'Could not update this leave request.',
        icon: 'error'
      });
    }
  };

  return (
    <>
      <section className="mlv-hero">
          <div>
            <span className="mlv-label">
              <i className="fas fa-calendar-check"></i>
              Leave Operations
            </span>
            <h1>Manage Leave Requests</h1>
            <p>Review, approve, and track leave applications in one place.</p>
            <div className="mlv-meta">
              <span>
                <i className="fas fa-building"></i>
                Speed Net Khulna
              </span>
              <span>
                <i className="fas fa-calendar-day"></i>
                {moment().format('DD MMMM, YYYY')}
              </span>
            </div>
          </div>
          <div className="mlv-kpi-grid">
            <article className="mlv-kpi total">
              <span>Total</span>
              <strong>{stats.total}</strong>
            </article>
            <article className="mlv-kpi pending">
              <span>Pending</span>
              <strong>{stats.pending}</strong>
            </article>
            <article className="mlv-kpi approved">
              <span>Approved</span>
              <strong>{stats.approved}</strong>
            </article>
            <article className="mlv-kpi rejected">
              <span>Rejected</span>
              <strong>{stats.rejected}</strong>
            </article>
          </div>
        </section>

        <section className="mlv-toolbar">
          <form onSubmit={handleSearch} className="mlv-filter-form">
            <div className="mlv-input with-icon">
              <i className="fas fa-search"></i>
              <input
                type="text"
                name="search"
                placeholder="Search by employee name or ID"
                value={filters.search}
                onChange={handleFilterChange}
              />
            </div>
            <select name="month" value={filters.month} onChange={handleFilterChange}>
              <option value="">All Months</option>
              {Array.from({ length: 12 }, (_, idx) => (
                <option key={idx + 1} value={idx + 1}>
                  {moment(idx + 1, 'M').format('MMMM')}
                </option>
              ))}
            </select>
            <select name="year" value={filters.year} onChange={handleFilterChange}>
              <option value="">All Years</option>
              {Array.from({ length: 6 }, (_, idx) => {
                const year = new Date().getFullYear() - 3 + idx;
                return (
                  <option key={year} value={year}>
                    {year}
                  </option>
                );
              })}
            </select>
            <button type="submit" className="mlv-btn primary">
              <i className="fas fa-search"></i>
              Search
            </button>
            <button type="button" className="mlv-btn secondary" onClick={handleReset}>
              <i className="fas fa-rotate"></i>
              Reset
            </button>
          </form>

          <div className="mlv-status-tabs" role="tablist" aria-label="Leave Status Filter">
            {STATUS_TABS.map((status) => (
              <button
                key={status}
                type="button"
                className={`mlv-status-tab ${activeStatus === status ? 'active' : ''}`}
                onClick={() => setActiveStatus(status)}
              >
                {status}
              </button>
            ))}
          </div>
        </section>

        {error && (
          <section className="mlv-error">
            <i className="fas fa-circle-exclamation"></i>
            <span>{error}</span>
          </section>
        )}

        <section className="mlv-table-card">
          <header>
            <h2>Leave Applications</h2>
            <p>{loading ? 'Loading data...' : `${filteredRequests.length} group(s) found`}</p>
          </header>
          <div className="table-responsive">
            <table className="table align-middle mb-0 mlv-table">
              <thead>
                <tr>
                  <th className="expand-col"></th>
                  <th>Employee</th>
                  <th>Leave Details</th>
                  <th>Date Range</th>
                  <th>Days</th>
                  <th>Status</th>
                  <th className="text-end">Actions</th>
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan="7" className="text-center py-5">
                      <div className="spinner-border text-primary" role="status">
                        <span className="visually-hidden">Loading...</span>
                      </div>
                    </td>
                  </tr>
                )}

                {!loading && filteredRequests.length === 0 && (
                  <tr>
                    <td colSpan="7" className="text-center py-5 text-muted">
                      <i className="fas fa-folder-open d-block mb-3 fs-1 opacity-25"></i>
                      No leave records match your filters.
                    </td>
                  </tr>
                )}

                {!loading &&
                  filteredRequests.map((group, index) => {
                    const leaves = Array.isArray(group.leaves) ? group.leaves : [];
                    if (leaves.length === 0) return null;

                    const groupId = `group_${group.first_id || index}`;
                    const isExpanded = Boolean(expandedGroups[groupId]);
                    const hasMultipleRows = leaves.length > 1;
                    const totalDays = leaves.reduce((sum, item) => sum + Number(item.actual_days || 0), 0);
                    const minStart = leaves.reduce(
                      (minDate, current) =>
                        !minDate || new Date(current.start_date) < new Date(minDate) ? current.start_date : minDate,
                      null
                    );
                    const maxEnd = leaves.reduce(
                      (maxDate, current) =>
                        !maxDate || new Date(current.end_date) > new Date(maxDate) ? current.end_date : maxDate,
                      null
                    );
                    const statusClass = getStatusClass(group.status);

                    return (
                      <React.Fragment key={groupId}>
                        <tr
                          className={`mlv-main-row ${isExpanded ? 'expanded' : ''}`}
                          onClick={() => hasMultipleRows && toggleGroup(groupId)}
                        >
                          <td className="expand-col">
                            {hasMultipleRows ? (
                              <i className={`fas fa-chevron-right ${isExpanded ? 'rotated' : ''}`}></i>
                            ) : (
                              <i className="fas fa-circle static-dot"></i>
                            )}
                          </td>
                          <td>
                            <div className="mlv-employee">
                              <ImageWithFallback
                                src={group.user_info?.profile_pic ? `/uploads/${group.user_info.profile_pic}` : null}
                                fallbackName={group.user_info?.full_name || 'Employee'}
                                className="mlv-avatar"
                                width="44px"
                                height="44px"
                              />
                              <div>
                                <strong>{group.user_info?.full_name || 'Unknown employee'}</strong>
                                <small>ID: {group.user_info?.employee_id || '-'}</small>
                              </div>
                            </div>
                          </td>
                          <td>
                            <div className="mlv-detail">
                              <strong>{hasMultipleRows ? `${leaves.length} segments` : leaves[0].leave_type_name}</strong>
                              <button
                                type="button"
                                onClick={(event) => {
                                  event.stopPropagation();
                                  openReasonModal(group.reason);
                                }}
                              >
                                View reason
                              </button>
                            </div>
                          </td>
                          <td>
                            <strong>
                              {moment(minStart).format('DD MMM')} - {moment(maxEnd).format('DD MMM, YYYY')}
                            </strong>
                            {hasMultipleRows && <small>{leaves.length} leave lines grouped</small>}
                          </td>
                          <td>
                            <span className="mlv-days-badge">{totalDays}</span>
                          </td>
                          <td>
                            <span className={`mlv-status ${statusClass}`}>{group.status}</span>
                          </td>
                          <td className="text-end" onClick={(event) => event.stopPropagation()}>
                            <div className="mlv-actions">
                              {group.status === 'Pending' && (
                                <>
                                  <button
                                    type="button"
                                    className="ok"
                                    title="Approve"
                                    onClick={() => handleStatusUpdate(group.first_id, 'Approved')}
                                  >
                                    <i className="fas fa-check"></i>
                                  </button>
                                  <button
                                    type="button"
                                    className="danger"
                                    title="Reject"
                                    onClick={() => handleStatusUpdate(group.first_id, 'Rejected')}
                                  >
                                    <i className="fas fa-xmark"></i>
                                  </button>
                                </>
                              )}

                              {group.status !== 'Pending' && (
                                <>
                                  <button
                                    type="button"
                                    className="warn"
                                    title="Move to Pending"
                                    onClick={() => handleStatusUpdate(group.first_id, 'Pending')}
                                  >
                                    <i className="fas fa-rotate-left"></i>
                                  </button>
                                  {group.status === 'Approved' && (
                                    <a href={`/approval/${group.first_id}`} target="_blank" rel="noreferrer" title="Print approval">
                                      <i className="fas fa-print"></i>
                                    </a>
                                  )}
                                </>
                              )}
                            </div>
                          </td>
                        </tr>

                        {isExpanded &&
                          leaves.map((leaf) => (
                            <tr key={leaf.id} className="mlv-sub-row">
                              <td></td>
                              <td></td>
                              <td>
                                <div className="mlv-sub-detail">
                                  <span className="line-mark"></span>
                                  <div>
                                    <strong>{leaf.leave_type_name}</strong>
                                    {Number(leaf.leave_type_id) === 3 && leaf.half_day_period && <small>{leaf.half_day_period}</small>}
                                  </div>
                                </div>
                              </td>
                              <td>
                                {moment(leaf.start_date).format('DD MMM')} - {moment(leaf.end_date).format('DD MMM, YYYY')}
                              </td>
                              <td>{leaf.actual_days}</td>
                              <td></td>
                              <td></td>
                            </tr>
                          ))}
                      </React.Fragment>
                    );
                  })}
              </tbody>
            </table>
          </div>
        </section>
    </>
  );
};

export default ManageLeaves;
