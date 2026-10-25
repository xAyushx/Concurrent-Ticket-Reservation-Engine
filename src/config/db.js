const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: Number(process.env.DB_PORT) || 3307,
  user: process.env.DB_USER || 'ticket',
  password: process.env.DB_PASSWORD || 'ticket_pw',
  database: process.env.DB_NAME || 'ticketing',
  connectionLimit: 20,
  timezone: 'Z',
});

module.exports = { pool };