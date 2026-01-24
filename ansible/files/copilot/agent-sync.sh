#!/bin/bash
# Agent Sync Script - Communication between Master and Lady agents
# Usage: ./agent-sync.sh [command]
#
# Commands:
#   compare     - Compare container states between servers
#   sync-check  - Check if configs are in sync
#   messages    - Show inter-agent messages
#   send        - Send message to other agent
#   status      - Full status of both servers

set -euo pipefail

# Determine which server we're on
HOSTNAME=$(hostname)
if [[ "$HOSTNAME" == quietly.its.me* ]]; then
    ME="quietly"
    TWIN="lady"
    MY_DOMAIN="quietly.its.me"
    TWIN_DOMAIN="quietly.online"
elif [[ "$HOSTNAME" == quietly.online* ]]; then
    ME="lady"
    TWIN="quietly"
    MY_DOMAIN="quietly.online"
    TWIN_DOMAIN="quietly.its.me"
else
    echo "ERROR: Unknown host $HOSTNAME"
    exit 1
fi

MESSAGES_FILE="$HOME/.copilot/agent-messages.jsonl"
MEMORIES_FILE="$HOME/.copilot/memories.jsonl"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

cmd_compare() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "  CONTAINER COMPARISON: $ME vs $TWIN"
    echo "═══════════════════════════════════════════════════════════════"
    
    # Get local containers
    LOCAL=$(docker ps --format '{{.Names}}:{{.Image}}' | sort)
    
    # Get remote containers
    if ! REMOTE=$(ssh "$TWIN" "docker ps --format '{{.Names}}:{{.Image}}'" 2>/dev/null | sort); then
        log_error "Cannot reach $TWIN via SSH"
        return 1
    fi
    
    echo ""
    echo "📦 $ME containers:"
    echo "$LOCAL" | while read line; do echo "  $line"; done
    
    echo ""
    echo "📦 $TWIN containers:"
    echo "$REMOTE" | while read line; do echo "  $line"; done
    
    echo ""
    echo "🔍 Differences:"
    
    # Find containers only on local
    ONLY_LOCAL=$(comm -23 <(echo "$LOCAL" | cut -d: -f1) <(echo "$REMOTE" | cut -d: -f1))
    if [[ -n "$ONLY_LOCAL" ]]; then
        log_warn "Only on $ME:"
        echo "$ONLY_LOCAL" | while read c; do echo "  - $c"; done
    fi
    
    # Find containers only on remote
    ONLY_REMOTE=$(comm -13 <(echo "$LOCAL" | cut -d: -f1) <(echo "$REMOTE" | cut -d: -f1))
    if [[ -n "$ONLY_REMOTE" ]]; then
        log_warn "Only on $TWIN:"
        echo "$ONLY_REMOTE" | while read c; do echo "  - $c"; done
    fi
    
    # Check for version differences
    echo ""
    echo "🏷️  Version comparison:"
    comm -12 <(echo "$LOCAL" | cut -d: -f1) <(echo "$REMOTE" | cut -d: -f1) | while read name; do
        LOCAL_IMG=$(echo "$LOCAL" | grep "^$name:" | cut -d: -f2-)
        REMOTE_IMG=$(echo "$REMOTE" | grep "^$name:" | cut -d: -f2-)
        if [[ "$LOCAL_IMG" == "$REMOTE_IMG" ]]; then
            log_ok "$name: $LOCAL_IMG"
        else
            log_warn "$name: $ME=$LOCAL_IMG vs $TWIN=$REMOTE_IMG"
        fi
    done
    
    if [[ -z "$ONLY_LOCAL" ]] && [[ -z "$ONLY_REMOTE" ]]; then
        echo ""
        log_ok "Containers are in sync! ✅"
    fi
}

