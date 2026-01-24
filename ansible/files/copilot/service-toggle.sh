#!/bin/bash
# Service Toggle Script
# Switches a service between vpn-only and public middleware
# Usage: service-toggle.sh <service> <on|off>
#   on  = make public
#   off = lock to VPN-only

set -euo pipefail

SERVICE="$1"
ACTION="${2:-status}"

# Service to compose file mapping (MASTER services only!)
declare -A COMPOSE_FILES=(
    ["ansible"]="/home/qui3tly/.docker-compose/semaphore/docker-compose.yaml"
    ["gotify"]="/home/qui3tly/.docker-compose/gotify/docker-compose.yaml"
    ["pihole"]="/home/qui3tly/.docker-compose/pihole/docker-compose.yaml"
    ["it-tools"]="/home/qui3tly/.docker-compose/it-tools/docker-compose.yaml"
    ["headscale-ui"]="/home/qui3tly/.docker-compose/headscale-ui/docker-compose.yaml"
    ["headscale-admin"]="/home/qui3tly/.docker-compose/headscale-ui/docker-compose.yaml"
)

# Service to container name mapping
declare -A CONTAINER_NAMES=(
    ["ansible"]="semaphore"
    ["gotify"]="gotify"
    ["pihole"]="pihole"
    ["it-tools"]="it-tools"
    ["headscale-ui"]="headscale-ui"
    ["headscale-admin"]="headscale-admin"
)

# Service to router name mapping
declare -A ROUTER_NAMES=(
    ["ansible"]="semaphore-secure"
    ["gotify"]="gotify-secure"
    ["pihole"]="pihole"
    ["it-tools"]="it-tools-secure"
    ["headscale-ui"]="headscale-ui"
    ["headscale-admin"]="headscale-admin"
)

if [[ -z "${COMPOSE_FILES[$SERVICE]:-}" ]]; then
    echo "Unknown service: $SERVICE"
    echo "Available: ${!COMPOSE_FILES[*]}"
    exit 1
fi

COMPOSE_FILE="${COMPOSE_FILES[$SERVICE]}"
CONTAINER="${CONTAINER_NAMES[$SERVICE]}"
ROUTER="${ROUTER_NAMES[$SERVICE]}"

get_status() {
    if docker inspect "$CONTAINER" --format '{{json .Config.Labels}}' 2>/dev/null | grep -q '"public@file"'; then
        echo "PUBLIC"
    else
        echo "VPN-ONLY"
    fi
}

case "$ACTION" in
    on|public)
        echo "Making $SERVICE public..."
        # Replace vpn-only with public in compose file
        sed -i "s/vpn-only@file/public@file/g" "$COMPOSE_FILE"
        # Recreate container
        cd "$(dirname "$COMPOSE_FILE")"
        docker compose up -d --force-recreate
        echo "$SERVICE is now PUBLIC"
        ;;
    off|vpn)
        echo "Locking $SERVICE to VPN-only..."
        # Replace public with vpn-only in compose file
        sed -i "s/public@file/vpn-only@file/g" "$COMPOSE_FILE"
        # Recreate container
        cd "$(dirname "$COMPOSE_FILE")"
        docker compose up -d --force-recreate
        echo "$SERVICE is now VPN-ONLY"
        ;;
    status)
        echo "$SERVICE: $(get_status)"
        ;;
    *)
        echo "Usage: $0 <service> <on|off|status>"
        exit 1
        ;;
esac
