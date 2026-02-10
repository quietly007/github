# SAFE NUKE EXECUTION PLAN

**Date:** 2026-02-10  
**Type:** Safe nuke (containers + images only, NO volumes)

---

## 1. PRE-NUKE CHECKLIST

- [x] Baseline documented (PRE_NUKE_BASELINE.md)
- [x] Compose files verified (COMPOSE_AUDIT.md)
- [x] Backup created (BACKUP_VERIFICATION.md)
- [ ] **User approval received** ← REQUIRED

---

## 2. NUKE COMMAND (SAFE)

```bash
# SAFE: Removes containers and images only
docker system prune -a --force

# DO NOT USE: Would delete ALL data!
# docker system prune -a --volumes  ← DANGEROUS!
```

**What gets deleted:**
- ✅ All stopped containers
- ✅ All unused images
- ✅ All build cache
- ✅ All unused networks

**What is PRESERVED:**
- ✅ Named volumes (portainer_data, etc.)
- ✅ Bind mount data (~/.docker/*)
- ✅ Compose files (~/.docker-compose/*)
- ✅ Secrets (~/.secrets/*)
- ✅ Cron jobs and scripts

---

## 3. POST-NUKE REBUILD SEQUENCE

```bash
# Order matters! Dependencies first.

# 1. Networks
docker network create traefik
docker network create monitoring

# 2. Core infrastructure
cd ~/.docker-compose/traefik && docker compose up -d
cd ~/.docker-compose/crowdsec && docker compose up -d

# 3. DNS
cd ~/.docker-compose/pihole && docker compose up -d

# 4. Auth
cd ~/.docker-compose/authelia && docker compose up -d

# 5. Monitoring stack
cd ~/.docker-compose/prometheus && docker compose up -d
cd ~/.docker-compose/loki && docker compose up -d
cd ~/.docker-compose/grafana && docker compose up -d
cd ~/.docker-compose/alertmanager && docker compose up -d

# 6. Exporters
cd ~/.docker-compose/node-exporter && docker compose up -d
cd ~/.docker-compose/cadvisor && docker compose up -d
cd ~/.docker-compose/promtail && docker compose up -d

# 7. Management
cd ~/.docker-compose/portainer && docker compose up -d

# 8. Services
cd ~/.docker-compose/uptime-kuma && docker compose up -d
cd ~/.docker-compose/gotify && docker compose up -d
cd ~/.docker-compose/ntfy && docker compose up -d
cd ~/.docker-compose/semaphore && docker compose up -d
cd ~/.docker-compose/it-tools && docker compose up -d

# 9. Web pages
cd ~/.docker-compose/default-landing && docker compose up -d
cd ~/.docker-compose/fuckoff-page && docker compose up -d

# 10. Headscale
cd ~/.docker-compose/headscale && docker compose up -d
cd ~/.docker-compose/headscale-ui && docker compose up -d

# 11. Admin
cd ~/.docker-compose/admin-panel && docker compose up -d
```

---

## 4. POST-REBUILD VERIFICATION

```bash
# Test same services as baseline
curl -sk http://127.0.0.1:8053/admin/ -o /dev/null -w "Pihole: %{http_code}\n"
curl -sk http://127.0.0.1:9000 -o /dev/null -w "Portainer: %{http_code}\n"
curl -sk http://100.64.0.1:3100/ready -o /dev/null -w "Loki: %{http_code}\n"
# ... (all services from baseline)

docker ps --format "{{.Names}}: {{.Status}}" | grep -c healthy
# Should be >= 13 healthy containers
```

---

## 5. SUCCESS CRITERIA

| Criteria | Expected | Actual |
|----------|----------|--------|
| All containers running | 24+ | TBD |
| Healthy containers | 13+ | TBD |
| Pihole responds | 302 | TBD |
| Portainer responds | 200 | TBD |
| Grafana responds | 302 | TBD |
| Loki responds | 200 | TBD |
| Same login credentials work | Yes | TBD |
| No data loss | Yes | TBD |

**Pass if:** All services return same HTTP codes as baseline

---

## 6. ROLLBACK PLAN

If rebuild fails:

```bash
# 1. Check logs
docker logs <container_name>

# 2. Restore compose files from backup
tar -xzf ~/backups/compose_*.tar.gz -C ~/

# 3. Restore secrets from backup
tar -xzf ~/backups/secrets_*.tar.gz -C ~/

# 4. Try rebuild again
cd ~/.docker-compose/SERVICE && docker compose up -d
```

---

## 7. ESTIMATED TIME

| Phase | Time |
|-------|------|
| Nuke | 1-2 minutes |
| Image pulls | 5-10 minutes |
| Container starts | 2-3 minutes |
| Verification | 5 minutes |
| **Total** | **~20 minutes** |

---

## APPROVAL REQUIRED

**To execute nuke, user must confirm:**

> "Yes, proceed with safe nuke (containers + images only, keep volumes)"

---

**Plan prepared by:** Agent  
**Status:** ⏳ AWAITING USER APPROVAL
