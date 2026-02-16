# CCIE Routing Decision Algorithm — Packet-Level FIB Lookup

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Verified**: 2026-02-16 (ALL data from `ip route show` on LIVE systems)  
> **Standard**: Cisco CCIE-level documentation — complete FIB with longest-prefix match  
> **Scope**: Both servers — every routing decision for every packet

---

## MASTER SERVER — Forwarding Information Base (FIB)

```
═══════════════════════════════════════════════════════════════════════════════════════════
    MASTER FIB — Verified from: ip route show (2026-02-16)
    Kernel routing table — longest prefix match, top to bottom
═══════════════════════════════════════════════════════════════════════════════════════════

    PREFIX                  NEXT-HOP / DEV         PROTO    SCOPE    NOTES
    ──────────────────────  ─────────────────────  ───────  ───────  ────────────────
    default                 via 213.136.68.1       dhcp     global   ● eth0
                            dev eth0

    10.10.0.0/30            dev wg0                kernel   link     WireGuard tunnel
                                                                     (Master ↔ Home)

    172.17.0.0/16           dev docker0            kernel   link     Docker default
                                                                     bridge (DOWN)

    172.18.0.0/16           dev br-fb776b4784ae    kernel   link     "traefik" net
                                                                     (20 containers)

    172.30.0.0/24           dev br-0341e55be098    kernel   link     "monitoring" net
                                                                     (12 containers)

    172.70.9.0/29           dev br-ca56054321aa    kernel   link     "pihole_internal"
                                                                     (2 containers)

    192.168.99.0/24         dev wg0                kernel   link     Home LAN route
                                                                     (via WG tunnel)

    213.136.68.0/24         dev eth0               kernel   link     Local subnet
                            src 213.136.68.108                       (Contabo DC)

    NOTE: Tailscale routes NOT in kernel FIB — handled in userspace by tailscaled
    100.64.0.0/10 → tailscale0 (managed by ts-input/ts-forward iptables chains)

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## MASTER ROUTING DECISION TREE

```
═══════════════════════════════════════════════════════════════════════════════════════════
    PACKET ARRIVES → Where does it go?
    Decision tree: longest-prefix match algorithm
═══════════════════════════════════════════════════════════════════════════════════════════

                         ┌──────────────────────────┐
                         │   PACKET IN              │
                         │   dst = X.X.X.X          │
                         └────────────┬─────────────┘
                                      │
                    ┌─────────────────┤──────────────────────┐
                    │ Is dst a LOCAL  │                      │
                    │ address on any  │                      │
                    │ interface?      │                      │
                    ▼                 ▼                      │
                  YES               NO                      │
            (INPUT chain)     (routing lookup)               │
                    │                 │                      │
                    ▼                 │                      │
          ┌──────────────┐           │                      │
          │ Deliver to   │           │                      │
          │ local process│           │                      │
          │ (Traefik,    │           │                      │
          │  WireGuard,  │           │                      │
          │  Headscale)  │           │                      │
          └──────────────┘           │                      │
                                     ▼                      │
                    ┌──────────────────────────┐            │
                    │  LONGEST PREFIX MATCH    │            │
                    │  Check FIB top→bottom    │            │
                    └────────────┬─────────────┘            │
                                 │                          │
         ┌───────────────────────┼───────────────────────┐  │
         │                       │                       │  │
         ▼                       ▼                       ▼  │
  ┌──────────────┐    ┌──────────────────┐   ┌────────────────────┐
  │ dst matches  │    │ dst matches      │   │ dst matches        │
  │ 172.70.9.0/29│    │ 172.30.0.0/24    │   │ 172.18.0.0/16      │
  │              │    │                  │   │                    │
  │ /29 = most   │    │ /24 wins over    │   │ /16 — broadest     │
  │ specific!    │    │ /16 Docker nets  │   │ Docker match       │
  │              │    │                  │   │                    │
  │ → pihole_int │    │ → monitoring     │   │ → traefik          │
  │ br-ca5605... │    │ br-034155...     │   │ br-fb776b...       │
  │ (pihole,     │    │ (prometheus,     │   │ (20 containers)    │
  │  cloudflared)│    │  grafana, etc)   │   │                    │
  └──────────────┘    └──────────────────┘   └────────────────────┘

         ▼                       ▼                       ▼
  ┌──────────────┐    ┌──────────────────┐   ┌────────────────────┐
  │ dst matches  │    │ dst matches      │   │ dst matches        │
  │ 10.10.0.0/30 │    │ 192.168.99.0/24  │   │ 213.136.68.0/24    │
  │              │    │                  │   │                    │
  │ → wg0 tunnel │    │ → wg0 tunnel     │   │ → eth0 (local LAN) │
  │ (to Home ER) │    │ (Home LAN behind │   │ (Contabo subnet)   │
  │              │    │  EdgeRouter)     │   │ src: .108           │
  └──────────────┘    └──────────────────┘   └────────────────────┘

         ▼                       ▼
  ┌──────────────┐    ┌──────────────────┐
  │ dst matches  │    │ dst matches      │
  │ 100.64.0.0   │    │ NOTHING above    │
  │ /10 (CGNAT)  │    │ (DEFAULT ROUTE)  │
  │              │    │                  │
  │ → tailscale0 │    │ → eth0           │
  │ (userspace   │    │ via 213.136.68.1 │
  │  routing)    │    │ (Contabo GW)     │
  │ Peers:       │    │ → Internet       │
  │ .2 = Lady    │    │                  │
  │ .3 = Mac     │    │                  │
  └──────────────┘    └──────────────────┘


