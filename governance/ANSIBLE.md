# Ansible Automation

> **Last Updated**: 2026-01-23
> **UI**: https://semaphore.quietly.its.me

---

## Architecture

**Workflow**: Local changes → Git push → Ansible pull → Deploy

### Source of Truth Flow

```
Developer Workflow:
1. Edit compose files locally (Master/Lady: ~/.docker-compose/)
2. git add + commit + push to GitHub (quietly.its.me / quietly.online repos)
3. Ansible playbooks run: git pull from GitHub
4. docker compose up -d (uses files from GitHub)

NO INLINE FILE CREATION IN PLAYBOOKS!
Compose files, configs, secrets live in repos, not in playbooks.
```

| Repo | URL | Contains | Pushed From |
|------|-----|----------|-------------|
| quietly.its.me | quietly007/quietly.its.me | Master home dir (~/.docker-compose/, ~/.docker/, configs) | Master |
| quietly.online | quietly007/quietly.online | Lady home dir (~/.docker-compose/, ~/.docker/, configs) | Lady |
| ansible | quietly007/ansible | Shared playbooks (pull & deploy only) | Master |
| governance | quietly007/governance | Policies, principles (read-only on workers) | Master |
| projects | quietly007/projects | Documentation, planning | Master |

---

## Deployment Workflow

### 1. Local Development
```bash
# On Master: Edit compose file
vim ~/.docker-compose/traefik/docker-compose.yaml

# Commit and push to GitHub
git -C ~ add .docker-compose/traefik/
git -C ~ commit -m "feat: Update Traefik config"
git -C ~ push origin main
```

### 2. Ansible Deployment
```bash
# Run playbook (pulls from GitHub, deploys)
ansible-playbook -i inventory/production.ini playbooks/master/04-traefik.yml

# What the playbook does:
# 1. git pull from quietly007/quietly.its.me (gets latest compose files)
# 2. docker compose -f ~/.docker-compose/traefik/docker-compose.yaml up -d
# 3. Health checks
```

### 3. Lady Workflow (Same Pattern)
```bash
# On Lady: Edit compose file
ssh lady
vim ~/.docker-compose/mailcow/docker-compose.yaml

# Commit and push to GitHub
git -C ~ add .docker-compose/mailcow/
git -C ~ commit -m "feat: Update Mailcow config"
git -C ~ push origin main

# On Master: Run Lady playbook
ansible-playbook -i inventory/production.ini playbooks/lady/07-mailcow.yml
# Playbook pulls from quietly007/quietly.online, deploys on Lady
```

---

## Semaphore Projects

| Project | ID | Playbooks | Target |
|---------|:--:|-----------|--------|
| **Shared** | 8 | 5 | Both servers |
| **Master** | 9 | 20 | Master only |
| **Lady** | 10 | 16 | Lady only |

---

## Quick Reference

```bash
cd ~/.ansible

# Deploy shared playbook (works on both servers)
ansible-playbook -i inventory/production.ini playbooks/shared/01-bootstrap.yml

# Deploy Master service
ansible-playbook -i inventory/production.ini playbooks/master/04-traefik.yml

# Deploy Lady service
ansible-playbook -i inventory/production.ini playbooks/lady/02-traefik.yml --limit lady

# Dry-run
ansible-playbook -i inventory/production.ini playbooks/master/04-traefik.yml --check
```

## GitHub CLI Auth (required before DR/site playbooks)

Use the PAT stored on the target host:

1. Ensure token file exists: `~/.secrets/github/token`
2. Authenticate: `gh auth login --with-token < ~/.secrets/github/token`
3. Verify: `gh auth status`

## Secrets Sync (DR/test)

`playbooks/master/00-secrets.yml` will copy secrets from the controller when present:
- `~/.secrets/github/token`
- `~/.secrets/wireguard/*` (e.g., `edgerouter.txt` with raw pubkey or `PublicKey = ...`)

---

## Playbook Structure

### Shared (playbooks/shared/) - Both Servers

| Playbook | Purpose |
|----------|---------|
| 00-initial-access | First-time server access |
| 01-bootstrap | Base packages, Docker |
| 02-hardening | UFW, SSH hardening |
| fresh-install | Full server setup |
| health-check | Verify server health |

### Master (playbooks/master/) - 20 Playbooks

