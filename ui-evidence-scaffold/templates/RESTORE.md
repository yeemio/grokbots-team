# 还原说明 — \<package title\> YYYY-MM-DD

## 交付物（路径相对任务根；亦在 PR 同相对路径）

| 项 | 相对路径 | SHA-256 |
| --- | --- | --- |
| 源码归档 | `delivery/archives/\<source\>.tar.gz` | `\<sha256\>` |
| DSH vendor 归档 | `delivery/archives/\<vendor\>.tar.gz` | `\<sha256\>` |
| 源文件清单 | `delivery/manifests/SOURCE-FILES.sha256` | `\<sha256\>` |
| vendor 清单 | `delivery/manifests/VENDOR-FILES.sha256` | `\<sha256\>` |
| 来源 HEAD | `delivery/manifests/SOURCE-HEAD.txt` | （见文件） |

来源：只读 `\<readonly_root\>` HEAD `\<full_sha\>`；打包排除 `.git` / `.owlcoda/runkit` / 真实数据 / 凭据 / 无关脏文件。vendor 以独立归档交付。

## 还原步骤（Linux/box）

```bash
NEW=/path/to/\<candidate-dir\>
mkdir -p "$NEW" && tar -xzf delivery/archives/\<source\>.tar.gz -C "$NEW"
mkdir -p "$NEW/vendor/dsh"
tar -xzf delivery/archives/\<vendor\>.tar.gz -C "$NEW/vendor/dsh"
cd "$NEW"
# 若仓库 .npmrc 含 ignore-scripts=true，可能需要本机 make/g++ 编译 native 扩展
npm ci
# --- build commands (replace with package-accurate commands) ---
npm run build:dsh-my-work-client   # placeholder
npx tsc -b                         # placeholder
npm run build:native --workspace @owlcoda/business-store  # placeholder
# --- verify accepted digests ---
node /path/to/yeemio-ops/ui-evidence-scaffold/scripts/check-accepted-hashes.mjs \
  /path/to/ACCEPTED_HASHES.json \
  "$NEW"
# optional joint verify:
# node scripts/\<joint-verify\>.mjs
```

DSH pin：`\<version\>`。正常入口：`scripts/owlcoda-product-v0.1.mjs start …`（联验脚本应封装隔离 SIM 根 + 合法种子）。

本交付未宣称 macOS 应用安装或企业业务验收，除非工作单明确写入并证据齐全。
