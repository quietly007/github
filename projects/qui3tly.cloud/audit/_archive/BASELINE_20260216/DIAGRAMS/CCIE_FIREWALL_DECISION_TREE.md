# CCIE Firewall Decision Tree — Packet Processing Algorithm

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Verified**: 2026-02-16 (ALL data from `iptables -L -n -v` on LIVE system)  
> **Standard**: Cisco CCIE-level documentation  
> **Scope**: Complete netfilter/iptables packet path, both servers

---

## MASTER SERVER — COMPLETE PACKET PROCESSING FLOWCHART

```
═══════════════════════════════════════════════════════════════════════════════════════════
               MASTER SERVER — NETFILTER PACKET PROCESSING ALGORITHM
               Source: sudo iptables -L -n -v (2026-02-16 live capture)
═══════════════════════════════════════════════════════════════════════════════════════════


                    ┌─────────────────────────────────────┐
                    │         PACKET ARRIVES ON WIRE       │
                    │     (Layer 2 frame → Layer 3 IP)     │
                    └──────────────────┬──────────────────┘
                                       │
                                       ▼
              ╔════════════════════════════════════════════════╗
              ║          WHICH INTERFACE RECEIVED?              ║
              ╚══════╤═══════════╤═══════════╤════════╤═══════╝
                     │           │           │        │
          ┌──────────┘     ┌─────┘     ┌─────┘  ┌────┘
          ▼                ▼           ▼        ▼
┌──────────────────┐ ┌──────────┐ ┌────────┐ ┌────────────────┐
│ ● eth0           │ │ ● wg0    │ │ ● ts0  │ │ ● br-*         │
│ 213.136.68.108/24│ │10.10.0.1 │ │100.64. │ │ Docker bridges │
│ MAC: 00:50:56:5f │ │   /30    │ │ 0.1/32 │ │ 172.x.x.x      │
│ :34:33           │ │MTU: 1420 │ │MTU:1280│ │ MTU: 1500      │
│ MTU: 1500        │ │ WireGuard│ │Tailscal│ │ 802.1D bridge  │
└────────┬─────────┘ └─────┬────┘ └───┬────┘ └───────┬────────┘
         │                 │          │              │
         └────────┬────────┘──────────┘──────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   TABLE: raw → CHAIN: PREROUTING                   │
│  (Connection tracking, packet mangling — mostly empty)             │
│  Packets: ~all                                                      │
│  Action: ACCEPT → continue to conntrack                            │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│               TABLE: nat → CHAIN: PREROUTING                       │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Rule 1: DOCKER (ADDRTYPE match dst-type LOCAL)              │  │
│  │  Packets: 764K+   Bytes: 45M+                                │  │
│  │  ─────────────────────────────────────────────────────────── │  │
│  │  Matches: destination is LOCAL address                       │  │
│  │  Action:  Jump to DOCKER chain for DNAT decisions            │  │
│  │                                                               │  │
│  │  DOCKER chain DNAT rules (port → container mapping):         │  │
│  │  ┌─────────────────────────────────────────────────────────┐ │  │
│  │  │ 10.10.0.1:53/tcp   → 172.70.9.3:53  (Pi-hole WG DNS)  │ │  │
│  │  │ 10.10.0.1:53/udp   → 172.70.9.3:53  (Pi-hole WG DNS)  │ │  │
│  │  │ 100.64.0.1:53/tcp  → 172.70.9.3:53  (Pi-hole TS DNS)  │ │  │
│  │  │ 100.64.0.1:53/udp  → 172.70.9.3:53  (Pi-hole TS DNS)  │ │  │
│  │  │ 0.0.0.0:80/tcp     → 172.30.0.2:80  (Traefik HTTP)    │ │  │
│  │  │ 0.0.0.0:443/tcp    → 172.30.0.2:443 (Traefik HTTPS)   │ │  │
│  │  │ 127.0.0.1:9000/tcp → 172.18.0.4:9000 (Portainer)      │ │  │
│  │  │ 127.0.0.1:9443/tcp → 172.18.0.4:9443 (Portainer TLS)  │ │  │
│  │  └─────────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────┘  │
└──────────────────────────────┬──────────────────────────────────────┘
                               │
                               ▼
              ╔════════════════════════════════════════╗
              ║     ROUTING DECISION                    ║
              ║   Destination IP lookup in FIB          ║
              ║                                         ║
              ║   Is destination THIS host?             ║
              ╚══════════╤═══════════════╤══════════════╝
                         │               │
              ┌── YES ───┘               └─── NO ──┐
              │  (local delivery)      (forwarding) │
              ▼                                     ▼
┌──────────────────────────────────┐  ┌──────────────────────────────────┐
│  TABLE: filter                   │  │  TABLE: filter                   │
│  CHAIN: INPUT                    │  │  CHAIN: FORWARD                  │
│  Policy: DROP (88,388 dropped)   │  │  Policy: ACCEPT                  │
│                                  │  │                                  │
│  ┌────────────────────────────┐  │  │  ┌────────────────────────────┐  │
│  │ #1 ts-input               │  │  │  │ #1 ts-forward              │  │
│  │    Pkts: 14M  Bytes: 9.1G │  │  │  │    Pkts: 3.6M Bytes: 4.6G │  │
│  │    Match: ALL packets      │  │  │  │    Match: ALL packets      │  │
│  │    Jump to Tailscale chain │  │  │  │    Jump to Tailscale fwd   │  │
│  │    ════════════════════════│  │  │  │    ════════════════════════│  │
│  │    • 100.64.0.0/10 src →  │  │  │  │    • VPN mesh forwarding   │  │
│  │      ACCEPT               │  │  │  │    • Inter-peer routing    │  │
│  │    • Other → RETURN       │  │  │  │    • Other → RETURN        │  │
│  ├────────────────────────────┤  │  │  ├────────────────────────────┤  │
│  │ #2 ufw-before-input       │  │  │  │ #2 DOCKER-USER             │  │
│  │    Pkts: 11M  Bytes: 3.4G │  │  │  │    Pkts: 7.1M Bytes: 7.9G │  │
│  │    Jump to UFW pre-rules   │  │  │  │    Match: ALL forwarded    │  │
│  │    ════════════════════════│  │  │  │    Jump to Docker user     │  │
│  │    • lo ACCEPT (loopback)  │  │  │  │    rules chain             │  │
│  │    • ESTABLISHED → ACCEPT │  │  │  │    • Default: RETURN       │  │
│  │    • RELATED → ACCEPT     │  │  │  ├────────────────────────────┤  │
│  │    • INVALID → DROP       │  │  │  │ #3 DOCKER-FORWARD          │  │
│  │    • ICMP → ACCEPT        │  │  │  │    Pkts: 2.2M Bytes: 286M │  │
│  │    • DHCP → ACCEPT        │  │  │  │    Inter-container routing │  │
│  ├────────────────────────────┤  │  │  ├────────────────────────────┤  │
│  │ #3 ufw-user-input         │  │  │  │ #4-9 ufw-forward           │  │
│  │    (from ufw-before-input) │  │  │  │    Pkts: 40  Bytes: 2880  │  │
│  │    ════════════════════════│  │  │  │    Almost no traffic       │  │
│  │    ALLOW rules:            │  │  │  │    (UFW not used for fwd)  │  │
│  │    ┌──────────────────────┐│  │  │  ├────────────────────────────┤  │
│  │    │ 1006/tcp  → SSH     ││  │  │  │ #10 ACCEPT in=wg0          │  │
│  │    │   80/tcp  → HTTP    ││  │  │  │     Pkts: 0               │  │
│  │    │  443/tcp  → HTTPS   ││  │  │  │     ALL from WireGuard    │  │
│  │    │ 8443/tcp  → HS API  ││  │  │  ├────────────────────────────┤  │
│  │    │51820/udp  → WG      ││  │  │  │ #11 ACCEPT out=wg0         │  │
│  │    │ 3478/udp  → DERP    ││  │  │  │     Pkts: 0               │  │
│  │    │41641/udp  → TS      ││  │  │  │     ALL to WireGuard      │  │
│  │    │  ALL tailscale0     ││  │  │  └────────────────────────────┘  │
│  │    │      ← 100.64.0/10 ││  │  │                                  │
│  │    │ 8085 ← 172.18.0/16 ││  │  │  FWD rules (UFW):               │
│  │    │  ALL wg0            ││  │  │  ┌────────────────────────────┐  │
│  │    │      ← 192.168.99/24│  │  │  │ 192.168.99/24 wg0 → eth0  │  │
│  │    │  ALL wg0            ││  │  │  │ 192.168.99/24 wg0 → ts0   │  │
│  │    │      ← 10.10.0.0/30││  │  │  │ 100.64.0/10 ts0 → wg0     │  │
│  │    │  ALL ← 100.64.0/10 ││  │  │  │ 10.10.0/30 wg0 → eth0     │  │
│  │    └──────────────────────┘│  │  │  │ 10.10.0/30 wg0 → ts0      │  │
│  ├────────────────────────────┤  │  │  └────────────────────────────┘  │
│  │ #4 ufw-after-input        │  │  │                                  │
│  │    Pkts: 100K Bytes: 5.5M │  │  │  Policy: ACCEPT (all handled    │
│  │    Post-processing         │  │  │  by rules above)                │
│  ├────────────────────────────┤  │  │                                  │
│  │ #5-7 ufw-logging/reject   │  │  └──────────────────────────────────┘
│  │    Pkts: 88,388 (DROPPED) │  │                  │
│  │    All unmatched → DROP   │  │                  │
│  └────────────────────────────┘  │                  │
│                                  │                  │
│  Policy: DROP                    │                  │
│  Total dropped: 88,388 pkts      │                  │
│  (4.9 MB — port scanners, bots)  │                  │
│                                  │                  │
└────────────────┬─────────────────┘                  │
                 │                                     │
                 ▼                                     ▼
┌────────────────────────────┐        ┌────────────────────────────────────┐
│  LOCAL PROCESS             │        │  TABLE: nat → CHAIN: POSTROUTING   │
│  ────────────────────────  │        │  (Outbound NAT / Masquerading)     │
│                            │        │                                    │
│  Application receives      │        │  ┌──────────────────────────────┐  │
│  packet on bound port:     │        │  │ #1 ts-postrouting            │  │
│                            │        │  │    Pkts: 234K  Bytes: 16M    │  │
│  ● Traefik (80, 443)      │        │  │    Tailscale NAT handling    │  │
│  ● SSHD (1006)            │        │  ├──────────────────────────────┤  │
│  ● Headscale (8080, 8443) │        │  │ #2 MASQ docker0 → !docker0  │  │
│  ● Pi-hole (53)           │        │  │    172.17.0.0/16 → eth0     │  │
│  ● Prometheus (9090)      │        │  │    Pkts: 2,352              │  │
│  ● Grafana (3000)         │        │  ├──────────────────────────────┤  │
│  ● Loki (3100)            │        │  │ #3 MASQ pihole_internal      │  │
│  ● All monitoring on      │        │  │    172.70.9.0/29 → eth0     │  │
│    172.30.0.x (internal)  │        │  │    Pkts: 77                 │  │
│                            │        │  ├──────────────────────────────┤  │
└────────────────────────────┘        │  │ #4 MASQ monitoring           │  │
                                      │  │    172.30.0.0/24 → eth0     │  │
                                      │  │    Pkts: 18,052             │  │
                                      │  ├──────────────────────────────┤  │
                                      │  │ #5 MASQ traefik              │  │
                                      │  │    172.18.0.0/16 → eth0     │  │
                                      │  │    Pkts: 6,140              │  │
                                      │  ├──────────────────────────────┤  │
                                      │  │ #6 MASQ home LAN             │  │
                                      │  │    192.168.99.0/24 → eth0   │  │
                                      │  │    Pkts: 2                  │  │
                                      │  ├──────────────────────────────┤  │
                                      │  │ #7 MASQ WireGuard            │  │
                                      │  │    10.10.0.0/30 → eth0      │  │
                                      │  │    Pkts: 0                  │  │
                                      │  └──────────────────────────────┘  │
                                      │                                    │
                                      └────────────────┬───────────────────┘
                                                       │
                                                       ▼
                                      ┌────────────────────────────────────┐
                                      │  PACKET LEAVES VIA OUTPUT INTERFACE │
                                      │  ─────────────────────────────────  │
                                      │  ● eth0 → Internet (src NAT)       │
                                      │  ● wg0  → Home (10.10.0.2)         │
                                      │  ● ts0  → VPN mesh (100.64.0.x)    │
                                      │  ● br-* → Container (172.x.x.x)    │
                                      └────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## LADY SERVER — FIREWALL RULESET

```
═══════════════════════════════════════════════════════════════════════════════════════════
                    LADY SERVER — UFW FIREWALL RULESET
                    Source: sudo ufw status verbose (2026-02-16)
                    Policy: DENY incoming | ALLOW outgoing | DENY routed
