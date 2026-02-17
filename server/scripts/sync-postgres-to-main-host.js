const { spawn } = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.resolve(__dirname, '../../.env') });
dotenv.config({ path: path.resolve(__dirname, '../.env'), override: false });

function getConfig(prefix, fallback = {}) {
  return {
    host: process.env[`${prefix}_HOST`] || fallback.host || 'localhost',
    port: process.env[`${prefix}_PORT`] || fallback.port || '5432',
    user: process.env[`${prefix}_USER`] || fallback.user || 'postgres',
    password: process.env[`${prefix}_PASSWORD`] || fallback.password || '',
    database: process.env[`${prefix}_NAME`] || fallback.database || '',
  };
}

function requireConfig(cfg, label) {
  const missing = [];
  if (!cfg.host) missing.push('HOST');
  if (!cfg.port) missing.push('PORT');
  if (!cfg.user) missing.push('USER');
  if (!cfg.database) missing.push('NAME');

  if (missing.length) {
    throw new Error(`${label} config missing: ${missing.join(', ')}`);
  }
}

function runCommand(cmd, args, extraEnv = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, {
      stdio: 'inherit',
      env: { ...process.env, ...extraEnv },
      shell: false,
    });

    child.on('error', (err) => {
      reject(new Error(`Failed to run "${cmd}": ${err.message}`));
    });

    child.on('close', (code) => {
      if (code === 0) {
        resolve();
      } else {
        reject(new Error(`"${cmd}" exited with code ${code}`));
      }
    });
  });
}

async function main() {
  const source = getConfig('SRC_DB', {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
  });

  const target = getConfig('MAIN_DB');

  requireConfig(source, 'Source DB');
  requireConfig(target, 'Main host DB');

  const dumpFile = path.join(
    os.tmpdir(),
    `pg-sync-${source.database}-${Date.now()}.sql`
  );

  try {
    console.log('1/3 Dumping source database...');
    await runCommand(
      'pg_dump',
      [
        '-h',
        source.host,
        '-p',
        String(source.port),
        '-U',
        source.user,
        '-d',
        source.database,
        '--clean',
        '--if-exists',
        '--no-owner',
        '--no-privileges',
        '-f',
        dumpFile,
      ],
      { PGPASSWORD: source.password }
    );

    console.log('2/3 Restoring dump into main host database...');
    await runCommand(
      'psql',
      [
        '-h',
        target.host,
        '-p',
        String(target.port),
        '-U',
        target.user,
        '-d',
        target.database,
        '-v',
        'ON_ERROR_STOP=1',
        '-f',
        dumpFile,
      ],
      { PGPASSWORD: target.password }
    );

    console.log('3/3 Sync completed successfully.');
    console.log(`Source: ${source.host}:${source.port}/${source.database}`);
    console.log(`Target: ${target.host}:${target.port}/${target.database}`);
  } finally {
    if (fs.existsSync(dumpFile)) {
      fs.unlinkSync(dumpFile);
    }
  }
}

main().catch((err) => {
  console.error('Database sync failed:', err.message);
  process.exit(1);
});
