# CCIE DNS Architecture — Complete Resolution Chain

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Verified**: 2026-02-16 (ALL data from LIVE system)  
> **Standard**: Cisco CCIE-level documentation — every resolver, every zone, every record  
> **Scope**: Full DNS infrastructure across Master, Lady, Headscale, Cloudflare

---

## DNS INFRASTRUCTURE OVERVIEW

```
═══════════════════════════════════════════════════════════════════════════════════════════
    DNS ARCHITECTURE — 5 resolvers, 3 zones, split-horizon
    "If you don't understand DNS, you don't understand the network" — CCIE axiom
═══════════════════════════════════════════════════════════════════════════════════════════

                    ┌──────────────────────────────────────────────────────────┐
                    │              CLOUDFLARE (Public DNS)                     │
                    │              Registrar + Authoritative NS                │
                    │                                                          │
                    │   Zone: quietly.its.me                                   │
                    │     A    quietly.its.me        → 213.136.68.108         │
                    │     A    *.quietly.its.me      → 213.136.68.108         │
                    │     (Wildcard — all subdomains resolve to Master)        │
                    │                                                          │
                    │   Zone: quietly.online                                   │
                    │     A    quietly.online         → 207.180.251.111        │
                    │     A    *.quietly.online       → 207.180.251.111        │
                    │     MX   quietly.online         → mail.quietly.online    │
                    │     TXT  quietly.online         → v=spf1 ...            │
                    │     TXT  _dmarc.quietly.online  → v=DMARC1 ...          │
                    │     CNAME _domainkey            → DKIM keys             │
                    │     TXT  _mta-sts.quietly.online → v=STSv1 ...          │
                    │     CNAME autoconfig             → mail.quietly.online  │
                    │     SRV  _autodiscover            → mail:443            │
                    │                                                          │
                    │   Zone: qui3tly.cloud                                    │
                    │     (Headscale base_domain — MagicDNS)                   │
                    │     A    qui3tly.cloud          → 213.136.68.108 (?)    │
                    └──────────────────────┬───────────────────────────────────┘
                                           │
                    ┌──────────────────────┤──────────────────────┐
                    │                      │                      │
             PUBLIC INTERNET          VPN CLIENTS           MAIL STACK
                    │                      │                      │
                    ▼                      ▼                      ▼
     ┌─────────────────────┐ ┌──────────────────────┐ ┌──────────────────────┐
     │  Query from browser │ │ Query from VPN node  │ │ Query from Postfix   │
     │  (no VPN)           │ │ (Tailscale/WG)       │ │ (Mailcow internal)   │
     └─────────┬───────────┘ └──────────┬───────────┘ └──────────┬───────────┘
               │                        │                        │
               ▼                        ▼                        ▼
     ┌─────────────────┐    ┌────────────────────┐    ┌────────────────────┐
     │  Cloudflare      │    │  Pi-hole            │    │  unbound-mailcow   │
     │  1.1.1.1         │    │  (split-horizon)    │    │  (recursive)       │
     │                  │    │  100.64.0.1:53       │    │  172.28.1.x:53     │
     │  → Public IPs    │    │  10.10.0.1:53        │    │  → root hints      │
     │  213.136.68.108  │    │  → VPN IPs           │    │  → authoritative   │
     │  207.180.251.111 │    │  100.64.0.1          │    │  (no forwarding)   │
     │                  │    │  100.64.0.2          │    │                    │
     └─────────────────┘    └────────────────────┘    └────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## SPLIT-HORIZON DNS — THE CORE CONCEPT

```
═══════════════════════════════════════════════════════════════════════════════════════════
    SAME DOMAIN → DIFFERENT ANSWER depending on WHO asks