═══════════════════════════════════════════════════════════════════════════════════════════
    PRECEDENCE ORDER (by prefix length — longest wins):
    1. /32  — Tailscale peer addresses (100.64.0.x)
    2. /30  — WireGuard tunnel (10.10.0.0/30)
    3. /29  — pihole_internal (172.70.9.0/29)
    4. /24  — monitoring (172.30.0.0/24), home LAN (192.168.99.0/24),
              Contabo subnet (213.136.68.0/24)
    5. /16  — traefik (172.18.0.0/16), docker0 (172.17.0.0/16)
    6. /0   — default gateway (213.136.68.1 via eth0)
═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## LADY SERVER — Forwarding Information Base (FIB)

```
═══════════════════════════════════════════════════════════════════════════════════════════
    LADY FIB — Verified from: ip route show (2026-02-16)
    Kernel routing table — longest prefix match
═══════════════════════════════════════════════════════════════════════════════════════════

    PREFIX                  NEXT-HOP / DEV         PROTO    SCOPE    NOTES
    ──────────────────────  ─────────────────────  ───────  ───────  ────────────────
    default                 via 207.180.192.1      dhcp     global   ● eth0
                            dev eth0

    172.17.0.0/16           dev docker0            kernel   link     Docker default
                                                                     bridge (DOWN)

    172.18.0.0/16           dev br-traefik         kernel   link     "traefik" net
                                                                     (~12 containers)

    172.19.0.0/16           dev br-monitoring      kernel   link     "monitoring" net
                                                                     (5 containers)

    172.20.0.0/16           dev br-nextcloud       kernel   link     "nextcloud" net
                                                                     (4 containers)

    172.21.0.0/16           dev br-portainer       kernel   link     "portainer" net

    172.22.0.0/16           dev br-odoo            kernel   link     "odoo" net
                                                                     (2 containers)

    172.23.0.0/16           dev br-unifi           kernel   link     "unifi" net

    172.28.1.0/24           dev br-mailcow         kernel   link     "mailcow" net
                                                                     (18 containers)

    207.180.192.0/18        dev eth0               kernel   link     Local subnet
                            via 207.180.192.1                        (Contabo DC)

    NOTE: Tailscale routes = userspace (100.64.0.0/10 → tailscale0)
    NOTE: No WireGuard interface on Lady — VPN only via Tailscale

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## LADY ROUTING DECISION TREE

```
═══════════════════════════════════════════════════════════════════════════════════════════

                         ┌──────────────────────────┐
                         │   PACKET IN              │
                         │   dst = X.X.X.X          │
                         └────────────┬─────────────┘
                                      │
                    ┌─────────────────┤──────────────────────┐
                    │ LOCAL?          │                      │
                    ▼                 ▼                      │
                  YES               NO                      │
            (INPUT chain)     (FIB lookup)                   │
                    │                 │                      │
         ┌─────────┘                 │                      │
         ▼                           ▼                      │
  ┌──────────────┐   ┌──────────────────────────┐          │
  │ Local process│   │ LONGEST PREFIX MATCH      │          │
  │ (Traefik,    │   │                           │          │
  │  Postfix,    │   │ /24: 172.28.1.0 → mailcow │          │
  │  Dovecot)    │   │ /18: 207.180.192.0 → eth0 │          │
  │              │   │ /16: 172.18-23.x → bridges│          │
  └──────────────┘   │ /10: 100.64.x → tailscale│          │
                      │  /0: default → eth0 GW   │          │
                      └──────────────────────────┘          │
                                                             │
    PRECEDENCE (Lady):                                       │
    1. /32  — Tailscale peers (100.64.0.1, 100.64.0.3)      │
    2. /24  — mailcow (172.28.1.0/24)                        │
    3. /18  — Contabo subnet (207.180.192.0/18)              │
    4. /16  — Docker bridges (172.18-23.0.0/16) × 6          │
    5. /0   — default gateway (207.180.192.1 via eth0)       │

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## NAT/MASQUERADE DECISION FLOW

