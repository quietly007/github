# QUI3TLY.CLOUD - ADMIN TOOLS & PAGES INVENTORY

**Last Updated**: 2026-01-28  
**Status**: Complete inventory of all administrative interfaces

---

## Master Server (100.64.0.1)

### Core Admin Interfaces

**Traefik Dashboard**
- **URL**: https://traefik.quietly.its.me
- **Access**: SSH tunnel (`ssh -L 8080:localhost:8080 master`) or Tailscale (`http://100.64.0.1:8080`)
- **Purpose**: Reverse proxy monitoring, routes, certificates
- **Port**: 8080 (localhost only)
- **Features**:
  - Real-time HTTP/HTTPS router status
  - SSL certificate monitoring
  - Middleware configuration
  - Service health checks

**Portainer**
- **URL**: https://portainer.quietly.its.me
- **Access**: Web UI (authenticated)
- **Purpose**: Docker management, container control
- **Features**:
  - Full Docker stack management
  - Container logs and stats
  - Environment management
  - User access control
  - Remote agent management (Lady)

**Grafana**
- **URL**: https://grafana.qui3tly.cloud
- **Access**: Web UI (authenticated)
- **Purpose**: Metrics visualization, dashboards
- **Dashboards**: 7 comprehensive dashboards
  1. Infrastructure Overview
  2. Server Deep Dive
  3. Container Analytics
  4. Service Health
  5. Log Intelligence
  6. Performance Trends
  7. Alert Central
- **Features**:
  - Prometheus data source
  - Loki logs integration
  - Custom dashboards
  - Alert visualization
  - Explore interface

**Prometheus**
- **URL**: http://100.64.0.1:9090
- **Access**: Tailscale only
- **Purpose**: Metrics database, queries
- **Features**:
  - PromQL query interface
  - Alert rule management
  - Target monitoring
  - Service discovery
  - Time series database
- **Storage**: 15-day retention

**Loki**
- **URL**: http://100.64.0.1:3100
- **Access**: Tailscale only
- **Purpose**: Log aggregation
- **Features**:
  - LogQL queries
  - Label-based indexing
  - Integration with Grafana
  - Log retention policies
- **Sources**: Master containers, future: Lady logs

**Alertmanager**
- **URL**: http://100.64.0.1:9093
- **Access**: Tailscale only
- **Purpose**: Alert routing and management
- **Features**:
  - Alert grouping
  - Silencing rules
  - Notification routing
  - Integration with Gotify/ntfy
  - Alert deduplication

**Pihole Admin**
- **URL**: http://100.64.0.1:8000/admin
- **Access**: Tailscale only
- **Purpose**: DNS management, ad blocking
- **Features**:
  - Query log viewer
  - Blocklist management
  - DNS statistics
  - DHCP configuration
  - Client management
  - Gravity update

**Authelia**
- **URL**: https://auth.quietly.its.me
- **Access**: Web UI
- **Purpose**: Authentication/SSO
- **Features**:
  - Two-factor authentication (2FA)
  - Session management
  - Password reset
  - User registration
  - Access control policies

**IT-Tools**
- **URL**: https://tools.quietly.its.me
- **Access**: Web UI (no authentication)
- **Purpose**: Admin utilities collection
- **Features**:
  - Base64 encoding/decoding
  - Hash generators (MD5, SHA256, etc.)
  - JSON formatter
  - Regular expression tester
  - Network tools
  - Text manipulation
  - Certificate decoder

**Gotify**
- **URL**: https://gotify.quietly.its.me
- **Access**: Web UI (authenticated)
- **Purpose**: Notification management
- **Features**:
  - Push notification server
  - Message history
  - Client management
  - Application tokens
  - Priority levels
  - Mobile app support

**Headscale**
- **Service**: System service (not web UI)
- **CLI**: `headscale` command on master server
- **Purpose**: Tailscale coordination server
- **Management**: Command-line only
- **Common Commands**:
  ```bash
  headscale nodes list
  headscale routes list
  headscale preauthkeys create --reusable --expiration 24h
  headscale users list
  ```

