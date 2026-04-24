# INFRASTRUCTURE BASELINE
## qui3tly.cloud Complete Inventory

> **Rule #0**: NEVER ASSUME — ALWAYS CHECK THE SYSTEM  
> **Audit Date**: February 16, 2026  
> **Source**: Live `docker ps`, `ip addr`, `df -h`, `free -h`, `iptables`, `fail2ban-client` — zero guesswork  
> **Verification**: Every entry below was pulled from a running system, not copied from old docs  
> **Previous Version**: [ARCHIVE/2026-02-16-REBOOT/INFRASTRUCTURE_BASELINE-old.md](../ARCHIVE/2026-02-16-REBOOT/INFRASTRUCTURE_BASELINE-old.md) — had 4 phantom containers on Master, wrong Lady container names, wrong storage sizes

---

## 1. EXECUTIVE SUMMARY

```
┌──────────────────────────────────────────────────────────┐
│  qui3tly.cloud — Infrastructure State: 2026-02-16 03:00  │
├──────────────────────────────────────────────────────────┤
│  Servers:      2 VPS (Master, Lady) + 1 client (Mac)     │
│  Containers:   64 (25 Master + 39 Lady)                  │
│  Unhealthy:    0                                         │
│  Native svcs:  1 (Headscale on Master, systemd)          │
│  Provider:     Contabo VPS M, Germany                    │
│  OS:           Debian 12 (bookworm) — BOTH servers       │
│  Kernel:       6.1.0-43-cloud-amd64 (Master)             │
│                6.1.0-42-cloud-amd64 (Lady)               │
│  Uptime:       5+ days (last maintenance: Feb 11)        │
│  Errors:       0 real errors (both servers, last 2h)     │
└──────────────────────────────────────────────────────────┘
```

---

## 2. HARDWARE SPECIFICATION

Both servers are identical Contabo VPS M instances.

```
╔══════════════════════════════════════════════════════════════════╗
║  CONTABO VPS M — HARDWARE SPECIFICATIONS                       ║
╠══════════════════════════════════════════════════════════════════╣
║  CPU:     12 vCPU (AMD EPYC)                                   ║
║  RAM:     48 GiB (47Gi usable)                                 ║
║  Disk:    985 GB NVMe SSD (/dev/sda1, ext4)                    ║
║  Network: 1 Gbps shared, 32 TB/month traffic                   ║
║  IPv4:    1 dedicated per server (/32)                         ║
║  IPv6:    Not deployed (deferred)                              ║
╚══════════════════════════════════════════════════════════════════╝
```

| Metric | Master | Lady |
|--------|--------|------|
| **Disk used** | 21 GB (3%) | 59 GB (7%) |
| **Disk free** | 924 GB | 886 GB |
| **RAM used** | 6.0 GiB (13%) | 9.7 GiB (21%) |
| **RAM free** | 41 GiB | 37 GiB |
| **Load** | Low | Low |

---

## 3. MASTER SERVER INVENTORY

```
╔═══════════════════════════════════════════════╗
║  MASTER — quietly.its.me                     ║
║  Public IP:    213.136.68.108                ║
║  Tailscale IP: 100.64.0.1                   ║
║  WireGuard IP: 10.10.0.1 (P2P to home)      ║
║  Role:         Control plane + monitoring    ║
║  Containers:   25 running, 0 unhealthy       ║
╚═══════════════════════════════════════════════╝
```

### 3.1 Master Containers (25)

