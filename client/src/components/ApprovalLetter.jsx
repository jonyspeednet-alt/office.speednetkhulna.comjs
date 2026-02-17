import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { getApprovalData } from '../services/approvalService';
import ImageWithFallback from './ImageWithFallback';
import html2canvas from 'html2canvas';
import moment from 'moment';
import 'moment/locale/bn'; // Import Bengali locale

const ApprovalLetter = () => {
  const { id } = useParams();
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [processingImg, setProcessingImg] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const result = await getApprovalData(id);
        setData(result);
      } catch (err) {
        setError('Failed to load approval letter.');
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [id]);

  const handlePrint = () => {
    window.print();
  };

  const handleDownloadImage = async () => {
    setProcessingImg(true);
    const letter = document.getElementById('approvalLetter');
    
    // Temporary style changes for capture
    const originalShadow = letter.style.boxShadow;
    const originalMargin = letter.style.margin;
    letter.style.boxShadow = 'none';
    letter.style.margin = '0';

    try {
      const canvas = await html2canvas(letter, {
        scale: 3,
        useCORS: true,
        allowTaint: true,
        backgroundColor: "#ffffff",
        logging: false
      });

      const image = canvas.toDataURL("image/png", 1.0);
      const link = document.createElement('a');
      link.download = `Approval-${data.info.employee_id}.png`;
      link.href = image;
      link.click();
    } catch (err) {
      alert("Image generation failed.");
    } finally {
      // Revert styles
      letter.style.boxShadow = originalShadow;
      letter.style.margin = originalMargin;
      setProcessingImg(false);
    }
  };

  if (loading) return <div className="text-center p-5">Loading...</div>;
  if (error) return <div className="text-center p-5 text-danger">{error}</div>;
  if (!data) return null;

  const { info, leaves, joining_info } = data;
  const isMulti = leaves.length > 1;

  // Bengali Day Mapping
  const bnDays = {
    'Saturday': 'শনিবার', 'Sunday': 'রবিবার', 'Monday': 'সোমবার',
    'Tuesday': 'মঙ্গলবার', 'Wednesday': 'বুধবার', 'Thursday': 'বৃহস্পতিবার', 'Friday': 'শুক্রবার'
  };

  const getBnDay = (dateStr) => {
    const dayEn = moment(dateStr).format('dddd');
    return bnDays[dayEn] || dayEn;
  };

  // Joining Text Construction
  let joiningText = "";
  if (joining_info.date) {
    const joinDate = moment(joining_info.date);
    const dateStr = joinDate.format('DD/MM/YYYY');
    const dayName = getBnDay(joining_info.date);
    
    let timePart = "";
    if (joining_info.desc === 'Second Half') {
      timePart = `(${dayName} - দিনের দ্বিতীয় ভাগে)`;
    } else {
      timePart = `(${dayName})`;
    }

    const prefix = isMulti ? "উপরোক্ত সব ছুটি শেষে আপনাকে" : "ছুটি শেষে আপনাকে";
    joiningText = `${prefix} আগামী <strong>${dateStr}</strong> তারিখ <strong>${timePart}</strong> যথাসময়ে কর্মস্থলে উপস্থিত হওয়ার জন্য অনুরোধ করা হলো।`;
  }

  return (
    <div style={{ background: '#f0f0f0', minHeight: '100vh', padding: '20px' }}>
      {/* Action Bar */}
      <div className="d-flex justify-content-end gap-2 mb-4 d-print-none container" style={{ maxWidth: '210mm' }}>
        <button onClick={handlePrint} className="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">
          <i className="fas fa-print me-2"></i> প্রিন্ট / PDF
        </button>
        <button onClick={handleDownloadImage} className="btn btn-success rounded-pill px-4 fw-bold shadow-sm" disabled={processingImg}>
          <i className={`fas ${processingImg ? 'fa-spinner fa-spin' : 'fa-image'} me-2`}></i> PNG ডাউনলোড
        </button>
      </div>

      {/* Letter Container */}
      <div 
        id="approvalLetter"
        style={{
          width: '210mm',
          minHeight: '297mm',
          padding: '15mm 20mm',
          margin: '0 auto',
          background: 'white',
          boxShadow: '0 0 10px rgba(0,0,0,0.1)',
          position: 'relative',
          display: 'flex',
          flexDirection: 'column',
          fontFamily: "'Hind Siliguri', sans-serif",
          color: '#333'
        }}
      >
        {/* Watermark */}
        <ImageWithFallback 
          src="/assets/img/logo-b.png" 
          alt="Watermark" 
          type="other"
          style={{
            position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)',
            width: '350px', opacity: 0.05, zIndex: 0, pointerEvents: 'none'
          }} 
        />

        {/* Header */}
        <div className="text-center border-bottom border-primary pb-3 mb-4" style={{ borderBottomWidth: '2px' }}>
          <ImageWithFallback src="/assets/img/logo-b.png" alt="Logo" style={{ height: '60px', width: 'auto', marginBottom: '5px' }} type="other" />
          <h3 style={{ margin: 0, color: '#333', fontSize: '24px', fontWeight: 'bold' }}>স্পিড নেট খুলনা</h3>
          <p style={{ margin: '2px 0', color: '#666', fontSize: '14px' }}>অফিসিয়াল ছুটির অনুমতি পত্র</p>
        </div>

        {/* Content */}
        <div style={{ flex: 1, lineHeight: 1.8, fontSize: '16px', textAlign: 'justify', position: 'relative', zIndex: 1 }}>
          <div className="d-flex justify-content-between mb-4" style={{ fontSize: '14px' }}>
            <div>সূত্র: SNKHL/HR/{moment().year()}/{String(info.id).padStart(4, '0')}</div>
            <div>তারিখ: <strong>{moment(info.action_at).format('DD MMM, YYYY')}</strong></div>
          </div>

          <p>
            বরাবর,<br/>
            <strong>{info.full_name}</strong><br/>
            পদবী: {info.designation}<br/>
            বিভাগ: {info.department}
          </p>

          <p style={{ marginTop: '5px' }}>
            আপনার আবেদনের প্রেক্ষিতে জানানো যাচ্ছে যে, কর্তৃপক্ষের সিদ্ধান্ত অনুযায়ী আপনার 
            {isMulti ? ' নিম্নোক্ত একাধিক ছুটির আবেদনসমূহ' : ' নিম্নোক্ত ছুটির আবেদনটি'} অনুমোদিত হয়েছে:
          </p>

          {isMulti ? (
            <table className="table table-bordered" style={{ borderColor: '#ddd' }}>
              <thead style={{ background: '#f9f9f9' }}>
                <tr>
                  <th>ক্রমিক</th>
                  <th>ছুটির ধরণ</th>
                  <th>তারিখ</th>
                  <th>অনুমোদিত দিন</th>
                </tr>
              </thead>
              <tbody>
                {leaves.map((lv, idx) => (
                  <tr key={lv.id}>
                    <td>{idx + 1}</td>
                    <td>{lv.type_name}</td>
                    <td>
                      {lv.is_half 
                        ? `${moment(lv.start_date).format('DD MMM, YYYY')} (হাফ ডে - ${lv.half_day_period === 'Morning' ? 'প্রথম ভাগ' : 'দ্বিতীয় ভাগ'})`
                        : `${moment(lv.start_date).format('DD MMM, YYYY')} - ${moment(lv.end_date).format('DD MMM, YYYY')}`
                      }
                    </td>
                    <td>{lv.day_count} দিন</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <table className="table table-bordered" style={{ borderColor: '#ddd' }}>
              <tbody>
                <tr>
                  <td style={{ background: '#f9f9f9', width: '35%', fontWeight: 'bold' }}>ছুটির ধরণ:</td>
                  <td>
                    {leaves[0].type_name}
                    {leaves[0].is_half && ` (${leaves[0].half_day_period === 'Morning' ? 'প্রথম ভাগ' : 'দ্বিতীয় ভাগ'})`}
                  </td>
                </tr>
                {leaves[0].is_half ? (
                  <tr>
                    <td style={{ background: '#f9f9f9', fontWeight: 'bold' }}>ছুটির তারিখ:</td>
                    <td>{moment(leaves[0].start_date).format('DD MMM, YYYY')}</td>
                  </tr>
                ) : (
                  <>
                    <tr>
                      <td style={{ background: '#f9f9f9', fontWeight: 'bold' }}>শুরুর তারিখ:</td>
                      <td>{moment(leaves[0].start_date).format('DD MMM, YYYY')}</td>
                    </tr>
                    <tr>
                      <td style={{ background: '#f9f9f9', fontWeight: 'bold' }}>শেষ তারিখ:</td>
                      <td>{moment(leaves[0].end_date).format('DD MMM, YYYY')}</td>
                    </tr>
                  </>
                )}
              </tbody>
            </table>
          )}

          <p dangerouslySetInnerHTML={{ __html: joiningText }}></p>
          <p>ভবিষ্যতে যেকোনো প্রয়োজনে কর্তৃপক্ষের সাথে যোগাযোগ করার পরামর্শ দেওয়া হলো। আপনার সুস্থতা কামনা করছি।</p>
        </div>

        {/* Footer */}
        <div className="mt-auto pt-5 pb-4">
          <div className="float-end text-center" style={{ width: '250px', position: 'relative' }}>
            {info.digital_seal && (
              <ImageWithFallback src={`/uploads/seals/${info.digital_seal}`} alt="Seal" style={{ width: '150px', position: 'absolute', bottom: '45px', left: '50%', transform: 'translateX(-50%)', opacity: 0.9, zIndex: 1 }} type="other" />
            )}
            <div style={{ marginTop: '60px', position: 'relative', zIndex: 2 }}>
              <hr style={{ border: 0, borderTop: '1px solid #000', marginBottom: '5px' }} />
              <strong>{info.admin_name}</strong><br/>
              <small>ব্যবস্থাপনা কর্তৃপক্ষ</small><br/>
              <small>স্পিড নেট খুলনা</small>
            </div>
          </div>
        </div>

        <div style={{ borderTop: '1px solid #eee', paddingTop: '10px', marginTop: '20px', textAlign: 'center', fontSize: '11px', color: '#888' }}>
          Speed Net Khulna | Head Office: Notun Bazar, Khulna | Email: info@speednetkhulna.com | Web: www.speednetkhulna.com
        </div>
      </div>
    </div>
  );
};

export default ApprovalLetter;