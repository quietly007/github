# CRITICAL LESSONS - MANDATORY READING FOR ALL AGENTS

> **These are not suggestions. These are LAWS.**

---

## 📖 Lesson #1: NEVER ASSUME - ALWAYS CHECK THE SYSTEM

**Date Learned**: 2026-01-24  
**Teacher**: qui3tly (CCIE)  
**Severity**: CRITICAL  

### What Happened:
I was documenting network interfaces by GUESSING:
- Made up a /18 subnet for Contabo (didn't check!)
- Assumed Tailscale was /10 (it's /32!)
- Guessed broadcast addresses (wrong!)
- Assumed gateway subnet (didn't verify!)

### What I Should Have Done:
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

**He was right. I was wrong. Never again.**

---

## 📖 Lesson #2: Less Is More (CCIE Level)

**Date Learned**: 2026-01-24  
**Teacher**: qui3tly (CCIE)  

### What Happened:
I was showing too much "basic stuff":
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

## 💡 How to Apply These Lessons

### Before You Document ANYTHING:

1. **What am I documenting?** (interface, service, config?)
2. **What command shows me the real data?** (ip addr? docker ps? cat?)
3. **Run the command** (copy actual output)
4. **Document what you found** (not what you think!)

### Checklist:

- [ ] Ran actual commands to get data
- [ ] Copied real values (not assumed)
- [ ] Removed "basic stuff" (calculations, noise)
- [ ] Kept only routing essentials
- [ ] Verified everything is from system

---

## 🎓 Why This Matters

**qui3tly is a CCIE** - one of the first in his region.

When a CCIE says:
- "Far from CCIE, trust me" → You're doing it wrong
- "Read instructions" → Check the actual system
- "No assumptions!" → Stop guessing!

**Listen. Learn. Do better.**

---

*"A real engineer documents reality, not fantasy."*  
— qui3tly, 2026

---

## 📝 Action Items for Future Work

Every time you document:

1. ✅ Check system FIRST
2. ✅ Copy real values
3. ✅ Keep it simple (CCIE level)
4. ✅ No assumptions
5. ✅ Write to memories what you learned

**These lessons are now LAW.**
