# F-0019 — Critical alert rules missing from Prometheus

**Severity**: **P1 (control failure — but enables P0 blast radius)**
**Status**: OPEN
**Discovered**: 2026-04-23 23:10 UTC (Phase 04 probe)
**Evidence**: `09-EVIDENCE/04_monitoring_pipeline_probe_20260423T230539Z.txt`
**Hosts**: master
**Root cause class**: alerting pipeline — rules layer

---

## What the probe proved

**Claim in repo memory** (`~/memories/repo/qui3tly_cloud_core.md`):
> "SSLCertExpiring14Days (warn), SSLCertExpiring7Days (critical), SSLCertExpired, TailscaleDisconnected"
> exist in `~/.docker/prometheus/config/alerts/`.

**Reality, verified via Prometheus API 2026-04-23 23:10Z:**

- **47 alerting rules loaded** across 13 rule groups
- **Zero match** the query pattern SSL/Cert/systemd/Tailscale
- List of all 47 rules attached below

Yet blackbox IS probing 6 endpoints and IS collecting `probe_ssl_earliest_cert_expiry`:

| Endpoint | Days until expiry |
|---|---|
| `https://mail.quietly.online` | **4 days** ⚠️ |
| `https://quietly.online` | **4 days** ⚠️ |
| `https://nextcloud.quietly.online` | **5 days** ⚠️ |
| `https://auth.quietly.its.me` | 41 |
| `https://grafana.quietly.its.me` | 41 |
| `https://quietly.its.me` | 41 |

So the pipeline state is:

```
blackbox → scrape → Prometheus storage → ??? NO RULE EVALUATES THIS ??? → Alertmanager → webhook → phone
  ✅         ✅           ✅                    ❌                         (never reached)
```

**The pipeline works perfectly. There is simply nothing telling it to fire.**

---

## Sub-gaps also uncovered

1. No rule queries `node_systemd_unit_state{state="failed"}==1` → `mailcow-tlsa.service` can fail nightly for months and no alert fires
2. No rule queries `probe_success == 0` for VPN reachability
3. No rule for `cloudflared` tunnel down (headscale-critical)

---

## Blast radius revision for F-0001

F-0001 currently scoped as *"mail.quietly.online expires in 4 days"*. Probe data proves **3 certs** are inside the 7-day window:
- `mail.quietly.online` (4d) — Mailcow SMTP + IMAPS + web
- `quietly.online` (4d) — **public Lady landing**
- `nextcloud.quietly.online` (5d) — Nextcloud UI

If F-0001 is not resolved by 2026-04-27, **Lady loses all HTTPS** (not just mail). That's Nextcloud, OnlyOffice, Odoo, UniFi UI, Home Assistant remote — everything fronted by Lady Traefik with a cert from Let's Encrypt DNS-01.

---

## Remediation (proposed — L1 for rule authoring, L2 for load)

### Immediate (rule-authoring — can be done without any production impact)

Create `~/.docker/prometheus/config/alerts/certs.yml`:

```yaml
groups:
  - name: ssl-certs
    rules:
      - alert: SSLCertExpiring14Days
        expr: (probe_ssl_earliest_cert_expiry - time()) / 86400 < 14
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "SSL cert {{ $labels.instance }} expires in less than 14 days"
      - alert: SSLCertExpiring7Days
        expr: (probe_ssl_earliest_cert_expiry - time()) / 86400 < 7
        for: 10m
        labels:
          severity: critical
        annotations:
          summary: "SSL cert {{ $labels.instance }} expires in less than 7 days"
      - alert: SSLCertExpired
        expr: probe_ssl_earliest_cert_expiry - time() < 0
        for: 1m
        labels:
          severity: critical
```

Create `~/.docker/prometheus/config/alerts/systemd.yml`:

```yaml
groups:
  - name: systemd
    rules:
      - alert: SystemdUnitFailed
        expr: node_systemd_unit_state{state="failed"} == 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Unit {{ $labels.name }} on {{ $labels.instance }} is in failed state"
```

### Deploy (L2 — touches live Prometheus)

```bash
docker exec prometheus kill -HUP 1        # hot-reload, no restart
# verify: curl https://prometheus.quietly.its.me/api/v1/rules | jq '[.data.groups[].rules[]] | length'
#   → expect 47 + N
```

### Full 47-rule inventory for reference

```
container-resources: ContainerHighCPU, ContainerOOMKilled
critical-containers: PortainerDown, NextcloudDown, OdooDown, HomeAssistantDown,
                     OnlyOfficeDown, NtfyDown, GotifyDown, HeadscaleDown
database-containers: MailcowMySQLDown, NextcloudDBDown, OdooDBDown,
                     NextcloudRedisDown, MailcowRedisDown
database-health:     MySQLDown, MySQLHighConnections, MySQLConnectionsFull,
                     MySQLSlowQueries, MySQLReplicationLag
mailcow-health:      MailcowContainerRestarting
mailcow-services:    PostfixDown, DovecotDown, RspamdDown, ClamdDown, SogoDown,
                     MailcowNginxDown, WatchdogDown
network-security:    HighNetworkErrors, DNSDown
security-monitoring: CrowdSecHighActivity, CrowdSecBouncerDown,
                     High5xxErrorRate, High4xxErrorRate
service-health:      TraefikDown, AutheliaDown, AlertmanagerDown, LokiDown,
                     GrafanaDown, PiholeDNSDown, CrowdSecDown
website-probes:      WebsiteSlow
critical:            InstanceDown, HighCPU, HighMemory, HighDisk
warning:             ContainerRestarting
```

**Nothing covering TLS cert lifetime. Nothing covering systemd unit state. Those are the exact two ways F-0001 + F-0010 would have been detected.**

---

## Sign-off

- Analyst: GitHub Copilot (Claude Opus 4.7)
- Evidence: `09-EVIDENCE/04_monitoring_pipeline_probe_20260423T230539Z.txt` + this file
- Proposed fix: write rules, hot-reload — L1 for writing, L2 for load (asks for owner OK before `SIGHUP`)

