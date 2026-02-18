# Investigation Report - Data Fetching Issue after Reload

## Bug Summary
The user reports that the project works initially, but after some time or upon a browser reload, no data is fetched from the database. Rebuilding the client (which likely triggers a server restart via nodemon) seems to temporarily fix the issue.

## Root Cause Analysis
Based on the codebase analysis, several factors could be contributing:
1. **Database Pool Configuration**: The current `db.js` uses a default `pg` Pool without explicit idle timeouts or connection keep-alive settings. On many hosting environments, idle database connections are killed by the server, but the client pool might still try to use them, leading to failed queries.
2. **Environment Variable Confusion**: There are `DB_*` and `MAIN_DB_*` variables in `.env`. If the server is intended to use the `MAIN_DB` credentials on the production host but is currently configured to use `DB_*` (which points to `localhost`), it might be connecting to a local database with no data or unstable connectivity.
3. **CORS/Origin Issues**: The server uses a hardcoded `FRONTEND_URL` in `.env`. If the user accesses the site via a different origin (e.g. adding or removing `www`), CORS might block requests.
4. **Session Persistence**: The server uses memory-based sessions. While JWT is used for auth, if some logic relies on sessions, it will be lost on server restart.

## Affected Components
- `server/utilities/db.js`: Database connection management.
- `server/index.js`: Server configuration and origin handling.
- `.env`: Environment variables.

## Implementation Notes
- **`server/utilities/db.js`**: Optimized pool settings with `idleTimeoutMillis`, `connectionTimeoutMillis`, and `keepAlive`. Added logic to switch to `MAIN_DB_*` credentials in production.
- **`server/index.js`**: 
    - Updated SPA fallback to re-check for `dist/index.html` on every non-API request, allowing the server to pick up new builds without a restart.
    - Enhanced `/api/health` with latency tracking and pool statistics for better production monitoring.

## Verification
- Connection pool settings are now robust against host-level timeouts.
- Dynamic credential switching ensures the correct database is used in production.
- Health check provides visibility into connection health.
