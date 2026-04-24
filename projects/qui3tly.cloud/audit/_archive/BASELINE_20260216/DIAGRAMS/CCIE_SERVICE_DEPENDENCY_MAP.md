# CCIE Service Dependency Map — All 64 Containers

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Verified**: 2026-02-16 (ALL data from LIVE system)  
> **Standard**: Cisco CCIE-level documentation — every dependency traced  
> **Scope**: Complete dependency map for 25 Master + 39 Lady containers

---

## MASTER SERVER — Service Dependency Tree (25 containers)

```
═══════════════════════════════════════════════════════════════════════════════════════════
    MASTER SERVER (213.136.68.108) — quietly.its.me — CONTROL PLANE
    25 containers | 3 Docker networks | ~2.8 GiB RAM used
═══════════════════════════════════════════════════════════════════════════════════════════

                              ┌─────────────────────┐
                              │     ENTRY POINT      │
                              │  ● eth0              │
                              │  213.136.68.108:443  │
                              └──────────┬──────────┘
                                         │
                    ┌────────────────────┤
                    ▼                    ▼
    ┌─────────────────────┐  ┌──────────────────────────┐
    │  TRAEFIK            │  │  Pi-hole DNS + DoH       │
    │  172.18.0.18 (t)    │  │  172.70.9.3 (pihole_int) │
    │  172.30.0.6 (m)     │  │  172.18.0.7 (traefik)    │
    │  Mem: 86.1 MiB      │  │  Mem: 99.3 MiB           │
    │  CPU: 4.59%          │  │                          │
    │  Ports: 80, 443      │  │  Depends on:             │
    │                      │  │  ├── cloudflared         │
    │  Depends on:         │  │  │   172.70.9.2           │
    │  ├── crowdsec        │  │  │   Mem: 19.9 MiB        │
    │  ├── bouncer-traefik │  │  │   (DoH to 1.1.1.1)    │
    │  └── authelia        │  │  └── (no other deps)      │
    └─────────┬────────────┘  └──────────────────────────┘
              │
              │  Routes ALL inbound HTTP/S
              │
     ┌────────┼────────────────────────────┐
     │        │                            │
     ▼        ▼                            ▼
 ┌────────────────────┐  ┌─────────────────────────────────────────────────┐
 │  SECURITY LAYER    │  │  APPLICATION LAYER                              │
 │                    │  │                                                 │
 │  crowdsec          │  │  ┌─────────────────┐  ┌──────────────────────┐ │
 │  172.18.0.3 (t)    │  │  │ admin-panel     │  │ it-tools             │ │
 │  Mem: 161.8 MiB    │  │  │ 172.18.0.5 (t)  │  │ 172.18.0.2 (t)      │ │
 │  CPU: 2.37%         │  │  │ Mem: 24.6 MiB   │  │ Mem: 32.8 MiB       │ │
 │  Depends on:       │  │  │ Dep: none       │  │ Dep: none           │ │
 │  └── (log sources) │  │  └─────────────────┘  └──────────────────────┘ │
 │                    │  │                                                 │
 │  bouncer-traefik   │  │  ┌─────────────────┐  ┌──────────────────────┐ │
 │  172.18.0.8 (t)    │  │  │ default-landing │  │ fuckoff-page         │ │
 │  Mem: 30.2 MiB     │  │  │ 172.18.0.6 (t)  │  │ 172.18.0.10 (t)     │ │
 │  Dep: crowdsec API │  │  │ Mem: 6.7 MiB    │  │ Mem: 7.0 MiB        │ │
 │                    │  │  │ Dep: none       │  │ Dep: none           │ │
 │  authelia          │  │  └─────────────────┘  └──────────────────────┘ │
 │  172.18.0.14 (t)   │  │                                                 │
 │  Mem: 47.3 MiB     │  │  ┌─────────────────┐  ┌──────────────────────┐ │
 │  Dep: redis (ext?) │  │  │ headscale-ui    │  │ headscale-admin      │ │
 │                    │  │  │ 172.18.0.12 (t) │  │ 172.18.0.16 (t)      │ │
 └────────────────────┘  │  │ Mem: 7.2 MiB    │  │ Mem: 77.5 MiB        │ │
                         │  │ Dep: headscale   │  │ Dep: headscale       │ │
                         │  │      (systemd!)  │  │      (systemd!)      │ │
                         │  └─────────────────┘  └──────────────────────┘ │
                         │                                                 │
                         │  ┌─────────────────┐  ┌──────────────────────┐ │
                         │  │ semaphore        │  │ uptime-kuma          │ │
                         │  │ 172.18.0.9 (t)   │  │ 172.18.0.20 (t)     │ │
                         │  │ 172.30.0.9 (m)   │  │ 172.30.0.9 (m)      │ │
                         │  │ Mem: 61.6 MiB    │  │ Mem: 170.3 MiB      │ │
                         │  │ Dep: none        │  │ Dep: none (monitors │ │
                         │  │ (Ansible runner) │  │      all services)   │ │
                         │  └─────────────────┘  └──────────────────────┘ │
                         │                                                 │
                         │  ┌─────────────────────────────────────────┐    │
                         │  │ portainer (172.18.0.4) Mem: 136 MiB    │    │
                         │  │ Dep: Docker socket (/var/run/docker.sock)│   │
                         │  └─────────────────────────────────────────┘    │
                         └─────────────────────────────────────────────────┘

 ┌─────────────────────────────────────────────────────────────────────────┐
 │  MONITORING LAYER — br-0341e55be098 "monitoring" (172.30.0.0/24)       │
 │                                                                         │
 │  ┌────────────────────────────────────────────────────────────────────┐ │
 │  │  prometheus (172.30.0.2)  Mem: 1,137 MiB  CPU: 10.15%            │ │
 │  │  THE CENTRAL DATA STORE — everything feeds into or out of this    │ │
 │  │                                                                    │ │
 │  │  Scrape targets (local):                                          │ │
 │  │  ├── node-exporter     (172.30.0.7)  — Host OS metrics            │ │
 │  │  ├── cadvisor           (172.30.0.5)  — Container metrics          │ │
 │  │  ├── blackbox-exporter (172.30.0.3)  — Endpoint probes            │ │
 │  │  ├── traefik            (172.30.0.6)  — Reverse proxy metrics      │ │
 │  │  ├── alertmanager      (172.30.0.8)  — Alert state                │ │
 │  │  └── loki              (172.30.0.4)  — Loki metrics               │ │
 │  │                                                                    │ │
 │  │  Scrape targets (CROSS-SERVER via Tailscale 100.64.0.2):           │ │
 │  │  ├── lady:node-exporter   (100.64.0.2:9100)                       │ │
 │  │  ├── lady:cadvisor        (100.64.0.2:8080)                        │ │
 │  │  ├── lady:mysqld-exporter (100.64.0.2:9104)                       │ │
 │  │  └── lady:blackbox        (100.64.0.2:9115)                        │ │
 │  └────────────────────────────────────────────────────────────────────┘ │
 │                                                                         │
 │  prometheus ──▶ alertmanager (172.30.0.8) Mem: 21.2 MiB                │
 │                 │  Fires alerts to:                                      │
 │                 ├── gotify (172.18.0.13 / 172.30.0.13) Mem: 43.8 MiB   │
 │                 └── ntfy   (172.18.0.11 / 172.30.0.12) Mem: 34.3 MiB  │
 │                                                                         │
 │  promtail (172.30.0.10) ──▶ loki (172.30.0.4)                          │
 │  Mem: 52.5 MiB              Mem: 204.2 MiB                             │
 │  Ships: container logs       Stores: log aggregation                    │
 │                                                                         │
 │  grafana (172.30.0.11 / 172.18.0.21) Mem: 136.1 MiB                   │
 │  Datasources:                                                           │
 │  ├── prometheus (172.30.0.2:9090)                                      │
 │  └── loki       (172.30.0.4:3100)                                       │
 │                                                                         │
 │  cadvisor (172.30.0.5) Mem: 245.0 MiB                                  │
 │  Dep: Docker socket (/var/run/docker.sock) + /sys + /proc               │
 └─────────────────────────────────────────────────────────────────────────┘

 ┌─────────────────────────────────────────────────────────────────────────┐
 │  NATIVE SERVICE (not Docker) — Headscale VPN Control Plane             │
 │                                                                         │
 │  headscale (systemd unit)                                               │
 │  Port: 8443 (HTTPS) + 3478/udp (DERP)                                  │
 │  Manages: tailscale0 interfaces on Master, Lady, Mac                    │
 │  Database: SQLite (/var/lib/headscale/db.sqlite)                        │
 │  Depends on: NOTHING (self-contained)                                   │
 │  Depended on by:                                                        │
 │  ├── headscale-ui (172.18.0.12) — Web management UI                    │
 │  ├── headscale-admin (172.18.0.16) — Admin panel                       │
 │  ├── tailscale0 on Master (100.64.0.1)                                  │
 │  ├── tailscale0 on Lady (100.64.0.2)                                    │
 │  └── tailscale on Mac (100.64.0.3)                                      │
 └─────────────────────────────────────────────────────────────────────────┘
```

