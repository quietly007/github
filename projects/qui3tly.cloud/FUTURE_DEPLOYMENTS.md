# Future Deployments Roadmap

> **Phase**: Phase IV  
> **Priority**: Medium (After documentation consolidation)  
> **Total Estimate**: ~56 hours  
> **Status**: Planning

---

## Overview

This document details all planned infrastructure expansion work post-Excellence Initiative. Each deployment includes purpose, architecture, implementation steps, files, and success criteria.

**Deployment Order**:
1. Security Tools (quick wins)
2. Semaphore Expansion (foundation for automation)
3. Lady Services (main deliverables)
4. WordPress Migration (public-facing)
5. Branding (polish)
6. Server Expansion (scale out)

---

## 1. Security Tools Expansion

**Estimate**: ~2 hours  
**Priority**: High (Quick win)  
**Servers**: Master + Lady

### Purpose
Add dedicated security audit tools beyond current stack (CrowdSec, fail2ban) for comprehensive security monitoring and vulnerability management.

### Tools Selected

#### Trivy - Container Vulnerability Scanner
- **Purpose**: Scan Docker images for known vulnerabilities
- **Use Case**: Pre-deployment scanning, continuous monitoring
- **Integration**: Can integrate with CI/CD (future Semaphore workflows)
- **Lightweight**: Minimal resource usage

#### Lynis - System Security Auditor
- **Purpose**: Linux system hardening audit
- **Use Case**: Weekly automated scans, compliance checking
- **Native**: Runs directly on host (not Docker)
- **Output**: Detailed hardening reports with actionable recommendations

### Architecture

```
Master (213.136.68.108)
├── Trivy (Docker) - port 8080
│   └── Scans all local images
└── Lynis (native) - weekly cron
    └── Reports to /var/log/lynis/

Lady (207.180.251.111)
├── Trivy (Docker) - port 8080
│   └── Scans all local images
└── Lynis (native) - weekly cron
    └── Reports to /var/log/lynis/
```

### Implementation Steps

#### Step 1: Deploy Trivy on Master (30 min)
```bash
# Create directory structure
mkdir -p ~/.docker-compose/security-tools
cd ~/.docker-compose/security-tools

# Create docker-compose.yaml
cat > docker-compose.yaml << 'EOF'
services:
  trivy:
    image: aquasec/trivy:0.48.0
    container_name: trivy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - trivy-cache:/root/.cache/trivy
    command: ["server", "--listen", "0.0.0.0:8080"]
    restart: unless-stopped
    networks:
      - traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.trivy.rule=Host(`trivy.quietly.its.me`)"
      - "traefik.http.routers.trivy.entrypoints=websecure"
      - "traefik.http.routers.trivy.middlewares=vpn-only@file"
      - "traefik.http.services.trivy.loadbalancer.server.port=8080"

volumes:
  trivy-cache:

networks:
  traefik:
    external: true
EOF

# Deploy
docker compose up -d

# Verify
docker logs trivy
```

#### Step 2: Deploy Trivy on Lady (15 min)
```bash
# Copy compose file to Lady
scp docker-compose.yaml lady:~/.docker-compose/security-tools/

# Deploy on Lady
ssh lady "cd ~/.docker-compose/security-tools && docker compose up -d"

# Update Traefik label
ssh lady "sed -i 's/quietly.its.me/quietly.online/' ~/.docker-compose/security-tools/docker-compose.yaml"
ssh lady "cd ~/.docker-compose/security-tools && docker compose up -d"
```

#### Step 3: Install Lynis on Both Servers (30 min)
```bash
# On Master
sudo apt update && sudo apt install -y lynis

# Create log directory
sudo mkdir -p /var/log/lynis

# Run initial audit
sudo lynis audit system --quick

# Set up weekly cron
echo "0 3 * * 0 root lynis audit system --cronjob --quiet > /var/log/lynis/weekly-$(date +\%Y\%m\%d).log 2>&1" | sudo tee /etc/cron.d/lynis-weekly

# On Lady
ssh lady "sudo apt update && sudo apt install -y lynis"
ssh lady "sudo mkdir -p /var/log/lynis"
ssh lady "sudo lynis audit system --quick"
ssh lady "echo '0 3 * * 0 root lynis audit system --cronjob --quiet > /var/log/lynis/weekly-\$(date +\\%Y\\%m\\%d).log 2>&1' | sudo tee /etc/cron.d/lynis-weekly"
```