═══════════════════════════════════════════════════════════════════════════════════════════

    Query: grafana.quietly.its.me

    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                                                                             │
    │  FROM PUBLIC INTERNET (via Cloudflare):                                     │
    │  ─────────────────────────────────────                                      │
    │  grafana.quietly.its.me → 213.136.68.108 (Master public IP)                │
    │                                                                             │
    │  Path: Client → Cloudflare NS → A record → 213.136.68.108                  │
    │        → eth0 → iptables DNAT → Traefik → CrowdSec → Authelia → Grafana   │
    │  Encryption: TLS (Internet) + plaintext (container)                        │
    │  Latency: ~40-80ms (Internet RTT + TLS handshake)                          │
    │                                                                             │
    │  ═══════════════════════════════════════════════════                        │
    │                                                                             │
    │  FROM VPN CLIENT (via Pi-hole):                                             │
    │  ──────────────────────────────                                             │
    │  grafana.quietly.its.me → 100.64.0.1 (Master Tailscale IP)                 │
    │                                                                             │
    │  Path: Client → MagicDNS (100.100.100.100) → Headscale delegates          │
    │        → Pi-hole (100.64.0.1:53) → dnsmasq local record                   │
    │        → 100.64.0.1 → Tailscale mesh → Traefik → Grafana                  │
    │  Encryption: WireGuard (end-to-end) + TLS (Traefik)                        │
    │  Latency: ~10ms (direct Tailscale peer, no Internet)                       │
    │                                                                             │
    └─────────────────────────────────────────────────────────────────────────────┘

    WHY: VPN users bypass public Internet entirely. Shorter path, stronger
         encryption, lower latency, no CrowdSec/firewall traversal needed.

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## PI-HOLE DNS — Complete Record Set

```
═══════════════════════════════════════════════════════════════════════════════════════════
    PI-HOLE LOCAL DNS — /etc/dnsmasq.d/01-local-dns.conf
    Purpose: Split-horizon DNS for VPN clients
    Listening on: 100.64.0.1:53 (Tailnet) + 10.10.0.1:53 (WireGuard)
    Mode: FTLCONF_dns_listeningMode=all
    Upstream: cloudflared (172.70.9.2:5053) — DNS-over-HTTPS
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌─────────────────────────────────────────────────────────────────────────────┐
    │  DOMAIN                              RESOLVES TO     SERVER   PURPOSE      │
    │  ────────────────────────────────────────────────────────────────────────── │
    │                                                                             │
    │  ── MASTER SERVICES (quietly.its.me → 100.64.0.1) ──────────────────────── │
    │                                                                             │
    │  quietly.its.me                      100.64.0.1      Master   Base domain  │
    │  master.quietly.its.me               100.64.0.1      Master   Alias        │
    │  traefik.quietly.its.me              100.64.0.1      Master   Rev. proxy   │
    │  portainer.quietly.its.me            100.64.0.1      Master   Container UI │
    │  headscale.quietly.its.me            100.64.0.1      Master   VPN control  │
    │  headscale-ui.quietly.its.me         100.64.0.1      Master   VPN UI       │
    │  headscale-admin.quietly.its.me      100.64.0.1      Master   VPN admin    │
    │  pihole.quietly.its.me               100.64.0.1      Master   DNS UI       │
    │  gotify.quietly.its.me               100.64.0.1      Master   Push notify  │
    │  tools.quietly.its.me                100.64.0.1      Master   IT Tools     │
    │  it-tools.quietly.its.me             100.64.0.1      Master   IT Tools alt │
    │  admin.quietly.its.me                100.64.0.1      Master   Admin panel  │
    │  ansible.quietly.its.me              100.64.0.1      Master   Semaphore    │
    │  semaphore.quietly.its.me            100.64.0.1      Master   Semaphore alt│
    │  grafana.quietly.its.me              100.64.0.1      Master   Dashboards   │
    │  prometheus.quietly.its.me           100.64.0.1      Master   Metrics      │
    │  alertmanager.quietly.its.me         100.64.0.1      Master   Alerts       │
    │  loki.quietly.its.me                 100.64.0.1      Master   Logs         │
    │  auth.quietly.its.me                 100.64.0.1      Master   Authelia SSO │
    │  *.quietly.its.me (wildcard)         100.64.0.1      Master   Catch-all    │
    │                                                                             │
    │  ── LADY SERVICES (quietly.online → 100.64.0.2) ────────────────────────── │
    │                                                                             │
    │  lady.quietly.its.me                 100.64.0.2      Lady     Alias        │
    │  quietly.online                      100.64.0.2      Lady     Base domain  │
    │  nextcloud.quietly.online            100.64.0.2      Lady     Cloud files  │
    │  unifi.quietly.its.me                100.64.0.2      Lady     Network ctrl │
    │  traefik.quietly.online              100.64.0.2      Lady     Rev. proxy   │
    │  portainer.quietly.online            100.64.0.2      Lady     Container UI │
    │  crowdsec.quietly.online             100.64.0.2      Lady     IPS          │
    │  *.quietly.online (wildcard)         100.64.0.2      Lady     Catch-all    │
    │                                                                             │
    │  ── TAILNET NODES (qui3tly.cloud → Headscale MagicDNS) ─────────────────── │
    │                                                                             │
    │  master.qui3tly.cloud                100.64.0.1      Master   MagicDNS     │
    │  lady.qui3tly.cloud                  100.64.0.2      Lady     MagicDNS     │
    │  mac.qui3tly.cloud                   100.64.0.3      Mac      MagicDNS     │
    │  *.qui3tly.cloud (wildcard)          100.64.0.1      Master   Catch-all    │
    │                                                                             │
    └─────────────────────────────────────────────────────────────────────────────┘

    TOTAL: 24 explicit records + 3 wildcards = ALL services covered
    IPv6: DISABLED (FTLCONF_dns_blockIPv6=yes, FTLCONF_dns_IPVersionFilter=ipv4)

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## DNS RESOLUTION CHAIN — Every Possible Path

```
═══════════════════════════════════════════════════════════════════════════════════════════
    RESOLUTION CHAIN 1: VPN Client (Mac/Phone) → Full Path