═══════════════════════════════════════════════════════════════════════════════════════════

                    ┌───────────────────────────────────────┐
                    │          PACKET ARRIVES                │
                    │     ● eth0 (207.180.251.111/18)       │
                    │     MAC: 00:50:56:5f:34:39            │
                    └──────────────────┬────────────────────┘
                                       │
              ╔════════════════════════╧════════════════════════════════════════╗
              ║                    UFW INBOUND RULES                            ║
              ║                    Default: DENY (incoming)                     ║
              ╠════════════════════════════════════════════════════════════════╣
              ║                                                                 ║
              ║  Port/Proto   Source            Interface   Purpose             ║
              ║  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ║
              ║  1006/tcp     ANY               eth0        SSH                 ║
              ║  60000-61000  ANY               eth0        Mosh (UDP)          ║
              ║    80/tcp     ANY               eth0        HTTP → Traefik      ║
              ║   443/tcp     ANY               eth0        HTTPS → Traefik     ║
              ║ 41641/udp     ANY               eth0        Tailscale direct    ║
              ║    25/tcp     ANY               eth0        SMTP (Postfix)      ║
              ║   465/tcp     ANY               eth0        SMTPS (Postfix)     ║
              ║   587/tcp     ANY               eth0        Submission          ║
              ║   993/tcp     ANY               eth0        IMAPS (Dovecot)     ║
              ║   995/tcp     ANY               eth0        POP3S (Dovecot)     ║
              ║  4190/tcp     ANY               eth0        ManageSieve         ║
              ║  ALL          100.64.0.0/10     tailscale0  Tailscale VPN       ║
              ║  ALL          172.16.0.0/12     docker br   Docker internal     ║
              ║  ALL          10.0.0.0/8        docker br   Docker internal     ║
              ║  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  ║
              ║  ELSE         ANY               ANY         → DENY (default)    ║
              ║                                                                 ║
              ╠════════════════════════════════════════════════════════════════╣
              ║  ROUTING:     DENY (no forwarding — single-homed server)       ║
              ║  OUTBOUND:    ALLOW ALL (no egress filtering)                  ║
              ╚════════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## SECURITY STACK — DEFENSE-IN-DEPTH LAYERS

