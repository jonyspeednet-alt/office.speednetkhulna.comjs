import React, { useEffect, useState } from 'react';
import { getNotice } from '../services/noticeService';
import '../styles/NoticeTicker.css';

const NoticeTicker = () => {
  const [notice, setNotice] = useState('');

  useEffect(() => {
    const fetchNotice = async () => {
      try {
        const data = await getNotice();
        setNotice(data?.notice || '');
      } catch (error) {
        console.error('Failed to load notice:', error);
        setNotice('');
      }
    };
    fetchNotice();
  }, []);

  if (!notice) return null;

  return (
    <div className="news-ticker">
      <div className="ticker-title">
        <i className="fas fa-bullhorn me-2"></i> সর্বশেষ আপডেট
      </div>
      <div className="ticker-content">
        {/* CSS Animation replaces <marquee> */}
        <div className="ticker-scroll">
          {notice}
        </div>
      </div>
    </div>
  );
};

export default NoticeTicker;
