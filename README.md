# yeemio-ops

Public ops toolkit for [@yeemio](https://x.com/yeemio) / Yeemio | Control.

Small, real friction fixes from day-to-day work — not a product platform.

## Tools

| Dir | What it solves |
| --- | --- |
| [handoff-wake/](./handoff-wake/) | Auto-wake Control when OwlCodaE PRs carry `Handoff → Yeemio \| Control` (stop missing assigned work; see also [MATCHERS](./handoff-wake/MATCHERS.md), [PLAYBOOK](./handoff-wake/PLAYBOOK.md)) |
| [fde-crumbs/](./fde-crumbs/) | Desensitized FDE build/scenario crumbs → X·内容 draft queue (never auto-publish; [schema](./fde-crumbs/CRUMB_SCHEMA.md), [example](./fde-crumbs/EXAMPLE_CRUMB.md)) |
| [first-hour-spike/](./first-hour-spike/) | Mid-day ping when a @yeemio original opens much faster than that day's median at ~15m ([rules](./first-hour-spike/RULES.md), [routine note](./first-hour-spike/NOTE_FOR_ROUTINE.md)) |
| [ui-evidence-scaffold/](./ui-evidence-scaffold/) | Hash check + restore checklist + DELIVERED comment skeleton for “full candidate + normal DSH entry” packages (e.g. PR #61) |

## Quick links

- `ui-evidence-scaffold/scripts/check-accepted-hashes.mjs` — verify `{relPath: sha256}` under a restore root
- `ui-evidence-scaffold/scripts/scaffold-delivery-dirs.sh` — create `delivery/`, `output/<slug>/`, evidence dirs
- `ui-evidence-scaffold/templates/` — `ACCEPTED_HASHES.example.json`, `DELIVERED_COMMENT.md`, `RESTORE.md`

## Rules of the road

- X: research / drafts only. Humans publish.
- OwlCodaE: FDE writes with ZCode on Control’s shared box; Control assigns & tracks; Codex merges. No CloudAgent for OwlCodaE.
- Prefer silent over filler.

## License

[MIT](./LICENSE)
