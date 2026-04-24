# EXTERNAL AUDIT REQUEST: Credentials & Secrets Exposure Audit

**Date**: 2026-02-18  
**Requestor**: qui3tly (30yr network veteran, AS8585 operator)  
**Type**: Read-Only Security Audit  
**Subject**: Find every plaintext credential, API token, password, and secret across both servers  
**Priority**: HIGH — multiple plaintext credentials already discovered incidentally  
**Report Location**: `.reports/audits/credentials/$(date +%Y%m%d-%H%M%S)/`

---

## CRITICAL: READ-ONLY AUDIT

**YOU DO NOT MODIFY ANYTHING.** No files, no services, no configs. Report only.

**SPECIAL HANDLING**: Do NOT write actual passwords, tokens, or keys in your report. Use redacted references:
- `Password: R***123!` (first letter + last 4 chars)
- `Token: cf_***abc` (prefix + last 3 chars)
- `Key: AAAB***ns=` (first 4 + last 3 chars base64)

---

## CONTEXT

During domain strategy auditing, multiple plaintext credentials were discovered incidentally:

| Finding | File | Sensitivity |
|---------|------|-------------|
| Ntfy basic_auth password | `~/.docker/alertmanager/config/alertmanager.yml` | HIGH — 4 webhook configs |
| Cloudflare API token | Lady `~/.docker-compose/mailcow/docker-compose.override.yml` | CRITICAL — DNS zone control |
| Gotify API token | `~/.secrets/gotify/alertmanager.token` | MEDIUM — notification access |

This audit must find ALL such exposures, not just the ones we stumbled on.

---

## SCOPE

### Master Server — Full Credential Sweep

```bash
# Pattern: passwords, tokens, keys, secrets in config files
grep -rn --include="*.yaml" --include="*.yml" --include="*.conf" --include="*.py" \
  --include="*.sh" --include="*.env" --include="*.toml" --include="*.ini" \
  --include="*.json" --include="*.cfg" \
  -iE "(password|passwd|secret|token|api.key|apikey|auth|credential|private.key|CF_|CLOUDFLARE)" \
  /home/qui3tly/.docker/ /home/qui3tly/.docker-compose/ /home/qui3tly/.copilot/ \
  /home/qui3tly/.ansible/ /etc/headscale/ 2>/dev/null | \
  grep -v ".git/" | grep -v "node_modules" | grep -v "Binary file"

# Docker container environment variables
for c in $(docker ps --format '{{.Names}}'); do
  env=$(docker inspect "$c" --format '{{range .Config.Env}}{{.}}{{"\n"}}{{end}}' | \
    grep -iE "password|secret|token|key|auth|CF_")
  if [ -n "$env" ]; then
    echo "=== CONTAINER: $c ==="
    echo "$env"
  fi
done

# Docker secrets (if any)
docker secret ls 2>/dev/null

# File permissions on sensitive files
ls -la /etc/wireguard/wg0.conf 2>/dev/null
ls -la /etc/headscale/config.yaml 2>/dev/null
ls -la /home/qui3tly/.docker/traefik/acme.json 2>/dev/null
ls -la /home/qui3tly/.secrets/ 2>/dev/null
find /home/qui3tly/.secrets/ -type f -exec ls -la {} \; 2>/dev/null

# SSH keys
ls -la /home/qui3tly/.ssh/
ls -la /root/.ssh/ 2>/dev/null

# Sudo: does qui3tly have NOPASSWD?
sudo cat /etc/sudoers.d/* 2>/dev/null
```

### Lady Server — Full Credential Sweep

```bash
ssh lady 'grep -rn --include="*.yaml" --include="*.yml" --include="*.conf" \
  --include="*.env" --include="*.py" --include="*.sh" \
  -iE "(password|passwd|secret|token|api.key|apikey|auth|credential|CF_)" \
  /home/qui3tly/.docker/ /home/qui3tly/.docker-compose/ 2>/dev/null | \
  grep -v ".git/" | head -100'

ssh lady 'for c in $(docker ps --format "{{.Names}}"); do
  env=$(docker inspect "$c" --format "{{range .Config.Env}}{{.}}\n{{end}}" 2>/dev/null | \
    grep -iE "password|secret|token|key|auth|CF_")
  if [ -n "$env" ]; then
    echo "=== CONTAINER: $c ==="
    echo "$env"
  fi
done'

ssh lady 'ls -la /etc/wireguard/ 2>/dev/null; ls -la /home/qui3tly/.secrets/ 2>/dev/null'
```

### Specific Areas to Check

1. **Mailcow** — Known to have many credentials:
   ```bash
   ssh lady 'grep -rn -iE "password|secret|token|key" \
     ~/.docker-compose/mailcow/mailcow.conf \
     ~/.docker-compose/mailcow/docker-compose.override.yml 2>/dev/null'
   ```

