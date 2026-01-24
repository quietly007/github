# GitHub Repositories

> **Last Updated**: 2026-01-24
> **Total Repos**: 7

---

## Repository Architecture

```
quietly007/                           # GitHub Account
├── quietly.its.me  ─────────────────→ Master: ~/
├── quietly.online  ─────────────────→ Lady: ~/
├── ansible         ─────────────────→ Both: ~/.ansible/
├── governance      ─────────────────→ Both: ~/.governance/ (read-only on Lady)
├── github-config   ─────────────────→ Both: ~/.github/
├── projects        ─────────────────→ Both: ~/projects/ (read-only on Lady)
└── copilot         ─────────────────→ Both: ~/.copilot-shared/ (SHARED MEMORIES)
```

---

## Repositories

### 1. quietly.its.me (Master Home)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/quietly.its.me |
| Local Path | Master: `~/` (home IS the repo) |
| Purpose | Master server home directory - configs, compose files, scripts |
| Push From | Master only |

**Contains:**
- `.docker-compose/` - All Docker Compose files
- `.docker/` - Docker configs and data
- `.docs/` - Documentation
- `.copilot/` - Agent scripts, memories, backups
- `.secrets/` (gitignored) - Sensitive data

---

### 2. quietly.online (Lady Home)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/quietly.online |
| Local Path | Lady: `~/` (home IS the repo) |
| Purpose | Lady-specific configs only |
| Push From | Lady (or Master via SSH) |

**Contains:**
- `.docker-compose/` - Lady's Docker Compose files
- `.docker/` - Lady's Docker configs
- `.copilot/` - Lady-specific scripts (lady-dr.sh, etc.)

---

### 3. ansible (Shared Playbooks)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/ansible |
| Local Path | Both: `~/.ansible/` |
| Purpose | Ansible playbooks, inventories, roles |
| Push From | Master only |

**Structure:**
```
playbooks/
├── shared/     # 5 playbooks - both servers
├── master/     # 20 playbooks - master only
└── lady/       # 16 playbooks - lady only
inventory/
├── production.ini  # MagicDNS (Tailscale)
├── bootstrap.ini   # Public IPs (pre-Tailscale)
└── fresh.ini       # Fresh server setup
```

---

### 4. governance (Policies)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/governance |
| Local Path | Both: `~/.governance/` |
| Purpose | Infrastructure policies and rules |
| Push From | Master only |
| Lady Access | **Read-only** (clone, git pull) |

**Contains:**
- `PRINCIPLES.md` - Core principles
- `RULES.md` - Operational rules
- `WORKFLOWS.md` - Standard procedures
- `SECRETS.md` - Secrets handling
- `ENFORCEMENT.md` - Enforcement policies

---

### 5. github-config (Copilot Instructions)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/github-config |
| Local Path | Both: `~/.github/` |
| Purpose | Shared Copilot instructions |
| Push From | Master only |

**Contains:**
- `copilot-instructions.md` - Agent directives

---

### 6. projects (Business Docs)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/projects |
| Local Path | Both: `~/projects/` |
| Purpose | Business planning and documentation |
| Push From | Master only |
| Lady Access | **Read-only** |

**Contains:**
- `qui3tly.cloud/` - Business project
  - `README.md`, `RFP.md`
  - `plans/`, `reports/`, `todo/`

---

### 7. copilot (Shared Memories)
| Property | Value |
|----------|-------|
| URL | https://github.com/quietly007/copilot |
| Local Path | Both: `~/.copilot-shared/` |
| Purpose | Cross-server agent coordination and memories |
| Push From | Master only |
| Lady Access | **Read-only** |

**Contains:**
- `memories/master.jsonl` - Master server agent memories
- `memories/lady.jsonl` - Lady server agent memories
- `scripts/` - Shared agent scripts
- `skills/` - Shared agent skills/prompts

**Note:** Each server also has local `~/.copilot/` for backups and temp files.

---

## Access Matrix

| Repo | Master | Lady |
|------|--------|------|
| quietly.its.me | Read/Write | - |
| quietly.online | - | Read/Write |
| ansible | Read/Write | **Read-only** |
| governance | Read/Write | **Read-only** |
| github-config | Read/Write | **Read-only** |
| projects | Read/Write | **Read-only** |
| copilot | Read/Write | **Read-only** |

---

## Keeping Lady Synced

Lady has read-only clones of shared repos. To update:

```bash
# On Lady - pull latest from GitHub
ssh lady "cd ~/.ansible && git pull"
ssh lady "cd ~/.governance && git pull"
ssh lady "cd ~/.github && git pull"
ssh lady "cd ~/projects && git pull"
```

Or use the sync script:
```bash
~/.copilot/scripts/sync-repos.sh lady
```

---

## Git Workflow

### Master (Push Source)
```bash
# Make changes locally
cd ~/.ansible
# ... edit files ...
git add -A
git commit -m "Description of change"
git push origin main
```

### Lady (Read-Only)
```bash
# Pull latest changes
cd ~/.ansible
git pull origin main
```

---

*Documentation lives on Master. Lady reads from shared repos.*
