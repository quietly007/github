# Findings Tracker

> **Format**: CSV-in-markdown for greppability  
> **Severity**: P0 (time-bomb) > P1 (high) > P2 (medium) > P3 (low)  
> **Status**: OPEN | IN-PROGRESS | FIXED | WAIVED

| ID | Severity | Status | Title | Host | Discovered | Evidence | Owner Action |
|---|---|---|---|---|---|---|---|
| F-0001 | P0 | OPEN | Cloudflare DNS-01 token invalid — CF error **code 9109 "Invalid access token"** — 16 certs blocked from renewal (earliest expiry Apr 28) | master+lady | 2026-04-23 | `09-EVIDENCE/systemd_both_20260423T202005Z.txt` | Provide new CF API token |
| F-0002 | P1 | OPEN | Alerting pipeline silent failure — `mailcow-tlsa.service` failed nightly 5+ days, no notification received; `SSLCertExpiring14Days` rule exists but did not fire to Gotify | master | 2026-04-23 | same evidence | Approve Phase 04C pipeline test |
| F-0003 | P1 | OPEN | `~/.governance/MONITORING.md` contains plaintext Gotify credential — violates `.governance/SECRETS.md` | master (doc) | 2026-04-23 | `~/.governance/MONITORING.md` (paths only) | Rotate Gotify admin pwd + scrub doc |
| F-0004 | P3 | IN-PROGRESS | `SYSTEMD_SERVICES.md` claims wait-online masked on Lady only — actually masked on BOTH. Master has "unit file changed on disk" warning (needs `daemon-reload`). Doc needs update. | master+lady | 2026-04-23 | `09-EVIDENCE/systemd_both_20260423T202005Z.txt` | `daemon-reload` on Master + doc update |
| F-0005 | P2 | OPEN | AIDE exclusions incomplete — `service-monitor.log` still hashed (Phase 01E context) | master | 2026-04-23 | `09-EVIDENCE/01F_master_sweep_20260423T192943Z.txt` | Re-verify exclusions or re-run `aideinit` |
| F-0006 | P3 | OPEN | Lady container count drift: docs say 39, actual 38 | lady (doc) | 2026-04-23 | `inv_lady_*.txt` | Update `INFRASTRUCTURE_OVERVIEW.md` |
| F-0007 | P3 | OPEN | EdgeRouter WAN IP drift: doc says `178.20.30.40`, observed wg peer endpoint `62.4.55.119` | master (doc) | 2026-04-23 | `inv_master_*.txt` (wg show) | Mark WAN IP as dynamic in network doc |
| F-0008 | P2 | OPEN | Master headscale binary listens on `0.0.0.0:8085/tcp` — needs external probe to confirm exposure | master | 2026-04-23 | `inv_master_*.txt` (ss -tulnp) | Phase 03A external nmap |
| F-0009 | P1 | OPEN | UniFi container binds `0.0.0.0:6789/tcp` + `0.0.0.0:10001/udp` — violates `SECURITY_STANDARDS.md` port-binding rules (3478/udp OK for STUN) | lady | 2026-04-23 | `inv_lady_*.txt` | Compose edit: rebind/remove 6789 + 10001; L2 approval |
| F-0010 | P1 | OPEN | `mailcow-tlsa` script's `docker exec postfix-mailcow postfix reload` fails (exit 1) every run — second bug; pipeline won't complete even after F-0001 fix | lady | 2026-04-23 | `09-EVIDENCE/systemd_both_*.txt` | Investigate inside Mailcow postfix container |

New findings append here. When a finding is closed, change Status in-place; keep row.

## Severity definitions

- **P0** — time-bomb: will cause an outage within days without intervention, or is actively being exploited.
- **P1** — high: either (a) a critical control does not work (monitoring, backup, security), or (b) a governance standard is violated with real risk.
- **P2** — medium: correctness issue with no immediate user impact but will compound.
- **P3** — low: cosmetic / doc / convenience items.