#### Step 4: Create Ansible Playbook (30 min)
```yaml
# ~/.ansible/playbooks/security-tools.yml
---
- name: Deploy Security Tools
  hosts: all
  become: yes
  tasks:
    - name: Install Lynis
      apt:
        name: lynis
        state: present
        update_cache: yes

    - name: Create Lynis log directory
      file:
        path: /var/log/lynis
        state: directory
        mode: '0755'

    - name: Setup Lynis weekly cron
      cron:
        name: "Lynis weekly audit"
        hour: "3"
        minute: "0"
        weekday: "0"
        job: "lynis audit system --cronjob --quiet > /var/log/lynis/weekly-$(date +\\%Y\\%m\\%d).log 2>&1"
        user: root

    - name: Create Trivy compose directory
      file:
        path: "/home/{{ ansible_user }}/.docker-compose/security-tools"
        state: directory
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"

    - name: Deploy Trivy docker-compose
      template:
        src: templates/security-tools-compose.j2
        dest: "/home/{{ ansible_user }}/.docker-compose/security-tools/docker-compose.yaml"
        owner: "{{ ansible_user }}"
        group: "{{ ansible_user }}"

    - name: Start Trivy
      community.docker.docker_compose:
        project_src: "/home/{{ ansible_user }}/.docker-compose/security-tools"
        state: present
```

#### Step 5: Documentation (15 min)
Update `~/.docs/security/SECURITY.md` with:
- Tool purposes and usage
- Trivy web UI access (trivy.quietly.its.me)
- Lynis report locations
- How to run manual scans
- Integration with monitoring (future)

### Files Created/Updated
- `~/.docker-compose/security-tools/docker-compose.yaml` (Master)
- `~/.docker-compose/security-tools/docker-compose.yaml` (Lady)
- `~/.ansible/playbooks/security-tools.yml`
- `~/.ansible/playbooks/templates/security-tools-compose.j2`
- Update: `~/.docs/security/SECURITY.md`

### Success Criteria
- [ ] Trivy running on Master with web UI accessible
- [ ] Trivy running on Lady with web UI accessible
- [ ] Lynis installed on both servers
- [ ] Weekly Lynis scans configured
- [ ] Ansible playbook tested
- [ ] Documentation updated
- [ ] Initial vulnerability scan completed

---

## 2. Semaphore CI/CD Expansion

**Estimate**: ~6 hours  
**Priority**: High (Foundation for automation)  
**Current**: 1 instance on Master  
**Target**: 3 instances (Shared, Master-specific, Workers-specific)

### Purpose
Separate Semaphore instances for different automation roles:
- **Shared**: Cross-server orchestration (Master ↔ Lady coordination)
- **Master-specific**: Local Master automation
- **Workers-specific**: Worker server automation (Lady, future madam/beauty)

### Architecture

```
Master (213.136.68.108)
├── Semaphore Shared (ansible-shared.quietly.its.me)
│   └── Cross-server workflows
│   └── Global playbooks
│   └── Full inventory (all servers)
│
└── Semaphore Master (ansible.quietly.its.me) - EXISTING
    └── Master-only tasks
    └── Local Docker deployments
    └── Master monitoring setup

Lady (207.180.251.111)
└── Semaphore Workers (ansible.quietly.online)
    └── Worker-specific tasks
    └── Service deployments
    └── Local health checks
    └── Used by: Lady, Madam, Beauty
```

### Implementation Steps

#### Step 1: Deploy Shared Semaphore on Master (2 hours)

**1.1 Create directory structure**
```bash
mkdir -p ~/.docker-compose/semaphore-shared
mkdir -p ~/.docker/semaphore-shared/database
cd ~/.docker-compose/semaphore-shared
```

