import React, { useState, useEffect } from 'react';

const ImageWithFallback = ({ 
  src, 
  alt, 
  fallbackSrc, 
  fallbackName, 
  className, 
  style, 
  width, 
  height,
  type = 'profile' // 'profile' or 'nid' or 'other'
}) => {
  const [imgSrc, setImgSrc] = useState(src);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    setImgSrc(src);
    setIsError(false);
  }, [src]);

  const handleError = () => {
    if (isError) return; // Prevent infinite loop if fallback also fails

    setIsError(true);
    
    if (fallbackSrc) {
      setImgSrc(fallbackSrc);
    } else if (fallbackName) {
      setImgSrc(`https://ui-avatars.com/api/?name=${encodeURIComponent(fallbackName)}&size=200&background=4e73df&color=fff&bold=true`);
    } else {
      // Default placeholder based on type
      if (type === 'profile') {
        setImgSrc('https://ui-avatars.com/api/?name=User&size=200&background=4e73df&color=fff&bold=true');
      } else {
        setImgSrc('https://via.placeholder.com/400x250?text=No+Image');
      }
    }
  };

  const defaultStyle = {
    objectFit: 'cover',
    width: width || '100%',
    height: height || 'auto',
    ...style
  };

  return (
    <img
      src={imgSrc || (fallbackName ? `https://ui-avatars.com/api/?name=${encodeURIComponent(fallbackName)}&size=200&background=4e73df&color=fff&bold=true` : 'https://via.placeholder.com/400x250?text=No+Image')}
      alt={alt}
      className={className}
      style={defaultStyle}
      onError={handleError}
    />
  );
};

export default ImageWithFallback;
