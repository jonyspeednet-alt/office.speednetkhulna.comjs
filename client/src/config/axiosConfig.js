import axios from 'axios';

/**
 * Axios instance configuration for API calls
 * Points to the Express backend server running on localhost:3000
 */

// Use Vite environment variables in the browser: `import.meta.env`.
// If you need to override, set `VITE_API_URL` in a `.env` file at the project root.
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';
console.log('Axios Base URL:', API_BASE_URL);

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Include cookies in requests
});

/**
 * Request Interceptor
 * Adds authorization token to headers if available
 */
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

/**
 * Response Interceptor
 * Handles errors and token expiration
 */
apiClient.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    // Handle 401 Unauthorized (token expired)
    if (error.response?.status === 401) {
      // Only redirect if not already on login page
      if (!window.location.pathname.includes('/login')) {
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;
