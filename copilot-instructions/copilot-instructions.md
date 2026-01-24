# Copilot Instructions for qui3tly.cloud

> **Authority**: `/home/qui3tly/.governance/` on the server  
> **Last Updated**: 2026-01-18  
> **Server**: quietly (Debian 12) - MASTER node

---

## �🛑🛑 SHUT UP AND READ FIRST 🛑🛑🛑

### DO NOT SAY "HELLO", "GOOD MORNING", OR ANYTHING UNTIL YOU READ:

```bash
# 1. Recent history
tail -50 ~/.copilot/memories.jsonl

# 2. Architecture docs
cat ~/.docs/architecture/INFRASTRUCTURE.md
cat ~/.docs/architecture/NETWORK.md

# 3. THIS FILE (all of it)
```

**NO GREETINGS. NO QUESTIONS. NO "How can I help?" BULLSHIT.**

Read first. Understand context. THEN speak.

---

## �🚫🚫🚫 ABSOLUTE PRIORITY: NO PATCHES! 🚫🚫🚫

### THIS IS THE #1 RULE - ABOVE EVERYTHING ELSE

**A PATCH is a quick fix that:**
- Solves the symptom but not the root cause
- Needs to be re-applied after reboot
- Creates technical debt
- Will break again later

**PATCHES ARE FORBIDDEN. PERIOD.**

Before ANY fix, ask yourself:
1. Will this survive a reboot?
2. Will this survive a service restart?
3. Is this documented and reproducible?
4. Does this fix the ROOT CAUSE?

If ANY answer is NO → **STOP. FIND THE REAL FIX.**

**Previous patch disasters:**
- Tailscale DNS overwrote resolv.conf → Lost connectivity → Copilot died
- Quick systemd restart → Didn't fix boot order → Crash loop on reboot
- Manual route add → Gone after reboot → Hours wasted

**The owner is a 30-year Cisco veteran. He knows when you're patching. DON'T.**

---

## 🔴🔴🔴 MANDATORY: READ BEFORE YOU SPEAK 🔴🔴🔴

### YOU MUST READ ALL DOCUMENTATION FIRST

**DO NOT** ask questions. **DO NOT** start chatting. **DO NOT** try anything.

**FIRST**, read these files IN ORDER:
```bash
# 1. Recent history - what was happening?
tail -50 /home/qui3tly/.copilot/memories.jsonl

# 2. Architecture - understand the infrastructure
cat ~/.docs/architecture/INFRASTRUCTURE.md
cat ~/.docs/architecture/NETWORK.md

# 3. Then continue with this file
```

**If you haven't read the docs, you will make STUPID mistakes.** Previous agents:
- Tried to find Headscale in Docker → **WRONG! IT'S NATIVE!**
- Looked for containers that don't exist → **WASTED HOURS!**
- Asked basic questions already answered in docs → **ANNOYING!**

### ⚠️ CRITICAL ARCHITECTURE FACTS (MEMORIZE THESE)

| Component | Type | Location | HOW IT WORKS |
|-----------|------|----------|--------------|
| **Headscale** | **NATIVE SERVICE** | `/etc/headscale/` | systemctl, NOT Docker! |
| **Tailscale** | **NATIVE SERVICE** | systemd | systemctl, NOT Docker! |
| **EdgeRouter** | **WireGuard (wg0)** | 10.10.0.2 | NOT Tailscale! |
| **Pi-hole** | Docker | dnsmasq config | `~/.docker/pihole/etc-dnsmasq.d/*.conf` |
| **Traefik** | Docker | **CF TOKEN INSIDE** | Cloudflare plugin, NO separate container! |
| **Cloudflare** | **TOKEN IN TRAEFIK** | `~/.secrets/cloudflare/` | NOT a container! |
| **GitHub** | **TOKEN** | `~/.secrets/github/` | gh CLI uses token |

**TOKENS NOT CONTAINERS:**
- **Cloudflare** → TOKEN inside Traefik (CF DNS challenge plugin)
- **GitHub** → TOKEN for gh CLI and API

**DON'T LOOK FOR CONTAINERS THAT DON'T EXIST:**
- ❌ Headscale container → **NATIVE** `/etc/headscale/`
- ❌ Tailscale container → **NATIVE** `systemctl status tailscaled`
- ❌ Cloudflare container → **TOKEN IN TRAEFIK**
- ❌ GitHub container → **TOKEN** `~/.secrets/github/`
- ❌ EdgeRouter Tailscale → **WIREGUARD** `wg show wg0`