---

## LADY SERVER — Service Dependency Tree (39 containers)

```
═══════════════════════════════════════════════════════════════════════════════════════════
    LADY SERVER (207.180.251.111) — quietly.online — APPLICATION HOST
    39 containers | 7+ Docker networks | ~7.5 GiB RAM used
═══════════════════════════════════════════════════════════════════════════════════════════

                              ┌─────────────────────┐
                              │     ENTRY POINT      │
                              │  ● eth0              │
                              │  207.180.251.111:443 │
                              └──────────┬──────────┘
                                         │
                    ┌────────────────────┤
                    ▼                    ▼
    ┌───────────────────────────┐  ┌──────────────────────────────┐
    │  TRAEFIK                  │  │  MAIL PORTS (25,465,587,993) │
    │  172.18.0.x (traefik net) │  │  Direct to Mailcow stack     │
    │  Routes all HTTPS         │  │  (bypasses Traefik)           │
    └──────────┬────────────────┘  └──────────────┬───────────────┘
               │                                   │
     ┌─────────┴──────────────────┐               │
     │                            │               │
     ▼                            ▼               ▼
┌──────────────────────────────────────────────────────────────────────────────────┐
│  MAILCOW STACK — br-mailcow (172.28.1.0/24) — 18 CONTAINERS                    │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────┐      │
│  │  INBOUND FLOW:                                                        │      │
│  │                                                                        │      │
│  │  Internet:25 → postfix-mailcow (78.5 MiB) ──┐                        │      │
│  │                                               ▼                        │      │
│  │                    rspamd-mailcow (222 MiB) ──────── clamd-mailcow    │      │
│  │                         │                        (1,021 MiB — AV scan)│      │
│  │                         │                                              │      │
│  │                         ▼                                              │      │
│  │                    dovecot-mailcow (74.8 MiB)                          │      │
│  │                    ├── IMAP: 993                                        │      │
│  │                    └── SOGo webmail access                             │      │
│  └────────────────────────────────────────────────────────────────────────┘      │
│                                                                                  │
│  ┌────────────────────────────────────────────────────────────────────────┐      │
│  │  SUPPORTING SERVICES:                                                  │      │
│  │                                                                        │      │
│  │  mysql-mailcow (366.6 MiB) ←── postfix, dovecot, rspamd, sogo         │      │
│  │  redis-mailcow (10.3 MiB) ←── rspamd, dovecot, sogo                  │      │
│  │  memcached-mailcow (5.8 MiB) ←── sogo                                │      │
│  │  unbound-mailcow (33.3 MiB) ←── postfix, rspamd (DNS resolver)       │      │
│  │  olefy-mailcow (33.3 MiB) ←── rspamd (macro scanning)                │      │
│  │  solr-mailcow (253.1 MiB) ←── dovecot (full-text search)             │      │
│  │  netfilter-mailcow (36.0 MiB) — iptables management                  │      │
│  │  watchdog-mailcow (28.4 MiB) — health monitoring                     │      │
│  │  acme-mailcow (19.1 MiB) — Let's Encrypt certs                       │      │
│  │  dockerapi-mailcow (20.2 MiB) — Docker socket API                    │      │
│  │  nginx-mailcow (13.8 MiB) — webmail reverse proxy                    │      │
│  │  ofelia-mailcow (13.0 MiB) — cron scheduler                          │      │
│  │  phpfpm-mailcow (60.3 MiB) — PHP for admin panel                     │      │
│  └────────────────────────────────────────────────────────────────────────┘      │
│                                                                                  │
│  DEPENDENCY CHAIN: postfix → rspamd → clamd + olefy                              │
│                    postfix → mysql + unbound                                      │
│                    dovecot → mysql + redis + solr                                 │
│                    sogo    → mysql + redis + memcached                            │
└──────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────┐
│  APPLICATION STACK — br-traefik (172.18.0.0/16)                                  │
│                                                                                  │
│  ┌─────────────────────┐  ┌─────────────────────────────────────────────────┐   │
│  │  Nextcloud           │  │  ONLYOFFICE                                     │   │
│  │  Network: nextcloud  │  │  Network: nextcloud (172.20.x)                  │   │
│  │  (172.20.x)          │  │  Mem: 617 MiB                                   │   │
│  │  Dep:                │  │  Dep: none (standalone)                         │   │
│  │  ├── mariadb         │  │  Integrated via: Nextcloud ONLYOFFICE plugin    │   │
│  │  │   Mem: 148.5 MiB  │  │                                                 │   │
│  │  ├── redis-nc        │  └─────────────────────────────────────────────────┘   │
│  │  │   Mem: 7.1 MiB    │                                                        │
│  │  └── onlyoffice      │  ┌─────────────────────────────────────────────────┐   │
│  │      (document edit) │  │  Odoo ERP                                        │   │
│  └─────────────────────┘  │  Network: odoo (172.22.x)                        │   │
│                            │  Dep:                                             │   │
│                            │  ├── postgresql (172.22.x) Mem: 30.3 MiB        │   │
│                            │  └── (no other deps)                             │   │
│                            └─────────────────────────────────────────────────┘   │
│                                                                                  │
│  ┌─────────────────────┐  ┌─────────────────────────────────────────────────┐   │
│  │  UniFi Controller    │  │  Frigate NVR                                     │   │
│  │  Network: unifi      │  │  Mem: 487 MiB                                    │   │
│  │  (172.23.x)          │  │  CPU: 32.02% (highest!)                          │   │
│  │  Mem: 851 MiB        │  │  Dep: none (standalone, RTSP input)             │   │
│  │  Dep: none           │  └─────────────────────────────────────────────────┘   │
│  │  (embedded MongoDB)  │                                                        │
│  └─────────────────────┘  ┌─────────────────────────────────────────────────┐   │
│                            │  Home Assistant                                  │   │
│                            │  Mem: 308.7 MiB                                  │   │
│                            │  Dep: none (standalone, Zigbee/Z-Wave input)    │   │
│                            └─────────────────────────────────────────────────┘   │
│                                                                                  │
│  ┌─────────────────────┐  ┌─────────────────────────────────────────────────┐   │
│  │  UISP                │  │  Uptime Kuma (Lady)                              │   │
│  │  Mem: 1,684 MiB      │  │  Mem: ~150 MiB                                  │   │
│  │  (HIGHEST on Lady!)  │  │  Dep: none (monitors all services)              │   │
│  │  Dep: none           │  └─────────────────────────────────────────────────┘   │
│  │  (embedded services) │                                                        │
│  └─────────────────────┘                                                         │
└──────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────┐
│  MONITORING STACK — br-monitoring (172.19.0.0/16)                                │
│                                                                                  │
│  node-exporter ──────┐                                                           │
│  cadvisor (339 MiB) ─┤──▶ SCRAPED BY Master Prometheus (100.64.0.1)             │
│  blackbox-exporter ──┤    via Tailscale mesh (100.64.0.2:port)                   │
│  mysqld-exporter ────┘                                                           │
│                                                                                  │
│  promtail ──▶ Master Loki (100.64.0.1:3100) via Tailscale                       │
│  (ships Lady container logs to central Loki)                                     │
└──────────────────────────────────────────────────────────────────────────────────┘
```