| # | Container | Image | Port Bindings | Status |
|---|-----------|-------|---------------|--------|
| 1 | admin-panel | python:3.11-slim | — | Up 2d (healthy) |
| 2 | alertmanager | prom/alertmanager:v0.27.0 | 9093/tcp | Up 5d (healthy) |
| 3 | authelia | authelia/authelia:4.39.15 | 9091/tcp | Up 5d (healthy) |
| 4 | blackbox | prom/blackbox-exporter:v0.28.0 | 0.0.0.0:9115→9115/tcp | Up 4d (healthy) |
| 5 | bouncer-traefik | fbonalair/traefik-crowdsec-bouncer:0.5.0 | — | Up 4d (healthy) |
| 6 | cadvisor | gcr.io/cadvisor/cadvisor:v0.52.1 | 8080/tcp | Up 23m (healthy) |
| 7 | cloudflared | cloudflare/cloudflared:2024.12.2 | — | Up 3d |
| 8 | crowdsec | crowdsecurity/crowdsec:v1.6.8 | — | Up 24m (healthy) |
| 9 | default-landing | nginx:1.27-alpine | 80/tcp | Up 3d |
| 10 | fuckoff-page | nginx:1.27-alpine | 80/tcp | Up 3d (healthy) |
| 11 | gotify | gotify/server:2.5.0 | 80/tcp | Up 5d (healthy) |
| 12 | grafana | grafana/grafana:11.4.0 | 3000/tcp | Up 7h (healthy) |
| 13 | headscale-admin | goodieshq/headscale-admin:0.26.0 | 80, 443, 2019/tcp, 443/udp | Up 3d |
| 14 | headscale-ui | ghcr.io/gurucomputing/headscale-ui:2025.08.23 | 443/tcp | Up 3d |
| 15 | it-tools | corentinth/it-tools:2024.10.22-7ca5933 | 80/tcp | Up 5d |
| 16 | loki | grafana/loki:3.3.2 | 100.64.0.1:3100→3100/tcp | Up 5d (healthy) |
| 17 | node-exporter | prom/node-exporter:v1.9.0 | 9100/tcp | Up 5d |
| 18 | ntfy | binwiederhier/ntfy:v2.16.0 | 80/tcp | Up 5d (healthy) |
| 19 | pihole | pihole/pihole:2025.11.1 | 10.10.0.1:53, 100.64.0.1:53, 127.0.0.1:8053→80 | Up 3d (healthy) |
| 20 | portainer | portainer/portainer-ce:2.33.6 | 127.0.0.1:9000→9000, 127.0.0.1:9443→9443 | Up 5d |
| 21 | prometheus | prom/prometheus:v2.54.1 | 9090/tcp | Up 5h (healthy) |
| 22 | promtail | grafana/promtail:3.4.2 | — | Up 5d |
| 23 | semaphore | semaphoreui/semaphore:v2.10.22 | — | Up 5d (healthy) |
| 24 | traefik | traefik:v3.6.6 | 0.0.0.0:80→80, 0.0.0.0:443→443, 127.0.0.1:8080→8080 | Up 3d (healthy) |
| 25 | uptime-kuma | louislam/uptime-kuma (f48d816cb746) | 3001/tcp | Up 5d (healthy) |

### 3.2 Master Native Services

| Service | Type | Version | Function | Status |
|---------|------|---------|----------|--------|
| headscale | systemd | v0.27.1 | Tailscale control plane | active (running) |
| fail2ban | systemd | — | IP blocking (3 jails) | active (running) |

**Why Headscale is native**: Avoids Docker networking complexity for VPN control plane.  
Containerizing Headscale creates circular dependencies with Tailscale networking.

### 3.3 Master Docker Networks

| Network | Driver | Purpose |
|---------|--------|---------|
| traefik | bridge | Reverse proxy interconnect |
| monitoring | bridge | Prometheus, Grafana, Loki, exporters |
| pihole_internal | bridge | DNS isolation |

### 3.4 Master Port Security

**Externally reachable** (0.0.0.0 bindings):
- 80/tcp → traefik (HTTP, redirects to HTTPS)
- 443/tcp → traefik (HTTPS, all services)
- 9115/tcp → blackbox-exporter

**VPN-only** (100.64.0.1 or 10.10.0.1 bindings):
- 3100/tcp → loki (Tailscale only)
- 53/tcp+udp → pihole (Tailscale + WireGuard)

**Localhost-only** (127.0.0.1 bindings):
- 9000/tcp → portainer
- 9443/tcp → portainer (HTTPS)
- 8080/tcp → traefik dashboard
- 8053/tcp → pihole web UI

---

## 4. LADY SERVER INVENTORY

```
╔═══════════════════════════════════════════════╗
║  LADY — quietly.online                       ║
║  Public IP:    207.180.251.111               ║
║  Tailscale IP: 100.64.0.2                   ║
║  Role:         Applications + mail           ║
║  Containers:   39 running, 0 unhealthy       ║
╚═══════════════════════════════════════════════╝
```