═══════════════════════════════════════════════════════════════════════════════════════════

    [Mac Mini — 100.64.0.3]
         │
         │ DNS query: grafana.quietly.its.me
         │ Configured DNS: 100.100.100.100 (MagicDNS)
         │
         ▼
    ┌─ MagicDNS (Headscale) ──────────────────────────────────────────┐
    │  100.100.100.100 (virtual — handled by tailscaled)              │
    │                                                                  │
    │  Headscale config:                                               │
    │    magic_dns: true                                               │
    │    base_domain: qui3tly.cloud                                    │
    │    nameservers.global: [100.64.0.1]                              │
    │                                                                  │
    │  Decision:                                                       │
    │  • *.qui3tly.cloud → MagicDNS built-in (node resolution)       │
    │  • Everything else → forward to 100.64.0.1 (Pi-hole)           │
    └──────────────┬───────────────────────────────────────────────────┘
                   │
                   ▼
    ┌─ Pi-hole (172.70.9.3 / 100.64.0.1) ─────────────────────────────┐
    │  Pi-hole v5.x (Docker container on Master)                       │
    │  Network: pihole_internal (172.70.9.0/29)                        │
    │  Also on: traefik (172.18.0.7) for web UI                        │
    │  Memory: 99.3 MiB                                                │
    │                                                                   │
    │  Step 1: Check blocklist (gravity.db)                            │
    │          → Not blocked? Continue.                                │
    │                                                                   │
    │  Step 2: Check local DNS (/etc/dnsmasq.d/01-local-dns.conf)     │
    │          → Match: address=/grafana.quietly.its.me/100.64.0.1     │
    │          → RETURN: 100.64.0.1                                    │
    │                                                                   │
    │  Step 3 (if no local match): Forward to upstream                 │
    │          Upstream: 172.70.9.2#5053 (cloudflared)                 │
    └──────────────────────────────────────────────────────────────────┘

    RESULT: 100.64.0.1 → Direct Tailscale connection to Master


═══════════════════════════════════════════════════════════════════════════════════════════
    RESOLUTION CHAIN 2: WireGuard Client (Office LAN) → Full Path