**1.2 Create docker-compose.yaml**
```yaml
services:
  semaphore-shared-postgres:
    image: postgres:16-alpine
    container_name: semaphore-shared-db
    environment:
      POSTGRES_USER: semaphore
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
      POSTGRES_DB: semaphore
    volumes:
      - ../../.docker/semaphore-shared/database:/var/lib/postgresql/data
    networks:
      - semaphore-shared
    restart: unless-stopped
    secrets:
      - db_password
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U semaphore"]
      interval: 10s
      timeout: 5s
      retries: 5

  semaphore-shared:
    image: semaphoreui/semaphore:v2.10.22
    container_name: semaphore-shared
    environment:
      SEMAPHORE_DB_DIALECT: postgres
      SEMAPHORE_DB_HOST: semaphore-shared-postgres
      SEMAPHORE_DB_PORT: 5432
      SEMAPHORE_DB_USER: semaphore
      SEMAPHORE_DB_PASS_FILE: /run/secrets/db_password
      SEMAPHORE_DB_NAME: semaphore
      SEMAPHORE_ADMIN: qui3tly
      SEMAPHORE_ADMIN_PASSWORD_FILE: /run/secrets/admin_password
      SEMAPHORE_ADMIN_NAME: "qui3tly"
      SEMAPHORE_ADMIN_EMAIL: "admin@quietly.its.me"
      SEMAPHORE_ACCESS_KEY_ENCRYPTION_FILE: /run/secrets/encryption_key
    volumes:
      - ../../.docker/semaphore-shared:/var/lib/semaphore
      - /home/qui3tly/.ansible-shared:/ansible:ro
      - /home/qui3tly/.ssh:/home/semaphore/.ssh:ro
    networks:
      - semaphore-shared
      - traefik
    restart: unless-stopped
    depends_on:
      semaphore-shared-postgres:
        condition: service_healthy
    secrets:
      - db_password
      - admin_password
      - encryption_key
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.semaphore-shared.rule=Host(`ansible-shared.quietly.its.me`)"
      - "traefik.http.routers.semaphore-shared.entrypoints=websecure"
      - "traefik.http.routers.semaphore-shared.middlewares=authelia@docker,vpn-only@file"
      - "traefik.http.services.semaphore-shared.loadbalancer.server.port=3000"

networks:
  semaphore-shared:
  traefik:
    external: true

secrets:
  db_password:
    file: ../../.secrets/semaphore-shared/db-password
  admin_password:
    file: ../../.secrets/semaphore-shared/admin-password
  encryption_key:
    file: ../../.secrets/semaphore-shared/encryption-key
```

**1.3 Create secrets**
```bash
mkdir -p ~/.secrets/semaphore-shared
chmod 700 ~/.secrets/semaphore-shared

openssl rand -base64 32 > ~/.secrets/semaphore-shared/db-password
echo "RaMpulstilckin123!" > ~/.secrets/semaphore-shared/admin-password
openssl rand -base64 32 > ~/.secrets/semaphore-shared/encryption-key

chmod 600 ~/.secrets/semaphore-shared/*
```

**1.4 Create ansible-shared repository**
```bash
# Create separate ansible repo for cross-server workflows
mkdir -p ~/.ansible-shared/{playbooks,inventory,roles}
cd ~/.ansible-shared

git init
cat > README.md << 'EOF'
# Shared Ansible Repository
Cross-server orchestration playbooks
Managed by: Semaphore Shared (ansible-shared.quietly.its.me)
EOF

# Create inventory
cat > inventory/inventory.ini << 'EOF'
[all:vars]
ansible_port=1006
ansible_user=qui3tly

[control]
master ansible_host=100.64.0.1

[workers]
lady ansible_host=100.64.0.2

[vpn]
master
lady

[monitoring]
master
lady
EOF

git add .
git commit -m "Initial shared ansible repository"
```

**1.5 Deploy and configure**
```bash
cd ~/.docker-compose/semaphore-shared
docker compose up -d

# Wait for startup
sleep 30

# Access: https://ansible-shared.quietly.its.me
# Configure: Add ~/.ansible-shared repository, inventory, SSH key
```

#### Step 2: Reconfigure Master Semaphore (1 hour)

**Purpose**: Refocus existing Semaphore on Master-specific tasks

**2.1 Update documentation**
- Update labels/description to clarify "Master-specific automation"
- Remove cross-server workflows (migrate to Shared)
- Focus on: Master Docker deployments, Master monitoring

**2.2 Inventory adjustment**
```ini
# ~/.ansible/inventory.ini - Update to be Master-focused
[master]
localhost ansible_connection=local

[master:vars]
ansible_python_interpreter=/usr/bin/python3
```

**2.3 Migrate cross-server playbooks**
- Move playbooks that target multiple servers → `~/.ansible-shared/`
- Keep Master-only playbooks in `~/.ansible/`

#### Step 3: Deploy Workers Semaphore on Lady (2 hours)

**3.1 Create on Lady**
```bash
# On Lady
ssh lady "mkdir -p ~/.docker-compose/semaphore-workers"
ssh lady "mkdir -p ~/.docker/semaphore-workers/database"

# Copy compose template
scp ~/.docker-compose/semaphore-shared/docker-compose.yaml lady:~/.docker-compose/semaphore-workers/

# Edit for Lady
ssh lady << 'EOF'
cd ~/.docker-compose/semaphore-workers
sed -i 's/semaphore-shared/semaphore-workers/g' docker-compose.yaml
sed -i 's/ansible-shared.quietly.its.me/ansible.quietly.online/g' docker-compose.yaml
sed -i 's/ansible-shared/ansible-workers/g' docker-compose.yaml
EOF
```

