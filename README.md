# foru-harness-template

**A Claude Code + ECC + RTK development harness for Foru-Engineering sprints.**

This repo is a **template**. Clone it (or "Use this template" on GitHub) at the start of every new sprint. Everything Claude Code needs to be productive from minute one is pre-wired here — subagents, slash commands, MCP servers, hooks, memory scaffolding, code-review rules, git conventions, and CI.

Team members do **not** need to configure any of this themselves. Just clone, run `./setup.sh`, and go.

---

## Why this exists

Every FORU sprint eats hours on the same setup dance: writing a CLAUDE.md, picking subagents, wiring hooks, remembering which MCP servers to enable, arguing about lint config, forgetting to install RTK. That setup dance eats sprint velocity — especially when the sprint is short (Coinfest demo: 3 weeks, deadline **7 Aug 2026**).

This template collapses the setup dance into `./setup.sh`. Every sprint starts from the same battle-tested baseline. Improvements to the baseline flow back here so the next sprint starts even faster.

## What you get on day one

| Layer                | What                                                                                         |
| -------------------- | -------------------------------------------------------------------------------------------- |
| **ECC**              | Full Everything-Claude-Code rules from `~/.claude/rules/ecc/` — coding style, testing, security, git, patterns, code review, agents |
| **RTK**              | Rust Token Killer pre-wired as PreToolUse Bash hook (60–90% token savings on dev commands)   |
| **5 subagents**      | `planner`, `code-reviewer`, `tdd-guide`, `security-reviewer`, `build-error-resolver`         |
| **5 slash commands** | `/ship`, `/work-on`, `/review`, `/deploy`, `/adr`                                            |
| **MCP servers**      | Context7 (fresh docs), GitHub, Playwright, Railway — auto-loaded via `.mcp.json`             |
| **Hooks**            | PostToolUse lint/fmt on edit, Stop-hook full verify at session end                           |
| **AGENTS.md**        | Cross-tool rules (Cursor / Cline / Windsurf compat) — bring your own IDE                     |
| **Memory scaffold**  | Pre-seeded FORU-org context so subagents know who they are                                   |
| **CI**               | GitHub Actions runs `bun run verify` on every PR                                             |
| **ADR template**     | For logging decisions like "Hermes vs OpenClaw"                                              |

## Quickstart

```bash
# 1. Use as GitHub template OR clone
gh repo create Foru-Engineering/my-sprint --template Foru-Engineering/foru-harness-template --private
cd my-sprint

# 2. Bootstrap
./setup.sh

# 3. Open Claude Code
claude

# 4. Start work
> /work-on "add fake-catalog seeds for savings wedge"
```

`setup.sh` verifies:

- RTK installed (`rtk --version`) — installs from https://github.com/rtk-ai/rtk if missing
- `gh` authenticated + Foru-Engineering org membership
- Bun installed (or Node LTS if Bun not preferred)
- ECC rules linked (from `~/.claude/rules/ecc/`)
- `.env` created from `.env.example`

## Sprint context

If you're picking this up for **Coinfest Asia 2026 demo** ("Project Zero" MVP), read [`docs/SPRINT-COINFEST-2026.md`](./docs/SPRINT-COINFEST-2026.md) first — it has the demo spec, the wedge structure, the fake-catalog convention, and the Hermes-vs-OpenClaw ADR.

## Onboarding

Fresh team member? [`docs/ONBOARDING.md`](./docs/ONBOARDING.md) walks through:

- What Claude Code + ECC + RTK actually give you
- How to use the 5 subagents effectively
- When to use each slash command
- How to add a new subagent / skill / hook
- The FORU git-commit convention

## Recipes

Common Claude Code moves — copy-paste prompts, when to use them, what to expect:
[`docs/AGENT-RECIPES.md`](./docs/AGENT-RECIPES.md)

## Sprint log

Every sprint appends to [`LOG.md`](./LOG.md) — one line per session: what shipped, what's next. Not a diary, a rolling changelog for handoffs.

---

## For tech leads (Faisal): how to fork this for a new sprint

1. **Create a repo** from this template in `Foru-Engineering/` (private by default).
2. **Edit `CLAUDE.md`** — replace the "sprint scope" section with the specific sprint's goals.
3. **Edit `docs/SPRINT-*.md`** — copy the Coinfest template as a starting shape.
4. **Optionally edit `.claude/memory/MEMORY.md`** — seed with sprint-specific facts.
5. **Invite team members** — Naufal, Toriq, Ariq (or whoever's on the sprint).
6. **Hand off.** They run `./setup.sh` and start.

## Contributing back to the template

If you learn something during a sprint that would help future sprints — a new subagent, a better skill, a hook that catches a common mistake — open a PR against `foru-harness-template` (not just your sprint repo). Improvements compound across sprints.
