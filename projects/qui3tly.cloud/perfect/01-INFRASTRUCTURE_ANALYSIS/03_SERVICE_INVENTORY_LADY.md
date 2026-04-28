# 03 — Lady Service Inventory

> **Source**: `09-EVIDENCE/inv_lady_20260423T201510Z.txt` (2026-04-23 20:15 UTC)  
> **Method**: `docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"` over SSH  
> **Container count**: 38 (docs claim 39 — drift, F-0006)  
> **Note**: Lady rebooted today at 14:00 CEST (P1B kernel patch). Evidence: `lady_reboot_and_load_20260423T201633Z.txt`.

## 📦 Running containers (38)

### Non-mailcow (20)

| # | Name | Status | Ports | Binding | Flag |
|---|---|---|---|---|---|
| 1 | `portainer-agent` | Up 8h | `100.64.0.2:9001` | VPN | ✅ |
| 2 | `mysqld-exporter` | Up 8h | `100.64.0.2:9104` | VPN | ✅ |
| 3 | `cadvisor` | Up 8h ✓ | `100.64.0.2:8081→8080` | VPN | ✅ |
| 4 | `node-exporter` | Up 8h | `100.64.0.2:9100` | VPN | ✅ |
| 5 | `crowdsec` | Up 8h ✓ | `100.64.0.2:6060` | VPN | ✅ |
| 6 | `traefik` | Up 8h | `0.0.0.0:80`, `:443`, `127.0.0.1:8080`, `100.64.0.2:8082` | public + VPN metrics | ✅ |
| 7 | `nextcloud` | Up 8h ✓ | 80, 443 (internal) | internal | — |
| 8 | `onlyoffice-documentserver` | Up 8h | 80, 443 (internal) | internal | — |
| 9 | `nextcloud-db` | Up 8h ✓ | 3306 (internal) | internal | — |
| 10 | `nextcloud-redis` | Up 8h ✓ | 6379 (internal) | internal | — |
| 11 | `uisp` | Up 8h | 80, 443, 2055/udp (internal) | internal | — |
| 12 | `promtail` | Up 8h | none | internal | — |
| 13 | `odoo-db` | Up 8h ✓ | 5432 (internal) | internal | — |
| 14 | `odoo` | Up 8h ✓ | 8069, 8071-8072 (internal) | internal | mem limit 1GiB ✅ |
| 15 | `bouncer-traefik` | Up 8h ✓ | none | internal | — |
| 16 | `unifi` | Up 8h | `0.0.0.0:3478/udp`, `0.0.0.0:10001/udp`, `0.0.0.0:6789/tcp`, 8080/8443/8843/8880 internal | **PART PUBLIC** | 🚨 F-0009 |
| 17 | `unifi-db` | Up 8h ✓ | 27017/tcp (internal) | internal | — |
| 18 | `fuckoff-page` | Up 8h ✓ | 80/tcp | internal | — |
| 19 | `homeassistant` | Up 8h | 8123/tcp (internal) | internal | — |
| 20 | `mta-sts` | Up 8h | 80/tcp (internal) | internal | — |

### Mailcow (18)

| # | Name | Ports | Binding | Flag |
|---|---|---|---|---|
| 21 | `nginx-mailcow-1` | `127.0.0.1:8843/8880` | localhost | ✅ (Traefik fronts) |
| 22 | `dovecot-mailcow-1` | `127.0.0.1:110/143`, `0.0.0.0:993/995`, `0.0.0.0:4190`, `127.0.0.1:19991` | public IMAPS/POP3S/ManageSieve | ✅ expected |
| 23 | `mysql-mailcow-1` | `127.0.0.1:13306` | localhost | ✅ |
| 24 | `redis-mailcow-1` | `127.0.0.1:7654` | localhost | ✅ |
| 25 | `unbound-mailcow-1` ✓ | 53/tcp/udp (internal) | internal | — |
| 26 | `postfix-mailcow-1` | `0.0.0.0:25/465/587`, 588 internal | public SMTP | ✅ expected |
| 27 | `watchdog-mailcow-1` | none | internal | 10% CPU active |
| 28 | `acme-mailcow-1` | none | internal | — |
| 29 | `ofelia-mailcow-1` | none | internal | scheduler |
| 30 | `rspamd-mailcow-1` | none | internal | 185MB RAM |
| 31 | `php-fpm-mailcow-1` | 9000 (internal) | internal | — |
| 32 | `postfix-tlspol-mailcow-1` | none | internal | — |
| 33 | `clamd-mailcow-1` ✓ | none | internal | 1GiB RAM (largest) |
| 34 | `netfilter-mailcow-1` | none | internal | — |
| 35 | `sogo-mailcow-1` | none | internal | 293MB RAM |
| 36 | `memcached-mailcow-1` | 11211 (internal) | internal | — |
| 37 | `dockerapi-mailcow-1` | none | internal | — |
| 38 | `olefy-mailcow-1` | none | internal | — |

## 🚨 F-0009 — UniFi public port exposure

Governance (`SECURITY_STANDARDS.md`): never expose 8080-range publicly.

| Port | Proto | Purpose | Justification? | Action |
|---|---|---|---|---|
| `0.0.0.0:3478` | UDP | UniFi STUN | ✅ needed for WAN adoption | keep |
| `0.0.0.0:10001` | UDP | UniFi device discovery | ❓ only if WAN devices; home APs are LAN-only | audit |
| `0.0.0.0:6789` | TCP | UniFi throughput test | ❌ not needed publicly; has history of CVE | **must restrict** |

**Recommendation**:
- 6789 → rebind to `100.64.0.2:6789` or remove
- 10001 → audit WAN-device need; rebind or drop

Compose edit + `docker compose up -d` on Lady. Requires L2 (tracked as B-004).

## 🩺 Live resource snapshot (post-reboot)

Load 9.48/7.79/7.21 on 12 CPU, 22:16 CEST. Top CPU:

```
crowdsec                  16.3%  (148 MB)
uisp                      14.8%  (1.1 GB)
promtail                  12.4%  (59 MB)
watchdog-mailcow          10.5%  (36 MB)
mailcow-redis              5.5%  (21 MB)
```

No runaway; warm-up expected to normalise within ~15 min. Re-check in Phase 04A (T-021).

## ⚠️ Failed units on Lady

```
mailcow-tlsa.service   loaded failed failed
```

Same root cause as F-0001 (invalid CF token) + F-0010 (postfix reload inside container).

## 📝 Next actions

- `docker inspect` → all 38 → image digest, healthchecks, limits → 06-GOVERNANCE_COMPLIANCE
- UniFi compose audit per F-0009
- Re-probe load once warm-up passes