### 4.1 Lady Mailcow Stack (18 containers)

All containers prefixed `mailcowdockerized-*-1` in Docker.

| # | Service | Image | Key Ports | Status |
|---|---------|-------|-----------|--------|
| 1 | postfix-mailcow | ghcr.io/mailcow/postfix:3.7.11 | 0.0.0.0:25, 0.0.0.0:465, 0.0.0.0:587 | Up 5d |
| 2 | dovecot-mailcow | ghcr.io/mailcow/dovecot:2.3.21.1 | 0.0.0.0:993, 0.0.0.0:995, 127.0.0.1:143 | Up 5d |
| 3 | sogo-mailcow | ghcr.io/mailcow/sogo:5.12.4 | — | Up 5d |
| 4 | rspamd-mailcow | ghcr.io/mailcow/rspamd:2.4 | — | Up 44h |
| 5 | redis-mailcow | redis:7.4.6-alpine | 127.0.0.1:7654→6379 | Up 5d |
| 6 | mysql-mailcow | mariadb:10.11 | 127.0.0.1:13306→3306 | Up 5d |
| 7 | memcached-mailcow | memcached:alpine | 11211/tcp | Up 5d |
| 8 | clamd-mailcow | ghcr.io/mailcow/clamd:1.71 | — | Up 5d (healthy) |
| 9 | olefy-mailcow | ghcr.io/mailcow/olefy:1.15 | — | Up 5d |
| 10 | watchdog-mailcow | ghcr.io/mailcow/watchdog:2.09 | — | Up 5d |
| 11 | acme-mailcow | ghcr.io/mailcow/acme:1.94 | — | Up 5d |
| 12 | nginx-mailcow | ghcr.io/mailcow/nginx:1.05 | 80/tcp, 127.0.0.1:8843, 127.0.0.1:8880 | Up 5d |
| 13 | netfilter-mailcow | ghcr.io/mailcow/netfilter:1.63 | — | Up 5d |
| 14 | dockerapi-mailcow | ghcr.io/mailcow/dockerapi:2.11 | — | Up 3d |
| 15 | unbound-mailcow | ghcr.io/mailcow/unbound:1.24 | 53/tcp+udp | Up 5d (healthy) |
| 16 | ofelia-mailcow | mcuadros/ofelia:0.3.20 | — | Up 5d |
| 17 | php-fpm-mailcow | ghcr.io/mailcow/phpfpm:8.2.29 | 9000/tcp | Up 5d |
| 18 | postfix-tlspol-mailcow | ghcr.io/mailcow/postfix-tlspol:1.8.22 | — | Up 5d |

**Note**: Old baseline listed `solr-mailcow` and `ipsec-mailcow` — these do NOT exist.  
Old baseline was missing `php-fpm-mailcow` and `postfix-tlspol-mailcow`.

### 4.2 Lady Application Stack (21 containers)

