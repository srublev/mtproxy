#!/bin/sh
set -eu

USER_NAME="${USER_NAME:-nobody}"
PORT="${PORT:-8888}"
HTTP_PORT="${HTTP_PORT:-443}"
SECRET="${SECRET:?SECRET is required}"
AES_PWD_FILE="${AES_PWD_FILE:-/proxy-secret}"
CONFIG_FILE="${CONFIG_FILE:-/proxy-multi.conf}"
WORKERS="${WORKERS:-1}"
FAKE_TLS_DOMAIN="${FAKE_TLS_DOMAIN:-}"

if [ ! -f "$AES_PWD_FILE" ]; then
  echo "AES password file not found: $AES_PWD_FILE" >&2
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE" >&2
  exit 1
fi

case "$SECRET" in
  [0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\
[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\
[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]\
[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F])
    ;;
  *)
    echo "SECRET must be exactly 32 hex chars (16 bytes)" >&2
    exit 1
    ;;
esac

CLIENT_SECRET="$SECRET"

if [ -n "$FAKE_TLS_DOMAIN" ]; then
  DOMAIN_HEX="$(printf '%s' "$FAKE_TLS_DOMAIN" | od -An -tx1 -v | tr -d ' \n')"
  CLIENT_SECRET="ee${SECRET}${DOMAIN_HEX}"
  export CLIENT_SECRET
fi

set -- \
  /mtproto-proxy \
  -u "$USER_NAME" \
  -p "$PORT" \
  -H "$HTTP_PORT" \
  -S "$SECRET" \
  -M "$WORKERS" \
  --http-stats \
  --aes-pwd "$AES_PWD_FILE"

if [ -n "$FAKE_TLS_DOMAIN" ]; then
  set -- "$@" --domain "$FAKE_TLS_DOMAIN"
fi

set -- "$@" "$CONFIG_FILE"

echo "Server secret: $SECRET" >&2
if [ -n "$FAKE_TLS_DOMAIN" ]; then
  echo "Fake TLS domain: $FAKE_TLS_DOMAIN" >&2
  echo "Client secret: $CLIENT_SECRET" >&2
fi

exec "$@"
