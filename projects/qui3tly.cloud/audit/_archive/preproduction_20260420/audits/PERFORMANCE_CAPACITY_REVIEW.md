# PERFORMANCE AND CAPACITY REVIEW — EXTERNAL AUDIT

Date: 2026-04-21
Auditor: External / Independent

---

## Master — Resource Snapshot

```
Uptime:      7 days, 56 min
Load avg:    4.36 (1m), 2.96 (5m), 2.78 (15m)
Memory:      4.4Gi used / 47Gi total (9%)
Swap:        0B / 2Gi (inactive — good)
Disk:        33G / 985G (4%)
Containers:  25 running
```

Load assessment: 4.36 (1m) is elevated. Memory at 9% does not explain it — points to CPU or I/O pressure.
CPU count NOT in evidence (critical gap). If 2 vCPU: 2x saturation. If 4 vCPU: ~100%.
VS Code server process (pid 319669) is visible in listener snapshot — may contribute significantly to load.

Validation:
  nproc
  ps -eo pid,cmd,%cpu --sort=-%cpu | head -15
  iostat -x 1 5

Disk/Memory: PASS — ample headroom on both. No capacity concern for 12+ months at current rate.

---

## Lady — Resource Snapshot

```
Uptime:      61 days, 21:42
Load avg:    4.68 (1m), 2.85 (5m), 2.59 (15m)
Memory:      8.9Gi used / 47Gi total (19%)
Swap:        0B / 2Gi (inactive — good)
Disk:        215G / 985G (23%)
Containers:  38 running (including 14 Mailcow sub-containers)
```

Load assessment: ELEVATED — likely root cause is ClamAV periodic scans or Nextcloud sync.
Memory: comfortable. 14Gi in buff/cache is healthy Linux behavior. 38Gi available.
Disk: 215G is real live data (Nextcloud, mail, Odoo, UniFi, HA). Monitor monthly. Alert at 70% (690G).

Validation:
  nproc
  docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
  docker logs mailcowdockerized-clamd-mailcow-1 --tail 30

---

## Container Resource Governance — Zero Limits Applied

No memory, CPU, or PID limits on any container on either node.

Risk scenarios:
  - ClamAV scan storm: can starve all 37 other Lady containers of CPU
  - Nextcloud sync storm: MariaDB memory growth can OOM-kill unrelated services
  - Prometheus retention growth: can OOM-kill monitoring itself

Recommended resource classes:

Master:
  Critical infra (traefik, authelia, crowdsec, pihole): mem 512m, cpus 0.5, pids 200
  Monitoring (prometheus, loki, alertmanager): mem 2g, cpus 1.0, pids 500
  Apps (grafana, ntfy, semaphore): mem 512m, cpus 0.5, pids 200
  Utility (node-exporter, cadvisor, blackbox): mem 128m, cpus 0.25, pids 100

Lady:
  Mail (postfix, dovecot, rspamd): mem 1g, cpus 1.0, pids 500
  Antivirus (clamd): mem 2g, cpus 1.5, pids 200
  DB (nextcloud-db, odoo-db, unifi-db): mem 2g, cpus 1.0, pids 300
  Apps (nextcloud, odoo): mem 2g, cpus 1.0, pids 500
  OnlyOffice: test at 4g before restricting — very resource intensive
  Utility (node-exporter, cadvisor, promtail): mem 128m, cpus 0.25, pids 100

---

## Aged Images

Master: cloudflared:2024.12.2, prometheus:v2.54.1, grafana:11.4.0 — all 4-5 months old
Master: uptime-kuma running as raw digest f48d816cb746 (NO TAG — governance issue)
Lady: homeassistant:2024.12.5, nextcloud:29.0.7 (upstream at 30.x)

Action:
  docker system df
  docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedSince}}\t{{.Size}}"
  docker image prune -a --filter "until=720h" --dry-run

---

## Performance Summary

| Metric            | Master    | Lady      | Action                              |
|-------------------|-----------|-----------|-------------------------------------|
| Load average      | ELEVATED  | ELEVATED  | Identify root cause; apply CPU limits |
| Memory            | PASS      | PASS      | Apply limits as safety net          |
| Swap              | PASS      | PASS      | —                                   |
| Disk              | PASS      | MONITOR   | Track monthly; alert at 70%         |
| Container limits  | FAIL      | FAIL      | Apply resource classes (P1)         |
| Image currency    | PARTIAL   | PARTIAL   | Update in maintenance window (P2)   |
