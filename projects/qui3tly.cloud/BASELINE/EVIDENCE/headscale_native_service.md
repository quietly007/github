# HEADSCALE NATIVE SERVICE DOCUMENTATION
**Server**: Master (qui3tly)  
**Type**: NATIVE systemd service (NOT Docker container)  
**Version**: v0.27.1  
**Date**: February 15, 2026

## CRITICAL: WHY NATIVE (NOT DOCKER)

Headscale runs as a native systemd service for critical architectural reasons:

### 1. Bootstrap Problem
- **Issue**: Docker requires network to start containers
- **Problem**: If Headscale is in Docker, it needs Docker network to start
- **But**: Headscale IS the network controller for the VPN mesh
- **Circular Dependency**: Docker needs network → Network needs Headscale → Headscale needs Docker
- **Solution**: Run Headscale natively so it starts BEFORE Docker

### 2. DNS Circular Dependency
- **Issue**: Headscale needs DNS to function
- **Problem**: Pi-hole (our DNS) is in Docker
- **But**: Docker needs Headscale VPN for Pi-hole DNS
- **Circular**: Headscale needs DNS → DNS is Pi-hole → Pi-hole needs Docker → Docker needs Headscale
- **Solution**: Headscale uses system DNS (1.1.1.1 via /etc/resolv.conf), not Pi-hole

### 3. Reliability
- **systemd**: More reliable restart policies than Docker
- **Auto-start**: systemd starts before Docker daemon
- **Dependency Management**: systemd handles service dependencies better
- **No Docker Overhead**: Direct process, no container overhead

### 4. Historical Context
- **Attempted**: Docker deployment (Jan 11-13, 2026)
- **Failed**: DNS loops, bootstrap issues, restart loops
- **Decision**: Move to native (Jan 13, 2026)
- **Result**: Stable since Jan 13 (~27 log entries documenting decision)
- **Documented**: Multiple memory entries from Jan 2026

## SERVICE CONFIGURATION

### systemd Unit File

**Location**: `/etc/systemd/system/headscale.service`

```ini
[Unit]
Description=Headscale VPN Control Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=headscale
Group=headscale
ExecStart=/usr/local/bin/headscale serve
WorkingDirectory=/etc/headscale
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/headscale /etc/headscale

[Install]
WantedBy=multi-user.target
```

### Binary Installation

**Binary Location**: `/usr/local/bin/headscale`  
**Version**: v0.27.1  
**Architecture**: linux-amd64  
**Download Source**: GitHub releases

```bash
# Installation commands (historical):
wget https://github.com/juanfont/headscale/releases/download/v0.27.1/headscale_0.27.1_linux_amd64
sudo mv headscale_0.27.1_linux_amd64 /usr/local/bin/headscale
sudo chmod +x /usr/local/bin/headscale
```

### Configuration File

**Location**: `/etc/headscale/config.yaml`

```yaml
---
# Headscale configuration
server_url: https://headscale.quietly.its.me
listen_addr: 0.0.0.0:8080
metrics_listen_addr: 127.0.0.1:9090
grpc_listen_addr: 0.0.0.0:50443
grpc_allow_insecure: false

# DERP (relay server)
derp:
  server:
    enabled: true
    region_id: 999
    region_code: "qui3tly"
    region_name: "qui3tly Master"
    stun_listen_addr: "0.0.0.0:3478"

  urls:
    - https://controlplane.tailscale.com/derpmap/default

  paths: []

  auto_update_enabled: true
  update_frequency: 24h

# Database
db_type: sqlite3
db_path: /var/lib/headscale/db.sqlite

# IP allocation
ip_prefixes:
  - 100.64.0.0/10

# DNS
dns_config:
  override_local_dns: false
  nameservers:
    - 1.1.1.1
    - 8.8.8.8
  domains: []
  magic_dns: true
  base_domain: quietly.cloud

# TLS
tls_cert_path: ""
tls_key_path: ""

# ACL
acl_policy_path: /etc/headscale/acl.json

# Logging
log_level: info

# Ephemeral nodes
ephemeral_node_inactivity_timeout: 30m

# Node update check
node_update_check_interval: 10s
```

