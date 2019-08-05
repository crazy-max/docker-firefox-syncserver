#!/bin/sh

TZ=${TZ:-UTC}
FF_SYNCSERVER_ACCESSLOG=${FF_SYNCSERVER_ACCESSLOG:-false}
FF_SYNCSERVER_LOGLEVEL=${FF_SYNCSERVER_LOGLEVEL:-info}
FF_SYNCSERVER_PUBLIC_URL=${FF_SYNCSERVER_PUBLIC_URL:-http://localhost:5000/}
FF_SYNCSERVER_ALLOW_NEW_USERS=${FF_SYNCSERVER_ALLOW_NEW_USERS:-true}
FF_SYNCSERVER_FORCE_WSGI_ENVIRON=${FF_SYNCSERVER_FORCE_WSGI_ENVIRON:-false}
FF_SYNCSERVER_SQLURI=${FF_SYNCSERVER_SQLURI:-sqlite:///data/syncserver.db}

# Timezone
echo "Setting timezone to ${TZ}..."
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

# Check secret
echo "Checking prerequisites..."
if [ -z "$FF_SYNCSERVER_SECRET" ] ; then
  echo "FATAL: FF_SYNCSERVER_SECRET must be defined"
  exit 1
fi

SYNCSERVER_INI_PATH="/syncserver.ini"

GU_ACCESSLOG=-
if [ "$FF_SYNCSERVER_ACCESSLOG" != true ]; then
  GU_ACCESSLOG=None
fi

# Config
echo "Generating configuration..."
cat > "$SYNCSERVER_INI_PATH" <<EOL
[server:main]
use = egg:gunicorn
host = 0.0.0.0
port = 5000
workers = 1
timeout = 30
accesslog = ${GU_ACCESSLOG}
loglevel = ${FF_SYNCSERVER_LOGLEVEL}

[app:main]
use = egg:syncserver

[syncserver]
# This must be edited to point to the public URL of your server,
# i.e. the URL as seen by Firefox.
public_url = ${FF_SYNCSERVER_PUBLIC_URL}

# This defines the database in which to store all server data.
sqluri = ${FF_SYNCSERVER_SQLURI}

# This is a secret key used for signing authentication tokens.
# It should be long and randomly-generated.
# The following command will give a suitable value on *nix systems:
#
#    head -c 20 /dev/urandom | sha1sum
#
# If not specified then the server will generate a temporary one at startup.
secret = ${FF_SYNCSERVER_SECRET}

# Set this to "false" to disable new-user signups on the server.
# Only request by existing accounts will be honoured.
allow_new_users = ${FF_SYNCSERVER_ALLOW_NEW_USERS}

# Set this to "true" to work around a mismatch between public_url and
# the application URL as seen by python, which can happen in certain reverse-
# proxy hosting setups.  It will overwrite the WSGI environ dict with the
# details from public_url.  This could have security implications if e.g.
# you tell the app that it's on HTTPS but it's really on HTTP, so it should
# only be used as a last resort and after careful checking of server config.
force_wsgi_environ = ${FF_SYNCSERVER_FORCE_WSGI_ENVIRON}

# Uncomment and edit the following to use a local BrowserID verifier
# rather than posting assertions to the mozilla-hosted verifier.
# Audiences should be set to your public_url without a trailing slash.
#[browserid]
#backend = tokenserver.verifiers.LocalVerifier
#audiences = https://localhost:5000

EOL

if [ -n "$FF_SYNCSERVER_FORWARDED_ALLOW_IPS" ]; then
  cat >> "$SYNCSERVER_INI_PATH" <<EOL
# If you are running Nginx on a different host than the ff sync server the ff snyc server have to trust the X-Forwarded-* headers sent by Nginx.
forwarded_allow_ips = ${FF_SYNCSERVER_FORWARDED_ALLOW_IPS}
EOL
fi

exec "$@"
