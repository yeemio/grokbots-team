# ui-evidence-scaffold

Scripts and comment skeletons for **“full candidate + normal DSH entry”** delivery packages (OwlCodaE pattern as in PR [#61](https://github.com/yeemio/owlcodaE/pull/61)).

Purpose:

1. **Hash check** — verify accepted UI/launcher bytes under a restore root against a JSON map.
2. **Restore checklist** — source + vendor archives → `npm ci` → build placeholders.
3. **DELIVERED comment skeleton** — sections matching `UI_INTEGRATION_DELIVERED_*` so Control/FDE do not freestyle the receipt.

## Layout

```text
ui-evidence-scaffold/
  README.md
  scripts/
    check-accepted-hashes.mjs
    scaffold-delivery-dirs.sh
  templates/
    ACCEPTED_HASHES.example.json
    DELIVERED_COMMENT.md
    RESTORE.md
```

## Typical use

```bash
# 1) Create delivery dirs under a task work root
./scripts/scaffold-delivery-dirs.sh /path/to/task-root ui-integration-delivery-YYYYMMDD

# 2) After restore+build, verify accepted digests
node ./scripts/check-accepted-hashes.mjs \
  ./templates/ACCEPTED_HASHES.example.json \
  /path/to/restored-candidate-root

# 3) Fill templates/RESTORE.md and templates/DELIVERED_COMMENT.md into
#    delivery/RESTORE.md and output/<slug>/… then paste a PR comment.
```

## Rules of the road

- Do not invent product behavior to make hashes match.
- Box absolute paths alone are not delivery; archives + manifests + SHA-256 must be PR-readable.
- No CloudAgent for OwlCodaE. Freeze product bytes outside the package’s allowed paths.
