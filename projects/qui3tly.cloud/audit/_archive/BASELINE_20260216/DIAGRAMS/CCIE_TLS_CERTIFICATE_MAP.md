# CCIE TLS/Certificate Map — Complete Certificate Inventory

> **Author**: qui3tly (One of the first CCIE in the region)  
> **Verified**: 2026-02-16 (ALL data from LIVE acme.json + docker inspect)  
> **Standard**: Cisco CCIE-level documentation — every cert, every domain, every issuer  
> **Scope**: All TLS certificates across Master + Lady

---

## CERTIFICATE AUTHORITY & ISSUANCE

```
═══════════════════════════════════════════════════════════════════════════════════════════
    TLS CERTIFICATE INFRASTRUCTURE — Who issues, how, where stored
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  ISSUER: Let's Encrypt (via ACME protocol)                              │
    │  Challenge type: DNS-01 (via Cloudflare API)                            │
    │  Advantage: Wildcard certs, no port 80 requirement                      │
    │  Token: /run/secrets/cf-token (bind-mounted from ~/.secrets/traefik/)  │
    │  Account email: tihomir.raznatovic@gmail.com                            │
    │  Resolver: cloudflare                                                   │
    │  DNS resolvers for challenge: 1.1.1.1:53, 1.0.0.1:53                   │
    └──────────────────────────────────────────────────────────────────────────┘

    ISSUANCE FLOW:

    ┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
    │  TRAEFIK          │      │  LET'S ENCRYPT   │      │  CLOUDFLARE      │
    │  (ACME client)    │      │  (ACME server)   │      │  (DNS provider)  │
    │                   │      │                   │      │                   │
    │  1. Request cert  │─────▶│  2. Issue DNS-01  │      │                   │
    │     for domain    │      │     challenge     │      │                   │
    │                   │◀─────│     token         │      │                   │
    │  3. Create TXT    │─────────────────────────────────▶│  4. Add record   │
    │     record via    │      │                   │      │  _acme-challenge │
    │     CF API token  │      │                   │      │  .domain.com     │
    │                   │      │  5. Verify TXT    │◀─────│                   │
    │                   │      │     record exists │      │                   │
    │  6. Receive cert  │◀─────│     → VALID       │      │                   │
    │     + key pair    │      │                   │      │                   │
    │  7. Store in      │      │                   │      │                   │
    │     acme.json     │      │                   │      │                   │
    └──────────────────┘      └──────────────────┘      └──────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## MASTER — Certificate Inventory

```
═══════════════════════════════════════════════════════════════════════════════════════════
    MASTER ACME — /home/qui3tly/.docker/traefik/acme.json
    Traefik v3.6.6 | Resolver: cloudflare | DNS-01 challenge
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #1: Wildcard — quietly.its.me                                     │
    │  ────────────────────────────────────────────────────────────────────── │
    │  Main:      quietly.its.me                                              │
    │  SANs:      *.quietly.its.me                                            │
    │  Type:      WILDCARD (covers ALL subdomains)                            │
    │  Issuer:    Let's Encrypt (ACME DNS-01 via Cloudflare)                  │
    │  Storage:   /home/qui3tly/.docker/traefik/acme.json                     │
    │  Used by:   Traefik → ALL Master services                               │
    │  Auto-renew: Yes (Traefik ACME client, 30 days before expiry)          │
    │                                                                          │
    │  SERVICES COVERED:                                                       │
    │  ├── traefik.quietly.its.me         (Traefik dashboard — VPN-only)      │
    │  ├── grafana.quietly.its.me         (Monitoring — VPN-only)             │
    │  ├── prometheus.quietly.its.me      (Metrics — VPN-only)                │
    │  ├── alertmanager.quietly.its.me    (Alerts — VPN-only)                 │
    │  ├── loki.quietly.its.me            (Logs — VPN-only)                   │
    │  ├── portainer.quietly.its.me       (Containers — VPN-only)             │
    │  ├── headscale.quietly.its.me       (VPN control — public!)             │
    │  ├── headscale-ui.quietly.its.me    (VPN UI — VPN-only)                 │
    │  ├── headscale-admin.quietly.its.me (VPN admin — VPN-only)              │
    │  ├── pihole.quietly.its.me          (DNS — VPN-only)                    │
    │  ├── auth.quietly.its.me            (Authelia SSO — public!)            │
    │  ├── gotify.quietly.its.me          (Push — VPN-only)                   │
    │  ├── admin.quietly.its.me           (Admin panel — VPN-only)            │
    │  ├── tools.quietly.its.me           (IT Tools — VPN-only)               │
    │  ├── semaphore.quietly.its.me       (Ansible — VPN-only)                │
    │  ├── uptime.quietly.its.me          (Uptime Kuma — VPN-only)            │
    │  └── (any future *.quietly.its.me) (Wildcard — auto-covered)           │
    │                                                                          │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #2: Single — quietly.online                                       │
    │  ────────────────────────────────────────────────────────────────────── │
    │  Main:      quietly.online                                              │
    │  SANs:      (none — single domain)                                      │
    │  Type:      SINGLE                                                      │
    │  Used by:   Master Traefik for Lady reverse-proxy if needed             │
    │  Note:      Exists in Master's acme.json (Traefik manages centrally?)  │
    └──────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## LADY — Certificate Inventory