| # | Container | Image | Key Ports | Status |
|---|-----------|-------|-----------|--------|
| 19 | traefik | traefik:v3.6.6 | 0.0.0.0:80→80, 0.0.0.0:443→443, 127.0.0.1:8080, 100.64.0.2:8082 | Up 3d |
| 20 | bouncer-traefik | fbonalair/traefik-crowdsec-bouncer:0.5.0 | — | Up 3d (healthy) |
| 21 | crowdsec | crowdsecurity/crowdsec:v1.6.8 | — | Up 24m (healthy) |
| 22 | fuckoff-page | nginx:1.27-alpine | 80/tcp | Up 3d (healthy) |
| 23 | nextcloud | lscr.io/linuxserver/nextcloud:29.0.7 | 80, 443/tcp | Up 2d (healthy) |
| 24 | nextcloud-db | lscr.io/linuxserver/mariadb:10.11.8 | 3306/tcp | Up 2d (healthy) |
| 25 | nextcloud-redis | redis:7.4-alpine | 6379/tcp | Up 2d (healthy) |
| 26 | onlyoffice-documentserver | onlyoffice/documentserver:8.2.0 | 80, 443/tcp | Up 2d |
| 27 | odoo | odoo:17.0 | 8069, 8071-8072/tcp | Up 3d (healthy) |
| 28 | odoo-db | postgres:16-alpine | 5432/tcp | Up 5h (healthy) |
| 29 | unifi | lscr.io/linuxserver/unifi-network-application:8.6.9 | 8080, 8443, 0.0.0.0:3478/udp, 0.0.0.0:10001/udp, 0.0.0.0:6789 | Up 3d |
| 30 | unifi-db | mongo:7.0 | 27017/tcp | Up 3d (healthy) |
| 31 | uisp | nico640/docker-unms:latest | 80, 443/tcp, 2055/udp | Up 5h |
| 32 | homeassistant | lscr.io/linuxserver/homeassistant:2024.12.5 | 8123/tcp | Up 5d |
| 33 | frigate | ghcr.io/blakeblackshear/frigate:stable | 0.0.0.0:5000, 0.0.0.0:8554-8555 | Up 2d (healthy) |
| 34 | mta-sts | nginx:1.27-alpine | 80/tcp | Up 5d |
| 35 | mysqld-exporter | prom/mysqld-exporter:latest | 0.0.0.0:9104→9104 | Up 5d |
| 36 | node-exporter | prom/node-exporter:v1.9.0 | 100.64.0.2:9100→9100 | Up 5d |
| 37 | cadvisor | gcr.io/cadvisor/cadvisor:v0.52.1 | 100.64.0.2:8081→8080 | Up 5d (healthy) |
| 38 | promtail | grafana/promtail:3.4.2 | — | Up 5d |
| 39 | portainer-agent | portainer/agent:2.24.1 | 100.64.0.2:9001→9001 | Up 5d |

**Note**: Old baseline listed `fail2ban`, `uisp-postgres`, `onlyoffice-postgres` as containers — NONE of these exist.  
Old baseline had rows 35-39 as vague "(5 support containers)".  
Old baseline listed `odoo-postgres` — actual name is `odoo-db`.

### 4.3 Lady Native Services

| Service | Type | Version | Function | Status |
|---------|------|---------|----------|--------|
| fail2ban | systemd | — | IP blocking (3 jails) | active (running) |

### 4.4 Lady Docker Networks

| Network | Driver | Purpose |
|---------|--------|---------|
| traefik | bridge | Reverse proxy interconnect |
| monitoring | bridge | Exporters, promtail |
| mailcowdockerized_mailcow-network | bridge | Mailcow stack isolation |
| nextcloud_nextcloud | bridge | Nextcloud + DB + Redis |
| odoo-internal | bridge | Odoo + PostgreSQL |
| unifi_unifi | bridge | UniFi + MongoDB |
| portainer-agent_default | bridge | Portainer agent |

### 4.5 Lady Port Security

**Externally reachable** (0.0.0.0 bindings):
- 80/tcp → traefik (HTTP)
- 443/tcp → traefik (HTTPS)
- 25/tcp → postfix (SMTP)
- 465/tcp → postfix (SMTPS)
- 587/tcp → postfix (submission)
- 993/tcp → dovecot (IMAPS)
- 995/tcp → dovecot (POP3S)
- 3478/udp → unifi (STUN)
- 5000/tcp → frigate (web UI)
- 6789/tcp → unifi (speed test)
- 8554-8555/tcp → frigate (RTSP)
- 9104/tcp → mysqld-exporter
- 10001/udp → unifi (AP discovery)

**VPN-only** (100.64.0.2 bindings):
- 8081/tcp → cadvisor
- 8082/tcp → traefik metrics
- 9001/tcp → portainer-agent
- 9100/tcp → node-exporter

**Localhost-only** (127.0.0.1 bindings):
- 8080/tcp → traefik dashboard
- 143/tcp → dovecot (IMAP unencrypted)
- 110/tcp → dovecot (POP3 unencrypted)
- 13306/tcp → mailcow MariaDB
- 7654/tcp → mailcow Redis
- 8843/tcp → mailcow nginx
- 8880/tcp → mailcow nginx

---

## 5. MAC CLIENT

```
╔═══════════════════════════════════════════════╗
║  MAC — mac.qui3tly.cloud                     ║
║  LAN IP:       192.168.99.x (DHCP)          ║
║  Tailscale IP: 100.64.0.3                   ║
║  Role:         Client / development          ║
║  Containers:   0                             ║
╚═══════════════════════════════════════════════╝
```

