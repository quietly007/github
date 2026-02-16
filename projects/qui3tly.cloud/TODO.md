# TODO — qui3tly.cloud

**Current work:** Steps 2+3 complete, UISP waiting on user (Step 1 of [PLAN.md](PLAN.md))  
**Last update:** 2026-02-16 04:00 CET

---

## Active

| # | Task | Server | Status |
|---|------|--------|--------|
| 1 | UISP setup wizard — `isConfigured=false` in DB, needs web UI completion | Lady | BLOCKED (user action) |

**UISP root cause:** `UnmsReadyCommand.php` checks `NmsOption::IS_CONFIGURED` in `nms_option_view` table → returns `false` → UCRM boot loop (278 Makefile error cycles). NMS API works fine (200 on 8081). Fix: complete setup wizard at https://uisp.quietly.online from Mac via Tailscale VPN.

## Next

| # | Task | Blocked by |
|---|------|------------|
| 4 | Configure Uptime Kuma monitors (currently 0) | — |
| 5 | Write service runbooks | — |
| 6 | Test 3 DR methods, measure actual RTO | 5 |
| 7 | Final verification pass | 1-6 |

## Done

| # | Task | Date |
|---|------|------|
| — | Infrastructure baseline (64 containers documented) | 2026-02-15 |
| — | 8 CCIE-level diagrams | 2026-02-16 |
| — | DNS architecture documented | 2026-02-16 |
| — | TLS certificate map | 2026-02-16 |
| — | Project structure reboot | 2026-02-16 |
| — | CrowdSec WAL mode enabled (both servers) | 2026-02-16 |
| — | Lady fail2ban jails added (traefik-auth + recidive) | 2026-02-16 |
| — | Docker prune: 2.4GB reclaimed on Master | 2026-02-16 |
| — | cAdvisor overlay2 errors: FIXED | 2026-02-16 |
| — | Secrets audit: 7 files fixed (4 Master + 3 Lady) → chmod 600 | 2026-02-16 |
| — | UISP image pinned from :latest to digest sha256:b428e73... | 2026-02-16 |
| — | CrowdSec Lady: added port 6060 for Prometheus metrics | 2026-02-16 |
| — | Prometheus: 20/20 targets ALL UP | 2026-02-16 |
| — | Promtail: Docker SD on both servers (container_name labels in Loki) | 2026-02-16 |
| — | Loki: 56 containers labeled, 4 scrape jobs, cross-server collection verified | 2026-02-16 |
| — | Alertmanager: healthy, 4 receivers, routes to ntfy | 2026-02-16 |
| — | Alert delivery: tested Alertmanager→ntfy, message confirmed received | 2026-02-16 |
| — | Grafana: 10 dashboards, 191 panels, 2 data sources (Prometheus+Loki) healthy | 2026-02-16 |
| — | Port scan: 4 exposed ports locked to VPN (blackbox 9115, frigate 5000/8554/8555, mysqld-exporter 9104) | 2026-02-16 |
| — | mysqld-exporter: created compose file, pinned v0.16.0, VPN-only port | 2026-02-16 |
| — | Documentation cleanup: 7 fixes (merged 28 docs, deleted archives, compressed reports, rewrote copilot-instructions + DOC_INVENTORY + START_HERE) | 2026-02-16 |

## Closed (not broken / false alarm)

| Issue | Verdict |
|-------|---------|
| Odoo DB connection refused | **NOT REPRODUCING** — 0 errors/h, healthy |
| cAdvisor 155% CPU (Lady) | **NOT REPRODUCING** — 0.96% CPU |
| CrowdSec Traefik log parser broken | **NOT BROKEN** — 17.7k parsed/0 unparsed |
| Blackbox probe `mail.quietly.online` → 403 | **BY DESIGN** — Mailcow nginx returns 403 on root |
| Blackbox probe `quietly.its.me` → 302 | **BY DESIGN** — redirects to Authelia |
| Dovecot SSL errors | **INTERNET SCANNERS** — IPs probing IMAP with bad TLS |
| Ofelia 389 "error" lines/h | **FALSE POSITIVE** — every line says "error: none" |
| Unbound DNS healthcheck | **NOT REPRODUCING** — healthy |

## Out of Scope

IPv6, CCTV/NVR, mobile apps, Montefish deployment, additional servers (Beauty/Madam), multi-site VPN, OSPF/FRR, branding/logo assets.
