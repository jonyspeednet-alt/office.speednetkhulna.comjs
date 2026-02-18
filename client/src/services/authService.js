import apiClient from '../config/axiosConfig';

/**
 * Logs in the user.
 * @param {string} identifier - Email or Employee ID
 * @param {string} password
 */
export const loginUser = async (identifier, password) => {
  try {
    const response = await apiClient.post('/api/auth/login', { identifier, password });
    // Store basic user info in localStorage (optional, for UI access)
    if (response.data.user) {
      localStorage.setItem('user', JSON.stringify(response.data.user));
    }
    if (response.data.token) {
      localStorage.setItem('token', response.data.token);
    }
    return response.data;
  } catch (error) {
    console.error("Login API Error:", error); // ডিবাগিং এর জন্য লগ যোগ করা হলো
    const responseData = error.response?.data;
    if (typeof responseData === 'string') {
      throw { message: responseData };
    }
    if (responseData && typeof responseData === 'object') {
      throw responseData;
    }
    throw { message: error.message || 'Login failed' };
  }
};

/**
 * Logs out the user.
 */
export const logoutUser = async () => {
  try {
    // Call backend to clear httpOnly cookies
    await apiClient.post('/api/auth/logout');
    
    // Clear client-side storage
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  } catch (error) {
    console.error('Logout failed', error);
  }
};
