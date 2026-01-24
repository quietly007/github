#!/usr/bin/env bash
# Gotify Notification Helper
# Usage: gotify-notify.sh <priority> <title> <message>
# Priority: 1-10 (1=low, 5=normal, 10=urgent)
#
# Created: 2026-01-12
# Purpose: Central notification for service alerts

set -euo pipefail

# Configuration
# Use docker internal network or localhost if running in container
GOTIFY_URL="${GOTIFY_URL:-http://gotify:80}"
TOKEN_FILE="/home/qui3tly/.secrets/gotify/alertmanager.token"

# If running from host (not container), use traefik domain
if [[ ! -f /.dockerenv ]]; then
    GOTIFY_URL="https://gotify.quietly.its.me"
fi

# Read token
if [[ ! -f "$TOKEN_FILE" ]]; then
    echo "ERROR: Token file not found: $TOKEN_FILE" >&2
    exit 1
fi
GOTIFY_TOKEN=$(cat "$TOKEN_FILE")

# Arguments
PRIORITY="${1:-5}"
TITLE="${2:-Alert}"
MESSAGE="${3:-No message provided}"

# Send notification
curl -s -X POST "${GOTIFY_URL}/message" \
    -H "X-Gotify-Key: ${GOTIFY_TOKEN}" \
    -F "title=${TITLE}" \
    -F "message=${MESSAGE}" \
    -F "priority=${PRIORITY}" \
    > /dev/null

echo "Notification sent: ${TITLE}"