Hardware: Mac Mini. Connects to Master/Lady via Tailscale mesh and to home LAN via EdgeRouter.

---

## 6. NETWORK INVENTORY

### 6.1 Public IPs

| Server | IPv4 | Provider | Gateway |
|--------|------|----------|---------|
| Master | 213.136.68.108/32 | Contabo Germany | 213.136.68.1 |
| Lady | 207.180.251.111/32 | Contabo Germany | 207.180.251.1 |

### 6.2 VPN Networks

**Tailscale Mesh** (100.64.0.0/10, MTU 1280, WireGuard encrypted):

| Node | Tailscale IP | Role |
|------|-------------|------|
| Master | 100.64.0.1 | Control plane (Headscale) |
| Lady | 100.64.0.2 | Application host |
| Mac | 100.64.0.3 | Client |

**WireGuard P2P** (10.10.0.0/30, MTU 1420, port 51820/udp):

| Peer | WireGuard IP | Location |
|------|-------------|----------|
| Master | 10.10.0.1 | Contabo (server end) |
| EdgeRouter | 10.10.0.2 | Home (client end) |

Routes via WireGuard: `192.168.99.0/24` (home LAN) routed through `10.10.0.2`.

### 6.3 DNS Architecture

```
┌─────────────────────────────────────────────────┐
│  DNS RESOLUTION — SPLIT-HORIZON                 │
├─────────────────────────────────────────────────┤
│  Internet → Cloudflare (1.1.1.1)               │
│  Master boot → 1.1.1.1 (IMMUTABLE resolv.conf) │
│  Lady → MagicDNS (100.100.100.100 via Headscale)│
│  VPN clients → Pi-hole (100.64.0.1:53)         │
│  Home LAN → Pi-hole (10.10.0.1:53 via WireGuard)│
│  Mailcow → unbound-mailcow (recursive, local)   │
├─────────────────────────────────────────────────┤
│  CRITICAL: Master /etc/resolv.conf is chattr +i │
│  NEVER set Master DNS to 100.100.100.100        │
│  (causes boot crash loop — Headscale ↔ DNS)     │
└─────────────────────────────────────────────────┘
```

### 6.4 Domains

| Domain | Points To | Purpose |
|--------|-----------|---------|
| quietly.its.me | 213.136.68.108 (Master) | Admin, monitoring, security, tools |
| quietly.online | 207.180.251.111 (Lady) | Mail, cloud, apps, customers |
| qui3tly.cloud | Headscale MagicDNS | Tailnet node resolution |

### 6.5 TLS Certificates

17 certificates across both servers, all Let's Encrypt, auto-renewed:
- Master: Traefik ACME (DNS-01 via Cloudflare API) — wildcard `*.quietly.its.me`
- Lady: Traefik ACME + Mailcow ACME — `mail.quietly.online` + service certs

---

## 7. STORAGE INVENTORY

### 7.1 Actual Usage (from `df -h /`)

| Server | Total | Used | Free | Use% |
|--------|-------|------|------|------|
| Master | 985 GB | 21 GB | 924 GB | 3% |
| Lady | 985 GB | 59 GB | 886 GB | 7% |

**Note**: Old baseline stated 400 GB total — WRONG. Both servers have 985 GB NVMe.

### 7.2 Backup Strategy

| Method | Scope | Frequency | Retention |
|--------|-------|-----------|-----------|
| GitHub repos | Configs, compose files, docs | Every commit | Permanent |
| Contabo snapshots | Full disk images | On-demand | Manual |
| Ansible playbooks | Full server rebuild | On change | Git |

---

## 8. SECURITY INVENTORY

### 8.1 Firewall (iptables + UFW chains)

Both servers run iptables with UFW chain integration. Default INPUT policy: **DROP**.

**Master iptables INPUT chain:**
```
1  ts-input                    # Tailscale rules
2  ufw-before-logging-input    # UFW logging
3  ufw-before-input            # UFW allow rules
4  ufw-after-input             # UFW additional rules
5  ufw-after-logging-input     # UFW post-logging
6  ufw-reject-input            # UFW rejects
7  ufw-track-input             # UFW connection tracking
```