---

## Lady Server (100.64.0.2)

### Mail & Web Admin

**Mailcow Admin**
- **URL**: https://mail.quietly.online
- **Access**: Web UI (authenticated)
- **Purpose**: Complete mail server management
- **Features**:
  - **Mailbox Management**: Create/edit/delete mailboxes
  - **Domain Configuration**: Add domains, verify DNS
  - **DKIM/SPF/DMARC**: Email authentication setup
  - **Queue Management**: View and flush mail queue
  - **Log Viewer**: Real-time and historical logs
  - **Quarantine Management**: Spam/virus quarantine
  - **User Management**: Access control
  - **Backup**: Configuration and data backup
  - **Statistics**: Mail flow analytics
  - **TLS Policy**: Per-domain TLS enforcement

**SOGo Webmail**
- **URL**: https://mail.quietly.online/SOGo
- **Access**: Web UI (user login)
- **Purpose**: Webmail interface
- **Features**:
  - Email client (IMAP)
  - Calendar (CalDAV)
  - Contacts (CardDAV)
  - Tasks
  - Mobile sync
  - Shared calendars
  - Resource booking

**Traefik Dashboard (Lady)**
- **URL**: http://100.64.0.2:8080
- **Access**: Tailscale only
- **Purpose**: Lady's reverse proxy monitoring
- **Features**: Same as Master Traefik

**Portainer Agent**
- **URL**: http://100.64.0.2:9001
- **Access**: Tailscale only
- **Management**: Via Master's Portainer
- **Purpose**: Remote Docker management
- **Features**: Container control from Master Portainer

**Nextcloud**
- **URL**: https://cloud.quietly.online
- **Access**: Web UI (needs initial setup)
- **Purpose**: Cloud storage, files, calendar, contacts
- **Features**:
  - File storage and sync
  - File sharing (internal/external)
  - Calendar (CalDAV)
  - Contacts (CardDAV)
  - Tasks
  - Collaborative editing
  - Mobile apps (iOS/Android)
  - Desktop sync client
  - Activity stream
  - File versioning

**CrowdSec Console**
- **CLI**: `docker exec crowdsec cscli` on lady
- **Purpose**: Security decisions, bouncer management
- **Features**:
  - IP ban list management
  - Threat intelligence
  - Bouncer configuration
  - Hub updates
- **Common Commands**:
  ```bash
  docker exec crowdsec cscli decisions list
  docker exec crowdsec cscli metrics
  docker exec crowdsec cscli hub update
  docker exec crowdsec cscli alerts list
  ```

---

## Monitoring Endpoints (Tailscale Only)

### Master Metrics

- **node-exporter**: http://100.64.0.1:9100/metrics
  - System metrics (CPU, memory, disk, network)
  
- **cAdvisor**: http://100.64.0.1:8080/metrics
  - Container metrics (Docker)
  
- **Traefik Metrics**: http://100.64.0.1:8082/metrics
  - HTTP request metrics, backend health

### Lady Metrics

- **node-exporter**: http://100.64.0.2:9100/metrics
  - System metrics (CPU, memory, disk, network)
  
- **cAdvisor**: http://100.64.0.2:8081/metrics
  - Container metrics (Docker)
  
- **Traefik Metrics**: http://100.64.0.2:8082/metrics
  - HTTP request metrics, backend health

---

## SSH Access

### Master Server

```bash
# Via Tailscale IP
ssh qui3tly@100.64.0.1

# Via domain
ssh qui3tly@quietly.its.me

# Via SSH config alias (if configured)
ssh master
```

**Port**: 1006 (custom, not default 22)  
**Authentication**: SSH key only (password disabled)  
**Root**: Disabled (use sudo)

### Lady Server

```bash
# Via Tailscale IP
ssh qui3tly@100.64.0.2

# Via domain
ssh qui3tly@quietly.online

# Via SSH config alias (if configured)
ssh lady
```

**Port**: 1006 (custom, not default 22)  
**Authentication**: SSH key only (password disabled)  
**Root**: Disabled (use sudo)

