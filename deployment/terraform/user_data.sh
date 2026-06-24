#!/bin/bash
# Cloud-init bootstrap for the geocodes EC2 instance.
# Terraform templatefile() interpolates ${...} variables; bash variables
# use $${...} syntax (produces literal ${...} in the rendered script).

set -euo pipefail
exec > >(tee /var/log/geocodes-setup.log) 2>&1
echo "=== geocodes cloud-init start ==="
date

# ── 1. Install Docker CE ────────────────────────────────────────────────────
export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get install -y -q ca-certificates curl gnupg lsb-release git openssl

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

apt-get update -q
apt-get install -y -q \
    docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
echo "Docker installed: $$(docker --version)"

# ── 2. Init Docker Swarm ─────────────────────────────────────────────────────
ADVERTISE_IP=$$(hostname -I | awk '{print $$1}')
docker swarm init --advertise-addr "$${ADVERTISE_IP}" || true

# ── 3. Create overlay network ────────────────────────────────────────────────
docker network create -d overlay --attachable headless_gleanerio 2>/dev/null || true

# ── 4. Clone repo ────────────────────────────────────────────────────────────
git clone --branch ${repo_branch} ${repo_url} ${deployment_path}

# ── 5. Generate .env ─────────────────────────────────────────────────────────
cd ${deployment_path}/deployment/simple
cp .env.example .env

sed -i "s|^PROJECT=.*|PROJECT=${project_name}|" .env
sed -i "s|^S3_BUCKET=.*|S3_BUCKET=${s3_bucket}|" .env
sed -i "s|^AWS_ACCESS_KEY_ID=.*|AWS_ACCESS_KEY_ID=${iam_access_key}|" .env
sed -i "s|^AWS_SECRET_ACCESS_KEY=.*|AWS_SECRET_ACCESS_KEY=${iam_secret_key}|" .env

# Generate a random secret key for the Qlever UI Django app
QLEVERUI_SECRET=$$(openssl rand -hex 32)
sed -i "s|^QLEVERUI_SECRET_KEY=.*|QLEVERUI_SECRET_KEY=$${QLEVERUI_SECRET}|" .env

# ── 6. Update Qleverfile with the S3 bucket URL ──────────────────────────────
sed -i \
    "s|https://CHANGE_ME.s3.amazonaws.com|https://${s3_bucket}.s3.${aws_region}.amazonaws.com|" \
    qlever/Qleverfile

# ── 7. Update FacetSearch config with the public IP ─────────────────────────
PUBLIC_IP=$$(curl -fsSL --max-time 5 http://169.254.169.254/latest/meta-data/public-ipv4 \
    || hostname -I | awk '{print $$1}')
sed -i "s|YOUR_HOSTNAME|$${PUBLIC_IP}|g" facetsearch/config.yaml

# ── 8. Copy scheduler config templates into place ────────────────────────────
# Operators should edit scheduler/*.yaml to enable sources, then run:
#   bash scripts/upload-configs.sh
mkdir -p scheduler
cp -n scheduler/gleanerconfig.yaml scheduler/gleanerconfig.yaml 2>/dev/null || true
cp -n scheduler/nabuconfig.yaml    scheduler/nabuconfig.yaml    2>/dev/null || true
cp -n scheduler/tenant.yaml        scheduler/tenant.yaml        2>/dev/null || true

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "=== geocodes cloud-init complete ==="
echo ""
echo "Next steps (from ${deployment_path}/deployment/simple):"
echo "  1. Edit scheduler/*.yaml — set active: true for desired sources"
echo "  2. Run: bash scripts/upload-configs.sh"
echo "  3. Edit qlever/Qleverfile — update SOURCES list to match active sources"
echo "  4. Run: docker compose up -d"
echo ""
echo "Endpoints:"
echo "  FacetSearch: http://$${PUBLIC_IP}/"
echo "  Dagster UI:  http://$${PUBLIC_IP}:3001/"
echo "  Qlever UI:   http://$${PUBLIC_IP}:7000/"
echo "  SPARQL:      http://$${PUBLIC_IP}/sparql"
date
