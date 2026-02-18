const { Pool } = require('pg');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const isProd = process.env.NODE_ENV === 'production';

// Preference: Use MAIN_DB credentials if available in production
const dbConfig = {
  user: (isProd && process.env.MAIN_DB_USER) || process.env.DB_USER || 'postgres',
  host: (isProd && process.env.MAIN_DB_HOST) || process.env.DB_HOST || 'localhost',
  database: (isProd && process.env.MAIN_DB_NAME) || process.env.DB_NAME || 'speednet_office',
  password: (isProd && process.env.MAIN_DB_PASSWORD) || process.env.DB_PASSWORD || '',
  port: (isProd && process.env.MAIN_DB_PORT) || process.env.DB_PORT || 5432,
  
  // Optimized Pool Settings for Stability on Shared/Cloud Hosting
  max: 20, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000, // Close idle clients after 30 seconds
  connectionTimeoutMillis: 10000, // Return an error after 10 seconds if connection cannot be established
  keepAlive: true, // Keep the connection alive
};

const pool = new Pool(dbConfig);

pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
});

// Set timezone to Asia/Dhaka for each new client connection
// This replicates: $conn->exec("SET time_zone = '+06:00'");
pool.on('connect', (client) => {
  client.query("SET timezone TO 'Asia/Dhaka'", (err) => {
    if (err) {
      console.error('Error setting DB timezone:', err);
    }
  });
});

module.exports = pool;
