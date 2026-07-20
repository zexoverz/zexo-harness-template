# Onboarding — first hour with foru-harness-template

Welcome to the team. This walks you through your first hour with the harness. After this you'll know how to use Claude Code + ECC + RTK effectively.

## Prerequisites

- macOS or Linux (Windows via WSL2)
- Git + `gh` (GitHub CLI) — `brew install gh` on macOS
- Bun — installed by `setup.sh` if missing
- Rust + Cargo — needed for RTK — `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Claude Code — https://docs.claude.com/claude-code

## Step 1 — clone + bootstrap

```bash
git clone https://github.com/Foru-Engineering/<sprint-name> ~/code/<sprint-name>
cd ~/code/<sprint-name>
./setup.sh
```

`setup.sh` verifies your environment. It's idempotent — safe to run multiple times.

## Step 2 — verify RTK

RTK compresses 60-90% of Bash output before Claude sees it. Test:

```bash
rtk --version
# Expected: rtk 0.43.x
rtk gain
# Expected: shows token-savings analytics (works even before you've used it)
```

If `rtk gain` errors with "command not found," you likely have the WRONG rtk binary (`reachingforthejack/rtk` = Rust Type Kit). Uninstall it and reinstall from https://github.com/rtk-ai/rtk.

## Step 3 — verify ECC

ECC (Everything Claude Code) is a set of global rules loaded on every Claude Code session. It lives at `~/.claude/rules/ecc/`. Check:

```bash
ls ~/.claude/rules/ecc/common/
# Expected: agents.md coding-style.md code-review.md ... testing.md
```

If missing, ask Faisal for the ECC bundle.

## Step 4 — open Claude Code

```bash
claude
```

Try:

```
> what's on the sprint plan?
```

Claude reads `CLAUDE.md` + `docs/SPRINT-*.md` automatically. It should tell you the sprint goals + deadline.

## Step 5 — use a slash command

Try `/adr agent-runtime-choice` — this scaffolds a new ADR. Confirm the file appears in `docs/ADR/`.

## Step 6 — use a subagent

Try a work-on command. Give a small task like "add a hello-world Elysia endpoint":

```
> /work-on "add a hello-world endpoint at /hello returning JSON { message: 'halo' }"
```

Claude will:
1. Call the `planner` subagent → produces a plan
2. Show you the plan → wait for approval
3. Call `tdd-guide` → writes test first, implementation second
4. Call `code-reviewer` + `security-reviewer` in parallel → reports findings
5. If clean, tells you to run `/ship`

Try `/ship` — verifies, commits, pushes, opens a PR.

## Step 7 — install/verify MCP servers

`.mcp.json` in the repo root pre-configures 4 MCP servers. Claude Code should load them automatically on start. Verify inside Claude:

```
> list available MCP tools
```

Expected: tools prefixed with `mcp__context7__`, `mcp__github__`, `mcp__playwright__`, `mcp__railway__`.

Set the required env vars in `.env`:

- `GITHUB_TOKEN` — a PAT with `repo` + `read:org` scope (create at https://github.com/settings/tokens)
- `RAILWAY_TOKEN` — from https://railway.app/account/tokens (only if you'll deploy)

## What each subagent is for

| Subagent               | When to use                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------ |
| `planner`              | Non-trivial feature — before any code                                                |
| `tdd-guide`            | Writing a feature — tests first                                                      |
| `code-reviewer`        | After writing / modifying code — general quality                                     |
| `security-reviewer`    | Touching auth / user input / DB / secrets — parallel with code-reviewer via `/review` |
| `build-error-resolver` | `bun run verify` fails, CI is red — reads error output, fixes root cause             |

## What each skill (slash command) is for

| Skill      | When to use                                                              |
| ---------- | ------------------------------------------------------------------------ |
| `/work-on` | Any non-trivial task — plans → TDD → reviews                             |
| `/ship`    | Feature done, ready for PR                                               |
| `/review`  | Standalone review pass (parallel code + security)                        |
| `/deploy`  | Push to Railway — pre-flight checks + smoke test                         |
| `/adr`     | Log a technical decision — Hermes vs OpenClaw, WhatsApp vs Telegram, etc |

## Do this / don't do this

**Do:**
- Ask `planner` before touching more than 2 files
- Run `/review` before every `/ship`
- Write an ADR for every architectural choice (why this DB, why this framework)
- Keep commits small — one behavior per commit
- Read `CLAUDE.md` before starting a new session
- Contribute back improvements to `foru-harness-template` (not just to your sprint repo)

**Don't:**
- Skip `bun run verify` before committing
- Commit `.env` (gitignored, but double-check)
- Use `git push --force` on `main`
- Mock the database in integration tests
- Trust training data for library APIs — use Context7 MCP
- Write documentation files unless explicitly asked

## Getting help

- **Faisal (tech lead)** — architecture / process / stuck-more-than-2-hours
- **Arief (advisor)** — big-picture direction only
- **Team channel** — daily blockers, PR reviews

Ask early. A 30-min question saves a 3-hour rabbit hole.
