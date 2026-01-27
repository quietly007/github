# MANDATORY CHECKLIST - BEFORE ANY SYSTEM CHANGE

**Created**: 2026-01-25 after critical failure
**Reason**: Agent violated all rules, made unauthorized production changes

---

## ⛔ STOP! READ THIS BEFORE TOUCHING ANYTHING

### Before ANY system change (config edit, container restart, file modification):

- [ ] **1. READ INSTRUCTIONS** 
  - `~/.copilot/WELCOME_NEW_AGENTS.md`
  - `~/.copilot/CRITICAL_LESSONS.md`
  - `~/.github/governance/RULES.md`
  
- [ ] **2. CHECK GOVERNANCE**
  - Is this change allowed?
  - What's the proper workflow?
  - Is GitHub involved?

- [ ] **3. ASK PERMISSION**
  - "I see [problem]. Want me to [solution]?"
  - "Should I do this via [method A] or [method B]?"
  - WAIT for answer

- [ ] **4. UNDERSTAND SCOPE**
  - Is this documentation only?
  - Is this production change?
  - Does it affect GitHub repos?

- [ ] **5. VERIFY METHOD**
  - Direct change or Ansible?
  - Does it survive reboot?
  - Is it reproducible?

### If ANY checkbox is unchecked → STOP, DON'T PROCEED

### If user says something unclear:
❌ DON'T assume what they mean
✅ ASK: "Do you mean [option A] or [option B]?"

### Examples of what needs permission:
- Restart any service
- Edit any config file
- Change container versions
- Run Ansible playbooks
- Commit to Git
- ANY production change

### Only these DON'T need permission:
- Reading files
- Checking status
- Generating reports
- Creating files in ~/.temp/

---

**This checklist exists because an agent violated ALL these rules in one action.**

**Don't be that agent.**
