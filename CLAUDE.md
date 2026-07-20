# CLAUDE.md — Sprint context

**Read this on every session start.** This file is auto-loaded into Claude Code's context per turn.

## What this sprint is

**Replace this section per sprint.** Placeholder shape:

- **Codename:** `[SPRINT-CODENAME]` (e.g., `project-zero-coinfest`)
- **Deadline:** `[YYYY-MM-DD]`
- **Deliverable:** `[one-sentence goal]`
- **Success criteria:** `[demo/video/PR/deploy — what proves done]`
- **Compliance posture:** `[strict / lite / demo-only]`

## Who this is for

- **Tech lead:** Faisal (`@zexoverz`)
- **Members:** Naufal (`@naufalputra1008`), Toriq (`@toriqahmads`), Ariq (`@AriqUntukmu`)
- **Advisors:** Arief (`@ariefclawford`), Kai (`@kaiipang`)

## Repo conventions

- **Package manager:** Bun (fallback: pnpm if a lib demands it). Never mix.
- **Runtime:** Bun for backend services; Node LTS if a lib forces it.
- **Lint / format:** `oxlint` + `oxfmt` (via `bun run verify`). No ESLint / Prettier unless the file lives inside a nested tool that already ships them.
- **Test:** `bun test` for unit, Playwright for E2E.
- **Verify command:** `bun run verify` runs typecheck + lint + fmt:check. Must pass before every commit.
- **Commit message format:** conventional commits — `<type>: <description>` where type ∈ `feat|fix|refactor|docs|test|chore|perf|ci`.
- **PR title:** short (< 70 chars). Details go in the body.

## Harness architecture

The `.claude/` directory in this repo is your Claude Code cockpit:

| Path                  | What                                                                                       |
| --------------------- | ------------------------------------------------------------------------------------------ |
| `.claude/settings.json`     | Hooks (RTK PreToolUse, post-edit lint, Stop verify), model + effort defaults        |
| `.claude/agents/*.md`       | 5 subagents — `planner`, `code-reviewer`, `tdd-guide`, `security-reviewer`, `build-error-resolver` |
| `.claude/skills/*.md`       | 5 slash commands — `/ship`, `/work-on`, `/review`, `/deploy`, `/adr`                       |
| `.claude/hooks/*.sh`        | Optional hook scripts                                                                      |
| `.claude/memory/MEMORY.md`  | Cross-session memory index                                                                 |
| `.mcp.json`                 | Pre-configured MCP servers (checked in, auto-loaded)                                       |

## ECC + RTK

Two global systems always active:

- **ECC (Everything Claude Code)** — rules from `~/.claude/rules/ecc/` — coding style, testing (80% coverage), git workflow, security checklist, code review standards, agent orchestration. Applies to every session.
- **RTK (Rust Token Killer)** — CLI proxy that compresses 60–90% of dev-command output. Hooked in via `.claude/settings.json` → `PreToolUse.Bash`. Zero config for you.

See [`docs/ONBOARDING.md`](./docs/ONBOARDING.md) for a deeper dive.

## Non-negotiables

1. **Never commit secrets.** `.env` is gitignored. Anthropic keys, Hermes tokens, WhatsApp API keys all live in `.env` locally.
2. **Never skip hooks.** Do not pass `--no-verify` to git. If a hook fails, fix the underlying issue.
3. **Never `git push --force` to `main`.** Feature branches only.
4. **Always run `bun run verify` before declaring work done.** The PostToolUse hook runs per-file lint; verify catches cross-file issues the per-file hook misses.
5. **Every architectural decision → ADR.** Use `/adr` to scaffold. Especially: which agent runtime (Hermes vs OpenClaw), which chat channel first (WhatsApp vs Telegram), how to handle fake catalog data.

## Working with the subagents

- **Complex new feature or refactor?** Ask `planner` first. Don't dive into code without a plan.
- **After writing code?** Run `/review` — spawns `code-reviewer` + `security-reviewer` in parallel.
- **Writing tests?** Use `tdd-guide` — enforces write-tests-first.
- **Build broken?** Use `build-error-resolver` — reads error output, fixes incrementally.

## Working with slash commands

- **`/work-on <task>`** — plan first (planner agent), then TDD (tdd-guide agent), then review.
- **`/ship`** — verify, commit, push, open PR. Includes the CI green check.
- **`/review`** — parallel code + security review of current diff.
- **`/deploy`** — Railway deploy with pre-flight checks.
- **`/adr <topic>`** — scaffold a new Architectural Decision Record in `docs/ADR/`.