**3.2 Create secrets on Lady**
```bash
ssh lady "mkdir -p ~/.secrets/semaphore-workers && chmod 700 ~/.secrets/semaphore-workers"
ssh lady "openssl rand -base64 32 > ~/.secrets/semaphore-workers/db-password"
ssh lady "echo 'RaMpulstilckin123!' > ~/.secrets/semaphore-workers/admin-password"
ssh lady "openssl rand -base64 32 > ~/.secrets/semaphore-workers/encryption-key"
ssh lady "chmod 600 ~/.secrets/semaphore-workers/*"
```

**3.3 Create ansible-workers repository**
```bash
ssh lady << 'EOF'
mkdir -p ~/.ansible-workers/{playbooks,inventory,roles}
cd ~/.ansible-workers
git init
cat > README.md << 'EOFINNER'
# Workers Ansible Repository
Worker-specific automation playbooks
Managed by: Semaphore Workers (ansible.quietly.online)
Used by: Lady, Madam, Beauty
EOFINNER

# Create inventory - workers only
cat > inventory/inventory.ini << 'EOFINNER'
[all:vars]
ansible_port=1006
ansible_user=qui3tly

[workers]
lady ansible_host=100.64.0.2

[workers:vars]
worker_role=true
EOFINNER

git add .
git commit -m "Initial workers ansible repository"
EOF
```

**3.4 Deploy**
```bash
ssh lady "cd ~/.docker-compose/semaphore-workers && docker compose up -d"
```

#### Step 4: Create Ansible Playbook for Semaphore Deployment (1 hour)
```yaml
# ~/.ansible-shared/playbooks/deploy-semaphore.yml
# Playbook to deploy Semaphore instances via automation
```

#### Step 5: Documentation (30 min)
Update documentation with:
- Three-instance architecture diagram
- When to use which Semaphore
- Access URLs and credentials
- Workflow examples for each instance

### Files Created/Updated
- `~/.docker-compose/semaphore-shared/` (new)
- `~/.docker-compose/semaphore-workers/` (Lady, new)
- `~/.ansible-shared/` (new repository)
- `~/.ansible-workers/` (Lady, new repository)
- Update: `~/.docs/operations/SEMAPHORE_SETUP.md`
- Create: `~/.docs/operations/SEMAPHORE_ARCHITECTURE.md`

### Success Criteria
- [ ] Semaphore Shared running on Master
- [ ] Semaphore Master reconfigured for local tasks
- [ ] Semaphore Workers running on Lady
- [ ] Three separate ansible repositories created
- [ ] Documentation updated with architecture
- [ ] Test workflow executed on each instance

---

## 3. Lady Services Expansion

**Estimate**: ~20 hours  
**Priority**: Medium (Main deliverables)  
**Target**: Lady server deployment

### Purpose
Deploy production services on Lady for office productivity, network management, smart home, and client VPN access.

---

### 3.1 Nextcloud (~3 hours)

**Purpose**: Complete office suite with file storage, calendar, contacts, OnlyOffice integration

#### Architecture
```
Nextcloud Stack on Lady:
├── Nextcloud (PHP-FPM)
├── PostgreSQL database
├── Redis cache
├── OnlyOffice Document Server
└── Traefik (existing) for SSL
```

#### Implementation

**Step 1: Create directory structure**
```bash
ssh lady "mkdir -p ~/.docker-compose/nextcloud"
ssh lady "mkdir -p ~/.docker/nextcloud/{data,database,redis,onlyoffice}"
```

**Step 2: Create docker-compose.yaml**
```yaml
# Complex setup with Nextcloud + DB + Redis + OnlyOffice
# See: https://github.com/nextcloud/docker for reference
services:
  nextcloud-db:
    image: postgres:16-alpine
    # ... config

  nextcloud-redis:
    image: redis:7-alpine
    # ... config

  nextcloud:
    image: nextcloud:28-fpm-alpine
    # ... config

  onlyoffice:
    image: onlyoffice/documentserver:7.5
    # ... config

  nextcloud-cron:
    image: nextcloud:28-fpm-alpine
    entrypoint: /cron.sh
    # ... config
```

**Step 3: Configure**
- Database setup
- Admin user creation
- OnlyOffice integration
- Calendar/Contacts apps
- Mobile app setup

**Step 4: Test**
- Upload/download files
- Edit documents with OnlyOffice
- Sync calendar with mobile
- Share files with users

**Files**: `~/.docker-compose/nextcloud/`, docs update

---

### 3.2 UniFi Controller (~2 hours)

**Purpose**: Network management for Home (EdgeRouter), future Office (MikroTik), Parents (UniFi) sites

#### Architecture
```
UniFi Controller on Lady:
├── UniFi Controller (Java)
└── MongoDB database
```

#### Implementation