---

## CROSS-SERVER DEPENDENCY MAP

```
═══════════════════════════════════════════════════════════════════════════════════════════
    CROSS-SERVER DEPENDENCIES — Tailscale Mesh (100.64.0.0/10)
═══════════════════════════════════════════════════════════════════════════════════════════

    MASTER (100.64.0.1)                           LADY (100.64.0.2)
    quietly.its.me                                quietly.online
    ────────────────────                          ────────────────────

    prometheus (172.30.0.2)                       node-exporter
         │  scrape :9100 ──────────────────────▶  ├── CPU/RAM/disk metrics
         │  scrape :8080 ──────────────────────▶  ├── cadvisor (container)
         │  scrape :9104 ──────────────────────▶  ├── mysqld-exporter (DB)
         │  scrape :9115 ──────────────────────▶  └── blackbox (probes)
         │
    loki (172.30.0.4)                             promtail
         │  ◀────── push :3100 ───────────────    └── Lady container logs
         │
    grafana (172.30.0.11)                         (dashboards rendered
         │  queries prometheus + loki              from Lady data)
         │
    alertmanager (172.30.0.8)                     (alerts for Lady
         │  fires for Lady metrics too             resource thresholds)
         │
    headscale (systemd :8443)                     tailscale (agent)
         │  control plane ─────────────────────▶  └── 100.64.0.2 identity
         │
    uptime-kuma (172.18.0.20)                     All Lady services
         │  monitor endpoints ─────────────────▶  └── health checks
         │
    semaphore (172.18.0.9)                        SSH ansible target
         │  ansible via tailscale ─────────────▶  └── config management


    TRAFFIC DIRECTION: Primarily MASTER → LADY (monitoring pull model)
    EXCEPTIONS: promtail pushes FROM Lady TO Master (log shipping)
    TRANSPORT: ALL cross-server = Tailscale WireGuard (encrypted)
    LATENCY: Direct peer connection, ~10ms (both in Contabo EU)

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## CRITICAL PATH ANALYSIS

```
═══════════════════════════════════════════════════════════════════════════════════════════
    SINGLE POINTS OF FAILURE — What kills what?
