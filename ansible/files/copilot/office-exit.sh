#!/bin/bash
# Office Exit Toggle - Routes office traffic via VPS
# SAFE: WireGuard endpoint 213.136.68.108/32 always routes via eth0

ACTION="${1:-status}"
EDGE_PASS=$(cat ~/.secrets/edgerouter/password)
SSH_CMD="sshpass -p $EDGE_PASS ssh -o StrictHostKeyChecking=no -p 1006 qui3tly@10.100.0.2"
VYATTA="/opt/vyatta/bin/vyatta-op-cmd-wrapper"
VCONF="/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper"

case "$ACTION" in
    status)
        echo "=== Office Exit Status ==="
        $SSH_CMD "$VYATTA show ip route 0.0.0.0/0" 2>/dev/null
        ;;
    on)
        echo "Enabling office exit via VPS..."
        $SSH_CMD "$VCONF begin && $VCONF set protocols static route 0.0.0.0/0 next-hop 10.100.0.1 distance 1 && $VCONF commit && $VCONF save && $VCONF end" 2>/dev/null
        echo "Verifying..."
        $SSH_CMD "$VYATTA show ip route 0.0.0.0/0" 2>/dev/null | head -4
        ;;
    off)
        echo "Disabling office exit via VPS..."
        # Delete entire route entry, not just next-hop
        $SSH_CMD "$VCONF begin && $VCONF delete protocols static route 0.0.0.0/0 && $VCONF commit && $VCONF save && $VCONF end" 2>/dev/null
        echo "Verifying..."
        $SSH_CMD "$VYATTA show ip route 0.0.0.0/0" 2>/dev/null | head -4
        ;;
    *)
        echo "Usage: $0 [on|off|status]"
        echo "  ON  = Office exits via VPS (distance 1)"
        echo "  OFF = Office exits via ISP (distance 210 DHCP)"
        ;;
esac