**Step 1: Deploy UniFi**
```yaml
services:
  unifi:
    image: lscr.io/linuxserver/unifi-controller:7.5
    container_name: unifi
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Podgorica
      - MEM_LIMIT=1024
    volumes:
      - ../../.docker/unifi/config:/config
    ports:
      - 8443:8443  # Web UI
      - 3478:3478/udp  # STUN
      - 10001:10001/udp  # Device discovery
      - 8080:8080  # Device communication
    restart: unless-stopped
```

**Step 2: Configure sites**
- Home site: Connect EdgeRouter (UBNT discovery)
- Future: Office MikroTik site
- Future: Parents UniFi site

**Files**: `~/.docker-compose/unifi/`, docs update

---

### 3.3 UNMS (~2 hours)

**Purpose**: Alternative/complement to UniFi for network device management

#### Implementation
Similar to UniFi, deploy UNMS container, configure for multi-site management.

**Files**: `~/.docker-compose/unms/`, docs update

---

### 3.4 Home Assistant (~4 hours)

**Purpose**: Smart home automation with network device integration

#### Architecture
```
Home Assistant on Lady:
├── Home Assistant Core
├── PostgreSQL database (recorder)
├── Integrations: UniFi, network devices, IoT
└── Mobile app access
```

#### Implementation

**Step 1: Deploy Home Assistant**
```yaml
services:
  homeassistant:
    image: homeassistant/home-assistant:2024.1
    container_name: homeassistant
    environment:
      - TZ=Europe/Podgorica
    volumes:
      - ../../.docker/homeassistant/config:/config
    network_mode: host
    restart: unless-stopped
```

**Step 2: Configure integrations**
- UniFi integration (network devices)
- MQTT (IoT devices)
- Calendar integration (Nextcloud)
- Notifications (Gotify)

**Step 3: Create automations**
- Network monitoring automations
- Device presence detection
- Alert routing

**Files**: `~/.docker-compose/homeassistant/`, docs update

---

### 3.5 VPN Server with GUI (~6 hours)

**Purpose**: Client VPN for remote workers with web-based user management

#### Architecture
```
VPN Server on Lady:
├── WireGuard or OpenVPN backend
├── Web GUI (wg-easy or similar)
├── Per-branch subnet allocation (10.8.0.0/16)
│   ├── 10.8.1.0/24 - Branch 1
│   ├── 10.8.2.0/24 - Branch 2
│   └── 10.8.X.0/24 - Branch X
├── Certificate management
└── FRR integration (future) for route distribution
```

#### Options

**Option 1: wg-easy** (WireGuard-based)
- Simple web GUI
- QR codes for mobile
- Easy peer management
- Lightweight

**Option 2: OpenVPN Access Server**
- More enterprise features
- More complex setup
- Better for large deployments

**Recommendation**: Start with wg-easy, evaluate OpenVPN AS later if needed

#### Implementation (wg-easy)

**Step 1: Deploy wg-easy**
```yaml
services:
  wg-easy:
    image: ghcr.io/wg-easy/wg-easy:7
    container_name: wg-easy
    environment:
      - WG_HOST=vpn.quietly.online
      - PASSWORD_HASH=$$argon2id$$v=19$$m=16,t=2,p=1$$...  # hashed password
      - WG_DEFAULT_ADDRESS=10.8.0.x
      - WG_DEFAULT_DNS=100.64.0.1  # Pi-hole via Tailnet
      - WG_ALLOWED_IPS=0.0.0.0/0, ::/0  # Full tunnel (or split-tunnel)
    volumes:
      - ../../.docker/wg-easy:/etc/wireguard
    ports:
      - "51821:51821/udp"  # WireGuard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
    networks:
      - traefik
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wg-easy.rule=Host(`vpn.quietly.online`)"
      - "traefik.http.routers.wg-easy.entrypoints=websecure"
      - "traefik.http.services.wg-easy.loadbalancer.server.port=51821"
```

**Step 2: Configure firewall**
```bash
ssh lady "sudo ufw allow 51821/udp comment 'Client VPN'"
```

**Step 3: Create per-branch subnet plan**
```
10.8.0.0/16 - Client VPN Pool
├── 10.8.1.0/24 - Office Branch
├── 10.8.2.0/24 - Remote Workers
├── 10.8.3.0/24 - Mobile Devices
└── 10.8.X.0/24 - Future branches
```

**Step 4: FRR integration (future)**
- Advertise 10.8.0.0/16 via OSPF
- Dynamic routing to all branches
- Exit node toggle capability

**Files**: `~/.docker-compose/wg-easy/`, `~/.docs/services/VPN_SERVER.md`

---

### 3.6 Service Documentation (~3 hours)

