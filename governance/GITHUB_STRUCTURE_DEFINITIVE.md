# GitHub Structure - DEFINITIVE GUIDE

> **THIS IS THE FINAL WORD ON REPO STRUCTURE**  
> **READ THIS BEFORE ANY DR, NEW AGENT, OR GIT CONFUSION**  
> **Last Updated**: 2026-01-24  
> **Authority**: qui3tly (Owner & Founder)

---

## 🚨 THE PROBLEM STATEMENT

Every time we do Disaster Recovery or a new agent comes in, the git structure gets messed up:
- Git files scattered everywhere
- Gitignore files lost or wrong
- People can't find what repo contains what
- Confusion between shared vs personal files

**THIS DOCUMENT FIXES THAT ONCE AND FOR ALL.**

---

## 🎯 THE CORRECT STRUCTURE (Read This 3 Times)

### HIGH-LEVEL CONCEPT

**TWO types of repos:**

1. **ONE SHARED REPO** (`quietly007/github`) - Contains ALL shared content for ALL servers
2. **MULTIPLE SERVER REPOS** (`quietly007/master`, `quietly007/lady`, etc.) - One per server, contains ONLY that server's personal files

```
GitHub Organization: quietly007/
│
├── github (SHARED - all servers use this)
│   ├── governance/
│   ├── copilot-instructions/
│   ├── ansible/
│   ├── copilot-shared/
│   └── projects/
│
├── master (Master server personal files)
│   ├── .docker-compose/
│   ├── .docker/
│   ├── .docs/
│   ├── .copilot/
│   └── [.gitignore, README.md]
│
├── lady (Lady server personal files)
│   ├── .docker-compose/
│   ├── .docker/
│   ├── .copilot/
│   └── [.gitignore, README.md]
│
└── madam (Future - Madam server personal files)
    ├── .docker-compose/
    ├── .docker/
    ├── .copilot/
    └── [.gitignore, README.md]
```

---

## 📂 DETAILED STRUCTURE

### Shared Repo: `quietly007/github`

**Purpose**: All content shared across ALL servers  
**Location on disk**: `/home/qui3tly/.github/` (note the dot!)  
**Clone command**: `git clone https://github.com/quietly007/github.git ~/.github`

**Contains:**
```
.github/                           # Git repo root
├── .git/                          # Git metadata
├── .gitignore                     # Ignores runtime files
├── README.md                      # "This is the shared repo"
│
├── governance/                    # Infrastructure policies
│   ├── PRINCIPLES.md
│   ├── RULES.md
│   ├── WORKFLOWS.md
│   ├── SECRETS.md
│   ├── ENFORCEMENT.md
│   ├── CHANGELOG.md
│   ├── REPOS.md
│   ├── ANSIBLE.md
│   ├── GITHUB_LAYOUT.md
│   ├── DOCKER_LAYOUT.md
│   └── GITHUB_STRUCTURE_DEFINITIVE.md  # THIS FILE!
│
├── copilot-instructions/          # Agent directives
│   ├── copilot-instructions.md
│   └── memories-format.md
│
├── ansible/                       # Automation playbooks
│   ├── inventory/
│   │   ├── production.ini
│   │   ├── bootstrap.ini
│   │   └── fresh.ini
│   ├── playbooks/
│   │   ├── shared/                # 5 playbooks for all servers
│   │   ├── master/                # 20 playbooks for master
│   │   └── lady/                  # 16 playbooks for lady
│   ├── roles/
│   ├── group_vars/
│   └── host_vars/
│
├── copilot-shared/                # Cross-server coordination
│   ├── memories/
│   │   ├── master.jsonl
│   │   ├── lady.jsonl
│   │   └── madam.jsonl (future)
│   ├── scripts/
│   └── skills/
│
└── projects/                      # Business planning
    └── qui3tly.cloud/
        ├── README.md
        ├── RFP.md
        ├── MASTER_PLAN.md
        ├── TODO.md
        ├── plans/
        ├── reports/
        └── final-audit/
```

**On each server, this is cloned to**: `~/.github/`

**Read-only symlinks** (optional for easier access):
```bash
ln -s ~/.github/governance ~/.governance      # So agents can find it
ln -s ~/.github/ansible ~/.ansible            # So Ansible finds it
ln -s ~/.github/copilot-shared ~/.copilot-shared  # So agents find memories
ln -s ~/.github/projects ~/projects           # So user finds projects
```

