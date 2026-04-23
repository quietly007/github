# EXTERNAL AUDIT REQUEST: Full FQDN Sweep — Migration Impact Inventory

**Date**: 2026-02-18  
**Requestor**: qui3tly (30yr network veteran, AS8585 operator)  
**Type**: Read-Only Inventory Audit  
**Subject**: Find every file and config referencing `quietly.its.me` or `quietly.online` that will need changing  
**Report Location**: `.reports/audits/fqdn-sweep/$(date +%Y%m%d-%H%M%S)/`

---

## CRITICAL: READ-ONLY AUDIT

**YOU DO NOT MODIFY ANYTHING.** No files, no services, no configs. Inventory only.

---

## CONTEXT

We are migrating VPN-only services from `*.quietly.its.me` and `*.quietly.online` to `*.qui3tly.cloud`. Before implementation, we need a complete inventory of every file, config, script, database, and container that references the old FQDNs. Two previous reviews found some but disagreed on completeness.

**Governing Principle**:
- `quietly.its.me` → PUBLIC services stay, VPN-only services → `qui3tly.cloud`
- `quietly.online` → PUBLIC services stay, VPN-only services → `qui3tly.cloud`
- Any reference to a VPN-only service using an old domain MUST be found and catalogued

---

## SCOPE

### Master Server — Complete Filesystem Sweep

```bash
# Find EVERY reference to quietly.its.me and quietly.online
# Exclude: binary files, node_modules, .git objects, acme.json (cert data)
grep -rn --include="*.yaml" --include="*.yml" --include="*.conf" --include="*.py" \
  --include="*.sh" --include="*.md" --include="*.json" --include="*.txt" \
  --include="*.toml" --include="*.ini" --include="*.env" --include="*.html" \
  "quietly\.\(its\.me\|online\)" \
  /home/qui3tly/ /etc/ 2>/dev/null | grep -v ".git/" | grep -v "node_modules" | grep -v "acme.json"

# Also check: Docker container environment variables
for c in $(docker ps --format '{{.Names}}'); do
  env=$(docker inspect "$c" --format '{{range .Config.Env}}{{.}}{{"\n"}}{{end}}' | grep -i "quietly")
  if [ -n "$env" ]; then
    echo "CONTAINER: $c"
    echo "$env"
  fi
done

# Also check: Docker compose files (ALL projects, including Lady via SSH)
find /home/qui3tly/.docker-compose -name "*.yaml" -o -name "*.yml" | xargs grep -l "quietly"
```

### Lady Server — Complete Filesystem Sweep

```bash
# Same sweep on Lady
ssh lady 'grep -rn --include="*.yaml" --include="*.yml" --include="*.conf" --include="*.py" \
  --include="*.sh" --include="*.md" --include="*.json" --include="*.txt" \
  "quietly" /home/qui3tly/ /etc/ 2>/dev/null | grep -v ".git/" | grep -v "acme.json" | head -200'

# Lady container env vars
ssh lady 'for c in $(docker ps --format "{{.Names}}"); do
  env=$(docker inspect "$c" --format "{{range .Config.Env}}{{.}}\n{{end}}" 2>/dev/null | grep -i "quietly")
  if [ -n "$env" ]; then
    echo "CONTAINER: $c"
    echo "$env"
  fi
done'
```

### Databases (SQLite)

```bash
# Uptime-Kuma monitors
# (need to copy db out, sqlite3 may not be in container)
cp ~/.docker/uptime-kuma/data/kuma.db /tmp/kuma.db
sqlite3 /tmp/kuma.db "SELECT name, url FROM monitor WHERE url LIKE '%quietly%';" 2>/dev/null

# Grafana (dashboards may have hardcoded links)
# Copy grafana.db, check for dashboard JSON with FQDNs
docker cp grafana:/var/lib/grafana/grafana.db /tmp/grafana.db
sqlite3 /tmp/grafana.db "SELECT title FROM dashboard WHERE data LIKE '%quietly%';" 2>/dev/null

# Pi-hole custom DNS (gravity.db)
docker exec pihole pihole-FTL sqlite3 /etc/pihole/gravity.db \
  "SELECT * FROM domain_audit WHERE domain LIKE '%quietly%';" 2>/dev/null
```