```
═══════════════════════════════════════════════════════════════════════════════════════════
    WHEN DOES A PACKET GET MASQUERADED (SNAT)?
    Only in nat POSTROUTING chain — verified from iptables -t nat -L POSTROUTING
═══════════════════════════════════════════════════════════════════════════════════════════

    PACKET LEAVES CONTAINER → Docker bridge gateway → host routing

         ┌───────────────────────────┐
         │  CONTAINER → INTERNET?    │
         │  (needs MASQUERADE)        │
         └─────────────┬─────────────┘
                       │
         ┌─────────────┤──────────────────────┐
         ▼             ▼                      ▼
    ┌──────────┐  ┌──────────────┐     ┌──────────────────┐
    │ src:     │  │ src:         │     │ src:             │
    │ 172.18.x │  │ 172.30.0.x   │     │ 172.70.9.x       │
    │ traefik  │  │ monitoring   │     │ pihole_internal  │
    │ bridge   │  │ bridge       │     │ bridge           │
    └────┬─────┘  └──────┬───────┘     └────────┬─────────┘
         │               │                      │
         ▼               ▼                      ▼
    ┌────────────────────────────────────────────────────────┐
    │  nat POSTROUTING:                                      │
    │                                                        │
    │  Rule: src 172.18.0.0/16 ! dst 172.18.0.0/16          │
    │        → MASQUERADE (src → 213.136.68.108)             │
    │        Packets matched: 62,949                         │
    │                                                        │
    │  Rule: src 172.30.0.0/24 ! dst 172.30.0.0/24          │
    │        → MASQUERADE                                    │
    │        Packets matched: 2,297,543 (most active!)       │
    │                                                        │
    │  Rule: src 172.70.9.0/29 ! dst 172.70.9.0/29          │
    │        → MASQUERADE                                    │
    │        Packets matched: 5,011,422 (DNS!)               │
    │                                                        │
    │  Rule: src 172.17.0.0/16 ! dst 172.17.0.0/16          │
    │        → MASQUERADE (docker0 — inactive)               │
    │        Packets matched: 0                              │
    └────────────────────────────────────────────────────────┘

    LOGIC: MASQUERADE when source is Docker network AND destination
           is NOT same Docker network (cross-network or Internet).
           Source IP rewritten to host's outgoing interface IP.

    HIGH-TRAFFIC OBSERVATION:
    • pihole_internal: 5M packets — cloudflared DoH queries to 1.1.1.1
    • monitoring: 2.3M packets — Prometheus scraping Lady via Tailscale
    • traefik: 63K packets — containers calling external APIs (low)

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## COMPLETE PACKET LIFECYCLE — START TO FINISH

```
═══════════════════════════════════════════════════════════════════════════════════════════
    LINUX NETFILTER: Complete packet path through kernel
    (applies to BOTH Master and Lady — this IS the kernel)
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌──────────────────┐
    │  PACKET ARRIVES   │
    │  on ● interface   │     ┌─────────────────────────────────────────┐
    └────────┬─────────┘     │  CONNTRACK (Connection Tracking)        │
             │                │  • ESTABLISHED/RELATED → fast-path      │
             ▼                │  • NEW → full chain traversal            │
    ┌─────────────────┐      │  • INVALID → typically DROP              │
    │  raw            │      └─────────────────────────────────────────┘
    │  PREROUTING     │
    │  (conntrack     │
    │   exceptions)   │
    └────────┬────────┘
             │
             ▼
    ┌─────────────────┐
    │  nat            │      ┌─────────────────────────────────────────┐
    │  PREROUTING     │      │  DNAT happens HERE                      │
    │                 │──────│  Example: :443 → 172.30.0.2:443         │
    │  DOCKER chain   │      │  This changes the DESTINATION before    │
    └────────┬────────┘      │  routing decision is made               │
             │                └─────────────────────────────────────────┘
             ▼
    ┌─────────────────┐
    │  ROUTING         │
    │  DECISION        │
    │                  │
    │  dst is LOCAL? ──┼──── YES ──▶ filter INPUT ──▶ LOCAL PROCESS
    │                  │                    │
    │  dst is REMOTE? ─┼──── YES ──▶ filter FORWARD ──▶ (see below)
    └─────────────────┘

    === IF LOCAL DELIVERY (INPUT) ===

    ┌─────────────────────────────────────────────────────────────────┐
    │  filter INPUT chain (Master — verified stats):                  │
    │                                                                 │
    │  1. ts-input          14,169,789 pkts    9,149 MB              │
    │     └── Tailscale VPN traffic → ACCEPT                         │
    │  2. ufw-before-input  11,093,498 pkts    5,282 MB              │
    │     ├── ESTABLISHED,RELATED → ACCEPT                           │
    │     ├── lo → ACCEPT                                             │
    │     └── ICMP → ACCEPT (limit 3/sec)                            │
    │  3. ufw-user-input (port rules):                               │
    │     ├── 1006/tcp  → ACCEPT (SSH — custom port)                 │
    │     ├── 80/tcp    → ACCEPT (HTTP redirect)                     │
    │     ├── 443/tcp   → ACCEPT (HTTPS — Traefik)                   │
    │     ├── 8443/tcp  → ACCEPT (Headscale)                         │
    │     ├── 51820/udp → ACCEPT (WireGuard)                         │
    │     ├── 3478/udp  → ACCEPT (DERP/STUN)                        │
    │     ├── 41641/udp → ACCEPT (Tailscale direct)                  │
    │     └── VPN-only: 100.64.0.0/10, 192.168.99.0/24 → ACCEPT     │
    │  4. Policy: DROP   88,388 packets dropped                      │
    └─────────────────────────────────────────────────────────────────┘

    === IF FORWARDING (FORWARD) ===

    ┌─────────────────────────────────────────────────────────────────┐
    │  filter FORWARD chain (Master — verified):                      │
    │                                                                 │
    │  1. ts-forward          3,628,789 pkts    4,598 MB             │
    │  2. DOCKER-USER         7,158,020 pkts    7,941 MB             │
    │     └── RETURN (no custom restrict rules)                      │
    │  3. DOCKER-FORWARD      2,253,694 pkts      286 MB             │
    │     └── Container-to-container routing                         │
    │  4. ufw-before-forward                                         │
    │     └── ESTABLISHED,RELATED → ACCEPT                           │
    │  5. ufw-user-forward                                           │
    │     └── wg0 → ACCEPT (WireGuard forwarding)                   │
    │  6. Policy: DROP (default)                                     │
    └─────────────────────────────────────────────────────────────────┘

    === AFTER ROUTING (outbound) ===

             ▼
    ┌─────────────────┐
    │  nat             │
    │  POSTROUTING     │
    │                  │      ┌────────────────────────────────────────┐
    │  ts-postrouting ─┼──────│ 234,135 pkts / 16 MB (Tailscale NAT) │
    │  MASQUERADE      │      └────────────────────────────────────────┘
    │  (per network)   │
    └────────┬─────────┘
             │
             ▼
    ┌─────────────────┐
    │  OUT on          │
    │  ● interface     │
    │  (eth0/wg0/ts0/  │
    │   Docker bridge) │
    └─────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## DOCKER NETWORK ISOLATION MODEL