---

## API Endpoints

### Mailcow API

- **URL**: https://mail.quietly.online/api/v1
- **Authentication**: API key required
- **Documentation**: https://mailcow.docs.apiary.io/
- **Usage**: 
  ```bash
  curl -X GET \
    -H "X-API-Key: YOUR_API_KEY" \
    https://mail.quietly.online/api/v1/get/mailbox/all
  ```

### Traefik API

- **URL**: http://localhost:8080/api
- **Access**: Localhost only (SSH tunnel)
- **Documentation**: Built-in Swagger UI at `/api/`
- **Endpoints**:
  - `/api/http/routers` - List all HTTP routers
  - `/api/http/services` - List all services
  - `/api/overview` - Dashboard data

### Prometheus API

- **URL**: http://100.64.0.1:9090/api/v1
- **Access**: Tailscale only
- **Documentation**: Prometheus API docs
- **Common Endpoints**:
  - `/api/v1/query` - Instant queries
  - `/api/v1/query_range` - Range queries
  - `/api/v1/targets` - Target status
  - `/api/v1/alerts` - Active alerts

### Grafana API

- **URL**: https://grafana.qui3tly.cloud/api
- **Authentication**: API key or session
- **Documentation**: Grafana API docs
- **Usage**:
  ```bash
  curl -H "Authorization: Bearer YOUR_API_KEY" \
    https://grafana.qui3tly.cloud/api/dashboards/home
  ```

---

## Mobile Apps

### Tailscale

- **Platforms**: iOS, Android, macOS, Windows, Linux
- **Purpose**: VPN access to all internal services
- **Setup**: 
  1. Install app
  2. Login with account
  3. Connect to qui3tly.cloud
  4. Access services via Tailscale IPs
- **Features**:
  - Always-on VPN
  - Split tunneling
  - Exit nodes
  - MagicDNS

### Gotify

- **Platform**: Android
- **Purpose**: Push notifications from infrastructure
- **Setup**:
  1. Install from F-Droid or GitHub
  2. Connect to https://gotify.quietly.its.me
  3. Login with credentials
- **Features**:
  - Real-time notifications
  - Priority levels
  - Message history

### SOGo/Mail Clients

- **Standard IMAP/SMTP**: Any mail client
- **Server**: mail.quietly.online
- **Ports**:
  - **IMAPS**: 993 (SSL/TLS)
  - **Submission**: 587 (STARTTLS)
- **Recommended Apps**:
  - iOS: Native Mail app
  - Android: K-9 Mail, FairEmail
  - Desktop: Thunderbird

### Nextcloud

- **Platforms**: iOS, Android, Desktop (Windows/macOS/Linux)
- **Purpose**: File sync, calendar, contacts
- **Server**: https://cloud.quietly.online
- **Features**:
  - Auto photo upload
  - Offline files
  - Instant upload
  - Share links

---

## Admin Credentials Storage

**Location**: `~/.reports/secrets/` (gitignored)

**Files**:
- `admin-credentials.md` - Service passwords and admin accounts
- `service-api-keys.md` - API keys and tokens
- `ssl-certificates.md` - Certificate details

**Security**: 
- Files are gitignored
- Permissions: 600 (owner read/write only)
- Encrypted at rest (LUKS)
- Regular rotation schedule

---

## Quick Access Bookmarks

### Daily Use

