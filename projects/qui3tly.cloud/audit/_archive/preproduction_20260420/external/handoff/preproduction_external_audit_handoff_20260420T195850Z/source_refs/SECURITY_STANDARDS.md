# Security Standards - qui3tly.cloud Infrastructure

## Critical: Docker Port Binding Security

### The Problem

**Docker bypasses UFW firewall completely!**

When you expose a port in Docker using standard syntax:
```yaml
ports:
  - "9001:9001"
```

Docker interprets this as `"0.0.0.0:9001:9001"` which means:
- ❌ Exposed to entire internet (all interfaces)
- ❌ UFW firewall rules are ignored
- ❌ Accessible to port scanners and attackers
- ❌ Docker creates iptables rules directly, bypassing UFW

### The Solution

**Always explicitly specify the host IP address:**

```yaml
# ✅ CORRECT: Bind to localhost only
ports:
  - "127.0.0.1:9001:9001"

# ✅ CORRECT: Bind to Tailscale VPN only
ports:
  - "100.64.0.2:9001:9001"

# ❌ WRONG: Exposed to internet
ports:
  - "9001:9001"
```

### Real-World Incident (2026-01-28)

**Services Exposed to Internet:**
- Portainer Agent (9001): Bot scanners from Poland, Microsoft Azure, AWS
- Traefik Metrics (8082): Accessible to anyone
- cAdvisor (8081): Container metrics exposed

**Scanner IPs Found:**
- `195.3.222.218`: Polish hosting provider (SKYTECHNOLOGY)
- `13.89.125.226`: Microsoft Azure security research
- `74.82.47.5`: Unknown scanner
- `3.143.33.63`: AWS-based scanner

**Fixes Applied:**
1. Portainer Agent: Changed to `100.64.0.2:9001:9001` (Tailscale only)
2. Traefik Metrics: Changed to `100.64.0.2:8082:8082` (Tailscale only)
3. cAdvisor: Changed to `127.0.0.1:8081:8080` (localhost only)

## Port Binding Standards

### Public Services (Internet-Facing)

**Must be behind Traefik with authentication:**

```yaml
services:
  web:
    ports:
      - "80:80"    # HTTP (redirect to HTTPS)
      - "443:443"  # HTTPS only
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.service.middlewares=vpn-only@file"
```

**Allowed Public Ports:**
- `80/tcp`: HTTP (Traefik - redirects to HTTPS)
- `443/tcp`: HTTPS (Traefik with TLS)
- `25/tcp`: SMTP (Mailcow only)
- `465/tcp`: SMTPS (Mailcow only)
- `587/tcp`: Submission (Mailcow only)
- `993/tcp`: IMAPS (Mailcow only)
- `995/tcp`: POP3S (Mailcow only)
- `4190/tcp`: ManageSieve (Mailcow only)
- `1006/tcp`: SSH (non-standard port)

### Internal Services (Localhost Only)

**Bind to 127.0.0.1:**

```yaml
services:
  database:
    ports:
      - "127.0.0.1:5432:5432"  # PostgreSQL
  
  redis:
    ports:
      - "127.0.0.1:6379:6379"  # Redis
  
  prometheus:
    ports:
      - "127.0.0.1:9090:9090"  # Prometheus
  
  grafana:
    ports:
      - "127.0.0.1:3000:3000"  # Grafana (use Traefik for access)
```

### VPN-Only Services (Tailscale)

**Bind to Tailscale IP:**

```yaml
services:
  portainer-agent:
    ports:
      - "100.64.0.2:9001:9001"  # Portainer agent on Lady
  
  metrics:
    ports:
      - "100.64.0.1:8082:8082"  # Traefik metrics on Master
```

**Tailscale IPs:**
- Master: `100.64.0.1`
- Lady: `100.64.0.2`

### Never Expose These Ports

**Critical Services - Never 0.0.0.0:**

```
3306    MySQL/MariaDB
5432    PostgreSQL
6379    Redis
9000    Portainer Web UI
9001    Portainer Agent
9090    Prometheus
3000    Grafana
8080    Application servers
8081    cAdvisor
8082    Traefik metrics
```

