# MASTER_TODO — all actions derived from audit

> **Rule**: every row must cite a finding or a phase. Rows without provenance are not allowed.  
> **Updated**: 2026-04-23

| ID | Priority | Finding | Phase | Title | Owner | Status |
|---|---|---|---|---|---|---|
| T-001 | P0 | F-0001 | 1F | Obtain new CF API token with correct zone scopes | qui3tly | BLOCKED |
| T-002 | P0 | F-0001 | 1F | Atomic token swap on both hosts + backup old | agent | WAITING on T-001 |
| T-003 | P0 | F-0001 | 1F | Force-renew `mail.quietly.online` (smoke test) | agent | WAITING on T-002 |
| T-004 | P0 | F-0010 | 1F | Fix `docker exec postfix-mailcow postfix reload` failure inside Mailcow | agent | WAITING on T-002 |
| T-005 | P0 | F-0001 | 1F | Rerun `mailcow-tlsa.service`, verify green | agent | WAITING on T-003 T-004 |
| T-006 | P0 | F-0001 | 1F | Verify all 16 certs refreshed (live + acme.json) | agent | WAITING on T-005 |
| T-007 | P1 | F-0002 | 04C | Prometheus `/api/v1/rules` — confirm `SSLCertExpiring14Days` loaded | agent | READY (L0) |
| T-008 | P1 | F-0002 | 04C | Prometheus `/api/v1/alerts` — is it currently firing? | agent | READY |
| T-009 | P1 | F-0002 | 04C | Alertmanager `/api/v2/alerts` — did it ingest? | agent | READY |
| T-010 | P1 | F-0002 | 04C | Alertmanager routing config → Gotify: inject synthetic alert | agent+owner | WAITING on Q-001 |
| T-011 | P1 | F-0002 | 04D | Gotify → mobile: confirm priority 5 push reaches phone | owner | BLOCKED on owner device |
| T-012 | P1 | F-0003 | 02D | Rotate Gotify admin credential; scrub `~/.governance/MONITORING.md` | agent+owner | WAITING on Q-003 |
| T-013 | P1 | F-0009 | 01D/L2 | UniFi compose: rebind 6789/tcp + 10001/udp to `100.64.0.2:` or remove | agent | WAITING L2 |
| T-014 | P2 | F-0008 | 03A | External nmap probe against Master port 8085 | agent+owner | WAITING on Q-001 |
| T-015 | P2 | F-0005 | 02 | Re-verify AIDE exclusions cover `service-monitor.log` | agent | READY |
| T-016 | P3 | F-0004 | 02B | `daemon-reload` on Master + update `SYSTEMD_SERVICES.md` to "both hosts" | agent | READY |
| T-017 | P3 | F-0006 | 06A | Update container count in `INFRASTRUCTURE_OVERVIEW.md` (39 → 38) | agent | READY |
| T-018 | P3 | F-0007 | 06A | Mark EdgeRouter WAN IP as dynamic in network doc | agent | READY |
| T-019 | — | — | 02 | Run security analysis (UFW Master, port exposure, SSH, secrets, CrowdSec) | agent | READY |
| T-020 | — | — | 03 | Pentest phase pending Q-001 answer | agent | BLOCKED on Q-001 |
| T-021 | — | — | 04A | Re-probe Lady load once post-reboot warm-up passes | agent | READY (wait 15 min) |
| T-022 | — | — | 05 | Backup + one restore test | agent+owner | BLOCKED on Q-004 |
| T-023 | — | — | 06B | Ansible reproducibility audit | agent | READY |
| T-024 | — | — | 10 | Produce final `GO_NO_GO.md` verdict | agent→owner | LAST |

## Next-up (by priority, not blocked)

1. **T-007/T-008/T-009** — alert pipeline interrogation (read-only, L0)
2. **T-015** — AIDE re-verification (read-only, L0)
3. **T-016** — Master systemd daemon-reload + doc update (L1 trivial)
4. **T-019** — security analysis sweep (read-only, L0)
5. **T-023** — Ansible reproducibility (read-only, L0)

Update rule: when a task completes, flip Status to `DONE (YYYY-MM-DD)` and link evidence path.