### Systemd, Cron, Timers

```bash
# Systemd units
grep -rn "quietly" /etc/systemd/system/ 2>/dev/null
systemctl list-timers --all --no-pager

# Crontab
crontab -l 2>/dev/null | grep "quietly"
sudo crontab -l 2>/dev/null | grep "quietly"

# Root SSH config
sudo grep -rn "quietly" /root/.ssh/ 2>/dev/null
```

### Browser-Accessible / Client-facing

```bash
# Authelia
grep -rn "quietly" ~/.docker/authelia/ 2>/dev/null

# Headscale
sudo grep -rn "quietly" /etc/headscale/ 2>/dev/null

# Tailscale
tailscale debug prefs 2>/dev/null | grep -i "url\|server"
ssh lady 'tailscale debug prefs 2>/dev/null | grep -i "url\|server"'
```

---

## OUTPUT FORMAT

### FQDN_INVENTORY.md

For every match found, catalog:

```markdown
| # | File Path | Line | FQDN/Reference | Service | Action | Phase |
|---|-----------|------|-----------------|---------|--------|-------|
| 1 | ~/.docker/ntfy/config/server.yml | 1 | ntfy.quietly.its.me | Ntfy base-url | Change to ntfy.qui3tly.cloud | Phase 5 |
| 2 | ~/.copilot/scripts/gotify-notify.sh | 18 | gotify.quietly.its.me | Gotify notification | Change to gotify.qui3tly.cloud | Phase 5 |
```

Classify each entry:
- **MUST CHANGE** — Functional dependency, breaks if not updated
- **SHOULD CHANGE** — Cosmetic/metadata, works but inconsistent
- **KEEP** — Public service reference, stays on old domain by design
- **DELETE** — Dead reference, should be removed entirely

### SUMMARY.md

```markdown
| Category | MUST CHANGE | SHOULD CHANGE | KEEP | DELETE | Total |
|----------|-------------|---------------|------|--------|-------|
| Master configs | ? | ? | ? | ? | ? |
| Lady configs | ? | ? | ? | ? | ? |
| Scripts | ? | ? | ? | ? | ? |
| Documentation | ? | ? | ? | ? | ? |
| Databases | ? | ? | ? | ? | ? |
| Container envs | ? | ? | ? | ? | ? |
```

---

## KNOWN FINDINGS (verify + extend)

Previous reviewers found these. Verify and find what they missed:

| File | Reference | Found by |
|------|-----------|----------|
| `~/.docker/authelia/configuration.yml` | `domain: quietly.its.me` | Both |
| `~/.copilot/scripts/gotify-notify.sh` | `gotify.quietly.its.me` | Lucky Luke |
| `~/.docker/ntfy/config/server.yml` | `ntfy.quietly.its.me` | Lucky Luke |
| `~/.docker/admin-panel/app_simple.py` | 16+ URLs | Lucky Luke |
| `~/.docker/alertmanager/config/alertmanager.yml` | Ntfy webhook URLs | Both (partially) |
| `~/.docker/prometheus/config/prometheus.yml` | 15+ label references | Lucky Luke |
| `~/.ansible/host_vars/*.yml` | domain references | External auditor |
| `~/.docker/pihole/etc-dnsmasq.d/01-local-dns.conf` | DNS entries | Both |
| Blackbox probe targets in prometheus.yml | `https://quietly.its.me` etc | Lucky Luke |
| Traefik dynamic config | headscale router/service | Both |

**Your job: find everything ELSE that's not on this list.**

---

## DELIVERABLES

1. `FQDN_INVENTORY.md` — Complete line-by-line inventory (both servers)
2. `SUMMARY.md` — Categorized totals and change impact
3. `MIGRATION_CHECKLIST.md` — Ordered list of files to change, grouped by Phase

Do not produce DOMAIN_STRATEGY v6. That is not your job.
