# qui3tly.cloud

Production infrastructure. 2 servers, **63 containers** (Master 25 + Lady 38), 3 domains.

> **Current status (2026-04-23):** NO-GO provisional. 17 open findings across all severities.
> See [`perfect/DEEP_ANALYSIS_2026-04-23.md`](perfect/DEEP_ANALYSIS_2026-04-23.md) for the reconciliation.

---

## Infrastructure

| Server | Role | Public IP | Tailscale IP | Containers | Kernel |
|--------|------|-----------|--------------|------------|--------|
| **Master** | Control plane | 213.136.68.108 | 100.64.0.1 | 25 | 6.1.0-44-cloud-amd64 |
| **Lady**   | Application host | 207.180.251.111 | 100.64.0.2 | 38 | 6.1.0-44-cloud-amd64 |

**Hardware** (each): Contabo VPS, Debian 12, 12 vCPU, 48 GiB RAM, 985 GB NVMe

## Domains

| Domain | Points To | Purpose |
|--------|-----------|---------|
| `quietly.its.me` | Master (213.136.68.108) | Admin, monitoring, VPN, security, tools |
| `quietly.online` | Lady (207.180.251.111) | Mail, cloud, apps, customer services |
| `qui3tly.cloud`  | Headscale MagicDNS | Tailnet node resolution (VPN-only) |

## Network Stack

- **Reverse proxy**: Traefik v3.6.x (both servers)
- **VPN**: Headscale (native systemd) + Tailscale mesh + WireGuard P2P (10.10.0.0/30)
- **DNS**: Pi-hole (split-horizon) → cloudflared (DoH) + unbound-mailcow (recursive)
- **Security**: CrowdSec + Authelia (2FA) + fail2ban + UFW
- **Monitoring**: Prometheus + Grafana + Loki + Alertmanager + Uptime Kuma + Gotify
- **Mail**: Mailcow (Postfix + Dovecot + Rspamd + SOGo) — sole MTA
- **TLS**: Let's Encrypt DNS-01 via Cloudflare API

## Hard Constraints

1. Headscale = **NATIVE systemd** service (NOT Docker)
2. No OSPF/FRR (permanently removed 2026-01-13)
3. Master `/etc/resolv.conf` = **IMMUTABLE** (`chattr +i`) → `1.1.1.1`, `8.8.8.8`
4. Postfix (Mailcow) = only MTA
5. No rsync `--delete` between Master ↔ Lady (2026-01-27 wipe incident)

## Working folders

- **`perfect/`** — active audit & production-readiness program (all current work)
- `BASELINE/` — verified baseline snapshot (2026-02-16)
- `scripts/` — helper scripts for the above

## Archives (historical reference)

- `perfect/_archive/perfection_20260421/`  — unified program (Apr-21, superseded)
- `perfect/_archive/preproduction_20260420/` — external-audit handoff (Apr-20, superseded)
- `ARCHIVE.tar.gz` — pre-baseline artifacts (Feb-16)

---

**Governance entrypoint:** `~/.github/copilot-instructions/copilot-instructions.md`
**Policy of record:** `~/.governance/`
**Canonical documentation:** `~/.docs/`
