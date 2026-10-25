const fs = require('node:fs');
const path = require('node:path');
const mysql = require('mysql2/promise');

async function main() {
  const conn = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT) || 3307,
    user: process.env.DB_USER || 'ticket',
    password: process.env.DB_PASSWORD || 'ticket_pw',
    database: process.env.DB_NAME || 'ticketing',
    multipleStatements: true, // lets one .sql file contain many statements
  });

  await conn.query(`
    CREATE TABLE IF NOT EXISTS schema_migrations (
      name VARCHAR(255) PRIMARY KEY,
      applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )`);

  const [rows] = await conn.query('SELECT name FROM schema_migrations');
  const applied = new Set(rows.map((r) => r.name));

  const dir = path.join(__dirname, '..', 'migrations');
  const files = fs.readdirSync(dir).filter((f) => f.endsWith('.sql')).sort();

  for (const file of files) {
    if (applied.has(file)) continue;
    console.log('applying', file);
    await conn.query(fs.readFileSync(path.join(dir, file), 'utf8'));
    await conn.query('INSERT INTO schema_migrations (name) VALUES (?)', [file]);
  }

  console.log('migrations up to date');
  await conn.end();
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});