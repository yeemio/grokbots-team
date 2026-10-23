#!/usr/bin/env bash
# new-package.sh — mkdir work + control stub, write HANDOFF, upsert board row.
# Dispatch-first: print DISPATCH NOW; Control must not research contracts further.
#
# Usage:
#   ./new-package.sh --id T12 --case TC13 --title "refund dual" \
#       --work-dir /workspace/OwlcodaE-tc13-refund-20261023
# Optional:
#   --contract PATH --contract-sha SHA --deliver-tag TAG --model "GLM-5.3"
#   --boundaries "..." --goal "..."

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PKG_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
TEMPLATE="$PKG_ROOT/templates/HANDOFF.md"
BOARD_DIR="$PKG_ROOT/board"
BOARD="$BOARD_DIR/status.json"

ID=""
CASE=""
TITLE=""
WORK_DIR=""
CONTRACT_PATH="(fill after dispatch in FDE)"
CONTRACT_SHA="pending"
DELIVER_TAG=""
MODEL="GLM-5.3"
BOUNDARIES="No shared UI/launcher/client/pin/index.ts; no CloudAgent/Formal/merge; parallel dirs only."
GOAL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) ID=$2; shift 2 ;;
    --case) CASE=$2; shift 2 ;;
    --title) TITLE=$2; shift 2 ;;
    --work-dir) WORK_DIR=$2; shift 2 ;;
    --contract) CONTRACT_PATH=$2; shift 2 ;;
    --contract-sha) CONTRACT_SHA=$2; shift 2 ;;
    --deliver-tag) DELIVER_TAG=$2; shift 2 ;;
    --model) MODEL=$2; shift 2 ;;
    --boundaries) BOUNDARIES=$2; shift 2 ;;
    --goal) GOAL=$2; shift 2 ;;
    -h|--help)
      sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$ID" || -z "$CASE" || -z "$TITLE" || -z "$WORK_DIR" ]]; then
  echo "Usage: $0 --id T12 --case TC13 --title \"...\" --work-dir /workspace/OwlcodaE-..." >&2
  exit 1
fi

if [[ -z "$GOAL" ]]; then
  GOAL="$TITLE"
fi
if [[ -z "$DELIVER_TAG" ]]; then
  DELIVER_TAG="${ID}-${CASE}-DELIVERED"
fi

TODAY=$(date '+%Y%m%d')
NOW=$(date '+%Y-%m-%dT%H:%M:%S%z' | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')
ID_LC=$(printf '%s' "$ID" | tr '[:upper:]' '[:lower:]')
CASE_LC=$(printf '%s' "$CASE" | tr '[:upper:]' '[:lower:]')
SLUG="${ID_LC}-${CASE_LC}"
CONTROL_STUB="/workspace/${SLUG}-${TODAY}"

mkdir -p "$WORK_DIR"
mkdir -p "$CONTROL_STUB"
mkdir -p "$BOARD_DIR"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Missing template: $TEMPLATE" >&2
  exit 1
fi

HANDOFF="$CONTROL_STUB/HANDOFF.md"
# Escape sed replacement specials in values (& \ | and newlines → space)
_sed_escape() {
  printf '%s' "$1" | sed -e 's/[&|\\]/\\&/g' | tr '\n' ' '
}

GOAL_E=$(_sed_escape "$GOAL")
TITLE_E=$(_sed_escape "$TITLE")
WORK_E=$(_sed_escape "$WORK_DIR")
MODEL_E=$(_sed_escape "$MODEL")
CPATH_E=$(_sed_escape "$CONTRACT_PATH")
CSHA_E=$(_sed_escape "$CONTRACT_SHA")
DTAG_E=$(_sed_escape "$DELIVER_TAG")
BOUND_E=$(_sed_escape "$BOUNDARIES")
ID_E=$(_sed_escape "$ID")
CASE_E=$(_sed_escape "$CASE")

sed \
  -e "s|{{TASK_ID}}|${ID_E}|g" \
  -e "s|{{CASE_ID}}|${CASE_E}|g" \
  -e "s|{{GOAL}}|${GOAL_E}|g" \
  -e "s|{{WORK_DIR}}|${WORK_E}|g" \
  -e "s|{{MODEL}}|${MODEL_E}|g" \
  -e "s|{{CONTRACT_PATH}}|${CPATH_E}|g" \
  -e "s|{{CONTRACT_SHA}}|${CSHA_E}|g" \
  -e "s|{{DELIVER_TAG}}|${DTAG_E}|g" \
  -e "s|{{BOUNDARIES}}|${BOUND_E}|g" \
  "$TEMPLATE" > "$HANDOFF"

# Also drop a pointer in work_dir for FDE discovery
printf 'Control HANDOFF: %s\n' "$HANDOFF" > "$WORK_DIR/HANDOFF.pointer.txt"

ROW_TITLE="${CASE} ${TITLE}"
# Upsert board/status.json
if command -v jq >/dev/null 2>&1; then
  if [[ ! -f "$BOARD" ]]; then
    echo '[]' > "$BOARD"
  fi
  tmp=$(mktemp)
  jq \
    --arg id "$ID" \
    --arg title "$ROW_TITLE" \
    --arg work_dir "$WORK_DIR" \
    --arg model "$MODEL" \
    --arg status "DISPATCHED" \
    --arg updated_at "$NOW" \
    --arg notes "HANDOFF at $HANDOFF; control stub $CONTROL_STUB" \
    '
      (map(.id) | index($id)) as $i
      | if $i != null then
          .[$i] = (.[$i] + {
            title: $title,
            work_dir: $work_dir,
            model: $model,
            status: $status,
            updated_at: $updated_at,
            notes: $notes
          })
        else
          . + [{
            id: $id,
            title: $title,
            work_dir: $work_dir,
            zcode_session: "",
            model: $model,
            status: $status,
            pr_url: "",
            notes: $notes,
            updated_at: $updated_at
          }]
        end
    ' "$BOARD" > "$tmp" && mv "$tmp" "$BOARD"
else
  python3 - "$BOARD" "$ID" "$ROW_TITLE" "$WORK_DIR" "$MODEL" "$NOW" "$HANDOFF" "$CONTROL_STUB" <<'PY'
import json, sys
path, id_, title, work_dir, model, now, handoff, stub = sys.argv[1:]
try:
    with open(path) as f:
        rows = json.load(f)
except FileNotFoundError:
    rows = []
notes = f"HANDOFF at {handoff}; control stub {stub}"
found = False
for r in rows:
    if r.get("id") == id_:
        r.update({
            "title": title,
            "work_dir": work_dir,
            "model": model,
            "status": "DISPATCHED",
            "updated_at": now,
            "notes": notes,
        })
        found = True
        break
if not found:
    rows.append({
        "id": id_,
        "title": title,
        "work_dir": work_dir,
        "zcode_session": "",
        "model": model,
        "status": "DISPATCHED",
        "pr_url": "",
        "notes": notes,
        "updated_at": now,
    })
with open(path, "w") as f:
    json.dump(rows, f, indent=2)
    f.write("\n")
PY
fi

echo "work_dir:      $WORK_DIR"
echo "control_stub:  $CONTROL_STUB"
echo "handoff:       $HANDOFF"
echo "board:         $BOARD"
echo ""
echo "DISPATCH NOW — do not research further; SendToAgent FDE with this HANDOFF"
echo "$HANDOFF"
