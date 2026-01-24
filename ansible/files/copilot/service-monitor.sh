#!/usr/bin/env bash
# Service Health Monitor with Notifications
# Checks critical services and sends alerts via Gotify
#
# Created: 2026-01-12
# Usage: Run via systemd timer or cron

set -euo pipefail

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
NOTIFY_SCRIPT="${SCRIPT_DIR}/gotify-notify.sh"
LOG_FILE="/home/qui3tly/.copilot/logging/service-monitor.log"
MEMORY_FILE="/home/qui3tly/.copilot/memories.jsonl"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] $*" | tee -a "$LOG_FILE"
}

alert() {
    local priority=$1
    local title=$2
    local message=$3
    
    log "ALERT: $title - $message"
    
    if [[ -x "$NOTIFY_SCRIPT" ]]; then
        "$NOTIFY_SCRIPT" "$priority" "$title" "$message" || true
    fi
    
    # Log to memories
    echo "{\"ts\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"action\":\"SERVICE_ALERT\",\"target\":\"$title\",\"result\":\"$message\"}" >> "$MEMORY_FILE"
}

# Critical systemd services
# NOTE: FRR removed 2026-01-13 (OSPF was too complex, now using Tailscale subnet routing)
# NOTE: headscale added 2026-01-13 (now native on Master instead of Docker on Lady)
SYSTEMD_SERVICES=(
    "fail2ban"
    "ssh"
    "docker"
    "tailscaled"
    "wg-quick@wg0"
    "headscale"
)

# Critical Docker containers
DOCKER_CONTAINERS=(
    "traefik"
    "pihole"
    "authelia"
    "gotify"
    "portainer"
    "grafana"
)

ISSUES_FOUND=0

log "=== Service Health Check Started ==="

# Check systemd services
for service in "${SYSTEMD_SERVICES[@]}"; do
    if ! systemctl is-active --quiet "$service" 2>/dev/null; then
        alert 8 "Service Down" "$service is not running on $(hostname)"
        ((ISSUES_FOUND++))
    fi
done

# Check Docker containers
for container in "${DOCKER_CONTAINERS[@]}"; do
    status=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null || echo "missing")
    if [[ "$status" != "running" ]]; then
        alert 8 "Container Down" "$container is $status on $(hostname)"
        ((ISSUES_FOUND++))
    fi
    
    # Check health if available
    health=$(docker inspect -f '{{.State.Health.Status}}' "$container" 2>/dev/null || echo "none")
    if [[ "$health" == "unhealthy" ]]; then
        alert 7 "Container Unhealthy" "$container is unhealthy on $(hostname)"
        ((ISSUES_FOUND++))
    fi
done

# Check disk space (alert if >85%)
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [[ "$DISK_USAGE" -gt 85 ]]; then
    alert 9 "Disk Space Critical" "Root filesystem at ${DISK_USAGE}% on $(hostname)"
    ((ISSUES_FOUND++))
fi

# Check memory (alert if <10% free)
MEM_FREE=$(free | awk '/^Mem:/ {print int($7/$2 * 100)}')
if [[ "$MEM_FREE" -lt 10 ]]; then
    alert 8 "Memory Low" "Only ${MEM_FREE}% memory available on $(hostname)"
    ((ISSUES_FOUND++))
fi

# Check load average
LOAD=$(awk '{print $1}' /proc/loadavg)
CORES=$(nproc)
LOAD_INT=${LOAD%.*}
if [[ "$LOAD_INT" -gt "$((CORES * 2))" ]]; then
    alert 7 "High Load" "Load average ${LOAD} (${CORES} cores) on $(hostname)"
    ((ISSUES_FOUND++))
fi

log "=== Service Health Check Complete: ${ISSUES_FOUND} issues found ==="

exit 0
