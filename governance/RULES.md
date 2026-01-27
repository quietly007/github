# Rules

Operational rules the agent must follow.

## CRITICAL: NO NORMAL ERRORS

**ABSOLUTE RULE**: There are NO "normal", "expected", "non-critical", or "cosmetic" errors.

**FORBIDDEN PHRASES**:
- ❌ "This error is normal"
- ❌ "This is expected behavior"  
- ❌ "Non-critical error"
- ❌ "Cosmetic issue"
- ❌ "Known issue"
- ❌ "Can be ignored"

**MANDATORY RESPONSE**: Every error MUST be:
- Fixed immediately, OR
- Functionality disabled if cannot be fixed
- Documented in memories.jsonl with fix plan
- Never dismissed or explained away

## Command Safety

- Default mode: **read-only**. Use `--dry-run` flags where available.
- Shell scripts must begin with:
  ```bash
  #!/usr/bin/env bash
  set -euo pipefail
  ```

## Rsync Safety (CRITICAL)

**See**: `.governance/RSYNC_RULES.md` for full details.

**CRITICAL RULES**:
- ❌ NEVER use `rsync --delete` between servers with different service configurations
- ✅ ALWAYS check source and destination differences before sync
- ✅ USE Git pull on destination for tracked configs (safer)
- ✅ USE selective directory sync for specific services only
- ❌ NEVER assume Master and Lady have identical services

**Master ≠ Lady**: Master has monitoring/VPN/DNS. Lady has email/nextcloud/unifi.

## Maximum Simplification

- **One tool call per request** — avoid chaining unnecessary operations.
- **No complex bash scripts** — keep commands direct and simple.
- **Break complex tasks into simple steps** — execute separately with clear output.
- **Short, clear output** — user controls verbosity, not agent.
- **No unnecessary steps** — efficient execution only.
- **Complete the job as user requested** — simplify execution but deliver what user asked for.
- **No auto-analysis unless requested** — user controls when to analyze.
- **No mega-commands** — avoid long chained commands or multi-line one-shots that risk truncation or partial execution; prefer small, sequential commands with clear output.

## Firewall Checks (Mandatory)

Before any network-related work:

1. Check firewall status (`ufw status`, `iptables -L`)
2. Test external port accessibility
3. Verify local AND external connectivity
4. Check UFW and iptables rules
5. Test HTTPS functionality
6. Verify DNS resolution
7. Test ALL ports (80, 443, 8080, 1006)

**Never assume network is working without testing.**

## Approval Model

| Level | Scope | Approver |
|-------|-------|----------|
| 0 | Read-only (scans, reports) | Auto |
| 1 | Routine edits (docs, version pins) | User or delegated maintainer |
| 2 | Destructive (delete, prune, restart) | User only |
| 3 | Emergency restore | User with rollback plan |

## Backup Format

```
.copilot/backups/<descriptive_name>_<YYYYMMDDTHHMMSSZ>/
```

## Docker Layout

| Path | Purpose |
|------|---------|
| `.docker-compose/{service}/` | Compose files |
| `.docker/{service}/config/` | Service config |
| `.docker/{service}/data/` | Persistent data |

- **Never use `:latest` tag** — always pin images to specific versions or digests.
- **Define healthchecks** for all services.
- **Set resource limits** (memory, CPU) where appropriate.
- **Keep images updated** — regularly check for security updates.
- Reference: `.governance/DOCKER_LAYOUT.md`

## Logging

| Sink | Path | Purpose |
|------|------|---------|
| Audit log | `.copilot/memories.jsonl` | JSON Lines, no secrets, append-only |
| Human log | `.copilot/logging/security_fixer_<ts>.log` | Human-readable mutating-action logs |
| User-facing reports | `/home/qui3tly/.reports/<category>/` | Audits, secrets scans, official reports |
| Internal reports | `/home/qui3tly/.copilot/reports/` | CI, agent-internal reports |

- Schema reference: `.governance/MEMORY_SCHEMA.md`
- Never capture or store command output containing secret values.

## File Permissions

| Type | Mode |
|------|------|
| Executable script | 755 |
| Documentation | 644 |
| Secret file | 600 |
| Secret directory | 700 |

## Symlinks Policy (Avoid)

- Avoid symlinks in this workspace.
- Only consider symlinks if **nothing else works** and only with explicit user approval.
- Default approach for structure changes is: **backup → rename/move → update references → verify**.

## Users and Privileges

- **Only owner (`qui3tly`) has sudo** — no shared admin accounts.
- **No shared credentials** — each user has unique authentication.
- **Service accounts are non-interactive** — no login shell.
- **Root login disabled** — use sudo from owner account only.

## Shell Standards

- Use `IFS= read -r` for reading lines.
- Always quote variable expansions: `"$var"`.
- Avoid `eval`; use arrays for dynamic command arguments.

## Forbidden Actions (Absolute Prohibitions)

- **NO** SSH configuration changes without verification
- **NO** complex setups or custom scripts
- **NO** actions that risk SSH availability
- **NO** skipping backup procedures
- **NO** proceeding without 100% certainty
- **NO** assumption anything works without checking
- **NO** skipping log checking in investigation step
- **NO** proceeding without verifying external port access
- **NO** 100% confirmation without complete verification process

## Internet Research Principles

- Always try official sources first: GitHub, official docs, vendor sites.
- Verify commands and configurations against authoritative references.
- Cross-reference with multiple sources for critical operations.

## Post-Installation Requirements (Mandatory)

After EVERY service installation or server setup:

1. **Create/Update Ansible Playbook** — If service was installed manually, create playbook to reproduce it.
2. **Update Documentation** — Add service to relevant docs (SERVICES.md, server-specific docs).
3. **Update memories.jsonl** — Log what was installed, where, and configuration details.
4. **Test Playbook** — Verify playbook can recreate the setup from scratch.
5. **Push to Git** — All changes committed and pushed before session ends.

**No installation is complete until it's reproducible via Ansible.**
