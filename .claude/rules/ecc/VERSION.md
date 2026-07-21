# ECC — vendored subset

**Upstream:** [affaan-m/ECC](https://github.com/affaan-m/ECC)
**Pinned SHA:** `5deee34c93395045b985e3baf91550e5f1ab7204`
**Fetched at:** 2026-07-21
**License:** MIT (upstream)

## What lives here

15 rule files selectively vendored from ECC:

- **`rules/common/`** — 10 shared rules (agents, code-review, coding-style, development-workflow, git-workflow, hooks, patterns, performance, security, testing)
- **`rules/typescript/`** — 5 TypeScript overrides (coding-style, hooks, patterns, security, testing)

## Why vendored (not submodule / plugin)

ECC v2.0 ships as a full multi-tool distribution — 67 agents, 278 skills, 94 legacy commands, i18n docs, bundles for Codex/Cursor/Gemini/Hermes/Kiro/Codebuddy. Cloning the whole thing (submodule or plugin install) puts ~2200 files under `.claude/`, which Claude Code auto-scans as memory files → context blows up ~5.8M tokens (582% of the 1M limit).

Vendoring only the rule files we cite from `CLAUDE.md` and subagent definitions keeps the harness lightweight (~30 KB total) while preserving `@`-imports and version traceability.

## Want the full ECC plugin?

If you want ECC's 278 skills + 94 commands available via slash commands:

```bash
# One-time, in any Claude Code session
/plugin marketplace add affaan-m/ECC
/plugin install ecc@ecc
```

This installs ECC globally at the user level — doesn't touch this repo. The vendored rules stay authoritative for **rule application**; the plugin adds **skills + commands** on top.

## Updating vendored rules

```bash
# From the repo root
./.claude/rules/ecc/update.sh
```

That script fetches the latest common+typescript rules from upstream and bumps the SHA in this file. Review the diff, commit if the changes make sense.

**Do not `git submodule` this back into place.** Vendored is the correct pattern given ECC's packaging.
