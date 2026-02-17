const fs = require('fs');
const path = require('path');
const pool = require('../utilities/db');

const dumpPath = process.argv[2];

if (!dumpPath) {
  console.error('Usage: node server/scripts/migrate-mysql-dump-to-postgres.js "<path-to-mysql-dump.sql>"');
  process.exit(1);
}

function splitSqlStatements(sql) {
  const statements = [];
  let current = '';
  let inSingle = false;
  let inDouble = false;
  let inLineComment = false;
  let inBlockComment = false;

  for (let i = 0; i < sql.length; i++) {
    const ch = sql[i];
    const next = sql[i + 1];
    const prev = sql[i - 1];

    if (inLineComment) {
      if (ch === '\n') inLineComment = false;
      continue;
    }

    if (inBlockComment) {
      if (ch === '*' && next === '/') {
        inBlockComment = false;
        i++;
      }
      continue;
    }

    if (!inSingle && !inDouble) {
      if (ch === '-' && next === '-') {
        inLineComment = true;
        i++;
        continue;
      }
      if (ch === '#') {
        inLineComment = true;
        continue;
      }
      if (ch === '/' && next === '*') {
        inBlockComment = true;
        i++;
        continue;
      }
    }

    if (ch === "'" && !inDouble && prev !== '\\') {
      inSingle = !inSingle;
      current += ch;
      continue;
    }
    if (ch === '"' && !inSingle && prev !== '\\') {
      inDouble = !inDouble;
      current += ch;
      continue;
    }

    if (ch === ';' && !inSingle && !inDouble) {
      const trimmed = current.trim();
      if (trimmed) statements.push(trimmed);
      current = '';
    } else {
      current += ch;
    }
  }

  const tail = current.trim();
  if (tail) statements.push(tail);
  return statements;
}

function normalizeStatement(stmt) {
  let s = stmt.trim();
  s = s.replace(/\r/g, '');
  return s;
}

function convertCreateTable(stmt) {
  let s = stmt;
  s = s.replace(/^CREATE TABLE\s+`([^`]+)`/i, 'CREATE TABLE "$1"');
  s = s.replace(/`([^`]+)`/g, '"$1"');
  s = s.replace(/\)\s*ENGINE=.*$/i, ')');
  s = s.replace(/\bDEFAULT CHARSET=[^\s,]+/gi, '');
  s = s.replace(/\bCHARACTER SET\s+[^\s,]+/gi, '');
  s = s.replace(/\bCOLLATE\s+[^\s,]+/gi, '');
  s = s.replace(/\bUNSIGNED\b/gi, '');
  s = s.replace(/\bAUTO_INCREMENT\b/gi, '');
  s = s.replace(/\s+COMMENT\s+'(?:\\'|[^'])*'/gi, '');
  s = s.replace(/\bON UPDATE CURRENT_TIMESTAMP\b/gi, '');
  s = s.replace(/\bcurrent_timestamp\(\)/gi, 'CURRENT_TIMESTAMP');
  s = s.replace(/\benum\s*\(([^)]+)\)/gi, 'text');
  s = s.replace(/\blongtext\b/gi, 'text');
  s = s.replace(/\bmediumtext\b/gi, 'text');
  s = s.replace(/\btinytext\b/gi, 'text');
  s = s.replace(/\bdatetime\b/gi, 'timestamp');
  s = s.replace(/\bdouble\b/gi, 'double precision');
  s = s.replace(/\bfloat\b/gi, 'double precision');
  s = s.replace(/\btinyint\s*\(\s*1\s*\)/gi, 'smallint');
  s = s.replace(/\bint\s*\(\s*\d+\s*\)/gi, 'integer');
  s = s.replace(/\bbigint\s*\(\s*\d+\s*\)/gi, 'bigint');
  s = s.replace(/\bsmallint\s*\(\s*\d+\s*\)/gi, 'smallint');
  s = s.replace(/\bdecimal\s*\(\s*(\d+)\s*,\s*(\d+)\s*\)/gi, 'numeric($1,$2)');
  s = s.replace(/,\s*\)/g, ')');
  return s;
}

function convertInsert(stmt) {
  let s = stmt;
  s = s.replace(/^INSERT INTO\s+`([^`]+)`/i, 'INSERT INTO "$1"');
  s = s.replace(/`([^`]+)`/g, '"$1"');
  s = s.replace(/'0000-00-00 00:00:00'/g, 'NULL');
  s = s.replace(/'0000-00-00'/g, 'NULL');
  return s;
}

