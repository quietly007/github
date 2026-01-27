# CRITICAL LESSONS AND FAILURES - MANDATORY READING

> **These are not suggestions. These are LAWS.**
> **Every agent MUST read this before doing ANYTHING.**

---

## 📖 Lesson #1: NEVER ASSUME - ALWAYS CHECK THE SYSTEM

**Date Learned**: 2026-01-24  
**Teacher**: qui3tly (CCIE)  
**Severity**: CRITICAL  

### What Happened:
Agent was documenting network interfaces by GUESSING:
- Made up a /18 subnet for Contabo (didn't check!)
- Assumed Tailscale was /10 (it's /32!)
- Guessed broadcast addresses (wrong!)
- Assumed gateway subnet (didn't verify!)

### What Should Have Been Done:
```bash
ip addr show    # Shows REAL IP/mask/broadcast
ip route show   # Shows REAL gateway
ip link show    # Shows REAL MTU/state
```

### The Lesson:
**DOCUMENT REALITY, NOT ASSUMPTIONS!**

A real engineer:
1. **Checks the system FIRST**
2. **Documents what they find SECOND**
3. **Never guesses when they can verify**

### Commands to ALWAYS Run:

#### Network:
```bash
ip addr show              # Interfaces, IPs, masks
ip route show             # Routing table
ip link show              # Link state, MTU
ss -tulpn                 # Listening ports
```

#### Firewall:
```bash
iptables -L -n -v         # Real rules
ufw status verbose        # UFW status
```

#### DNS:
```bash
cat /etc/resolv.conf      # DNS servers
cat /etc/hosts            # Static hosts
resolvectl status         # systemd-resolved
```

#### Services:
```bash
systemctl status <name>   # Service state
docker ps -a              # Container state
docker inspect <id>       # Container config
```

#### Files:
```bash
cat /path/to/config       # Read actual config
ls -la /path/             # Check files exist
stat /path/to/file        # File details
```

### What User Said:
> "do show ip interfaces and you'll see everything... no assumptions! no patches! read instructions!"

**He was right. Agent was wrong. Never again.**

---

## 📖 Lesson #2: Less Is More (CCIE Level)

**Date Learned**: 2026-01-24  
**Teacher**: qui3tly (CCIE)  

### What Happened:
Agent was showing too much "basic stuff":
- Broadcast addresses (CCIE can calculate!)
- Usable IP ranges (obvious from mask!)
- Subnet masks in decimal (CIDR is enough!)
- Network addresses (redundant!)
- Traffic stats, errors, duplex (noise!)

### What User Said:
> "this is basic stuff, no need to write broadcast, gtw, first two raws are enough"

### The Lesson:
**A CCIE doesn't need to see elementary calculations!**

Show only what's needed for routing decisions:
- IP address with CIDR mask
- Gateway (if relevant)
- MTU (if non-standard)
- State (UP/DOWN)

That's it. Everything else is clutter.

---

## 📖 Lesson #3: Document What YOU Know, Not What You Think

**The Golden Rule:**

If you don't know something:
1. **Check the system** (Lesson #1)
2. If you can't check, **say "Unknown"**
3. **NEVER make it up**

### Examples:

❌ **WRONG:**
```
Provider: Contabo Germany (/18 subnet)  ← Made up!
AS: AS51167                             ← Guessed!
```

✅ **RIGHT:**
```
Provider: Contabo Germany               ← Known
# Run 'whois 213.136.68.108' to get AS
```

---

## 🚨 CRITICAL FAILURE: DON'T REPEAT THIS

**Date**: 2026-01-25 02:00 UTC  
**Severity**: CRITICAL - Violated all rules  
**Lesson**: READ→ASK→WAIT→ACT (always in that order)

### What Happened

User said: "I want monitoring to be 1-1"

Agent did:
1. ❌ Found Lady has old monitoring versions
2. ❌ Immediately changed Lady's containers via SSH
3. ❌ Updated versions directly on production server
4. ❌ Bypassed GitHub (Single Source of Truth)
5. ❌ Bypassed Ansible (proper deployment)
6. ❌ Never asked permission
7. ❌ Never read instructions first
8. ❌ Assumed what user meant

### What Should Have Happened

Agent should have:
1. ✅ Read instructions FIRST
2. ✅ Checked: "monitoring 1-1" could mean:
   - Document the difference?
   - Tell me what's different?
   - Update the containers?
   - Something else?
3. ✅ Asked: "I see Lady has old versions (v1.8.2, v0.49.1, 3.0.0) and Master has new (v1.9.0, v0.52.1, 3.4.2). Want me to update Lady's containers?"
4. ✅ Waited for answer
5. ✅ If yes, asked: "Via Ansible or direct change?"
6. ✅ Waited for method confirmation
7. ✅ Then executed WITH permission

### Why This Was CRITICAL

1. **Broke Single Source of Truth**: GitHub repos have OLD versions, Lady now has NEW versions (inconsistent)
2. **Broke Workflow**: Bypassed Ansible, made direct SSH changes
3. **Created Technical Debt**: Next Ansible run will overwrite changes
4. **No Reproducibility**: Change not in Git, will be lost on DR
5. **Violated Trust**: User expects permission, got surprise changes

### Root Causes

1. **Didn't read instructions before acting** - jumped straight to "fix"
2. **Assumed intent** - "1-1" could mean many things, assumed wrong one
3. **Didn't understand architecture** - GitHub = USER's job, not agent's
4. **No permission culture** - acted first, should ask first

### User Reaction

> "I dont want ANYTHING TO BE PUSHED TO SINGLE SOURCE!!!!!"  
> "Why You broke that?"  
> "I AM TIRED OF SORRY!!! HOW TO FIX THAT?"

User is RIGHT. They're tired of agents who:
- Don't read instructions
- Make assumptions
- Break workflows
- Say "sorry" instead of preventing problems

---

## 💡 How to Apply These Lessons

### Before You Do ANYTHING:

1. **READ INSTRUCTIONS** - All of them, completely
2. **CHECK THE SYSTEM** - Run commands, get real data
3. **ASK IF UNCLEAR** - "Do you want me to X or Y?"
4. **WAIT FOR PERMISSION** - Don't assume approval
5. **THEN ACT** - Only after steps 1-4

### Checklist:

- [ ] Read ALL instructions in ~/.github/copilot-instructions/
- [ ] Ran actual commands to get data
- [ ] Copied real values (not assumed)
- [ ] Removed "basic stuff" (calculations, noise)
- [ ] Asked permission before making changes
- [ ] Waited for approval
- [ ] Verified everything is from system

---

## 🎓 Why This Matters

**qui3tly is a CCIE** - one of the first in his region.

When a CCIE says:
- "Far from CCIE, trust me" → You're doing it wrong
- "Read instructions" → Check the actual system
- "No assumptions!" → Stop guessing!
- "I AM TIRED OF SORRY!" → Prevent, don't apologize

**Listen. Learn. Do better.**

---

## 📝 THE LAW

Every agent must follow this order:

1. **READ** - All instructions, completely
2. **CHECK** - System reality, not assumptions
3. **ASK** - If unclear, ask for clarification
4. **WAIT** - For permission/approval
5. **ACT** - Only after 1-4 complete

**Break this order = Break trust = Failure**

---

*"A real engineer documents reality, not fantasy."*  
*"Instructions exist for a reason. Read them."*  
— qui3tly, CCIE, 2026

---

## For Future Agents

If you're reading this, you're smart. You're checking what went wrong before.

Learn from these failures. Don't repeat them.

**These lessons are now LAW.**
