# HANDOFF — {{TASK_ID}} / {{CASE_ID}}

| Field | Value |
| --- | --- |
| **TASK_ID** | {{TASK_ID}} |
| **CASE_ID** | {{CASE_ID}} |
| **GOAL** | {{GOAL}} |
| **WORK_DIR** | {{WORK_DIR}} |
| **MODEL** | {{MODEL}} |
| **CONTRACT** | {{CONTRACT_PATH}} (sha: {{CONTRACT_SHA}}) |
| **DELIVER_TAG** | {{DELIVER_TAG}} |

## Goal

{{GOAL}}

## Work dir

`{{WORK_DIR}}`

Stay inside this tree. Do not touch sibling OwlCodaE package dirs.

## Model

**{{MODEL}}** — no flash. Prefer GLM-5.3.

## Contract

- Path: `{{CONTRACT_PATH}}`
- SHA: `{{CONTRACT_SHA}}`

Read the contract **after** dispatch inside the FDE session; Control does not pre-research it.

## Deliver tag

`{{DELIVER_TAG}}`

## Boundaries

{{BOUNDARIES}}

Default boundaries (apply even if above is empty):

- No shared UI / launcher / client / pin / `index.ts`
- No CloudAgent / Formal / merge
- Parallel dirs only — one package ↔ one `WORK_DIR`
- Do not edit product trees outside this package’s allowed paths

## Done when

1. Work lands under `WORK_DIR` with evidence Control can paste.
2. Status row updated (`DELIVERED` or `BLOCKED` with notes).
3. PR opened (if in scope) and `pr_url` set on the board row.