cmd_sync_check() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "  CONFIG SYNC CHECK: $ME vs $TWIN"
    echo "═══════════════════════════════════════════════════════════════"
    
    # Check compose files
    echo ""
    echo "📁 Compose files comparison:"
    
    LOCAL_COMPOSE=$(find ~/.docker-compose -name "docker-compose.yaml" -o -name "docker-compose.yml" 2>/dev/null | sort)
    REMOTE_COMPOSE=$(ssh "$TWIN" "find ~/.docker-compose -name 'docker-compose.yaml' -o -name 'docker-compose.yml' 2>/dev/null" | sort)
    
    LOCAL_COUNT=$(echo "$LOCAL_COMPOSE" | wc -l)
    REMOTE_COUNT=$(echo "$REMOTE_COMPOSE" | wc -l)
    
    echo "  $ME: $LOCAL_COUNT compose files"
    echo "  $TWIN: $REMOTE_COUNT compose files"
    
    # Check memories sync
    echo ""
    echo "🧠 Memories comparison:"
    LOCAL_MEM=$(wc -l < "$MEMORIES_FILE" 2>/dev/null || echo 0)
    REMOTE_MEM=$(ssh "$TWIN" "wc -l < ~/.copilot/memories.jsonl 2>/dev/null || echo 0")
    
    echo "  $ME: $LOCAL_MEM entries"
    echo "  $TWIN: $REMOTE_MEM entries"
    
    # Last activity
    echo ""
    echo "⏰ Last activity:"
    LOCAL_LAST=$(tail -1 "$MEMORIES_FILE" 2>/dev/null | jq -r '.ts // "unknown"')
    REMOTE_LAST=$(ssh "$TWIN" "tail -1 ~/.copilot/memories.jsonl 2>/dev/null" | jq -r '.ts // "unknown"')
    
    echo "  $ME: $LOCAL_LAST"
    echo "  $TWIN: $REMOTE_LAST"
}

cmd_messages() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "  INTER-AGENT MESSAGES"
    echo "═══════════════════════════════════════════════════════════════"
    
    echo ""
    echo "📨 Messages TO me ($ME):"
    ssh "$TWIN" "cat ~/.copilot/agent-messages.jsonl 2>/dev/null" | grep "\"to\":\"$ME\"" | tail -10 | while read line; do
        TS=$(echo "$line" | jq -r '.ts')
        FROM=$(echo "$line" | jq -r '.from')
        MSG=$(echo "$line" | jq -r '.msg')
        echo "  [$TS] $FROM: $MSG"
    done
    
    echo ""
    echo "📤 Messages FROM me ($ME):"
    cat "$MESSAGES_FILE" 2>/dev/null | grep "\"from\":\"$ME\"" | tail -10 | while read line; do
        TS=$(echo "$line" | jq -r '.ts')
        TO=$(echo "$line" | jq -r '.to')
        MSG=$(echo "$line" | jq -r '.msg')
        echo "  [$TS] → $TO: $MSG"
    done
}

cmd_send() {
    if [[ -z "${1:-}" ]]; then
        echo "Usage: $0 send \"Your message here\""
        exit 1
    fi
    
    MSG="$1"
    TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    echo "{\"ts\":\"$TS\",\"from\":\"$ME\",\"to\":\"$TWIN\",\"msg\":\"$MSG\"}" >> "$MESSAGES_FILE"
    log_ok "Message sent to $TWIN: $MSG"
}

cmd_status() {
    echo "═══════════════════════════════════════════════════════════════"
    echo "  DUAL SERVER STATUS"
    echo "═══════════════════════════════════════════════════════════════"
    
    echo ""
    echo "🖥️  $ME ($MY_DOMAIN) - THIS SERVER:"
    echo "  Containers: $(docker ps -q | wc -l) running"
    echo "  Load: $(uptime | awk -F'load average:' '{print $2}')"
    echo "  Disk: $(df -h / | tail -1 | awk '{print $5 " used"}')"
    
    echo ""
    echo "🖥️  $TWIN ($TWIN_DOMAIN) - TWIN SERVER:"
    if ssh "$TWIN" "echo ok" &>/dev/null; then
        echo "  Containers: $(ssh $TWIN 'docker ps -q | wc -l') running"
        echo "  Load: $(ssh $TWIN "uptime | awk -F'load average:' '{print \$2}'")"
        echo "  Disk: $(ssh $TWIN "df -h / | tail -1 | awk '{print \$5 \" used\"}'")"
    else
        log_error "Cannot reach $TWIN!"
    fi
    
    echo ""
    cmd_compare
}

cmd_help() {
    echo "Agent Sync - Inter-agent communication tool"
    echo ""
    echo "Usage: $0 <command> [args]"
    echo ""
    echo "Commands:"
    echo "  compare     Compare container states between servers"
    echo "  sync-check  Check if configs/memories are in sync"
    echo "  messages    Show inter-agent messages"
    echo "  send MSG    Send message to twin agent"
    echo "  status      Full status of both servers"
    echo "  help        Show this help"
    echo ""
    echo "Current host: $ME"
    echo "Twin host: $TWIN"
}

# Main
case "${1:-help}" in
    compare)    cmd_compare ;;
    sync-check) cmd_sync_check ;;
    messages)   cmd_messages ;;
    send)       cmd_send "${2:-}" ;;
    status)     cmd_status ;;
    help|*)     cmd_help ;;
esac
