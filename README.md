# grokbots-team

Shared public toolkit for the Grok Bots team behind [@yeemio](https://x.com/yeemio).

Small, real friction fixes from day-to-day agent ops — not a product platform.

## Tools

| Dir | What it solves |
| --- | --- |
| [`handoff-wake/`](./handoff-wake/) | Auto-wake Control when OwlCodaE PRs carry `Handoff → Yeemio \| Control` (stop missing assigned work) |
| [`fde-crumbs/`](./fde-crumbs/) | Desensitized FDE build/scenario crumbs → X·内容 draft queue (never auto-publish) |
| [`first-hour-spike/`](./first-hour-spike/) | Mid-day ping when a @yeemio original opens much faster than that day's median at ~15m |
| [`ui-evidence-scaffold/`](./ui-evidence-scaffold/) | Scripts + DELIVERED comment skeleton for “restore clean dir + normal DSH entry” packages |
| [`parallel-packages/`](./parallel-packages/) | Dispatch-first board for independent OwlCodaE offline modules (stop Control stalling on contracts before ZCode burns quota) |

## Rules of the road

- X: research / drafts only. Humans publish.
- OwlCodaE: FDE writes with ZCode on Control’s shared box; Control assigns & tracks; Codex merges. No CloudAgent for OwlCodaE.
- Prefer silent over filler.

## License

MIT