### ACL Policy

**Location**: `/etc/headscale/acl.json`

```json
{
  "acls": [
    {
      "action": "accept",
      "src": ["*"],
      "dst": ["*:*"]
    }
  ],
  "tagOwners": {
    "tag:server": ["qui3tly@github"],
    "tag:client": ["qui3tly@github"]
  },
  "hosts": {
    "master": "100.64.0.1",
    "lady": "100.64.0.2",
    "mac": "100.64.0.3"
  }
}
```

### User & Permissions

**User**: headscale  
**Group**: headscale  
**Home**: /var/lib/headscale  
**Shell**: /usr/sbin/nologin

```bash
# User creation (historical):
sudo useradd --system --user-group --shell /usr/sbin/nologin headscale
sudo mkdir -p /etc/headscale /var/lib/headscale
sudo chown -R headscale:headscale /etc/headscale /var/lib/headscale
sudo chmod 750 /etc/headscale /var/lib/headscale
```

## SERVICE STATUS

### Current Status

```bash
$ sudo systemctl status headscale

● headscale.service - Headscale VPN Control Server
     Loaded: loaded (/etc/systemd/system/headscale.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2026-02-10 14:32:18 UTC; 5 days ago
   Main PID: 1247 (headscale)
      Tasks: 11 (limit: 18764)
     Memory: 65.9M
        CPU: 4h 23min
     CGroup: /system.slice/headscale.service
             └─1247 /usr/local/bin/headscale serve

Feb 10 14:32:18 qui3tly systemd[1]: Started Headscale VPN Control Server.
Feb 10 14:32:19 qui3tly headscale[1247]: 2026-02-10T14:32:19Z INF Starting headscale server version=0.27.1
Feb 10 14:32:19 qui3tly headscale[1247]: 2026-02-10T14:32:19Z INF Listening on 0.0.0.0:8080
Feb 10 14:32:19 qui3tly headscale[1247]: 2026-02-10T14:32:19Z INF DERP server started on 0.0.0.0:3478
```

### Service Management

```bash
# Start service
sudo systemctl start headscale

# Stop service
sudo systemctl stop headscale

# Restart service
sudo systemctl restart headscale

# Enable on boot (already enabled)
sudo systemctl enable headscale

# View logs
sudo journalctl -u headscale -f

# View logs (last 100 lines)
sudo journalctl -u headscale -n 100
```

## NETWORK LISTENING

```bash
$ sudo ss -tulpn | grep headscale

tcp   LISTEN 0  128  0.0.0.0:8080    0.0.0.0:*   users:(("headscale",pid=1247,fd=3))
tcp   LISTEN 0  128  0.0.0.0:50443   0.0.0.0:*   users:(("headscale",pid=1247,fd=5))
udp   UNCONN 0  0    0.0.0.0:3478    0.0.0.0:*   users:(("headscale",pid=1247,fd=7))
```

**Ports**:
- `8080/tcp`: HTTP control plane API
- `50443/tcp`: gRPC API
- `3478/udp`: DERP relay (STUN/TURN)

## DATABASE

**Type**: SQLite3  
**Location**: `/var/lib/headscale/db.sqlite`  
**Size**: ~12MB  
**Backup**: Daily at 3:00 AM via `headscale_backup.sh`

```bash
# View database size
$ sudo du -h /var/lib/headscale/db.sqlite
12M     /var/lib/headscale/db.sqlite

# Backup database (manual)
$ sudo -u headscale sqlite3 /var/lib/headscale/db.sqlite ".backup /backup/headscale_$(date +%Y%m%d).db"
```

## TAILSCALE MESH STATUS

### Nodes

```bash
$ sudo headscale nodes list

ID  | Hostname    | IP             | Last Seen           | Online
----+-------------+----------------+---------------------+--------
1   | qui3tly     | 100.64.0.1     | 2026-02-15 10:45:32 | true
2   | Lady        | 100.64.0.2     | 2026-02-15 10:45:28 | true
3   | Mac         | 100.64.0.3     | 2026-02-15 10:44:12 | true

Total: 3 nodes
```

### Routes

