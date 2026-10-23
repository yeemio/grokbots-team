# MATCHERS — treat as handoff → wake Control

Case-sensitive where shown. Match against PR **comment body** and PR **body** (including edits). Strip leading/trailing whitespace before compare; ignore pure markdown quote prefixes (`> `) on the matched line.

## Primary (wake immediately)

| Pattern | Notes |
| --- | --- |
| `Handoff → Yeemio \| Control` | Canonical. Pipe may be written as `\|` or `\|` in markdown; normalize `|`. |
| `Handoff → Yeemio | Control` | Same with plain `|`. |
| `ASSIGNED` on its own line, or as `[ASSIGNED]`, when the same comment also names `Yeemio \| Control` / `Yeemio | Control` / `@yeemio` Control role | Alone without Control naming → **no wake**. |
| `交接 → Yeemio \| Control` / `交接 → Yeemio | Control` | Chinese equivalent of the canonical handoff line. |
| `派给 Yeemio \| Control` / `派给 Yeemio | Control` | Explicit assign phrasing. |

## Secondary (wake if co-located with Control naming)

Within the same comment (or same PR-body section within ~20 lines):

- `下一包` / `派下一包` / `接收并组织`
- `唯一工程 writer` / `FDE·工程` / `Yeemio | FDE`
- `HANDOFF.md` path mention **and** `Yeemio | Control` in the same comment

Secondary alone (no Control naming) → **no wake**.

## Explicit non-matches (stay silent)

- CI bot summaries, Dependabot, codecov, `github-actions` status blobs
- Codex `ACCEPT` / `REWORK` / `BLOCKED` **without** a Control handoff line
- Review comments that only discuss code (`nit:`, `LGTM`, line notes)
- Mentions of `yeemio` that are not Control handoff (e.g. X handle in a changelog)
- Comments authored by Control itself that only ACK a prior handoff (avoid wake loops)

## Normalization helpers

```text
normalize(line):
  trim
  replace "\\|" with "|"
  collapse internal runs of whitespace to single space
  optional: strip one leading "> " (blockquote)
```

Match if `normalize(line)` equals or **contains** a primary pattern as a contiguous substring, or satisfies a secondary+Control co-location rule above.
