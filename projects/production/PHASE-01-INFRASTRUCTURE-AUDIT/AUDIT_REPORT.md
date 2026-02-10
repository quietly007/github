# PHASE 01: Infrastructure Audit Report

**Date:** 2026-02-10  
**Auditor:** Agent  
**Target Grade:** 60/100

---

## MASTER SERVER (100.64.0.1)

### Container Inventory: 25 Containers

| Container | Image | Status |
|-----------|-------|--------|
| default-landing | nginx:alpine | Up 8 hours |
| loki | grafana/loki:3.3.2 | Up 8 hours (healthy) |
| blackbox | prom/blackbox-exporter:latest | Up 8 hours |
| grafana | grafana/grafana:11.4.0 | Up 8 hours (healthy) |
| alertmanager | prom/alertmanager:v0.27.0 | Up 8 hours (healthy) |
| pihole | pihole/pihole:2025.11.1 | Up 8 hours (healthy) |
| cloudflared | cloudflare/cloudflared:2024.12.2 | Up 8 hours |
| uptime-kuma | louislam/uptime-kuma:latest | Up 8 hours (healthy) |
| traefik | traefik:v3.6.6 | Up 8 hours |
| semaphore | semaphoreui/semaphore:v2.10.22 | Up 8 hours (healthy) |
| promtail | grafana/promtail:3.4.2 | Up 8 hours |
| **prometheus** | prom/prometheus:v2.54.1 | **Exited (255) 8 hours ago** |
| portainer | portainer/portainer-ce:2.33.6 | Up 8 hours |
| ntfy | binwiederhier/ntfy:latest | Up 8 hours (healthy) |
| node-exporter | prom/node-exporter:v1.9.0 | Up 8 hours |
| it-tools | corentinth/it-tools:2024.10.22-7ca5933 | Up 8 hours |
| headscale-ui | ghcr.io/gurucomputing/headscale-ui:2025.08.23 | Up 8 hours |
| headscale-admin | goodieshq/headscale-admin:0.26.0 | Up 8 hours |
| gotify | gotify/server:2.5.0 | Up 8 hours (healthy) |
| fuckoff-page | nginx:1.27-alpine | Up 8 hours (healthy) |
| bouncer-traefik | fbonalair/traefik-crowdsec-bouncer:0.5.0 | Up 8 hours (healthy) |
| crowdsec | crowdsecurity/crowdsec:v1.6.8 | Up 8 hours (healthy) |
| cadvisor | gcr.io/cadvisor/cadvisor:v0.52.1 | Up 8 hours (healthy) |
| authelia | authelia/authelia:4.39.15 | Up 8 hours (healthy) |
| admin-panel | python:3.11-slim | Up 8 hours |

### Master Health Summary

- **Healthy:** 13 containers
- **Up (no healthcheck):** 11 containers
- **DOWN:** 1 container (prometheus)

---

## LADY SERVER (100.64.0.2)

### Container Inventory: 36 Containers

| Container | Image | Status |
|-----------|-------|--------|
| mailcowdockerized-nginx-mailcow-1 | ghcr.io/mailcow/nginx:1.05 | Up 6 hours |
| mailcowdockerized-dovecot-mailcow-1 | ghcr.io/mailcow/dovecot:2.3.21.1 | Up 6 hours |
| mailcowdockerized-mysql-mailcow-1 | mariadb:10.11 | Up 6 hours |
| mailcowdockerized-redis-mailcow-1 | redis:7.4.6-alpine | Up 6 hours |
| mailcowdockerized-unbound-mailcow-1 | ghcr.io/mailcow/unbound:1.24 | Up 6 hours (healthy) |
| onlyoffice-documentserver | onlyoffice/documentserver:8.2.0 | Up 6 hours |
| nextcloud | lscr.io/linuxserver/nextcloud:29.0.7 | Up 6 hours |
| homeassistant | lscr.io/linuxserver/homeassistant:2024.12.5 | Up 6 hours |
| unifi-db | mongo:7.0 | Up 6 hours (healthy) |
| frigate | ghcr.io/blakeblackshear/frigate:stable | Up 6 hours (healthy) |
| odoo | odoo:17.0 | Up 6 hours |
| odoo-db | postgres:16-alpine | Up 6 hours (healthy) |
| nextcloud-db | lscr.io/linuxserver/mariadb:10.11.8 | Up 6 hours (healthy) |
| nextcloud-redis | redis:7.4-alpine | Up 6 hours (healthy) |
| crowdsec | crowdsecurity/crowdsec:v1.6.8 | Up 6 hours (healthy) |
| mysqld-exporter | prom/mysqld-exporter:latest | Up 6 hours |
| portainer-agent | portainer/agent:2.24.1 | Up 6 hours |
| mta-sts | nginx:1.27-alpine | Up 6 hours |
| mailcowdockerized-watchdog-mailcow-1 | ghcr.io/mailcow/watchdog:2.09 | Up 6 hours |
| mailcowdockerized-acme-mailcow-1 | ghcr.io/mailcow/acme:1.94 | Up 6 hours |
| mailcowdockerized-ofelia-mailcow-1 | mcuadros/ofelia:0.3.20 | Up 6 hours |
| mailcowdockerized-rspamd-mailcow-1 | ghcr.io/mailcow/rspamd:2.4 | Up 6 hours |
| mailcowdockerized-postfix-mailcow-1 | ghcr.io/mailcow/postfix:3.7.11 | Up 6 hours |
| mailcowdockerized-php-fpm-mailcow-1 | ghcr.io/mailcow/phpfpm:8.2.29 | Up 6 hours |
| mailcowdockerized-postfix-tlspol-mailcow-1 | ghcr.io/mailcow/postfix-tlspol:1.8.22 | Up 6 hours |
| mailcowdockerized-clamd-mailcow-1 | ghcr.io/mailcow/clamd:1.71 | Up 6 hours (healthy) |
| mailcowdockerized-netfilter-mailcow-1 | ghcr.io/mailcow/netfilter:1.63 | Up 6 hours |
| mailcowdockerized-sogo-mailcow-1 | ghcr.io/mailcow/sogo:5.12.4 | Up 6 hours |
| mailcowdockerized-memcached-mailcow-1 | memcached:alpine | Up 6 hours |
| mailcowdockerized-dockerapi-mailcow-1 | ghcr.io/mailcow/dockerapi:2.11 | Up 6 hours |
| mailcowdockerized-olefy-mailcow-1 | ghcr.io/mailcow/olefy:1.15 | Up 6 hours |
| node-exporter | prom/node-exporter:v1.9.0 | Up 6 hours |
| bouncer-traefik | fbonalair/traefik-crowdsec-bouncer:0.5.0 | Up 6 hours (healthy) |
| promtail | grafana/promtail:3.4.2 | Up 6 hours |
| cadvisor | gcr.io/cadvisor/cadvisor:v0.52.1 | Up 6 hours (healthy) |
| traefik | traefik:v3.6.6 | Up 6 hours |