## Security Audit Checklist

### Before Deploying Any Service

- [ ] Check `docker-compose.yaml` for port bindings
- [ ] Verify all ports specify host IP (127.0.0.1 or Tailscale IP)
- [ ] Test: `ss -tlnp | grep 0.0.0.0` should show only intended public services
- [ ] Verify UFW rules match intent
- [ ] Check for exposed Docker ports: `docker ps --format '{{.Names}}: {{.Ports}}' | grep 0.0.0.0`

### Regular Security Audits

**Monthly:**
```bash
# Check all exposed ports
ss -tlnp | grep "LISTEN.*0.0.0.0"

# Check Docker exposed ports
docker ps --format '{{.Names}}: {{.Ports}}' | grep 0.0.0.0

# Check recent failed connections
sudo journalctl -u docker --since "7 days ago" | grep -i "error\|fail"
```

**After Any Docker Deployment:**
```bash
# Verify new service isn't exposed
docker ps --format '{{.Names}}: {{.Ports}}' | grep 0.0.0.0 | grep -v ":80\|:443\|:25\|:465\|:587\|:993\|:995"
```

## Firewall Configuration

### UFW Rules (Master)

```bash
# Default deny
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Public services
sudo ufw allow 1006/tcp comment "SSH"
sudo ufw allow 80/tcp comment "HTTP"
sudo ufw allow 443/tcp comment "HTTPS"
sudo ufw allow 51820/udp comment "WireGuard"
sudo ufw allow 3478/udp comment "Headscale DERP"
sudo ufw allow 41641/udp comment "Tailscale"

# Tailscale VPN
sudo ufw allow from 100.64.0.0/10 comment "Tailscale VPN"

sudo ufw enable
```

### UFW Rules (Lady)

```bash
# Default deny
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Public services
sudo ufw allow 1006/tcp comment "SSH"
sudo ufw allow 80/tcp comment "HTTP"
sudo ufw allow 443/tcp comment "HTTPS"

# Mailcow ports
sudo ufw allow 25/tcp comment "SMTP"
sudo ufw allow 465/tcp comment "SMTPS"
sudo ufw allow 587/tcp comment "Submission"
sudo ufw allow 993/tcp comment "IMAPS"
sudo ufw allow 995/tcp comment "POP3S"
sudo ufw allow 4190/tcp comment "ManageSieve"

# Tailscale
sudo ufw allow 41641/udp comment "Tailscale"
sudo ufw allow from 100.64.0.0/10 comment "Tailscale VPN"

# Docker networks
sudo ufw allow from 172.16.0.0/12 comment "Docker internal"
sudo ufw allow from 10.0.0.0/8 comment "Docker internal"

sudo ufw enable
```

## Docker Compose Template

```yaml
version: '3.8'

services:
  # Example: Internal service (database)
  database:
    image: postgres:16
    container_name: database
    restart: unless-stopped
    ports:
      # ✅ Bind to localhost only
      - "127.0.0.1:5432:5432"
    networks:
      - internal
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    secrets:
      - db_password

  # Example: VPN-only service (monitoring)
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      # ✅ Bind to Tailscale IP only
      - "100.64.0.1:9090:9090"
    networks:
      - monitoring
    volumes:
      - prometheus_data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro

  # Example: Public service (web)
  web:
    image: nginx:alpine
    container_name: web
    restart: unless-stopped
    # ❌ NO direct port binding
    # Public access via Traefik only
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.web.rule=Host(`example.quietly.online`)"
      - "traefik.http.routers.web.entrypoints=https"
      - "traefik.http.routers.web.tls=true"
      - "traefik.http.routers.web.middlewares=vpn-only@file"

networks:
  internal:
    driver: bridge
  monitoring:
    external: true
  traefik:
    external: true

volumes:
  db_data:
  prometheus_data:

secrets:
  db_password:
    file: /home/qui3tly/.secrets/service/db_password
```

## Common Mistakes

### ❌ Mistake 1: Forgetting Host IP

