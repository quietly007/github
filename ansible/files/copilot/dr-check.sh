#!/bin/bash
# DR Check Script - Master agent verifies Lady's state
# Run from MASTER only
# Usage: ./dr-check.sh [full|quick|containers|config]

set -euo pipefail

HOSTNAME=$(hostname)
if [[ "$HOSTNAME" != quietly.its.me* ]]; then
    echo "ERROR: This script runs from MASTER (quietly.its.me) only!"
    exit 1
fi

TWIN="lady"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
REPORT_DIR="$HOME/.reports/dr"
REPORT_FILE="$REPORT_DIR/dr-check-$(date +%Y%m%d-%H%M%S).txt"

mkdir -p "$REPORT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "$1" | tee -a "$REPORT_FILE"; }
log_ok() { log "${GREEN}[✓]${NC} $1"; }
log_fail() { log "${RED}[✗]${NC} $1"; }
log_warn() { log "${YELLOW}[!]${NC} $1"; }
log_info() { log "${BLUE}[i]${NC} $1"; }

PASS=0
FAIL=0
WARN=0

check() {
    local name="$1"
    local cmd="$2"
    
    if eval "$cmd" &>/dev/null; then
        log_ok "$name"
        ((PASS++))
    else
        log_fail "$name"
        ((FAIL++))
    fi
}

header() {
    log ""
    log "${CYAN}═══ $1 ═══${NC}"
}

#=== MAIN ===

log "${CYAN}"
log "╔═══════════════════════════════════════════════════════════════╗"
log "║              🔄 DISASTER RECOVERY CHECK 🔄                     ║"
log "║                                                                ║"
log "║   Master: quietly.its.me                                       ║"
log "║   Clone:  quietly.online (lady)                                ║"
log "║   Time:   $TIMESTAMP                              ║"
log "╚═══════════════════════════════════════════════════════════════╝"
log "${NC}"

#--- Quick connectivity ---
header "CONNECTIVITY"
check "SSH to Lady" "ssh $TWIN 'echo ok'"
check "Tailscale tunnel" "tailscale ping -c 1 lady"

if ! ssh $TWIN 'echo ok' &>/dev/null; then
    log_fail "Cannot reach Lady! Aborting DR check."
    exit 1
fi

#--- Container comparison ---
header "CONTAINER STATE"

MASTER_CONTAINERS=$(docker ps --format '{{.Names}}' | sort)
LADY_CONTAINERS=$(ssh $TWIN "docker ps --format '{{.Names}}'" | sort)

MASTER_COUNT=$(echo "$MASTER_CONTAINERS" | wc -l)
LADY_COUNT=$(echo "$LADY_CONTAINERS" | wc -l)

log_info "Master: $MASTER_COUNT containers"
log_info "Lady: $LADY_COUNT containers"

# Find differences
ONLY_MASTER=$(comm -23 <(echo "$MASTER_CONTAINERS") <(echo "$LADY_CONTAINERS"))
ONLY_LADY=$(comm -13 <(echo "$MASTER_CONTAINERS") <(echo "$LADY_CONTAINERS"))

if [[ -z "$ONLY_MASTER" ]] && [[ -z "$ONLY_LADY" ]]; then
    log_ok "Container lists match"
else
    if [[ -n "$ONLY_MASTER" ]]; then
        log_warn "Only on Master: $ONLY_MASTER"
        ((WARN++))
    fi
    if [[ -n "$ONLY_LADY" ]]; then
        log_warn "Only on Lady: $ONLY_LADY"
        ((WARN++))
    fi
fi

# Check container health
log ""
log_info "Container health comparison:"
for container in $MASTER_CONTAINERS; do
    MASTER_STATUS=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null || echo "missing")
    LADY_STATUS=$(ssh $TWIN "docker inspect --format='{{.State.Status}}' '$container'" 2>/dev/null || echo "missing")
    
    if [[ "$MASTER_STATUS" == "running" ]] && [[ "$LADY_STATUS" == "running" ]]; then
        log_ok "$container: running on both"
    elif [[ "$LADY_STATUS" == "missing" ]]; then
        log_warn "$container: missing on Lady"
        ((WARN++))
    else
        log_warn "$container: Master=$MASTER_STATUS Lady=$LADY_STATUS"
        ((WARN++))
    fi
done

#--- Image versions ---
header "IMAGE VERSIONS"