═══════════════════════════════════════════════════════════════════════════════════════════

    IF THIS DIES...              THESE DIE TOO               BLAST RADIUS
    ──────────────────────       ──────────────────────       ────────────
    Traefik (Master)             ALL Master web services      ████████████ 20/25
    Traefik (Lady)               ALL Lady web services        ████████████ 35/39

    headscale (systemd)          headscale-ui                 ███          3/64
                                 headscale-admin
                                 (mesh stays up — cached)

    prometheus                   alertmanager (no data)       ██████       6/64
                                 grafana (no metrics)
                                 monitoring visibility LOST

    mysql-mailcow                postfix (queue only)         ████████     8/39
                                 dovecot (read-only cache)
                                 rspamd (no bayes)
                                 sogo (dead)
                                 phpfpm (dead)

    eth0 (Master)                EVERYTHING on Master         █████████████ 25/25
                                 + all cross-server deps      + Lady monitoring

    eth0 (Lady)                  EVERYTHING on Lady           █████████████ 39/39
                                 Master monitoring blind

    tailscale0 (any)             Cross-server monitoring      ████         ~8 deps
                                 (fallback: WireGuard wg0     (wg0 = backup path
                                  for Master↔home only)        but no Lady link)

═══════════════════════════════════════════════════════════════════════════════════════════
    RESILIENCE NOTES:
    • No container HA / clustering — both servers are standalone
    • WireGuard (wg0) = backup for home access if Tailscale dies
    • Pi-hole → cloudflared: if cloudflared dies, DNS fails for WG clients
    • DNS bootstrap: Master resolv.conf = 1.1.1.1 (immutable) — DNS never dies
    • Headscale mesh survives control plane reboot (clients cache state)
═══════════════════════════════════════════════════════════════════════════════════════════
```