| Playbook | Service | Description |
|----------|---------|-------------|
| 00-secrets | Secrets | Deploy secrets |
| 02-headscale | Headscale (native) | VPN server |
| 03-tailscale | Tailscale | VPN client |
| 04-traefik | Traefik v3.6.6 | Reverse proxy with SSL |
| 05-portainer | Portainer 2.33.6 | Docker management |
| 06-monitoring | Grafana/Prometheus/Loki | Monitoring stack |
| 07-it-tools | IT-Tools | Developer utilities |
| 08-gotify | Gotify | Push notifications |
| 09-crowdsec | CrowdSec v1.6.4 | Security/IDS |
| 10-pihole | Pi-hole | DNS ad blocking |
| 12-semaphore | Semaphore | Ansible UI |
| 14-wireguard | WireGuard | P2P tunnel |
| 15-copilot | Copilot | Agent automation |
| 16-authelia | Authelia | SSO/2FA |
| 17-headscale-ui | Headscale-UI | VPN management |
| 18-fuckoff-page | Fuckoff Page | Default landing |
| 19-admin-panel | Admin Panel | Custom Flask admin |
| 20-github | GitHub | Git config |
| 21-headscale-ip-fix | Headscale IP fix | DR-only node delete + VACUUM |
| site | All services | Full deployment |
| site-dr | DR recovery | Disaster recovery |

### Lady (playbooks/lady/) - 16 Playbooks

| Playbook | Service | Description |
|----------|---------|-------------|
| 00-bootstrap | Bootstrap | Base setup |
| 00-initial-access | Access | First-time access |
| 01-hardening | Hardening | Security |
| 02-traefik | Traefik | Reverse proxy |
| 03-crowdsec | CrowdSec | Security/IDS |
| 04-portainer | Portainer Agent | Managed by Master |
| 05-monitoring-agents | Promtail/Node-exp | Monitoring |
| 06-tailscale | Tailscale | VPN client |
| 07-mailcow | Mailcow | Email server |
| 08-github | GitHub | Git config |
| 20-nextcloud | Nextcloud | Cloud storage |
| 21-unifi | UniFi | Network controller |
| 22-uisp | UISP | ISP management |
| fresh-install | Full setup | Complete install |
| health-check | Health | Verify server |
| site-lady | All services | Full Lady deployment |

---

## Playbook Design Pattern

All service playbooks follow this pattern:

```yaml
tasks:
  - name: Pull latest from GitHub
    ansible.builtin.git:
      repo: "https://github.com/quietly007/{{ repo_name }}.git"
      dest: "{{ ansible_env.HOME }}"
      version: main
      update: yes

  - name: Verify required files exist
    # Fail fast if compose/configs/secrets are missing

  - name: Start Service
    community.docker.docker_compose_v2:
      project_src: "{{ compose_dir }}/{{ service }}"
      state: present
```

**NO inline content creation** - all configs are in GitHub.

**Vars path rule:**
- All playbooks must load `vars_files` using `{{ playbook_dir }}` to avoid relative-path failures when running ad-hoc inventories or imported playbooks.

**Lint exclusions:**
- `playbooks/lady/07-mailcow.yml` is excluded from ansible-lint (managed end-to-end and already configured as required).

---

## Inventory

```ini
# ~/.ansible/inventory/production.ini
[servers]
master ansible_host=master.qui3tly.cloud ansible_port=1006
lady ansible_host=lady.qui3tly.cloud ansible_port=1006

[clients]
mac ansible_host=mac.qui3tly.cloud ansible_port=22
```

---

## File Structure

```
~/.ansible/
├── inventory/
│   ├── production.ini    # MagicDNS-based (Tailscale)
│   ├── bootstrap.ini     # Public IPs (pre-Tailscale)
│   └── fresh.ini         # Fresh server setup
├── group_vars/
│   └── all.yml           # Docker image versions, common vars
├── host_vars/
│   ├── master.yml        # Master-specific vars
│   └── lady.yml          # Lady-specific vars
└── playbooks/
    ├── shared/           # Both servers (5 playbooks)
    ├── master/           # Master only (20 playbooks)
    ├── lady/             # Lady only (16 playbooks)
    └── templates/        # Jinja2 templates
```

---

## Disaster Recovery

1. **Snapshot** VPS (< 1 minute)
2. **Ansible** to rebuild (< 5 minutes)
3. **GitHub pull** for all configs (< 1 minute)

Total recovery time: **Under 10 minutes**
