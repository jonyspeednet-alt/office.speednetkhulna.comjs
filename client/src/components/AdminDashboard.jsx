import React from 'react';
import { Link } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import moment from 'moment';
import ImageWithFallback from './ImageWithFallback';
import NoticeTicker from './NoticeTicker';
import { getAdminDashboardData } from '../services/adminDashboardService';
import '../styles/AdminDashboard.css';

const defaultDashboardData = {
  stats: { pending: 0, onLeave: 0, offDay: 0, totalStaff: 0 },
  onLeaveList: [],
  recentLeaves: []
};

const AdminDashboard = () => {
  const { data: result, isLoading: loading, error } = useQuery({
    queryKey: ['adminDashboard'],
    queryFn: getAdminDashboardData,
    select: (result) => ({
      stats: { ...defaultDashboardData.stats, ...(result?.stats || {}) },
      onLeaveList: Array.isArray(result?.onLeaveList) ? result.onLeaveList : [],
      recentLeaves: Array.isArray(result?.recentLeaves) ? result.recentLeaves : []
    }),
  });

  const data = result || defaultDashboardData;

  const getGreeting = () => {
    const hour = moment().hour();
    if (hour < 12) return 'Shuvo Shokal';
    if (hour < 17) return 'Shuvo Dupur';
    return 'Shuvo Shondha';
  };

  const formatDate = (value) => {
    if (!value) return '-';
    const parsed = moment(value);
    return parsed.isValid() ? parsed.format('DD MMM YYYY') : '-';
  };

  const getStatusClass = (status) => {
    if (status === 'Approved') return 'status-chip status-approved';
    if (status === 'Rejected') return 'status-chip status-rejected';
    return 'status-chip status-pending';
  };

  const generateCalendarDays = () => {
    const days = [];
    const endOfMonth = moment().endOf('month');
    const today = moment().date();
    
    for (let i = 1; i <= endOfMonth.date(); i++) {
      days.push({
        day: i,
        isToday: i === today,
        hasEvent: Math.random() > 0.8
      });
    }
    return days;
  };

  const DashboardSkeleton = () => (
    <div className="admin-skeleton-grid">
      <div className="admin-skeleton hero"></div>
      <div className="admin-skeleton stat"></div>
      <div className="admin-skeleton stat"></div>
      <div className="admin-skeleton stat"></div>
      <div className="admin-skeleton stat"></div>
    </div>
  );

  const DashboardHeader = ({ stats }) => {
    const availableStaff = Math.max(stats.totalStaff - stats.onLeave - stats.offDay, 0);
    const availabilityRate = stats.totalStaff > 0
      ? Math.round((availableStaff / stats.totalStaff) * 100)
      : 0;

    return (
      <section className="hero-panel glass-card fade-in">
        <div className="hero-content">
          <div className="hero-badge-group">
            <span className="hero-badge primary"><i className="fas fa-shield-alt"></i> Admin Control</span>
            {stats.pending > 0 && (
              <Link to="/manage-leaves?status=Pending" className="hero-badge warning pulse">
                <i className="fas fa-clock"></i> {stats.pending} Pending
              </Link>
            )}
          </div>
          <h1><span className="gradient-text">{getGreeting()}</span>, Admin</h1>
          <div className="hero-meta">
            <span><i className="fas fa-calendar-day"></i> {moment().format('DD MMMM, YYYY')}</span>
            <span><i className="fas fa-users"></i> {stats.totalStaff} Team Members</span>
          </div>
        </div>
        
        <div className="hero-stats-grid">
          <div className="hero-stat-item available">
            <div className="stat-label">Available</div>
            <div className="stat-value">{availableStaff}</div>
            <div className="stat-progress">
              <div className="progress-bar" style={{ width: `${availabilityRate}%` }}></div>
            </div>
          </div>
          <div className="hero-stat-item on-leave">
            <div className="stat-label">On Leave</div>
            <div className="stat-value">{stats.onLeave}</div>
            <div className="stat-dot"></div>
          </div>
          <div className="hero-stat-item off-day">
            <div className="stat-label">Off Day</div>
            <div className="stat-value">{stats.offDay}</div>
            <div className="stat-dot"></div>
          </div>
        </div>
      </section>
    );
  };

  const StatCard = ({ icon, title, value, variant }) => (
    <article className={`stat-card stat-${variant} glass-card animate-fade-in`}>
      <div className="stat-icon"><i className={`fas ${icon}`}></i></div>
      <div className="stat-info">
        <p className="stat-title">{title}</p>
        <h3 className="stat-value">{value}</h3>
      </div>
    </article>
  );

  const RecentActivityTable = ({ leaves }) => (
    <article className="widget-card glass-card animate-fade-in">
      <div className="widget-header">
        <h5 className="widget-title">Recent Leave Activity</h5>
        <Link to="/manage-leaves" className="btn-link">View All</Link>
      </div>

      <div className="activity-table">
        <table className="table">
          <thead>
            <tr>
              <th>Staff Member</th>
              <th>Leave Type</th>
              <th>Duration</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {leaves.length === 0 ? (
              <tr>
                <td colSpan="4" className="text-center py-5 text-muted">No recent activities</td>
              </tr>
            ) : (
              leaves.slice(0, 5).map((leave, index) => (
                <tr key={leave.id || index}>
                  <td>
                    <div className="staff-info">
                      <ImageWithFallback
                        src={leave.profile_pic ? `/uploads/${leave.profile_pic}` : null}
                        fallbackName={leave.full_name}
                        className="avatar-sm"
                        alt=""
                        width="32px"
                        height="32px"
                      />
                      <div>
                        <div className="fw-bold">{leave.full_name}</div>
                        <small className="text-muted">ID: {leave.staff_id}</small>
                      </div>
                    </div>
                  </td>
                  <td className="fw-semibold">{leave.type_name}</td>
                  <td>
                    <div className="small">{formatDate(leave.from_date)}</div>
                    <div className="small text-muted">to {formatDate(leave.to_date)}</div>
                  </td>
                  <td>
                    <span className={getStatusClass(leave.status)}>{leave.status}</span>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </article>
  );

  const TeamStatusList = ({ onLeave }) => (
    <article className="widget-card fade-in">
      <div className="widget-header">
        <h5 className="widget-title">Team Status</h5>
        <span className="badge bg-soft-success">{onLeave.length} Away</span>
      </div>

      <div className="team-status-list">
        {onLeave.length > 0 ? (
          onLeave.slice(0, 5).map((staff, index) => (
            <div key={index} className="team-row">
              <ImageWithFallback 
                src={staff.profile_pic ? `/uploads/${staff.profile_pic}` : null} 
                fallbackName={staff.full_name}
                className="avatar-sm" 
                alt="" 
                width="32px"
                height="32px"
              />
              <div>
                <h6>{staff.full_name}</h6>
                <small>{staff.leave_type || 'Leave'} in progress</small>
              </div>
            </div>
          ))
        ) : (
          <div className="text-center py-4 text-muted">All staff are available</div>
        )}
      </div>
    </article>
  );

  const AnalyticsWidget = ({ stats }) => {
    const total = Math.max(stats.pending + stats.onLeave + stats.offDay, 1);
    const pendingPer = (stats.pending / total) * 100;
    const onLeavePer = (stats.onLeave / total) * 100;

    return (
      <article className="widget-card fade-in">
        <div className="widget-header">
          <h5 className="widget-title">Availability Mix</h5>
        </div>

        <div className="analytics-chart-wrap">
          <div
            className="analytics-chart"
            style={{
              background: `conic-gradient(
                #f59e0b 0% ${pendingPer}%,
                #10b981 ${pendingPer}% ${pendingPer + onLeavePer}%,
                #3b82f6 ${pendingPer + onLeavePer}% 100%
              )`
            }}
          >
            <div className="analytics-center">{stats.totalStaff}</div>
          </div>
        </div>

        <div className="analytics-legend">
          <span><i className="fas fa-circle text-warning"></i> Pending ({stats.pending})</span>
          <span><i className="fas fa-circle text-success"></i> On Leave ({stats.onLeave})</span>
          <span><i className="fas fa-circle text-info"></i> Off Day ({stats.offDay})</span>
        </div>
      </article>
    );
  };

  return (
    <>
      <NoticeTicker />
      
      {loading ? (
        <DashboardSkeleton />
      ) : error ? (
        <div className="alert alert-danger">
          {error.message || 'Dashboard data load failed. Please check your network or API.'}
        </div>
      ) : (
        <>
          <DashboardHeader stats={data.stats} />
          
          <div className="stats-grid-modern">
            <StatCard variant="purple" icon="fa-user-clock" title="Pending Leaves" value={data.stats.pending} />
            <StatCard variant="amber" icon="fa-walking" title="On Leave Today" value={data.stats.onLeave} />
            <StatCard variant="green" icon="fa-calendar-check" title="Off Day Today" value={data.stats.offDay} />
            <StatCard variant="blue" icon="fa-users" title="Total Staff" value={data.stats.totalStaff} />
          </div>

          <div className="dashboard-grid">
            <div className="grid-left">
              <RecentActivityTable leaves={data.recentLeaves} />
            </div>
            <div className="grid-right">
              <div className="d-flex flex-column gap-4">
                <TeamStatusList onLeave={data.onLeaveList} />
                <AnalyticsWidget stats={data.stats} />
                <article className="widget-card fade-in">
                  <div className="widget-header">
                    <h5 className="widget-title">Quick Actions</h5>
                  </div>
                  <ul className="quick-action-list">
                    <li><Link to="/manage-leaves"><i className="fas fa-tasks"></i> Review Requests</Link></li>
                    <li><Link to="/employees"><i className="fas fa-users-cog"></i> Manage Staff</Link></li>
                    <li><Link to="/leave-report"><i className="fas fa-file-alt"></i> Reports</Link></li>
                  </ul>
                </article>
              </div>
            </div>
          </div>
        </>
      )}
    </>
  );
};

export default AdminDashboard;
