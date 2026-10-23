# RULES — first-hour spike thresholds

Timezone for “day” and quiet hours: **Asia/Shanghai (UTC+8)**.

## Eligibility

| Rule | Detail |
| --- | --- |
| Author | Status is an **original** by `@yeemio` (not a pure reply; quote-tweet counts only if treated as original in the existing routine — default: **originals only, no QT**). |
| Sample time | Impressions snapshot nearest **T+15m** (±2m tolerance). If no sample by T+20m, skip spike path (EOD summary may still cover it). |
| Day bucket | Calendar date of publish in Asia/Shanghai. |

## Spike threshold (all must hold)

Let `imp_15` = impressions at the ~15m sample.  
Let `median_day` = median of `imp_15` for **earlier originals the same day** that already have a 15m sample.

Wake Owner when:

1. `imp_15 >= 2 × median_day`, **and**
2. `imp_15 >= 50` (absolute floor), **and**
3. At least **3** prior same-day originals with 15m samples exist to form `median_day`.

### Cold start (fewer than 3 priors)

- Do **not** use a synthetic median.
- Stay silent on the spike channel.
- EOD summary still lists the post.

### Optional soft note (not a spike ping)

If priors < 3 but `imp_15 >= 200`, Control may fold a one-liner into an existing Owner digest — **not** a dedicated spike interrupt.

## Dedupe

- **One ping per status id** forever for the spike path.
- Re-samples at T+30 / T+60 do not re-fire even if ratio grows.
- Edits to the post text do not reset the status id.

## Quiet hours

| Window (Asia/Shanghai) | Behavior |
| --- | --- |
| 00:00–08:29 | **No spike ping.** Queue for 08:30 digest bullet if still noteworthy (`imp_15` still ≥ threshold vs final morning median), else drop. |
| 08:30–22:59 | Spike pings allowed. |
| 23:00–23:59 | No spike ping; leave to EOD summary. |

## When to stay silent

- Replies, reposts, or someone else’s post.
- Threshold not met.
- Cold start (<3 priors) except optional soft note path above.
- Quiet hours (per table).
- Status already spike-pinged.
- Metrics API failure / missing impressions — **no guess**; skip.
- Owner muted the spike routine.

## Ping shape (when firing)

```text
【首小时尖峰】@yeemio status <id>
~15m impressions: <imp_15> (≥2× day median <median_day>, floor 50)
link: <url>
```

No draft replies. No “should we engage?” essay unless Owner asks.
