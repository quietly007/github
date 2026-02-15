# CONTAINER RESOURCE ANALYSIS
## Complete Container Statistics - Agent 2 Verification
### Date: February 15, 2026 18:55 UTC

---

## 📊 MASTER SERVER - 25 CONTAINERS

### Resource Overview

| Metric | Value |
|--------|-------|
| Total Containers | 25 |
| All Running | ✅ Yes |
| Total RAM Used | ~3.2 GiB |
| Average CPU | ~25% |
| Healthcheck Pass | 17/25 |
| No Healthcheck | 8/25 |

### Detailed Container Statistics

| # | Container | CPU % | Memory | Mem % | Status | Uptime |
|---|-----------|-------|--------|-------|--------|--------|
| 1 | prometheus | 0.18% | 1.518G/2G | 75.91% | healthy | 5d |
| 2 | cadvisor | 6.79% | 339.2M | 0.70% | healthy | 5d |
| 3 | grafana | 0.17% | 228.3M/1G | 22.30% | healthy | 5d |
| 4 | loki | 1.84% | 201M | 0.42% | healthy | 5d |
| 5 | uptime-kuma | 1.33% | 169.7M | 0.35% | healthy | 5d |
| 6 | crowdsec | 7.22% | 154.4M | 0.32% | healthy | 3d |
| 7 | promtail | 2.65% | 143.6M | 0.30% | running | 5d |
| 8 | portainer | 0.00% | 88.71M | 0.18% | running | 5d |
| 9 | authelia | 0.03% | 85.03M | 0.18% | healthy | 5d |
| 10 | pihole | 0.57% | 62.42M | 0.13% | healthy | 3d |
| 11 | semaphore | 0.01% | 55.86M | 0.12% | healthy | 5d |
| 12 | ntfy | 0.06% | 54.72M | 0.11% | healthy | 5d |
| 13 | traefik | 0.00% | 52.95M | 0.11% | healthy | 3d |
| 14 | alertmanager | 0.22% | 49.6M/256M | 19.38% | healthy | 5d |
| 15 | gotify | 0.00% | 41.32M | 0.09% | healthy | 5d |
| 16 | admin-panel | 4.41% | 36.42M | 0.08% | healthy | 2d |
| 17 | bouncer-traefik | 0.00% | 30.16M | 0.06% | healthy | 3d |
| 18 | blackbox | 0.00% | 28.95M | 0.06% | healthy | 3d |
| 19 | node-exporter | 0.00% | 27.65M | 0.06% | running | 5d |
| 20 | cloudflared | 0.03% | 24.42M | 0.05% | running | 3d |
| 21 | headscale-ui | 0.00% | 18.8M | 0.04% | running | 3d |
| 22 | headscale-admin | 0.00% | 16.18M | 0.03% | running | 3d |
| 23 | it-tools | 0.00% | 13.53M | 0.03% | running | 5d |
| 24 | fuckoff-page | 0.00% | 10.29M | 0.02% | healthy | 3d |
| 25 | default-landing | 0.00% | 9.398M | 0.02% | running | 3d |

### Resource Alerts

| Container | Alert | Severity | Notes |
|-----------|-------|----------|-------|
| prometheus | 75.91% memory | ⚠️ WATCH | Has 2GB limit, using 1.5GB |
| grafana | 22.30% memory | ℹ️ INFO | Has 1GB limit, using 228MB |
| alertmanager | 19.38% memory | ℹ️ INFO | Has 256MB limit, using 49.6MB |

### Network I/O (Top 5)
| Container | RX | TX |
|-----------|----|----|
| prometheus | 19.8GB | 367MB |
| admin-panel | 1.18GB | 1.15GB |
| cadvisor | 102MB | 8.24GB |
| portainer | 857MB | 63.4MB |
| loki | 407MB | 417MB |

### Block I/O (Top 5)
| Container | Read | Write |
|-----------|------|-------|
| crowdsec | 5.32GB | 844MB |
| prometheus | 2.99GB | 5.8GB |
| loki | 374MB | 3.3GB |
| pihole | 1.89GB | 565MB |
| gotify | 1.8GB | 28.7KB |

