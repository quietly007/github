# EXTERNAL AUDIT REQUEST: Complete Monitoring & Alerting System

**Date**: 2026-01-29  
**Requestor**: qui3tly  
**Type**: Read-Only Comprehensive Audit  
**Target Grade**: A+++ (Complete Observability)  
**Report Location**: `.reports/audits/monitoring/$(date +%Y%m%d-%H%M%S)/`

---

## 🎯 AUDIT OBJECTIVE

Perform a **complete read-only audit** of the entire monitoring, logging, and alerting infrastructure for qui3tly.cloud to achieve **A+++ system reliability and observability**.

**Goal**: Verify that EVERY SINGLE service (native and Docker) has:
- ✅ Proper logging configuration
- ✅ Metrics collection and export
- ✅ Alert rules configured
- ✅ Grafana dashboard integration
- ✅ Multi-channel alerting (Ntfy, Gotify, email)
- ✅ Log aggregation in Loki
- ✅ Proper data retention policies

---

## 📊 INFRASTRUCTURE OVERVIEW

### Servers
- **Master** (213.136.68.108 / 100.64.0.1): Monitoring hub + services
- **Lady** (207.180.251.111 / 100.64.0.2): Production services + Mailcow

### Monitoring Stack Components
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Loki**: Log aggregation
- **Promtail**: Log shipping
- **Alertmanager**: Alert routing and notification
- **Node-Exporter**: System metrics (Master + Lady)
- **cAdvisor**: Container metrics
- **Ntfy**: Push notifications
- **Gotify**: Alert notifications
- **Uptime Kuma**: Service health monitoring

---

## 🔍 AUDIT SCOPE: EVERY SERVICE

### 1. DOCKER SERVICES AUDIT

**Master Server Docker Services** (23 containers):
- [ ] traefik
- [ ] authelia
- [ ] prometheus
- [ ] grafana
- [ ] loki
- [ ] promtail
- [ ] alertmanager
- [ ] node-exporter
- [ ] cadvisor
- [ ] portainer
- [ ] semaphore
- [ ] pihole
- [ ] crowdsec
- [ ] bouncer-traefik
- [ ] gotify
- [ ] ntfy
- [ ] uptime-kuma
- [ ] cloudflared
- [ ] headscale-ui
- [ ] headscale-admin
- [ ] it-tools
- [ ] admin-panel
- [ ] fuckoff-page

**Lady Server Docker Services** (31 containers):
- [ ] All Mailcow containers (18):
  - mailcowdockerized-acme-mailcow
  - mailcowdockerized-clamd-mailcow
  - mailcowdockerized-dockerapi-mailcow
  - mailcowdockerized-dovecot-mailcow
  - mailcowdockerized-ipv6nat-mailcow
  - mailcowdockerized-memcached-mailcow
  - mailcowdockerized-mysql-mailcow
  - mailcowdockerized-netfilter-mailcow
  - mailcowdockerized-nginx-mailcow
  - mailcowdockerized-ofelia-mailcow
  - mailcowdockerized-olefy-mailcow
  - mailcowdockerized-php-fpm-mailcow
  - mailcowdockerized-postfix-mailcow
  - mailcowdockerized-redis-mailcow
  - mailcowdockerized-rspamd-mailcow
  - mailcowdockerized-sogo-mailcow
  - mailcowdockerized-solr-mailcow
  - mailcowdockerized-watchdog-mailcow
- [ ] nextcloud
- [ ] nextcloud-db
- [ ] pihole (Lady instance)
- [ ] node-exporter (Lady)
- [ ] promtail (Lady)
- [ ] nginx-proxy-manager
- [ ] unifi-controller
- [ ] uisp
- [ ] portainer (Lady)
- [ ] Other Lady services

### 2. NATIVE SERVICES AUDIT