═══════════════════════════════════════════════════════════════════════════════════════════

    [Office device — 192.168.99.x]
         │
         │ DNS query: grafana.quietly.its.me
         │ Configured DNS: 10.10.0.1 (Pi-hole via WireGuard)
         │ (EdgeRouter DHCP pushes 10.10.0.1 as DNS)
         │
         ▼
    ┌─ EdgeRouter X ───────────────────────────────────────────────────┐
    │  ● eth1.0: 192.168.99.1/24 (LAN gateway)                       │
    │  ● wg0: 10.10.0.2/30 (WireGuard tunnel)                        │
    │                                                                  │
    │  Route: 10.10.0.1 → via wg0 → Master                           │
    └──────────────┬───────────────────────────────────────────────────┘
                   │ WireGuard encrypted (ChaCha20-Poly1305)
                   ▼
    ┌─ Master ● wg0 (10.10.0.1/30) ───────────────────────────────────┐
    │  Decrypted: DNS query for grafana.quietly.its.me                │
    │  Destination: 10.10.0.1:53 (local)                              │
    │  Forward to: Pi-hole (172.70.9.3 via DNAT)                      │
    └──────────────┬───────────────────────────────────────────────────┘
                   │
                   ▼
    ┌─ Pi-hole ────────────────────────────────────────────────────────┐
    │  Same as Chain 1 from here                                       │
    │  Match: address=/grafana.quietly.its.me/100.64.0.1               │
    │  RETURN: 100.64.0.1                                              │
    └──────────────────────────────────────────────────────────────────┘

    RESULT: 100.64.0.1 → Client connects via WireGuard tunnel to Master


═══════════════════════════════════════════════════════════════════════════════════════════
    RESOLUTION CHAIN 3: Public Internet User → Full Path
═══════════════════════════════════════════════════════════════════════════════════════════

    [Public user browser]
         │
         │ DNS query: grafana.quietly.its.me
         │ DNS server: any public resolver (8.8.8.8, 1.1.1.1, ISP)
         │
         ▼
    ┌─ Recursive resolver → Cloudflare Authoritative NS ──────────────┐
    │  NS: *.ns.cloudflare.com                                         │
    │  Zone: quietly.its.me                                            │
    │  Record: *.quietly.its.me → A 213.136.68.108                     │
    │  RETURN: 213.136.68.108                                          │
    └──────────────────────────────────────────────────────────────────┘

    RESULT: 213.136.68.108 → Public Internet path to Master eth0


═══════════════════════════════════════════════════════════════════════════════════════════
    RESOLUTION CHAIN 4: Master Host OS → Full Path (BOOTSTRAP)
═══════════════════════════════════════════════════════════════════════════════════════════

    [Master OS — needs DNS for apt, NTP, ACME, etc.]
         │
         │ /etc/resolv.conf (IMMUTABLE — chattr +i):
         │   nameserver 1.1.1.1
         │   nameserver 8.8.8.8
         │
         │ WHY IMMUTABLE: Bootstrap problem. Pi-hole is a Docker container.
         │ If resolv.conf pointed to Pi-hole (which runs inside Docker),
         │ and Docker needed DNS to pull images... circular dependency.
         │ Solution: Host ALWAYS uses Cloudflare directly. Period.
         │
         ▼
    ┌─ Cloudflare Public DNS ──────────────────────────────────────────┐
    │  1.1.1.1 (primary) / 8.8.8.8 (fallback)                         │
    │  Direct UDP/53 from eth0 (213.136.68.108)                        │
    │  No encryption (standard DNS)                                    │
    │  No ad-blocking, no split-horizon — raw public DNS               │
    └──────────────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════════════════════
    RESOLUTION CHAIN 5: Lady Host OS → Full Path
