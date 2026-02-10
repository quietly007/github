# PRE-NUKE BASELINE

**Date:** 2026-02-10  
**Tester:** Agent

---

## MASTER SERVER (100.64.0.1)

| Service | URL | HTTP Code | Status |
|---------|-----|-----------|--------|
| Pihole | http://127.0.0.1:8053/admin/ | 302 | ✅ OK (redirect to login) |
| Grafana | https://grafana.quietly.its.me | 302 | ✅ OK (redirect to login) |
| Portainer | http://127.0.0.1:9000 | 200 | ✅ OK |
| Traefik | http://127.0.0.1:8080/api/version | 200 | ✅ OK |
| Prometheus | http://100.64.0.1:9090 | 000 | ❌ DOWN (Exit 255) |
| Alertmanager | http://100.64.0.1:9093 | 000 | ❌ TIMEOUT |
| Loki | http://100.64.0.1:3100/ready | 200 | ✅ OK |
| Uptime-kuma | https://status.quietly.its.me | 302 | ✅ OK (redirect) |
| Ntfy | https://ntfy.quietly.its.me | 404 | ⚠️ Routing issue |
| Gotify | https://gotify.quietly.its.me | 200 | ✅ OK |
| IT-Tools | https://tools.quietly.its.me | 200 | ✅ OK |
| Semaphore | https://semaphore.quietly.its.me | 200 | ✅ OK |

**Master Summary:** 9/12 services OK, 2 DOWN, 1 routing issue

---

## LADY SERVER (100.64.0.2)

| Service | URL | HTTP Code | Status |
|---------|-----|-----------|--------|
| Mailcow | https://mail.quietly.online (via VPN) | 200 | ✅ OK |
| Nextcloud | https://nextcloud.quietly.online (via VPN) | 200 | ✅ OK (but DB broken) |
| Odoo | https://odoo.quietly.online | 404 | ❌ Routing issue |
| HomeAssistant | https://homeassistant.quietly.its.me | 404 | ❌ Routing issue |
| Frigate | https://frigate.quietly.its.me | 404 | ❌ Routing issue |

**Lady Summary:** 2/5 services OK, 3 routing issues

---

## KNOWN ISSUES BEFORE NUKE

1. **Prometheus:** EXIT 255 - needs restart
2. **Alertmanager:** Not responding - may depend on Prometheus
3. **Nextcloud:** DB doesn't exist (109 errors in logs)
4. **Odoo:** DB doesn't exist
5. **Ntfy, HomeAssistant, Frigate, Odoo:** Traefik routing issues

---

## BASELINE ESTABLISHED

**Total services tested:** 17  
**Working:** 11 (65%)  
**Down/Issues:** 6 (35%)

This baseline confirms infrastructure has pre-existing issues BEFORE nuke.
