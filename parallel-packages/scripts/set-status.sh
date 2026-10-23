#!/usr/bin/env bash
# set-status.sh — update one board row by id.
#
# Usage:
#   ./set-status.sh --id T12 --status RUNNING \
#       --session session_xxx --model "GLM-5.3"
# Optional: --pr-url URL --notes "..." --work-dir PATH --title "..."

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PKG_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
BOARD="$PKG_ROOT/board/status.json"

ID=""
STATUS=""
SESSION=""
MODEL=""
PR_URL=""
NOTES=""
WORK_DIR=""
TITLE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --id) ID=$2; shift 2 ;;
    --status) STATUS=$2; shift 2 ;;
    --session) SESSION=$2; shift 2 ;;
    --model) MODEL=$2; shift 2 ;;
    --pr-url) PR_URL=$2; shift 2 ;;
    --notes) NOTES=$2; shift 2 ;;
    --work-dir) WORK_DIR=$2; shift 2 ;;
    --title) TITLE=$2; shift 2 ;;
    -h|--help)
      sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "$ID" || -z "$STATUS" ]]; then
  echo "Usage: $0 --id T12 --status RUNNING [--session S] [--model M] ..." >&2
  exit 1
fi

case "$STATUS" in
  PLANNED|DISPATCHED|RUNNING|DELIVERED|BLOCKED|FROZEN) ;;
  *)
    echo "status must be PLANNED|DISPATCHED|RUNNING|DELIVERED|BLOCKED|FROZEN" >&2
    exit 1
    ;;
esac

if [[ ! -f "$BOARD" ]]; then
  echo "Missing board: $BOARD (run new-package.sh first)" >&2
  exit 1
fi

NOW=$(date '+%Y-%m-%dT%H:%M:%S%z' | sed -E 's/([+-][0-9]{2})([0-9]{2})$/\1:\2/')

if command -v jq >/dev/null 2>&1; then
  tmp=$(mktemp)
  jq \
    --arg id "$ID" \
    --arg status "$STATUS" \
    --arg session "$SESSION" \
    --arg model "$MODEL" \
    --arg pr_url "$PR_URL" \
    --arg notes "$NOTES" \
    --arg work_dir "$WORK_DIR" \
    --arg title "$TITLE" \
    --arg updated_at "$NOW" \
    '
      (map(.id) | index($id)) as $i
      | if $i == null then
          error("no row with id=\($id)")
        else
          .[$i].status = $status
          | .[$i].updated_at = $updated_at
          | if $session != "" then .[$i].zcode_session = $session else . end
          | if $model != "" then .[$i].model = $model else . end
          | if $pr_url != "" then .[$i].pr_url = $pr_url else . end
          | if $notes != "" then .[$i].notes = $notes else . end
          | if $work_dir != "" then .[$i].work_dir = $work_dir else . end
          | if $title != "" then .[$i].title = $title else . end
        end
    ' "$BOARD" > "$tmp" && mv "$tmp" "$BOARD"
else
  python3 - "$BOARD" "$ID" "$STATUS" "$SESSION" "$MODEL" "$PR_URL" "$NOTES" "$WORK_DIR" "$TITLE" "$NOW" <<'PY'
import json, sys
path, id_, status, session, model, pr_url, notes, work_dir, title, now = sys.argv[1:]
with open(path) as f:
    rows = json.load(f)
for r in rows:
    if r.get("id") == id_:
        r["status"] = status
        r["updated_at"] = now
        if session:
            r["zcode_session"] = session
        if model:
            r["model"] = model
        if pr_url:
            r["pr_url"] = pr_url
        if notes:
            r["notes"] = notes
        if work_dir:
            r["work_dir"] = work_dir
        if title:
            r["title"] = title
        break
else:
    raise SystemExit(f"no row with id={id_}")
with open(path, "w") as f:
    json.dump(rows, f, indent=2)
    f.write("\n")
PY
fi

echo "updated $ID → $STATUS ($NOW)"