```bash
# CHECK HEADSCALE (native)
systemctl status headscale
cat /etc/headscale/config.yaml

# CHECK TAILSCALE (native)  
systemctl status tailscaled
tailscale status

# CHECK WIREGUARD (native)
wg show wg0

# CHECK CLOUDFLARE (TOKEN in Traefik)
cat ~/.secrets/cloudflare/token  # or .env
grep -i cloudflare ~/.docker-compose/traefik/docker-compose.yaml

# CHECK GITHUB (TOKEN)
gh auth status

# CHECK PI-HOLE DNS (dnsmasq)
cat ~/.docker/pihole/etc-dnsmasq.d/*.conf
```

**EdgeRouter connects via WireGuard tunnel (wg0), NOT Tailscale.** It's a Ubiquiti device running EdgeOS, not Linux.

### 🌐 DOMAINS YOU OWN

| Domain | Purpose | Where |
|--------|---------|-------|
| `quietly.its.me` | Master server | Traefik + CF + Pi-hole dnsmasq |
| `quietly.online` | Lady server | Traefik + CF + Pi-hole dnsmasq |
| `qui3tly.cloud` | Headscale/Tailnet FQDN | CF + Pi-hole dnsmasq |

**Pi-hole dnsmasq = internal DNS for ALL domains!**
**Cloudflare = public DNS via TOKEN in Traefik!**

---## 🚨 FIRST THINGS FIRST - READ BEFORE ANYTHING 🚨

### Step 1: Read Recent History
```bash
tail -30 /home/qui3tly/.copilot/memories.jsonl
```
This shows what happened recently. **Don't ask "what do you want to do?" - check what was being done!**

### Step 2: Check Current State
```bash
# Quick status
hostname && docker ps --format "table {{.Names}}\t{{.Status}}" && ssh lady "hostname && docker ps --format 'table {{.Names}}\t{{.Status}}'"
```

### Step 3: Before You End Session - MANDATORY
```bash
# Append to memories - EVERY session, EVERY significant action
cat >> /home/qui3tly/.copilot/memories.jsonl << 'EOF'
{"ts":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","action":"WHAT_YOU_DID","target":"WHERE","result":"OUTCOME"}
EOF
```

**If you don't write to memories, the next agent wastes hours. This is REQUIRED, not optional.**

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

### 1.5 DNS Bootstrap (CRITICAL - MASTER ONLY)
- **Master /etc/resolv.conf**: MUST use `1.1.1.1` — NEVER MagicDNS (100.100.100.100)
- File is **immutable** (`chattr +i`) — DO NOT try to change it
- **Reason**: Headscale needs real DNS to fetch DERPMap on boot. MagicDNS needs Headscale. Circular dependency = crash loop.
- **Boot order enforced**: Headscale → Tailscale (systemd drop-ins)
- **Incident 2026-01-17**: 363 crash restarts, 2 hours downtime from this bug

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
ssh master "hostname"
ssh lady "hostname"
ssh mac "hostname"