```yaml
ports:
  - "5432:5432"  # ❌ Exposed to internet!
```

**Fix:**
```yaml
ports:
  - "127.0.0.1:5432:5432"  # ✅ Localhost only
```

### ❌ Mistake 2: Trusting UFW

```bash
# You configured UFW:
sudo ufw deny 9001

# But Docker still exposes it:
docker run -d -p 9001:9001 service
```

**Fix:** UFW doesn't control Docker. Always bind explicitly in compose file.

### ❌ Mistake 3: Using Host Network Mode

```yaml
services:
  app:
    network_mode: host  # ❌ Bypasses all firewall rules!
```

**Fix:** Use bridge networks and explicit port bindings.

### ❌ Mistake 4: Copy-Paste Without Review

```yaml
# From example online:
ports:
  - "8080:8080"  # ❌ Didn't add host IP!
```

**Fix:** Always review and add host IP to every port binding.

## Incident Response

### If You Discover An Exposed Port

1. **Immediate Action:**
```bash
# Stop the container
docker stop CONTAINER_NAME

# Fix the docker-compose.yaml
# Add host IP to port binding

# Restart with fix
docker-compose up -d

# Verify fix
ss -tlnp | grep PORT_NUMBER
```

2. **Check Access Logs:**
```bash
# Check who accessed it
docker logs CONTAINER_NAME | grep "$(date +%Y-%m-%d)"

# Check auth failures
sudo journalctl | grep -i "failed\|unauthorized" | grep PORT
```

3. **Document:**
- What was exposed
- How long it was exposed
- Who might have accessed it
- What fix was applied

## Prevention

### Pre-Deployment Checklist

Before deploying any Docker service:

1. Review `docker-compose.yaml` for all `ports:` sections
2. Add explicit host IP to every port binding
3. Run: `docker-compose config` to verify syntax
4. Deploy to test environment first
5. After deployment, verify: `ss -tlnp | grep 0.0.0.0`
6. Check Docker ports: `docker ps --format '{{.Ports}}'`
7. Document any intentional public exposure

### Automated Checks

```bash
#!/bin/bash
# Security audit script
# /home/qui3tly/scripts/security-audit.sh

echo "=== Security Audit ==="
echo ""

echo "1. Checking exposed ports..."
EXPOSED=$(ss -tlnp | grep "LISTEN.*0.0.0.0" | grep -v ":80\|:443\|:25\|:465\|:587\|:993\|:995\|:1006" | wc -l)
if [ "$EXPOSED" -gt 0 ]; then
    echo "❌ Warning: $EXPOSED unexpected exposed ports found"
    ss -tlnp | grep "LISTEN.*0.0.0.0" | grep -v ":80\|:443\|:25\|:465\|:587\|:993\|:995\|:1006"
else
    echo "✅ No unexpected exposed ports"
fi

echo ""
echo "2. Checking Docker exposed ports..."
DOCKER_EXPOSED=$(docker ps --format '{{.Ports}}' | grep "0.0.0.0" | grep -v ":80\|:443\|:25\|:465\|:587\|:993\|:995" | wc -l)
if [ "$DOCKER_EXPOSED" -gt 0 ]; then
    echo "❌ Warning: $DOCKER_EXPOSED Docker services exposed"
    docker ps --format '{{.Names}}: {{.Ports}}' | grep "0.0.0.0" | grep -v ":80\|:443"
else
    echo "✅ No unexpected Docker exposures"
fi

echo ""
echo "3. Checking UFW status..."
sudo ufw status | grep -q "Status: active" && echo "✅ UFW is active" || echo "❌ UFW is inactive"

echo ""
echo "=== Audit Complete ==="
```

## Resources

- [Docker Network Security](https://docs.docker.com/network/network-tutorial-standalone/)
- [UFW with Docker](https://github.com/chaifeng/ufw-docker)
- [Tailscale Access Control](https://tailscale.com/kb/1018/acls/)

## Last Updated

2026-01-28 - After security incident with exposed Portainer agent, Traefik metrics, and cAdvisor
