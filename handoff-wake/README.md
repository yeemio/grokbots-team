# handoff-wake

Grok Bot GitHub listener routine for [`yeemio/owlcodaE`](https://github.com/yeemio/owlcodaE).

Wakes **Yeemio | Control** when a PR comment (or PR body edit) carries an explicit handoff toward Control — so assigned work is not left sitting unread.

## Why this exists

PR [#60](https://github.com/yeemio/owlcodaE/pull/60) Round 3 (`Handoff → Yeemio | Control` / ASSIGNED) landed while Control was not actively watching the thread. The handoff sat until a human noticed. That miss delayed ACK, FDE dispatch, and Owner visibility.

This routine closes that gap with a narrow, match-driven wake — not a general “every PR comment” notifier.

## What it does

On a matching comment or body change in `yeemio/owlcodaE`:

1. **Wake Control** with PR number, comment URL, and the matched handoff line.
2. **ACK on the PR** (Control posts a short acknowledgment — see [PLAYBOOK.md](./PLAYBOOK.md)).
3. **Dispatch FDE·工程** with a bounded work message (Control → FDE), when the handoff is an engineering package.

Exact match strings live in [MATCHERS.md](./MATCHERS.md). Post-wake checklist: [PLAYBOOK.md](./PLAYBOOK.md).

## What it does not do

- Does **not** merge, push, force-push, or open CloudAgents for OwlCodaE.
- Does **not** rewrite product trees or invent scope beyond the handoff text.
- Does **not** auto-ACCEPT / REWORK / BLOCKED — that stays with Codex / Owner.
- Does **not** wake on every `@` mention, review emoji, or CI status; only documented matchers.
- Does **not** replace end-of-day or Owner digests — this is an interrupt for assigned handoffs only.

## Operator notes

- Prefer silent when the matcher is ambiguous; ping Owner once if the comment looks like a handoff but fails exact match.
- Dedupe: one wake per `(pr_number, comment_id)` (or body revision hash). Re-edits that still match may re-wake only if the handoff line itself changed.