**Systemd Services**:
- [ ] headscale.service
- [ ] tailscaled.service
- [ ] ssh.service (sshd)
- [ ] fail2ban.service
- [ ] docker.service
- [ ] containerd.service
- [ ] ufw.service
- [ ] cron.service
- [ ] rsyslog.service (or journald)
- [ ] systemd-timesyncd.service
- [ ] systemd-resolved.service
- [ ] unattended-upgrades.service
- [ ] aide.service (if active)
- [ ] rkhunter.service/timer
- [ ] logrotate.service/timer
- [ ] apt-daily.timer
- [ ] apt-daily-upgrade.timer
- [ ] fstrim.timer
- [ ] All custom systemd timers/services

**Network Services**:
- [ ] UFW firewall rules
- [ ] iptables/nftables
- [ ] WireGuard (wg0)
- [ ] Tailscale VPN
- [ ] DNS resolution (systemd-resolved)

**Security Services**:
- [ ] CrowdSec (native + container)
- [ ] fail2ban
- [ ] UFW
- [ ] AIDE (intrusion detection)
- [ ] rkhunter (rootkit scanner)

### 3. CRON JOBS & SCHEDULED TASKS

**User Crontab** (`crontab -l`):
- [ ] Daily report script
- [ ] Weekly security script
- [ ] Monthly report script
- [ ] Any backup jobs
- [ ] Any maintenance jobs