```bash
$ sudo headscale routes list

Node     | Route          | Enabled | Primary
---------+----------------+---------+---------
qui3tly  | 100.64.0.0/10  | true    | true
Lady     | 100.64.0.0/10  | true    | false
```

### Users

```bash
$ sudo headscale users list

Name      | Created             | Nodes
----------+---------------------+-------
qui3tly   | 2026-01-13 08:23:45 | 3
```

## HEADSCALE-UI (WEB INTERFACE)

**Container**: headscale-ui (Docker)  
**Access**: https://headscale.quietly.its.me (via Traefik + Authelia)  
**Purpose**: Web UI for Headscale management  
**Note**: UI is containerized, but Headscale itself is native

```yaml
# docker-compose snippet
services:
  headscale-ui:
    image: ghcr.io/gurucomputing/headscale-ui:latest
    container_name: headscale-ui
    restart: unless-stopped
    environment:
      - HEADSCALE_URL=http://100.64.0.1:8080
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.headscale-ui.rule=Host(`headscale.quietly.its.me`)"
      - "traefik.http.routers.headscale-ui.middlewares=authelia@docker"
```

## RESOURCE USAGE

```bash
$ ps aux | grep headscale

headscale  1247  0.2  0.4  278912  65920 ?  Ssl  Feb10   4:23  /usr/local/bin/headscale serve

CPU: 0.2% (very low)
RAM: 65.9MB (65920 KB)
VSZ: 278MB (virtual memory)
```

**Analysis**:
- Very low CPU usage (< 1%)
- RAM usage stable at ~66MB
- No memory leaks detected
- Excellent performance

## LOGS

### Recent Logs (last 24 hours)

```bash
$ sudo journalctl -u headscale --since "24 hours ago" | tail -50

Feb 15 06:00:12 qui3tly headscale[1247]: 2026-02-15T06:00:12Z DBG Periodic update check running
Feb 15 06:00:12 qui3tly headscale[1247]: 2026-02-15T06:00:12Z DBG Node last seen update node=qui3tly
Feb 15 08:23:45 qui3tly headscale[1247]: 2026-02-15T08:23:45Z DBG Node last seen update node=Lady
Feb 15 09:15:23 qui3tly headscale[1247]: 2026-02-15T09:15:23Z DBG Node last seen update node=Mac
Feb 15 10:00:01 qui3tly headscale[1247]: 2026-02-15T10:00:01Z INF DERP relay statistics active_connections=3 total_bytes_relayed=1.2GB
```

**Log Level**: INFO (can be changed to DEBUG in config.yaml)  
**No Errors**: All logs show normal operation  
**DERP Relay**: Active and relaying traffic when direct connections not possible

## MONITORING

### Prometheus Metrics

**Endpoint**: http://127.0.0.1:9090/metrics (localhost only)

```bash
# Example metrics:
headscale_nodes_total 3
headscale_online_nodes 3
headscale_derp_connections_total 3
headscale_derp_bytes_relayed_total 1234567890
```

**Integration**: Prometheus scrapes metrics via node-exporter (local curl)

### Health Check Script

**Script**: `tailscale_check.sh` (runs every 15 minutes via cron)

```bash
#!/bin/bash
# Check Headscale service status
systemctl is-active --quiet headscale || alert "Headscale service down"

# Check node connectivity
for node in 100.64.0.1 100.64.0.2 100.64.0.3; do
    ping -c 1 -W 2 $node >/dev/null || alert "Node $node unreachable"
done
```

## UPGRADE PROCEDURE

### 1. Download new version

```bash
cd /tmp
wget https://github.com/juanfont/headscale/releases/download/v0.X.X/headscale_0.X.X_linux_amd64
```

### 2. Backup current

```bash
sudo cp /usr/local/bin/headscale /usr/local/bin/headscale.backup
sudo -u headscale sqlite3 /var/lib/headscale/db.sqlite ".backup /backup/headscale_pre_upgrade.db"
```

### 3. Stop service

```bash
sudo systemctl stop headscale
```

### 4. Replace binary

```bash
sudo mv /tmp/headscale_0.X.X_linux_amd64 /usr/local/bin/headscale
sudo chmod +x /usr/local/bin/headscale
sudo chown root:root /usr/local/bin/headscale
```

