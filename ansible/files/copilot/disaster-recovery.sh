#!/bin/bash
#===============================================================================
# DISASTER RECOVERY SCRIPT
# Purpose: Restore all services from git in under 60 seconds
# Usage: ./disaster-recovery.sh [full|services|check]
#===============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

HOME_DIR="/home/qui3tly"
COMPOSE_DIR="$HOME_DIR/.docker-compose"
SECRETS_DIR="$HOME_DIR/.secrets"

# Services to start in order (dependencies first)
SERVICES=(
    "traefik"
    "pihole"
    "portainer"
    "monitoring"
    "gotify"
    "semaphore"
    "it-tools"
    "admin-panel"
    "fuckoff-page"
    "headscale-ui"
)

log() { echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_secrets() {
    log "Checking required secrets..."
    local missing=0
    
    # Required secrets per service
    declare -A REQUIRED_SECRETS=(
        ["traefik"]="traefik/cf-token"
        ["gotify"]="gotify/admin-password"
        ["semaphore"]="semaphore/admin-password"
        ["monitoring"]="monitoring/grafana_admin_password"
        ["headscale"]="headscale/keys.env"
    )
    
    for svc in "${!REQUIRED_SECRETS[@]}"; do
        secret_file="$SECRETS_DIR/${REQUIRED_SECRETS[$svc]}"
        if [[ ! -f "$secret_file" ]]; then
            error "Missing: $secret_file"
            missing=$((missing + 1))
        fi
    done
    
    if [[ $missing -gt 0 ]]; then
        error "$missing secrets missing! Cannot proceed."
        echo ""
        echo "Run: $0 template  # to see what secrets are needed"
        exit 1
    fi
    
    log "All required secrets present ✓"
}

check_permissions() {
    log "Checking permissions..."
    
    # Secrets folder needs 711 for docker access
    if [[ $(stat -c %a "$SECRETS_DIR") != "711" ]]; then
        warn "Fixing ~/.secrets permissions (711 for docker access)"
        chmod 711 "$SECRETS_DIR"
    fi
    
    # Monitoring secrets need 711
    if [[ -d "$SECRETS_DIR/monitoring" ]]; then
        chmod 711 "$SECRETS_DIR/monitoring"
        chmod 644 "$SECRETS_DIR/monitoring/grafana_admin_password" 2>/dev/null || true
    fi
    
    log "Permissions OK ✓"
}

restore_from_git() {
    log "Restoring configs from git..."
    cd "$HOME_DIR"
    
    # Reset any local changes to tracked files
    git checkout -- .docker/ .docker-compose/
    
    log "Git restore complete ✓"
}

create_networks() {
    log "Creating Docker networks..."
    docker network create traefik 2>/dev/null || true
    docker network create monitoring 2>/dev/null || true
    docker network create pihole_internal 2>/dev/null || true
    log "Networks ready ✓"
}

start_services() {
    log "Starting services..."
    local failed=0
    
    for svc in "${SERVICES[@]}"; do
        # Try .yml first (more common), then .yaml
        compose_file="$COMPOSE_DIR/$svc/docker-compose.yml"
        if [[ ! -f "$compose_file" ]]; then
            compose_file="$COMPOSE_DIR/$svc/docker-compose.yaml"
        fi
        
        if [[ -f "$compose_file" ]]; then
            echo -n "  Starting $svc... "
            if docker compose -f "$compose_file" up -d 2>/dev/null; then
                echo -e "${GREEN}OK${NC}"
            else
                echo -e "${RED}FAILED${NC}"
                failed=$((failed + 1))
            fi
        else
            echo -e "  ${YELLOW}Skipping $svc (no compose file)${NC}"
        fi
    done
    
    if [[ $failed -gt 0 ]]; then
        error "$failed service(s) failed to start!"
        return 1
    fi
}

show_status() {
    echo ""
    log "Current container status:"
    docker ps --format "table {{.Names}}\t{{.Status}}" | sort
    
    echo ""
    local unhealthy=$(docker ps --filter "health=unhealthy" --format "{{.Names}}" 2>/dev/null)
    local restarting=$(docker ps --filter "status=restarting" --format "{{.Names}}" 2>/dev/null)
    
    if [[ -n "$unhealthy" ]] || [[ -n "$restarting" ]]; then
        error "Problem containers:"
        [[ -n "$unhealthy" ]] && echo "  Unhealthy: $unhealthy"
        [[ -n "$restarting" ]] && echo "  Restarting: $restarting"
    else
        log "All containers healthy ✓"
    fi
}

show_template() {
    cat << 'EOF'
===============================================================================
SECRETS TEMPLATE - Create these files in ~/.secrets/
===============================================================================

Required secrets structure:
~/.secrets/                          # chmod 711
├── traefik/
│   └── cf-token                     # Cloudflare API token
├── monitoring/                      # chmod 711
│   └── grafana_admin_password       # chmod 644 (Grafana user: qui3tly)
├── semaphore/
│   └── admin-password               # Semaphore admin password
├── gotify/
│   └── admin-password               # Gotify admin password
├── headscale/
│   └── keys.env                     # HEADSCALE_API_KEY=...
├── authelia/                        # (if using)
│   ├── jwt                          # 64-char random
│   ├── session                      # 64-char random
│   └── storage                      # 64-char random
└── portainer/
    └── encryption_key               # Portainer encryption key

Generate random secrets:
  openssl rand -hex 32 > ~/.secrets/authelia/jwt
  openssl rand -hex 32 > ~/.secrets/authelia/session
  openssl rand -hex 32 > ~/.secrets/authelia/storage

After creating secrets:
  chmod 711 ~/.secrets ~/.secrets/monitoring
  chmod 600 ~/.secrets/*/*
  chmod 644 ~/.secrets/monitoring/grafana_admin_password
===============================================================================
EOF
}

full_recovery() {
    echo "==============================================================================="
    echo "DISASTER RECOVERY - Full restore from git"
    echo "==============================================================================="
    echo ""
    
    check_secrets
    check_permissions
    restore_from_git
    create_networks
    start_services
    
    sleep 5
    show_status
    
    echo ""
    log "Recovery complete!"
}

case "${1:-full}" in
    full)
        full_recovery
        ;;
    services)
        check_secrets
        check_permissions
        start_services
        sleep 5
        show_status
        ;;
    check)
        check_secrets
        check_permissions
        show_status
        ;;
    template)
        show_template
        ;;
    *)
        echo "Usage: $0 [full|services|check|template]"
        echo ""
        echo "  full      - Full recovery: git restore + start all services"
        echo "  services  - Start all services (no git restore)"
        echo "  check     - Check secrets and show status"
        echo "  template  - Show secrets template"
        exit 1
        ;;
esac
