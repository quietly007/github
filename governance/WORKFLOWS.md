# Workflows

Mandatory processes for common operations.

Scope: These workflows assume a **remote-only VPS**. Lockout prevention and SSH safety are mandatory.

## 7-Step Change Workflow

| Step | Action | Notes |
|------|--------|-------|
| 1 | **Investigation** | Collect evidence (read-only): configs, logs, container state |
| 2 | **Testing** | Dry-run or isolated test |
| 3 | **Backup** | Timestamped copy to `.copilot/backups/`; record path |
| 4 | **Confirmation** | Present plan, risk, commands, rollback; get explicit user approval |
| 5 | **Implementation** | Execute with logging; capture stdout/stderr |
| 6 | **Verification** | Health checks, log tailing, state confirmation |
| 7 | **Documentation** | Append to `.copilot/memories.jsonl`; update reports/runbooks |

**SSH-impacting changes:** Agent stops after step 4; owner executes steps 5–7.

### SSH-Impacting Change Examples

The following require **owner-only execution** (agent prepares, owner runs):

- Firewall rule changes (UFW, iptables)
- fail2ban configuration changes
- SSH service restarts
- Server reboots
- Network configuration changes
- Port changes on any service
- Kernel or systemd changes affecting networking

## VERIFY 100% Workflow (9-Step)

**Triggers:** User says "VERIFY" OR first action attempt fails.

When triggered, agent MUST:

| Step | Action |
|------|--------|
| 1 | Deep inspection and analysis |
| 2 | Check everything thoroughly |
| 3 | Verify through internet (official sources) |
| 4 | Check everything locally |
| 5 | Cross-reference with PRINCIPLES.md |
| 6 | Deep log analysis |
| 7 | Internet verification (second pass) |
| 8 | Local verification (second pass) |
| 9 | Principles compliance check |

**After first failure:**
- MUST NOT try to fix problem
- MUST NOT do anything else
- MUST complete VERIFY 100% first
- ONLY THEN proceed with second attempt
- Document everything in memory

## Lockout Prevention

Before SSH-impacting changes:

1. **Two SSH sessions open** — one for work, one as fallback
2. **tmux or screen required** — protect against disconnect
3. **Pre-schedule rollback** — have commands ready to undo
4. **Test on non-critical port first** if possible

## Connection Environment

- Primary connection: **mosh** (UDP ports 60000-61000)
- Fallback: SSH on port 1006
- Always verify client vs server before acting

### Environment Details

| Side | System | Hostname | Purpose |
|------|--------|----------|----------|
| Client | Windows 11 (VS Code + WSL/SSH) | quietly-home | Remote development client |
| Server | Debian 12 | quietly.its.me | Remote development server |
| Network | Ubiquiti UniFi EdgeRouter (EdgeOS) | edgerouter | Gateway/router; runs Wireguard to connect to Headscale | 192.168.1.0/24 LAN

**SSH Baseline (sshd_config)**

- Port 1006; root login disabled; SFTP subsystem `/usr/lib/openssh/sftp-server`
- Auth: Pubkey yes; PasswordAuth no; empty passwords disabled; ChallengeResponse/KbdInteractive disabled; PAM disabled; no cloud-init drop-ins
- Hardening: MaxAuthTries 2; MaxStartups 10:30:100; MaxSessions 5
- Keepalives: ClientAliveInterval 60; ClientAliveCountMax 5; TCPKeepAlive yes

**Org-wide Code/Policy**

- `.github/` workflows and instructions are authoritative for all nodes; edits only from master, others consume read-only via Git.

**SSH Client Profiles (~/.ssh/config)**

- lady → 207.180.251.111, user `qui3tly`, key `~/.ssh/quietly.its.me`, port 1006
- madam → 164.68.107.251, user `qui3tly`, key `~/.ssh/quietly.its.me`, port 1006
- beauty → 84.247.176.135, user `qui3tly`, key `~/.ssh/quietly.its.me`, port 1006
- master → 213.136.68.108, user `qui3tly`, key `~/.ssh/quietly.its.me`, port 1006

## Secrets Discovery Workflow

1. Report path + matched pattern only (**never print value**).
2. Backup original to `.copilot/backups/`.
3. Present options: redact, move to `.secrets/`, rotate.
4. On approval: move, `chmod 600`, record in audit log.

## Emergency Response Workflow

1. Collect minimal facts: service name, last 200 log lines, recent changes.
2. Notify user with options and risks.
3. Execute **only after explicit approval** and documented rollback plan.

## Pre-Change Checks

- `shellcheck` on changed `.sh` files.
- YAML validation: `yq` or `python -c 'import yaml'`.
- Compose validation: `docker compose config` in service folder.

## Post-Change Validation

- `docker ps` / `docker compose ps` for expected containers.
- Tail logs ≥30s for errors.
- Hit health endpoints; compare to baseline.

## Mandatory Log Checking

**AFTER EVERY STEP:** Check logs deeply and thoroughly.

- Analyze ALL container logs before confirming anything
- Check ALL service logs before proceeding
- Check server logs completely
- Analyze error logs thoroughly
- **Never assume anything works without checking logs**
- **Never confirm anything works without complete log analysis**