---

## 🖥️ LADY SERVER - 39 CONTAINERS

### Resource Overview

| Metric | Value |
|--------|-------|
| Total Containers | 39 |
| All Running | ✅ Yes |
| Total RAM Used | ~6.8 GiB |
| Average CPU | ~15% |
| Healthcheck Pass | 13/39 |
| No Healthcheck | 26/39 |

### Detailed Container Statistics

| # | Container | CPU % | Memory | Mem % | Status |
|---|-----------|-------|--------|-------|--------|
| 1 | uisp | 3.51% | 1.912G | 4.06% | running |
| 2 | clamd-mailcow | 0.00% | 1021M | 2.12% | healthy |
| 3 | unifi | 0.50% | 850.6M | 1.77% | running |
| 4 | onlyoffice | 0.49% | 615.2M | 1.28% | running |
| 5 | frigate | 1.65% | 488.7M | 1.01% | healthy |
| 6 | cadvisor | 0.44% | 387.2M | 0.80% | healthy |
| 7 | mysql-mailcow | 0.04% | 366.2M | 0.76% | running |
| 8 | sogo-mailcow | 0.16% | 293.5M | 0.61% | running |
| 9 | ofelia-mailcow | 0.00% | 267.2M | 0.55% | running |
| 10 | unifi-db | 1.38% | 256M | 0.53% | healthy |
| 11 | homeassistant | 0.04% | 250M | 0.52% | running |
| 12 | rspamd-mailcow | 0.50% | 218.9M | 0.45% | running |
| 13 | nextcloud | 0.01% | 190.6M | 0.40% | healthy |
| 14 | odoo | 0.25% | 189.4M/1G | 18.49% | healthy |
| 15 | php-fpm-mailcow | 0.01% | 143.2M | 0.30% | running |
| 16 | crowdsec | 0.04% | 130M | 0.27% | healthy |
| 17 | nextcloud-db | 0.03% | 126.2M | 0.26% | healthy |
| 18 | promtail | 4.04% | 89.81M | 0.19% | running |
| 19 | postfix-mailcow | 0.13% | 80.71M | 0.17% | running |
| 20 | dovecot-mailcow | 0.02% | 74.67M | 0.15% | running |
| 21 | traefik | 0.08% | 57.18M | 0.12% | running |
| 22 | dockerapi-mailcow | 0.44% | 56.15M | 0.12% | running |
| 23 | unbound-mailcow | 0.05% | 44.56M | 0.09% | healthy |
| 24 | postfix-tlspol | 0.02% | 42.93M | 0.09% | running |
| 25 | odoo-db | 0.00% | 37.77M/512M | 7.38% | healthy |
| 26 | watchdog-mailcow | 0.41% | 35.44M | 0.07% | running |
| 27 | netfilter-mailcow | 0.02% | 29.29M | 0.06% | running |
| 28 | bouncer-traefik | 0.00% | 24.36M | 0.05% | healthy |
| 29 | nginx-mailcow | 0.00% | 18.87M | 0.04% | running |
| 30 | redis-mailcow | 0.83% | 17.9M | 0.04% | running |
| 31 | node-exporter | 0.00% | 17.09M | 0.04% | running |
| 32 | portainer-agent | 0.00% | 16.6M | 0.03% | running |
| 33 | mysqld-exporter | 0.00% | 15.88M | 0.03% | running |
| 34 | olefy-mailcow | 0.00% | 14.62M | 0.03% | running |
| 35 | mta-sts | 0.00% | 11.17M | 0.02% | running |
| 36 | nextcloud-redis | 0.85% | 10.76M | 0.02% | healthy |
| 37 | fuckoff-page | 0.00% | 9.828M | 0.02% | healthy |
| 38 | memcached-mailcow | 0.04% | 3.406M | 0.01% | running |
| 39 | acme-mailcow | 0.00% | 2.695M | 0.01% | running |

