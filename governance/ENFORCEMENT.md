# Enforcement

Hooks, CI awareness, and escalation.

## User Control Commands

Owner can issue these commands at any time:

| Command | Action |
|---------|--------|
| **STOP IMMEDIATELY** | Halt all actions instantly |
| **VERIFY** | Trigger 9-step verification process |
| **SHOW COMPLIANCE** | Display current compliance status |
| **SHOW WORKFLOW STATUS** | Display current workflow step |
| **STEP STATUS** | Show current step and history |
| **VIOLATION LOG** | Report any rule violations |
| **RESET COMMITMENTS** | Force re-reading all rules |

## Violation Consequences

When a violation occurs:

1. **Immediate acknowledgment** — admit the violation clearly
2. **Stop current action** — do not continue
3. **Restart verification** — complete VERIFY 100% workflow
4. **Document failure** — record in `.copilot/memories.jsonl`
5. **Present correction plan** — explain how to prevent recurrence
6. **Get approval** — user must approve before resuming

## Local Hooks

| Hook | Location | Purpose |
|------|----------|---------|
| pre-commit | `.githooks/pre-commit` | shellcheck on staged `.sh`; require non-empty `.copilot/memories.jsonl` |
| pre-push | `.copilot/hooks/pre-push` | shellcheck on staged `.sh`; secrets-scan on sensitive paths; require `.copilot/memories.jsonl` for sensitive changes |

### Secrets Scan Behavior

- Triggered on staged changes touching `.docker-compose/`, `.docker/`, `.copilot/`, or `.governance/`.
- Reports `path + line + pattern` only (no values).
- Writes report under `/home/qui3tly/.reports/secrets/` named `pre_push_secrets_scan_<ts>.txt`.
- **Non-zero hits block push.**

## Pre-Change Checks

- `shellcheck` on shell scripts.
- YAML validation.
- `docker compose config` for compose files.

## Documentation Integrity (connected documents)

- Docs must not drift: any absolute `/home/qui3tly/...` references in `.docs/` and `.governance/` must point to real paths.
- Checker: `/home/qui3tly/.copilot/scripts/docs_link_check.sh` (writes to `/home/qui3tly/.reports/audits/`).

## Post-Change Validation

- Verify expected containers running.
- Tail logs for errors.
- Test health endpoints.

## Escalation

- If blocked by hook or policy conflict:
  1. Collect reason.
  2. Produce short remediation plan.
  3. Present to user for decision.

## Hook Installation

- Installer: `.copilot/hooks/install_hooks.sh`
- Requires explicit user approval before running.

## Temporary audit bypass (owner-only)

Sometimes audits require repeating operations without local hook blocks. This is allowed only with **owner authorization**:

- Toggle script: `/home/qui3tly/.copilot/scripts/audit_restrictions.sh`
- How-to: `/home/qui3tly/.docs/howto/remove-audit-restrictions.md`

Rules:
- Only the owner may disable/enable local hooks.
- Must be restored immediately after the audit step.
- Does not bypass CI.

## GitHub Governance

See `GITHUB_LAYOUT.md` for the canonical org structure (quietly007) and placement of `.github`, governance repo, shared projects repo, and per-project assets. Key enforcement points:

## Copilot Instruction Entry Point

- Agent entrypoint instructions live under `quietly007/.github` and are mirrored into repo-local `.github/` until all repos consume the org-level copy. Server working copies remain at `/home/qui3tly/.github/`.
- These files must remain consistent with canonical dot-roots (`/home/qui3tly/.governance/`, `/home/qui3tly/.copilot/`, `/home/qui3tly/.secrets/`).
- **Authority remains `/home/qui3tly/.governance/`**; `.github/` documents the entrypoint and pointers.

- **Branch protection:** Main branch requires PRs, status checks pass.
- **CODEOWNERS:** Sensitive paths require owner review.
- **Commit signing:** Recommended for all commits.
- **No force push** to protected branches.

## CI Artifacts

- CI reports saved to: `/home/qui3tly/.copilot/reports/ci/`
- Naming: `<workflow>_<run_id>_<ts>.log`

## Memory Tracking

- Every action step written to `.copilot/memories.jsonl`
- Exact position tracking
- Complete history of all actions
- Success/failure documentation
- 2-year rolling retention for audit log

## Pruning Automation

- **Default mode: dry-run** — show what would be deleted without deleting.
- **User approval required** — never auto-prune without explicit consent.
- **Destructive prune = Level 2** — requires user-only approval.
- Log pruning actions in `.copilot/memories.jsonl`.
