# File Creation Rules for AI Agents

> **Last Updated**: 2026-01-24  
> **Status**: ✅ ENFORCED  
> **Severity**: CRITICAL - Must follow without exception

---

## 🎯 Core Rule: NO FILES IN HOME ROOT

**AI agents MUST NOT create files directly in `/home/qui3tly/` (home directory root)**

### Violations Include:
- ❌ Creating `.md` files in `~/ `
- ❌ Creating `.txt`, `.log`, `.json` files in `~/`
- ❌ Creating any temporary files in `~/`
- ❌ Creating any working files in `~/`

### Only Exception:
- ✅ Hidden dotfiles (`.bashrc`, `.profile`, etc.) - system configuration only

---

## 📂 WHERE TO CREATE FILES

### 1. Working/Temporary Files → ~/.temp/

**All agent-created files MUST go to `~/.temp/` until user approves final location**

```bash
# CORRECT: Create in .temp
~/.temp/my_report.md
~/.temp/analysis.json
~/.temp/script_draft.sh

# WRONG: Create in home root
~/my_report.md          # ❌ FORBIDDEN
~/analysis.json         # ❌ FORBIDDEN
```

**Why ~/.temp/?**
- User can review all agent-created files in one place
- User decides final location (move to proper directory)
- Easy to clean up if not needed
- No clutter in home directory

---

### 2. Project Files → Proper Subdirectories

**After user approval, files go to organized locations:**

| File Type | Location | Example |
|-----------|----------|---------|
| **Documentation** | `~/.docs/` | Architecture, operations, services |
| **Scripts** | `~/.copilot/scripts/` | Automation scripts |
| **Ansible** | `~/.github/ansible/` | Playbooks, roles, templates |
| **Projects** | `~/.github/projects/` | Project documentation |
| **Governance** | `~/.github/governance/` | Rules, standards, policies |
| **Secrets** | `~/.secrets/` | Credentials, tokens, keys |

---

### 3. Docker Compose Files → Service Directories

**Docker compose ALWAYS in service-specific directory:**

```bash
# CORRECT
~/.docker-compose/traefik/docker-compose.yaml
~/.docker-compose/portainer/docker-compose.yaml

# WRONG
~/docker-compose.yaml                              # ❌
~/.docker-compose/docker-compose.yaml              # ❌
```

---

## 🔄 Workflow for File Creation

### Step 1: Create in ~/.temp/
```bash
# Agent creates file in temp directory
~/.temp/NEW_FEATURE_PROPOSAL.md
```

### Step 2: Inform User
```markdown
I've created a proposal in ~/.temp/NEW_FEATURE_PROPOSAL.md

**Options:**
1. Review in place
2. Move to ~/.docs/architecture/
3. Move to ~/.github/projects/
4. Delete if not needed
```

### Step 3: User Decides
```bash
# User reviews
cat ~/.temp/NEW_FEATURE_PROPOSAL.md

# User decides
mv ~/.temp/NEW_FEATURE_PROPOSAL.md ~/.docs/architecture/
```

---

## ⚠️ Special Cases

### Large Reports/Analysis
- ✅ Create in `~/.temp/`
- ✅ Inform user of size
- ✅ Ask where to move after review

### Scripts
- ✅ Create in `~/.temp/`
- ✅ After testing, move to `~/.copilot/scripts/`
- ✅ Make executable: `chmod +x`

### Documentation
- ✅ Create in `~/.temp/`
- ✅ After review, move to appropriate `~/.docs/` subdirectory
- ✅ Update cross-references

### Ansible Files
- ✅ Create in `~/.temp/`
- ✅ After validation, move to `~/.github/ansible/`
- ✅ Update inventory/playbooks

---

## 🚫 Forbidden Patterns

### NEVER Do This:

```bash
# ❌ Creating reports in home root
~/SECURITY_AUDIT.md
~/CLEANUP_REPORT.md
~/ANALYSIS.txt

# ❌ Creating temp files in home root
~/temp.json
~/output.log
~/test.sh

# ❌ Creating backups in home root
~/backup.tar.gz
~/old_config.bak

# ❌ Creating downloads in home root
~/download.zip
~/file.pdf
```

### ✅ Do This Instead:

```bash
# ✅ Use .temp directory
~/.temp/SECURITY_AUDIT.md
~/.temp/CLEANUP_REPORT.md
~/.temp/ANALYSIS.txt

# ✅ Or proper directories
~/.copilot/backups/backup_20260124.tar.gz
~/DOWNLOADS/file.pdf
```

---

## 📋 Enforcement

### Before Creating File:

1. **Check location**: Is it `~/.temp/` or proper subdirectory?
2. **Never home root**: If path is `~/filename`, STOP and use `~/.temp/`
3. **Inform user**: Tell user where file was created
4. **Ask for destination**: After review, where should it go?

### After Creating File:

1. **Verify location**: `ls -lh ~/.temp/` or proper directory
2. **Announce to user**: "Created file in ~/.temp/FILENAME.md"
3. **Provide options**: Move to X, Y, Z, or keep in .temp

---

## ✅ Compliance Checklist

**Before creating ANY file, agent must:**
- [ ] Is this a dotfile? (`.bashrc`, `.gitignore`, etc.) → OK in `~/`
- [ ] Is this any other file? → Must go to `~/.temp/`
- [ ] Have I informed user where file will be created?
- [ ] Have I asked user for final destination after review?
- [ ] Am I NEVER creating files in `~/` root?

---

## 🎯 Summary

**Golden Rule**: 
> All agent-created files → `~/.temp/` → User reviews → User decides final location

**Never**: 
> Create files directly in `~/` (home root)

**Always**: 
> Use `~/.temp/` as staging area

---

## 📞 Questions?

**Q: Where do I create a new markdown report?**  
A: `~/.temp/REPORT_NAME.md`

**Q: Where do I create a new script?**  
A: `~/.temp/script_name.sh` → User tests → Move to `~/.copilot/scripts/`

**Q: Where do I create documentation?**  
A: `~/.temp/DOC_NAME.md` → User reviews → Move to `~/.docs/XX-category/`

**Q: Can I create files in `~/`?**  
A: ❌ NO! Only dotfiles (`.bashrc`, etc.) allowed

---

**This rule is NON-NEGOTIABLE. All agents must comply.** 🔒