**Update all documentation with new services**:
- `~/.docs/services/NEXTCLOUD.md`
- `~/.docs/services/UNIFI.md`
- `~/.docs/services/UNMS.md`
- `~/.docs/services/HOMEASSISTANT.md`
- `~/.docs/services/VPN_SERVER.md`
- Update `~/.docs/architecture/SERVICES.md` with complete inventory
- Create runbooks for each service
- Update Ansible playbooks for automation

---

## 4. WordPress Migration (~8 hours)

**Estimate**: ~8 hours  
**Priority**: Medium (Public-facing)  
**Target**: Lady server

### Purpose
Migrate from old website to qui3tly.cloud infrastructure with proper backup, SSL, and management.

#### Architecture
```
WordPress on Lady:
├── WordPress (PHP-FPM)
├── MariaDB database
├── Traefik (existing) for SSL
└── Automated backups
```

### Implementation Steps

#### Step 1: Content Audit (~2 hours)
- Review current website content
- Decide what to keep/archive/discard
- Plan new site structure
- Identify required plugins/themes
- Export content from old site

#### Step 2: Deployment (~2 hours)
```yaml
# ~/.docker-compose/wordpress/docker-compose.yaml
services:
  wordpress-db:
    image: mariadb:11
    container_name: wordpress-db
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD_FILE: /run/secrets/db_password
    volumes:
      - ../../.docker/wordpress/database:/var/lib/mysql
    restart: unless-stopped
    secrets:
      - db_root_password
      - db_password

  wordpress:
    image: wordpress:6.4-fpm-alpine
    container_name: wordpress
    environment:
      WORDPRESS_DB_HOST: wordpress-db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD_FILE: /run/secrets/db_password
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - ../../.docker/wordpress/html:/var/www/html
    restart: unless-stopped
    depends_on:
      - wordpress-db
    networks:
      - wordpress
      - traefik
    secrets:
      - db_password
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wordpress.rule=Host(`qui3tly.cloud`)"
      - "traefik.http.routers.wordpress.entrypoints=websecure"
      - "traefik.http.services.wordpress.loadbalancer.server.port=9000"

networks:
  wordpress:
  traefik:
    external: true

secrets:
  db_root_password:
    file: ../../.secrets/wordpress/db-root-password
  db_password:
    file: ../../.secrets/wordpress/db-password
```

#### Step 3: Migration (~2 hours)
- Import content from export
- Configure theme
- Install plugins
- Test functionality
- Verify all pages/posts render correctly

#### Step 4: DNS/SSL (~1 hour)
```bash
# Update DNS record via Cloudflare API
curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"qui3tly.cloud","content":"207.180.251.111"}'

# Verify SSL via Traefik (automatic Let's Encrypt)
# Test: https://qui3tly.cloud
```

#### Step 5: Documentation (~1 hour)
- Document WordPress setup in `~/.docs/services/WORDPRESS.md`
- Create content management guide
- Document backup/restore procedures
- Update SERVICES.md inventory

### Files Created/Updated
- `~/.docker-compose/wordpress/docker-compose.yaml`
- `~/.secrets/wordpress/` (passwords)
- `~/.docs/services/WORDPRESS.md`
- `~/.docs/runbooks/wordpress-backup.md`

### Success Criteria
- [ ] WordPress deployed on Lady
- [ ] Content migrated successfully
- [ ] SSL certificate valid
- [ ] DNS pointing to Lady
- [ ] Backups automated
- [ ] Documentation complete

---

## 5. Complete Branding (~12 hours)

**Estimate**: ~12 hours  
**Priority**: Low (Polish)  
**Target**: All services

### Purpose
Create professional visual identity for qui3tly.cloud infrastructure with logos, colors, and branded interfaces.

### Implementation Steps

#### Step 1: Logo Design (~4 hours)

**1.1 Primary Logo**
- Design main logo representing qui3tly.cloud
- Concept: Network/connectivity theme
- Modern, professional, technical
- Works at multiple sizes

**1.2 Variations**
- Dark background version
- Light background version
- Monochrome version
- Icon-only version (favicon, 32x32, 64x64)

**1.3 Export Formats**
- SVG (scalable, web use)
- PNG (multiple sizes: 16x16, 32x32, 64x64, 128x128, 256x256, 512x512)
- ICO (favicon)
- PDF (print, documentation)

**1.4 Storage**
```
~/.branding/logos/
├── primary/
│   ├── logo.svg
│   ├── logo-dark.svg
│   ├── logo-light.svg
│   └── logo-mono.svg
├── icons/
│   ├── favicon.ico
│   ├── favicon-16x16.png
│   ├── favicon-32x32.png
│   └── favicon-64x64.png
└── exports/
    ├── logo-256x256.png
    ├── logo-512x512.png
    └── logo.pdf
```

