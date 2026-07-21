# Onboarding — first hour with zexo-harness-template

This walks you through your first hour with the harness. After this you'll know how to use Claude Code + ECC + RTK effectively.

## Prerequisites

- macOS or Linux (Windows via WSL2)
- Git + `gh` (GitHub CLI) — `brew install gh` on macOS
- Bun — installed by `setup.sh` if missing
- Rust + Cargo — needed for RTK — `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Claude Code — https://docs.claude.com/claude-code

## Step 1 — clone + bootstrap

```bash
gh repo create <owner>/<my-new-project> --template zexoverz/zexo-harness-template --private
cd <my-new-project>
./setup.sh
```

Or, if you already have a repo:

```bash
git clone https://github.com/<owner>/<my-new-project>.git
cd <my-new-project>
./setup.sh
```

`setup.sh` verifies your environment. It's idempotent — safe to run multiple times.

## Step 2 — verify RTK

RTK compresses 60-90% of Bash output before Claude sees it. Test:

```bash
rtk --version
# Expected: rtk 0.43.x or higher
rtk gain
# Expected: shows token-savings analytics (works even before you've used it)
```

If `rtk gain` errors with "command not found," you likely have the WRONG rtk binary (there's a `reachingforthejack/rtk` = Rust Type Kit that collides on the name). Uninstall it and reinstall from https://github.com/rtk-ai/rtk.

## Step 3 — verify ECC

**As of v0.2.0, ECC is vendored as a git submodule in this repo** — no global install required. It lives at `.claude/rules/ecc/` and is pinned to a specific SHA of [affaan-m/ECC](https://github.com/affaan-m/ECC). `setup.sh` auto-initializes it.

Verify:

```bash
ls .claude/rules/ecc/rules/common/
# Expected: agents.md code-review.md coding-style.md development-workflow.md \
#           git-workflow.md hooks.md patterns.md performance.md security.md testing.md
```

`CLAUDE.md` `@`-imports 15 ECC files (10 common + 5 TypeScript) on every session start, so ECC rules are always in Claude's context. Every subagent (`planner`, `code-reviewer`, `security-reviewer`, `tdd-guide`, `critic`, `build-error-resolver`) explicitly cites the ECC files that govern it.

If the submodule directory is empty (fresh clone without `--recurse-submodules`), run:

```bash
git submodule update --init --recursive
```

## Step 4 — open Claude Code

```bash
claude
```

Try:

```
> what's the project scope?
```

Claude reads `CLAUDE.md` automatically. It should tell you the project goals.

## Step 5 — use a slash command

Try `/adr example-decision` — this scaffolds a new ADR. Confirm the file appears in `docs/ADR/`.

## Step 6 — use a subagent

Try a work-on command. Give a small task like "add a hello-world endpoint":

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

Expected: tools prefixed with `mcp__context7__`, `mcp__github__`, `mcp__playwright__`, `mcp__chrome-devtools__`.

Set the required env vars in `.env`:

- `GITHUB_TOKEN` — a PAT with `repo` + `read:org` scope (create at https://github.com/settings/tokens)
- Cloud target (only if you'll deploy): `GCP_PROJECT_ID` + `GCP_REGION`, OR `VERCEL_TOKEN`, OR `FLY_API_TOKEN`

## What each subagent is for

| Subagent               | When to use                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------ |
| `planner`              | Non-trivial feature — before any code                                                |
| `tdd-guide`            | Writing a feature — tests first                                                      |
| `code-reviewer`        | After writing / modifying code — general quality                                     |
| `security-reviewer`    | Touching auth / user input / DB / secrets — parallel with code-reviewer via `/review` |
| `critic`               | Adversarial review — fresh session, tries to break the diff. Use for high-stakes code. |
| `build-error-resolver` | `bun run verify` fails, CI is red — reads error output, fixes root cause             |

## What each skill (slash command) is for

| Skill                   | When to use                                                              |
| ----------------------- | ------------------------------------------------------------------------ |
| `/work-on`              | Any non-trivial task — plans → TDD → reviews                             |
| `/ship`                 | Feature done, ready for PR                                               |
| `/review`               | Standalone review pass (parallel code + security)                        |
| `/verify-adversarial`   | After `/review` passes — adversarial critic on the diff                  |
| `/loop <goal-file>`     | Autonomous burndown of a backlog checklist                               |
| `/swarm <task-list>`    | Fan out N independent tasks to worktree-isolated subagents               |
| `/deploy`               | Push to GCP / Vercel / Fly — pre-flight checks + smoke test              |
| `/adr <topic>`          | Log a technical decision                                                 |
| `/prune-claude-md`      | Diagnose + fix CLAUDE.md bloat                                           |

## Do this / don't do this

**Do:**
- Ask `planner` before touching more than 2 files
- Run `/review` before every `/ship`
- Run `/verify-adversarial` for anything auth / payment / security-sensitive
- Write an ADR for every architectural choice
- Keep commits small — one behavior per commit
- Read `CLAUDE.md` before starting a new session

**Don't:**
- Skip `bun run verify` before committing
- Commit `.env` (gitignored, but double-check)
- Use `git push --force` on `main`
- Mock the database in integration tests
- Trust training data for library APIs — use Context7 MCP
- Write documentation files unless explicitly asked

## Getting help

- **Issues in the template itself:** https://github.com/zexoverz/zexo-harness-template/issues
- **Claude Code docs:** https://code.claude.com/docs
- **ECC (rules foundation):** https://github.com/affaan-m/ECC (vendored as submodule at `.claude/rules/ecc/`)
- **RTK (token compression):** https://github.com/rtk-ai/rtk
