import apiClient from '../config/axiosConfig';

export const getNotice = async () => {
  try {
    const response = await apiClient.get('/api/notice');
    return response.data;
  } catch (error) {
    console.error('Error fetching notice:', error);
    return { notice: '' };
  }
};