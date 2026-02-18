const { Pool } = require('pg');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const isProd = process.env.NODE_ENV === 'production';

// Preference: Use MAIN_DB credentials if available in production
const dbConfig = {
  user: (isProd && process.env.MAIN_DB_USER) ? process.env.MAIN_DB_USER : (process.env.DB_USER || 'postgres'),
  host: (isProd && process.env.MAIN_DB_HOST) ? process.env.MAIN_DB_HOST : (process.env.DB_HOST || 'localhost'),
  database: (isProd && process.env.MAIN_DB_NAME) ? process.env.MAIN_DB_NAME : (process.env.DB_NAME || 'speednet_office'),
  password: (isProd && process.env.MAIN_DB_PASSWORD) ? process.env.MAIN_DB_PASSWORD : (process.env.DB_PASSWORD || ''),
  port: (isProd && process.env.MAIN_DB_PORT) ? process.env.MAIN_DB_PORT : (process.env.DB_PORT || 5432),
  
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
};

// Log the connection target (without password)
console.log(`[DB] Target: ${dbConfig.database} on ${dbConfig.host} as ${dbConfig.user}`);

const pool = new Pool(dbConfig);

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
});

pool.on('connect', (client) => {
  client.query("SET timezone TO 'Asia/Dhaka'").catch(err => {
    console.error('Error setting DB timezone:', err);
  });
});

module.exports = pool;
