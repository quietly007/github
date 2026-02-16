# TODO — qui3tly.cloud

**Current work:** Fix broken things (Step 1 of [PLAN.md](PLAN.md))  
**Last log sweep:** 2026-02-16 02:30 CET

---

## Active

| # | Task | Server | Status |
|---|------|--------|--------|
| 1 | UISP internal restart loop — `web.sh` watchdog timeout, `Makefile:22`, ~91 errors/2h | Lady | INVESTIGATING |

**UISP detail:** Container never actually restarts (RestartCount: 0). Port 8081 returns 200.  
App works but internal `unms_ready.sh` watchdog is too aggressive — times out before UNMS backend is ready.  
CPU: 101%, MEM: 1.68 GiB. This is **log noise from a misconfigured timeout**, not a broken service.

## Next (after Active)

| # | Task | Blocked by |
|---|------|------------|
| 2 | External port scan (both servers) | — |
| 3 | Secrets audit (`~/.secrets/` permissions) | — |
| 4 | Validate all Grafana dashboards | — |
| 5 | Test Alertmanager → Gotify alert delivery | — |
| 6 | Write 54 service runbooks | — |
| 7 | Consolidate 452 scattered doc files | — |
| 8 | Test 3 DR methods, measure actual RTO | 6 |
| 9 | Final verification pass | 2-8 |

## Done

| # | Task | Date |
|---|------|------|
| — | Infrastructure baseline (64 containers documented) | 2026-02-15 |
| — | 8 CCIE-level diagrams (network, firewall, DNS, TLS, packet flow, routing, dependencies, data viz) | 2026-02-16 |
| — | DNS architecture documented (5 resolvers, 3 zones, 6 resolution chains) | 2026-02-16 |
| — | TLS certificate map (17 certs, issuance flow, termination points) | 2026-02-16 |
| — | Project structure reboot (archived PM theater, clean CCIE structure) | 2026-02-16 |
| — | CrowdSec WAL mode enabled (both servers) | 2026-02-16 |
| — | Lady fail2ban jails added: traefik-auth + recidive (now matches Master: 3 jails) | 2026-02-16 |
| — | Docker prune: 2.4GB reclaimed on Master, stale overlay2 layers removed | 2026-02-16 |
| — | cAdvisor overlay2 errors: FIXED (stale layers were the cause) | 2026-02-16 |

## Closed (not broken / false alarm)

| Issue | Verdict |
|-------|---------|
| Odoo DB connection refused | **NOT REPRODUCING** — 0 errors/h, CPU 0%, MEM 189MB, healthy |
| cAdvisor 155% CPU (Lady) | **NOT REPRODUCING** — 0.96% CPU, 385MB, zero errors |
| CrowdSec Traefik log parser broken | **NOT BROKEN** — Master: 17.7k parsed/0 unparsed, Lady: 114.9k parsed/3 unparsed |
| Blackbox probe `mail.quietly.online` → 403 | **BY DESIGN** — Mailcow nginx returns 403 on root. `http_any` module accepts 403. Probe passes. |
| Blackbox probe `quietly.its.me` → 302 | **BY DESIGN** — redirects to Authelia. Expected for VPN-only services. |
| Dovecot SSL errors | **INTERNET SCANNERS** — IPs (167.94.x, 3.130.x, 86.54.x) probing IMAP with bad TLS. Normal for port 993. |
| Ofelia 389 "error" lines/h | **FALSE POSITIVE** — every line says "error: none". Zero actual failures. |
| Unbound DNS healthcheck | **NOT REPRODUCING** — `docker inspect` shows Health: healthy |

## Out of Scope

IPv6, CCTV/NVR, mobile apps, Montefish deployment, additional servers (Beauty/Madam), multi-site VPN, OSPF/FRR, branding/logo assets.
