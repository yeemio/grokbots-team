# parallel-packages

Dispatch-first toolkit for **independent offline OwlCodaE modules** that Control must track in parallel — without burning ZCode quota on contract research after Owner says 开工.

## What it solves

1. **Dispatch-first** — when Owner says go, Control writes a HANDOFF and SendToAgent FDE immediately. Reading contracts before dispatch stalled Control and burned quota (e.g. ZCode session time while Control was still researching).
2. **Parallel board** — several independent packages (separate work dirs, no shared UI/launcher/client/pin/`index.ts`) run at once; one JSON board + compact markdown report keeps status honest.

## Layout

```text
parallel-packages/
  README.md
  templates/
    HANDOFF.md          # filled-style stub; sed placeholders in new-package.sh
    STATUS.row.json     # one package row schema
  scripts/
    new-package.sh      # mkdir + HANDOFF + upsert board row → DISPATCH NOW
    set-status.sh       # update status / session / model on a row
    board-report.sh     # compact markdown table from board/status.json
  board/
    status.json         # living board (seeded)
    STATUS.md           # optional; written by board-report.sh --write
```

## How Control uses it

```bash
PKG=/workspace/grokbots-team/parallel-packages

# 1) Owner said 开工 → do NOT research contracts further. Dispatch.
"$PKG/scripts/new-package.sh" \
  --id T12 --case TC13 \
  --title "refund dual" \
  --work-dir /workspace/OwlcodaE-tc13-refund-20261023

# 2) SendToAgent FDE with the printed HANDOFF path (model GLM-5.3, no flash).

# 3) As FDE reports, flip status:
"$PKG/scripts/set-status.sh" --id T12 --status RUNNING \
  --session session_xxx --model "GLM-5.3"

# 4) Glance the board anytime:
"$PKG/scripts/board-report.sh"
"$PKG/scripts/board-report.sh" --write   # also refresh board/STATUS.md
```

## Status enum

`PLANNED` → `DISPATCHED` → `RUNNING` → `DELIVERED` (or `BLOCKED` / `FROZEN`).

`FROZEN` = delivered (or abandoned) and product bytes outside package boundaries must not be touched.

## Boundaries (remind FDE via HANDOFF)

- No shared UI / launcher / client / pin / `index.ts`
- No CloudAgent / Formal / merge
- Parallel dirs only — one package, one work_dir
- Model: **GLM-5.3** (no flash)

## Rules of the road

- Prefer bash + `jq` (fallback: python3).
- This package only writes under `parallel-packages/` in-repo; `new-package.sh` may mkdir work/control stubs under `/workspace/` when Control runs it.
- No CloudAgent for OwlCodaE. Codex merges.