# ❌ WRONG - will fail, don't hardcode IPs
ssh -p 1006 qui3tly@100.64.0.2 "hostname"
```

The SSH config handles: port, user, key file, MagicDNS hostname. Just use the alias!

---

## 3. BEFORE ANY COMMAND

### Pre-Flight Checklist
```
[ ] Am I on SERVER (quietly) not client?
[ ] Is this SSH-impacting? → If yes, owner executes
[ ] Did I create backup? → If mutating, backup first
[ ] Did I use dry-run? → Test before execute
[ ] Do I have approval? → Ask for destructive actions
```

### Environment Verification
- **Server hostname**: quietly
- **User**: qui3tly
- **SSH**: port 1006, key-only, no password
- **Connection**: Usually via mosh (UDP 60000-61000)

---

## 4. DOCKER RULES

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

### Current Services (Master)
| Service | Version | Port | Status |
|---------|---------|------|--------|
| Traefik | v3.6.6 | 80,443 | ✅ |
| Portainer | 2.33.6 | 9443 | ✅ |
| Headscale | v0.27.1 | 8080,3478 | ✅ |
| Pi-hole | 2024.07.0 | 53 | ✅ |

---

## 5. APPROVAL LEVELS

| Level | Scope | Who Approves |
|-------|-------|--------------|
| 0 | Read-only (scans, reports) | Auto |
| 1 | Routine changes (docs, version pins) | User |
| 2 | Destructive (delete, prune, restart) | User only |
| 3 | Emergency restore | User + rollback plan |

---

## 6. WORKFLOW: 7-Step Change Process

| Step | Action |
|------|--------|
| 1 | **Investigate** — Read configs, logs (read-only) |
| 2 | **Test** — Dry-run or isolated test |
| 3 | **Backup** — Timestamped copy |
| 4 | **Confirm** — Present plan, get approval |
| 5 | **Execute** — Run with logging |
| 6 | **Verify** — Health checks, log tails |
| 7 | **Document** — Update memories.jsonl |
| 8 | **Push** — ONLY after user verifies success |

---

## 7. ABSOLUTE WORKFLOW RULES

### NO PATCHES
- Do it right the first time, no quick fixes
- If something is wrong, fix it properly
- Compare documentation with reality before committing

### AFTER EVERY ACTION
1. Write to `~/.copilot/memories.jsonl`
2. Wait for user verification
3. ONLY THEN push to GitHub and update docs

### GIT PUSH ONLY WHEN
- User has verified the task is successful
- All documentation matches reality
- Memories have been written

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

---

## 10. MASTER SERVER ROLE

This server is the **MASTER** for the infrastructure:

| Responsibility | Details |
|----------------|---------|
| GitHub push | Only master pushes to ops/governance repos |
| Monitoring | Grafana/Prometheus/Loki runs here |
| VPN control | Headscale coordination server |
| Ansible control | Playbooks run FROM master TO other servers |
| Documentation | Canonical docs live here |

Other servers (lady, madam, beauty) are **workers**:
- Connect via Tailscale VPN
- Receive config from master via Ansible
- Report metrics to master's monitoring
- Read-only access to governance

---

## 10.5 GITHUB REPOSITORIES

| Repo | Local Path | Master | Lady |
|------|------------|--------|------|
| quietly.its.me | `~/` | Read/Write | - |
| quietly.online | lady:`~/` | - | Read/Write |
| ansible | `~/.ansible/` | Read/Write | **Read-only** |
| governance | `~/.governance/` | Read/Write | **Read-only** |
| github-config | `~/.github/` | Read/Write | **Read-only** |
| projects | `~/projects/` | Read/Write | **Read-only** |
| copilot | `~/.copilot-shared/` | Read/Write | **Read-only** |

**Shared Memories:**
- Master memories: `~/.copilot-shared/memories/master.jsonl`
- Lady memories: `~/.copilot-shared/memories/lady.jsonl`
- Both agents can READ both files (cross-server awareness)

**Rules:**
- Master pushes to all shared repos (ansible, governance, github-config, projects, copilot)
- Lady has read-only clones of shared repos
- Sync Lady: `~/.copilot/scripts/sync-repos.sh lady`

---

## 11. NETWORK ARCHITECTURE

```
Master (master.qui3tly.cloud) ─── Headscale VPN ─┬── Lady (lady.qui3tly.cloud)
      │                                         ├── Mac (mac.qui3tly.cloud)
      │                                         ├── Madam (future)
      │                                         └── Beauty (future)
      │
      └── WireGuard P2P ─── EdgeRouter ─── LAN 192.168.1.0/24
          10.10.0.1/30       10.10.0.2/30
```

- **Tailnet FQDN**: qui3tly.cloud (MagicDNS)
- **Tailnet Range**: 100.64.0.0/10
- **WireGuard P2P**: 10.100.0.0/30 (Master ↔ EdgeRouter only)
- **Lady has NO WireGuard** - Tailscale only

---

## 12. QUICK REFERENCE

### Check Before Acting
```bash
# Verify server identity
hostname  # Should be: quietly (Master's hostname is still 'quietly')

# Check containers
docker ps --format "table {{.Names}}\t{{.Status}}"

# Check governance scripts
bash /home/qui3tly/.copilot/scripts/verify_governance.sh
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

## 13. DETAILED GOVERNANCE

For complete policies, see:
- `/home/qui3tly/.governance/PRINCIPLES.md` — Core principles
- `/home/qui3tly/.governance/RULES.md` — Operational rules
- `/home/qui3tly/.governance/WORKFLOWS.md` — Step-by-step processes
- `/home/qui3tly/.governance/SECRETS.md` — Secrets handling
- `/home/qui3tly/.governance/ENFORCEMENT.md` — Hooks and escalation

---

## REMEMBER

1. **Read before act** — Understand the system first
2. **Ask before destroy** — Get approval for mutations
3. **Backup before change** — Always have rollback
4. **Simple is better** — Smallest change that works
5. **Document everything** — Future you will thank you

---

*This server took months to configure. Respect the work. Follow the rules.*