---

### Server Repo: `quietly007/master`

**Purpose**: Master server's personal files ONLY  
**Location on disk**: `/home/qui3tly/` (home directory IS the repo)  
**Clone command**: `git clone https://github.com/quietly007/master.git /tmp/master && rsync -av /tmp/master/ ~/ && rm -rf /tmp/master`

**Contains:**
```
~/                                 # Git repo root (home directory)
├── .git/                          # Git metadata
├── .gitignore                     # See section below
├── README.md                      # "This is Master server personal repo"
│
├── .docker-compose/               # All compose files
│   ├── traefik/
│   ├── portainer/
│   ├── monitoring/
│   ├── crowdsec/
│   ├── pihole/
│   ├── authelia/
│   ├── headscale/
│   ├── semaphore/
│   ├── gotify/
│   └── [20+ services]
│
├── .docker/                       # Docker configs (not data!)
│   ├── traefik/traefik.yaml       # Static config
│   ├── traefik/dynamic/           # Dynamic configs
│   ├── prometheus/prometheus.yml
│   ├── grafana/provisioning/
│   ├── loki/loki-config.yml
│   ├── pihole/etc-dnsmasq.d/*.conf
│   └── [configs only, data ignored]
│
├── .docs/                         # Master-specific documentation
│   ├── architecture/
│   ├── operations/
│   ├── security/
│   ├── services/
│   ├── runbooks/
│   ├── network/
│   └── planning/
│
├── .copilot/                      # Master's personal copilot files
│   ├── memories.jsonl             # Master-only memories
│   ├── backups/
│   ├── scripts/
│   └── README.md
│
├── .secrets/                      # IGNORED - never committed
│   ├── [all secrets]
│
└── .reports/                      # IGNORED - generated reports
    └── [runtime reports]
```

**Does NOT contain:**
- ❌ `.github/` - That's the shared repo!
- ❌ Separate `.governance/`, `.ansible/`, `projects/` - Those are in shared repo!
- ❌ Docker data directories - Those are in `.gitignore`

---

### Server Repo: `quietly007/lady`

**Purpose**: Lady server's personal files ONLY  
**Location on disk**: `/home/qui3tly/` (home directory IS the repo)  
**Clone command**: `git clone https://github.com/quietly007/lady.git /tmp/lady && rsync -av /tmp/lady/ ~/ && rm -rf /tmp/lady`

**Contains:**
```
~/                                 # Git repo root (home directory)
├── .git/                          # Git metadata
├── .gitignore                     # See section below
├── README.md                      # "This is Lady server personal repo"
│
├── .docker-compose/               # Lady's compose files
│   ├── traefik/
│   ├── portainer-agent/
│   ├── monitoring/
│   ├── crowdsec/
│   ├── mailcow/                   # Lady-specific!
│   └── [Lady services]
│
├── .docker/                       # Lady's Docker configs
│   ├── traefik/
│   ├── mailcow/
│   └── [Lady configs]
│
├── .copilot/                      # Lady's personal copilot files
│   ├── memories.jsonl             # Lady-only memories
│   ├── scripts/
│   │   └── lady-dr.sh
│   └── README.md
│
├── .secrets/                      # IGNORED
│   └── [Lady secrets]
│
└── [NO .docs/ - Lady doesn't need personal docs]
```

**Does NOT contain:**
- ❌ `.github/` - That's shared!
- ❌ `.docs/` - Documentation lives on Master

---

## 🔍 THE GITIGNORE STRATEGY (CRITICAL!)

### Master's `~/.gitignore`

**Purpose**: Ignore everything that's NOT personal Master files

```gitignore
# THIS IS MASTER'S ~/.gitignore
# Master repo (quietly007/master) should ONLY contain Master personal files

# === THE SHARED REPO ===
# .github/ is a separate repo, don't track it in Master repo
.github/

# === SYMLINKS TO SHARED REPO ===
# These are symlinks to ~/.github/, don't track them
.governance/
.ansible/
.copilot-shared/
projects/

# === SECRETS - NEVER TRACK ===
.secrets/
**/secrets/
*.pem
*.key
*token*
*credential*
acme.json

# === RUNTIME DATA ===
**/data/
**/logs/
**/cache/
*.log
*.pid
*.sock
*.db

# === DOCKER RUNTIME (keep configs, ignore data) ===
.docker/**/data/
.docker/**/logs/
.docker/**/db/

# === PERSONAL/LOCAL ===
.bash_history
.bash_logout
.bashrc
.profile
.cache/
.config/
.ssh/
.gnupg/
.gitconfig

# === GENERATED/TEMP ===
.reports/
DOWNLOADS/
*.tar.gz
*.bak
*.swp

# === COPILOT RUNTIME ===
.copilot/backups/
.copilot/TEMP/
```

