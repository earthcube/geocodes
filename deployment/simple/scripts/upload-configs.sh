#!/usr/bin/env bash
# Upload Gleaner, Nabu, and tenant config files from scheduler/ to S3.
# Run from deployment/simple/ after editing scheduler/*.yaml and filling in .env.
#
# Usage:
#   bash scripts/upload-configs.sh
#   bash scripts/upload-configs.sh --dry-run

set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[upload]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC}  $*"; }
die()  { echo -e "${RED}[error]${NC} $*" >&2; exit 1; }

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ── Load .env ─────────────────────────────────────────────────────────────────

[[ -f .env ]] || die ".env not found. Copy .env.example to .env and fill in credentials."
# shellcheck disable=SC1091
set -a; source .env; set +a

: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID not set in .env}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY not set in .env}"
: "${S3_BUCKET:?S3_BUCKET not set in .env}"

CONFIG_PATH="${GLEANERIO_DAGSTER_CONFIG_PATH:-scheduler/configs}"
# Strip trailing slash
CONFIG_PATH="${CONFIG_PATH%/}"
AWS_REGION="${AWS_DEFAULT_REGION:-us-east-1}"

export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION="${AWS_REGION}"

# ── Verify aws CLI ─────────────────────────────────────────────────────────────

if ! command -v aws &>/dev/null; then
    die "aws CLI not found. Install it: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
fi

# ── Upload ────────────────────────────────────────────────────────────────────

SCHEDULER_DIR="$(cd "$(dirname "$0")/../scheduler" && pwd)"

[[ -d "${SCHEDULER_DIR}" ]] || die "scheduler/ directory not found at ${SCHEDULER_DIR}"

FILES=(
    "gleanerconfig.yaml"
    "nabuconfig.yaml"
    "tenant.yaml"
)

log "Target: s3://${S3_BUCKET}/${CONFIG_PATH}/"
log "Files:  ${FILES[*]}"
${DRY_RUN} && warn "DRY RUN — no files will be uploaded"
echo ""

for f in "${FILES[@]}"; do
    src="${SCHEDULER_DIR}/${f}"
    dst="s3://${S3_BUCKET}/${CONFIG_PATH}/${f}"

    [[ -f "${src}" ]] || { warn "Missing: ${src} — skipping"; continue; }

    if ${DRY_RUN}; then
        log "[dry-run] would upload: ${src} → ${dst}"
    else
        aws s3 cp "${src}" "${dst}" \
            --region "${AWS_REGION}" \
            --content-type "application/yaml"
        log "Uploaded: ${dst}"
    fi
done

echo ""
log "Done. Verify with:"
log "  aws s3 ls s3://${S3_BUCKET}/${CONFIG_PATH}/"