#### Step 2: Color Scheme (~2 hours)

**2.1 Define Palette**
```
Primary Colors:
- Brand Blue: #0066CC (trustworthy, technical)
- Accent Green: #00CC66 (success, online status)
- Dark Gray: #1A1A1A (backgrounds)
- Light Gray: #F5F5F5 (light mode backgrounds)

Secondary Colors:
- Warning Orange: #FF9900
- Error Red: #CC0000
- Info Cyan: #00CCCC

Monochrome:
- Black: #000000
- Dark: #333333
- Medium: #666666
- Light: #CCCCCC
- White: #FFFFFF
```

**2.2 Dark Theme** (Primary)
```css
:root {
  --bg-primary: #1A1A1A;
  --bg-secondary: #2A2A2A;
  --text-primary: #FFFFFF;
  --text-secondary: #CCCCCC;
  --brand-primary: #0066CC;
  --brand-accent: #00CC66;
}
```

**2.3 Accessibility Verification**
- Check contrast ratios (WCAG AA minimum)
- Test with colorblind simulators
- Ensure sufficient differentiation

**2.4 Storage**
```
~/.branding/colors/
├── palette.json
├── css-variables.css
├── scss-variables.scss
└── accessibility-report.md
```

#### Step 3: Visual Assets (~4 hours)

**3.1 Dashboard Headers**
- Grafana header banner
- Portainer header banner
- Semaphore header banner
- All services: Consistent branded header

**3.2 Login Pages**
- Custom Authelia login page
- Branded background
- Logo placement
- Color scheme application

**3.3 Error Pages**
- Upgrade current "fuckoff page" with branding
- 403, 404, 500, 503 error pages
- Traefik error page templates
- Maintain humor but add branding

**3.4 Email Templates**
- Gotify notification templates
- Alertmanager alert emails
- Mailcow branded emails
- System notification templates

**3.5 Social Media Assets** (Optional)
- Open Graph images (og:image for links)
- Twitter Card images
- LinkedIn preview images

**3.6 Storage**
```
~/.branding/assets/
├── headers/
│   ├── grafana-header.png
│   ├── portainer-header.png
│   └── semaphore-header.png
├── login/
│   ├── authelia-bg.jpg
│   └── authelia-custom.css
├── errors/
│   ├── 403.html
│   ├── 404.html
│   ├── 500.html
│   └── 503.html
├── emails/
│   ├── gotify-template.html
│   └── alert-template.html
└── social/
    ├── og-image.png
    └── twitter-card.png
```

#### Step 4: Implementation (~2 hours)

**4.1 Grafana Branding**
```ini
# grafana.ini
[server]
domain = grafana.quietly.its.me

[branding]
logo_path = /usr/share/grafana/public/img/custom-logo.svg
header_logo_path = /usr/share/grafana/public/img/custom-header.png
```

**4.2 Portainer Branding**
```
# Custom logo via Settings > Appearance
Upload: ~/.branding/logos/icons/favicon-64x64.png
```

**4.3 Authelia Branding**
```yaml
# authelia-config.yaml
theme: dark
branding:
  logo: /path/to/logo.svg
  favicon: /path/to/favicon.ico
```

**4.4 Traefik Error Pages**
```yaml
# Traefik dynamic config
http:
  middlewares:
    errors:
      errors:
        status:
          - "403-404"
          - "500-599"
        service: error-pages
        query: /{status}.html
```

**4.5 Documentation**
Create: `~/.branding/IMPLEMENTATION_GUIDE.md`
- How to apply branding to new services
- File locations and formats
- Color usage guidelines
- Logo usage guidelines

### Files Created
- `~/.branding/logos/` (multiple files)
- `~/.branding/colors/` (CSS, JSON, docs)
- `~/.branding/assets/` (images, templates)
- `~/.branding/GUIDE.md`
- `~/.branding/IMPLEMENTATION_GUIDE.md`
- Updated service configs

### Success Criteria
- [ ] Logo created in all required formats
- [ ] Color scheme defined and documented
- [ ] WCAG AA accessibility verified
- [ ] Dashboard headers applied to all services
- [ ] Custom login pages implemented
- [ ] Branded error pages deployed
- [ ] Implementation guide complete

---

## 6. Server Expansion (Timeline TBD)

**Estimate**: ~6 hours per server  
**Priority**: Low (Scale out)  
**Target**: Add madam.qui3tly.cloud, beauty.qui3tly.cloud

### Purpose
Add worker servers to the mesh for:
- Geographic distribution
- Load balancing
- Service isolation
- Redundancy

### Implementation Per Server

#### Step 1: Provision VPS (~30 min + wait time)
- Order Contabo VPS (same specs as Lady)
- Receive credentials
- Initial SSH access

