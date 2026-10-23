#!/usr/bin/env bash
# scaffold-delivery-dirs.sh — create delivery/evidence dirs under a work root
#
# Usage:
#   ./scaffold-delivery-dirs.sh <workRoot> <slug>
#
# Creates:
#   <workRoot>/delivery/archives
#   <workRoot>/delivery/manifests
#   <workRoot>/output/<slug>/
#   <workRoot>/docs/task-packages/<slug>/evidence/shots

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <workRoot> <slug>" >&2
  exit 1
fi

WORK_ROOT=$(cd "$1" && pwd)
SLUG=$2

if [[ ! "$SLUG" =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "slug must be [A-Za-z0-9._-]+" >&2
  exit 1
fi

dirs=(
  "$WORK_ROOT/delivery/archives"
  "$WORK_ROOT/delivery/manifests"
  "$WORK_ROOT/output/$SLUG"
  "$WORK_ROOT/docs/task-packages/$SLUG/evidence/shots"
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
  echo "created $d"
done

# Lightweight placeholders so the tree is discoverable
touch "$WORK_ROOT/delivery/manifests/.gitkeep"
touch "$WORK_ROOT/delivery/archives/.gitkeep"
touch "$WORK_ROOT/output/$SLUG/.gitkeep"
touch "$WORK_ROOT/docs/task-packages/$SLUG/evidence/shots/.gitkeep"

if [[ ! -f "$WORK_ROOT/delivery/RESTORE.md" ]]; then
  cat > "$WORK_ROOT/delivery/RESTORE.md" <<'STUB'
# RESTORE — fill from ui-evidence-scaffold/templates/RESTORE.md
STUB
  echo "stubbed $WORK_ROOT/delivery/RESTORE.md"
fi

echo "done. workRoot=$WORK_ROOT slug=$SLUG"
