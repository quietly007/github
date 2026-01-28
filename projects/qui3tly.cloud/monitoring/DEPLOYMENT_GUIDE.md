# Grafana Full Completion - Deployment Guide

**Date**: 2026-01-28  
**Status**: Ready for Deployment  
**Estimated Time**: 30-45 minutes

## Overview

This guide walks through deploying the complete Grafana monitoring setup with:
- 7 comprehensive dashboards (56 panels)
- Prometheus metrics from Master + Lady
- Loki log aggregation
- AlertManager rules (Critical, Warning, Info)
- Complete infrastructure visibility

## Prerequisites

✅ Monitoring stack running (Grafana, Prometheus, Loki, Promtail, AlertManager)  
✅ Configuration files created (Phase 1.1 complete)  
✅ Dashboard files created (Phase 1.2 complete)  
✅ Alert rules created (Phase 1.3 complete)

## Phase 1: Deploy Configurations

### Step 1: Deploy Prometheus Configuration

```bash
# Backup current Prometheus config
docker exec prometheus cat /etc/prometheus/prometheus.yml > ~/backup-prometheus.yml

# Copy new config to Prometheus container
docker cp ~/projects/qui3tly.cloud/monitoring/prometheus/prometheus.yml prometheus:/etc/prometheus/prometheus.yml

# Reload Prometheus configuration
docker exec prometheus kill -HUP 1

# Verify Prometheus is running
docker ps | grep prometheus
curl -s http://localhost:9090/-/healthy
```

**Verify**: Check Prometheus targets at http://localhost:9090/targets - all should be "UP"

### Step 2: Deploy Loki Configuration

```bash
# Backup current Loki config
docker exec loki cat /etc/loki/local-config.yaml > ~/backup-loki.yml

# Copy new config to Loki container
docker cp ~/projects/qui3tly.cloud/monitoring/loki/loki-config.yml loki:/etc/loki/local-config.yaml

# Restart Loki to apply config
docker restart loki

# Wait for Loki to be ready
sleep 10
curl -s http://localhost:3100/ready
```

**Verify**: Check Loki is ready at http://localhost:3100/ready

### Step 3: Deploy Promtail Configuration (Master)

```bash
# Backup current Promtail config
docker exec promtail cat /etc/promtail/config.yml > ~/backup-promtail.yml

# Copy new config to Promtail container
docker cp ~/projects/qui3tly.cloud/monitoring/promtail/promtail-master.yml promtail:/etc/promtail/config.yml

# Restart Promtail
docker restart promtail

# Verify Promtail is running
docker logs promtail --tail 20
```

**Verify**: Check Promtail logs for "clients configured" and "targets found"

### Step 4: Deploy Promtail Configuration (Lady)

```bash
# SSH to Lady server
ssh lady

# Copy config to Lady
scp ~/projects/qui3tly.cloud/monitoring/promtail/promtail-lady.yml lady:/tmp/

# On Lady: Deploy config
docker cp /tmp/promtail-lady.yml promtail:/etc/promtail/config.yml
docker restart promtail

# Verify
docker logs promtail --tail 20
```

**Verify**: Check Promtail on Lady is sending logs to Master (100.64.0.1:3100)

### Step 5: Deploy AlertManager Rules

```bash
# Copy alert rules to Prometheus
docker cp ~/projects/qui3tly.cloud/monitoring/alerts/alert-rules.yml prometheus:/etc/prometheus/alerts/

# Reload Prometheus to load alerts
docker exec prometheus kill -HUP 1

# Verify alerts loaded
curl -s http://localhost:9090/api/v1/rules | jq .
```

**Verify**: Check Prometheus rules at http://localhost:9090/rules

## Phase 2: Import Dashboards into Grafana

### Method 1: Via Grafana UI (Recommended)

1. **Access Grafana**: https://grafana.qui3tly.cloud
2. **Login**: Use admin credentials
3. **Import each dashboard**:
   - Click "+" → "Import dashboard"
   - Click "Upload JSON file"
   - Select dashboard file
   - Click "Import"

**Import in this order**:
1. 1-infrastructure-overview.json
2. 2-server-details.json
3. 3-container-monitoring.json
4. 4-service-health.json
5. 5-log-analysis.json
6. 6-performance-trends.json
7. 7-alerting.json

### Method 2: Via Grafana API (Automated)

```bash
# Set Grafana credentials
GRAFANA_URL="http://localhost:3000"
GRAFANA_USER="admin"
GRAFANA_PASS="your_admin_password"

# Import all dashboards
for dashboard in ~/projects/qui3tly.cloud/monitoring/dashboards/*.json; do
  echo "Importing $(basename $dashboard)..."
  curl -X POST \
    -H "Content-Type: application/json" \
    -u "$GRAFANA_USER:$GRAFANA_PASS" \
    -d @"$dashboard" \
    "$GRAFANA_URL/api/dashboards/db"
  echo ""
done
```

## Phase 3: Configure Data Sources

### Step 1: Verify Prometheus Data Source

1. Go to **Configuration** → **Data Sources**
2. Select **Prometheus**
3. Verify URL: `http://prometheus:9090`
4. Click **Save & Test** - should show "Data source is working"

### Step 2: Configure Loki Data Source

