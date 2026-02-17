const pool = require('./utilities/db');
const fs = require('fs');
const path = require('path');

async function dump() {
    try {
        console.log('Starting DB Dump...');
        const tables = ['roles', 'users', 'departments', 'leaves', 'leave_submissions', 'notices', 'phone_directory'];
        let sql = '';

        for (const table of tables) {
            try {
                const res = await pool.query(`SELECT * FROM ${table}`);
                if (res.rows.length > 0) {
                    sql += `\n-- Data for ${table}\n`;
                    for (const row of res.rows) {
                        const keys = Object.keys(row);
                        const values = Object.values(row).map(v => {
                            if (v === null) return 'NULL';
                            if (typeof v === 'string') return `'${v.replace(/'/g, "''")}'`;
                            if (v instanceof Date) return `'${v.toISOString()}'`;
                            if (typeof v === 'object') return `'${JSON.stringify(v)}'`;
                            return v;
                        });
                        sql += `INSERT INTO ${table} (${keys.join(', ')}) VALUES (${values.join(', ')}) ON CONFLICT DO NOTHING;\n`;
                    }
                }
            } catch (e) {
                console.log(`Table ${table} might not exist or error: ${e.message}`);
            }
        }

        fs.writeFileSync(path.join(__dirname, 'data_dump.sql'), sql);
        console.log('Dump completed: server/data_dump.sql');
    } catch (err) {
        console.error('Dump failed:', err);
    } finally {
        await pool.end();
    }
}

dump();