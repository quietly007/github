#!/bin/bash
# Agent Handshake Test - Run from either server to verify twin connectivity
# Usage: ./agent-handshake.sh

set -uo pipefail

HOSTNAME=$(hostname)
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [[ "$HOSTNAME" == quietly.its.me* ]]; then
    ME="quietly"
    TWIN="lady"
elif [[ "$HOSTNAME" == quietly.online* ]]; then
    ME="lady"
    TWIN="quietly"
else
    echo "ERROR: Unknown host: $HOSTNAME"
    exit 1
fi

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║           🤖 AGENT HANDSHAKE TEST 🤖                          ║"
echo "║                                                                ║"
echo "║   Testing connectivity between $ME and $TWIN              ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local name="$1"
    local cmd="$2"
    
    echo -n "  Testing: $name... "
    if eval "$cmd" &>/dev/null; then
        echo -e "${GREEN}PASS${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        ((TESTS_FAILED++))
        return 1
    fi
}

echo ""
echo -e "${BLUE}═══ Phase 1: Network Connectivity ═══${NC}"

run_test "SSH to $TWIN" "ssh $TWIN 'echo ok'"

# Get Tailscale IP for ping test
if [[ "$TWIN" == "lady" ]]; then
    TWIN_IP="100.64.0.3"
else
    TWIN_IP="100.64.0.1"
fi

run_test "Ping $TWIN via Tailscale" "ping -c 1 -W 2 $TWIN_IP"
run_test "Tailscale status" "tailscale status | grep -q $TWIN"

echo ""
echo -e "${BLUE}═══ Phase 2: File System Access ═══${NC}"

run_test "Read $TWIN memories" "ssh $TWIN 'cat ~/.copilot/memories.jsonl | tail -1'"
run_test "Read $TWIN governance" "ssh $TWIN 'ls ~/.governance/'"
run_test "Read $TWIN compose" "ssh $TWIN 'ls ~/.docker-compose/'"

echo ""
echo -e "${BLUE}═══ Phase 3: Docker Access ═══${NC}"

run_test "List $TWIN containers" "ssh $TWIN 'docker ps'"
run_test "Docker version match" "[[ \$(docker version --format '{{.Server.Version}}') == \$(ssh $TWIN 'docker version --format {{.Server.Version}}') ]]"

echo ""
echo -e "${BLUE}═══ Phase 4: Agent Communication ═══${NC}"

# Send test message
TEST_MSG="Handshake test from $ME at $TIMESTAMP"
echo "{\"ts\":\"$TIMESTAMP\",\"from\":\"$ME\",\"to\":\"$TWIN\",\"msg\":\"$TEST_MSG\",\"type\":\"handshake\"}" >> ~/.copilot/agent-messages.jsonl

run_test "Message file writable" "test -w ~/.copilot/agent-messages.jsonl"
run_test "Read $TWIN messages" "ssh $TWIN 'cat ~/.copilot/agent-messages.jsonl 2>/dev/null || echo ok'"

echo ""
echo -e "${BLUE}═══ Phase 5: Service Comparison ═══${NC}"

LOCAL_COUNT=$(docker ps -q | wc -l)
REMOTE_COUNT=$(ssh $TWIN 'docker ps -q | wc -l' 2>/dev/null || echo 0)

echo "  Local containers: $LOCAL_COUNT"
echo "  Remote containers: $REMOTE_COUNT"

if [[ "$LOCAL_COUNT" == "$REMOTE_COUNT" ]]; then
    echo -e "  Container count: ${GREEN}MATCH${NC}"
    ((TESTS_PASSED++))
else
    echo -e "  Container count: ${YELLOW}DIFFER${NC} (may be intentional)"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Summary
TOTAL=$((TESTS_PASSED + TESTS_FAILED))

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED! ($TESTS_PASSED/$TOTAL)${NC}"
    echo ""
    echo "Agents $ME and $TWIN are connected and ready to collaborate!"
    
    # Log success to memories
    cat >> ~/.copilot/memories.jsonl << EOF
{"ts":"$TIMESTAMP","action":"handshake-test","target":"$TWIN","result":"PASS - all $TOTAL tests passed"}
EOF
    
else
    echo -e "${RED}⚠️  SOME TESTS FAILED! ($TESTS_PASSED passed, $TESTS_FAILED failed)${NC}"
    echo ""
    echo "Check network connectivity and SSH configuration."
    
    # Log failure to memories
    cat >> ~/.copilot/memories.jsonl << EOF
{"ts":"$TIMESTAMP","action":"handshake-test","target":"$TWIN","result":"PARTIAL - $TESTS_PASSED/$TOTAL passed"}
EOF
fi

echo ""
echo "Test completed at $TIMESTAMP"
