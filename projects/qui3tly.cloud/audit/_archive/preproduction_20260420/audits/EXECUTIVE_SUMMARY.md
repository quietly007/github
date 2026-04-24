# EXECUTIVE SUMMARY — EXTERNAL PREPRODUCTION AUDIT

Date: 2026-04-21
Auditor: External / Independent (GitHub Copilot AI Audit Agent)
Scope: qui3tly.cloud — Master (213.136.68.108) + Lady (207.180.251.111)
Evidence Timestamp: 20260420T193118Z
Request File: preproduction/external/EXTERNAL_AUDIT_REQUEST_PREPRODUCTION_2026-04-20.md

---

## VERDICT: NO-GO

**Preproduction is NOT cleared for production lock.**

Three P0 blockers are open and unresolved. No production lock should be declared until these are remediated and evidenced. The underlying architecture is solid; the risks are operational gaps, not fundamental design failures. The sprint to green is achievable in 3–5 days of focused work.

---

## Overall Grade

| Dimension              | Grade | Notes                                              |
|------------------------|-------|----------------------------------------------------|
| Security               | C+    | P0 listeners + patch backlog + AIDE failure        |
| Resilience / DR        | D     | No backup/restore evidence for Lady                |
| Platform Stability     | C     | No container resource limits; high load averages   |
| Monitoring / Alerting  | B     | 20/20 targets up; pipeline not end-to-end tested   |
| Documentation          | B-    | Good structure; runtime drift not yet corrected    |
| **Overall**            | **C** | **Not production-safe yet**                        |

---

## P0 Findings (Hard Blockers)

### P0-1: Lady Security Patch Backlog + Kernel Drift
- Lady is running kernel `6.1.0-42-cloud-amd64` (built 2025-12-30), while Master runs `6.1.0-44-cloud-amd64` (2026-03-09).
- Lady uptime is **61 days** — no maintenance window applied since February 2026.
- Security-sensitive packages (openssl, gnutls, nss path) confirmed in upgradable list per audit report.
- Risk: known-vulnerability exposure on an internet-facing mail and application node.

### P0-2: Lady Backup Posture — No DR Evidence
- No backup artifacts, cron jobs, or restore drill evidence are present in any evidence file for Lady.
- Lady disk is at 23% used (215G of 985G), hosting critical data: Nextcloud, Mailcow (mail + DB), Odoo, Home Assistant, UniFi.
- Documented DR standards require tested recovery with measured RTO/RPO.
- Risk: complete data loss with no recovery path if Lady fails.

### P0-3: Unscoped External Listeners on Lady (HTCondor/Pegasus + Unknown Python Process)
- Evidence confirms the following 0.0.0.0 listeners with no UFW ALLOW rule matching:
  - `:9618` — HTCondor collector
  - `:6789` — Condor/HTCondor related
  - `:6769` — HTCondor daemon
  - `:4691` — Pegasus WMS
  - `:2529` — HTCondor
  - `:30715` — unidentified high port
  - `:5000` — python3 process (not tied to any known service in compose inventory)
- UFW does NOT explicitly permit these ports; but Docker userland-proxy can bypass UFW in some configurations.
- Risk: potential unintended external exposure of research/workflow services on a production mail/app node.

### P0-4 (NEW — External Finding): Unidentified Python3 Process on 0.0.0.0:5000
- A python3 process (pid 26417 + 26313) is listening on all interfaces port 5000.
- Not associated with any known compose service in the Lady inventory.
- Must be identified and removed or explicitly documented before production lock.

---

## P1 Findings (High Priority)

### P1-1: Master AIDE Integrity Monitoring Failure
- `aide.service` confirmed failed on Master per audit report.
- Risk: undetected file system changes on the VPN/auth/monitoring control plane.

### P1-2: Container Resource Governance (Both Nodes)
- Zero containers have memory, CPU, or PID limits across 25 (Master) and 38 (Lady) running services.
- Master load: 4.36 (1m). Lady load: 4.68 (1m) — elevated on both nodes.
- Risk: one runaway container can destabilize the entire host.

### P1-3: Traefik Hardening — Not Verified
- No Traefik config captured in evidence. Cannot confirm dashboard security, middleware chain coverage, or TLS posture.

### P1-4 (NEW — External Finding): Lady UFW Broad Internal Allow Rules
- `ALLOW IN 172.16.0.0/12` and `ALLOW IN 10.0.0.0/8` are present in Lady UFW rules.
- Entire Docker RFC 1918 address space is allowed inbound — undermines default-deny posture.
- If any container is compromised, lateral movement is trivially possible.

---

## P2 Findings (Medium)

- Sysctl hardening consistency drift between nodes (needs validation — not in evidence).
- Container root/privilege minimization not evidenced.
- Image lifecycle: cloudflared, homeassistant, prometheus, grafana are 4+ months old.
- Master load average elevated — root cause not isolated (likely VS Code server or monitoring stack).
- Nextcloud 5-hour uptime on Lady unexplained — possible crash/restart cycle.

---

## Gate Status

| Gate | Requirement                             | Status       |
|------|-----------------------------------------|--------------|
| A    | Security — patches, listeners, AIDE     | FAIL (P0/P1) |
| B    | Resilience — backups + restore drill    | FAIL (P0)    |
| C    | Stability — container limits, load      | FAIL (P1)    |
| D    | Documentation — runtime drift corrected | PARTIAL      |

---

## Minimum Viable Sprint to Production Lock

1. **Day 1**: Snapshot both VPS. Patch Lady + reboot. Identify and remove all non-core listeners. Fix AIDE on Master.
2. **Day 2**: Fix Lady UFW broad rules. Implement Lady backup jobs (Mailcow, Nextcloud, Odoo, UniFi). Run Master backup verification.
3. **Day 3**: Execute restore drills on both nodes with timing evidence. Review Traefik config in detail.
4. **Day 4**: Apply container resource limits by class. Monitor for regressions. Test alert pipeline end-to-end.
5. **Day 5**: Reconcile docs. Capture full evidence set. Run gate checklist. Issue signed Go/No-Go.

---

## Evidence References

- `evidence/10_master_snapshot_20260420T193118Z.txt` — Master runtime state
- `evidence/11_lady_snapshot_20260420T193118Z.txt` — Lady runtime state, listeners, uptime
- `reports/PREPRODUCTION_AUDIT_MERGED.md` — Original internal findings
- `plans/PREPRODUCTION_EXECUTION_PLAN.md` — Remediation plan reviewed
- `todo/PREPRODUCTION_TODO.md` — Task tracker: all gates open
- `reports/DOCUMENTATION_COVERAGE_MATRIX.md` — Coverage gaps identified
- `reports/ACCURACY_VALIDATION_REPORT.md` — Validation confidence levels