### Lady's `~/.gitignore`

**Purpose**: Ignore everything that's NOT personal Lady files

```gitignore
# THIS IS LADY'S ~/.gitignore  
# Lady repo (quietly007/lady) should ONLY contain Lady personal files

# === THE SHARED REPO ===
.github/

# === SYMLINKS TO SHARED REPO ===
.governance/
.ansible/
.copilot-shared/
projects/

# === SECRETS - NEVER TRACK ===
.secrets/
**/secrets/
*.pem
*.key
*token*
*credential*
acme.json

# === RUNTIME DATA ===
**/data/
**/logs/
**/cache/
*.log
*.pid
*.sock
*.db

# === DOCKER RUNTIME ===
.docker/**/data/
.docker/**/logs/
.docker/**/db/
.docker/mailcow/             # Mailcow has HUGE data dirs
.docker-compose/mailcow/mailcow.conf  # Contains secrets

# === PERSONAL/LOCAL ===
.bash_history
.bash_logout
.bashrc
.profile
.cache/
.config/
.ssh/
.gnupg/
.gitconfig

# === GENERATED/TEMP ===
DOWNLOADS/
*.tar.gz
*.bak
*.swp

# === COPILOT RUNTIME ===
.copilot/backups/
.copilot/TEMP/
```

---

## 🛠️ IMPLEMENTATION STEPS

### Phase 1: Create Shared Repo (If Doesn't Exist)

**Option A: Merge existing repos into `quietly007/github`**

```bash
# This consolidates: governance, github-config, ansible, copilot, projects
# Into ONE repo called 'github'

# 1. Create new repo on GitHub
gh repo create quietly007/github --public --description "Shared infrastructure content for all servers"

# 2. Clone it
git clone https://github.com/quietly007/github.git /tmp/github-new

# 3. Copy content from existing repos
cd /tmp/github-new
mkdir governance copilot-instructions ansible copilot-shared projects

# Copy governance
cp -r ~/.governance/* governance/

# Copy copilot instructions
cp ~/.github/copilot-instructions.md copilot-instructions/

# Copy ansible
cp -r ~/.ansible/* ansible/

# Copy copilot-shared
cp -r ~/.copilot-shared/* copilot-shared/

# Copy projects
cp -r ~/projects/* projects/

# 4. Create README
cat > README.md << 'EOF'
# quietly007/github - Shared Infrastructure

This repo contains ALL shared content for qui3tly.cloud infrastructure:
- governance/ - Infrastructure policies
- copilot-instructions/ - Agent directives
- ansible/ - Automation playbooks
- copilot-shared/ - Cross-server memories
- projects/ - Business planning

Clone to: ~/.github/ on all servers
EOF

# 5. Create .gitignore
cat > .gitignore << 'EOF'
# Ignore runtime Ansible files
ansible/**/*.retry
ansible/.ansible/

# Ignore copilot runtime
copilot-shared/temp/
copilot-shared/backups/

# Ignore project temp files
projects/**/node_modules/
EOF

# 6. Commit and push
git add -A
git commit -m "Initial shared repo - consolidates governance, ansible, copilot, projects"
git push origin main
```

**Option B: Use existing `quietly007/github-config` and rename**

```bash
# Rename repo
gh repo rename quietly007/github-config github

# Then follow steps 2-6 above to populate
```

### Phase 2: Migrate Master

