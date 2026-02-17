const fs = require('fs');
const path = require('path');

const input = process.argv[2];
const output = process.argv[3];

if (!input) {
  console.error(
    'Usage: node server/scripts/sanitize-pg-dump-for-old-postgres.js <input.sql> [output.sql]'
  );
  process.exit(1);
}

const inFile = path.resolve(input);
const outFile = output ? path.resolve(output) : inFile;

let sql = fs.readFileSync(inFile, 'utf8');

const removals = [
  /^\s*\\restrict.*\r?\n/gm,
  /^\s*\\unrestrict.*\r?\n/gm,
  /^\s*SET\s+statement_timeout\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+lock_timeout\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+idle_in_transaction_session_timeout\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+transaction_timeout\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+check_function_bodies\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+xmloption\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+client_min_messages\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+row_security\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*SET\s+default_table_access_method\s*=\s*[^;]+;\r?\n/gmi,
  /^\s*COMMENT\s+ON\s+SCHEMA\s+public\s+IS\s+.*;\r?\n/gmi,
];

for (const pattern of removals) {
  sql = sql.replace(pattern, '');
}

// PostgreSQL < 11 compatibility
sql = sql.replace(/\bEXECUTE\s+FUNCTION\b/gmi, 'EXECUTE PROCEDURE');

fs.writeFileSync(outFile, sql, 'utf8');
console.log(`Sanitized dump written to: ${outFile}`);
