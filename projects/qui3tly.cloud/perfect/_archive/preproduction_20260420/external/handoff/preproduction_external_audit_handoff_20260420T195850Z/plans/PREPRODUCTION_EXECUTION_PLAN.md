# PREPRODUCTION_EXECUTION_PLAN

Date: 2026-04-20
Objective: reach production-ready state with measurable gates and evidence.

## Phase 0 - Freeze + Baseline Snapshot (Day 0)

Goals:
- Freeze non-essential changes.
- Capture full pre-change evidence.

Actions:
1. Snapshot both VPS (Contabo snapshot + local metadata).
2. Export current configs:
   - Docker compose trees
   - Traefik static/dynamic config
   - Firewall rules
   - Monitoring rules and dashboards
3. Record health baseline:
   - Prometheus targets
   - Alertmanager active alerts
   - container states
   - critical endpoint probes

Exit criteria:
- Snapshots complete for Master and Lady.
- Baseline evidence committed under `preproduction/evidence/`.

## Phase 1 - Security Remediation (Day 1-2)

Goals:
- Remove immediate risk and close exposure gaps.

Actions:
1. Lady patching + reboot maintenance:
   - Apply pending security updates.
   - Reboot and verify services/metrics/alerts.
2. Restrict or remove non-core listeners (HTCondor/Pegasus).
3. Fix Master AIDE failure and validate healthy timer execution.
4. Harmonize high-value sysctl hardening across both nodes.
5. Validate Traefik hardening runtime (no insecure/debug in active path).

Exit criteria:
- No critical security findings open.
- Both nodes pass post-reboot health checklist.

## Phase 2 - Resilience and Recovery (Day 2-3)

Goals:
- Align live backup/restore behavior with documented RTO/RPO standards.

Actions:
1. Implement and validate Lady backup jobs (data + config + DB as applicable).
2. Verify Master backup chain integrity.
3. Execute one restore drill per node (controlled scope):
   - service-level restore
   - data restore validation
4. Record measured RTO/RPO and compare with targets.

Exit criteria:
- Backup jobs verified and recent artifacts present on both nodes.
- Restore drill evidence available with timings.

## Phase 3 - Platform Stability and Resource Governance (Day 3-4)

Goals:
- Prevent host instability from container overconsumption.

Actions:
1. Apply resource classes:
   - Class A (critical infra): explicit memory + CPU + pids caps.
   - Class B (stateful apps/db): stronger memory and I/O protections.
   - Class C (utility): conservative caps.
2. Recheck noisy/large logs and retention.
3. Keep justified privileged/root exceptions documented.

Exit criteria:
- 100% containers classified; limits applied where safe.
- No service regressions under monitored load.

## Phase 4 - Monitoring and Alert Quality (Day 4-5)

Goals:
- Ensure alerting is actionable and complete.

Actions:
1. Validate all Prometheus targets and recording/alert rules.
2. Test Alertmanager routing to actual channels.
3. Review false positive rates and tune only with evidence.
4. Add preproduction dashboard with gate KPIs.

Exit criteria:
- Alert pipeline tested end-to-end.
- No blind spots for critical services.

## Phase 5 - Documentation Reconciliation and Sign-Off (Day 5)

Goals:
- Make docs match reality and produce release decision package.

Actions:
1. Update drifted docs (counts, versions, topology specifics).
2. Produce final sign-off report:
   - open risks
   - accepted risks
   - rollback plan
3. Final go/no-go meeting checklist.

Exit criteria:
- Docs and runtime state aligned.
- Preproduction checklist fully green or explicitly risk-accepted.

## Rollback Strategy

For each phase:
- Use snapshot rollback if phase fails hard.
- Use compose-level rollback for service-level regressions.
- Keep change log with timestamp and operator.

## Governance Rules for Execution

- No undocumented emergency changes.
- Every mutation must have:
  - before evidence
  - command log
  - after verification
- No "done" without measurable acceptance criteria.

