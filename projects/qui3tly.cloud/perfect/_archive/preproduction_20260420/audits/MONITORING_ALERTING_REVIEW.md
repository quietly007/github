# MONITORING AND ALERTING REVIEW — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent

---

## Monitoring Stack Status

Master (hub):
  prometheus      prom/prometheus:v2.54.1          Up 7d  healthy
  alertmanager    prom/alertmanager:v0.27.0         Up 7d  healthy
  grafana         grafana/grafana:11.4.0            Up 7d  healthy
  loki            grafana/loki:3.3.2                Up 7d  healthy
  promtail        grafana/promtail:3.4.2            Up 7d  healthy
  blackbox        prom/blackbox-exporter:v0.28.0   Up 7d  healthy
  cadvisor        gcr.io/cadvisor/cadvisor:v0.52.1 Up 7d  healthy
  node-exporter   prom/node-exporter:v1.9.0         Up 7d  —
  uptime-kuma     f48d816cb746 (NO TAG)             Up 7d  healthy
  ntfy            binwiederhier/ntfy:v2.16.0        Up 7d  healthy
  gotify          gotify/server:2.5.0               Up 7d  healthy

Lady (remote source):
  node-exporter   prom/node-exporter:v1.9.0         Up 6d  —
  cadvisor        gcr.io/cadvisor/cadvisor:v0.52.1 Up 6d  healthy
  mysqld-exporter prom/mysqld-exporter:v0.16.0      Up 6d  —
  promtail        grafana/promtail:3.4.2            Up 2m  healthy

---

## Prometheus Target Health

From evidence/10_master_snapshot:
  targets_up=20/20
  alerts=0

Assessment: All 20 targets UP at snapshot time. Zero active alerts. Strongest positive signal in this audit.

External challenge: 20/20 with 0 alerts is ideal but requires depth validation:
  1. Are the right services being scraped? (Mailcow metrics, Nextcloud metrics, Odoo metrics likely missing)
  2. Are alert rules appropriately tuned? (0 alerts = no problems OR alerts not firing when they should)
  3. Is blackbox prober testing the right endpoints?

---

## Alert Pipeline — NOT End-to-End Tested

Status: todo/PREPRODUCTION_TODO.md shows: [ ] Test Alertmanager routing channels end-to-end

Test procedure:
  # Fire test alert
  curl -XPOST http://localhost:9093/api/v2/alerts \
    -H "Content-Type: application/json" \
    -d '[{"labels":{"alertname":"TestAlert","severity":"critical"},"annotations":{"summary":"External audit test"},"startsAt":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}]'

  # Verify Ntfy push notification received on device
  # Verify Gotify notification visible in UI
  # Record time-to-notification (target: < 5 minutes)

  # Resolve test alert
  curl -XPOST http://localhost:9093/api/v2/alerts \
    -H "Content-Type: application/json" \
    -d '[{"labels":{"alertname":"TestAlert","severity":"critical"},"endsAt":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}]'

---

## Alert Rule Quality — Needs Validation

Alert rules not captured in evidence. Check:
  curl -s http://localhost:9090/api/v1/rules | jq '.data.groups[].rules[].name'

Required mandatory rules (add if missing):

  NodeDown:         up == 0 for 5m                          severity: critical
  HighMemory:       node_memory_MemAvailable < 15%          severity: warning
  HighDisk:         disk usage > 80%                        severity: warning
  CriticalDisk:     disk usage > 90%                        severity: critical
  ContainerOOM:     container_oom_events_total > 0          severity: critical
  TargetDown:       up == 0 (any scrape target)             severity: critical
  CertExpiry30d:    ssl_cert_not_after - time() < 30d       severity: warning
  CertExpiry7d:     ssl_cert_not_after - time() < 7d        severity: critical
  HighLoad:         load1 > (cpu_count * 0.8) for 10m       severity: warning
  BackupFailure:    (custom metric from backup job)         severity: critical

---

## Loki Log Aggregation

Loki healthy on Master. Promtail agents on both nodes.
Needs Validation:
  - Confirm all critical service logs are shipped (Mailcow, Nextcloud, Traefik access logs)
  - Confirm Loki retention policy is set (default = unlimited = disk exhaustion risk)
  - Confirm log-based alert rules exist (e.g., high 5xx rate in Traefik access logs)

  docker exec loki cat /etc/loki/loki.yml | grep -A10 "retention"

---

## Blackbox Probe Coverage

Expected targets (confirm each is probed):
  https://qui3tly.cloud               — public landing
  https://mail.quietly.online         — Mailcow webUI
  https://nextcloud.quietly.online    — Nextcloud
  https://traefik.qui3tly.cloud       — should redirect to auth
  https://grafana.qui3tly.cloud       — Grafana

  curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | select(.scrapeUrl | contains("blackbox")) | .labels.instance'

---

## Dual Notification Risk

Both Ntfy and Gotify run on Master. If Master goes down, both notification channels are silenced simultaneously.
A critical Lady failure while Master is down would generate no alert delivery.
Recommendation: Route at least one critical alert class to an external Ntfy cloud instance or separate Alertmanager.

---

## Uptime Kuma

Running as image digest f48d816cb746 (no tag). Governance issue — cannot audit version.
Action: Pin to named tag (louislam/uptime-kuma:latest or specific version).

---

## Monitoring Summary

| Component            | Status     | Action Required                        |
|----------------------|------------|----------------------------------------|
| Prometheus targets   | 20/20 UP   | Validate alert rule coverage           |
| Alertmanager         | Running    | Test routing end-to-end                |
| Grafana              | Healthy    | Add preproduction KPI dashboard        |
| Loki                 | Healthy    | Confirm retention policy set           |
| Promtail (both)      | Running    | Confirm log stream completeness        |
| Blackbox             | Healthy    | Validate probe target list             |
| cAdvisor (both)      | Healthy    | Will improve with container limits     |
| Uptime Kuma          | Healthy    | Fix image tag; confirm monitor list    |
| Ntfy / Gotify        | Healthy    | Test delivery end-to-end               |
| Alert rules          | Unknown    | Review and add missing mandatory rules |
| Backup failure alert | Missing    | Add after backup implementation        |

Grade: B — strong foundation, but untested alert pipeline and missing mandatory rule classes.
