# CRUMB_SCHEMA

Each crumb is one Markdown file (or one section) with **all** required fields present. Empty string is not “present.” Use `n/a` only when the field truly does not apply, and say why in sensitivity notes.

## Required fields

| Field | Description |
| --- | --- |
| `title` | Short working title (≤80 chars). Not the final X headline. |
| `angle` | One sentence: why this is interesting to a public technical audience. |
| `desensitized_facts` | Bullet list of facts safe to reuse. No secrets, no private paths, no real customer names beyond approved sim brands. |
| `suggested_en_line` | One English draft line (tweet-length or first hook). May be rewritten by X·内容. |
| `chinese_gloss` | Chinese gloss of the same idea (not a literal machine translation dump). |
| `source_pr_or_path` | Public PR URL and/or repo-relative path to the delivery note (e.g. `yeemio/owlcodaE#61`, `docs/task-packages/…`). |
| `sensitivity_notes` | What was stripped or must never appear; residual risk if any. |

## Optional fields

| Field | Description |
| --- | --- |
| `suggested_zh_line` | Optional Chinese hook if different from gloss. |
| `media_hint` | e.g. “wide shot of My Work list, no PII” — still requires human crop. |
| `do_not_say` | Explicit ban list for this crumb. |
| `expires` | ISO date after which the angle is stale. |

## Front-matter example

```yaml
---
title: "Clean-dir restore beat the 'works on my box' tax"
angle: "Shipping a full UI candidate as archives + SHA map so receivers do not guess from dirty trees."
source_pr_or_path: "https://github.com/yeemio/owlcodaE/pull/61"
sensitivity_notes: "No real customer data; SIM brands only; omit box absolute paths in public copy."
---
```

Body then includes `desensitized_facts`, `suggested_en_line`, `chinese_gloss` as Markdown sections matching the field names.
