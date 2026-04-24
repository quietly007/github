# Findings Tracker

> **Format**: CSV-in-markdown for greppability
> **Severity**: P0 (time-bomb) > P1 (high) > P2 (medium) > P3 (low)
> **Status**: OPEN | IN-PROGRESS | FIXED | WAIVED

| ID | Severity | Status | Title | Host | Discovered | Evidence | Owner Action |
|---|---|---|---|---|---|---|---|
| F-0001 | **P0** | **FIXED** | Cloudflare DNS-01 token rotated 2026-04-24 01:45 CEST. All 14 Lady certs renewed to 89 days. mailcow-tlsa ran clean. No errors. | master+lady | 2026-04-23 | `09-EVIDENCE/14_cf_token_rotation_20260424T000114Z.md` | — |
| F-0002 | P1 | **FIXED** | Root cause was F-0019 (missing rules). SSL rules now deployed and evaluating; Traefik-renewal failures will now page. | master | 2026-04-24 | `09-EVIDENCE/15_f010_f019_deploy_*.md` | — |
| F-0003 | P1 | OPEN | `~/.governance/MONITORING.md` contains plaintext Gotify credential — violates `.governance/SECRETS.md` | master (doc) | 2026-04-23 | `~/.governance/MONITORING.md` | **Owner**: rotate Gotify admin pwd; then I scrub doc |
| F-0004 | P3 | FIXED | `SYSTEMD_SERVICES.md` claimed wait-online masked on Lady only — actually masked on BOTH. Master daemon-reload executed. | master+lady | 2026-04-23 | `09-EVIDENCE/systemd_both_*.txt` + live verify | — |
| F-0005 | P2 | OPEN | AIDE exclusions incomplete — `service-monitor.log` still hashed | master | 2026-04-23 | `09-EVIDENCE/01F_master_sweep_*.txt` | Re-verify exclusions; may need re-`aideinit` |
| F-0006 | P3 | OPEN | Lady container count drift: docs say 39, actual 38 | lady (doc) | 2026-04-23 | `inv_lady_*.txt` | Bundled with F-0007/16/17 — doc sweep |
| F-0007 | P3 | OPEN | EdgeRouter WAN IP drift: doc `178.20.30.40`, wg endpoint `62.4.55.119` | master (doc) | 2026-04-23 | `inv_master_*.txt` | Bundled doc sweep |
| F-0008 | P2 | OPEN | Master headscale listens `0.0.0.0:8085/tcp` — external exposure check pending | master | 2026-04-23 | `inv_master_*.txt` | Phase 03A external nmap |
| F-0009 | P1 | OPEN | UniFi binds `0.0.0.0:6789/tcp` + `0.0.0.0:10001/udp` (STUN 3478/udp OK) | lady | 2026-04-23 | `inv_lady_*.txt` | Compose edit — **L2** |
| F-0010 | P3 | **FIXED** | Patched `mailcow-extract-traefik-cert.py` L76/L78 container names → `mailcowdockerized-{postfix,dovecot}-mailcow-1`. Live test: `Services reloaded successfully`. Backup: `.bak.20260424T000909Z`. | lady | 2026-04-24 | `09-EVIDENCE/15_f010_f019_deploy_*.md` | — |
| F-0011 | P1 | OPEN | `admin-panel` container hot-installs pkgs on boot, runs as root, SSH key mounted, Flask code unreviewed | master | 2026-04-21 | `_archive/perfection_20260421/REPORT.md §8` | Code + secrets review before any other change |
| F-0012 | P1 | OPEN | Zero container `mem_limit`/`cpus` on both nodes (21 Master + 14+ Lady) — class level | master+lady | 2026-04-21 | `_archive/perfection_20260421/REPORT.md §9B` | Phase 06C roll-out |
| F-0013 | P1 | OPEN | No evidenced backup chain on Lady for 215 GB app data (Mailcow, Nextcloud, Odoo, UniFi, HA, Frigate) | lady | 2026-04-20 | `_archive/perfection_20260421/REPORT.md §P0-2` | Phase 05A |
| F-0014 | P1 | OPEN | No restore drill ever executed on either host | master+lady | 2026-04-20 | same | Phase 05B |
| F-0015 | P2 | OPEN | 6/13 audit requests un-started: 01 Project, 02 DNS, 06 Mail, 08 Branding, 12 FQDN(✅done), 13 Credentials(✅done) — now 4/13 left | — | 2026-04-23 | `~/personal/audits/` | **Owner**: priority call |
| F-0016 | P3 | FIXED | Stale root `TODO.md` said "maintenance mode, all done" (Feb-17) | — | 2026-04-23 | git diff | Rewritten as pointer 2026-04-23 22:53Z |
| F-0017 | P3 | FIXED | Repo memory claimed AM at `10.10.0.1:9093` — actually via Traefik `alertmanager.quietly.its.me` | master | 2026-04-23 | live verify 200 OK | Memory corrected 2026-04-23 22:54Z |
| F-0018 | P2 | OPEN | `acme.json` historically committed to git — current `.gitignore` excludes but history not rewritten | master | 2026-04-23 | `_archive/.../01A_git_secret_leak_*.md` | git history rewrite (risk assessment) |
| F-0019 | P1 | **FIXED-PARTIAL** | 5 rules deployed via hot-reload 2026-04-24 02:12 CEST: SSLCertExpiring14Days/7Days/Expired (health=ok, evaluating), SystemdUnitFailed/Flapping (loaded but `unknown` — blocked by F-0026). Rule count 47→53. Backup: `~/.copilot/backups/prometheus_rules_20260424T001104Z`. | master | 2026-04-24 | `09-EVIDENCE/15_f010_f019_deploy_*.md` | F-0026 |
| F-0020 | P3 | FIXED (false-positive) | Lady `~/.docker-compose/nextcloud/.env` reported 777 — is a **symlink** to `~/.secrets/nextcloud/.env` (600). Symlink perms are cosmetic on Linux; target perms apply. Verified `stat -L` 2026-04-23 23:25Z. | lady | 2026-04-23 | live verify | — |
| F-0021 | P2 | FIXED | `~/.secrets/backup/` dir 755 on BOTH hosts → `chmod 700` applied 2026-04-23 23:22Z | master+lady | 2026-04-23 | `09-EVIDENCE/13_credentials_sweep_*.txt` + verify | — |
| F-0022 | P2 | FIXED | Lady `~/.secrets/crowdsec/` dir 755 → `chmod 700` applied 2026-04-23 23:22Z | lady | 2026-04-23 | same | — |
| F-0023 | P3 | OPEN | Secrets hygiene: Grafana admin pwd in 4 different paths (`.secrets/grafana/admin-password`, `.secrets/grafana/admin_password`, `.secrets/monitoring/grafana_admin_password`, `.secrets/monitoring/grafana_password.txt`) — drift risk | master | 2026-04-23 | same | Consolidate to one canonical path |
| F-0024 | P3 | OPEN | Master `~/.ssh/` contains 7 private keys (`qui3tly.com`, `quietly.co.me`, `quietly-home`, `quietly.its.me`, `quietly-mac`, `quietly.online`) — overlap + purpose unclear | master | 2026-04-23 | same | Review + consolidate |
| F-0025 | P3 | OPEN | New CF token scope broader than needed (7 zones; only 3 used by infra). Consider zone-scoped token. | global | 2026-04-24 | `09-EVIDENCE/14_cf_token_rotation_*.md` | Owner: create zone-scoped token when convenient |
| F-0026 | P3 | OPEN | node-exporter missing `--collector.systemd` flag on both hosts — `node_systemd_unit_state` empty. Blocks F-0019 systemd alerts. Fix: add flag + mount `/run/systemd` to node-exporter compose; restart. | master+lady | 2026-04-24 | `09-EVIDENCE/15_f010_f019_deploy_*.md` | Owner OK to edit node-exporter compose |

