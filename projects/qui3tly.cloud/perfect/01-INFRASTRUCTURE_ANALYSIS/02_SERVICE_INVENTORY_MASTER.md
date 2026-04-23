# 02 — Master Service Inventory

> **Source**: `09-EVIDENCE/inv_master_20260423T201406Z.txt` (2026-04-23 20:14 UTC)  
> **Method**: `docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"`  
> **Container count**: 25 ✅ matches `INFRASTRUCTURE_OVERVIEW.md`

## 📦 Running containers (25)

| # | Name | Status | Exposed ports | Binding | Security note |
|---|---|---|---|---|---|
| 1 | `headscale-admin` | Up 10d | 80/443/2019, 443/udp | internal | — |
| 2 | `headscale-ui` | Up 10d | 443/tcp | internal | — |
| 3 | `pihole` | Up 10d ✓ | `10.10.0.1:53`, `100.64.0.1:53`, `127.0.0.1:8053→80` | VPN+localhost | ✅ |
| 4 | `traefik` | Up 10d ✓ | `0.0.0.0:80`, `0.0.0.0:443`, `127.0.0.1:8080` | public (expected) | ✅ |
| 5 | `it-tools` | Up 10d | 80/tcp | internal | — |
| 6 | `promtail` | Up 10d ✓ | none | internal | — |
| 7 | `blackbox` | Up 10d ✓ | `100.64.0.1:9115` | VPN-only | ✅ |
| 8 | `cloudflared` | Up 10d | none | internal | DoH sidecar for pihole |
| 9 | `default-landing` | Up 10d | 80/tcp | internal | — |
| 10 | `fuckoff-page` | Up 10d ✓ | 80/tcp | internal | — |
| 11 | `admin-panel` | Up 10d ✓ | none | internal | — |
| 12 | `bouncer-traefik` | Up 10d ✓ | none | internal | — |
| 13 | `crowdsec` | Up 10d ✓ | none | internal | — |
| 14 | `ntfy` | Up 10d ✓ | 80/tcp | internal | — |
| 15 | `semaphore` | Up 10d ✓ | none | internal | — |
| 16 | `authelia` | Up 10d ✓ | 9091/tcp | internal | — |
| 17 | `uptime-kuma` | Up 10d ✓ | 3001/tcp | internal | — |
| 18 | `prometheus` | Up 10d ✓ | 9090/tcp | internal | — |
| 19 | `loki` | Up 10d ✓ | `100.64.0.1:3100` | VPN-only | ✅ |
| 20 | `grafana` | Up 10d ✓ | 3000/tcp | internal | — |
| 21 | `alertmanager` | Up 10d ✓ | 9093/tcp | internal | — |
| 22 | `portainer` | Up 10d | `127.0.0.1:9000`, 8000/tcp, `127.0.0.1:9443` | localhost | ✅ |
| 23 | `node-exporter` | Up 10d | 9100/tcp | internal | — |
| 24 | `gotify` | Up 10d ✓ | 80/tcp | internal | — |
| 25 | `cadvisor` | Up 10d ✓ | 8080/tcp | internal | — |

Healthcheck coverage: **18/25** containers report health. Remaining 7 lack a declared healthcheck — violates `DOCKER_LAYOUT.md` "Healthchecks required for all services". Filed under 06-GOVERNANCE_COMPLIANCE.

## 🔌 Host listeners on Master (from `ss -tulnp`)

Summary (full in evidence):

```
# Public (0.0.0.0)
tcp :80     traefik         ✅ expected
tcp :443    traefik         ✅ expected
tcp :1006   sshd            ✅ expected
tcp :8085   headscale       ⚠ F-0008 — external probe needed
udp :3478   headscale DERP  ✅ STUN
udp :41641  tailscaled      ✅
udp :51820  wireguard       ✅

# Tailscale (100.64.0.1)
tcp :53, udp :53   pihole          ✅
tcp :9115          blackbox        ✅
tcp :3100          loki            ✅

# WireGuard (10.10.0.1)
tcp :53, udp :53   pihole          ✅

# Localhost only (127.0.0.1)
tcp :9000  portainer       ✅
tcp :9090  headscale mx    ✅
tcp :8053  pihole web      ✅
tcp :8080  traefik api     ✅
tcp :9443  portainer TLS   ✅
```

→ **F-0008 (new, P2)**: `0.0.0.0:8085/tcp` headscale listener needs Phase 03A external probe to confirm not actually reachable.

## 🗄️ Docker networks

| Network | Subnet | Members (indicative) |
|---|---|---|
| `traefik` | 172.18.0.0/16 | traefik + every service behind it |
| `monitoring` | 172.30.0.0/24 | prometheus, grafana, loki, alertmanager, blackbox, cadvisor, node-exporter, promtail |
| `pihole_internal` | 172.70.9.0/29 | pihole + cloudflared (6 usable IPs — tight) |

## 📝 Next actions

- `docker inspect` across all 25 → image digest, healthcheck config, mem/CPU limits → `06-GOVERNANCE_COMPLIANCE/03_DOCKER_LAYOUT_COMPLIANCE.md`
- Digest vs upstream → `02-SECURITY_ANALYSIS/05_CVE_SCAN.md`