### Lady Health Summary

- **Healthy:** 10 containers
- **Up (no healthcheck):** 26 containers
- **DOWN:** 0 containers

---

## TOP 10 ERRORS (from /tmp/preproduction_logs_20260210_014012/ALL_ERRORS_SUMMARY.txt)

| Count | Error | Severity |
|-------|-------|----------|
| 109 | `Exception: Not installed in /app/www/public/lib/base.php:284` | **CRITICAL** - Nextcloud broken |
| 12 | Python Traceback errors | HIGH |
| 6 | OnlyOffice nginx.error.log errors | MEDIUM |
| 4 | EOFError (Python) | MEDIUM |
| 3 | `redis.exceptions.ConnectionError` | HIGH |
| 2 | Redis: Host unreachable (172.28.1.249:6379) | HIGH |
| 2 | Redis: Connection closed by server | HIGH |
| 2 | Dovecot SSL: unsupported protocol | MEDIUM |
| 2 | Dovecot SSL: no shared cipher | MEDIUM |
| 2 | Grafana plugin xychart already registered | LOW |

---

## PRIORITY ISSUES

### P0 — CRITICAL (Immediate action required)

| # | Issue | Location | Evidence |
|---|-------|----------|----------|
| 1 | **Prometheus DOWN** | Master | Exit code 255, down 8 hours |
| 2 | **Nextcloud broken** | Lady | 109 errors: "Not installed" in base.php:284 |
| 3 | **Redis unreachable** | Lady | Connection errors to 172.28.1.249:6379 |

### P1 — HIGH (Fix within 24 hours)

| # | Issue | Location | Evidence |
|---|-------|----------|----------|
| 4 | :latest tags (blackbox, uptime-kuma, ntfy) | Master | Version pinning violation |
| 5 | :latest tag (mysqld-exporter) | Lady | Version pinning violation |
| 6 | 11 containers without healthcheck | Master | Monitoring blindspot |
| 7 | 26 containers without healthcheck | Lady | Monitoring blindspot |

### P2 — MEDIUM (Fix within 7 days)

| # | Issue | Location | Evidence |
|---|-------|----------|----------|
| 8 | Python traceback errors (12) | Various | Application errors |
| 9 | OnlyOffice nginx errors | Lady | Web server issues |
| 10 | Dovecot SSL protocol issues | Lady | Mail security |

### P3 — LOW (Scheduled maintenance)

| # | Issue | Location | Evidence |
|---|-------|----------|----------|
| 11 | Grafana plugin warning (xychart) | Master | Non-critical |
| 12 | Scheduled job notices | Lady mailcow | Informational only |

---

## HEALTH STATUS SUMMARY

| Metric | Master | Lady | Total |
|--------|--------|------|-------|
| Total containers | 25 | 36 | **61** |
| Healthy | 13 | 10 | 23 |
| Up (no healthcheck) | 11 | 26 | 37 |
| DOWN | 1 | 0 | **1** |
| :latest images | 3 | 1 | **4** |

---

## IMMEDIATE ACTIONS REQUIRED

1. **Restart Prometheus** on Master:
   ```bash
   cd ~/.docker-compose/prometheus && docker compose up -d
   ```

2. **Investigate Nextcloud** on Lady:
   ```bash
   ssh lady "docker logs nextcloud --tail 50"
   ssh lady "docker exec nextcloud-db mariadb -u root -e 'SHOW DATABASES;'"
   ```

3. **Pin :latest versions**:
   - blackbox → v0.28.0
   - uptime-kuma → 1.23.17
   - ntfy → v2.16.0
   - mysqld-exporter → v0.18.0

---

## GRADE ASSESSMENT

**Current Grade: 59/100 (D+)**

- Prometheus DOWN: -20 points
- Nextcloud broken: -15 points
- Missing healthchecks (37): -5 points
- :latest violations (4): -1 point

---

**Report completed: 2026-02-10**  
**Phase 01 complete. Awaiting user approval.**
