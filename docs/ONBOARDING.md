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

ECC has **two layers** in this harness:

1. **Vendored rules** (this step) — 15 files at `.claude/rules/ecc/rules/` drive the `@`-imports in `CLAUDE.md`, so ECC rules are always in Claude's context. Kept as vendored copies (not submodule / not full clone) because ECC v2 is a full multi-tool distribution (~2200 files across i18n docs + 8 IDE bundles); cloning it wholesale blows Claude Code's memory-file scan past its 1M limit.
2. **Plugin `ecc@ecc`** — Step 4 below. Ships 67 subagents + 278 skills + 94 commands globally. Required.

Verify:

```bash
ls .claude/rules/ecc/rules/common/
# Expected: agents.md code-review.md coding-style.md development-workflow.md \
#           git-workflow.md hooks.md patterns.md performance.md security.md testing.md
```

Pinned upstream SHA is in `.claude/rules/ecc/VERSION.md`. `CLAUDE.md` `@`-imports 15 rule files (10 common + 5 TypeScript) on every session start. Every subagent (`planner`, `code-reviewer`, `security-reviewer`, `tdd-guide`, `critic`, `build-error-resolver`) explicitly cites the ECC files that govern it.

**To refresh the vendored files from upstream:**

```bash
./.claude/rules/ecc/update.sh
git diff .claude/rules/ecc/rules/   # review before committing
```

## Step 4 — install the ECC plugin (REQUIRED, one-time)

The vendored rules cover `@`-imports, but the harness also needs ECC's 67 subagents + 278 skills + 94 commands installed globally in Claude Code. `.claude/settings.json` declares `ecc@ecc` under `enabledPlugins`, so Claude Code will refuse to start clean if it's missing.

Open Claude Code:

```bash
claude
```

Then run **exactly these two commands** at the prompt:

```
/plugin marketplace add affaan-m/ECC
/plugin install ecc@ecc
```

You'll see confirmation output showing the plugin loaded — that includes commands like `/coding-standards`, `/security-audit`, `/tdd-cycle`, etc. Restart the Claude Code session once so the plugin registers cleanly.

Now the harness is fully wired. Every future Claude Code session (in any repo cloned from `zexo-harness-template` or any child template like `project-zero-demo`) auto-loads ECC's plugin — you never install it again.

## Step 5 — try a slash command

Try `/adr example-decision` — this scaffolds a new ADR. Confirm the file appears in `docs/ADR/`.

You can also try one of ECC's plugin-provided commands:

```
/coding-standards
/tdd-cycle
```

If these work, the ECC plugin is loaded correctly.

Try:

```
> what's the project scope?
```

Claude reads `CLAUDE.md` automatically. It should tell you the project goals.

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
- **ECC (rules foundation):** https://github.com/affaan-m/ECC (15 rule files vendored at `.claude/rules/ecc/rules/`, pinned SHA in `VERSION.md`)
- **RTK (token compression):** https://github.com/rtk-ai/rtk
