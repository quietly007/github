#!/bin/bash
# Exit node toggle for Headscale
# Usage: exit-toggle.sh [on|off|status]

set -euo pipefail

ACTION=${1:-status}
NODE_ID=1  # quietly

case "$ACTION" in
    on)
        sudo headscale nodes approve-routes -i $NODE_ID -r "0.0.0.0/0,10.100.0.0/30,192.168.1.0/24,::/0"
        echo "EXIT NODE ENABLED"
        ;;
    off)
        sudo headscale nodes approve-routes -i $NODE_ID -r "10.100.0.0/30,192.168.1.0/24"
        echo "EXIT NODE DISABLED"
        ;;
    status)
        # Strip ANSI codes and check Approved column for 0.0.0.0/0
        ROUTES=$(sudo headscale nodes list-routes -i $NODE_ID 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | grep "^$NODE_ID")
        APPROVED=$(echo "$ROUTES" | cut -d'|' -f3)
        if echo "$APPROVED" | grep -q "0.0.0.0/0"; then
            echo "EXIT: ENABLED"
        else
            echo "EXIT: DISABLED"
        fi
        ;;
    *)
        echo "Usage: $0 [on|off|status]"
        exit 1
        ;;
esac
