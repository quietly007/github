# CCIE Network Topology — Complete Infrastructure Map

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Verified**: 2026-02-16 (ALL data from LIVE system — Rule #0 applied)  
> **Standard**: Cisco CCIE-level documentation  
> **Scope**: ALL interfaces, ALL IPs, ALL subnets, ALL MACs, ALL MTUs

---

## COMPLETE PHYSICAL + VIRTUAL TOPOLOGY (Cisco/Visio Style)

```
═══════════════════════════════════════════════════════════════════════════════════════════════════════
                        qui3tly.cloud — COMPLETE NETWORK TOPOLOGY
                        Verified: 2026-02-16 | All data from live system
═══════════════════════════════════════════════════════════════════════════════════════════════════════


                                    ┌─────────────────────────┐
                                    │    ☁  PUBLIC INTERNET   │
                                    │    BGP / IPv4 Only      │
                                    │    Routing: Best-path   │
                                    └────────┬───────┬────────┘
                                             │       │
                              ┌──────────────┘       └──────────────┐
                              │                                     │
                    ╔═════════╧═══════════════════════╗   ╔════════╧══════════════════════╗
                    ║  CONTABO GERMANY (Frankfurt)    ║   ║  CONTABO GERMANY (Nuremberg)  ║
                    ║  AS51167 — Contabo GmbH         ║   ║  AS51167 — Contabo GmbH       ║
                    ╚═════════╤═══════════════════════╝   ╚════════╤══════════════════════╝
                              │                                     │
┌─────────────────────────────┤─────────────────────────────────────┤─────────────────────────────────┐
│                             │                                     │                                 │
│  ═══════════════════════════╧═════════════════════════╗           │                                 │
│  ╔════════════════════════════════════════════════════╣           │                                 │
│  ║          MASTER SERVER — quietly.its.me            ║           │                                 │
│  ║          Role: Control Plane + Services            ║           │                                 │
│  ║          OS: Debian 12 (bookworm)                  ║           │                                 │
│  ║          Kernel: Linux 6.x                         ║           │                                 │
│  ║          CPU: 12 vCPU (KVM/QEMU)                   ║           │                                 │
│  ║          RAM: 47 GiB (48 GB nominal)               ║           │                                 │
│  ║          Disk: 985 GB NVMe (/dev/sda1) [3% used]   ║           │                                 │
│  ║          Containers: 25 running                    ║           │                                 │
│  ╚════════════════════════════════════════════════════╝           │                                 │
│                                                                   │                                 │
│  ┌─ ● eth0 (Physical Ethernet — WAN) ─────────────────────────┐  │                                 │
│  │  TYPE:         Physical (virtio — KVM paravirtualized)      │  │                                 │
│  │  Alt Name:     enp0s18                                      │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  IPv4 Address: 213.136.68.108/24                            │  │                                 │
│  │  Subnet Mask:  255.255.255.0 (256 hosts, 254 usable)       │  │                                 │
│  │  Broadcast:    213.136.68.255                               │  │                                 │
│  │  Gateway:      213.136.68.1 (Contabo upstream router)      │  │                                 │
│  │  MAC Address:  00:50:56:5f:34:33                            │  │                                 │
│  │  MTU:          1500 bytes                                   │  │                                 │
│  │  Speed:        1 Gbps (virtio)                              │  │                                 │
│  │  Duplex:       Full                                         │  │                                 │
│  │  Queue Length: 1000                                         │  │                                 │
│  │  State:        UP/UP (Physical + Protocol)                  │  │                                 │
│  │  Flags:        BROADCAST,MULTICAST,UP,LOWER_UP              │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  DNS:          1.1.1.1 (resolv.conf — IMMUTABLE)            │  │                                 │
│  │                ⚠ NEVER 100.100.100.100 (boot crash loop!)  │  │                                 │
│  │  Provider:     Contabo GmbH, Frankfurt, Germany             │  │                                 │
│  │  Purpose:      Public internet ingress/egress               │  │                                 │
│  │  Binds:        SSH(1006), HTTP(80), HTTPS(443),             │  │                                 │
│  │                WireGuard(51820/udp), Headscale(8443),       │  │                                 │
│  │                DERP(3478/udp), Tailscale(41641/udp)         │  │                                 │
│  └─────────────────────────────────────────────────────────────┘  │                                 │
│                             │                                     │                                 │
│  ┌─ ● wg0 (Virtual — WireGuard Point-to-Point) ───────────────┐  │                                 │
│  │  TYPE:         Virtual (WireGuard kernel module)            │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  IPv4 Address: 10.10.0.1/30                                 │  │                                 │
│  │  Subnet Mask:  255.255.255.252 (4 IPs — 2 usable)          │  │                                 │
│  │  Network:      10.10.0.0 — 10.10.0.3                       │  │                                 │
│  │  Local:        10.10.0.1 (this host)                        │  │                                 │
│  │  Peer:         10.10.0.2 (EdgeRouter X)                     │  │                                 │
│  │  MTU:          1420 bytes (80 byte WireGuard overhead)      │  │                                 │
│  │  Queue Length: 1000                                         │  │                                 │
│  │  State:        UNKNOWN (normal for P2P — no carrier detect) │  │                                 │
│  │  Flags:        POINTOPOINT,NOARP,UP,LOWER_UP                │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  Listen Port:  51820/udp                                    │  │                                 │
│  │  Public Key:   wal/0u2DXphxjbMSt2mZDsp0pFWhzaffRaOOnv3LiB4=│  │                                 │
│  │  Peer Key:     G72JPy0epHT2c/pNrlUee6REpkSf3nYv9ej6zNoU7EA=│  │                                 │
│  │  Endpoint:     62.4.55.119:38340 (EdgeRouter dynamic WAN)  │  │                                 │
│  │  Allowed IPs:  10.10.0.0/30, 192.168.99.0/24               │  │                                 │
│  │  Keepalive:    25 seconds                                   │  │                                 │
│  │  Last Shake:   ~1 minute ago (active tunnel)                │  │                                 │
│  │  TX/RX:        184.77 MiB sent / 156.26 MiB received       │  │                                 │
│  │  Encryption:   ChaCha20-Poly1305                            │  │                                 │
│  │  Protocol:     Noise_IKpsk2 (WireGuard)                     │  │                                 │
│  │  Purpose:      Home LAN gateway (192.168.99.0/24 access)   │  │                                 │
│  └─────────────────────────────────────────────────────────────┘  │                                 │
│                             │                                     │                                 │
│  ┌─ ● tailscale0 (Virtual — Tailscale/WireGuard Mesh) ────────┐  │                                 │
│  │  TYPE:         Virtual (Tailscale userspace + kernel WG)    │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  IPv4 Address: 100.64.0.1/32                                │  │                                 │
│  │  Subnet Mask:  255.255.255.255 (host route — P2P mesh)     │  │                                 │
│  │  CGNAT Range:  100.64.0.0/10 (RFC 6598)                    │  │                                 │
│  │  MTU:          1280 bytes (WireGuard + Tailscale overhead)  │  │                                 │
│  │  Queue Length: 500                                          │  │                                 │
│  │  State:        UNKNOWN (normal for P2P)                     │  │                                 │
│  │  Flags:        POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP      │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  Control Plane: Headscale (NATIVE systemd — NOT Docker)     │  │                                 │
│  │  DERP Relay:    3478/udp (fallback relay)                   │  │                                 │
│  │  Direct Port:   41641/udp (UDP hole-punch)                  │  │                                 │
│  │  Encryption:    ChaCha20-Poly1305                           │  │                                 │
│  │  ──────────────────────────────────────────────────────────  │  │                                 │
│  │  Peer: lady    100.64.0.2  ACTIVE  direct 207.180.251.111  │  │                                 │
│  │        TX: 617,291,396 bytes | RX: 5,038,203,460 bytes     │  │                                 │
│  │  Peer: mac     100.64.0.3  ACTIVE  direct 85.94.110.9      │  │                                 │
│  │        TX: 486,866,076 bytes | RX: 1,019,417,980 bytes     │  │                                 │
│  │  Purpose:      Server-to-server encrypted mesh VPN          │  │                                 │
│  └─────────────────────────────────────────────────────────────┘  │                                 │
│                                                                   │                                 │
│  ┌─ ● docker0 (Virtual — Default Docker Bridge) ──────────────┐   │                                 │
│  │  TYPE:         Linux Bridge (802.1D)                        │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  IPv4 Address: 172.17.0.1/16                                │   │                                 │
│  │  Subnet Mask:  255.255.0.0 (65,536 IPs)                    │   │                                 │
│  │  Broadcast:    172.17.255.255                               │   │                                 │
│  │  MAC Address:  4a:8d:2a:de:ca:24                            │   │                                 │
│  │  MTU:          1500 bytes                                   │   │                                 │
│  │  State:        DOWN (NO-CARRIER — no containers on default) │   │                                 │
│  │  STP:          Disabled (stp_state 0)                       │   │                                 │
│  │  Purpose:      Unused fallback bridge (all containers       │   │                                 │
│  │                use named networks below)                    │   │                                 │
│  └─────────────────────────────────────────────────────────────┘   │                                 │
│                                                                   │                                 │
│  ┌─ ● br-fb776b4784ae "traefik" (Docker Bridge) ──────────────┐   │                                 │
│  │  TYPE:         Linux Bridge (802.1D)                        │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  IPv4 Address: 172.18.0.1/16                                │   │                                 │
│  │  Broadcast:    172.18.255.255                               │   │                                 │
│  │  MAC Address:  5e:b0:ae:ec:06:ca                            │   │                                 │
│  │  MTU:          1500 bytes                                   │   │                                 │
│  │  State:        UP (20 containers connected)                 │   │                                 │
│  │  STP:          Disabled                                     │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  Connected Containers (verified IPs):                       │   │                                 │
│  │    it-tools        172.18.0.2/16                            │   │                                 │
│  │    crowdsec        172.18.0.3/16                            │   │                                 │
│  │    portainer       172.18.0.4/16                            │   │                                 │
│  │    admin-panel     172.18.0.5/16                            │   │                                 │
│  │    default-landing 172.18.0.6/16                            │   │                                 │
│  │    pihole          172.18.0.7/16                            │   │                                 │
│  │    bouncer-traefik 172.18.0.8/16                            │   │                                 │
│  │    semaphore       172.18.0.9/16                            │   │                                 │
│  │    fuckoff-page    172.18.0.10/16                           │   │                                 │
│  │    ntfy            172.18.0.11/16                           │   │                                 │
│  │    headscale-ui    172.18.0.12/16                           │   │                                 │
│  │    gotify          172.18.0.13/16                           │   │                                 │
│  │    authelia        172.18.0.14/16                           │   │                                 │
│  │    prometheus      172.18.0.15/16                           │   │                                 │
│  │    headscale-admin 172.18.0.16/16                           │   │                                 │
│  │    loki            172.18.0.17/16                           │   │                                 │
│  │    traefik         172.18.0.18/16                           │   │                                 │
│  │    alertmanager    172.18.0.19/16                           │   │                                 │
│  │    uptime-kuma     172.18.0.20/16                           │   │                                 │
│  │    grafana         172.18.0.21/16                           │   │                                 │
│  │  NAT:  MASQUERADE to eth0 (outbound)                       │   │                                 │
│  └─────────────────────────────────────────────────────────────┘   │                                 │
│                                                                   │                                 │
│  ┌─ ● br-0341e55be098 "monitoring" (Docker Bridge) ───────────┐   │                                 │
│  │  TYPE:         Linux Bridge (802.1D)                        │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  IPv4 Address: 172.30.0.1/24                                │   │                                 │
│  │  Broadcast:    172.30.0.255                                 │   │                                 │
│  │  MAC Address:  1a:fa:54:48:5f:8a                            │   │                                 │
│  │  MTU:          1500 bytes                                   │   │                                 │
│  │  State:        UP (12 containers connected)                 │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  Connected Containers (verified IPs):                       │   │                                 │
│  │    prometheus      172.30.0.2/24                            │   │                                 │
│  │    blackbox        172.30.0.3/24                            │   │                                 │
│  │    loki            172.30.0.4/24                            │   │                                 │
│  │    cadvisor        172.30.0.5/24                            │   │                                 │
│  │    traefik         172.30.0.6/24                            │   │                                 │
│  │    node-exporter   172.30.0.7/24                            │   │                                 │
│  │    alertmanager    172.30.0.8/24                            │   │                                 │
│  │    uptime-kuma     172.30.0.9/24                            │   │                                 │
│  │    promtail        172.30.0.10/24                           │   │                                 │
│  │    grafana         172.30.0.11/24                           │   │                                 │
│  │    ntfy            172.30.0.12/24                           │   │                                 │
│  │    gotify          172.30.0.13/24                           │   │                                 │
│  │  NAT:  MASQUERADE to eth0 (outbound)                       │   │                                 │
│  └─────────────────────────────────────────────────────────────┘   │                                 │
│                                                                   │                                 │
│  ┌─ ● br-ca56054321aa "pihole_internal" (Docker Bridge) ──────┐   │                                 │
│  │  TYPE:         Linux Bridge (802.1D)                        │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  IPv4 Address: 172.70.9.1/29                                │   │                                 │
│  │  Broadcast:    172.70.9.7                                   │   │                                 │
│  │  Subnet:       .0—.7 (8 IPs, 6 usable)                     │   │                                 │
│  │  MAC Address:  0a:15:e6:9c:b1:1c                            │   │                                 │
│  │  MTU:          1500 bytes                                   │   │                                 │
│  │  State:        UP (2 containers)                            │   │                                 │
│  │  ──────────────────────────────────────────────────────────  │   │                                 │
│  │  Connected Containers:                                      │   │                                 │
│  │    cloudflared     172.70.9.2/29  (DNS-over-HTTPS proxy)    │   │                                 │
│  │    pihole          172.70.9.3/29  (DNS sinkhole + cache)    │   │                                 │
│  │  NAT:  MASQUERADE to eth0 (outbound)                       │   │                                 │
│  │  DNAT: 10.10.0.1:53 → 172.70.9.3:53 (WG DNS)              │   │                                 │
│  │  DNAT: 100.64.0.1:53 → 172.70.9.3:53 (TS DNS)             │   │                                 │
│  └─────────────────────────────────────────────────────────────┘   │                                 │
│                                                                   │                                 │
│  ┌─ ● lo (Loopback) ──────────────────────────────────────────┐   │                                 │
│  │  IPv4: 127.0.0.1/8  |  MTU: 65536  |  State: UP           │   │                                 │
│  └─────────────────────────────────────────────────────────────┘   │                                 │
│                                                                   │                                 │
│  NATIVE SYSTEMD SERVICES (NOT Docker):                            │                                 │
│  ┌────────────────────────────────────────────────────────────┐    │                                 │
│  │  ● headscale   — VPN control plane (0.0.0.0:8080)         │    │                                 │
│  │  ● tailscaled  — Tailscale daemon                         │    │                                 │
│  │  ● sshd        — OpenSSH (port 1006)                      │    │                                 │
│  │  ● wg-quick    — WireGuard (wg0)                          │    │                                 │
│  │  ● fail2ban    — Intrusion prevention                     │    │                                 │
│  │  ● ufw         — Firewall frontend                        │    │                                 │
│  └────────────────────────────────────────────────────────────┘    │                                 │
│                                                                   │                                 │
└───────────────────────────────────────────────────────────────────┘                                 │
                              │                                                                       │
          ┌───────WireGuard───┘                                                                       │
          │     10.10.0.0/30                                                                          │
          │     ChaCha20-Poly1305                                                                     │
          │     UDP 51820                                                                             │
          │                                    ┌───────Tailscale Mesh───┐                             │
          │                                    │     100.64.0.0/10      │                             │
          │                                    │     ChaCha20-Poly1305  │                             │
          │                                    │     UDP 41641          │                             │
          │                                    │                        │                             │
          │                                    │                        │                             │
┌─────────┤────────────────────────────────────┤────────────────────────┤─────────────────────────────┐
│         │                                    │                        │                             │
│  ╔══════╧════════════════════════════════════╧═══════════════════════╧══════════════════════╗       │
│  ║                    LADY SERVER — quietly.online                                         ║       │
│  ║                    Role: Workloads (Mail, Apps, IoT)                                    ║       │
│  ║                    OS: Debian 12 (bookworm)                                             ║       │
│  ║                    CPU: 12 vCPU (KVM/QEMU)                                              ║       │
│  ║                    RAM: 47 GiB (48 GB nominal) [9.6 GiB used]                           ║       │
│  ║                    Disk: 985 GB NVMe (/dev/sda1) [7% used]                              ║       │
│  ║                    Containers: 39 running                                               ║       │
│  ╚═════════════════════════════════════════════════════════════════════════════════════════╝       │
│                                                                                                    │
│  ┌─ ● eth0 (Physical Ethernet — WAN) ─────────────────────────┐                                    │
│  │  TYPE:         Physical (virtio — KVM paravirtualized)      │                                    │
│  │  Alt Name:     enp0s18                                      │                                    │
│  │  ──────────────────────────────────────────────────────────  │                                    │
│  │  IPv4 Address: 207.180.251.111/18                           │                                    │
│  │  Subnet Mask:  255.255.192.0 (16,384 hosts)                │                                    │
│  │  Broadcast:    207.180.255.255                              │                                    │
│  │  Gateway:      207.180.192.1 (Contabo upstream router)     │                                    │
│  │  MAC Address:  00:50:56:5f:34:39                            │                                    │
│  │  MTU:          1500 bytes                                   │                                    │
│  │  Speed:        1 Gbps (virtio)                              │                                    │
│  │  State:        UP/UP                                        │                                    │
│  │  ──────────────────────────────────────────────────────────  │                                    │
│  │  DNS:          100.100.100.100 (MagicDNS via Headscale)     │                                    │
│  │                1.1.1.1 (Cloudflare fallback)                │                                    │
│  │  Provider:     Contabo GmbH, Nuremberg, Germany             │                                    │
│  │  Binds:        SSH(1006), HTTP(80), HTTPS(443),             │                                    │
│  │                SMTP(25), SMTPS(465), Submission(587),       │                                    │
│  │                IMAPS(993), POP3S(995), ManageSieve(4190),   │                                    │
│  │                Tailscale(41641/udp), Mosh(60000-61000/udp)  │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│  ┌─ ● tailscale0 (Virtual — Tailscale/WireGuard Mesh) ────────┐                                    │
│  │  IPv4 Address: 100.64.0.2/32                                │                                    │
│  │  MTU:          1280 bytes                                   │                                    │
│  │  State:        UNKNOWN (normal for P2P)                     │                                    │
│  │  ──────────────────────────────────────────────────────────  │                                    │
│  │  Peer: master  100.64.0.1  ACTIVE  direct 213.136.68.108   │                                    │
│  │        TX: 5,086,188,332 bytes | RX: 596,257,148 bytes     │                                    │
│  │  Peer: mac     100.64.0.3  ACTIVE  direct 85.94.110.9      │                                    │
│  │        TX: 11,259,964 bytes  | RX: 3,500,612 bytes         │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│  ┌─ ● docker0 (Default Bridge — UNUSED) ──────────────────────┐                                    │
│  │  IPv4: 172.17.0.1/16 | MAC: 6e:b5:c5:c3:6e:8c | DOWN      │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│  Docker Networks (all UP, all /16):                                                                │
│  ┌─────────────────────────────────────────────────────────────┐                                    │
│  │  ● br-64228b449149 "traefik"          172.18.0.1/16        │                                    │
│  │  ● br-12d346c9fe84 "monitoring"       172.19.0.1/16        │                                    │
│  │  ● br-8304b566c6f6 "nextcloud"        172.20.0.1/16        │                                    │
│  │  ● br-f9e210a1a2f7 "portainer-agent"  172.21.0.1/16        │                                    │
│  │  ● br-f49159028a5d "odoo-internal"    172.22.0.1/16        │                                    │
│  │  ● br-f55304df6a53 "unifi"            172.23.0.1/16        │                                    │
│  │  ● br-mailcow      "mailcow-network" 172.28.1.1/24        │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│  39 Containers:                                                                                    │
│  ┌──────────────────────────────────────────────────┐                                              │
│  │ INFRASTRUCTURE (3):                              │                                              │
│  │   traefik, bouncer-traefik, crowdsec             │                                              │
│  │ EMAIL — Mailcow (18):                            │                                              │
│  │   postfix, dovecot, rspamd, sogo, nginx,         │                                              │
│  │   mysql, redis, unbound, php-fpm, acme,          │                                              │
│  │   olefy, watchdog, clamd, netfilter,             │                                              │
│  │   postfix-tlspol, memcached, dockerapi, ofelia   │                                              │
│  │ APPLICATIONS (8):                                │                                              │
│  │   nextcloud, nextcloud-db, nextcloud-redis,      │                                              │
│  │   odoo, odoo-db, onlyoffice-documentserver,      │                                              │
│  │   mta-sts, fuckoff-page                          │                                              │
│  │ IoT / NETWORK (5):                               │                                              │
│  │   unifi, unifi-db, homeassistant, frigate, uisp  │                                              │
│  │ MONITORING (5):                                  │                                              │
│  │   node-exporter, cadvisor, mysqld-exporter,      │                                              │
│  │   promtail, portainer-agent                      │                                              │
│  └──────────────────────────────────────────────────┘                                              │
│                                                                                                    │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘
          │
          │  WireGuard P2P Tunnel
          │  10.10.0.0/30
          │  UDP 51820
          │  ChaCha20-Poly1305
          │  Keepalive: 25s
          │
┌─────────┤──────────────────────────────────────────────────────────────────────────────────────────┐
│         │                                                                                          │
│  ╔══════╧══════════════════════════════════════════════════════════════════════════════════╗        │
│  ║                    EDGEROUTER X — edge.qui3tly.cloud                                   ║        │
│  ║                    Role: Home Gateway + WireGuard Endpoint                             ║        │
│  ║                    OS: EdgeOS (Vyatta fork)                                            ║        │
│  ║                    CPU: MIPS (MediaTek MT7621)                                          ║        │
│  ║                    RAM: 256 MB                                                         ║        │
│  ╚════════════════════════════════════════════════════════════════════════════════════════╝        │
│                                                                                                    │
│  ┌─ ● eth0 (WAN — ISP Uplink) ────────────────────────────────┐                                    │
│  │  IPv4 Address: Dynamic (DHCP from ISP)                      │                                    │
│  │  Current:      62.4.55.119 (ISP — dynamic)                  │                                    │
│  │  MTU:          1500 bytes                                   │                                    │
│  │  State:        UP/UP                                        │                                    │
│  │  Purpose:      Internet uplink                              │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│  ┌─ ● eth1.0 (LAN — Home Network) ────────────────────────────┐                                    │
│  │  IPv4 Address: 192.168.99.1/24                              │                                    │
│  │  Subnet Mask:  255.255.255.0 (254 usable hosts)            │                                    │
│  │  MTU:          1500 bytes                                   │                                    │
│  │  State:        UP/UP                                        │                                    │
│  │  DHCP Server:  192.168.99.100 — 192.168.99.250             │                                    │
│  │  DNS:          10.10.0.1 (Pi-hole via WireGuard)            │                                    │
│  │  Purpose:      Home LAN gateway                             │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│  ┌─ ● wg0 (WireGuard Tunnel to Master) ───────────────────────┐                                    │
│  │  IPv4 Address: 10.10.0.2/30                                 │                                    │
│  │  Peer:         10.10.0.1 (Master)                           │                                    │
│  │  Endpoint:     213.136.68.108:51820                         │                                    │
│  │  MTU:          1420 bytes                                   │                                    │
│  │  Allowed IPs:  0.0.0.0/0 (all traffic via Master)          │                                    │
│  │  Keepalive:    25 seconds                                   │                                    │
│  │  Purpose:      Full tunnel to Master (DNS + VPN access)     │                                    │
│  └─────────────────────────────────────────────────────────────┘                                    │
│                                                                                                    │
│                    ─────────────── LAN ───────────────                                              │
│                    │               │                │                                               │
│              ┌─────┴─────┐   ┌─────┴─────┐   ┌─────┴─────┐                                        │
│              │  Mac Mini │   │  Phones   │   │  IoT      │                                        │
│              │ 100.64.0.3│   │  DHCP     │   │  Devices  │                                        │
│              │ 192.168.  │   │  192.168. │   │  192.168. │                                        │
│              │ 99.x      │   │  99.x     │   │  99.x     │                                        │
│              └───────────┘   └───────────┘   └───────────┘                                        │
│                                                                                                    │
└────────────────────────────────────────────────────────────────────────────────────────────────────┘


═══════════════════════════════════════════════════════════════════════════════════════════════════════
                                    INTERCONNECTION MATRIX
═══════════════════════════════════════════════════════════════════════════════════════════════════════

Source           Destination       Transport        Interface Out    Next Hop         Encryption
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Master eth0   →  Internet          Direct           eth0            213.136.68.1      None (TLS app)
Master eth0   →  Lady eth0         Internet         eth0            213.136.68.1      TLS (app layer)
Master ts0    →  Lady ts0          Tailscale mesh   tailscale0      100.64.0.2        ChaCha20
Master ts0    →  Mac ts0           Tailscale mesh   tailscale0      100.64.0.3        ChaCha20
Master wg0    →  EdgeRouter wg0    WireGuard P2P    wg0             10.10.0.2         ChaCha20
Master wg0    →  Home LAN          WireGuard→LAN    wg0             10.10.0.2→LAN     ChaCha20→None
Lady eth0     →  Internet          Direct           eth0            207.180.192.1     None (TLS app)
Lady ts0      →  Master ts0        Tailscale mesh   tailscale0      100.64.0.1        ChaCha20
Lady ts0      →  Mac ts0           Tailscale mesh   tailscale0      100.64.0.3        ChaCha20
EdgeRouter    →  Master wg0        WireGuard P2P    wg0             213.136.68.108    ChaCha20
Mac en0       →  EdgeRouter LAN    Ethernet         en0             192.168.99.1      None
Mac ts0       →  Master ts0        Tailscale mesh   tailscale0      100.64.0.1        ChaCha20
Mac ts0       →  Lady ts0          Tailscale mesh   tailscale0      100.64.0.2        ChaCha20

═══════════════════════════════════════════════════════════════════════════════════════════════════════
```

---

## ROUTING TABLES (Verified from `ip route show`)

### Master Server Routing Table

```
═══════════════════════════════════════════════════════════════════════════════════════
                    MASTER SERVER — ROUTING TABLE (ip route show)
                    Verified: 2026-02-16 — copied from live system
═══════════════════════════════════════════════════════════════════════════════════════

 #  Destination          Gateway          Interface            Proto   Src             Scope
─── ──────────────────── ──────────────── ──────────────────── ─────── ─────────────── ───────
 1  default              213.136.68.1     ● eth0               static  —               global
 2  10.10.0.0/30         (direct)         ● wg0                kernel  10.10.0.1       link
 3  172.17.0.0/16        (direct)         ● docker0            kernel  172.17.0.1      link ↓
 4  172.18.0.0/16        (direct)         ● br-fb776b4784ae    kernel  172.18.0.1      link
 5  172.30.0.0/24        (direct)         ● br-0341e55be098    kernel  172.30.0.1      link
 6  172.70.9.0/29        (direct)         ● br-ca56054321aa    kernel  172.70.9.1      link
 7  192.168.99.0/24      (direct)         ● wg0                —       —               link
 8  213.136.68.0/24      (direct)         ● eth0               kernel  213.136.68.108  link

 Notes:
 ↓ = linkdown (docker0 has no containers — all use named networks)
 Route #7: Home LAN reachable via WireGuard tunnel (next-hop 10.10.0.2 implicit)
 Tailscale routes managed dynamically by tailscaled (not in main table)

═══════════════════════════════════════════════════════════════════════════════════════
```

### Lady Server Routing Table

```
═══════════════════════════════════════════════════════════════════════════════════════
                    LADY SERVER — ROUTING TABLE (ip route show)
                    Verified: 2026-02-16 — copied from live system
═══════════════════════════════════════════════════════════════════════════════════════

 #  Destination          Gateway          Interface            Proto   Src             Scope
─── ──────────────────── ──────────────── ──────────────────── ─────── ─────────────── ───────
 1  default              207.180.192.1    ● eth0               static  —               global
 2  172.17.0.0/16        (direct)         ● docker0            kernel  172.17.0.1      link ↓
 3  172.18.0.0/16        (direct)         ● br-64228b449149    kernel  172.18.0.1      link
 4  172.19.0.0/16        (direct)         ● br-12d346c9fe84    kernel  172.19.0.1      link
 5  172.20.0.0/16        (direct)         ● br-8304b566c6f6    kernel  172.20.0.1      link
 6  172.21.0.0/16        (direct)         ● br-f9e210a1a2f7    kernel  172.21.0.1      link
 7  172.22.0.0/16        (direct)         ● br-f49159028a5d    kernel  172.22.0.1      link
 8  172.23.0.0/16        (direct)         ● br-f55304df6a53    kernel  172.23.0.1      link
 9  172.28.1.0/24        (direct)         ● br-mailcow         kernel  172.28.1.1      link
10  207.180.192.0/18     207.180.192.1    ● eth0               —       —               —

 Notes:
 ↓ = linkdown (docker0 unused — 7 named networks in use)
 No WireGuard on Lady (connected to Master only via Tailscale)
 Tailscale routes managed dynamically by tailscaled

═══════════════════════════════════════════════════════════════════════════════════════
```