```
═══════════════════════════════════════════════════════════════════════════════════════════
    LADY ACME — /home/qui3tly/.docker/traefik/acme.json (on Lady)
    Traefik (Lady) | Resolver: cloudflare | DNS-01 challenge
    SAME Cloudflare API token as Master (same account)
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #1: Wildcard — quietly.its.me (shared with Master)                │
    │  Main: quietly.its.me | SANs: *.quietly.its.me                          │
    │  Used for: unifi.quietly.its.me (UniFi on Lady, Master domain)         │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #2: Single — quietly.online                                       │
    │  Main: quietly.online | SANs: none                                      │
    │  Used for: Base domain landing                                          │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #3: Single — mail.quietly.online                                  │
    │  Main: mail.quietly.online | SANs: none                                 │
    │  Used for: Mailcow SMTP/IMAP TLS (Postfix + Dovecot)                   │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #4: Single — mta-sts.quietly.online                               │
    │  Main: mta-sts.quietly.online | SANs: none                              │
    │  Used for: MTA-STS policy file serving (SMTP security)                  │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #5: autoconfig + autodiscover                                     │
    │  Main: autoconfig.quietly.online                                        │
    │  SANs: autodiscover.quietly.online                                      │
    │  Used for: Mail client auto-configuration (Thunderbird, Outlook)        │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #6-#12: Individual service certs                                  │
    │  cloud.quietly.online      → Nextcloud                                  │
    │  home.quietly.online       → Home Assistant                             │
    │  office.quietly.online     → OnlyOffice                                 │
    │  nextcloud.quietly.online  → Nextcloud (alt domain)                     │
    │  odoo.quietly.online       → Odoo ERP                                   │
    │  unifi.quietly.online      → UniFi (if accessed via .online)            │
    │  cctv.quietly.online       → Frigate NVR                                │
    └──────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  CERT #13: Wildcard — *.quietly.online                                  │
    │  Main: *.quietly.online                                                  │
    │  Covers: ALL future *.quietly.online subdomains                         │
    │  NOTE: Individual certs above were likely issued before wildcard.       │
    │  Traefik will preferentially use the more specific cert.               │
    └──────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## MAILCOW CERTIFICATE — Separate ACME Client

```
═══════════════════════════════════════════════════════════════════════════════════════════
    MAILCOW ACME — acme-mailcow container (Lady)
    Separate from Traefik! Mailcow has its OWN ACME client.
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  Container: acme-mailcow (172.28.1.x)                                   │
    │  Memory: 19.1 MiB                                                        │
    │  Network: br-mailcow (172.28.1.0/24)                                    │
    │                                                                          │
    │  Purpose: Issues certs for SMTP/IMAP (not web — Traefik handles web)   │
    │  Domains:                                                                │
    │  ├── mail.quietly.online (Postfix MX hostname)                          │
    │  ├── autoconfig.quietly.online (Thunderbird auto-config)                │
    │  └── autodiscover.quietly.online (Outlook auto-discover)                │
    │                                                                          │
    │  Used by:                                                                │
    │  ├── Postfix (port 25, 465, 587) — SMTP TLS/STARTTLS                   │
    │  └── Dovecot (port 993, 995) — IMAPS                                   │
    │                                                                          │
    │  NOTE: Mailcow's nginx-mailcow may also use Traefik-issued certs       │
    │  for the web interface, depending on configuration.                      │
    └──────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## TLS TERMINATION POINTS

