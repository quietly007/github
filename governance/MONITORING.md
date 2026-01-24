# Monitoring & Logging - Complete Guide

> **Project**: qui3tly.cloud Production Monitoring  
> **Status**: ✅ Operational  
> **Updated**: 2026-01-24  
> **Owner**: qui3tly

---

## 📊 ONE DASHBOARD FOR EVERYTHING

**Access Point**: https://grafana.quietly.its.me

Everything lives in Grafana:
- ✅ **Metrics**: CPU, RAM, Disk, Network, Docker stats
- ✅ **Logs**: All Docker containers + system logs  
- ✅ **Alerts**: 3-tier notification system

---

## 🏗️ Architecture Overview

```
┌────────────────────────────────────────────────────────────────────┐
│                     MONITORING ARCHITECTURE                         │
├────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────┐          ┌─────────────────┐                 │
│  │   MASTER        │          │    LADY         │                 │
│  │ quietly.its.me  │          │ quietly.online  │                 │
│  └────────┬────────┘          └────────┬────────┘                 │
│           │                             │                          │
│    ┌──────┴──────┐              ┌──────┴──────┐                  │
│    │   AGENTS    │              │   AGENTS    │                  │
│    ├─────────────┤              ├─────────────┤                  │
│    │ Node Export │              │ Node Export │                  │
│    │  (metrics)  │              │  (metrics)  │                  │
│    │             │              │             │                  │
│    │  cAdvisor   │              │  cAdvisor   │                  │
│    │ (Docker mon)│              │ (Docker mon)│                  │
│    │             │              │             │                  │
│    │  Promtail   │              │  Promtail   │                  │
│    │(log collect)│              │(log collect)│                  │
│    └──────┬──────┘              └──────┬──────┘                  │
│           │                             │                          │
│           └──────────────┬──────────────┘                          │
│                          │                                         │
│                   ┌──────▼──────┐                                 │
│                   │ PROMETHEUS  │                                 │
│                   │ (Master)    │                                 │
│                   │ Scrapes all │                                 │
│                   │   metrics   │                                 │
│                   └──────┬──────┘                                 │
│                          │                                         │
│          ┌───────────────┼───────────────┐                        │
│          │               │               │                        │
│    ┌─────▼─────┐   ┌────▼────┐   ┌──────▼──────┐                │
│    │   LOKI    │   │ GRAFANA │   │ALERTMANAGER │                │
│    │ (Master)  │   │(Master) │   │  (Master)   │                │
│    │Log storage│   │Dashboard│   │Alert routing│                │
│    └───────────┘   └────┬────┘   └──────┬──────┘                │
│                         │                │                        │
│                         │          ┌─────┴──────┐                 │
│                         │          │   GOTIFY   │                 │
│                         │          │ (Master)   │                 │
│                         │          │Push notifs │                 │
│                         │          └─────┬──────┘                 │
│                         │                │                        │
│                    ┌────▼────────────────▼────┐                  │
│                    │        YOU             │                  │
│                    │  Browser + Mobile App  │                  │
│                    └───────────────────────────┘                  │
│                                                                      │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📡 Data Flow

### Metrics Collection
```
Servers (Master/Lady)
  ↓
Node Exporter (system metrics: CPU, RAM, Disk, Network)
  ↓
cAdvisor (Docker metrics: container stats, resource usage)
  ↓
Prometheus (scrapes every 15s, stores time-series data)
  ↓
Grafana (visualizes via dashboards)
```

### Log Collection
```
Docker Containers (all services)
  ↓
Docker json-file driver (writes logs)
  ↓
Promtail (reads logs, adds labels: container, host, job)
  ↓
Loki (stores logs, indexes labels only - not content)
  ↓
Grafana (query/search logs, correlation with metrics)
```

### Alert Flow
```
Prometheus (evaluates alert rules)
  ↓
Alertmanager (routes based on severity)
  ↓