**System Cron** (`/etc/cron.*`):
- [ ] /etc/cron.daily/* (aide, rkhunter, logrotate, apt, etc.)
- [ ] /etc/cron.weekly/* (man-db, rkhunter)
- [ ] /etc/cron.monthly/*
- [ ] /etc/cron.hourly/*

**Systemd Timers** (`systemctl list-timers`):
- [ ] All active timers
- [ ] Timer execution logs
- [ ] Timer failure notifications

### 4. LOG SOURCES

**System Logs**:
- [ ] /var/log/syslog
- [ ] /var/log/auth.log
- [ ] /var/log/kern.log
- [ ] /var/log/daemon.log
- [ ] /var/log/mail.log (if exists)
- [ ] journalctl (systemd journal)
- [ ] Docker logs (`docker logs`)

**Application Logs**:
- [ ] Traefik access logs
- [ ] Nginx access/error logs
- [ ] Mailcow logs (all components)
- [ ] Pihole logs
- [ ] CrowdSec logs
- [ ] fail2ban logs

---

## 📋 DETAILED AUDIT CHECKLIST

### FOR EACH SERVICE, VERIFY:

#### A. Logging Configuration
- [ ] **Logs exist**: Service produces logs
- [ ] **Log format**: Structured (JSON) or parseable
- [ ] **Log level**: Appropriate verbosity (INFO/WARN/ERROR)
- [ ] **Log destination**: File, stdout, or both
- [ ] **Log rotation**: Configured (logrotate or Docker)
- [ ] **Log retention**: Defined policy (days/size)
- [ ] **Log aggregation**: Shipped to Loki via Promtail
- [ ] **Log parsing**: Loki labels configured correctly
- [ ] **Log readability**: Searchable in Grafana Explore

#### B. Metrics Collection
- [ ] **Metrics exposed**: Service exports metrics (Prometheus format)
- [ ] **Scrape config**: Prometheus scrapes the endpoint
- [ ] **Scrape interval**: Appropriate frequency (15s/30s/60s)
- [ ] **Metrics stored**: Data visible in Prometheus
- [ ] **Metric labels**: Proper job/instance labels
- [ ] **Service discovery**: Auto-discovery or static config
- [ ] **Metric retention**: Prometheus retention policy

#### C. Alerting Rules
- [ ] **Alert defined**: Prometheus alert rule exists
- [ ] **Alert threshold**: Appropriate trigger conditions
- [ ] **Alert severity**: Labeled (critical/warning/info)
- [ ] **Alert description**: Clear, actionable message
- [ ] **Alert routing**: Alertmanager routes to correct channel
- [ ] **Alert testing**: Rule triggers correctly
- [ ] **Alert silence**: Can be silenced when needed

#### D. Grafana Integration
- [ ] **Dashboard exists**: Service has dedicated dashboard
- [ ] **Data source connected**: Dashboard queries Prometheus/Loki
- [ ] **Panels configured**: All relevant metrics visualized
- [ ] **Panel queries**: Queries return data
- [ ] **Time ranges**: Appropriate default time range
- [ ] **Refresh rate**: Auto-refresh configured
- [ ] **Variables**: Template variables for filtering
- [ ] **Annotations**: Events/alerts shown on graphs
- [ ] **Links**: Cross-dashboard navigation
- [ ] **Export/Import**: Dashboard JSON available

#### E. Notification Channels
- [ ] **Ntfy configured**: Push notifications enabled
- [ ] **Gotify configured**: Alert notifications enabled
- [ ] **Email configured**: Critical alerts via email (if applicable)
- [ ] **Webhook configured**: Custom integrations (if applicable)
- [ ] **Channel testing**: Test alerts work
- [ ] **Alert grouping**: Related alerts grouped
- [ ] **Alert deduplication**: No spam/duplicates

---

## 🎯 SPECIFIC AUDIT TASKS

### Task 1: Prometheus Configuration Audit
**File**: `~/.docker/prometheus/config/prometheus.yml`

Verify:
- [ ] All scrape jobs defined
- [ ] All targets reachable
- [ ] Scrape intervals appropriate
- [ ] Relabeling rules correct
- [ ] Recording rules configured
- [ ] Alert rules loaded
- [ ] Remote write configured (if applicable)
- [ ] Storage retention settings

**Commands**:
```bash
# Check Prometheus targets
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job, health, lastError}'

# Check scrape configs
curl -s http://localhost:9090/api/v1/status/config | jq -r '.data.yaml' | grep -A5 "scrape_configs"

# Check loaded rules
curl -s http://localhost:9090/api/v1/rules | jq '.data.groups[].rules[] | {alert, expr}'

# Check Prometheus metrics about itself
curl -s http://localhost:9090/api/v1/query?query=up | jq '.data.result[] | {job, instance, value}'
```

---

### Task 2: Grafana Dashboards Audit
**Access**: http://10.10.0.1:3000

Verify each dashboard:
- [ ] **01-infrastructure**: Master/Lady system metrics
- [ ] **02-docker**: Container metrics (CPU, RAM, network)
- [ ] **03-traefik**: Reverse proxy metrics
- [ ] **04-pihole**: DNS metrics
- [ ] **05-crowdsec**: Security metrics
- [ ] **06-headscale**: VPN metrics
- [ ] **07-monitoring**: Prometheus/Loki/Grafana metrics
- [ ] **08-mailcow**: Email system metrics (if exists)
- [ ] **09-services**: General service health
- [ ] **10-logs**: Loki log exploration
- [ ] **11-alerts**: Alertmanager status

**For each dashboard panel**:
```bash
# Export dashboard JSON
curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" \
  http://localhost:3000/api/dashboards/uid/<dashboard-uid> | jq '.dashboard'

# Check panel queries
jq '.panels[] | {title, targets}' dashboard.json

# Verify data sources
curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" \
  http://localhost:3000/api/datasources | jq '.[] | {name, type, url}'
```

---

### Task 3: Loki & Promtail Audit
**Loki**: Log aggregation server  
**Promtail**: Log shipping agent (Master + Lady)

Verify:
- [ ] Promtail running on Master
- [ ] Promtail running on Lady
- [ ] Promtail scrape configs complete
- [ ] All Docker containers scraped
- [ ] All systemd services scraped
- [ ] All file logs scraped
- [ ] Loki receiving logs
- [ ] Loki labels correct
- [ ] Loki retention policy
- [ ] Logs queryable in Grafana

**Commands**:
```bash
# Check Promtail targets
curl -s http://localhost:9080/targets | jq '.activeTargets'

# Query Loki
curl -s 'http://localhost:3100/loki/api/v1/query?query={job="docker"}' | jq '.data.result'

# Check log labels
curl -s 'http://localhost:3100/loki/api/v1/labels' | jq '.data'

# Count logs per job
curl -s 'http://localhost:3100/loki/api/v1/query?query=count_over_time({job=~".+"}[1h])' | jq '.data.result'
```

---

### Task 4: Alertmanager Configuration Audit
**File**: `~/.docker/alertmanager/config/alertmanager.yml`

Verify:
- [ ] Global config (SMTP, API keys)
- [ ] Route tree defined
- [ ] Receiver configs (ntfy, gotify, email)
- [ ] Inhibition rules (avoid alert spam)
- [ ] Grouping rules
- [ ] Repeat intervals
- [ ] Alert templates

**Commands**:
```bash
# Check Alertmanager config
curl -s http://localhost:9093/api/v2/status | jq '.config'

# Check active alerts
curl -s http://localhost:9093/api/v2/alerts | jq '.[] | {labels, status, startsAt}'

# Check silences
curl -s http://localhost:9093/api/v2/silences | jq '.[] | {matchers, startsAt, endsAt, comment}'

# Test alert
curl -XPOST http://localhost:9093/api/v1/alerts -d '[{
  "labels": {"alertname":"TestAlert","severity":"warning"},
  "annotations": {"summary":"Test alert from audit"}
}]'
```

---

### Task 5: Node-Exporter Metrics Audit
**Master**: http://localhost:9100/metrics  
**Lady**: http://100.64.0.2:9100/metrics

Verify metrics exist:
- [ ] CPU metrics (node_cpu_*)
- [ ] Memory metrics (node_memory_*)
- [ ] Disk metrics (node_disk_*, node_filesystem_*)
- [ ] Network metrics (node_network_*)
- [ ] Load average (node_load*)
- [ ] Uptime (node_boot_time_seconds)
- [ ] Temperature (node_hwmon_temp_celsius)
- [ ] Systemd metrics (node_systemd_*)
- [ ] Textfile collector enabled
- [ ] Custom metrics (if any)

---

### Task 6: cAdvisor Container Metrics Audit
**URL**: http://localhost:8080

Verify:
- [ ] All containers visible
- [ ] CPU usage per container
- [ ] Memory usage per container
- [ ] Network I/O per container
- [ ] Disk I/O per container
- [ ] Container restart counts
- [ ] Prometheus scrapes cAdvisor

---

### Task 7: Docker Logs Integration
**All containers must ship logs to Loki**

Verify via Promtail config:
```yaml
scrape_configs:
  - job_name: docker
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
```

Check:
- [ ] All Master containers in Loki
- [ ] All Lady containers in Loki
- [ ] Logs parseable/searchable
- [ ] Container labels preserved
- [ ] Timestamps correct

---

### Task 8: Systemd Journal Integration

Verify Promtail scrapes journald:
```yaml
scrape_configs:
  - job_name: systemd-journal
    journal:
      path: /var/log/journal
      labels:
        job: systemd-journal
```

Check logs for:
- [ ] SSH (sshd)
- [ ] Docker daemon
- [ ] Headscale
- [ ] Tailscale
- [ ] fail2ban
- [ ] UFW
- [ ] systemd itself
- [ ] All timers/services

---

### Task 9: Cron Job Monitoring

**Requirements**:
- [ ] Cron job execution tracked
- [ ] Cron job failures alerted
- [ ] Cron job duration metrics
- [ ] Last successful run timestamp

**Implementation check**:
```bash
# Check if cron jobs write metrics
ls -la ~/.copilot/metrics/*.prom

# Verify node-exporter textfile collector reads them
curl -s http://localhost:9100/metrics | grep "^cron_"

# Check Prometheus has cron metrics
curl -s 'http://localhost:9090/api/v1/query?query=cron_job_last_success' | jq '.data.result'
```

---

### Task 10: Service Health Monitoring

**Uptime Kuma**: http://localhost:3001

Verify all services monitored:
- [ ] Master services
- [ ] Lady services
- [ ] External endpoints
- [ ] SSL certificate expiry
- [ ] DNS resolution
- [ ] HTTP status codes
- [ ] Response times
- [ ] Uptime percentage
- [ ] Downtime alerts

---

### Task 11: Alert Rules Completeness

**Every service must have alerts for**:
- [ ] Service down (up == 0)
- [ ] High CPU usage (> 80%)
- [ ] High memory usage (> 90%)
- [ ] Disk space low (< 10%)
- [ ] High error rate
- [ ] Slow response time
- [ ] Certificate expiry (< 7 days)
- [ ] Backup failures

**Check alert rule files**:
```bash
ls -la ~/.docker/prometheus/rules/*.yml

# Validate rules
docker exec prometheus promtool check rules /etc/prometheus/rules/*.yml
```

---

### Task 12: Notification Testing

**Test each channel**:
```bash
# Test Ntfy
curl -d "Test from monitoring audit" https://ntfy.quietly.its.me/alerts

# Test Gotify
curl -X POST "http://localhost:8082/message?token=$GOTIFY_TOKEN" \
  -F "title=Test Alert" \
  -F "message=Monitoring audit test" \
  -F "priority=5"

# Test Alertmanager routing
curl -XPOST http://localhost:9093/api/v1/alerts -d '[{
  "labels": {"alertname":"TestAlert","severity":"critical"},
  "annotations": {"summary":"Critical test alert"}
}]'
```

Verify:
- [ ] Ntfy notification received
- [ ] Gotify notification received
- [ ] Alert visible in Alertmanager UI
- [ ] Alert appears in Grafana

---

### Task 13: Grafana Data Source Health

**Verify all data sources connected**:
```bash
# Test Prometheus data source
curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" \
  http://localhost:3000/api/datasources/proxy/1/api/v1/query?query=up | jq '.status'

# Test Loki data source
curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" \
  http://localhost:3000/api/datasources/proxy/2/loki/api/v1/labels | jq '.status'
```

Check:
- [ ] Prometheus data source working
- [ ] Loki data source working
- [ ] Query response times < 1s
- [ ] No timeout errors

---

### Task 14: Log Retention & Rotation

**Verify policies**:
- [ ] Prometheus retention: 30 days (`--storage.tsdb.retention.time=30d`)
- [ ] Loki retention: 30 days (config)
- [ ] Docker logs: rotated (max-size, max-file)
- [ ] System logs: logrotate configured
- [ ] Backup logs: cleaned up

**Commands**:
```bash
# Check Prometheus retention
curl -s http://localhost:9090/api/v1/status/runtimeinfo | jq '.data.storageRetention'

# Check Loki config
docker exec loki cat /etc/loki/local-config.yaml | grep -A5 "retention"

# Check Docker log rotation
docker inspect traefik | jq '.[0].HostConfig.LogConfig'

# Check logrotate
cat /etc/logrotate.d/*
```

---

### Task 15: Custom Metrics Export

**Verify custom textfile collector metrics**:
```bash
# Check textfile directory
ls -la /var/lib/node_exporter/textfile_collector/

# Check if node-exporter reads them
curl -s http://localhost:9100/metrics | grep -v "^#" | grep -v "^node_" | head -20
```

**Required custom metrics**:
- [ ] Backup job status
- [ ] Cron job execution
- [ ] Script execution status
- [ ] Custom application metrics

---

## 📊 DELIVERABLES

**🚨 MANDATORY**: After completing this audit, you MUST provide a comprehensive action plan with detailed TODO list saved in `.reports/MONITORING_SYSTEM.md/ACTION_PLAN_TODO.md` containing:
- Prioritized tasks (🔴 Critical → 🟡 High → 🟢 Medium → ⚪ Low)
- Exact commands to execute
- Time estimates per task
- Total effort summary
- Dependencies between tasks
- Implementation order

### Audit Report Structure

Create in `.reports/audits/monitoring/YYYYMMDD-HHMMSS/`:

**1. EXECUTIVE_SUMMARY.md**
- Overall grade (A+ to F)
- Critical findings count
- Services audited count
- Compliance percentage

**2. FINDINGS_BY_CATEGORY.md**
- Logging: What works, what's missing
- Metrics: Coverage analysis
- Alerting: Rule completeness
- Dashboards: Dashboard quality
- Notifications: Channel reliability

**3. SERVICE_BY_SERVICE_AUDIT.md**
- Table: Service | Logging | Metrics | Alerts | Dashboard | Grade
- Detailed findings for each service

**4. GRAFANA_DASHBOARD_AUDIT.md**
- Dashboard-by-dashboard analysis
- Panel functionality verification
- Data source connectivity
- Query performance

**5. ALERT_RULES_AUDIT.md**
- All alert rules listed
- Coverage gaps identified
- Threshold recommendations
- Missing alerts

**6. CONFIGURATION_ISSUES.md**
- Prometheus config problems
- Loki/Promtail config problems
- Alertmanager config problems
- Grafana config problems

**7. RECOMMENDATIONS.md**
- Quick wins (< 1 hour each)
- High priority (1-4 hours each)
- Medium priority (4-8 hours each)
- Long term improvements

**8. ACTION_PLAN.md**
- Prioritized TODO list
- Time estimates
- Implementation order
- Success criteria

**9. RELIABILITY_ASSESSMENT.md**
- Current system reliability grade
- MTTR (Mean Time To Recover)
- MTTD (Mean Time To Detect)
- Alert fatigue analysis
- False positive rate

**10. IMPROVEMENT_ROADMAP.md**
- Phase 1: Critical fixes (Week 1)
- Phase 2: High priority (Week 2-3)
- Phase 3: Enhancements (Month 2)
- Phase 4: Advanced features (Quarter 2)

---

## ✅ SUCCESS CRITERIA

Audit is complete when:
- [ ] All 23 Master Docker services audited
- [ ] All 31 Lady Docker services audited
- [ ] All native systemd services audited
- [ ] All cron jobs audited
- [ ] All Grafana dashboards verified
- [ ] All Prometheus targets checked
- [ ] All Loki log sources verified
- [ ] All alert rules validated
- [ ] All notification channels tested
- [ ] Report files created in `.reports/audits/monitoring/`
- [ ] Action plan with exact TODO list created
- [ ] Current reliability grade assigned (A+ to F)
- [ ] Improvement recommendations provided

---

## 🚫 AUDIT CONSTRAINTS

**READ-ONLY**: Do NOT:
- ❌ Change any configurations
- ❌ Restart any services
- ❌ Modify alert rules
- ❌ Create new dashboards
- ❌ Delete anything
- ❌ Run load tests
- ❌ Send real production alerts

**DO**:
- ✅ Read all configs
- ✅ Query all APIs
- ✅ Check logs
- ✅ Verify connectivity
- ✅ Test with dummy data only
- ✅ Document everything
- ✅ Provide recommendations

---

## 📝 AUDIT EXECUTION CHECKLIST

### Pre-Audit
- [ ] Access to Master server verified
- [ ] Access to Lady server verified
- [ ] Grafana credentials available
- [ ] Prometheus accessible
- [ ] Loki accessible
- [ ] Report directory created

### During Audit
- [ ] Follow checklist systematically
- [ ] Document every finding
- [ ] Take screenshots of issues
- [ ] Export relevant configs
- [ ] Note timestamps
- [ ] Record metrics values

### Post-Audit
- [ ] All findings documented
- [ ] Report files created
- [ ] Action plan written
- [ ] Grade assigned
- [ ] Recommendations prioritized
- [ ] Files committed to git

---

## 🎯 TARGET: A+++ MONITORING SYSTEM

**A+++ Requirements**:
- ✅ 100% service coverage (all native + Docker)
- ✅ All logs aggregated in Loki
- ✅ All metrics in Prometheus
- ✅ All services have dashboards
- ✅ All critical metrics have alerts
- ✅ Multi-channel notifications working
- ✅ No missing data gaps
- ✅ Sub-minute detection time
- ✅ Clear, actionable alerts
- ✅ Zero false positives
- ✅ Complete observability

**Current Estimate**: B+ (Good but incomplete)  
**Target After Fixes**: A+++ (World-class)

---

## 📞 CONTACT & SUPPORT

**Requester**: qui3tly  
**Review**: Upon completion  
**Questions**: Ask before making assumptions  
**Timeline**: Complete within reasonable time  
**Priority**: HIGH (blocking Phase IV planning)

---

**AUDIT START DATE**: TBD (when external agent accepts)  
**EXPECTED COMPLETION**: 4-8 hours of audit work  
**REPORT DELIVERY**: Within 24 hours of completion