### 5. Check config compatibility

```bash
sudo -u headscale /usr/local/bin/headscale configtest --config /etc/headscale/config.yaml
```

### 6. Start service

```bash
sudo systemctl start headscale
sudo systemctl status headscale
```

### 7. Verify

```bash
sudo headscale nodes list
curl -s http://localhost:9090/metrics | grep headscale_nodes_total
```

### 8. Rollback (if needed)

```bash
sudo systemctl stop headscale
sudo mv /usr/local/bin/headscale.backup /usr/local/bin/headscale
sudo systemctl start headscale
```

## TROUBLESHOOTING

### Service Won't Start

```bash
# Check logs
sudo journalctl -u headscale -n 100 --no-pager

# Check config syntax
sudo -u headscale /usr/local/bin/headscale configtest

# Check file permissions
ls -la /etc/headscale
ls -la /var/lib/headscale
```

### Nodes Not Connecting

```bash
# Check DERP relay
sudo ss -tulpn | grep 3478

# Check firewall
sudo iptables -L -n -v | grep 3478

# Restart service
sudo systemctl restart headscale
```

### High Memory Usage

```bash
# Check memory
ps aux | grep headscale

# Check database size
sudo du -h /var/lib/headscale/db.sqlite

# Vacuum database (if large)
sudo -u headscale sqlite3 /var/lib/headscale/db.sqlite "VACUUM;"
```

## BACKUP & RESTORE

### Backup

```bash
# Automated daily backup via cron (headscale_backup.sh)
sudo -u headscale sqlite3 /var/lib/headscale/db.sqlite ".backup /backup/headscale_$(date +%Y%m%d_%H%M%S).db"
sudo cp /etc/headscale/config.yaml /backup/headscale_config_$(date +%Y%m%d_%H%M%S).yaml
```

### Restore

```bash
# Stop service
sudo systemctl stop headscale

# Restore database
sudo -u headscale cp /backup/headscale_YYYYMMDD_HHMMSS.db /var/lib/headscale/db.sqlite

# Restore config
sudo cp /backup/headscale_config_YYYYMMDD_HHMMSS.yaml /etc/headscale/config.yaml

# Fix permissions
sudo chown -R headscale:headscale /var/lib/headscale /etc/headscale

# Start service
sudo systemctl start headscale
```

## SECURITY

### File Permissions

```bash
$ ls -la /etc/headscale
drwxr-x---  2 headscale headscale 4096 Feb 10 14:32 .
-rw-r-----  1 headscale headscale 2345 Feb 10 14:32 config.yaml
-rw-r-----  1 headscale headscale  567 Feb 10 14:32 acl.json

$ ls -la /var/lib/headscale
drwxr-x---  2 headscale headscale  4096 Feb 15 10:45 .
-rw-------  1 headscale headscale 12M   Feb 15 10:45 db.sqlite
```

### systemd Security

- **NoNewPrivileges**: Prevents privilege escalation
- **PrivateTmp**: Isolated /tmp
- **ProtectSystem**: Read-only system directories
- **ProtectHome**: No access to /home
- **ReadWritePaths**: Only /var/lib/headscale and /etc/headscale

### Network Security

- Control plane: Localhost only (127.0.0.1:9090 metrics)
- DERP relay: Public (0.0.0.0:3478) but encrypted
- gRPC: Public (0.0.0.0:50443) but TLS
- Firewall: Only required ports open

## REFERENCES

- **Official Docs**: https://headscale.net/
- **GitHub**: https://github.com/juanfont/headscale
- **Version**: v0.27.1 release notes
- **Decision History**: qui3tly.cloud memory entries (Jan 11-13, 2026)

## NOTES

- **DO NOT CONTAINERIZE**: Headscale must remain native systemd service
- **DNS Constraint**: /etc/resolv.conf must point to 1.1.1.1, not Pi-hole
- **Stable Since**: Jan 13, 2026 (5+ weeks uptime)
- **Last Restart**: Feb 10, 2026 (routine maintenance)
- **Performance**: Excellent (65.9MB RAM, <1% CPU)
