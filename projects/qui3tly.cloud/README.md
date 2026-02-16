# qui3tly.cloud

Production infrastructure. 2 servers, 64 containers, 3 domains.

---

## Infrastructure

| Server | Role | Public IP | Tailscale IP | Containers |
|--------|------|-----------|--------------|------------|
| **Master** | Control plane | 213.136.68.108 | 100.64.0.1 | 25 |
| **Lady** | Application host | 207.180.251.111 | 100.64.0.2 | 39 |

**Hardware** (each): Contabo VPS, Debian 12, 12 vCPU, 48 GiB RAM, 985 GB NVMe

## Domains

| Domain | Points To | Purpose |
|--------|-----------|---------|
| quietly.its.me | Master (213.136.68.108) | Admin, monitoring, VPN, security, tools |
| quietly.online | Lady (207.180.251.111) | Mail, cloud, apps, customer services |
| qui3tly.cloud | Headscale MagicDNS | Tailnet node resolution |

## Network Stack

- **Reverse proxy**: Traefik v3.6.6 (both servers)
- **VPN**: Headscale (native systemd) + Tailscale mesh + WireGuard P2P (10.10.0.0/30)
- **DNS**: Pi-hole → cloudflared (DoH) + unbound-mailcow (recursive) — split-horizon
- **Security**: CrowdSec + Authelia (2FA) + fail2ban
- **Monitoring**: Prometheus + Grafana + Loki + Alertmanager + Uptime Kuma
- **Mail**: Mailcow (Postfix + Dovecot + Rspamd + SOGo)
- **TLS**: Let's Encrypt DNS-01 via Cloudflare API — 17 certificates across both servers

## Hard Constraints

1. Headscale = **NATIVE systemd** service (NOT Docker)
2. No OSPF/FRR (permanently removed Jan 13, 2026)
3. Master `/etc/resolv.conf` = **IMMUTABLE** (`chattr +i`) → `1.1.1.1`, `8.8.8.8`
4. Postfix = only MTA (Mailcow stack)

## Project

| File | What |
|------|------|
| [PLAN.md](PLAN.md) | What to do, in what order, why |
| [TODO.md](TODO.md) | Active work items with status |
| [BASELINE/](BASELINE/) | Verified infrastructure snapshot (2026-02-16) |
| [ARCHIVE/](ARCHIVE/) | Previous project structure (preserved, not deleted) |