### Service Groupings

#### Mailcow Stack (18 containers, ~2.5GB RAM)
| Container | RAM |
|-----------|-----|
| clamd-mailcow | 1021M |
| mysql-mailcow | 366.2M |
| sogo-mailcow | 293.5M |
| ofelia-mailcow | 267.2M |
| rspamd-mailcow | 218.9M |
| php-fpm-mailcow | 143.2M |
| postfix-mailcow | 80.71M |
| dovecot-mailcow | 74.67M |
| dockerapi-mailcow | 56.15M |
| unbound-mailcow | 44.56M |
| postfix-tlspol | 42.93M |
| watchdog-mailcow | 35.44M |
| netfilter-mailcow | 29.29M |
| nginx-mailcow | 18.87M |
| redis-mailcow | 17.9M |
| olefy-mailcow | 14.62M |
| memcached-mailcow | 3.406M |
| acme-mailcow | 2.695M |

#### Business Apps (~2.4GB RAM)
| Container | RAM |
|-----------|-----|
| uisp | 1.912G |
| onlyoffice | 615.2M |
| nextcloud | 190.6M |
| odoo | 189.4M |
| nextcloud-db | 126.2M |
| odoo-db | 37.77M |
| nextcloud-redis | 10.76M |

#### Network Management (~1.1GB RAM)
| Container | RAM |
|-----------|-----|
| unifi | 850.6M |
| unifi-db | 256M |

#### Smart Home (~740MB RAM)
| Container | RAM |
|-----------|-----|
| frigate | 488.7M |
| homeassistant | 250M |

---

## 📈 AGGREGATE STATISTICS

### Total Resource Usage

| Server | Containers | RAM Used | RAM % | Disk Used | Disk % |
|--------|------------|----------|-------|-----------|--------|
| Master | 25 | 6.4 GiB | 13.6% | 22 GiB | 3% |
| Lady | 39 | 8.8 GiB | 18.7% | 63 GiB | 7% |
| **TOTAL** | **64** | **15.2 GiB** | **16%** | **85 GiB** | **4.3%** |

### Available Headroom

| Resource | Total | Used | Available | Headroom |
|----------|-------|------|-----------|----------|
| RAM | 96 GiB | 15.2 GiB | 80.8 GiB | 84% |
| Disk | 1.97 TB | 85 GiB | 1.81 TB | 92% |
| vCPUs | 24 | ~3-4 avg | 20+ | 83% |

### Containers by Health Status

| Status | Master | Lady | Total |
|--------|--------|------|-------|
| Healthy | 17 | 13 | 30 |
| Running (no healthcheck) | 8 | 26 | 34 |
| Unhealthy | 0 | 0 | 0 |
| Stopped | 0 | 0 | 0 |

---

## 🔍 ANOMALY DETECTION

### High Memory Usage (>50% of limit)
| Container | Usage | Limit | % |
|-----------|-------|-------|---|
| prometheus | 1.518G | 2G | 76% |

### High CPU Usage (>5%)
| Container | CPU % | Notes |
|-----------|-------|-------|
| crowdsec (master) | 7.22% | Expected - log parsing |
| cadvisor (master) | 6.79% | Expected - container monitoring |

### Recent Restarts (< 3 days)
| Container | Server | Uptime | Notes |
|-----------|--------|--------|-------|
| rspamd-mailcow | Lady | 37h | May have been restarted |
| frigate | Lady | 42h | May have been updated |
| admin-panel | Master | 2d | Recently deployed |

---

## ✅ VERIFICATION SUMMARY

| Claim | Documented | Verified | Match |
|-------|-----------|----------|-------|
| Master containers | 25 | 25 | ✅ |
| Lady containers | 39 | 39 | ✅ |
| Total containers | 64 | 64 | ✅ |
| All running | Yes | Yes | ✅ |
| Critical issues | None | None | ✅ |

---

*Report Generated: February 15, 2026 19:05 UTC*
*Agent: Agent 2 (Secondary Audit)*
