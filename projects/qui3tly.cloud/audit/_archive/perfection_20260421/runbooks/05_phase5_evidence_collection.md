# Runbook 05 — Phase 5 Evidence Collection

**Purpose:** One script that captures every evidence gap external DOCUMENTATION_ACCURACY_REVIEW flagged. Run from Master as `qui3tly` with SSH to Lady.

---

```bash
#!/usr/bin/env bash
set -u
TS=$(date -u +%Y%m%dT%H%M%SZ)
EV=~/projects/qui3tly.cloud/perfection/evidence
mkdir -p "$EV"

# ============================================================
# 1. Sysctl both nodes
# ============================================================
KEYS="net.ipv4.conf.all.accept_redirects net.ipv4.conf.default.accept_redirects \
      net.ipv4.conf.all.send_redirects net.ipv4.conf.all.rp_filter \
      net.ipv4.tcp_syncookies kernel.kptr_restrict kernel.dmesg_restrict \
      kernel.randomize_va_space"
sysctl $KEYS > "$EV/master_sysctl_${TS}.txt" 2>&1
ssh lady "sysctl $KEYS" > "$EV/lady_sysctl_${TS}.txt" 2>&1

# ============================================================
# 2. AIDE status on Master
# ============================================================
{
  systemctl status aide.service aide.timer --no-pager
  echo "---"
  journalctl -u aide.service -n 30 --no-pager
} > "$EV/master_aide_status_${TS}.txt" 2>&1

# ============================================================
# 3. Traefik config + routers both nodes
# ============================================================
{
  echo "=== Traefik static @ master ==="
  docker exec traefik cat /etc/traefik/traefik.yaml
  echo "--- Routers ---"
  curl -s http://127.0.0.1:8080/api/http/routers | jq '.[] | {name,rule,middlewares,service}'
} > "$EV/master_traefik_${TS}.txt" 2>&1

{
  echo "=== Traefik static @ lady ==="
  ssh lady "docker exec traefik cat /etc/traefik/traefik.yaml"
  echo "--- Routers ---"
  ssh lady "curl -s http://127.0.0.1:8080/api/http/routers" | jq '.[] | {name,rule,middlewares,service}'
} > "$EV/lady_traefik_${TS}.txt" 2>&1

# ============================================================
# 4. Container inspect (restart policy, limits, user, mounts)
# ============================================================
INSPECT_JQ='.[] | {Name, RestartPolicy:.HostConfig.RestartPolicy.Name, Memory:.HostConfig.Memory, PidsLimit:.HostConfig.PidsLimit, User:.Config.User, Mounts:[.Mounts[] | {Type, Source, Destination, Name}]}'
docker inspect $(docker ps -q) | jq "$INSPECT_JQ" > "$EV/master_container_inspect_${TS}.txt"
ssh lady 'docker inspect $(docker ps -q)' | jq "$INSPECT_JQ" > "$EV/lady_container_inspect_${TS}.txt"

# ============================================================
# 5. Volumes + docker system df
# ============================================================
{ echo "=== docker volume ls ==="; docker volume ls; echo; echo "=== docker system df ==="; docker system df; } > "$EV/master_volumes_${TS}.txt"
ssh lady 'echo "=== docker volume ls ==="; docker volume ls; echo; echo "=== docker system df ==="; docker system df' > "$EV/lady_volumes_${TS}.txt"

# ============================================================
# 6. Backup cron + timers
# ============================================================
{ echo "=== crontab -l ==="; crontab -l 2>/dev/null; echo; echo "=== timers ==="; systemctl list-timers --all | grep -iE 'backup|aide'; } > "$EV/master_backup_schedule_${TS}.txt"
ssh lady 'echo "=== crontab -l ==="; crontab -l 2>/dev/null; echo; echo "=== timers ==="; systemctl list-timers --all | grep -iE "backup|aide"' > "$EV/lady_backup_schedule_${TS}.txt"

# ============================================================
# 7. iptables raw both nodes
# ============================================================
sudo iptables -L -n -v > "$EV/master_iptables_${TS}.txt" 2>&1
ssh lady 'sudo iptables -L -n -v' > "$EV/lady_iptables_${TS}.txt" 2>&1

# ============================================================
# 8. Secrets permissions
# ============================================================
find ~/.secrets/ -type f -printf '%m %u:%g %p\n' > "$EV/master_secrets_perms_${TS}.txt" 2>&1
ssh lady 'find ~/.secrets/ -type f -printf "%m %u:%g %p\n"' > "$EV/lady_secrets_perms_${TS}.txt" 2>&1

# ============================================================
# 9. Final listener state
# ============================================================
ss -tlnp > "$EV/master_listeners_final_${TS}.txt" 2>&1
ssh lady 'ss -tlnp' > "$EV/lady_listeners_final_${TS}.txt" 2>&1

# ============================================================
# 10. Prometheus targets + rules + alerts
# ============================================================
{
  echo "=== Active targets ==="
  curl -s http://localhost:9090/api/v1/targets | jq '[.data.activeTargets[] | {job, instance, health, lastError}]'
  echo "=== Alert rules ==="
  curl -s http://localhost:9090/api/v1/rules | jq '[.data.groups[].rules[].name]'
  echo "=== Active alerts ==="
  curl -s http://localhost:9093/api/v2/alerts
} > "$EV/monitoring_snapshot_${TS}.txt" 2>&1

echo
echo "=== Evidence collection complete ==="
echo "Timestamp: $TS"
echo "Location:  $EV"
ls -la "$EV" | tail -30
```

---

## After running

```bash
cd ~ && git add projects/qui3tly.cloud/perfection/evidence/ \
  && git commit -m "perfection: phase-5 evidence collection run ${TS}" \
  && git push
```

Review every file; investigate surprises before marking Phase 5 items done.