═══════════════════════════════════════════════════════════════════════════════════════════

    [Lady OS — 207.180.251.111]
         │
         │ /etc/resolv.conf:
         │   nameserver 100.64.0.1       ← Pi-hole via Tailscale!
         │   nameserver 1.1.1.1          ← Fallback
         │   search qui3tly.cloud        ← MagicDNS search domain
         │
         │ NOTE: Lady CAN use Pi-hole because Tailscale is a host-level
         │ service, not Docker. No bootstrap problem here.
         │
         ▼
    ┌─ tailscale0 (100.64.0.2) → Master (100.64.0.1:53) ─────────────┐
    │  Encrypted via Tailscale mesh (WireGuard)                        │
    │  → Pi-hole → dnsmasq local match OR cloudflared upstream         │
    └──────────────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════════════════════
    RESOLUTION CHAIN 6: Mailcow Stack (Postfix/Rspamd) → Full Path
═══════════════════════════════════════════════════════════════════════════════════════════

    [Postfix / Rspamd — needs DNS for MX, SPF, DKIM, DMARC lookups]
         │
         │ Configured DNS: unbound-mailcow (172.28.1.x:53)
         │ (Internal to br-mailcow network 172.28.1.0/24)
         │
         ▼
    ┌─ unbound-mailcow (172.28.1.x) ──────────────────────────────────┐
    │  RECURSIVE resolver — does NOT forward to Pi-hole or cloudflared│
    │  Uses root hints → iterative resolution from root NS down       │
    │  Memory: 33.3 MiB                                               │
    │                                                                  │
    │  Access control (from unbound.conf):                             │
    │  • 10.0.0.0/8 allow                                              │
    │  • 172.16.0.0/12 allow                                           │
    │  • 192.168.0.0/16 allow                                          │
    │  • fc00::/7 allow (IPv6 ULA)                                     │
    │  • fe80::/10 allow (IPv6 link-local)                             │
    │                                                                  │
    │  Cache: min-ttl=5s, max-negative-ttl=60s                        │
    │  IPv4+IPv6: do-ip4=yes, do-ip6=yes                              │
    │  TCP+UDP: do-tcp=yes, do-udp=yes                                │
    │  Logging: verbosity=1, to /dev/console                          │
    │                                                                  │
    │  WHY SEPARATE: Mail DNS must be authoritative and untampered.    │
    │  Pi-hole ad-blocking could interfere with mail delivery.         │
    │  unbound goes direct to root → TLD → authoritative NS.          │
    └──────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## CLOUDFLARED — DNS-over-HTTPS Upstream

```
═══════════════════════════════════════════════════════════════════════════════════════════
    CLOUDFLARED — Pi-hole's encrypted upstream
    Container: cloudflared (172.70.9.2)
    Network: pihole_internal (172.70.9.0/29)
    Memory: 19.9 MiB
    Image: cloudflare/cloudflared:2024.12.2
═══════════════════════════════════════════════════════════════════════════════════════════

    Pi-hole → cloudflared (172.70.9.2:5053)
                  │
                  │  TUNNEL_DNS_PORT=5053
                  │  TUNNEL_DNS_ADDRESS=0.0.0.0
                  │  TUNNEL_DNS_UPSTREAM:
                  │    1. https://1.1.1.1/dns-query     (Cloudflare primary)
                  │    2. https://1.0.0.1/dns-query     (Cloudflare secondary)
                  │    3. https://9.9.9.9/dns-query     (Quad9 — fallback)
                  │
                  │  Transport: DNS-over-HTTPS (DoH)
                  │  TLS cert: /etc/ssl/certs/ca-certificates.crt
                  │  Outgoing via: MASQUERADE → eth0 (213.136.68.108)
                  │
                  ▼
    ┌─ Internet (encrypted HTTPS) ─────────────────────────────────────┐
    │  1.1.1.1 / 1.0.0.1 / 9.9.9.9                                    │
    │  Query encrypted in TLS 1.3 — ISP cannot see DNS queries         │
    │  Response: plaintext to cloudflared → Pi-hole → client           │
    └──────────────────────────────────────────────────────────────────┘

    PACKET PATH (MASQUERADE stats from iptables):
    Pi-hole → cloudflared: 172.70.9.3 → 172.70.9.2 (same /29 bridge)
    cloudflared → Internet: MASQUERADE through pihole_internal bridge
    NAT POSTROUTING: 5,011,422 packets matched (busiest MASQ rule!)

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## HEADSCALE MagicDNS INTEGRATION

```
═══════════════════════════════════════════════════════════════════════════════════════════
    HEADSCALE DNS CONFIG — /etc/headscale/config.yaml (Native systemd service)