```
═══════════════════════════════════════════════════════════════════════════════════════════
              DEFENSE-IN-DEPTH — 5 SECURITY LAYERS (Both Servers)
═══════════════════════════════════════════════════════════════════════════════════════════


 INTERNET THREATS (port scanners, brute force, spam, exploits)
          │
          ▼
╔═══════════════════════════════════════════════════════════════════════════════════╗
║  LAYER 1: PERIMETER — UFW + Fail2ban                                            ║
║  ═══════════════════════════════════════════════════════════════════════════════  ║
║                                                                                  ║
║  ┌─ MASTER ───────────────────────────┐  ┌─ LADY ────────────────────────────┐  ║
║  │ Policy: DROP all incoming          │  │ Policy: DENY all incoming         │  ║
║  │ Open:  1006,80,443,8443,           │  │ Open:  1006,80,443,25,465,       │  ║
║  │        51820,3478,41641            │  │        587,993,995,4190,41641    │  ║
║  │ Fail2ban: 5 IPs currently banned   │  │ Fail2ban: Active                 │  ║
║  │ Dropped: 88,388 packets (4.9 MB)   │  │                                  │  ║
║  └────────────────────────────────────┘  └──────────────────────────────────┘  ║
║                                                                                  ║
╚══════════════════════════════════╤════════════════════════════════════════════════╝
                                   │  ✓ PASSED perimeter
                                   ▼
╔══════════════════════════════════════════════════════════════════════════════════╗
║  LAYER 2: IPS — CrowdSec (Master + Lady)                                       ║
║  ════════════════════════════════════════════════════════════════════════════════║
║                                                                                 ║
║  Engine:          CrowdSec (community-driven threat intelligence)               ║
║  Master memory:   161.8 MiB                                                     ║
║  Lady memory:     133.4 MiB                                                     ║
║  Bouncer:         bouncer-traefik (blocks at reverse proxy level)               ║
║  Action:          403 Forbidden for known-bad IPs                               ║
║  Integration:     Traefik middleware → CrowdSec API                             ║
║                                                                                 ║
╚══════════════════════════════════╤══════════════════════════════════════════════╝
                                   │  ✓ PASSED IPS
                                   ▼
╔══════════════════════════════════════════════════════════════════════════════════╗
║  LAYER 3: REVERSE PROXY — Traefik (TLS Termination)                            ║
║  ════════════════════════════════════════════════════════════════════════════════║
║                                                                                 ║
║  Master:  172.18.0.18 (traefik network) + 172.30.0.6 (monitoring)              ║
║  Lady:    172.18.0.x (traefik network)                                          ║
║  TLS:     Let's Encrypt auto-renewal (ACME)                                    ║
║  Grade:   A+ (SSL Labs)                                                         ║
║  HSTS:    Enabled                                                               ║
║  Headers: X-Frame-Options, CSP, X-Content-Type                                 ║
║  Routes:  Host-header based routing to backend containers                      ║
║  Memory:  Master 54.4 MiB | Lady 61.3 MiB                                     ║
║                                                                                 ║
╚══════════════════════════════════╤══════════════════════════════════════════════╝
                                   │  ✓ PASSED TLS + headers
                                   ▼
╔══════════════════════════════════════════════════════════════════════════════════╗
║  LAYER 4: AUTHENTICATION — Authelia (Master only — 2FA + SSO)                  ║
║  ════════════════════════════════════════════════════════════════════════════════║
║                                                                                 ║
║  Container:   authelia (172.18.0.14)                                            ║
║  Memory:      85 MiB                                                            ║
║  Method:      TOTP (Time-based One-Time Password)                              ║
║  Session:     12h expiry, 1h inactivity timeout                                ║
║  Domain:      auth.quietly.its.me                                               ║
║  Protected:   Grafana, Prometheus, Portainer, and all admin panels             ║
║  Bypass:      Public services (landing page, fuckoff-page)                     ║
║  Storage:     SQLite (local)                                                    ║
║                                                                                 ║
╚══════════════════════════════════╤══════════════════════════════════════════════╝
                                   │  ✓ PASSED authentication
                                   ▼
╔══════════════════════════════════════════════════════════════════════════════════╗
║  LAYER 5: APPLICATION — Container Isolation                                    ║
║  ════════════════════════════════════════════════════════════════════════════════║
║                                                                                 ║
║  Master: 4 isolated Docker networks (traefik, monitoring, pihole, default)     ║
║  Lady:   7 isolated Docker networks (traefik, monitoring, nextcloud,           ║
║          odoo, unifi, portainer, mailcow)                                       ║
║  Containers can only reach peers on SAME network                               ║
║  Cross-network: Only via Traefik routing                                       ║
║  Volumes:  Bind mounts to ~/.docker/<service>/                                 ║
║  No --privileged except: cadvisor (read-only /), node-exporter (/proc,/sys)    ║
║                                                                                 ║
╚══════════════════════════════════════════════════════════════════════════════════╝

═══════════════════════════════════════════════════════════════════════════════════════════
```