for container in traefik grafana prometheus loki pihole portainer; do
    MASTER_IMG=$(docker inspect --format='{{.Config.Image}}' "$container" 2>/dev/null || echo "N/A")
    LADY_IMG=$(ssh $TWIN "docker inspect --format='{{.Config.Image}}' '$container'" 2>/dev/null || echo "N/A")
    
    if [[ "$MASTER_IMG" == "$LADY_IMG" ]]; then
        log_ok "$container: $MASTER_IMG"
    else
        log_warn "$container: Master=$MASTER_IMG Lady=$LADY_IMG"
        ((WARN++))
    fi
done

#--- Config sync ---
header "CONFIG SYNC"

# Compare compose file counts
MASTER_COMPOSE=$(find ~/.docker-compose -name "*.yaml" -o -name "*.yml" 2>/dev/null | wc -l)
LADY_COMPOSE=$(ssh $TWIN "find ~/.docker-compose -name '*.yaml' -o -name '*.yml' 2>/dev/null | wc -l")

if [[ "$MASTER_COMPOSE" == "$LADY_COMPOSE" ]]; then
    log_ok "Compose file count matches ($MASTER_COMPOSE)"
else
    log_warn "Compose files: Master=$MASTER_COMPOSE Lady=$LADY_COMPOSE"
    ((WARN++))
fi

# Check secrets exist
MASTER_SECRETS=$(find ~/.secrets -type f 2>/dev/null | wc -l)
LADY_SECRETS=$(ssh $TWIN "find ~/.secrets -type f 2>/dev/null | wc -l")

if [[ "$MASTER_SECRETS" == "$LADY_SECRETS" ]]; then
    log_ok "Secrets count matches ($MASTER_SECRETS)"
else
    log_warn "Secrets: Master=$MASTER_SECRETS Lady=$LADY_SECRETS"
    ((WARN++))
fi

#--- Memories sync ---
header "AGENT MEMORIES"

MASTER_MEM=$(wc -l < ~/.copilot/memories.jsonl)
LADY_MEM=$(ssh $TWIN "wc -l < ~/.copilot/memories.jsonl 2>/dev/null || echo 0")

log_info "Master memories: $MASTER_MEM entries"
log_info "Lady memories: $LADY_MEM entries"

MASTER_LAST=$(tail -1 ~/.copilot/memories.jsonl | jq -r '.ts // "unknown"')
LADY_LAST=$(ssh $TWIN "tail -1 ~/.copilot/memories.jsonl 2>/dev/null" | jq -r '.ts // "unknown"')

log_info "Master last entry: $MASTER_LAST"
log_info "Lady last entry: $LADY_LAST"

#--- Services check ---
header "KEY SERVICES"

check "Lady Traefik responds" "curl -sf -o /dev/null https://lady:443 || curl -sf -o /dev/null http://lady:80"
check "Lady Portainer API" "curl -sf -o /dev/null -k https://lady:9443"
check "Lady Pi-hole DNS" "dig @lady +short google.com"

#--- Disk space ---
header "DISK SPACE"

MASTER_DISK=$(df -h / | tail -1 | awk '{print $5}')
LADY_DISK=$(ssh $TWIN "df -h / | tail -1 | awk '{print \$5}'")

log_info "Master: $MASTER_DISK used"
log_info "Lady: $LADY_DISK used"

#--- Summary ---
log ""
log "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
log ""

TOTAL=$((PASS + FAIL + WARN))

if [[ $FAIL -eq 0 ]] && [[ $WARN -eq 0 ]]; then
    log "${GREEN}🎉 DR CHECK PASSED! ($PASS/$TOTAL checks)${NC}"
    log ""
    log "Lady is ready to take over if Master fails!"
    RESULT="PASS"
elif [[ $FAIL -eq 0 ]]; then
    log "${YELLOW}⚠️  DR CHECK PASSED WITH WARNINGS ($PASS passed, $WARN warnings)${NC}"
    log ""
    log "Lady can take over but some differences exist."
    RESULT="WARN"
else
    log "${RED}❌ DR CHECK FAILED! ($PASS passed, $FAIL failed, $WARN warnings)${NC}"
    log ""
    log "Lady is NOT ready for failover! Fix issues first."
    RESULT="FAIL"
fi

log ""
log "Report saved: $REPORT_FILE"

# Log to memories
cat >> ~/.copilot/memories.jsonl << EOF
{"ts":"$TIMESTAMP","action":"dr-check","target":"lady","result":"$RESULT - $PASS pass, $FAIL fail, $WARN warn"}
EOF

# Sync summary to Lady's memories
ssh $TWIN "cat >> ~/.copilot/memories.jsonl << EOF
{\"ts\":\"$TIMESTAMP\",\"action\":\"dr-check-received\",\"target\":\"from-master\",\"result\":\"$RESULT - checked by master agent\"}
EOF"

log ""
log "Both agents' memories updated."
