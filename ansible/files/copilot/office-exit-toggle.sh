#!/bin/bash
# Office Exit Toggle - Route office traffic via VPS or local ISP
# Controlled from Master, applied to EdgeRouter

EDGE_HOST="home"
VPS_NEXTHOP="10.100.0.1"
PASS_FILE="$HOME/.secrets/edgerouter/password"

usage() {
    echo "Usage: $0 {on|off|status}"
    echo "  on     - Route office traffic via VPS"
    echo "  off    - Route office traffic via local ISP"
    echo "  status - Show current default routes"
    exit 1
}

edge_cmd() {
    sshpass -f "$PASS_FILE" ssh -o StrictHostKeyChecking=accept-new "$EDGE_HOST" "$1"
}

case "$1" in
    on)
        echo "Enabling office exit via VPS ($VPS_NEXTHOP)..."
        edge_cmd "/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper set protocols static route 0.0.0.0/0 next-hop $VPS_NEXTHOP distance 1 && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end"
        echo "Done. Office traffic now exits via VPS."
        ;;
    off)
        echo "Disabling office exit via VPS..."
        edge_cmd "/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper begin && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper delete protocols static route 0.0.0.0/0 next-hop $VPS_NEXTHOP && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper commit && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper save && \
                  /opt/vyatta/sbin/vyatta-cfg-cmd-wrapper end"
        echo "Done. Office traffic now exits via local ISP."
        ;;
    status)
        echo "=== EdgeRouter Default Routes ==="
        edge_cmd "show ip route 0.0.0.0/0"
        ;;
    *)
        usage
        ;;
esac

echo ""
$0 status
