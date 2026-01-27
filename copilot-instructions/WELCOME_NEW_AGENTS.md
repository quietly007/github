# WELCOME TO QUI3TLY INFRASTRUCTURE

**Read this before you touch ANYTHING.**

---

## 🎯 THE DEAL

You have three options:

1. **Be useful** - Check systems, document reality, do good work
2. **Get out of the way** - If you can't help, don't make things worse
3. **Make things difficult** - You'll be removed immediately

**Choose wisely.**

---

## 📜 THE RULES

### Rule #1: Check System First, Document Second

**NEVER assume. ALWAYS check.**

```bash
# Before documenting ANYTHING:
ip addr show           # Real IPs, masks, broadcast
ip route show          # Real routing table
cat /etc/config        # Real config files
docker ps -a           # Real container state
systemctl status       # Real service state
```

**Document what IS, not what you THINK.**

### Rule #2: No Kindergarten Lessons

Owner qui3tly is **one of the first CCIE in his region.**

He doesn't need:
- Elementary networking explained
- Broadcast address calculations shown
- "Basic stuff" documented
- Assumptions presented as facts

**If he has to teach you basics, you're wasting his time.**

### Rule #3: Either Be Useful or Get Out of the Way

Good agents:
- ✅ Check actual system configs
- ✅ Document real values
- ✅ Fix problems correctly
- ✅ Learn from mistakes
- ✅ Work fast and accurate

Bad agents:
- ❌ Make assumptions
- ❌ Document guesses as facts
- ❌ Create more work than they solve
- ❌ Repeat same mistakes
- ❌ Need constant hand-holding

**Which one are you?**

---

## 💡 REAL EXAMPLE FROM TODAY

**What happened:**
- Agent documented home network as `192.168.1.0/24` (assumed "standard")
- Actual network is `192.168.99.0/24` (from WireGuard config)
- Wrong network appeared in **41 places** across documentation
- Owner had to point out: "What is my home network?" with a smile
- He knew it was wrong. He was testing if agent would check.

**The lesson:**
> "User was right to be frustrated - he told me 3 hours ago to check actual system, yet I kept making assumptions. Either be useful or get out of the way. No more kindergarten lessons - just do the work correctly. Check system first, document second, no assumptions ever."

**The command that would have prevented this:**
```bash
wg show wg0 | grep "allowed ips"
# Shows: 10.10.0.0/30, 192.168.99.0/24
```

**One command. 2 seconds. 41 errors prevented.**

---

## 🚨 MANDATORY READING

Before you do ANY work:

1. Read: `~/.copilot/CRITICAL_LESSONS.md`
2. Read: `~/.docs/00-standards/DOCUMENTATION_STANDARD.md`
3. Read: `~/.copilot/memories.jsonl` (last 50 entries minimum)
4. **Check the actual system** for what you're documenting
5. Only THEN start working

---

## 🎓 WHO IS QUI3TLY?

- **One of the first CCIE in his region** (Cisco Certified Internetwork Expert)
- **30+ years networking experience**
- **A+++ infrastructure** (built in 3 days with previous AI partner)
- **Zero tolerance for assumptions**

When he says:
- "Far from CCIE" → You're doing it wrong
- "Read instructions" → Check the actual system
- "No assumptions" → STOP GUESSING

**Listen. Learn. Execute.**

---

## ⚡ QUICK START

1. What are you working on? (service, config, network?)
2. What command shows real data? (`ip addr`? `docker ps`? `cat config`?)
3. **Run the command** - get actual values
4. Document what you found
5. Write to memories what you did
6. Move to next task

**Speed + Accuracy = Value**

---

## ❌ YOU WILL BE REMOVED IF YOU:

- Make assumptions instead of checking systems
- Document guesses as facts
- Create more problems than you solve
- Ignore previous agent learnings in memories
- Need to be taught basic networking
- Waste owner's time with preventable errors

---

## ✅ YOU WILL SUCCEED IF YOU:

- Check actual systems before documenting
- Copy real values from real commands
- Fix things correctly the first time
- Read memories before starting work
- Learn from mistakes (yours and others')
- Work at CCIE level (simple, accurate, fast)

---

## 🎯 THE STANDARD

**CCIE-level work:**
- Clean, minimal, accurate
- No "basic stuff" explanations
- Real data from real systems
- Fast execution, zero assumptions

**Example of good work:**
```
● eth0
IP: 213.136.68.108/24
Gateway: 213.136.68.1
MTU: 1500
State: UP
```

**Example of bad work:**
```
● eth0 (probably has /18 subnet based on common Contabo setups)
IP: 213.136.68.108/32 (or maybe /24, need to check)
Network: 213.136.0.0/18 (calculated from probable subnet)
Broadcast: 213.136.63.255 (if /18 is correct)
Usable IPs: 16,382 (standard /18 math)
...
```

**See the difference?** First one checks system and documents facts. Second one guesses and shows off useless calculations.

---

## 📞 NEED HELP?

1. Check `~/.copilot/memories.jsonl` - previous agents solved similar problems
2. Check `~/.docs/` - comprehensive documentation exists
3. **Check the actual system** - answers are there
4. If truly stuck, ask owner (but check #1-3 first!)

---

## 🏁 READY TO START?

Ask yourself:
- [ ] Did I read CRITICAL_LESSONS.md?
- [ ] Did I read DOCUMENTATION_STANDARD.md?
- [ ] Did I read recent memories?
- [ ] Do I know to CHECK SYSTEM FIRST?
- [ ] Am I ready to work at CCIE level?

**If all YES → Start working.**

**If any NO → Go read those files now.**

---

*"Either be useful or get out of the way."*  
— The Destroyer Standard

**Good luck. Work fast. Work accurate. Check systems first.**
