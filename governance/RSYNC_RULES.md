# RSYNC Rules - CRITICAL

> **Created**: 2026-01-27 after CATASTROPHIC failure  
> **Status**: ✅ MANDATORY - NO EXCEPTIONS  
> **Severity**: CRITICAL

---

## ❌ CATASTROPHIC FAILURE - JANUARY 27, 2026

**What Happened**: AI agent used `rsync --delete` from Master to Lady, deleting ALL Lady-specific services:
- Deleted: mailcow docker-compose (21 running containers)
- Deleted: nextcloud, unifi, uisp, home-assistant compose files
- Deleted: mta-sts configuration
- **Result**: Services still running but NO WAY TO MANAGE THEM

**Root Cause**: Failed to understand that Master and Lady have DIFFERENT service configurations.

**Impact**: CATASTROPHIC - Lost management files for production email server and other critical services.

---

## 🚨 MANDATORY RULES - NO EXCEPTIONS

### Rule 1: NEVER Use --delete Between Different Servers

```bash
# ❌ FORBIDDEN - Will delete unique services
rsync -avz --delete master:~/.docker-compose/ lady:~/.docker-compose/

# ✅ CORRECT - Preserves unique services on destination
rsync -avz master:~/.docker-compose/service-name/ lady:~/.docker-compose/service-name/
```

**Why**: Each server has unique services. Master ≠ Lady.

### Rule 2: Check Server Differences BEFORE Sync

**MANDATORY PRE-SYNC CHECK**:
```bash
# 1. List services on source
ssh master "ls ~/.docker-compose/"

# 2. List services on destination
ssh lady "ls ~/.docker-compose/"

# 3. Identify unique services on destination
# 4. NEVER sync directories that don't exist on source
# 5. ONLY sync shared services OR use selective sync
```

### Rule 3: Server-Specific Services

**Master Services**:
- monitoring (prometheus, grafana, alertmanager, loki)
- VPN (tailscale, wireguard)
- DNS (pihole)
- security (crowdsec, authelia)
- infrastructure (traefik, portainer)

**Lady Services** (UNIQUE - DO NOT DELETE):
- **mailcow** (21 containers - PRODUCTION EMAIL)
- **nextcloud** (file storage)
- **unifi** (network management)
- **uisp** (ISP management)
- **home-assistant** (IoT)
- **mta-sts** (email security)

**Shared Services**:
- traefik (but different configs)
- crowdsec (shared threat intelligence)
- monitoring agents (promtail, node-exporter)

### Rule 4: Approved Rsync Patterns

#### ✅ SAFE: Selective Directory Sync
```bash
# Sync specific service (both servers have it)
rsync -avz ~/.docker/traefik/config/ lady:~/.docker/traefik/config/

# Sync new service to Lady
rsync -avz ~/.docker-compose/new-service/ lady:~/.docker-compose/new-service/
```

#### ✅ SAFE: Exclude Unique Services
```bash
# Sync with exclusions (better but still risky)
rsync -avz \
  --exclude='mailcow' \
  --exclude='nextcloud' \
  --exclude='unifi' \
  --exclude='uisp' \
  --exclude='home-assistant' \
  --exclude='mta-sts' \
  ~/.docker-compose/ lady:~/.docker-compose/
```

#### ❌ FORBIDDEN: Blind --delete
```bash
# NEVER DO THIS
rsync -avz --delete ~/.docker-compose/ lady:~/.docker-compose/
rsync -avz --delete ~/.docker/ lady:~/.docker/
```

### Rule 5: Git-Based Sync for Shared Configs

**PREFERRED METHOD**: Use Git for configuration sync
```bash
# On Lady: Pull updates from GitHub
ssh lady "cd ~/.docker && git pull origin main"

# Result: Only tracked files updated, unique files preserved
```

### Rule 6: Permission Errors = CRITICAL ERRORS

**NEVER dismiss permission errors as**:
- ❌ "non-critical"
- ❌ "expected"
- ❌ "normal"
- ❌ "cosmetic"

**ALL permission errors MUST be**:
- ✅ Fixed immediately
- ✅ Documented in memories.jsonl
- ✅ Root cause identified
- ✅ Verified fixed

---

## 📋 Pre-Sync Checklist (MANDATORY)

Before ANY rsync operation:

- [ ] Listed source services
- [ ] Listed destination services
- [ ] Identified unique services on destination
- [ ] Confirmed sync will NOT delete unique services
- [ ] Using specific paths OR exclusions
- [ ] NOT using --delete flag between different servers
- [ ] Documented sync plan in memories.jsonl
- [ ] User approved sync operation

**If ANY checkbox fails**: STOP and ask user.

---

## 🔧 Recovery Procedures

If you accidentally delete compose files:

1. **Check git history on destination**:
   ```bash
   ssh lady "cd ~/.docker && git status"
   ssh lady "cd ~/.docker && git diff HEAD"
   ```

2. **Restore from git** (if tracked):
   ```bash
   ssh lady "cd ~/.docker && git restore ."
   ```

3. **Restore from backup**:
   ```bash
   ssh lady "ls ~/.copilot/backups/"
   ```

4. **Recreate from running containers**:
   ```bash
   # Get container inspect output
   ssh lady "docker inspect mailcowdockerized-nginx-mailcow-1"
   ```

---

## 🎓 Lessons Learned

1. **Understand architecture before acting** - Know what each server runs
2. **NEVER assume servers are identical** - They're not
3. **Permission errors are ALWAYS critical** - No exceptions
4. **--delete is dangerous** - Use only when 100% certain
5. **Git > rsync for configs** - Safer, trackable, reversible
6. **Check before destroy** - Preview operations first

---

## ✅ Enforcement

- This document is MANDATORY reading before ANY rsync operation
- Violations will be documented in memories.jsonl
- Repeated violations = escalation to user
- NO EXCEPTIONS to these rules

---

**Remember**: Production systems depend on these configurations. One wrong rsync command can break email, storage, network management, and IoT systems.