function convertAlterAddKeys(stmt) {
  const tableMatch = stmt.match(/^ALTER TABLE\s+`([^`]+)`\s+([\s\S]+)$/i);
  if (!tableMatch) return [];
  const table = tableMatch[1];
  const body = tableMatch[2];
  const parts = body
    .split(/,\s*\n/)
    .map((p) => p.trim())
    .filter(Boolean);

  const out = [];
  for (const part of parts) {
    let p = part.replace(/`([^`]+)`/g, '"$1"');
    if (/^ADD PRIMARY KEY/i.test(p)) {
      out.push(`ALTER TABLE "${table}" ${p}`);
      continue;
    }
    const uniq = p.match(/^ADD UNIQUE KEY\s+"([^"]+)"\s*(\(.+\))$/i);
    if (uniq) {
      out.push(`ALTER TABLE "${table}" ADD CONSTRAINT "${uniq[1]}" UNIQUE ${uniq[2]}`);
      continue;
    }
    const key = p.match(/^ADD KEY\s+"([^"]+)"\s*(\(.+\))$/i);
    if (key) {
      out.push(`CREATE INDEX IF NOT EXISTS "${key[1]}" ON "${table}" ${key[2]}`);
    }
  }
  return out;
}

function convertAlterAutoIncrement(stmt) {
  const m = stmt.match(/^ALTER TABLE\s+`([^`]+)`\s+MODIFY\s+`id`.+AUTO_INCREMENT(?:,\s*AUTO_INCREMENT=(\d+))?/is);
  if (!m) return [];
  const table = m[1];
  const nextVal = m[2] ? parseInt(m[2], 10) : null;
  const seq = `${table}_id_seq`;
  const list = [
    `CREATE SEQUENCE IF NOT EXISTS "${seq}"`,
    `ALTER TABLE "${table}" ALTER COLUMN "id" SET DEFAULT nextval('"${seq}"')`,
    `ALTER SEQUENCE "${seq}" OWNED BY "${table}"."id"`,
  ];
  if (nextVal && Number.isFinite(nextVal)) {
    list.push(`SELECT setval('"${seq}"', ${nextVal}, false)`);
  } else {
    list.push(`SELECT setval('"${seq}"', COALESCE((SELECT MAX("id") FROM "${table}"), 1), true)`);
  }
  return list;
}

function convertAlterConstraint(stmt) {
  let s = stmt.replace(/^ALTER TABLE\s+`([^`]+)`/i, 'ALTER TABLE "$1"');
  s = s.replace(/`([^`]+)`/g, '"$1"');
  return [s];
}

function shouldSkip(stmt) {
  const s = stmt.trim().toUpperCase();
  return (
    s.startsWith('SET ') ||
    s.startsWith('START TRANSACTION') ||
    s.startsWith('COMMIT') ||
    s.startsWith('LOCK TABLES') ||
    s.startsWith('UNLOCK TABLES') ||
    s.startsWith('/*!')
  );
}

function buildExecutionPlan(statements) {
  const creates = [];
  const inserts = [];
  const keyAlters = [];
  const autoIncs = [];
  const fkAlters = [];

  for (const raw of statements) {
    const stmt = normalizeStatement(raw);
    if (!stmt || shouldSkip(stmt)) continue;

    if (/^CREATE TABLE\s+/i.test(stmt)) {
      creates.push(convertCreateTable(stmt));
      continue;
    }
    if (/^INSERT INTO\s+/i.test(stmt)) {
      inserts.push(convertInsert(stmt));
      continue;
    }
    if (/^ALTER TABLE\s+`[^`]+`\s+ADD\s+/i.test(stmt)) {
      keyAlters.push(...convertAlterAddKeys(stmt));
      continue;
    }
    if (/^ALTER TABLE\s+`[^`]+`\s+MODIFY\s+`id`/i.test(stmt)) {
      autoIncs.push(...convertAlterAutoIncrement(stmt));
      continue;
    }
    if (/^ALTER TABLE\s+`[^`]+`\s+ADD CONSTRAINT/i.test(stmt)) {
      fkAlters.push(...convertAlterConstraint(stmt));
    }
  }

  return [...creates, ...inserts, ...keyAlters, ...autoIncs, ...fkAlters];
}

async function run() {
  const abs = path.resolve(dumpPath);
  const sql = fs.readFileSync(abs, 'utf8');
  const statements = splitSqlStatements(sql);
  const plan = buildExecutionPlan(statements);

  const client = await pool.connect();
  try {
    console.log(`Parsed ${statements.length} raw statements.`);
    console.log(`Prepared ${plan.length} PostgreSQL statements.`);

    await client.query('BEGIN');
    await client.query('DROP SCHEMA IF EXISTS public CASCADE');
    await client.query('CREATE SCHEMA public');

    for (let i = 0; i < plan.length; i++) {
      const q = plan[i];
      try {
        await client.query(q);
      } catch (err) {
        console.error(`Failed at statement #${i + 1}`);
        console.error(q);
        throw err;
      }
    }

    await client.query('COMMIT');
    console.log('Migration completed successfully.');
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Migration failed. Rolled back.');
    throw err;
  } finally {
    client.release();
    await pool.end();
  }
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