```bash
# ON MASTER

# 1. Backup current state
cd ~
tar -czf /tmp/master-backup-$(date +%Y%m%d).tar.gz .docker-compose .docker .docs .copilot

# 2. Clean up old structure
rm -rf ~/.governance ~/.ansible ~/projects   # These will become symlinks
mv ~/.github ~/.github.old                    # Backup old github-config

# 3. Clone new shared repo
git clone https://github.com/quietly007/github.git ~/.github

# 4. Create symlinks for easier access
ln -s ~/.github/governance ~/.governance
ln -s ~/.github/ansible ~/.ansible  
ln -s ~/.github/copilot-shared ~/.copilot-shared
ln -s ~/.github/projects ~/projects

# 5. Update home repo remote (if needed)
cd ~
git remote -v
# If it's currently quietly.its.me, rename that repo to 'master'
# gh repo rename quietly007/quietly.its.me master

# Or change remote
git remote set-url origin https://github.com/quietly007/master.git

# 6. Update .gitignore
cat > ~/.gitignore << 'EOF'
[Use the Master .gitignore from above section]
EOF

# 7. Verify what will be committed
git status

# Should show:
# - .docker-compose/ (tracked)
# - .docker/ configs (tracked)
# - .docs/ (tracked)
# - .copilot/ (tracked)
# - .github/ (ignored - separate repo)
# - .governance, .ansible, projects (ignored - symlinks)

# 8. Commit and push
git add -A
git commit -m "Migrate to new structure: personal Master files only"
git push origin main
```

### Phase 3: Migrate Lady

```bash
# ON LADY (via SSH)

ssh lady

# 1. Backup
cd ~
tar -czf /tmp/lady-backup-$(date +%Y%m%d).tar.gz .docker-compose .docker .copilot

# 2. Clean up old structure  
rm -rf ~/.governance ~/.ansible ~/projects ~/.github

# 3. Clone shared repo
git clone https://github.com/quietly007/github.git ~/.github

# 4. Create symlinks
ln -s ~/.github/governance ~/.governance
ln -s ~/.github/ansible ~/.ansible
ln -s ~/.github/copilot-shared ~/.copilot-shared  
ln -s ~/.github/projects ~/projects

# 5. Update home repo remote
cd ~
git remote set-url origin https://github.com/quietly007/lady.git
# Or: gh repo rename quietly007/quietly.online lady

# 6. Update .gitignore
cat > ~/.gitignore << 'EOF'
[Use the Lady .gitignore from above section]
EOF

# 7. Verify
git status

# 8. Commit and push
git add -A
git commit -m "Migrate to new structure: personal Lady files only"
git push origin main
```

### Phase 4: Update Documentation

```bash
# Update all docs that reference old structure
# Update Ansible playbooks
# Update DR scripts
# Update Copilot instructions
```

---

## 🔄 DAILY WORKFLOW

### Making Changes to Shared Content

```bash
# On Master (only Master pushes to shared repo)

# Example: Update governance policy
cd ~/.github
# or: cd ~/.governance (same directory via symlink)

git pull origin main
# ... edit files ...
git add -A
git commit -m "Update governance policy"
git push origin main

# Sync to Lady
ssh lady "cd ~/.github && git pull origin main"
```

### Making Changes to Master Personal Files

```bash
# On Master

cd ~  # Home directory
# ... edit .docker-compose files, .docs, etc ...
git add -A
git commit -m "Update Master traefik config"
git push origin main
```

### Making Changes to Lady Personal Files

```bash
# On Lady

cd ~  # Home directory
# ... edit .docker-compose files, .copilot scripts, etc ...
git add -A
git commit -m "Update Lady DR script"
git push origin main
```

---

## 📋 DISASTER RECOVERY PROCESS

### Fresh Master Deployment

```bash
# 1. Bootstrap fresh Debian server
# 2. Install git
sudo apt update && sudo apt install -y git gh

# 3. Clone personal Master repo
git clone https://github.com/quietly007/master.git /tmp/master
rsync -av /tmp/master/ ~/
rm -rf /tmp/master
cd ~

# 4. Clone shared repo
git clone https://github.com/quietly007/github.git ~/.github

# 5. Create symlinks
ln -s ~/.github/governance ~/.governance
ln -s ~/.github/ansible ~/.ansible
ln -s ~/.github/copilot-shared ~/.copilot-shared
ln -s ~/.github/projects ~/projects

# 6. Restore secrets (from backup)
# ... copy .secrets/ from secure backup ...

# 7. Deploy services
cd ~/.docker-compose/traefik && docker compose up -d
# ... continue with other services ...
```

### Fresh Lady Deployment

```bash
# Same process but:
# - Clone quietly007/lady instead of master
# - No .docs/ to worry about
# - Different services
```

---

## ❓ COMMON QUESTIONS

### Q: Why not keep separate repos for governance, ansible, etc.?

**A**: Because it creates confusion. Every DR, every new agent, everyone asks "where is ansible?" Having ONE shared repo means ONE place to look. Simple.