```
═══════════════════════════════════════════════════════════════════════════════════════════
    WHERE DOES TLS GET TERMINATED? — Every encryption boundary
═══════════════════════════════════════════════════════════════════════════════════════════

    ┌──────────────────────────────────────────────────────────────────────────┐
    │  TERMINATION POINT        CERT SOURCE         PROTOCOL    BACKEND      │
    │  ─────────────────────── ──────────────────── ─────────── ──────────── │
    │                                                                         │
    │  ── MASTER ─────────────────────────────────────────────────────────── │
    │  Traefik (:443)           acme.json (LE)       TLS 1.3     HTTP to     │
    │                           *.quietly.its.me     + HSTS      containers  │
    │                                                                         │
    │  Headscale (:8443)        System cert (?)      TLS 1.3     N/A         │
    │                           or acme via Traefik  (native)    (systemd)   │
    │                                                                         │
    │  ── LADY ───────────────────────────────────────────────────────────── │
    │  Traefik (:443)           acme.json (LE)       TLS 1.3     HTTP to     │
    │                           *.quietly.online     + HSTS      containers  │
    │                           *.quietly.its.me                              │
    │                                                                         │
    │  Postfix (:465)           acme-mailcow (LE)    TLS 1.2/3   (MTA)      │
    │  Postfix (:587)           acme-mailcow (LE)    STARTTLS    (MTA)      │
    │  Postfix (:25)            acme-mailcow (LE)    STARTTLS*   (MTA)      │
    │                                                  *optional              │
    │                                                                         │
    │  Dovecot (:993)           acme-mailcow (LE)    TLS 1.2/3   (IMAP)     │
    │                                                                         │
    │  ── VPN TUNNELS (not TLS — WireGuard crypto) ────────────────────── │
    │  WireGuard (:51820)       Static keys          ChaCha20    Point-to-  │
    │                                                 Poly1305   point       │
    │                                                                         │
    │  Tailscale (:41641)       Headscale keys       ChaCha20    Mesh        │
    │                                                 Poly1305   network     │
    │                                                                         │
    │  ── CONTAINER-TO-CONTAINER (no TLS) ──────────────────────────────── │
    │  Docker bridge traffic    None                  Plaintext  Internal    │
    │  (172.x.x.x ↔ 172.x.x.x)                      (trusted)  only        │
    │                                                                         │
    └──────────────────────────────────────────────────────────────────────────┘

    SECURITY HEADERS (Traefik dynamic config — both servers):
    ├── Strict-Transport-Security: max-age=3153600; includeSubDomains; preload
    ├── X-Content-Type-Options: nosniff
    ├── X-XSS-Protection: 0 (modern CSP preferred)
    ├── Referrer-Policy: strict-origin-when-cross-origin
    └── X-Forwarded-Proto: https (custom header injection)

    serversTransport: insecureSkipVerify=true
    (Traefik doesn't verify backend container certs — containers use HTTP)

═══════════════════════════════════════════════════════════════════════════════════════════
```

---

## CERTIFICATE SUMMARY

```
═══════════════════════════════════════════════════════════════════════════════════════════
    TOTAL CERTIFICATE INVENTORY
═══════════════════════════════════════════════════════════════════════════════════════════

    SERVER    CERT                          TYPE        ISSUER    ACME CLIENT
    ────────  ────────────────────────────  ──────────  ────────  ───────────
    Master    quietly.its.me               Wildcard    LE        Traefik
    Master    quietly.online               Single      LE        Traefik

    Lady      quietly.its.me               Wildcard    LE        Traefik
    Lady      quietly.online               Single      LE        Traefik
    Lady      *.quietly.online             Wildcard    LE        Traefik
    Lady      mail.quietly.online          Single      LE        Traefik
    Lady      mta-sts.quietly.online       Single      LE        Traefik
    Lady      autoconfig+autodiscover      SAN         LE        Traefik
    Lady      cloud.quietly.online         Single      LE        Traefik
    Lady      home.quietly.online          Single      LE        Traefik
    Lady      office.quietly.online        Single      LE        Traefik
    Lady      nextcloud.quietly.online     Single      LE        Traefik
    Lady      odoo.quietly.online          Single      LE        Traefik
    Lady      unifi.quietly.online         Single      LE        Traefik
    Lady      cctv.quietly.online          Single      LE        Traefik

    Lady      mail.quietly.online          Separate    LE        acme-mailcow
    (Mailcow) autoconfig/autodiscover      Separate    LE        acme-mailcow

    TOTAL: 2 wildcards + 13 single-domain + 2 SAN = 17 certificates
    ALL via Let's Encrypt, ALL via DNS-01 challenge, ALL auto-renewing

    OBSERVATION: Lady has individual certs that the wildcard (*.quietly.online)
    already covers. These are likely legacy from before wildcard was added.
    Traefik handles precedence correctly (most specific cert wins).

═══════════════════════════════════════════════════════════════════════════════════════════
```
