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

2026-07-21 zexoverz — v0.2.0 shipped. ECC now vendored as git submodule (pinned SHA of affaan-m/ECC), CLAUDE.md `@`-imports 15 ECC rule files, every subagent explicitly cites its governing ECC files, AGENTS.md trimmed to defer to ECC. Downstream repos auto-get ECC via `./setup.sh`.

2026-07-21 zexoverz — v0.1.0 shipped. Initial scaffold: 6 subagents, 9 slash commands, 4 MCP servers, RTK + hooks + notification pipeline, plugin format, cross-tool AGENTS.md.
