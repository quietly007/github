# Monitoring Stack

Complete monitoring solution with dashboard, status monitoring, and notifications.

## Services

### Homepage
- **URL**: https://home.quietly.its.me
- **Purpose**: Main dashboard showing all services
- **Config**: `homepage/config/`

### Uptime Kuma
- **URL**: https://status.quietly.its.me
- **Purpose**: Service uptime monitoring and status page
- **Data**: Stored in Docker volume `uptime-kuma-data`

### Ntfy
- **URL**: https://ntfy.quietly.its.me
- **Purpose**: Push notifications for iOS and Android
- **Topics**:
  - `qui3tly-critical` - Priority 5 (urgent)
  - `qui3tly-warnings` - Priority 4 (important)
  - `qui3tly-info` - Priority 3 (normal)

## Deployment

Deploy using Ansible playbook:

```bash
cd ~/.ansible/playbooks
ansible-playbook deploy-monitoring.yml --connection=local
```

The playbook will:
1. Pull latest from GitHub
2. Deploy all services
3. Verify they're responding
4. Output access URLs

## Manual Deployment

```bash
# Homepage
cd ~/.docker-compose/homepage
docker compose up -d

# Uptime Kuma
cd ~/.docker-compose/uptime-kuma
docker compose up -d

# Ntfy
cd ~/.docker-compose/ntfy
docker compose up -d
```

## Integration with Alertmanager

Alertmanager sends alerts to Ntfy topics. Config is updated automatically by playbook.
