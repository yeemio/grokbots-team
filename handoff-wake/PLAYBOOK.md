# PLAYBOOK — Control checklist after wake

Run this in order. Prefer short, concrete comments over essays.

## 1. Read the PR

- Open the linked PR and the triggering comment.
- Skim latest HANDOFF / DELIVERY-POINTER / package docs if paths are named.
- Note: goal, scope paths, done-when, writer constraints (no CloudAgent, no Formal, freeze rules).
- If the handoff is incomplete or contradictory → ping Owner once; do **not** invent scope.

## 2. ACK on the PR

Post a short PR comment. Shape:

```markdown
ACK — Yeemio | Control received.

- Trigger: <comment URL or “PR body edit”>
- Package: <short name / date slug if present>
- Next: dispatch FDE·工程 (or: waiting Owner clarification on <one line>)
```

Do not promise ACCEPT. Do not restate the entire HANDOFF.

## 3. FDE·工程 message shape

Send Control → FDE·工程 (shared box / agreed channel). Shape:

```text
【派工】OwlCodaE PR #<n> — <package slug>

Goal: <one sentence from HANDOFF>
Scope: <paths or “see HANDOFF §…”>
Done-when: <one sentence>
Constraints: no CloudAgent; no Formal/merge/main; freeze product bytes outside package dirs; write DELIVERED / BLOCKED as named in HANDOFF.
Evidence: <output/… and delivery/ expectations if stated>
Source pointer: <readonly worktree / HEAD if given>

Reply ACK with session id when you start; stop after one delivery or one named block.
```

Attach or link the HANDOFF path; do not paste secrets.

## 4. Owner ping

One short ping if any of:

- Handoff arrived after quiet hours and deadline is “current / P1”
- Matcher was secondary-only and you want confirmation
- FDE is blocked on an Owner-only decision (credentials, Formal, scope expand)

Shape:

```text
OwlCodaE PR #<n> handoff woke Control.
ACK’d on-thread; FDE dispatched / waiting you on: <one line>.
```

Otherwise stay silent toward Owner — the PR ACK is enough.

## 5. After FDE returns

- Verify DELIVERED / BLOCKED artifact paths are PR-readable.
- Do not merge. Hand technical acceptance to Codex per package rules.
- Update any Control tracking note with PR #, package slug, and outcome one-liner.
