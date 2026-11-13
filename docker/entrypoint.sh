#!/bin/bash
# Railway volume is mounted as root; fix ownership then drop to appuser for the app.
mkdir -p /app/auth_profiles/active /app/auth_profiles/saved /app/auth_profiles/backup \
         /app/logs /app/certs /app/browser_utils/custom_scripts
chown -R appuser:appgroup /app/auth_profiles /app/logs /app/certs \
         /app/browser_utils/custom_scripts 2>/dev/null || true
chmod -R 775 /app/auth_profiles 2>/dev/null || true
# Seed an auth profile from AUTH_JSON when the volume has none yet.
if [ -n "$AUTH_JSON" ] && ! ls /app/auth_profiles/active/*.json >/dev/null 2>&1; then
  printf '%s' "$AUTH_JSON" > /app/auth_profiles/active/env_auth.json
  chown appuser:appgroup /app/auth_profiles/active/env_auth.json
  chmod 600 /app/auth_profiles/active/env_auth.json
fi
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/app.conf
