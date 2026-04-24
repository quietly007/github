# PREPRODUCTION_AUDIT_MERGED

Date: 2026-04-20
Scope: Master + Lady, all production-critical infrastructure paths
Status: Preproduction readiness audit (docs + live reality merged)

## 1. What Was Merged (Documentation-First)

This report merges:
- Project baseline and plan:
  - `~/projects/qui3tly.cloud/README.md`
  - `~/projects/qui3tly.cloud/PLAN.md`
  - `~/projects/qui3tly.cloud/TODO.md`
  - `~/projects/qui3tly.cloud/BASELINE/*`
- Core standards and architecture:
  - `~/.docs/00-standards/*`
  - `~/.docs/01-architecture/NETWORK_ARCHITECTURE.md`
  - `~/.docs/02-operations/{BACKUP_STRATEGY.md,DISASTER_RECOVERY.md}`
  - `~/.docs/06-security/SECURITY_STANDARDS.md`
- Audit programs and expected deliverables:
  - `~/personal/audits/01..13_AUDIT_REQUEST_*.md`
  - `~/personal/audits/AUDIT_REQUESTS_SUMMARY.md`
  - `~/personal/audits/TAILSCALE_OUTAGE_INVESTIGATION_2026-02-18.md`
  - `~/personal/audits/DNS_PIHOLE_CHANGE_REPORT.md`
- Live system evidence from both servers (system, docker, security, monitoring)

## 2. Method Used

1. Read standards and architecture first (no assumptions).
2. Read audit requests to extract mandatory outcomes/checklists.
3. Validate current live state against documented intent.
4. Build remediation by priority (P0/P1/P2/P3), mapped to existing docs.

## 3. Executive Summary

Overall state: Good foundation, not yet "production-perfect".

Strengths:
- Monitoring recovered: Prometheus targets healthy.
- Core stack up on both servers.
- Secrets permissions mostly strong (600).
- Fail2ban + UFW present and active.
- Security layers present (Traefik, CrowdSec, Authelia, VPN segmentation).

Gaps blocking "perfect" preproduction sign-off:
- Lady package/security patch debt and older kernel.
- Lady backup posture not aligned with documented DR targets.
- Exposure/control issues around extra non-core services (HTCondor/Pegasus listeners).
- Docker resource governance weak (almost all containers without limits).
- AIDE integrity monitor failing on Master.
- Some hardened defaults inconsistent between Master and Lady.

## 4. Findings (Prioritized)

## P0 - Must Fix Before Production Lock

1) Lady backup gap vs DR policy
- Live: Lady backup location effectively empty/unreliable for critical restore posture.
- Docs require tested recovery and explicit RTO/RPO discipline.
- Risk: data loss and failed restore for mail/nextcloud/apps.
- Required: implement and test Lady backups + restore drill evidence.

2) Lady security patch backlog
- Live: multiple upgradable security-sensitive packages (openssl/gnutls/nss path included in pending list).
- Risk: known-vuln exposure in internet-facing mail/app node.
- Required: patch window + reboot + post-patch validation checklist.

3) Unscoped listeners for non-core workloads on Lady (HTCondor/Pegasus)
- Live: listeners on 0.0.0.0 for condor/pegasus-related ports.
- Risk: unnecessary attack surface on production node.
- Required: remove or bind strictly to internal interface; enforce firewall explicit deny.

## P1 - High Priority

4) Master integrity monitoring failure (AIDE)
- Live: `aide.service` failed.
- Risk: file integrity controls not trusted.
- Required: reinitialize/fix AIDE workflow and verify clean runs.

5) Docker hardening/resource governance weak on both nodes
- Live: majority of containers have no mem/cpu/pid constraints.
- Risk: noisy-neighbor or runaway process can destabilize host.
- Required: enforce per-service limits by class (critical/data/edge/utility).

6) Traefik hardening consistency
- Need to ensure no insecure/debug posture in active runtime and global security middleware coverage on all public routes.
- Required: explicit config verification and lock.

## P2 - Medium Priority

7) Sysctl/security consistency drift between nodes
- Not all hardening knobs aligned (e.g., redirect and kernel pointer restrictions).
- Required: unified hardened sysctl baseline.

8) Container identity minimization
- Many services run as root by default.
- Required: non-root where compatible; document justified exceptions.

9) Image lifecycle hygiene
- Several old image lines and large reclaimable image footprint.
- Required: controlled update cadence and deprecation policy.

## P3 - Optimization / Polish

10) Monitoring quality uplift
- Add stronger preproduction SLO/SLA dashboards, synthetic probes, and alert hygiene checks from audit templates.

11) Branding and service UX consistency
- Covered in audit request #08; not a blocker for infra security but required for business-ready polish.

## 5. Cross-Reference: Documentation vs Live Reality

Aligned:
- Twin-server architecture and service split are real.
- VPN-centric access model is real.
- Monitoring stack present and integrated.

Drift requiring correction:
- Some memory documents still mention old container counts and prior grades; live counts differ.
- Plan/TODO marked "complete" in Feb baseline context, but Apr live audit shows new drift (patches, backups, AIDE, extra listeners).

Conclusion: baseline was true for that point in time; this preproduction package supersedes it for current go-live readiness.

## 6. Preproduction Acceptance Gates

Gate A - Security
- All critical CVE patching applied on both nodes.
- No unnecessary 0.0.0.0 listeners for non-core services.
- AIDE healthy and passing.
- CrowdSec/Fail2ban/Firewall checks green.

Gate B - Resilience
- Backup + restore tested for Master and Lady (documented evidence).
- DR drill with measured RTO/RPO recorded.

Gate C - Platform Stability
- Container resource limits applied by class.
- Monitoring/alerting validated end-to-end after changes.

Gate D - Documentation Integrity
- Docs updated to current reality and linked to evidence.
- Preproduction TODO fully checked with timestamps.

## 7. Immediate Recommendation

Do not declare production-perfect yet.
Move to a controlled preproduction hardening sprint using:
- `plans/PREPRODUCTION_EXECUTION_PLAN.md`
- `todo/PREPRODUCTION_TODO.md`

