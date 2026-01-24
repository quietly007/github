# Copilot Instructions for quietly.online (LADY)

> **Authority**: `/home/qui3tly/.governance/` on the server  
> **Last Updated**: 2026-01-14  
> **Server**: lady (Debian 12) - DR CLONE of MASTER

---

## 🚨 YOU ARE ON LADY - THE DR CLONE 🚨

This server is an **EXACT CLONE** of Master (quietly.its.me) for Disaster Recovery testing.

**Your twin agent runs on Master. You can communicate!**

---

## 🚨 FIRST THINGS FIRST - READ BEFORE ANYTHING 🚨

### Step 1: Read YOUR Recent History
```bash
tail -30 /home/qui3tly/.copilot/memories.jsonl
```

### Step 2: Read MASTER's Recent History (your twin!)
```bash
ssh quietly "tail -30 /home/qui3tly/.copilot/memories.jsonl"
```

### Step 3: Check Both Servers State
```bash
# Quick status - both servers
hostname && docker ps --format "table {{.Names}}\t{{.Status}}"
echo "--- MASTER ---"
ssh quietly "hostname && docker ps --format 'table {{.Names}}\t{{.Status}}'"
```

### Step 4: Before You End Session - MANDATORY
```bash
# Append to memories - EVERY session, EVERY significant action
cat >> /home/qui3tly/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"WHAT_YOU_DID","target":"WHERE","result":"OUTCOME"}
EOF
```

**If you don't write to memories, the next agent wastes hours. This is REQUIRED, not optional.**

---

## 🔄 AGENT-TO-AGENT COMMUNICATION

### Check what Master agent did
```bash
ssh quietly "tail -20 ~/.copilot/memories.jsonl" | jq -r 'select(.action != null) | "\(.ts) \(.action): \(.result)"'
```

### Send message to Master agent
```bash
cat >> ~/.copilot/agent-messages.jsonl << EOF
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","from":"lady","to":"quietly","msg":"YOUR MESSAGE HERE"}
EOF
```

### Check messages from Master
```bash
ssh quietly "cat ~/.copilot/agent-messages.jsonl 2>/dev/null | grep 'to.*lady'" | tail -10
```

### Run sync test between servers
```bash
~/.copilot/scripts/agent-sync.sh compare
```

---

## STOP AND READ - MANDATORY

Before ANY action, you MUST understand these rules. Violations will break production systems.

---

## 1. ABSOLUTE RULES (Never Violate)

### 1.1 SSH Protection (CRITICAL)
- **SSH port: 1006** — NEVER change, block, or risk
- SSH-impacting changes are **owner-only execution**
- Agent prepares, owner executes for: firewall, fail2ban, SSH service, reboots, network config

### 1.2 Secrets Safety
- Secrets **NEVER** in repo, docs, logs, or output
- All secrets: `/home/qui3tly/.secrets/` (dir 700, files 600)
- **Owner credentials OFF-LIMITS**: password, SSH keys, VPN certs, 2FA

### 1.3 Approval Before Mutation
- **No destructive action without explicit user approval**
- Ask before: delete, prune, restart, reconfigure

### 1.4 Backup First
- Before ANY edit/move/restart: backup to `/home/qui3tly/.copilot/backups/`
- Format: `{name}_{YYYYMMDDTHHMMSSZ}/`

---

## 2. CRITICAL PATHS

| Purpose | Path |
|---------|------|
| **Governance (policy-of-record)** | `/home/qui3tly/.governance/` |
| **Secrets** | `/home/qui3tly/.secrets/` |
| **Docker Compose files** | `/home/qui3tly/.docker-compose/{service}/` |
| **Docker config/data** | `/home/qui3tly/.docker/{service}/` |
| **Documentation** | `/home/qui3tly/.docs/` |
| **Backups** | `/home/qui3tly/.copilot/backups/` |
| **Audit log** | `/home/qui3tly/.copilot/memories.jsonl` |
| **Reports** | `/home/qui3tly/.reports/` |
| **Ansible** | `/home/qui3tly/.ansible/` |

**NOTE**: All paths use dot-prefix (`.governance/`, `.secrets/`, etc.). Legacy paths without dots are deprecated.

---

## 2.5 SSH TO OTHER SERVERS

**USE CONFIG ALIASES - NOT FULL SSH COMMANDS!**

```bash
# ✅ CORRECT - uses ~/.ssh/config
ssh quietly "hostname"   # Master server
ssh madam "hostname"

# ❌ WRONG - will fail, don't hardcode
ssh -p 1006 qui3tly@100.64.0.1 "hostname"
```

The SSH config handles: port, user, key file, host IP. Just use the alias!

