#!/bin/bash
# Railway volume is mounted as root; fix ownership then drop to appuser for the app.
mkdir -p /app/auth_profiles/active /app/auth_profiles/saved /app/auth_profiles/backup \
         /app/logs /app/certs /app/browser_utils/custom_scripts
chown -R appuser:appgroup /app/auth_profiles /app/logs /app/certs \
         /app/browser_utils/custom_scripts 2>/dev/null || true
chmod -R 775 /app/auth_profiles 2>/dev/null || true
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/app.conf
