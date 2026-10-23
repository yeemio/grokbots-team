# first-hour-spike

Mid-day alert when a **@yeemio original** post’s ~15-minute impressions are clearly above that day’s running median — so Owner can follow while the thread is still hot.

**End-of-day summary stays separate.** This tool only covers the interrupt path.

## Intent

- Watch originals authored by `@yeemio` (not replies-only, not reposts-as-primary).
- Around **T+15 minutes** after publish, compare impressions to the **running median** of that calendar day’s prior originals’ 15m impressions.
- If clearly elevated (see [RULES.md](./RULES.md)), ping Owner once per status id.
- Otherwise stay silent.

## Related

- Paste-ready routine intent: [NOTE_FOR_ROUTINE.md](./NOTE_FOR_ROUTINE.md) for updating「原创首小时跟踪」.
- Thresholds / quiet hours / dedupe: [RULES.md](./RULES.md).

## What it does not do

- Does not auto-reply, quote-tweet, or like.
- Does not replace the end-of-day first-hour rollup.
- Does not alert on replies, quote-posts as primary object, or third-party mentions.