### Q: What if I'm working on Lady and need to update governance?

**A**: You DON'T. Only Master pushes to shared repo. Lady pulls changes. Master is the single source of truth.

### Q: Where do I find my memories?

**A**:
- **Personal memories**: `~/.copilot/memories.jsonl` (your server only)
- **Shared memories**: `~/.copilot-shared/memories/master.jsonl` or `lady.jsonl` (cross-server awareness)

### Q: What if symlinks break?

**A**: Recreate them:
```bash
ln -sf ~/.github/governance ~/.governance
ln -sf ~/.github/ansible ~/.ansible
ln -sf ~/.github/copilot-shared ~/.copilot-shared
ln -sf ~/.github/projects ~/projects
```

### Q: Can I still access files without symlinks?

**A**: Yes! Everything is in `~/.github/`. The symlinks are just for convenience.

---

## 🚫 ANTI-PATTERNS (Don't Do This!)

❌ **Don't clone governance to a separate directory**  
✅ It's in `~/.github/governance/` or use symlink `~/.governance`

❌ **Don't have separate repos for governance, ansible, projects**  
✅ They're all in `quietly007/github` repo

❌ **Don't track `.github/` in your home repo**  
✅ It's in `.gitignore` because it's a separate repo

❌ **Don't put Lady's files in Master's repo**  
✅ Each server has its own repo

❌ **Don't track secrets in any repo**  
✅ Everything in `.secrets/` is gitignored

---

## 📊 VERIFICATION CHECKLIST

**On Master:**
- [ ] `~/.github/` exists and is a git repo pointing to `quietly007/github`
- [ ] `~/` is a git repo pointing to `quietly007/master`
- [ ] `~/.governance` is a symlink to `~/.github/governance/`
- [ ] `~/.ansible` is a symlink to `~/.github/ansible/`
- [ ] `~/.copilot-shared` is a symlink to `~/.github/copilot-shared/`
- [ ] `~/projects` is a symlink to `~/.github/projects/`
- [ ] `git status` in `~/.github/` is clean
- [ ] `git status` in `~/` shows only personal files
- [ ] `.github/` is in `~/.gitignore`

**On Lady:**
- [ ] `~/.github/` exists and is a git repo pointing to `quietly007/github`
- [ ] `~/` is a git repo pointing to `quietly007/lady`
- [ ] Same symlinks as Master
- [ ] `git status` in `~/.github/` is clean (read-only, should be clean)
- [ ] `git status` in `~/` shows only Lady personal files
- [ ] `.github/` is in `~/.gitignore`

**Commands to verify:**
```bash
# On both servers
cd ~/.github && git remote -v    # Should show: quietly007/github
cd ~ && git remote -v             # Master: quietly007/master, Lady: quietly007/lady
ls -la ~ | grep '^l'              # Should show symlinks: .governance, .ansible, etc.
cd ~ && git status --ignored      # Should show .github/ as ignored
```

---

## 🎓 FOR NEW AGENTS / DR SITUATIONS

**READ THIS FIRST BEFORE DOING ANYTHING WITH GIT:**

1. There are TWO repos on each server:
   - `~/.github/` = Shared content (same on all servers)
   - `~/` = Personal content (different per server)

2. The shared repo is called `quietly007/github`

3. Personal repos are `quietly007/master`, `quietly007/lady`, etc.

4. Use symlinks for convenience:
   - `~/.governance` → `~/.github/governance/`
   - `~/.ansible` → `~/.github/ansible/`
   - etc.

5. Only Master pushes to shared repo. Lady pulls only.

6. Each server pushes to its own personal repo.

7. Check `.gitignore` - it should ignore `.github/` and the symlinks.

**If confused, run these commands:**
```bash
# See repos
cd ~/.github && git remote -v
cd ~ && git remote -v

# See symlinks  
ls -la ~ | grep '^l'

# Verify gitignore
cat ~/.gitignore | grep -A 3 "SHARED REPO"
```

---

## 📞 EMERGENCY CONTACT

If this structure is wrong or confusing: **STOP**.

Don't make changes. Don't push anything.

Read this document again. All answers are here.

---

**Last Updated**: 2026-01-24  
**Next Review**: After first successful DR with this structure  
**Document Location**: `~/.github/governance/GITHUB_STRUCTURE_DEFINITIVE.md`

---

*This is the FINAL WORD on repo structure. No more confusion. No more lost git files.*
