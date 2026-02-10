# COMPOSE AUDIT

**Date:** 2026-02-10

---

## MASTER SERVER COMPOSE FILES

| Service | Path | Exists | Has Volumes | Secrets Externalized |
|---------|------|--------|-------------|---------------------|
| admin-panel | ~/.docker-compose/admin-panel/ | ✅ | ✅ | ✅ .env file |
| alertmanager | ~/.docker-compose/alertmanager/ | ✅ | ✅ | N/A |
| authelia | ~/.docker-compose/authelia/ | ✅ | ✅ | ✅ /secrets mount |
| cadvisor | ~/.docker-compose/cadvisor/ | ✅ | ✅ | N/A |
| crowdsec | ~/.docker-compose/crowdsec/ | ✅ | ✅ | ✅ secrets block |
| default-landing | ~/.docker-compose/default-landing/ | ✅ | ✅ | N/A |
| fuckoff-page | ~/.docker-compose/fuckoff-page/ | ✅ | ✅ | N/A |
| gotify | ~/.docker-compose/gotify/ | ✅ | ✅ | ✅ secrets block |
| grafana | ~/.docker-compose/grafana/ | ✅ | ✅ | ✅ secrets block |
| headscale | ~/.docker-compose/headscale/ | ✅ | ✅ | ✅ config file |
| headscale-ui | ~/.docker-compose/headscale-ui/ | ✅ | ✅ | N/A |
| it-tools | ~/.docker-compose/it-tools/ | ✅ | ✅ | N/A |
| loki | ~/.docker-compose/loki/ | ✅ | ✅ | N/A |
| node-exporter | ~/.docker-compose/node-exporter/ | ✅ | ✅ | N/A |
| ntfy | ~/.docker-compose/ntfy/ | ✅ | ✅ | N/A |
| pihole | ~/.docker-compose/pihole/ | ✅ | ✅ | ✅ secrets block (fixed) |
| portainer | ~/.docker-compose/portainer/ | ✅ | ✅ | ✅ secrets block |
| prometheus | ~/.docker-compose/prometheus/ | ✅ | ✅ | N/A |
| promtail | ~/.docker-compose/promtail/ | ✅ | ✅ | N/A |
| security-tools | ~/.docker-compose/security-tools/ | ✅ | ✅ | N/A |
| semaphore | ~/.docker-compose/semaphore/ | ✅ | ✅ | ✅ /secrets mount |
| tailscale | ~/.docker-compose/tailscale/ | ✅ | ✅ | ✅ state files |
| traefik | ~/.docker-compose/traefik/ | ✅ | ✅ | ✅ cf-token secret |
| uptime-kuma | ~/.docker-compose/uptime-kuma/ | ✅ | ✅ | N/A |

**Total:** 24 compose directories  
**Secrets externalized:** 12 services  
**Ready for rebuild:** ✅ All 24

---

## SECRETS DIRECTORY

```
~/.secrets/
├── admin-panel/
├── authelia/
├── crowdsec/
├── gotify/
├── grafana/
├── headscale/
├── pihole/          (NEW - Phase 02)
├── portainer/
├── semaphore/
└── traefik/
```

**Permissions:** 700 (owner only)

---

## RED FLAGS

| Issue | Service | Status |
|-------|---------|--------|
| ~~Pihole hardcoded password~~ | pihole | ✅ FIXED in Phase 02 |
| :latest tags | blackbox, security-tools | ⚠️ Low risk |

---

## AUDIT RESULT

✅ **All 24 compose files verified ready for rebuild**
