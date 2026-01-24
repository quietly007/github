# Final Audit Preparation Brief (Operational)

> **Date**: 2026-01-24
> **Purpose**: Prepare the external agent for the final audit (read-only).
> **Scope**: Read-only verification and reporting. No fixes or changes by the auditor.

---

## Canonical Repos (Policy of Record)

See governance:
- `/home/qui3tly/.governance/REPOS.md`
- `/home/qui3tly/.governance/GITHUB_LAYOUT.md`

Key points:
- Shared repos: ansible, governance, github-config, projects, copilot
- Shared memories location: `/home/qui3tly/.copilot-shared/memories/`
  - `master.jsonl` (Master writes)
  - `lady.jsonl` (Lady writes)
- Copilot instructions are in `~/.github/` (github-config repo)

---

## Project Path (Updated)

The project has been renamed and consolidated:
- Current project root: `/home/qui3tly/projects/qui3tly.cloud/`
- Legacy `quietly.cloud` project folder was removed.

---

## Audit Rules (Read-Only)

The external audit is **read-only**:
- **No changes** to configs, services, repos, or docs.
- **No restarts** or destructive actions.
- **Reports only** in `/home/qui3tly/.reports/final-audit/`.

---

## Required Report Outputs (Single Bundle)

Output the following files under `/home/qui3tly/.reports/final-audit/`:
- `AUDIT_REPORT.md`
- `SECURITY_FINDINGS.md`
- `DOCUMENTATION_GAPS.md`
- `QUICK_WINS.md`
- `PRIORITY_MATRIX.md`
- `COMPARISON_MATRIX.md` (full comparison matrix)

---

## Mandatory Full Comparison Areas

The auditor must compare documentation vs reality across:
- **Playbooks** (`~/.ansible/playbooks/`)
- **Scripts** (`~/.copilot/scripts/`)
- **Service configs** (`~/.docker-compose/` and `~/.docker/`)
- **Docs** (`~/.docs/` and `~/.governance/`)

Provide a matrix like:

```
| Item | Documentation Says | Reality | Status |
|------|--------------------|---------|--------|
| playbook.yml | "Does X" | Does X+Y | ⚠️ MISMATCH |
```

---

## Read-Only Verification Commands

**Master**
```bash
systemctl status headscale tailscaled
wg show wg0
docker ps --format "table {{.Names}}\t{{.Status}}"
```

**Lady**
```bash
ssh lady "systemctl status tailscaled"
ssh lady "docker ps --format 'table {{.Names}}\t{{.Status}}'"
```

---

## Known Recent Changes (Operational)

- Governance now includes policy-of-record for:
  - `REPOS.md`
  - `ANSIBLE.md`
  - `GITHUB_LAYOUT.md`
  - `DOCKER_LAYOUT.md`
- Projects consolidated under `~/projects/qui3tly.cloud/`.
- Shared repos (`.github`, `.copilot-shared`) are separate from home repos.

---

## Audit Entry Points

- Governance: `/home/qui3tly/.governance/`
- Docs: `/home/qui3tly/.docs/`
- Reports (prior audits):
  - `/home/qui3tly/.reports/external-audit-20260122/`
  - `/home/qui3tly/.reports/external-audit-20260122-external/`

---

## Final Reminder

The external agent must **only** read, verify, and report.
No fixes or modifications.
