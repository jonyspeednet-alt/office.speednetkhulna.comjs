const { Pool } = require('pg');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'speednet_office',
  password: process.env.DB_PASSWORD || '',
  port: process.env.DB_PORT || 5432,
});

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