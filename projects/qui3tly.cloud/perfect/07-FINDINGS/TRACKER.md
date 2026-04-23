# Findings Tracker

> **Format**: CSV-in-markdown for greppability
> **Severity**: P0 (time-bomb) > P1 (high) > P2 (medium) > P3 (low)
> **Status**: OPEN | IN-PROGRESS | FIXED | WAIVED

| ID | Severity | Status | Title | Host | Discovered | Evidence | Owner Action |
|---|---|---|---|---|---|---|---|
| F-0001 | **P0** | OPEN | Cloudflare DNS-01 token invalid (err 9109) — **ENTIRE Lady fleet** (14 FQDNs) expires 4-17 days. 10 FQDNs expire 4-5 days (Apr 28-29): `mail / autoconfig / autodiscover / home / mta-sts / quietly.online / cloud / nextcloud / odoo / office`. **Mailcow + Nextcloud + Odoo + OnlyOffice + Lady landing ALL lose HTTPS.** | master+lady | 2026-04-23 | `09-EVIDENCE/12_fqdn_sweep_*.txt`, `04_monitoring_pipeline_probe_*.txt` | **Owner**: provide new CF API token |
| F-0002 | P1 | IN-PROGRESS | Alerting pipeline — root cause now identified as F-0019 (missing rules). Webhook chain itself tests fine; 47 rules loaded, 20/20 targets up, 0 silences. | master | 2026-04-23 | `09-EVIDENCE/04_monitoring_pipeline_probe_*.txt` | Close once F-0019 closes |
| F-0003 | P1 | OPEN | `~/.governance/MONITORING.md` contains plaintext Gotify credential — violates `.governance/SECRETS.md` | master (doc) | 2026-04-23 | `~/.governance/MONITORING.md` | **Owner**: rotate Gotify admin pwd; then I scrub doc |
| F-0004 | P3 | FIXED | `SYSTEMD_SERVICES.md` claimed wait-online masked on Lady only — actually masked on BOTH. Master daemon-reload executed. | master+lady | 2026-04-23 | `09-EVIDENCE/systemd_both_*.txt` + live verify | — |
| F-0005 | P2 | OPEN | AIDE exclusions incomplete — `service-monitor.log` still hashed | master | 2026-04-23 | `09-EVIDENCE/01F_master_sweep_*.txt` | Re-verify exclusions; may need re-`aideinit` |
| F-0006 | P3 | OPEN | Lady container count drift: docs say 39, actual 38 | lady (doc) | 2026-04-23 | `inv_lady_*.txt` | Bundled with F-0007/16/17 — doc sweep |
| F-0007 | P3 | OPEN | EdgeRouter WAN IP drift: doc `178.20.30.40`, wg endpoint `62.4.55.119` | master (doc) | 2026-04-23 | `inv_master_*.txt` | Bundled doc sweep |
| F-0008 | P2 | OPEN | Master headscale listens `0.0.0.0:8085/tcp` — external exposure check pending | master | 2026-04-23 | `inv_master_*.txt` | Phase 03A external nmap |
| F-0009 | P1 | OPEN | UniFi binds `0.0.0.0:6789/tcp` + `0.0.0.0:10001/udp` (STUN 3478/udp OK) | lady | 2026-04-23 | `inv_lady_*.txt` | Compose edit — **L2** |
| F-0010 | P1 | OPEN | `mailcow-tlsa` post-renewal `docker exec postfix-mailcow postfix reload` fails exit 1 | lady | 2026-04-23 | `09-EVIDENCE/systemd_both_*.txt` | Investigate in Mailcow postfix container |
| F-0011 | P1 | OPEN | `admin-panel` container hot-installs pkgs on boot, runs as root, SSH key mounted, Flask code unreviewed | master | 2026-04-21 | `_archive/perfection_20260421/REPORT.md §8` | Code + secrets review before any other change |
| F-0012 | P1 | OPEN | Zero container `mem_limit`/`cpus` on both nodes (21 Master + 14+ Lady) — class level | master+lady | 2026-04-21 | `_archive/perfection_20260421/REPORT.md §9B` | Phase 06C roll-out |
| F-0013 | P1 | OPEN | No evidenced backup chain on Lady for 215 GB app data (Mailcow, Nextcloud, Odoo, UniFi, HA, Frigate) | lady | 2026-04-20 | `_archive/perfection_20260421/REPORT.md §P0-2` | Phase 05A |
| F-0014 | P1 | OPEN | No restore drill ever executed on either host | master+lady | 2026-04-20 | same | Phase 05B |
| F-0015 | P2 | OPEN | 6/13 audit requests un-started: 01 Project, 02 DNS, 06 Mail, 08 Branding, 12 FQDN(✅done), 13 Credentials(✅done) — now 4/13 left | — | 2026-04-23 | `~/personal/audits/` | **Owner**: priority call |
| F-0016 | P3 | FIXED | Stale root `TODO.md` said "maintenance mode, all done" (Feb-17) | — | 2026-04-23 | git diff | Rewritten as pointer 2026-04-23 22:53Z |
| F-0017 | P3 | FIXED | Repo memory claimed AM at `10.10.0.1:9093` — actually via Traefik `alertmanager.quietly.its.me` | master | 2026-04-23 | live verify 200 OK | Memory corrected 2026-04-23 22:54Z |
| F-0018 | P2 | OPEN | `acme.json` historically committed to git — current `.gitignore` excludes but history not rewritten | master | 2026-04-23 | `_archive/.../01A_git_secret_leak_*.md` | git history rewrite (risk assessment) |
| **F-0019** | **P1** | **OPEN** | **Critical alert rules MISSING from Prometheus: SSL-cert rules, systemd-unit rules, Tailscale rules — none loaded despite repo-memory claim. `probe_ssl_earliest_cert_expiry` IS collected (6 certs, some 4 days), no rule to evaluate → F-0001 never alerted.** | master | 2026-04-23 | `09-EVIDENCE/04_monitoring_pipeline_probe_*.txt`, `F-0019_MISSING_ALERT_RULES.md` | Write rules + hot-reload (L1 author, L2 load) |
| F-0020 | P3 | FIXED (false-positive) | Lady `~/.docker-compose/nextcloud/.env` reported 777 — is a **symlink** to `~/.secrets/nextcloud/.env` (600). Symlink perms are cosmetic on Linux; target perms apply. Verified `stat -L` 2026-04-23 23:25Z. | lady | 2026-04-23 | live verify | — |
| F-0021 | P2 | FIXED | `~/.secrets/backup/` dir 755 on BOTH hosts → `chmod 700` applied 2026-04-23 23:22Z | master+lady | 2026-04-23 | `09-EVIDENCE/13_credentials_sweep_*.txt` + verify | — |
| F-0022 | P2 | FIXED | Lady `~/.secrets/crowdsec/` dir 755 → `chmod 700` applied 2026-04-23 23:22Z | lady | 2026-04-23 | same | — |
| F-0023 | P3 | OPEN | Secrets hygiene: Grafana admin pwd in 4 different paths (`.secrets/grafana/admin-password`, `.secrets/grafana/admin_password`, `.secrets/monitoring/grafana_admin_password`, `.secrets/monitoring/grafana_password.txt`) — drift risk | master | 2026-04-23 | same | Consolidate to one canonical path |
| F-0024 | P3 | OPEN | Master `~/.ssh/` contains 7 private keys (`qui3tly.com`, `quietly.co.me`, `quietly-home`, `quietly.its.me`, `quietly-mac`, `quietly.online`) — overlap + purpose unclear | master | 2026-04-23 | same | Review + consolidate |

## Severity definitions

- **P0** — time-bomb: outage within days without intervention, or actively being exploited
- **P1** — high: critical control does not work OR governance standard violated with real risk
- **P2** — medium: correctness issue with no immediate user impact but will compound
- **P3** — low: cosmetic / doc / convenience

## Current tally (2026-04-23 23:30 UTC)

| Severity | Open | Fixed | Total |
|---|---|---|---|
| P0 | 1 | 0 | 1 |
| P1 | 7 | 0 | 7 |
| P2 | 4 | 2 | 6 |
| P3 | 5 | 4 | 9 |
| **Total** | **17** | **7** | **24** |

**Autonomous fixes executed 2026-04-23** (no owner input needed, all L1 or read-only):
- F-0004 daemon-reload master (live verify: inactive/masked both hosts)
- F-0016 stale root TODO → pointer
- F-0017 repo memory AM IP corrected
- F-0020 cleared as false-positive with proof
- F-0021 backup dir 700 (both hosts)
- F-0022 crowdsec dir 700 (Lady)

**Discovered during execution** (+6 previously invisible): F-0019, F-0020-24.
