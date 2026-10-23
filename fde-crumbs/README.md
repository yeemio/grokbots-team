# fde-crumbs

Desensitized FDE **build / scenario crumbs** → draft queue for **Yeemio | X·内容**.

Control (or FDE under Control gate) drops a crumb when a delivery has a teachable, public-safe angle. X·内容 turns crumbs into draft posts. **Never auto-publish.** Humans publish on X.

## Flow

```text
FDE delivery (OwlCodaE / sim / tooling)
        │
        ▼
  crumb file (this schema)
        │
        ▼
  Yeemio | X·内容 draft queue
        │
        ▼
  Control gate (sensitivity + voice)
        │
        ▼
  Owner / human publish (or discard)
```

## Rules

- **Desensitize first.** No customer legal names, no private URLs, no tokens, no internal box paths that reveal host layout beyond public sim brands.
- Public sim brands already in the workflow are OK: **CO01 云栈**, **MFG01 澄岳** (and similar documented SIM labels).
- Prefer *how we ship* over *what the customer bought*.
- One crumb = one angle. Split if you have two stories.
- Control may reject or rewrite before the draft queue; silence is fine.

## Files

| File | Role |
| --- | --- |
| [CRUMB_SCHEMA.md](./CRUMB_SCHEMA.md) | Required fields |
| [EXAMPLE_CRUMB.md](./EXAMPLE_CRUMB.md) | Fictionalized UI-integration style example |

## What this is not

- Not a changelog bot.
- Not a substitute for PR DELIVERED comments.
- Not permission to post product internals, hashes of private trees, or unpaid anecdotes about real companies.
