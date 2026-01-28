# Grafana Monitoring - Quick Reference

**Date**: 2026-01-28  
**Infrastructure**: qui3tly.cloud (Master + Lady)

## Access URLs

| Service | URL | Purpose |
|---------|-----|---------|
| Grafana | https://grafana.qui3tly.cloud | Dashboard UI |
| Prometheus | http://master:9090 | Metrics database |
| Loki | http://master:3100 | Log aggregation |
| AlertManager | http://master:9093 | Alert management |

## The 7 Dashboards

### 1. Infrastructure Overview
**Purpose**: Everything at a glance  
**When to use**: First thing you check, daily health check  
**Key panels**: Server status, container count, CPU/RAM/Disk usage, active alerts

### 2. Server Details
**Purpose**: Deep dive into specific server  
**When to use**: Troubleshooting server issues, capacity planning  
**Key panels**: CPU cores, memory breakdown, load average, disk I/O, filesystem usage

### 3. Container Monitoring
**Purpose**: All 83 containers status and resources  
**When to use**: Finding resource hogs, checking container health, restart loops  
**Key panels**: Container list, CPU/Memory usage, restart count, top consumers

### 4. Service Health
**Purpose**: Critical services monitoring  
**When to use**: Service-specific troubleshooting, performance analysis  
**Key panels**: Traefik requests, Headscale clients, CrowdSec bans, Authelia auth, Mailcow queue

### 5. Log Analysis
**Purpose**: Errors, warnings, security events  
**When to use**: Debugging issues, security monitoring, finding errors  
**Key panels**: Error count, recent errors, Traefik logs, auth failures, security events

### 6. Performance Trends
**Purpose**: Historical analysis and capacity planning  
**When to use**: Weekly/monthly reviews, capacity planning, identifying patterns  
**Key panels**: CPU/RAM/Disk trends (24h/7d/30d), network traffic, container trends

### 7. Alerting
**Purpose**: Alert management  
**When to use**: Managing active alerts, reviewing alert history  
**Key panels**: Active alerts, alert count by severity, alert frequency, resolution time

## Common Queries

### Check Container Status
```promql
# Count running containers
count(container_last_seen{name!=""})

# Find containers using most CPU
topk(5, rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100)

# Find containers using most memory
topk(5, container_memory_usage_bytes{name!=""})
```

### Check Server Resources
```promql
# CPU usage by server
100 - (avg by (server) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage by server
((node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes) * 100

# Disk usage by server and mountpoint
(node_filesystem_size_bytes{fstype!~"tmpfs|fuse.*"} - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

### Check Logs
```logql
# Recent errors
{level="error"}

# Traefik access logs with 5xx errors
{job="traefik-access"} |= "DownstreamStatus" |~ "5.."

# Authentication failures
{job="auth"} |= "Failed"
{job="authelia"} |= "authentication failed"

# Security events
{job=~"syslog"} |= "crowdsec" or "fail2ban"
```

## Alert Severity Levels

### Critical (Immediate Action)
- Service down >1 min
- CPU >90% for 5 min
- RAM >95% for 5 min
- Disk <10% free
- Container restart loop (>3 in 10 min)

### Warning (Attention Needed)
- CPU >75% for 15 min
- RAM >85% for 15 min
- Disk <20% free
- High error rate (>100 5xx/min)
- Certificate expiring <30 days

### Info (FYI)
- Backup completed
- Certificate renewed
- Updates available
- CrowdSec ban wave (>100 IPs/hour)

## Quick Commands

### Restart Monitoring Stack
```bash
# Master
docker restart prometheus loki promtail grafana alertmanager

# Lady
ssh lady "docker restart promtail"
```

### Check Prometheus Targets
```bash
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health}'
```

### Check Loki Logs
```bash
curl -s "http://localhost:3100/loki/api/v1/query" \
  --data-urlencode 'query={level="error"}' \
  --data-urlencode 'limit=10' | jq .
```

### Check Active Alerts
```bash
curl -s http://localhost:9093/api/v1/alerts | jq '.data[] | {labels: .labels, state: .status.state}'
```

### Reload Prometheus Config
```bash
docker exec prometheus kill -HUP 1
```

## Metrics Retention

| Component | Retention | Storage Location |
|-----------|-----------|------------------|
| Prometheus | 15 days | /prometheus/data |
| Loki | 7 days | /loki/chunks |
| Grafana | Unlimited | /var/lib/grafana |

## Common Issues & Solutions

### Dashboard shows "No data"
1. Check time range (top-right)
2. Verify data source (Config → Data Sources)
3. Check Prometheus/Loki are running

### Alerts not firing
1. Check AlertManager: `docker logs alertmanager`
2. Verify rules loaded: http://localhost:9090/rules
3. Check alert state: http://localhost:9090/alerts

### Lady metrics missing
1. Verify Tailscale: `ping 100.64.0.2`
2. Check node-exporter on Lady: `ssh lady "docker ps | grep node-exporter"`
3. Test scrape: `curl http://100.64.0.2:9100/metrics`

### Logs not appearing
1. Check Promtail: `docker logs promtail`
2. Verify Loki: `curl http://localhost:3100/ready`
3. Check log paths exist

## Panel Customization

### Change Time Range
- Click time picker (top-right)
- Select: Last 5m, 15m, 1h, 6h, 24h, 7d, 30d
- Or set custom range

### Add Panel to Dashboard
1. Click "Add panel" → "Add a new panel"
2. Write PromQL/LogQL query
3. Configure visualization
4. Save dashboard

### Clone Dashboard
1. Open dashboard
2. Dashboard settings (gear icon)
3. "Save As" → New name
4. Customize cloned dashboard

## Best Practices

1. **Check Infrastructure Overview daily** - 2 min health check
2. **Review Performance Trends weekly** - Capacity planning
3. **Investigate all Critical alerts immediately**
4. **Review Warning alerts within 4 hours**
5. **Check Log Analysis for errors daily**
6. **Export dashboards monthly** - Backup
7. **Update alert thresholds as needed** - Based on patterns

## Resources

- **Prometheus Docs**: https://prometheus.io/docs/
- **Loki Docs**: https://grafana.com/docs/loki/
- **Grafana Docs**: https://grafana.com/docs/grafana/
- **PromQL Guide**: https://prometheus.io/docs/prometheus/latest/querying/basics/
- **LogQL Guide**: https://grafana.com/docs/loki/latest/logql/

---

**Setup Complete**: 2026-01-28  
**Dashboards**: 7 (56 panels)  
**Coverage**: 83 containers, 2 servers, all logs