**Morning Checks**:
- [Grafana](https://grafana.qui3tly.cloud) - Infrastructure overview
- [Portainer](https://portainer.quietly.its.me) - Container status
- [Mailcow](https://mail.quietly.online) - Mail queue and stats

### Troubleshooting

**When Things Go Wrong**:
- [Traefik Dashboard](https://traefik.quietly.its.me) - Route debugging
- [Prometheus](http://100.64.0.1:9090) - Metrics queries
- [Grafana Explore](https://grafana.qui3tly.cloud/explore) - Log analysis (Loki)

### Security

**Security Monitoring**:
- CrowdSec Decisions: `ssh lady "docker exec crowdsec cscli decisions list"`
- [Pihole Admin](http://100.64.0.1:8000/admin) - DNS queries and blocks
- [Authelia](https://auth.quietly.its.me) - Authentication logs
- fail2ban: `ssh master "sudo fail2ban-client status sshd"`

### Admin Utilities

**Quick Tools**:
- [IT-Tools](https://tools.quietly.its.me) - Encoding, hashing, network tools
- [Gotify](https://gotify.quietly.its.me) - Send test notifications

---

## Browser Extensions (Recommended)

### Productivity

**Tab Management**:
- **Tab Stash**: Save frequently used admin tabs
- **Tab Groups**: Organize by service type

**Password Management**:
- **Bitwarden**: Store admin credentials securely
- **KeePassXC-Browser**: Alternative password manager

### Development

**API Testing**:
- **RESTClient**: Test API endpoints
- **JSON Formatter**: Format API responses

---

## Desktop Applications

### SSH Management

- **Termius**: SSH client with saved connections
- **iTerm2** (macOS): Terminal with profiles
- **tmux**: Terminal multiplexer for persistent sessions

### Monitoring

- **Grafana Desktop**: Native Grafana client
- **Prometheus CLI**: `promtool` for query testing

---

## Command-Line Quick Reference

### Health Checks

```bash
# Quick infrastructure health check
ssh master "docker ps --format 'table {{.Names}}\t{{.Status}}'"
ssh lady "docker ps --format 'table {{.Names}}\t{{.Status}}'"

# Check service ports
ssh master "ss -tlnp | grep -E '(8080|9090|3100)'"
ssh lady "ss -tlnp | grep -E '(8080|8081)'"

# Mail queue status
ssh lady "docker exec mailcow-postfixd postqueue -p"

# Security status
ssh lady "docker exec crowdsec cscli decisions list | head -20"
ssh master "sudo fail2ban-client status"
```

### Log Viewing

```bash
# Container logs
docker logs -f <container_name>
docker logs --tail 100 <container_name>

# System logs
sudo journalctl -u docker -f
sudo tail -f /var/log/syslog

# Mail logs
ssh lady "docker logs mailcow-postfixd --tail 100"
```

### Resource Monitoring

```bash
# System resources
htop
docker stats

# Disk usage
df -h
du -sh /var/lib/docker
docker system df

# Network connections
ss -tulpn
```

---

## Emergency Contacts

### Hosting Providers

**Contabo Support**:
- Email: support@contabo.com
- Customer Portal: https://my.contabo.com
- Emergency: Check portal for phone support

### DNS Provider

**Cloudflare**:
- Dashboard: https://dash.cloudflare.com
- Support: https://support.cloudflare.com
- API Status: https://www.cloudflarestatus.com

### Domain Registrar

**[Your Registrar]**:
- Contact details needed
- Domain transfer codes stored in secrets

---

## Maintenance Windows

**Recommended Schedule**:
- **Daily**: Morning checks (5 minutes)
- **Weekly**: Monday log review (15 minutes)
- **Monthly**: First Monday security audit (45 minutes)
- **Scheduled Maintenance**: Sunday 02:00-04:00 CET (lowest traffic)

---

## Additional Resources

### Documentation

**Internal Docs**:
- [Master Operations Guide](file://~/.docs/MASTER_OPERATIONS_GUIDE.md)
- [Complete Infrastructure Audit](file://~/.reports/audits/complete-infrastructure-audit-2026-01-28.md)
- [Network Architecture](file://~/.docs/01-infrastructure/NETWORK_ARCHITECTURE.md)
- [Service Documentation](file://~/.docs/03-services/)

**External Resources**:
- [Traefik Docs](https://doc.traefik.io/traefik/)
- [Mailcow Docs](https://docs.mailcow.email/)
- [Prometheus Docs](https://prometheus.io/docs/)
- [Grafana Docs](https://grafana.com/docs/)

---

**Last Updated**: 2026-01-28  
**Maintained By**: qui3tly  
**Review Schedule**: Monthly (with security audits)