#### Step 2: Ansible Bootstrap (~30 min)
```bash
# Add to inventory
echo "madam ansible_host=<IP>" >> ~/.ansible/inventory.ini

# Run bootstrap playbook (same as Lady)
ansible-playbook ~/.ansible/playbooks/bootstrap.yml -i ~/.ansible/inventory.ini --limit madam
```

#### Step 3: Base Services (~2 hours)
```bash
# Deploy foundation stack
ansible-playbook ~/.ansible-shared/playbooks/deploy-base-services.yml --limit madam

# Includes:
# - Traefik
# - Portainer agent
# - Monitoring (node-exporter, cadvisor, promtail)
# - CrowdSec + bouncer
# - UFW firewall
```

#### Step 4: Tailnet Connection (~15 min)
```bash
# Join Tailscale mesh
ssh madam "curl -fsSL https://tailscale.com/install.sh | sh"
ssh madam "tailscale up --login-server=https://headscale.quietly.online"

# On Master: Approve node in Headscale
headscale nodes register --user qui3tly --key <node_key>
```

#### Step 5: Monitoring Integration (~1 hour)
- Add Prometheus scrape targets
- Add Portainer endpoint
- Add Loki log collection
- Verify dashboards show new server

#### Step 6: DR Testing (~1 hour)
```bash
# Test DR deployment to new server
ansible-playbook ~/.ansible-shared/playbooks/madam-dr.yml --check

# If check passes, test actual deployment
ansible-playbook ~/.ansible-shared/playbooks/madam-dr.yml
```

#### Step 7: Documentation (~30 min)
- Update SERVERS.md with new server
- Update network diagrams
- Update inventory files
- Document any server-specific notes

### Files Created/Updated
- Update: `~/.ansible/inventory.ini`
- Update: `~/.docs/architecture/SERVERS.md`
- Update: `~/.docs/architecture/NETWORK.md` (diagrams)
- Create: `~/.ansible-shared/playbooks/madam-dr.yml`
- Create: `~/.ansible-shared/playbooks/beauty-dr.yml`

### Success Criteria Per Server
- [ ] Server provisioned and accessible
- [ ] Ansible bootstrap complete
- [ ] Base services deployed and healthy
- [ ] Tailnet connection established
- [ ] Monitoring integrated
- [ ] DR tested and validated
- [ ] Documentation updated

---

## Summary

### Total Effort

| Deployment | Hours | Priority | Complexity |
|------------|-------|----------|------------|
| Security Tools | 2 | High | Medium |
| Semaphore Expansion | 6 | High | High |
| Nextcloud | 3 | Medium | Medium |
| UniFi Controller | 2 | Medium | Low |
| UNMS | 2 | Medium | Low |
| Home Assistant | 4 | Medium | Medium |
| VPN Server | 6 | Medium | High |
| Service Docs | 3 | Medium | Low |
| WordPress Migration | 8 | Medium | Medium |
| Branding | 12 | Low | Medium |
| Server Expansion (×2) | 12 | Low | Medium |
| **TOTAL** | **56** | | |

### Recommended Order

1. **Security Tools** (2h) - Quick win, improves security posture
2. **Semaphore Expansion** (6h) - Foundation for automated deployments
3. **Lady Services** (20h) - Main deliverables
   - Nextcloud (3h)
   - UniFi (2h)
   - UNMS (2h)
   - Home Assistant (4h)
   - VPN Server (6h)
   - Documentation (3h)
4. **WordPress** (8h) - Public-facing site
5. **Branding** (12h) - Polish and professional appearance
6. **Server Expansion** (12h) - Scale out when needed

### Dependencies

- **Semaphore Expansion** should be done before Lady Services (enables automation)
- **VPN Server** benefits from FRR/OSPF (Phase V future work)
- **Server Expansion** uses patterns established in Lady Services
- **Branding** can be done in parallel with other work

### Success Metrics

**Phase IV Complete**:
- [ ] 2 security tools deployed (Master + Lady)
- [ ] 3 Semaphore instances operational
- [ ] 5 Lady services deployed and documented
- [ ] WordPress migrated successfully
- [ ] Complete branding applied
- [ ] 2 additional servers online (madam + beauty)
- [ ] All services documented
- [ ] All Ansible playbooks created
- [ ] DR validated for all servers

---

**Phase**: Phase IV (Future Infrastructure Expansion)  
**Status**: Ready for sequential execution  
**Prerequisite**: Phase III (Documentation Consolidation) complete  
**Next**: Start with Security Tools (quick win)

---

**The A+++ Destroyer Partnership**: qui3tly + Lucky Luke 🤠  
*Experience + Speed = Unstoppable* 🚀
