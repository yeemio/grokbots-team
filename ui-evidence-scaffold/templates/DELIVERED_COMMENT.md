# UI_INTEGRATION_DELIVERED_YYYYMMDD

> Skeleton for PR comment / `output/<slug>/UI_INTEGRATION_DELIVERED_*.md`.
> Replace placeholders. Delete unused rows. Do not claim NOT_RUN items as passed.

- Writer：Yeemio | FDE·工程 / \<model\> / ZCode（session `\<session_id\>`；account `\<account_label\>`）。无 CloudAgent、无另开付费 API、未动 Formal/merge/main/vendor 产品字节/lock/install/release。
- 来源完整 HEAD：`\<full_sha\>`（分支 `\<branch\>`，只读 `\<readonly_root\>`）。
- 来源 dirty（**未**打入产品包）：`\<list or “none”\>`。
- 任务目录：`\<task_root\>`；还原候选：`\<restored_candidate_root\>`。

## 交付物与清单 SHA-256

| 项 | 路径 | SHA-256 |
| --- | --- | --- |
| 源码归档 | `delivery/archives/\<source-archive\>.tar.gz` | `\<sha256\>` |
| DSH vendor 归档 | `delivery/archives/\<vendor-archive\>.tar.gz` | `\<sha256\>` |
| SOURCE-FILES 清单 | `delivery/manifests/SOURCE-FILES.sha256` | `\<sha256\>` |
| VENDOR-FILES 清单 | `delivery/manifests/VENDOR-FILES.sha256` | `\<sha256\>` |
| 还原说明 | `delivery/RESTORE.md` | （见文件） |
| 联验脚本 | `scripts/\<joint-verify\>.mjs` | （随 PR 提交） |
| 联验结果（脱敏） | `output/\<slug\>/…/JOINT-VERIFY-RESULT.json` | （见文件；`allPassed=\<bool\>`，`providerHits=\<n\>`） |

排除：`.git` / `.owlcoda/runkit` / 凭据 / 真实工作根 / 上列 dirty。box 路径 alone 不算交付；归档 + 清单 + SHA-256 已交回 PR 可读取路径。

## 还原与构建（fresh | reused）

1. `tar -xzf` 源码归档 → 新目录；`tar -xzf` vendor → `$NEW/vendor/dsh/`。
2. `npm ci` → `\<build commands\>`（记录 native / make 需求）。
3. 还原后身份（逐字节）——对照 `ACCEPTED_HASHES` / `check-accepted-hashes.mjs`：
   - client `packages/integration-dsh/client/index.js` = `\<sha256\>`
   - launcher `packages/integration-dsh/src/product-launcher.ts` = `\<sha256\>`
   - 其余已接受 UI SHA 与表一致 / 列出例外。
4. DSH pin：`\<version\>`。

## 一次正常入口联验（fresh | reused | NOT_RUN）

命令：`node scripts/\<joint-verify\>.mjs`（cwd=还原候选根）。正常 CLI：`scripts/owlcoda-product-v0.1.mjs start|stop`；隔离 SIM 根 + 合法种子；mock/loopback 策略：`\<describe\>`。

| 面 | 结果 | 证据 |
| --- | --- | --- |
| My Work … | OK / FAIL / NOT_RUN | shots / JSON |
| CO01 云栈 … | OK / FAIL / NOT_RUN | … |
| … | … | … |
| stop + reopen | … | … |
| digests 联验前后不变；providerHits | … | … |

## fresh / reused / NOT_RUN

| 项 | 状态 |
| --- | --- |
| 源码+vendor 归档与清单 | **fresh** / reused |
| 干净目录还原 + npm ci + 构建 | **fresh** / reused |
| 正常 launcher 联验 | **fresh** / reused / **NOT_RUN** |
| 既有包行为探针/契约全套 | **reused** / fresh / **NOT_RUN** |
| macOS 应用安装 / 企业业务验收 / Formal | **NOT_RUN**（范围外） |

## 保护读回

- 只读来源树；未改产品业务核心 / application / store / 权限 / schema / Host / provider / 启动生命周期 / deps / locks / vendor 产品树 / 品牌（除非工作单明确允许）。
- 未覆盖无关证据目录、Mac 主工程、真实工作根。
- 未 merge、未 push main、未 force、未 install/release、未 CloudAgent、未付费 API（若有例外，具名写出）。
- PR 推送仅本包允许的脚本/清单/归档/证据/文档（不含凭据）。

## 未决项

- \<条件项 / 范围外 / 等 Codex `ACCEPT / REWORK / BLOCKED`\>

写完停止修改产品候选。