1. Go to **Configuration** → **Data Sources**
2. Click **Add data source**
3. Select **Loki**
4. Configure:
   - Name: `Loki`
   - URL: `http://loki:3100`
   - Click **Save & Test** - should show "Data source is working"

## Phase 4: Testing & Validation

### Test 1: Verify Metrics Collection

```bash
# Check Prometheus targets
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health}'

# Expected: All targets with health="up"
```

### Test 2: Verify Log Collection

```bash
# Check Loki for logs
curl -s "http://localhost:3100/loki/api/v1/label/job/values" | jq .

# Expected: Should see jobs like: syslog, auth, docker-logs, traefik-access, etc.
```

### Test 3: Test Each Dashboard

Visit each dashboard and verify data is displaying:

1. **Infrastructure Overview**: 
   - Server status shows UP
   - Container count shows ~83
   - CPU/RAM graphs showing data

2. **Server Details**:
   - Select server from dropdown (master/lady)
   - All panels show data

3. **Container Monitoring**:
   - Container list populated
   - CPU/Memory graphs showing container data

4. **Service Health**:
   - Traefik metrics showing
   - Prometheus targets table populated

5. **Log Analysis**:
   - Recent errors panel shows logs
   - Error/Warning counts displaying

6. **Performance Trends**:
   - Historical data displaying
   - Can switch between 24h/7d/30d

7. **Alerting**:
   - Alert table shows current state
   - Alert history graph displaying

### Test 4: Verify AlertManager

```bash
# Check AlertManager is receiving alerts
curl -s http://localhost:9093/api/v1/alerts | jq .

# Trigger test alert (optional)
# Will resolve automatically after 1 minute
docker stop prometheus
sleep 90
docker start prometheus
```

## Phase 5: Final Configuration

### Set Infrastructure Overview as Home Dashboard

1. Go to **Infrastructure Overview** dashboard
2. Click **⭐ (star icon)** to favorite
3. Go to **Preferences** → **Profile**
4. Set **Home Dashboard**: "1. Infrastructure Overview"

### Configure Alert Notifications (Optional)

1. Go to **Alerting** → **Contact points**
2. Add notification channels:
   - Email
   - Gotify (already deployed)
   - Slack/Discord/etc.

3. Create **Notification policies**:
   - Critical alerts → Immediate notification
   - Warning alerts → Grouped (5 min delay)
   - Info alerts → Daily digest

## Validation Checklist

Complete this checklist to verify deployment:

- [ ] Prometheus targets all UP (check /targets page)
- [ ] Loki receiving logs (check /ready endpoint)
- [ ] Promtail on Master shipping logs
- [ ] Promtail on Lady shipping logs via Tailscale
- [ ] All 7 dashboards imported into Grafana
- [ ] Prometheus data source working
- [ ] Loki data source working
- [ ] Infrastructure Overview dashboard shows data
- [ ] Server Details dashboard shows data
- [ ] Container Monitoring shows all 83 containers
- [ ] Service Health shows Traefik metrics
- [ ] Log Analysis shows recent logs
- [ ] Performance Trends shows historical data
- [ ] Alerting dashboard shows alerts
- [ ] Alert rules loaded in Prometheus
- [ ] AlertManager receiving alerts
- [ ] Home dashboard set to Infrastructure Overview

## Troubleshooting

### Issue: Prometheus targets showing DOWN

**Solution**:
```bash
# Check if services are running
docker ps | grep -E 'prometheus|node-exporter|cadvisor'

# Check Prometheus logs
docker logs prometheus --tail 50

# Verify network connectivity
docker exec prometheus ping -c 3 node-exporter
```

### Issue: No logs appearing in Loki

**Solution**:
```bash
# Check Promtail is running
docker ps | grep promtail

# Check Promtail logs
docker logs promtail --tail 50

# Verify Promtail can reach Loki
docker exec promtail wget -O- http://loki:3100/ready
```

### Issue: Dashboard shows "No data"

**Solution**:
1. Verify data source connection (Configuration → Data Sources)
2. Check time range (top-right corner)
3. Verify labels in queries match your setup
4. Check Prometheus has metrics: `curl http://localhost:9090/api/v1/label/__name__/values`

### Issue: Lady metrics not appearing

**Solution**:
```bash
# On Lady, check node-exporter and cadvisor are running
ssh lady "docker ps | grep -E 'node-exporter|cadvisor'"

# Check if ports are accessible via Tailscale
curl -v http://100.64.0.2:9100/metrics
curl -v http://100.64.0.2:8080/metrics

# Verify Prometheus can scrape Lady
docker logs prometheus | grep "lady"
```

## Next Steps

After successful deployment:

1. **Monitor for 24 hours** - Let metrics and logs accumulate
2. **Review dashboards daily** - Get familiar with normal patterns
3. **Test alerts** - Verify notifications work
4. **Document anomalies** - Note any expected "errors" or "warnings"
5. **Create custom views** - Clone dashboards for specific needs
6. **Share dashboards** - Create read-only users for team members

## Support

**Configuration Files**: `~/projects/qui3tly.cloud/monitoring/`  
**Documentation**: `~/.docs/03-services/GRAFANA.md` (to be created)  
**Monitoring Stack**: Docker Compose setup on Master

---

**Deployment Status**: Ready ✅  
**Next Phase**: Testing & Validation (30 min)