═══════════════════════════════════════════════════════════════════════════════════════════

    dns:
      magic_dns: true                    ← Enables MagicDNS
      base_domain: qui3tly.cloud         ← Node FQDNs: <node>.qui3tly.cloud
      nameservers:
        global:
          - 100.64.0.1                   ← Pi-hole for all non-MagicDNS queries
      search_domains: []                 ← No additional search domains
      extra_records: []                  ← No additional records (all in Pi-hole)

    HOW IT WORKS:
    ┌──────────────────────────────────────────────────────────────────────────┐
    │                                                                          │
    │  1. Tailscale client sets DNS to 100.100.100.100 (virtual MagicDNS)    │
    │                                                                          │
    │  2. Query arrives at tailscaled (local Tailscale daemon)               │
    │                                                                          │
    │  3. Is it *.qui3tly.cloud?                                              │
    │     YES → Headscale resolves from its node registry:                    │
    │           master.qui3tly.cloud → 100.64.0.1                             │
    │           lady.qui3tly.cloud   → 100.64.0.2                             │
    │           mac.qui3tly.cloud    → 100.64.0.3                             │
    │                                                                          │
    │  4. Is it anything else?                                                │
    │     YES → Forward to global nameserver: 100.64.0.1 (Pi-hole)           │
    │           Pi-hole handles: split-horizon + ad-blocking + upstream DoH   │
    │                                                                          │
    │  5. Lady's resolv.conf uses "search qui3tly.cloud"                      │
    │     → Short names auto-append: "master" → "master.qui3tly.cloud"       │
    │                                                                          │
    └──────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## DNS RESOLUTION SUMMARY TABLE

```
═══════════════════════════════════════════════════════════════════════════════════════════

    WHO ASKS?          DNS SERVER     ENCRYPTED?     RESULT TYPE       BOOTSTRAP
    ────────────────   ────────────   ────────────   ───────────────   ──────────
    VPN client         100.100.100.100 WireGuard     Split-horizon     Tailscale
    (Tailscale)        → Pi-hole       (tunnel)      VPN IPs (100.64)  daemon
                       → cloudflared   DoH (HTTPS)

    WG client          10.10.0.1      WireGuard      Split-horizon     WireGuard
    (Office LAN)       → Pi-hole      (tunnel)       VPN IPs (100.64)  tunnel
                       → cloudflared  DoH (HTTPS)

    Public Internet    Cloudflare NS  None (UDP/53)  Public IPs        N/A
                       (recursive)                   (213.x, 207.x)

    Master host OS     1.1.1.1        None (UDP/53)  Public IPs        IMMUTABLE
                       8.8.8.8                       (raw Internet)    resolv.conf

    Lady host OS       100.64.0.1     WireGuard      Split-horizon     Tailscale
                       1.1.1.1 (fb)   (Tailscale)    + fallback        daemon

    Mailcow stack      unbound        None (local)   Recursive from    Docker
    (Postfix,Rspamd)   172.28.1.x     container net  root hints        network

═══════════════════════════════════════════════════════════════════════════════════════════
    DESIGN RATIONALE:
    • Master resolv.conf = IMMUTABLE → prevents circular Docker/DNS dependency
    • Pi-hole handles split-horizon → VPN clients get optimal paths
    • cloudflared encrypts upstream → ISP cannot snoop DNS queries
    • unbound-mailcow = isolated → ad-blocking never touches mail DNS
    • Wildcards (*.quietly.its.me, *.quietly.online) = future-proof
═══════════════════════════════════════════════════════════════════════════════════════════
```
