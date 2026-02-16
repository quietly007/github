# Copilot Instructions - qui3tly.cloud Infrastructure

> **Governance**: `~/.governance/` — all rules  
> **Documentation**: `~/.docs/` — all docs (00-06 categories)  
> **Last Updated**: 2026-02-16  
> **Servers**: Master (213.136.68.108) + Lady (207.180.251.111)  
> **Containers**: 64 total (25 Master + 39 Lady)

---

## BEFORE YOU ACT

1. Read `~/.governance/RULES.md` and `~/.governance/PRINCIPLES.md`
2. Read `tail -50 ~/.copilot/memories.jsonl` for recent context
3. Check data before assuming anything

**Golden Rule**: CHECK DATA FIRST. ASSUME NOTHING. READ EVERYTHING.

---

## GOVERNANCE

All rules in `~/.governance/`. Key files:

| Action | Read First |
|--------|-----------|
| Creating files | `FILE_CREATION_RULES.md` — new files go to `~/.temp/` first |
| Docker ops | `DOCKER_LAYOUT.md` |
| GitHub ops | `GITHUB_STRUCTURE_DEFINITIVE.md` |
| Secrets | `SECRETS.md` |
| SSH | `SSH_CONNECTION_PROTOCOL.md` — port 1006, pubkey only |

---

## ABOUT THE OWNER

**qui3tly**: 30-year networking veteran, one of first CCIEs in region, AS8585 operator.  
No patches — only permanent solutions. Documentation is mandatory.

---

## ARCHITECTURE FACTS

| Component | Type | Location | Don't Confuse |
|-----------|------|----------|---------------|
| Headscale | NATIVE | `/etc/headscale/` (systemd) | Not Docker |
| Tailscale | NATIVE | systemd | Not Docker |
| Cloudflare | TOKEN | Inside Traefik config | No CF container |
| EdgeRouter | WireGuard | 10.10.0.2 | Not Tailscale |

**DNS Bootstrap**: Master's `/etc/resolv.conf` is IMMUTABLE (`chattr +i`). Uses 1.1.1.1. Never touch it.

---

## NETWORK REFERENCE

| Server | Public IP | Tailscale IP | WireGuard |
|--------|-----------|--------------|-----------|
| Master | 213.136.68.108 | 100.64.0.1 | 10.10.0.1 |
| Lady | 207.180.251.111 | 100.64.0.2 | — |
| Mac | — | 100.64.0.3 | — |
| EdgeRouter | 178.20.30.40 | — | 10.10.0.2 |

- Tailscale VPN: 100.64.0.0/10
- WireGuard P2P: 10.10.0.0/30 (Master ↔ EdgeRouter)
- Home LAN: 192.168.1.0/24

DNS: Cloudflare (public) → Pi-hole + dnsmasq (internal) → Headscale MagicDNS (VPN)

---

## CRITICAL RULES

1. **Check data first** — logs, configs, status before any action
2. **No patches** — permanent fixes only (survives reboot, restart, documented)
3. **Backup before mutation** — timestamped in `~/.copilot/backups/`
4. **Ask before destruction** — delete, prune, restart = get approval
5. **Document changes** — write to `~/.copilot/memories.jsonl`
6. **File creation** — `~/.temp/` first, search for duplicates, inform user

---

## QUICK COMMANDS

```bash
# System status
docker ps --format "table {{.Names}}\t{{.Status}}"
ssh lady "docker ps --format 'table {{.Names}}\t{{.Status}}'"
tailscale status
systemctl status headscale tailscaled docker

# Logs
docker logs -f --tail 50 <container>

# Deploy
docker compose -f ~/.docker-compose/<service>/docker-compose.yaml up -d

# Ansible
cd ~/.ansible && ansible-playbook playbooks/<playbook>.yml
```

---

## SECURITY

- SSH: port 1006, key-only, fail2ban protected
- CrowdSec: 24,000+ IPs banned
- Firewall: default deny, explicit allow
- 2FA: Authelia on all public services
- HTTPS only via Traefik with security headers

---

## DOCUMENTATION STRUCTURE

```
~/.docs/
├── 00-QUICKSTART/      # Emergency procedures, quick refs
├── 01-architecture/    # Infrastructure, network, security
├── 02-operations/      # DR, monitoring, troubleshooting
├── 03-services/        # 51 service docs (all services here)
├── 04-monitoring/      # Monitoring stack docs
├── 05-security/        # Security procedures
└── 06-mail/            # Mail system docs

~/.governance/          # 16 policy files — THE LAW
~/projects/             # Symlink → ~/.github/projects/
```

---

## WEB INTERFACES

| Service | URL |
|---------|-----|
| Grafana | https://grafana.quietly.its.me |
| Prometheus | https://prometheus.quietly.its.me |
| Portainer | https://portainer.quietly.its.me |
| Mailcow | https://mail.quietly.online |

