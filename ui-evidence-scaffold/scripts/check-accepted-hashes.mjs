#!/usr/bin/env node
/**
 * check-accepted-hashes.mjs
 *
 * Usage:
 *   node check-accepted-hashes.mjs <hashes.json> <rootDir>
 *
 * hashes.json: { "rel/path": "<sha256 hex>", ... }
 * Verifies each file under rootDir. Prints a table. Exit 1 on any miss/mismatch.
 */

import { createHash } from "node:crypto";
import { readFile, access } from "node:fs/promises";
import { join, normalize } from "node:path";
import { constants } from "node:fs";

function usage(code = 1) {
  console.error("Usage: node check-accepted-hashes.mjs <hashes.json> <rootDir>");
  process.exit(code);
}

function sha256Hex(buf) {
  return createHash("sha256").update(buf).digest("hex");
}

function pad(s, n) {
  s = String(s);
  return s.length >= n ? s : s + " ".repeat(n - s.length);
}

async function main() {
  const [, , mapPath, rootDir] = process.argv;
  if (!mapPath || !rootDir) usage(1);

  let map;
  try {
    map = JSON.parse(await readFile(mapPath, "utf8"));
  } catch (err) {
    console.error(`Failed to read JSON map: ${mapPath}\n${err.message}`);
    process.exit(2);
  }

  if (!map || typeof map !== "object" || Array.isArray(map)) {
    console.error("hashes.json must be a JSON object of { relPath: sha256 }");
    process.exit(2);
  }

  const entries = Object.entries(map);
  if (entries.length === 0) {
    console.error("hashes.json has no entries");
    process.exit(2);
  }

  const rows = [];
  let failures = 0;

  for (const [relRaw, expectedRaw] of entries) {
    const rel = normalize(String(relRaw).replace(/^\.\/+/, ""));
    const expected = String(expectedRaw).trim().toLowerCase();
    const abs = join(rootDir, rel);

    if (rel.startsWith("..")) {
      rows.push({ rel, expected, actual: "", status: "INVALID_PATH" });
      failures++;
      continue;
    }

    try {
      await access(abs, constants.R_OK);
    } catch {
      rows.push({ rel, expected, actual: "", status: "MISSING" });
      failures++;
      continue;
    }

    const buf = await readFile(abs);
    const actual = sha256Hex(buf);
    if (!/^[0-9a-f]{64}$/.test(expected)) {
      rows.push({ rel, expected, actual, status: "BAD_EXPECTED" });
      failures++;
    } else if (actual !== expected) {
      rows.push({ rel, expected, actual, status: "MISMATCH" });
      failures++;
    } else {
      rows.push({ rel, expected, actual, status: "OK" });
    }
  }

  const relW = Math.min(
    72,
    Math.max(8, ...rows.map((r) => r.rel.length)),
  );
  const hashW = 64;

  console.log(
    pad("STATUS", 12) +
      pad("REL_PATH", relW + 2) +
      pad("EXPECTED", hashW + 2) +
      "ACTUAL",
  );
  console.log("-".repeat(12 + relW + 2 + hashW + 2 + hashW));

  for (const r of rows) {
    console.log(
      pad(r.status, 12) +
        pad(r.rel, relW + 2) +
        pad(r.expected || "-", hashW + 2) +
        (r.actual || "-"),
    );
  }

  const ok = rows.filter((r) => r.status === "OK").length;
  console.log("");
  console.log(`Checked ${rows.length} path(s): ${ok} OK, ${failures} failed.`);
  console.log(`Root: ${rootDir}`);
  console.log(`Map:  ${mapPath}`);

  process.exit(failures === 0 ? 0 : 1);
}

main().catch((err) => {
  console.error(err);
  process.exit(2);
});
