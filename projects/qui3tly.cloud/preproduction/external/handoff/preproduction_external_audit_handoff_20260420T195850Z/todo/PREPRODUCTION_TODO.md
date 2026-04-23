# PREPRODUCTION_TODO

Date: 2026-04-20
Owner: qui3tly
Status: ACTIVE

Legend:
- [ ] not started
- [-] in progress
- [x] complete

## A. Documentation and Baseline Reconciliation

- [x] Merge core standards/docs/audit requests into a unified preproduction package
- [ ] Reconcile runtime container counts/versions with baseline docs
- [ ] Update drifted docs (architecture/security/operations) to current state
- [ ] Add evidence index linking every claim to command output

Acceptance:
- No known contradictions between docs and live state.

## B. Security Hardening (P0/P1)

- [ ] Patch Lady security updates and reboot in maintenance window
- [ ] Verify post-reboot service health (containers, targets, alerts)
- [ ] Restrict/remove HTCondor/Pegasus external listeners on Lady
- [ ] Fix Master AIDE failure and verify timer success
- [ ] Align critical sysctl hardening across Master/Lady
- [ ] Validate Traefik active runtime hardening (no insecure/debug leakage)

Acceptance:
- Zero open P0 security items.
- Documented before/after evidence.

## C. Backup & DR (P0)

- [ ] Implement/verify Lady backup jobs for app + data + DB scope
- [ ] Verify Master backup integrity and retention compliance
- [ ] Run restore drill on Master (service/data scope)
- [ ] Run restore drill on Lady (service/data scope)
- [ ] Record measured RTO/RPO vs target

Acceptance:
- Backups present and fresh on both nodes.
- Restore proof with timing evidence.

## D. Container Resource Governance (P1/P2)

- [ ] Classify all containers (critical/stateful/utility)
- [ ] Apply mem/cpu/pids limits for critical/stateful services first
- [ ] Validate no regressions after limit rollout
- [ ] Document justified root/privileged exceptions

Acceptance:
- All production-critical services have explicit limits.

## E. Monitoring and Alert Quality

- [ ] Validate Prometheus target completeness
- [ ] Validate alert rule quality (noise vs signal)
- [ ] Test Alertmanager routing channels end-to-end
- [ ] Add preproduction KPI dashboard and checklist panel

Acceptance:
- Alert pipeline tested and documented.
- No blind spots for critical services.

## F. Production Readiness Gate

- [ ] Security gate: PASS
- [ ] Resilience gate: PASS
- [ ] Stability gate: PASS
- [ ] Monitoring gate: PASS
- [ ] Documentation gate: PASS
- [ ] Final go/no-go decision report signed

Acceptance:
- All five gates PASS or explicit risk acceptance signed.

## Immediate Next 10 Commands (Operator Runbook)

1. `apt list --upgradable` (Lady)
2. `apt upgrade -y` (Lady)
3. `reboot` (Lady)
4. Health verify after reboot (targets/alerts)
5. Check and lock down condor/pegasus listeners
6. Fix AIDE on Master and verify `aide.timer`
7. Verify Lady backup artifacts + cron
8. Run controlled restore test on Lady
9. Apply container limits incrementally
10. Run full gate checklist and issue go/no-go

