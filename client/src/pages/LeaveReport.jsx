import React, { useEffect, useMemo, useState } from 'react';
import * as XLSX from 'xlsx';
import moment from 'moment';
import { getLeaveSummaryReport } from '../services/reportService';
import '../styles/AdminDashboard.css';
import '../styles/LeaveReport.css';

const LeaveReport = () => {
  const [data, setData] = useState({
    employeesList: [],
    leaveTypes: [],
    summaryReport: [],
    grandTypeCounts: {},
    grandTotalDays: 0
  });

  const [filters, setFilters] = useState({
    employee_id: '',
    start_date: '',
    end_date: ''
  });

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const fetchData = async (overrideFilters = null) => {
    setLoading(true);
    setError('');
    try {
      const result = await getLeaveSummaryReport(overrideFilters || filters);
      setData(result);
    } catch (fetchError) {
      setError(fetchError?.response?.data?.message || 'Failed to load report data.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleFilterChange = (event) => {
    setFilters((prev) => ({ ...prev, [event.target.name]: event.target.value }));
  };

  const handleSearch = (event) => {
    event.preventDefault();
    fetchData();
  };

  const handleReset = () => {
    const defaultFilters = { employee_id: '', start_date: '', end_date: '' };
    setFilters(defaultFilters);
    fetchData(defaultFilters);
  };

  const handleExport = () => {
    if (!data.summaryReport.length) return;

    const exportData = data.summaryReport.map((item, index) => {
      const row = {
        SL: index + 1,
        'Emp ID': item.emp_id,
        'Employee Name': item.name,
        Designation: item.designation
      };

      data.leaveTypes.forEach((leaveType) => {
        row[leaveType.name] = item.type_counts[leaveType.id] || '-';
      });

      row.Total = item.total_days;
      return row;
    });

    const totalRow = { SL: '', 'Emp ID': '', 'Employee Name': 'Grand Total', Designation: '' };
    data.leaveTypes.forEach((leaveType) => {
      totalRow[leaveType.name] = data.grandTypeCounts[leaveType.id] || '-';
    });
    totalRow.Total = data.grandTotalDays;
    exportData.push(totalRow);

    const worksheet = XLSX.utils.json_to_sheet(exportData);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Leave Report');
    XLSX.writeFile(workbook, `Leave_Report_${new Date().toISOString().slice(0, 10)}.xlsx`);
  };

  const previewRange = useMemo(() => {
    if (!filters.start_date && !filters.end_date) return 'All dates';
    if (filters.start_date && filters.end_date) {
      return `${moment(filters.start_date).format('DD MMM YYYY')} - ${moment(filters.end_date).format('DD MMM YYYY')}`;
    }
    if (filters.start_date) return `From ${moment(filters.start_date).format('DD MMM YYYY')}`;
    return `Until ${moment(filters.end_date).format('DD MMM YYYY')}`;
  }, [filters.start_date, filters.end_date]);

  return (
    <>
      <section className="lr-hero">
          <div>
            <span className="lr-chip">
              <i className="fa-solid fa-chart-line"></i>
              Reports Center
            </span>
            <h1>Leave Summary Report</h1>
            <p>Analyze leave trends by employee, type, and period with export-ready data.</p>
          </div>
          <div className="lr-metric-grid">
            <article>
              <span>Employees</span>
              <strong>{data.summaryReport.length}</strong>
            </article>
            <article>
              <span>Leave Types</span>
              <strong>{data.leaveTypes.length}</strong>
            </article>
            <article>
              <span>Total Days</span>
              <strong>{data.grandTotalDays || 0}</strong>
            </article>
            <article>
              <span>Range</span>
              <strong>{previewRange}</strong>
            </article>
          </div>
        </section>

        <section className="lr-filter-card">
          <form onSubmit={handleSearch} className="lr-filters">
            <div>
              <label>Select Employee</label>
              <select name="employee_id" value={filters.employee_id} onChange={handleFilterChange}>
                <option value="">All Employees</option>
                {data.employeesList.map((emp) => (
                  <option key={emp.id} value={emp.id}>
                    {emp.full_name} ({emp.employee_id})
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label>Start Date</label>
              <input type="date" name="start_date" value={filters.start_date} onChange={handleFilterChange} />
            </div>

            <div>
              <label>End Date</label>
              <input type="date" name="end_date" value={filters.end_date} onChange={handleFilterChange} />
            </div>

            <div className="lr-actions">
              <button type="submit" className="btn-primary-lite">
                <i className="fa-solid fa-magnifying-glass"></i>
                View
              </button>
              <button type="button" className="btn-success-lite" onClick={handleExport} disabled={!data.summaryReport.length}>
                <i className="fa-solid fa-file-excel"></i>
                Export
              </button>
              <button type="button" className="btn-neutral-lite" onClick={() => window.print()}>
                <i className="fa-solid fa-print"></i>
                Print
              </button>
              <button type="button" className="btn-soft-lite" onClick={handleReset}>
                <i className="fa-solid fa-rotate"></i>
                Reset
              </button>
            </div>
          </form>
        </section>

        {error && (
          <section className="lr-error">
            <i className="fa-solid fa-triangle-exclamation"></i>
            <span>{error}</span>
          </section>
        )}

        <section className="lr-table-card">
          <header>
            <div>
              <h2>Employee Leave Summary</h2>
              <p>Generated on {moment().format('DD MMMM YYYY, h:mm A')}</p>
            </div>
          </header>

          <div className="table-responsive">
            <table className="table mb-0 lr-table">
              <thead>
                <tr>
                  <th>SL</th>
                  <th>Emp ID</th>
                  <th>Employee Name</th>
                  <th>Designation</th>
                  {data.leaveTypes.map((leaveType) => (
                    <th key={leaveType.id} className="text-center">
                      {leaveType.name}
                    </th>
                  ))}
                  <th className="text-center">Total</th>
                </tr>
              </thead>
              <tbody>
                {loading && (
                  <tr>
                    <td colSpan="100%" className="text-center py-5">
                      <div className="spinner-border text-primary" role="status">
                        <span className="visually-hidden">Loading...</span>
                      </div>
                    </td>
                  </tr>
                )}

                {!loading && data.summaryReport.length === 0 && (
                  <tr>
                    <td colSpan="100%" className="text-center py-5 text-muted">
                      No data found for the selected filters.
                    </td>
                  </tr>
                )}

                {!loading &&
                  data.summaryReport.map((item, index) => (
                    <tr key={item.user_id}>
                      <td>{index + 1}</td>
                      <td className="text-center fw-bold">{item.emp_id}</td>
                      <td className="fw-bold">{item.name}</td>
                      <td>{item.designation}</td>
                      {data.leaveTypes.map((leaveType) => (
                        <td key={leaveType.id} className="text-center">
                          {item.type_counts[leaveType.id] > 0 ? item.type_counts[leaveType.id] : '-'}
                        </td>
                      ))}
                      <td className="text-center fw-bold total-cell">{item.total_days}</td>
                    </tr>
                  ))}
              </tbody>

              <tfoot>
                <tr>
                  <td colSpan="4" className="text-end text-uppercase fw-bold">
                    Grand Total
                  </td>
                  {data.leaveTypes.map((leaveType) => (
                    <td key={leaveType.id} className="text-center fw-bold">
                      {data.grandTypeCounts[leaveType.id] > 0 ? data.grandTypeCounts[leaveType.id] : '-'}
                    </td>
                  ))}
                  <td className="text-center fw-bold total-footer">{data.grandTotalDays}</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </section>
    </>
  );
};

export default LeaveReport;