**Lady iptables INPUT chain:**
```
1  MAILCOW                     # Mailcow netfilter rules
2  ts-input                    # Tailscale rules
3  ufw-before-logging-input    # UFW logging
4  ufw-before-input            # UFW allow rules
5  ufw-after-input             # UFW additional rules
6  ufw-after-logging-input     # UFW post-logging
7  ufw-reject-input            # UFW rejects
8  ufw-track-input             # UFW connection tracking
```

### 8.2 fail2ban

| Server | Jails | Status |
|--------|-------|--------|
| Master | sshd, traefik-auth, recidive | 3 active |
| Lady | sshd, traefik-auth, recidive | 3 active |

**Note**: Old baseline stated Lady was missing traefik-auth and recidive. This has been FIXED (2026-02-16).

### 8.3 CrowdSec

| Component | Master | Lady |
|-----------|--------|------|
| Version | v1.6.8 | v1.6.8 |
| Container | crowdsec | crowdsec |
| Bouncer | bouncer-traefik | bouncer-traefik |
| WAL mode | Enabled | Enabled |
| Community rules | Active | Active |

### 8.4 Authentication

- **Authelia** (Master only): SSO/2FA for sensitive services behind Traefik
- **SSH**: Key-based authentication (both servers)
- **Secrets**: `~/.secrets/{service}/` — directory 700, files 600, gitignored

---

## 9. MONITORING INVENTORY

### 9.1 Metrics Pipeline

```
┌──────────┐    ┌──────────────┐    ┌────────────┐    ┌─────────┐
│ node-exp │───>│              │    │            │    │         │
│ cadvisor │───>│  prometheus  │───>│  grafana   │───>│ gotify  │
│ blackbox │───>│  (Master)    │    │  (Master)  │    │ (push)  │
│ mysqld-e │───>│              │    │            │    │         │
└──────────┘    └──────┬───────┘    └────────────┘    └─────────┘
                       │
                       ▼
                ┌──────────────┐
                │ alertmanager │
                └──────────────┘
```

### 9.2 Log Pipeline

```
┌──────────┐    ┌──────────┐    ┌─────────┐
│ promtail │───>│   loki   │───>│ grafana │
│ (Master) │    │ (Master) │    │ (query) │
│ (Lady)   │    │          │    │         │
└──────────┘    └──────────┘    └─────────┘
```

### 9.3 Uptime Monitoring

Uptime Kuma (Master): 25+ HTTP/TCP/Ping checks across all services.

### 9.4 Component Versions

| Component | Master | Lady |
|-----------|--------|------|
| Prometheus | v2.54.1 | — |
| Grafana | 11.4.0 | — |
| Loki | 3.3.2 | — |
| Alertmanager | v0.27.0 | — |
| Promtail | 3.4.2 | 3.4.2 |
| Node Exporter | v1.9.0 | v1.9.0 |
| cAdvisor | v0.52.1 | v0.52.1 |
| Blackbox Exporter | v0.28.0 | — |
| mysqld-exporter | — | latest |

---

## 10. DEPENDENCIES & CONSTRAINTS

### 10.1 Boot Order Dependencies

```
1. /etc/resolv.conf (1.1.1.1 — IMMUTABLE on Master)
2. Docker daemon
3. Headscale (systemd, Master only)
4. Tailscale daemon (connects to Headscale)
5. All containers (docker compose up -d)
```

### 10.2 Cross-Server Dependencies

```
Lady → Master:
  - Tailscale mesh (100.64.0.2 → 100.64.0.1 for VPN control)
  - Promtail → Loki (log shipping via Tailscale)
  - Portainer agent → Portainer (management via Tailscale)
  - node-exporter → Prometheus (metrics via Tailscale)
  - cadvisor → Prometheus (metrics via Tailscale)

Master → Lady:
  - Pi-hole → unbound-mailcow (DNS forwarding for mail domains)
  - Blackbox → Lady services (endpoint probing)
```

### 10.3 Mandatory Constraints

