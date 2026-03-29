#!/bin/sh
set -eu

USER_NAME="${USER_NAME:-nobody}"
PORT="${PORT:-8888}"
HTTP_PORT="${HTTP_PORT:-443}"
SECRET="${SECRET:?SECRET is required}"
AES_PWD_FILE="${AES_PWD_FILE:-/proxy-secret}"
CONFIG_FILE="${CONFIG_FILE:-/proxy-multi.conf}"
WORKERS="${WORKERS:-1}"

if [ ! -f "$AES_PWD_FILE" ]; then
  echo "AES password file not found: $AES_PWD_FILE" >&2
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE" >&2
  exit 1
fi

exec /mtproto-proxy \
  -u "$USER_NAME" \
  -p "$PORT" \
  -H "$HTTP_PORT" \
  -S "$SECRET" \
  -M "$WORKERS" \
  --http-stats \
  --aes-pwd "$AES_PWD_FILE" \
  "$CONFIG_FILE" 
