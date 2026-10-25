const express = require('express');
const { pool } = require('./config/db');

const app = express();
app.use(express.json());

app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', mysql: 'up' });
  } catch (err) {
    res.status(503).json({ status: 'down', mysql: 'down' });
  }
});

module.exports = app;