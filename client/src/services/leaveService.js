import apiClient from '../config/axiosConfig';

/**
 * Updates the status of a leave request.
 * 
 * @param {number} id - The ID of the leave request.
 * @param {string} status - 'Approved', 'Rejected', or 'Pending'.
 * @param {string} [note] - Optional admin remark.
 * @returns {Promise<Object>} - The API response.
 */
export const updateLeaveStatus = async (id, status, note = '') => {
  try {
    const response = await apiClient.put(`/api/leaves/${id}/status`, {
      status,
      note
    });
    return response.data;
  } catch (error) {
    // Handle error (e.g., throw it to be caught by the component)
    const message = error.response?.data?.message || 'Failed to update status';
    throw new Error(message);
  }
};

/**
 * Fetches grouped leave requests.
 * @param {Object} params - { search, month, year }
 */
export const getLeaveRequests = async (params = {}) => {
  try {
    const response = await apiClient.get('/api/leaves', { params });
    return response.data;
  } catch (error) {
    console.error('Error fetching leaves:', error);
    throw error;
  }
};