import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { getUserProfile } from '../services/profileService';
import ImageWithFallback from '../components/ImageWithFallback';
import moment from 'moment';
import '../styles/AdminDashboard.css';

const Profile = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [profileData, setProfileData] = useState(null);
  const [activeTab, setActiveTab] = useState('overview');
  const [filters, setFilters] = useState({
    month: '',
    year: new Date().getFullYear()
  });

  const fetchProfile = async () => {
    setLoading(true);
    try {
      const data = await getUserProfile(id, filters.month, filters.year);
      setProfileData(data);
    } catch (error) {
      console.error("Failed to fetch profile", error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProfile();
  }, [id, filters.month, filters.year]);

  if (loading) return (
    <div className="d-flex flex-column justify-content-center align-items-center h-100 py-5">
      <div className="loader-container text-center">
        <div className="spinner-border text-primary" role="status" style={{ width: '3rem', height: '3rem' }}></div>
        <p className="mt-3 fw-bold text-primary">প্রোফাইল লোড হচ্ছে...</p>
      </div>
    </div>
  );

  if (!profileData) return (
    <div className="d-flex flex-column justify-content-center align-items-center h-100 py-5 text-center">
      <div className="error-card glass-card p-5">
        <div className="display-1 fw-bold text-danger opacity-25">404</div>
        <h2 className="fw-bold text-dark">ইউজার পাওয়া যায়নি</h2>
        <p className="text-muted mb-4">দুঃখিত, এই ইউজারটির কোনো তথ্য আমাদের ডাটাবেজে নেই।</p>
        <button onClick={() => navigate('/employees')} className="btn btn-primary rounded-pill px-5 shadow">
          কর্মচারী তালিকায় ফিরে যান
        </button>
      </div>
    </div>
  );

  const { user, leaves, filteredTotalDays } = profileData;

  const getStatusBadge = (status) => {
    switch(status) {
      case 'Approved': return <span className="badge bg-success-soft text-success">অনুমোদিত</span>;
      case 'Rejected': return <span className="badge bg-danger-soft text-danger">বাতিল</span>;
      default: return <span className="badge bg-warning-soft text-warning">অপেক্ষমান</span>;
    }
  };

  return (
    <>
      {/* Modern Profile Header */}
        <div className="profile-header-container mb-4">
          <div className="profile-banner"></div>
          <div className="profile-info-overlay glass-card">
            <div className="row align-items-end g-4">
              <div className="col-auto">
                <div className="profile-avatar-wrapper">
                  <ImageWithFallback 
                    src={user.profile_pic ? `/uploads/${user.profile_pic}` : null} 
                    fallbackName={user.full_name} 
                    alt={user.full_name} 
                    className="profile-avatar shadow-lg"
                    width="140px"
                    height="140px"
                  />
                  <div className={`status-indicator ${user.can_take_action ? 'active' : ''}`}></div>
                </div>
              </div>
              <div className="col">
                <div className="d-flex flex-wrap justify-content-between align-items-center gap-3">
                  <div className="profile-titles">
                    <h1 className="user-name mb-1">{user.full_name}</h1>
                    <div className="user-meta d-flex gap-3 flex-wrap">
                      <span><i className="fas fa-id-badge me-1"></i> ID: {user.employee_id}</span>
                      <span><i className="fas fa-briefcase me-1"></i> {user.designation || 'Staff'}</span>
                      <span><i className="fas fa-layer-group me-1"></i> {user.department}</span>
                    </div>
                  </div>
                  <div className="profile-actions d-flex gap-2">
                    <button onClick={() => navigate(`/edit-employee/${user.id}`)} className="btn btn-primary-glass">
                      <i className="fas fa-user-edit me-2"></i>প্রোফাইল এডিট
                    </button>
                    <button onClick={() => navigate('/employees')} className="btn btn-light-glass">
                      <i className="fas fa-chevron-left me-2"></i>ফিরে যান
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="profile-tabs-container mb-4">
          <div className="nav nav-pills glass-card p-2 d-inline-flex">
            <button 
              className={`nav-link ${activeTab === 'overview' ? 'active' : ''}`} 
              onClick={() => setActiveTab('overview')}
            >
              <i className="fas fa-th-large me-2"></i>ওভারভিউ
            </button>
            <button 
              className={`nav-link ${activeTab === 'details' ? 'active' : ''}`} 
              onClick={() => setActiveTab('details')}
            >
              <i className="fas fa-info-circle me-2"></i>বিস্তারিত তথ্য
            </button>
            <button 
              className={`nav-link ${activeTab === 'leaves' ? 'active' : ''}`} 
              onClick={() => setActiveTab('leaves')}
            >
              <i className="fas fa-calendar-alt me-2"></i>ছুটির হিসেব
            </button>
          </div>
        </div>

        {/* Tab Content */}
        <div className="tab-content">
          
          {/* OVERVIEW TAB */}
          {activeTab === 'overview' && (
            <div className="fade-in">
              <div className="row g-4">
                <div className="col-lg-8">
                  <div className="widget-card glass-card p-4">
                    <div className="d-flex justify-content-between align-items-center mb-4">
                      <h5 className="section-title"><i className="fas fa-chart-pie me-2"></i>এই বছরের ছুটির পরিসংখ্যান</h5>
                      <div className="badge bg-primary px-3 py-2">{filters.year}</div>
                    </div>
                    <div className="row g-3">
                      <div className="col-md-4">
                        <div className="stat-box text-center p-4 rounded-4 bg-primary-soft">
                          <div className="stat-label">মোট ছুটি (দিন)</div>
                          <div className="stat-value text-primary">{filteredTotalDays}</div>
                        </div>
                      </div>
                      <div className="col-md-4">
                        <div className="stat-box text-center p-4 rounded-4 bg-success-soft">
                          <div className="stat-label">অনুমোদিত আবেদন</div>
                          <div className="stat-value text-success">{leaves.filter(l => l.status === 'Approved').length}</div>
                        </div>
                      </div>
                      <div className="col-md-4">
                        <div className="stat-box text-center p-4 rounded-4 bg-warning-soft">
                          <div className="stat-label">অপেক্ষমান</div>
                          <div className="stat-value text-warning">{leaves.filter(l => l.status === 'Pending' || !l.status).length}</div>
                        </div>
                      </div>
                    </div>
                    
                    <div className="mt-4 pt-4 border-top">
                      <h6 className="mb-3 fw-bold">কর্মক্ষেত্রের তথ্য</h6>
                      <div className="row g-3">
                        <div className="col-6 col-md-3">
                          <div className="small text-muted">সাপ্তাহিক ছুটি</div>
                          <div className="fw-bold">{user.weekly_off || 'শুক্রবার'}</div>
                        </div>
                        <div className="col-6 col-md-3">
                          <div className="small text-muted">যোগদানের তারিখ</div>
                          <div className="fw-bold">{user.joining_date ? moment(user.joining_date).format('DD MMM, YYYY') : 'N/A'}</div>
                        </div>
                        <div className="col-6 col-md-3">
                          <div className="small text-muted">রোল / পদবী</div>
                          <div className="fw-bold">{user.can_take_action ? 'এডমিন/ম্যানেজার' : 'সাধারণ ইউজার'}</div>
                        </div>
                        <div className="col-6 col-md-3">
                          <div className="small text-muted">স্ট্যাটাস</div>
                          <div className="fw-bold text-success">সক্রিয়</div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                
                <div className="col-lg-4">
                  <div className="widget-card glass-card p-4 h-100">
                    <h5 className="section-title mb-4"><i className="fas fa-address-book me-2"></i>যোগাযোগ</h5>
                    <div className="contact-item mb-3">
                      <div className="icon-circle bg-light me-3"><i className="fas fa-envelope text-primary"></i></div>
                      <div>
                        <div className="small text-muted">ইমেইল এড্রেস</div>
                        <div className="fw-bold text-break">{user.email || 'N/A'}</div>
                      </div>
                    </div>
                    <div className="contact-item mb-3">
                      <div className="icon-circle bg-light me-3"><i className="fas fa-phone text-success"></i></div>
                      <div>
                        <div className="small text-muted">ফোন নাম্বার</div>
                        <div className="fw-bold">{user.phone}</div>
                      </div>
                    </div>
                    <div className="contact-item">
                      <div className="icon-circle bg-light me-3"><i className="fas fa-tint text-danger"></i></div>
                      <div>
                        <div className="small text-muted">রক্তের গ্রুপ</div>
                        <div className="fw-bold text-danger">{user.blood_group || 'অজানা'}</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* DETAILS TAB */}
          {activeTab === 'details' && (
            <div className="fade-in">
              <div className="row g-4">
                <div className="col-lg-6">
                  <div className="widget-card glass-card p-4">
                    <h5 className="section-title mb-4"><i className="fas fa-map-marker-alt me-2"></i>ঠিকানা সমূহ</h5>
                    <div className="address-card p-3 rounded-4 bg-light mb-3">
                      <div className="text-primary fw-bold mb-1"><i className="fas fa-home me-2"></i>বর্তমান ঠিকানা</div>
                      <p className="mb-0 text-muted">{user.present_address || 'কোন তথ্য প্রদান করা হয়নি।'}</p>
                    </div>
                    <div className="address-card p-3 rounded-4 bg-light">
                      <div className="text-primary fw-bold mb-1"><i className="fas fa-building me-2"></i>স্থায়ী ঠিকানা</div>
                      <p className="mb-0 text-muted">{user.permanent_address || 'কোন তথ্য প্রদান করা হয়নি।'}</p>
                    </div>
                  </div>
                </div>
                <div className="col-lg-6">
                  <div className="widget-card glass-card p-4 h-100">
                    <h5 className="section-title mb-4"><i className="fas fa-id-card me-2"></i>পরিচয়পত্র (NID)</h5>
                    {user.nid_number && <div className="mb-3"><strong>NID নাম্বার:</strong> {user.nid_number}</div>}
                    {user.nid_pic ? (
                      <div className="nid-image-container rounded-4 overflow-hidden border">
                        <ImageWithFallback 
                          src={`/uploads/${user.nid_pic}`} 
                          className="img-fluid" 
                          alt="NID" 
                          type="nid"
                        />
                        <div className="overlay-btn">
                          <button className="btn btn-white btn-sm shadow" data-bs-toggle="modal" data-bs-target="#nidModal">
                            <i className="fas fa-expand-arrows-alt me-2"></i>বড় করে দেখুন
                          </button>
                        </div>
                      </div>
                    ) : (
                      <div className="text-center py-5 bg-light rounded-4">
                        <i className="fas fa-id-card-alt fa-3x mb-3 text-muted opacity-25"></i>
                        <p className="text-muted">NID কপি আপলোড করা হয়নি</p>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* LEAVES TAB */}
          {activeTab === 'leaves' && (
            <div className="fade-in">
              <div className="widget-card glass-card p-4">
                <div className="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
                  <h5 className="section-title mb-0"><i className="fas fa-history me-2"></i>ছুটির বিস্তারিত ইতিহাস</h5>
                  <div className="d-flex gap-2">
                    <select className="form-select form-select-sm border-0 bg-light-glass rounded-pill ps-3 pe-5" style={{ minWidth: '140px' }} value={filters.month} onChange={(e) => setFilters({...filters, month: e.target.value})}>
                      <option value="">সকল মাস</option>
                      {Array.from({length: 12}, (_, i) => (<option key={i+1} value={i+1}>{moment(i+1, 'M').format('MMMM')}</option>))}
                    </select>
                    <select className="form-select form-select-sm border-0 bg-light-glass rounded-pill ps-3 pe-5" style={{ minWidth: '100px' }} value={filters.year} onChange={(e) => setFilters({...filters, year: e.target.value})}>
                      {Array.from({length: 3}, (_, i) => { const y = new Date().getFullYear() - i; return <option key={y} value={y}>{y}</option>; })}
                    </select>
                  </div>
                </div>
                
                <div className="table-responsive">
                  <table className="table custom-table">
                    <thead>
                      <tr>
                        <th>তারিখ</th>
                        <th>ছুটির ধরণ</th>
                        <th>দিন সংখ্যা</th>
                        <th>কারণ</th>
                        <th>স্ট্যাটাস</th>
                      </tr>
                    </thead>
                    <tbody>
                      {leaves.length === 0 ? (
                        <tr><td colSpan="5" className="text-center py-5 text-muted">কোন ছুটির রেকর্ড পাওয়া যায়নি।</td></tr>
                      ) : (
                        leaves.map(leave => (
                          <tr key={leave.id}>
                            <td>
                              <div className="fw-bold">{moment(leave.start_date).format('DD MMM, YYYY')}</div>
                              <small className="text-muted">{moment(leave.end_date).format('DD MMM, YYYY')}</small>
                            </td>
                            <td><span className="type-dot me-2"></span>{leave.type_name}</td>
                            <td><span className="badge bg-light text-dark border px-3">{parseInt(leave.leave_type_id) === 3 ? '0.5' : moment(leave.end_date).diff(moment(leave.start_date), 'days') + 1} দিন</span></td>
                            <td className="small text-muted" style={{ maxWidth: '200px' }}>{leave.reason}</td>
                            <td>{getStatusBadge(leave.status)}</td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          )}
        </div>

        {/* NID Modal */}
        <div className="modal fade" id="nidModal" tabIndex="-1">
          <div className="modal-dialog modal-lg modal-dialog-centered">
            <div className="modal-content glass-card border-0">
              <div className="modal-header border-0 pb-0">
                <button type="button" className="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <div className="modal-body text-center p-4">
                {user.nid_pic && <img src={`/uploads/${user.nid_pic}`} className="img-fluid rounded-4 shadow" alt="NID Full" />}
              </div>
            </div>
          </div>
        </div>
      
      <style dangerouslySetInnerHTML={{ __html: `
        /* Professional Profile Styles */
        .profile-header-container { position: relative; border-radius: 24px; overflow: hidden; margin-top: -10px; }
        .profile-banner { height: 150px; background: linear-gradient(135deg, #4318ff 0%, #a855f7 100%); opacity: 0.8; }
        .profile-info-overlay { margin: -60px 20px 0; padding: 25px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.4); }
        .profile-avatar-wrapper { position: relative; }
        .profile-avatar { width: 140px; height: 140px; border-radius: 24px; border: 5px solid #fff; object-fit: cover; }
        .status-indicator { position: absolute; bottom: 10px; right: 10px; width: 20px; height: 20px; background: #9ca3af; border: 3px solid #fff; border-radius: 50%; }
        .status-indicator.active { background: #10b981; }
        
        .user-name { font-size: 2rem; font-weight: 800; color: #1b2559; }
        .user-meta { color: #64748b; font-weight: 500; font-size: 0.95rem; }
        
        .btn-primary-glass { background: #4318ff; color: #fff; border: none; padding: 10px 24px; border-radius: 12px; font-weight: 600; transition: 0.3s; box-shadow: 0 4px 14px 0 rgba(67, 24, 255, 0.39); }
        .btn-primary-glass:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(67, 24, 255, 0.4); }
        .btn-light-glass { background: rgba(255,255,255,0.8); color: #1b2559; border: 1px solid #e2e8f0; padding: 10px 24px; border-radius: 12px; font-weight: 600; transition: 0.3s; }
        .btn-light-glass:hover { background: #fff; transform: translateY(-2px); }

        .profile-tabs-container .nav-pills .nav-link { color: #64748b; font-weight: 600; padding: 10px 20px; border-radius: 12px; border: none; transition: 0.3s; }
        .profile-tabs-container .nav-pills .nav-link.active { background: #4318ff; color: #fff; box-shadow: 0 4px 12px rgba(67,24,255,0.2); }
        .profile-tabs-container .nav-pills .nav-link:not(.active):hover { background: rgba(67,24,255,0.05); color: #4318ff; }

        .section-title { font-weight: 800; color: #1b2559; font-size: 1.1rem; }
        .stat-label { color: #64748b; font-weight: 600; font-size: 0.85rem; margin-bottom: 5px; }
        .stat-value { font-size: 2.2rem; font-weight: 800; line-height: 1; }
        
        .bg-primary-soft { background-color: rgba(67, 24, 255, 0.08); }
        .bg-success-soft { background-color: rgba(16, 185, 129, 0.1); }
        .bg-danger-soft { background-color: rgba(239, 68, 68, 0.1); }
        .bg-warning-soft { background-color: rgba(245, 158, 11, 0.1); }
        
        .contact-item { display: flex; align-items: center; }
        .icon-circle { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; }
        
        .nid-image-container { position: relative; }
        .overlay-btn { position: absolute; top: 0; left: 0; width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; background: rgba(0,0,0,0.2); opacity: 0; transition: 0.3s; }
        .nid-image-container:hover .overlay-btn { opacity: 1; }

        .custom-table { margin-bottom: 0; }
        .custom-table thead th { background: #f8fafc; border: none; padding: 15px; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; }
        .custom-table tbody td { border-bottom: 1px solid #f1f5f9; padding: 15px; vertical-align: middle; color: #1b2559; }
        .type-dot { display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: #4318ff; }

        .fade-in { animation: fadeIn 0.4s ease-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        @media (max-width: 991px) {
          .profile-avatar { width: 100px; height: 100px; }
          .profile-info-overlay { margin-top: -40px; padding: 15px; }
          .user-name { font-size: 1.5rem; }
          .profile-actions { width: 100%; }
          .profile-actions button { flex: 1; font-size: 0.9rem; padding: 8px 15px; }
        }
      `}} />
    </>
  );
};

export default Profile;