┌──────────┬────────────┬──────────┐
│ CRITICAL │  WARNING   │   INFO   │
│          │            │          │
│ Gotify   │   Email    │ Browser  │
│ Push→📱  │   →📧      │ →🖥️     │
│Priority10│ Priority5  │Priority2 │
└──────────┴────────────┴──────────┘
```

---

## 🔧 Components

### Prometheus (Metrics Database)
- **Port**: 9090
- **URL**: Internal only
- **Scrapes**: Every 15s
- **Retention**: 30 days
- **Targets**:
  - `node-master`: Master system metrics
  - `node-lady`: Lady system metrics
  - `cadvisor-master`: Master Docker metrics
  - `cadvisor-lady`: Lady Docker metrics
  - `traefik-master`: Master proxy metrics
  - `traefik-lady`: Lady proxy metrics

### Loki (Log Aggregation)
- **Port**: 3100
- **URL**: Internal only
- **Retention**: 30 days
- **Sources**:
  - Master: All Docker containers + /var/log/
  - Lady: All Docker containers + /var/log/

### Grafana (Visualization)
- **Port**: 3000
- **URL**: https://grafana.quietly.its.me
- **Datasources**:
  - Prometheus (metrics) - Default
  - Loki (logs)
- **Authentication**: VPN-only access

### Alertmanager (Alert Routing)
- **Port**: 9093
- **URL**: Internal only
- **Receivers**: Gotify, Email (future), Browser

### Gotify (Push Notifications)
- **Port**: 80
- **URL**: https://gotify.quietly.its.me
- **Mobile App**: Download from gotify.net
- **Login**: qui3tly / RaMpulstilckin123!

---

## 📱 Three-Tier Alert System

### 🔴 Tier 1: URGENT (Critical)
**Trigger**: System down, service failure, security breach  
**Notification**: Gotify Push (Priority 10) → Mobile  
**Sound**: Loud alert  
**Examples**:
- Server offline
- Docker daemon down
- Traefik unreachable
- Disk >95% full
- Out of memory

**Response Time**: Immediate

### 🟡 Tier 2: MEDIUM (Warning)
**Trigger**: Degraded performance, approaching limits  
**Notification**: Email  
**Examples**:
- CPU >80% for 10 minutes
- Disk >85% full
- Memory >85% used
- Container restart loop
- High error rate

**Response Time**: 1 hour

### 🟢 Tier 3: LOW (Info)
**Trigger**: Informational, scheduled events  
**Notification**: Browser notification in Grafana  
**Examples**:
- Backup completed
- Certificate renewed
- Container updated
- System reboot (planned)

**Response Time**: Next check-in

---

## 🎯 What's Monitored

### Master (quietly.its.me)
```
System:
├─ CPU usage (per core + total)
├─ Memory usage (used/available/swap)
├─ Disk usage (all filesystems)
├─ Network traffic (in/out per interface)
└─ Load average (1m, 5m, 15m)

Docker:
├─ Container count (running/stopped)
├─ Per-container CPU usage
├─ Per-container memory usage
├─ Per-container network I/O
├─ Per-container disk I/O
└─ Container restarts

Services:
├─ Traefik (requests, errors, latency)
├─ Headscale (users, nodes, traffic)
├─ Prometheus (targets up/down)
├─ Grafana (active users, dashboards)
└─ All other containers (health, logs)
```

### Lady (quietly.online)
```
System: (same as Master)

Docker: (same as Master)