```
═══════════════════════════════════════════════════════════════════════════════════════════
    NETWORK SEGMENTATION — Which containers can talk to which?
═══════════════════════════════════════════════════════════════════════════════════════════

    MASTER NETWORKS:

    ┌─ traefik (172.18.0.0/16) ──────────────────────────────────────────────────┐
    │  ALL web-facing containers live here (20 containers)                        │
    │  CAN reach: Internet (via MASQUERADE)                                      │
    │  CAN reach: monitoring network (dual-homed containers)                     │
    │  CANNOT reach: pihole_internal (different bridge, no route)                 │
    └────────────────────────────────────────────────────────────────────────────┘

    ┌─ monitoring (172.30.0.0/24) ───────────────────────────────────────────────┐
    │  ALL monitoring containers (12 containers)                                  │
    │  CAN reach: Tailscale (via MASQUERADE → tailscale0 → Lady)                 │
    │  CAN reach: traefik network (dual-homed: traefik, grafana, ntfy, gotify)  │
    │  CANNOT reach: pihole_internal                                              │
    │  NOTE: /24 = more restrictive than /16 traefik net (max 254 hosts)         │
    └────────────────────────────────────────────────────────────────────────────┘

    ┌─ pihole_internal (172.70.9.0/29) ──────────────────────────────────────────┐
    │  ISOLATED: Only 2 containers (pihole + cloudflared)                         │
    │  /29 = 6 usable IPs maximum — TIGHTEST segmentation                        │
    │  CAN reach: Internet (cloudflared DoH → 1.1.1.1 via MASQUERADE)           │
    │  CANNOT reach: traefik or monitoring networks directly                      │
    │  pihole also on traefik net (172.18.0.7) for web UI access                 │
    └────────────────────────────────────────────────────────────────────────────┘

    DUAL-HOMED CONTAINERS (on multiple networks):
    ┌──────────────────────────────────────────────────────────────────┐
    │  Container         traefik net      monitoring net  pihole net  │
    │  ────────────────  ──────────────   ──────────────  ────────── │
    │  traefik           172.18.0.18      172.30.0.6      —          │
    │  prometheus         172.18.0.15     172.30.0.2      —          │
    │  grafana           172.18.0.21      172.30.0.11     —          │
    │  alertmanager      172.18.0.19      172.30.0.8      —          │
    │  loki              172.18.0.17      172.30.0.4      —          │
    │  uptime-kuma       172.18.0.20      172.30.0.9      —          │
    │  ntfy              172.18.0.11      172.30.0.12     —          │
    │  gotify            172.18.0.13      172.30.0.13     —          │
    │  pihole            172.18.0.7       —               172.70.9.3 │
    │                                                                 │
    │  These containers bridge network segments — potential lateral   │
    │  movement risk if compromised (limited by container isolation)  │
    └──────────────────────────────────────────────────────────────────┘


    LADY NETWORKS:

    ┌─ traefik (172.18.0.0/16) ──── web services ───────────────────────────────┐
    ┌─ monitoring (172.19.0.0/16) ── metrics exporters ─────────────────────────┐
    ┌─ nextcloud (172.20.0.0/16) ── nextcloud + mariadb + redis + onlyoffice ──┐
    ┌─ portainer (172.21.0.0/16) ── container management ──────────────────────┐
    ┌─ odoo (172.22.0.0/16) ──── ERP + postgresql ─────────────────────────────┐
    ┌─ unifi (172.23.0.0/16) ──── network controller ──────────────────────────┐
    ┌─ mailcow (172.28.1.0/24) ── TIGHTEST: 18 containers, isolated ──────────┐
    │  NOTE: Mailcow uses /24 (not /16) — proper segmentation for mail stack   │
    └──────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```
