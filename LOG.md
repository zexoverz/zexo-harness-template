# Log

Rolling log for the project using this template. Not a diary — a handoff record.

Format: `YYYY-MM-DD <author> — <what shipped, what's next>`

---

## How to use this file

- Append at the top of the "Project entries" section
- 1 line per session; extra context goes in commit messages / PRs / ADRs
- No branding, no emoji, no marketing tone — this is for the next person picking up mid-project
- If a session shipped nothing (spike, research, blocked), still log it — negative results save the next person time

---

## Project entries

<!-- Add your project's log entries here.
     Example:
     2026-07-21 zexoverz — initial scaffold shipped, backend contract locked, plan.md drafted
-->

## zexo-harness-template releases

2026-07-21 zexoverz — v0.4.0 shipped. Flipped ECC plugin (`ecc@ecc` from affaan-m/ECC marketplace) from optional → **REQUIRED**. Declared in `.claude/settings.json` under `enabledPlugins` (Claude Code flags missing on startup). `setup.sh` prints mandatory install banner. CLAUDE.md + AGENTS.md led with REQUIRED plugin section. New `docs/ONBOARDING.md` Step 4 walks through `/plugin marketplace add affaan-m/ECC && /plugin install ecc@ecc`. Now three-layer integration: vendored 15 rule files for always-on `@`-imports, plugin for 67 subagents + 278 skills + 94 commands, plugin.json for versioned declaration.

2026-07-21 zexoverz — v0.3.0 shipped (HOTFIX). Replaced v0.2.0 ECC submodule with vendored 15-file subset. Root cause: ECC v2 is a full multi-tool distribution (~2200 files across 8 IDE bundles + i18n docs); Claude Code auto-scans `.claude/**/*.md` as memory files and hit 5.8M tokens (582% of 1M limit). Fix: vendor only `rules/common/*.md` + `rules/typescript/*.md` (~30 KB), pin SHA in VERSION.md, provide `update.sh` for refreshes. Full ECC plugin install still documented as optional at this version.

2026-07-21 zexoverz — v0.2.0 shipped. ECC as git submodule (later replaced in v0.3.0 due to context blow-up).

2026-07-21 zexoverz — v0.1.0 shipped. Initial scaffold: 6 subagents, 9 slash commands, 4 MCP servers, RTK + hooks + notification pipeline, plugin format, cross-tool AGENTS.md.