2. **Traefik** — CF DNS token:
   ```bash
   grep -iE "CF_|CLOUDFLARE|token|email" ~/.docker-compose/traefik/docker-compose.yaml
   ssh lady 'grep -iE "CF_|CLOUDFLARE|token|email" ~/.docker-compose/traefik/docker-compose.yaml'
   ```

3. **Authelia** — JWT, session, OIDC secrets:
   ```bash
   grep -iE "secret|jwt|encryption|password|salt|pepper" ~/.docker/authelia/configuration.yml
   ```

4. **Headscale** — OIDC client secret, noise private key:
   ```bash
   sudo grep -iE "secret|private|oidc|noise" /etc/headscale/config.yaml
   ```

5. **Nextcloud** — Admin password, DB credentials:
   ```bash
   ssh lady 'grep -iE "password|secret|token" ~/.docker-compose/nextcloud/docker-compose.yaml'
   ```

6. **Odoo** — DB password:
   ```bash
   ssh lady 'grep -iE "password|secret" ~/.docker-compose/odoo/docker-compose.yml'
   ```

7. **Grafana** — Admin password, datasource credentials:
   ```bash
   grep -iE "password|secret|admin" ~/.docker-compose/grafana/docker-compose.yaml
   grep -iE "password|secret" ~/.docker/grafana/config/provisioning/datasources/datasources.yml
   ```

8. **Git history** — Credentials committed accidentally:
   ```bash
   git log --all --diff-filter=D --name-only -- '*.env' '*.secret' '*.key' '*.token' 2>/dev/null
   git log --all -p -- '**/docker-compose*' 2>/dev/null | grep -iE "password|secret|token|CF_" | head -20
   ```

---

## CLASSIFICATION

For each credential found, classify:

| Category | Definition |
|----------|------------|
| CRITICAL | Zone-level DNS control, SSH keys, admin passwords for production services |
| HIGH | API tokens, webhook credentials, database passwords |
| MEDIUM | Service-to-service auth (Docker internal), monitoring tokens |
| LOW | Read-only tokens, development credentials, commented-out |

### Storage Assessment

For each credential, assess current storage method:

| Method | Risk Level |
|--------|------------|
| Plaintext in compose file | HIGH — visible to anyone with file access, git history |
| Environment variable (no .env) | HIGH — visible in docker inspect |
| `.env` file (not committed) | MEDIUM — better but still plaintext on disk |
| Docker secret | LOW — encrypted at rest, only available to authorized containers |
| External secret manager (Vault, etc.) | LOWEST — not in use currently |
| File in `~/.secrets/` with proper permissions | MEDIUM — depends on permissions |

---

## OUTPUT REQUIREMENTS

### Report Files

Save to `.reports/audits/credentials/$(date +%Y%m%d-%H%M%S)/`:

| File | Content |
|------|---------|
| `CREDENTIALS_INVENTORY.md` | Every credential found, redacted, classified, with storage method |
| `FILE_PERMISSIONS.md` | Permissions audit on sensitive files (SSH keys, WireGuard, Headscale, acme.json) |
| `RECOMMENDATIONS.md` | Prioritized remediation plan: what to move to Docker secrets/env files |
| `GIT_HISTORY.md` | Any credentials ever committed to git (even if since removed — still in history) |

### Inventory Format

```markdown
| # | Server | File | Line | Type | Value (redacted) | Classification | Storage | Recommendation |
|---|--------|------|------|------|-----------------|----------------|---------|----------------|
| 1 | Lady | mailcow/docker-compose.override.yml | 5 | CF API Token | cf_***xyz | CRITICAL | Plaintext compose | Docker secret |
| 2 | Master | alertmanager/config/alertmanager.yml | 48 | Ntfy password | R***123! | HIGH | Plaintext config | Docker secret |
```

---

## KNOWN SO FAR (verify + extend)

| # | Server | Finding | Found by |
|---|--------|---------|----------|
| 1 | Lady | CF_Token in mailcow compose override | External auditor |
| 2 | Master | Ntfy password in alertmanager.yml (×4) | Lucky Luke |
| 3 | Master | Gotify token in ~/.secrets/ | Both (mentioned) |
| 4 | Master | WireGuard private key in wg0.conf | External auditor |

**Your job: Find EVERYTHING else.**

---

## DELIVERABLES SUMMARY

1. Complete credential inventory (both servers, redacted)
2. File permissions audit on all sensitive files
3. Git history credential exposure check
4. Prioritized remediation plan with effort estimates

Do not fix anything. Do not rotate credentials. Report only.
