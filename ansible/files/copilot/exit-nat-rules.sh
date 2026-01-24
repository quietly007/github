#!/bin/bash
# exit-nat-rules.sh - Add NAT masquerade rules for exit node
# Run after docker starts (docker creates its own iptables rules)
# These rules are REQUIRED for exit node to work

set -euo pipefail

# Check if rules already exist
if iptables -t nat -C POSTROUTING -s 10.100.0.0/30 -o eth0 -j MASQUERADE 2>/dev/null; then
    echo "NAT rules already exist"
    exit 0
fi

# Add NAT rules for exit traffic
iptables -t nat -A POSTROUTING -s 10.100.0.0/30 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE

echo "Exit NAT rules added (10.100.0.0/30 + 192.168.1.0/24 → eth0)"