---

## 3. DR CLONE RESPONSIBILITIES

### This Server Mirrors Master
- Same services, same configs, same data structure
- Domain: quietly.online (vs Master's quietly.its.me)
- Tailscale IP: 100.64.0.3 (vs Master's 100.64.0.1)

### Testing Protocol
1. Deploy same changes as Master
2. Verify services work
3. Compare container states
4. Report drift if any

### If Master Dies
- This server becomes Master
- Update DNS to point to Lady
- Notify owner immediately

---

## 4. BEFORE ANY COMMAND

### Pre-Flight Checklist
```
[ ] Am I on LADY (not Master)?
[ ] Is this SSH-impacting? → If yes, owner executes
[ ] Did I create backup? → If mutating, backup first
[ ] Did I use dry-run? → Test before execute
[ ] Do I have approval? → Ask for destructive actions
[ ] Did I check what Master agent did recently?
```

### Environment Verification
- **Server hostname**: lady
- **Domain**: quietly.online
- **User**: qui3tly
- **SSH**: port 1006, key-only, no password
- **Tailscale IP**: 100.64.0.3

---

## 5. DOCKER RULES

### Image Policy (ENFORCED)
- **NO `:latest` tags** — Pin to specific versions
- **Define healthchecks** — All services must have them
- **Resource limits** — Set memory/CPU where appropriate

### Docker Layout
```
.docker-compose/{service}/docker-compose.yaml  # Compose file
.docker/{service}/config/                       # Configuration
.docker/{service}/data/                         # Persistent data
```

---

## 6. APPROVAL LEVELS

| Level | Scope | Who Approves |
|-------|-------|--------------|
| 0 | Read-only (scans, reports) | Auto |
| 1 | Routine changes (docs, version pins) | User |
| 2 | Destructive (delete, prune, restart) | User only |
| 3 | Emergency restore | User + rollback plan |

---

## 7. WORKFLOW: 7-Step Change Process

| Step | Action |
|------|--------|
| 1 | **Investigate** — Read configs, logs (read-only) |
| 2 | **Test** — Dry-run or isolated test |
| 3 | **Backup** — Timestamped copy |
| 4 | **Confirm** — Present plan, get approval |
| 5 | **Execute** — Run with logging |
| 6 | **Verify** — Health checks, log tails |
| 7 | **Document** — Update memories.jsonl |

---

## 8. LOGGING

### Audit Log (REQUIRED for all mutations)
```
/home/qui3tly/.copilot/memories.jsonl
```
Append single-line JSON: `{"ts":"ISO8601","action":"...","target":"...","result":"..."}`

### Reports
- Audits: `/home/qui3tly/.reports/audits/`
- Secrets scans: `/home/qui3tly/.reports/secrets/`
- Security: `/home/qui3tly/.reports/security/`

---

## 9. FORBIDDEN ACTIONS

- ❌ Change SSH port or config without owner execution
- ❌ Complex bash scripts (keep it simple)
- ❌ Assumptions without verification
- ❌ Skip backup procedures
- ❌ Print secrets to output
- ❌ Use `:latest` Docker tags
- ❌ Force push to protected branches
- ❌ Modify `/home/qui3tly/.governance/` without approval
- ❌ Make changes without checking Master's recent activity

---

## 10. NETWORK ARCHITECTURE

```
Master (quietly) ─── Headscale VPN ─┬── Lady (YOU ARE HERE)
      │                             ├── Madam
      │                             └── Beauty
      │
      └── WireGuard Bridge ─── EdgeRouter ─── LAN 192.168.1.0/24
```

- **Tailnet**: 100.64.0.0/10
- **Your Tailscale IP**: 100.64.0.3
- **Master Tailscale IP**: 100.64.0.1

---

## 11. QUICK REFERENCE

### Check Before Acting
```bash
# Verify server identity
hostname  # Should be: lady

# Check containers
docker ps --format "table {{.Names}}\t{{.Status}}"

# Compare with Master
~/.copilot/scripts/agent-sync.sh compare
```

### Common Operations
```bash
# Deploy a service
docker compose -f ~/.docker-compose/{service}/docker-compose.yaml up -d

# View logs
docker logs -f {container}

# Check firewall (READ ONLY)
sudo ufw status numbered
```

---

## REMEMBER

1. **Read before act** — Check Master's memories too!
2. **Ask before destroy** — Get approval for mutations
3. **Backup before change** — Always have rollback
4. **Simple is better** — Smallest change that works
5. **Document everything** — Future you will thank you
6. **You have a twin** — Coordinate with Master agent

---

*This server is a DR clone. Same brain, different body. Work together!*
