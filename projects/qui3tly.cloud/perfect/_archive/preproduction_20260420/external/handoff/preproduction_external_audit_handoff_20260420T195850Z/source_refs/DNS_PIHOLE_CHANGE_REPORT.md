# DNS / Pi-hole Change Report

**Repository:** `/home/qui3tly`
**Period:** Jan 13 – Feb 16, 2026
**Generated:** 2026-02-18

---

## Authors

| Author | Email | Role | Active period |
|---|---|---|---|
| Tihomir Raznatovic | tihomir.raznatovic@gmail.com | Initial architect | Jan 13–14, 2026 |
| qui3tly | qui3tly@quietly.online | Ongoing operator | Jan 17, 2026 – present |

---

## Chronological Change Log

### `57bef89` — Wed Jan 14, 2026 00:16 — *Tihomir Raznatovic*
**Fix DNS: return Tailnet IPs per RFP design**

**Why:** The original config resolved all services to the WireGuard bridge IP (`10.100.0.1`). This violated the RFP requirement that VPN clients receive Tailnet IPs directly.

**Files changed:**
- `.docker/pihole/etc-dnsmasq.d/01-local-dns.conf`
- `.docs/architecture/NETWORK.md`

**What changed in dnsmasq:**
- All `*.quietly.its.me` entries: `10.100.0.1` → `100.64.0.1` (Tailnet IP of Master)
- Converted comment header to describe split-horizon DNS model
- Added missing entries: `tools.`, `admin.`, `auth.`, `nextcloud.quietly.online`
- Removed: `vpn.quietly.its.me`, `unifi.quietly.online`
- Lady server (`100.64.0.2`) entries retained/corrected

---

### `9ffc243` — Wed Jan 14, 2026 05:52 — *Tihomir Raznatovic*
**EdgeRouter DNS fix: all-servers option, Grafana .env password**

**Why:** EdgeRouter DNS resolution issues required enabling `all-servers` mode. Large infrastructure commit.

**Files changed:** CrowdSec, Authelia, monitoring configs, Grafana `.env` — DNS dnsmasq file unchanged.

**Note:** The EdgeRouter-side DNS fix (`all-servers` option) is applied on the EdgeRouter directly and is not tracked in this repository.

---

### `7ffef11` — Sat Jan 17, 2026 04:40 — *qui3tly*
**Add Lady services to Pi-hole DNS and admin panel**

**Why:** Lady server (`quietly.online`) services were not resolvable via Pi-hole. VPN clients couldn't reach Lady services by hostname.

**Files changed:**
- `.docker/pihole/etc-dnsmasq.d/01-local-dns.conf`

**What changed in dnsmasq:**
```
# Lady server (quietly.online) - Full services
address=/quietly.online/100.64.0.2
address=/traefik.quietly.online/100.64.0.2
address=/portainer.quietly.online/100.64.0.2
address=/crowdsec.quietly.online/100.64.0.2

# Wildcard for any new services on lady
address=/.quietly.online/100.64.0.2
```

---

### `25e54d5` — Sun Jan 18, 2026 00:54 — *qui3tly*
**DNS fix complete, dnsmasq updated with qui3tly.cloud entries**

**Why:** Headscale's built-in MagicDNS was being replaced/supplemented by Pi-hole. Pi-hole needed to authoritatively serve `qui3tly.cloud` entries (Headscale `base_domain`).

**Files changed:**
- `.docker/pihole/etc-dnsmasq.d/01-local-dns.conf`

**What changed in dnsmasq:**
```
# Tailnet FQDN (qui3tly.cloud) - Headscale MagicDNS replacement
address=/master.qui3tly.cloud/100.64.0.1
address=/lady.qui3tly.cloud/100.64.0.2
address=/mac.qui3tly.cloud/100.64.0.3

# Wildcard for any new Tailnet nodes
address=/.qui3tly.cloud/100.64.0.1
```

---

## DNS Architecture Evolution

```
2026-01-13  Initial commit: WireGuard IPs (10.100.0.1) for all services
             └─ Tihomir Raznatovic

2026-01-14  RFP fix: Switched to Tailnet IPs (100.64.0.x)
             └─ Tihomir Raznatovic (57bef89)

2026-01-14  EdgeRouter: all-servers DNS fix (not in repo)
             └─ Tihomir Raznatovic (9ffc243)

2026-01-17  Lady server added: *.quietly.online → 100.64.0.2
             └─ qui3tly (7ffef11)

2026-01-18  Headscale domain added: *.qui3tly.cloud → Tailnet
             └─ qui3tly (25e54d5)
```

---

## Current State

Pi-hole serves split-horizon DNS for three domains, all resolving to Tailnet IPs accessible only over VPN:

| Domain | Resolves to | Server |
|---|---|---|
| `*.quietly.its.me` | `100.64.0.1` | Master |
| `*.quietly.online` | `100.64.0.2` | Lady |
| `*.qui3tly.cloud` | `100.64.0.x` | Tailnet nodes |

Pi-hole listens on:
- `100.64.0.1` — Tailnet clients
- `10.100.0.1` — Office via WireGuard bridge