Services:
├─ Traefik (requests, errors, latency)
├─ Mailcow (all 20 containers monitored)
│  ├─ Postfix (queue size, delivery rate)
│  ├─ Dovecot (connections, errors)
│  ├─ Rspamd (spam detected, ham/spam ratio)
│  ├─ MySQL (queries, connections)
│  ├─ Redis (memory, operations)
│  └─ All others (health, logs)
└─ Crowdsec (banned IPs, decisions)
```

---

## 📈 Pre-Installed Dashboards

### 1. Overview Dashboard
- All servers health at a glance
- Critical metrics: CPU, RAM, Disk, Network
- Service status (all green/red indicators)
- Recent alerts

### 2. System Metrics (Node Exporter)
- CPU usage per core
- Memory detailed breakdown
- Disk I/O and space
- Network traffic by interface
- System load and uptime

### 3. Docker Containers
- All containers resource usage
- Container logs (last 1000 lines)
- Container restart history
- Health check status

### 4. Traefik
- Requests per second
- Response times (p50, p95, p99)
- Error rates by service
- Active connections
- SSL certificate expiry

### 5. Logs Explorer
- Search all logs (Master + Lady)
- Filter by: container, host, severity
- Live tail
- Log context (click line → see surrounding logs)

---

## 🛠️ Configuration Files

### Prometheus
**Location**: `~/.docker/monitoring/prometheus/prometheus.yml`
**Key Settings**:
- `scrape_interval: 15s` - How often to collect metrics
- `evaluation_interval: 15s` - How often to evaluate alerts
- `external_labels` - Tags for all metrics (environment, server)

### Loki
**Location**: `~/.docker/monitoring/loki/loki-config.yaml`
**Key Settings**:
- `retention_period: 744h` - Keep logs for 30 days
- `compactor` - Compresses old logs

### Promtail (Master)
**Location**: `~/.docker/monitoring/promtail/config.yml`
**Scrapes**:
- `/var/log/*log` - System logs
- Docker containers via socket discovery

### Promtail (Lady)
**Location**: `~/.docker/monitoring/promtail/config.yml` (on Lady)
**Scrapes**:
- Same as Master
- Sends to Loki on Master

### Alertmanager
**Location**: `~/.docker/monitoring/alertmanager/alertmanager.yml`
**Routing**:
- Critical → Gotify (priority 10)
- Warning → Gotify (priority 5)
- Info → Gotify (priority 2)

### Grafana Datasources
**Location**: `~/.docker/monitoring/grafana/provisioning/datasources/datasources.yml`
**Configured**:
- Prometheus (default)
- Loki

---

## 🔍 How to Use

### View Metrics
1. Go to https://grafana.quietly.its.me
2. Click "Dashboards" → Browse
3. Select dashboard (Overview, System, Docker, etc.)
4. Time range selector (top right) - Last 1h, 6h, 24h, 7d, etc.

### Search Logs
1. In Grafana → Click "Explore" (left sidebar)
2. Select "Loki" datasource (top dropdown)
3. Click "Log browser" → Select labels:
   - `host`: master or lady
   - `container`: specific container name
   - `job`: docker or syslog
4. Click "Show logs"
5. Add filters: `|= "error"` to find errors
6. Live tail: Click "Live" button (top right)

### Check Alerts
1. Grafana → "Alerting" (left sidebar)
2. "Alert rules" - See all configured alerts
3. "Firing" - Currently active alerts
4. "Silences" - Temporarily mute alerts

### Mobile Notifications
1. Download Gotify app:
   - Android: F-Droid or gotify.net
   - iOS: Not available (use web)
2. Settings → Add server
3. URL: https://gotify.quietly.its.me
4. Login: qui3tly / RaMpulstilckin123!
5. Create client (for your phone)
6. Copy token → Settings → Enable notifications

---

## 🚨 Alert Examples

### Disk Space Low
```yaml
- alert: DiskSpaceLow
  expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 15
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Disk space low on {{ $labels.instance }}"
    description: "Filesystem {{ $labels.mountpoint }} on {{ $labels.instance }} has only {{ $value | humanize }}% free space"
```

### Service Down
```yaml
- alert: ServiceDown
  expr: up == 0
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Service {{ $labels.job }} is down"
    description: "{{ $labels.instance }} has been down for more than 2 minutes"
```

### Container Restarting
```yaml
- alert: ContainerRestarting
  expr: rate(container_last_seen{name!=""}[5m]) > 0.1
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Container {{ $labels.name }} is restarting"
    description: "Container {{ $labels.name }} on {{ $labels.instance }} is restarting frequently"
```

---

## 🔐 Security

### Access Control
- **Grafana**: VPN-only via Traefik middleware
- **Gotify**: VPN-only via Traefik middleware
- **Prometheus/Loki/Alertmanager**: Internal Docker network only

### Authentication
- **Grafana**: Admin credentials in `~/.secrets/grafana/`
- **Gotify**: User: qui3tly / RaMpulstilckin123!

### Data Retention
- **Prometheus**: 30 days (configurable)
- **Loki**: 30 days (configurable)
- **Logs deleted**: Automatically after retention period

---

## 🆘 Troubleshooting

### No Data in Grafana
1. Check Prometheus targets: `docker exec prometheus wget -qO- http://localhost:9090/targets`
2. Verify datasources: Grafana → Configuration → Data sources
3. Check time range (top right in dashboard)

### Missing Logs
1. Check Promtail status: `docker logs promtail`
2. Verify Loki connection: `docker exec promtail wget -qO- http://loki:3100/ready`
3. Check container logging driver: `docker inspect <container> --format '{{.HostConfig.LogConfig.Type}}'`

### No Alerts
1. Check Alertmanager: `docker logs alertmanager`
2. Verify Gotify connection: `docker exec alertmanager wget -qO- http://gotify:80/health`
3. Test Gotify manually: `curl -F "title=Test" -F "message=Test" http://gotify:80/message?token=<token>`

### Prometheus Not Scraping
1. Check network: `docker exec prometheus ping node-exporter`
2. Verify config: `docker exec prometheus cat /etc/prometheus/prometheus.yml`
3. Check targets: `docker exec prometheus wget -qO- http://localhost:9090/api/v1/targets`

---

## 📝 Maintenance

### Backup Configuration
```bash
# Backup all monitoring configs
cd ~/.docker/monitoring
tar -czf ~/monitoring-config-backup-$(date +%Y%m%d).tar.gz \
  prometheus/ loki/ grafana/ alertmanager/
```

### Update Retention Period
```bash
# Edit Prometheus retention (default 30d)
cd ~/.docker-compose/monitoring
# Edit docker-compose.yaml:
# --storage.tsdb.retention.time=60d

# Edit Loki retention
cd ~/.docker/monitoring/loki
# Edit loki-config.yaml:
# retention_period: 1440h  # 60 days
```

### Add New Server
1. Deploy agents on new server:
   - Node Exporter
   - cAdvisor  
   - Promtail
2. Add to Prometheus config:
   - Edit `~/.docker/monitoring/prometheus/prometheus.yml`
   - Add new scrape targets
3. Restart Prometheus: `docker restart prometheus`

---

## 📚 Resources

- **Prometheus**: https://prometheus.io/docs/
- **Grafana**: https://grafana.com/docs/
- **Loki**: https://grafana.com/docs/loki/
- **Gotify**: https://gotify.net/docs/

---

## ✅ Verification Checklist

After setup, verify:
- [ ] Can access Grafana
- [ ] See metrics from Master
- [ ] See metrics from Lady
- [ ] Can search logs from both servers
- [ ] Gotify app connected on mobile
- [ ] Test alert (trigger disk space warning)
- [ ] All Prometheus targets "UP"
- [ ] All dashboards load data

---

**Status**: ✅ OPERATIONAL  
**Last Updated**: 2026-01-24  
**Maintained By**: qui3tly