## Severity definitions

- **P0** — time-bomb: outage within days without intervention, or actively being exploited
- **P1** — high: critical control does not work OR governance standard violated with real risk
- **P2** — medium: correctness issue with no immediate user impact but will compound
- **P3** — low: cosmetic / doc / convenience

## Current tally (2026-04-24 00:15 UTC)

| Severity | Open | Fixed | Total |
|---|---|---|---|
| P0 | 0 | 1 | 1 |
| P1 | 4 | 2 | 6 |
| P2 | 4 | 2 | 6 |
| P3 | 7 | 6 | 13 |
| **Total** | **15** | **11** | **26** |

**P0 ELIMINATED** — F-0001 closed by CF token rotation 2026-04-24 01:45 CEST.
**F-0002 + F-0010 + F-0019 (partial)** — closed 2026-04-24 02:09-02:12 CEST.

**Autonomous fixes executed 2026-04-23** (no owner input needed, all L1 or read-only):
- F-0004 daemon-reload master (live verify: inactive/masked both hosts)
- F-0016 stale root TODO → pointer
- F-0017 repo memory AM IP corrected
- F-0020 cleared as false-positive with proof
- F-0021 backup dir 700 (both hosts)
- F-0022 crowdsec dir 700 (Lady)

**Discovered during execution** (+6 previously invisible): F-0019, F-0020-24.
