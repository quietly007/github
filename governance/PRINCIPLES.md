# Principles

Binding principles for all agent and human activity in this workspace.

## 1. Protect SSH Access (Absolute)

- SSH listens on **port 1006**. Never change, block, or risk SSH on port 1006.
- Any action that may affect SSH reachability is **owner-only execution**; the agent prepares but does not execute.

## 2. Secrets Safety

- Secrets **never** enter repo, docs, or logs.
- All secrets live under `.secrets/` with directory perms `700` and file perms `600`.
- **Owner credentials are off-limits to automation:** owner password, SSH keys, VPN material, and personal authentication tokens must **never** be requested, handled, stored, or transmitted by any agent.

## 3. Approval Before Mutation

- No destructive or state-mutating action without explicit user approval (`ask_user` or equivalent).

## 4. Backup First

- Before any in-place edit, move, or restart, create a timestamped backup in `.copilot/backups/`.

## 5. Audit Everything

- Append a single-line JSON entry to `.copilot/memories.jsonl` for every mutating action (no secrets in payload).
- Create a dated report under `/home/qui3tly/.reports/audits` for large or sensitive operations.

## 6. Simplicity

- Prefer the smallest change that solves the problem.
- Default to read-only and dry-run; mutate only after approval.

## 7. 2FA Policy

- All externally reachable services require 2FA (traefik-forward-auth or equivalent).
- **Exception:** Owner SSH on port 1006 (key-based only, no 2FA wrapper).

## 8. Trust Principle

- **Never overcomplicate simple tasks.** User trust depends on efficiency and clarity.
- Lesson learned: 2+ hours wasted on a desktop shortcut is unacceptable.

## 9. Architecture Clarity

- **Always verify client vs server** before taking any action.
- Understand where code runs: local machine, remote server, container, or service.

## 10. Principle Priority

- If a proposed action conflicts with these principles, **stop and consult the user**.
- Principles are **absolute** — no override for any reason.

## 11. Governance Lockdown (Policy-of-Record)

- The governance set under `/home/qui3tly/.governance/` is the policy-of-record for this workspace.
- Any governance change requires explicit user approval and must follow `.governance/WORKFLOWS.md`.
- Every governance change must be logged to `.copilot/memories.jsonl` and recorded in `.governance/CHANGELOG.md`.
- See `.governance/LOCKDOWN_POLICY.md`.
