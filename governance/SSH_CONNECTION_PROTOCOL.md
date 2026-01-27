# SSH Connection Protocol - MANDATORY

**Created**: 2026-01-28T01:00:00Z
**Reason**: Agent repeatedly attempted SSH connections using defaults instead of reading config
**Authority**: ABSOLUTE - NO EXCEPTIONS

---

## 🛑 BEFORE ANY SSH CONNECTION - MANDATORY CHECKLIST

**RULE**: NEVER attempt SSH connection without completing this checklist FIRST.

### ✅ STEP 1: Read SSH Config

**Command**: `cat ~/.ssh/config`

**MUST identify**:
- [ ] Actual hostname/alias
- [ ] Actual port (NOT 22 default)
- [ ] Actual connection method (IP vs Tailscale)
- [ ] Authentication method (pubkey ONLY)
- [ ] User account

**If config doesn't exist or incomplete**: STOP and ask user for connection details.

---

## 🛑 LADY SERVER CONNECTION - SPECIFIC REQUIREMENTS

**From SSH config** (must be read first):

```
Host lady
    HostName 100.64.0.2          # Tailscale IP (NOT public IP)
    Port 1006                     # Custom port (NOT 22)
    User qui3tly                  # User account
    IdentityFile ~/.ssh/id_ed25519  # Pubkey only
    StrictHostKeyChecking yes
```

**Connection Rules**:
1. ✅ MUST use Tailscale IP (100.64.0.2) - NEVER public IP
2. ✅ MUST use port 1006 - NEVER port 22
3. ✅ MUST use pubkey authentication - NEVER password
4. ✅ MUST use SSH alias: `ssh lady` (NOT `ssh user@IP`)

**Correct command**: `ssh lady`
**System handles**: Tailscale IP, port 1006, pubkey auth automatically

---

## 🛑 FORBIDDEN ACTIONS

**NEVER do these** (historical violations from this session):

❌ `ssh qui3tly@207.180.251.111` - Using public IP instead of Tailscale
❌ `ssh -p 22 lady` - Using default port instead of configured port
❌ `ssh -o PasswordAuthentication=yes` - Trying password instead of pubkey
❌ Attempting connection WITHOUT reading SSH config first

**If you do any of these**: You violated governance and wasted user's time.

---

## 🔧 DEBUG/INSPECTION PROTOCOL

**Before ANY connection attempt**:

1. **Read SSH config**: `cat ~/.ssh/config`
2. **Verify Tailscale connectivity**: `tailscale status | grep lady`
3. **Check if service is reachable**: `nc -zv 100.64.0.2 1006`
4. **THEN and ONLY THEN**: `ssh lady`

**For debugging connection issues**:
```bash
# Check Tailscale status
tailscale status

# Check SSH config
cat ~/.ssh/config | grep -A 10 "Host lady"

# Test connectivity
ping -c 3 100.64.0.2

# Test port
nc -zv 100.64.0.2 1006

# Verbose SSH (if still failing)
ssh -v lady
```

---

## 📋 VERIFICATION CHECKLIST

Before marking ANY SSH-related task as complete:

- [ ] Read SSH config file FIRST
- [ ] Used Tailscale IP (not public IP)
- [ ] Used correct port from config (not default 22)
- [ ] Used pubkey authentication (not password)
- [ ] Connection succeeded with clean logs
- [ ] Verified with actual command output

**If ANY checkbox is NO**: Task is NOT complete. Fix and retry.

---

## 🚨 CONSEQUENCES OF VIOLATION

**If agent attempts SSH without following this protocol**:
- ❌ Connection will FAIL (wrong port/IP/auth)
- ❌ User must correct agent's assumptions
- ❌ Time wasted
- ❌ Demonstrates agent doesn't read available configuration
- ❌ Violates PRE_FLIGHT_CHECKLIST governance

**Historical violations** (this session):
- Request #16: Attempted connection without checking config
- Request #21: agent-sync.sh attempted connection (failed)
- Result: User frustration, repeated pattern of not reading docs

---

## ✅ CORRECT WORKFLOW EXAMPLE

```bash
# 1. Read SSH config FIRST
cat ~/.ssh/config | grep -A 10 "Host lady"

# 2. Verify Tailscale connectivity
tailscale status | grep lady

# 3. Test port connectivity (if debugging)
nc -zv 100.64.0.2 1006

# 4. Connect using SSH alias
ssh lady

# 5. Verify connection in logs
# (check output for clean connection, no errors)
```

**Result**: Clean connection, no errors, no wasted time.

---

**ENFORCEMENT**: This protocol is MANDATORY. Violations are inexcusable.

**Related governance**:
- PRE_FLIGHT_CHECKLIST.md (CHECKPOINT 4: Check configs before acting)
- FILE_CREATION_RULES.md
- DOCKER_LAYOUT.md

**Authority**: Absolute - based on repeated agent failures in this session.
