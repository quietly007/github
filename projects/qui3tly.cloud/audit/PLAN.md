# PLAN.md — Execution Plan & Phase Status

> **Owner**: qui3tly  
> **Agent**: GitHub Copilot (Claude)  
> **Created**: 2026-04-23  
> **Updated**: 2026-04-23

## 🎯 OBJECTIVE

Deliver a **101%-verified** answer to "Can qui3tly.cloud go to production?" with every claim backed by raw evidence under `09-EVIDENCE/`.

## 🧭 METHODOLOGY

1. **Read-only first.** Every phase starts by collecting evidence without touching state.
2. **Evidence → synthesis.** Raw output goes to `09-EVIDENCE/<ts>_<name>.txt`; findings summarised in numbered folders.
3. **Findings tracked.** Each deviation from desired state is logged in `07-FINDINGS/` with severity (P0/P1/P2/P3) and an entry in `08-TODO/MASTER_TODO.md`.
4. **Mutations gated.** Any fix needs L2 owner approval; memory log written per `.governance/`.
5. **Phase gate.** Each phase produces a certificate per `~/.docs/00-standards/PHASE_COMPLETION_TEMPLATE.md`.

## 🚦 CRITICAL PATH (URGENT — 4-day cert cliff)

**P1F — TLS pipeline rescue.** New Cloudflare DNS-01 token required. 13 certs on Lady + 3 on Master renew through it. Earliest expiry: `quietly.online`, `mail.quietly.online`, `mta-sts.quietly.online`, `autoconfig.quietly.online`, `cloud.quietly.online`, `home.quietly.online` → 2026-04-28 02:43 UTC (≈4 days). No execution here until token received.

## 🗺️ PHASE MAP

| # | Phase | Kind | Owner-approval | Folder |
|---|---|---|---|---|
| 01 | Infrastructure Analysis | Read | L0 auto | `01-INFRASTRUCTURE_ANALYSIS/` |
| 02 | Security Analysis | Read | L0 auto | `02-SECURITY_ANALYSIS/` |
| 03 | Penetration Tests | Read | **L1** (install `nmap`, `testssl.sh`, `trivy`) | `03-PENETRATION_TESTS/` |
| 04 | Monitoring & Alerting | Read + **L2** test alert injection | — | `04-MONITORING_ALERTING/` |
| 05 | Backup & DR | Read + **L2** one restore test | — | `05-BACKUP_DR/` |
| 06 | Governance Compliance | Read | L0 auto | `06-GOVERNANCE_COMPLIANCE/` |
| 07 | Findings consolidation | Synthesis | — | `07-FINDINGS/` |
| 08 | TODO derivation | Synthesis | — | `08-TODO/` |
| 10 | Production readiness verdict | Synthesis + owner sign-off | **L3** owner-only | `10-PRODUCTION_READINESS/` |

## 📅 STATUS LEGEND

⬜ not started | 🟡 in progress | ✅ complete | ⚠️ blocked | ❌ failed

## ✅ CURRENT STATUS

| Phase | Status | Last Update | Evidence |
|---|---|---|---|
| 00 — Scaffolding & doc read | ✅ | 2026-04-23 | `~/.docs/` + `~/.governance/` consumed |
| 01A — Master inventory | ✅ | 2026-04-23 | `inv_master_20260423T201406Z.txt` (220 lines) |
| 01B — Lady inventory | ✅ | 2026-04-23 | `inv_lady_20260423T201510Z.txt` (147 lines) |
| 01C — Topology doc | ✅ | 2026-04-23 | `01-INFRASTRUCTURE_ANALYSIS/01_TOPOLOGY.md` |
| 01D — Master service inventory doc | ✅ | 2026-04-23 | `02_SERVICE_INVENTORY_MASTER.md` |
| 01E — Lady service inventory doc | ✅ | 2026-04-23 | `03_SERVICE_INVENTORY_LADY.md` |
| 01F — Systemd snapshot | ✅ | 2026-04-23 | `systemd_both_20260423T202005Z.txt` + `08_SYSTEMD_UNITS.md` |
| 01G — Network interfaces deep-dive | ⬜ | | |
| 01H — DNS architecture | ⬜ | | |
| 01I — Cert inventory (live + acme.json) | 🟡 | partial from 01F sweep | needs live probe |
| 02A — UFW audit (both hosts) | 🟡 | Lady complete via inventory; Master pending | |
| 02B — Port exposure (0.0.0.0 listeners) | 🟡 | captured in inventory; needs synthesis | |
| 02C — SSH posture | ⬜ | | |
| 02D — Secrets sweep + governance scrub | ⬜ | | |
| 02E — CVE scan (trivy) | ⬜ | | |
| 02F — CrowdSec/fail2ban effectiveness | ⬜ | | |
| 02G — OWASP Top 10 per public service | ⬜ | | |
| 03A — External nmap | ⬜ | Needs off-net vantage | |
| 03B — Internal nmap (Tailscale) | ⬜ | | |
| 03C — testssl.sh every endpoint | ⬜ | Needs install | |
| 03D — HTTP security headers | ⬜ | | |
| 03E — Mail probes | ⬜ | | |
| 03F — DNS probes | ⬜ | | |
| 04A — Prometheus targets up/down | ⬜ | | |
| 04B — Alert rules audit | ⬜ | | |
| 04C — Alertmanager routing test | ⬜ | **P0 priority** | |
| 04D — Gotify delivery (priority 5 → phone) | ⬜ | owner device | |
| 04E — Log coverage | ⬜ | | |
| 04F — Uptime-kuma 42 monitors | ⬜ | | |
| 05A — Backup inventory | ⬜ | | |
| 05B — One restore test | ⬜ | **L2 required** | |
| 05C — Contabo snapshots | ⬜ | owner login | |
| 06A — Docs-vs-reality | 🟡 | 4 drifts found | F-0004 F-0006 F-0007 |
| 06B — Ansible reproducibility | ⬜ | | |
| 06C — Docker layout compliance | ⬜ | | |
| 06D — FQDN sweep | ⬜ | | |
| 06E — Governance violations | 🟡 | Gotify password in doc (F-0003) | |

## 🔒 HARD GATES

Production readiness requires **all** of:

1. Zero P0 findings open
2. Zero P1 findings open, OR each P1 has an explicit owner waiver + mitigation
3. Alerting pipeline verified end-to-end (rule → AM → Gotify → phone)
4. One restore-from-backup test passed within last 7 days
5. External nmap shows no unexpected open port
6. CF token valid, all certs ≥ 30 days validity
7. Every running service has an Ansible playbook
8. `~/.copilot/scripts/docs_link_check.sh` returns 0 broken links

## 📌 CHANGE LOG

- 2026-04-23 20:00Z — folder created; canonical docs consumed; this plan committed.
- 2026-04-23 20:30Z — infrastructure phase 01A-F complete; 10 findings open.
