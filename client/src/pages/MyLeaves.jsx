import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { getMyLeaves } from '../services/myLeavesService';
import moment from 'moment';

const MyLeaves = () => {
  const [leaves, setLeaves] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchLeaves();
  }, []);

  const fetchLeaves = async () => {
    try {
      const data = await getMyLeaves();
      setLeaves(data);
    } catch (error) {
      // Handle error silently or show notification
    } finally {
      setLoading(false);
    }
  };

  const countDays = (start, end) => {
    const startDate = moment(start);
    const endDate = moment(end);
    return endDate.diff(startDate, 'days') + 1;
  };

  return (
    <div className="container-fluid p-4">
      {/* Header */}
      <div className="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4">
        <div>
          <h3 className="fw-bold text-dark mb-1">আমার ছুটির তালিকা</h3>
          <p className="text-muted mb-0">আপনার আবেদনের বর্তমান অবস্থা এবং ডিজিটাল অনুমোদন পত্র</p>
        </div>
        <Link to="/apply-leave" className="btn btn-primary rounded-pill px-4 fw-bold shadow-sm mt-3 mt-md-0">
          <i className="fas fa-plus me-2"></i> নতুন আবেদন
        </Link>
      </div>

      {/* Table Card */}
      <div className="card border-0 shadow-sm rounded-4 p-4 bg-white">
        <div className="table-responsive">
          <table className="table table-hover align-middle">
            <thead className="bg-light">
              <tr>
                <th className="border-0 text-muted small fw-bold text-uppercase p-3">আবেদনের তারিখ</th>
                <th className="border-0 text-muted small fw-bold text-uppercase p-3">ছুটির ধরণ</th>
                <th className="border-0 text-muted small fw-bold text-uppercase p-3">সময়সীমা</th>
                <th className="border-0 text-muted small fw-bold text-uppercase p-3">মোট দিন</th>
                <th className="border-0 text-muted small fw-bold text-uppercase p-3">অবস্থা (Status)</th>
                <th className="border-0 text-muted small fw-bold text-uppercase p-3 text-end">অ্যাকশন</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan="6" className="text-center py-5 text-muted">Loading...</td></tr>
              ) : leaves.length === 0 ? (
                <tr>
                  <td colSpan="6" className="text-center py-5">
                    <div className="text-muted">আপনার কোনো ছুটির আবেদন পাওয়া যায়নি।</div>
                  </td>
                </tr>
              ) : (
                leaves.map(leave => (
                  <tr key={leave.id}>
                    <td className="p-3">
                      <div className="fw-bold">{moment(leave.applied_at).format('DD MMM, YYYY')}</div>
                      <small className="text-muted">{moment(leave.applied_at).format('h:mm A')}</small>
                    </td>
                    <td className="p-3"><span className="text-primary fw-bold">{leave.leave_name}</span></td>
                    <td className="p-3">
                      <div className="small fw-bold">
                        <i className="far fa-calendar-alt text-muted me-1"></i>
                        {moment(leave.start_date).format('DD/MM/YYYY')} - {moment(leave.end_date).format('DD/MM/YYYY')}
                      </div>
                    </td>
                    <td className="p-3">
                      <span className="badge bg-light text-dark rounded-pill border">
                        {countDays(leave.start_date, leave.end_date)} দিন
                      </span>
                    </td>
                    <td className="p-3">
                      <span className={`badge rounded-pill px-3 py-2 ${
                        leave.status === 'Approved' ? 'bg-success-subtle text-success' : 
                        leave.status === 'Rejected' ? 'bg-danger-subtle text-danger' : 
                        'bg-warning-subtle text-warning'
                      }`}>
                        <i className="fas fa-circle me-1" style={{fontSize: '8px'}}></i> {leave.status}
                      </span>
                    </td>
                    <td className="p-3 text-end">
                      {leave.status === 'Approved' ? (
                        <a href={`/api/leaves/generate-approval/${leave.id}`} target="_blank" rel="noopener noreferrer" className="btn btn-sm btn-outline-primary rounded-pill px-3 fw-bold">
                          <i className="fas fa-file-invoice me-1"></i> ডাউনলোড
                        </a>
                      ) : (
                        <span className="badge bg-light text-muted fw-normal">প্রক্রিয়াধীন</span>
                      )}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default MyLeaves;