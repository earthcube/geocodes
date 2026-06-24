#!/usr/bin/env bash
# Bootstrap a fresh Ubuntu/Debian or Amazon Linux VM for the geocodes stack.
# Run as root or with sudo from the deployment/simple/ directory.
#
# What this does:
#   1. Installs Docker CE + Docker Compose plugin
#   2. Initialises Docker Swarm (required for Gleaner/Nabu job scheduling)
#   3. Creates the headless_gleanerio overlay network
#   4. Prints next-step instructions

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log()     { echo -e "${GREEN}[setup]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }
die()     { echo -e "${RED}[error]${NC} $*" >&2; exit 1; }
section() { echo -e "\n${BLUE}════════════════════════════════════════${NC}\n${BLUE} $*${NC}\n${BLUE}════════════════════════════════════════${NC}"; }

[[ "$(id -u)" -eq 0 ]] || die "Run as root or with sudo: sudo bash $0"

# ─────────────────────────────────────────────────────────────────────────────
section "1 / 4  Detect OS"
# ─────────────────────────────────────────────────────────────────────────────

[[ -f /etc/os-release ]] || die "Cannot detect OS — /etc/os-release not found."
. /etc/os-release
OS_ID="${ID}"
OS_PRETTY="${PRETTY_NAME:-$OS_ID ${VERSION_ID:-}}"
log "Detected: ${OS_PRETTY}"

# ─────────────────────────────────────────────────────────────────────────────
section "2 / 4  Install Docker"
# ─────────────────────────────────────────────────────────────────────────────

install_docker_ubuntu_debian() {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -q
    apt-get install -y -q ca-certificates curl gnupg lsb-release
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/${OS_ID}/gpg" \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/${OS_ID} $(lsb_release -cs) stable" \
        > /etc/apt/sources.list.d/docker.list
    apt-get update -q
    apt-get install -y -q \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
}

install_docker_amzn() {
    dnf update -y -q
    dnf install -y -q docker
    # docker compose plugin — install from GitHub since it's not in amzn repos
    local compose_ver
    compose_ver=$(curl -fsSL https://api.github.com/repos/docker/compose/releases/latest \
        | grep '"tag_name"' | head -1 | cut -d '"' -f4)
    local cli_plugins=/usr/local/lib/docker/cli-plugins
    mkdir -p "${cli_plugins}"
    curl -fsSL \
        "https://github.com/docker/compose/releases/download/${compose_ver}/docker-compose-linux-$(uname -m)" \
        -o "${cli_plugins}/docker-compose"
    chmod +x "${cli_plugins}/docker-compose"
}

if command -v docker &>/dev/null && docker compose version &>/dev/null 2>&1; then
    log "Docker already installed: $(docker --version)"
else
    case "${OS_ID}" in
        ubuntu|debian)  install_docker_ubuntu_debian ;;
        amzn)           install_docker_amzn ;;
        *)
            die "Unsupported OS '${OS_ID}'. Install Docker CE manually, then re-run from step 3."
            ;;
    esac
    systemctl enable --now docker
    log "Docker installed:         $(docker --version)"
    log "Docker Compose installed: $(docker compose version)"
fi

if [[ -n "${SUDO_USER:-}" ]]; then
    usermod -aG docker "${SUDO_USER}" 2>/dev/null || true
    warn "Added '${SUDO_USER}' to the docker group. Log out and back in for it to take effect."
fi

# ─────────────────────────────────────────────────────────────────────────────
section "3 / 4  Initialise Docker Swarm"
# ─────────────────────────────────────────────────────────────────────────────

# Gleaner and Nabu run as Docker Swarm service jobs (replicated-job mode).
# A single-node swarm is sufficient — no multi-node cluster required.

SWARM_STATE=$(docker info --format '{{.Swarm.LocalNodeState}}' 2>/dev/null || echo unknown)
if [[ "${SWARM_STATE}" == "active" ]]; then
    log "Docker Swarm already active (node: $(docker info --format '{{.Swarm.NodeID}}'))"
else
    ADVERTISE_IP=$(hostname -I | awk '{print $1}')
    docker swarm init --advertise-addr "${ADVERTISE_IP}"
    log "Swarm initialised (advertise addr: ${ADVERTISE_IP})"
fi

# ─────────────────────────────────────────────────────────────────────────────
section "4 / 4  Create headless_gleanerio overlay network"
# ─────────────────────────────────────────────────────────────────────────────

# Gleaner/Nabu Swarm services need an attachable overlay network for internet
# access during crawls.  The name is read from GLEANERIO_DOCKER_HEADLESS_NETWORK
# in .env (default: headless_gleanerio).

NETWORK_NAME=$(grep -E '^GLEANERIO_HEADLESS_NETWORK=' .env 2>/dev/null \
    | cut -d= -f2 || echo headless_gleanerio)

if docker network ls --filter "name=^${NETWORK_NAME}$" --format '{{.Name}}' \
        | grep -qx "${NETWORK_NAME}"; then
    log "Overlay network '${NETWORK_NAME}' already exists"
else
    docker network create -d overlay --attachable "${NETWORK_NAME}"
    log "Created overlay network: ${NETWORK_NAME}"
fi

# ─────────────────────────────────────────────────────────────────────────────
section "Bootstrap complete — next steps"
# ─────────────────────────────────────────────────────────────────────────────

PUBLIC_IP=$(curl -fsSL --max-time 2 http://169.254.169.254/latest/meta-data/public-ipv4 \
    2>/dev/null || hostname -I | awk '{print $1}')

echo ""
echo "  1. Copy and edit the environment file:"
echo "       cp .env.example .env"
echo "       nano .env"
echo "       # Required: PROJECT  AWS_ACCESS_KEY_ID  AWS_SECRET_ACCESS_KEY"
echo "       #           S3_BUCKET  QLEVERUI_SECRET_KEY"
echo ""
echo "  2. Edit the Qlever source list:"
echo "       nano qlever/Qleverfile"
echo "       # Set SOURCES (space-separated) and BASE_URL for your S3 bucket"
echo ""
echo "  3. Edit the FacetSearch config:"
echo "       nano facetsearch/config.yaml"
echo "       # Replace YOUR_HOSTNAME with: ${PUBLIC_IP}"
echo ""
echo "  4. Customise and upload Gleaner/Nabu configs to S3:"
echo "       nano scheduler/gleanerconfig.yaml  # mark sources active: true"
echo "       bash scripts/upload-configs.sh"
echo ""
echo "  5. Start the stack:"
echo "       docker compose up -d"
echo ""
echo "  Endpoints (once running):"
echo "    FacetSearch:  http://${PUBLIC_IP}/"
echo "    Dagster UI:   http://${PUBLIC_IP}:3001/"
echo "    Qlever UI:    http://${PUBLIC_IP}:7000/"
echo "    SPARQL:       http://${PUBLIC_IP}/sparql"
echo ""