| Constraint | Reason |
|------------|--------|
| Headscale = systemd (NEVER Docker) | Avoids circular VPN-Docker dependency |
| No OSPF/FRR | Permanently rejected Jan 13, 2026 — caused garbage routes |
| Master resolv.conf = 1.1.1.1 (immutable) | Prevents DNS-Headscale boot crash loop |
| Postfix = only MTA | Single point of mail delivery (Mailcow stack) |
| Docker organization per MANDATORY standard | `~/.docs/01-architecture/DOCKER_ORGANIZATION_MANDATORY.md` |
| Two-repo GitHub model | master + github repos with symlinks |

---

## 11. KNOWN ISSUES

| # | Issue | Server | Severity | Status |
|---|-------|--------|----------|--------|
| 1 | UISP internal watchdog log noise (~91 errors/2h) | Lady | Low | Container works, log noise only |
| 2 | mysqld-exporter uses `:latest` tag | Lady | Low | Should pin version |
| 3 | uisp uses `nico640/docker-unms:latest` | Lady | Low | Should pin version |
| 4 | uptime-kuma running by image hash (no tag) | Master | Low | Should pin version |

All other issues from previous baseline are RESOLVED or CLOSED (see [TODO.md](../TODO.md)).

---

## 12. VERIFICATION COMMANDS

Run these to verify this document against live state:

```bash
# Container count
echo "Master: $(docker ps -q | wc -l)" && echo "Lady: $(ssh lady 'docker ps -q | wc -l')"

# All containers healthy?
docker ps --format '{{.Names}}\t{{.Status}}' | grep -v "Up"
ssh lady 'docker ps --format "{{.Names}}\t{{.Status}}" | grep -v "Up"'

# Hardware
nproc && free -h | grep Mem && df -h / | tail -1

# Headscale
systemctl is-active headscale && headscale version

# fail2ban
sudo fail2ban-client status

# No real errors (last 2h)
for c in $(docker ps --format '{{.Names}}'); do
  cnt=$(docker logs "$c" --since 2h 2>&1 | grep -ciE 'level=(error|fatal|panic|crit)' 2>/dev/null || echo 0)
  [ "$cnt" -gt 0 ] && echo "$c: $cnt real errors"
done
```

---

## 13. COMPARISON WITH PREVIOUS BASELINE

### What was WRONG in the old doc (archived):

| Error | Old Value | Real Value |
|-------|-----------|------------|
| Master container #6 | fail2ban (container) | Does NOT exist as container — it's systemd |
| Master container #23 | postgres:14 | Does NOT exist |
| Master container #24 | redis:7-alpine | Does NOT exist |
| Master container #25 | watchtower | Does NOT exist (phantom) |
| Master missing | headscale-admin, headscale-ui, default-landing, fuckoff-page | All 4 are running |
| Lady #9 | solr-mailcow | Does NOT exist |
| Lady #17 | ipsec-mailcow | Does NOT exist |
| Lady #23 | onlyoffice-postgres | Does NOT exist (OnlyOffice has no separate DB) |
| Lady #25 | odoo-postgres | Actually named `odoo-db` |
| Lady #29 | uisp-postgres | Does NOT exist |
| Lady #34 | fail2ban (container) | Does NOT exist as container — it's systemd |
| Lady #35-39 | "(5 support containers)" | Vague — real containers: mta-sts, mysqld-exporter, portainer-agent, traefik, homeassistant, frigate |
| Storage (both) | 400 GB total | 985 GB total |
| Image versions | prometheus v2.45.0, grafana 10.1.0, loki 2.9.0, etc. | prometheus v2.54.1, grafana 11.4.0, loki 3.3.2, etc. |
| Lady fail2ban | "Missing traefik-auth + recidive" | FIXED — 3 jails active |
| Lady mailcow count | Listed 18 but wrong 2 | Real 18, different 2 containers |

---

**Document Version**: 2.0  
**Verified By**: Live system inspection, 2026-02-16 03:00 CET  
**Method**: `docker ps`, `ssh lady`, `free -h`, `df -h`, `iptables`, `fail2ban-client`, `headscale version`  
**Standard**: Per `~/.docs/00-standards/DOCUMENTATION_STANDARD.md` — Rule #0 applied throughout  
**Next Review**: When container count changes or hardware is modified
