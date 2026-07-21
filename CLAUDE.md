# CLAUDE.md

**Read this on every session start.** This file is auto-loaded into Claude Code's context per turn.

Keep this file under **200 lines**. If it grows past that, run `/prune-claude-md` — move enforceable rules into hooks, scoped guidance into subdirectory `CLAUDE.md` files.

## ECC (Everything Claude Code) — base rules

The following rules from [affaan-m/ECC](https://github.com/affaan-m/ECC) are vendored at `.claude/rules/ecc/rules/` (15 files copied from upstream; pinned SHA in `VERSION.md`; refresh via `./.claude/rules/ecc/update.sh`). They govern this repo. Anything in this file below overrides or extends them; anything omitted here defers to ECC.

@.claude/rules/ecc/rules/common/coding-style.md
@.claude/rules/ecc/rules/common/testing.md
@.claude/rules/ecc/rules/common/security.md
@.claude/rules/ecc/rules/common/code-review.md
@.claude/rules/ecc/rules/common/git-workflow.md
@.claude/rules/ecc/rules/common/agents.md
@.claude/rules/ecc/rules/common/hooks.md
@.claude/rules/ecc/rules/common/patterns.md
@.claude/rules/ecc/rules/common/performance.md
@.claude/rules/ecc/rules/common/development-workflow.md
@.claude/rules/ecc/rules/typescript/coding-style.md
@.claude/rules/ecc/rules/typescript/testing.md
@.claude/rules/ecc/rules/typescript/security.md
@.claude/rules/ecc/rules/typescript/hooks.md
@.claude/rules/ecc/rules/typescript/patterns.md

## Project scope

**Replace this section per project.** Placeholder shape:

- **Codename:** `[PROJECT-CODENAME]`
- **Purpose:** `[one-sentence goal]`
- **Deadline:** `[YYYY-MM-DD or "no fixed deadline"]`
- **Success criteria:** `[what proves done — deploy, video, PR, benchmark, etc.]`
- **Non-goals:** `[what this project is deliberately NOT doing]`

## Repo conventions

Assumes Bun + TypeScript. Adapt to your stack per project.

- **Package manager:** Bun. Never mix with npm/pnpm.
- **Lint / format:** `oxlint` + `oxfmt` via `bun run verify`.
- **Test:** `bun test` for unit, Playwright for E2E, real DB for integration (never mocked).
- **Verify command:** `bun run verify` — typecheck + lint + fmt:check. Must pass before every commit.
- **Commit format:** conventional commits — `<type>: <description>` (type ∈ feat|fix|refactor|docs|test|chore|perf|ci).
- **Branch flow:** feature branches → PR → main. Never push directly to main.

## Harness architecture

`.claude/` is your Claude Code cockpit:

| Path                            | What                                                                       |
| ------------------------------- | -------------------------------------------------------------------------- |
| `.claude/settings.json`         | Hooks (RTK, lint, verify, notifications), model + effort, sandbox creds    |
| `.claude/agents/*.md`           | 6 subagents (planner, code-reviewer, security-reviewer, tdd-guide, critic, build-error-resolver) |
| `.claude/skills/*.md`           | 9 slash commands (/work-on, /ship, /review, /verify-adversarial, /loop, /swarm, /deploy, /adr, /prune-claude-md) |
| `.claude/hooks/*.sh`            | Hook scripts (post-edit-lint, notify-when-done)                            |
| `.claude/memory/MEMORY.md`      | Cross-session memory index — auto-maintained                              |
| `.claude-plugin/plugin.json`    | Plugin metadata (installable via `/plugin install`)                        |
| `.mcp.json`                     | Pre-configured MCP servers (Context7, GitHub, Playwright, Chrome DevTools) |

## Non-negotiables

1. **Never commit secrets.** `.env` is gitignored. API keys live in `.env` locally.
2. **Never skip hooks.** No `--no-verify` on git.
3. **Never `git push --force` to `main`** or protected branches.
4. **Always run `bun run verify` before declaring work done.** Per-file hooks catch per-file issues; verify catches cross-file.
5. **Every architectural decision → ADR.** Use `/adr` to scaffold.
6. **Verify facts before recommending.** Memory is a starting hypothesis, not truth. Grep / read current code before acting on remembered facts.
7. **CLAUDE.md is a contract with future you.** If a rule here is being violated regularly, fix the rule (or the hook) — don't just re-remind yourself.

## Subagents — when to use each

- **`planner`** — before any feature that touches > 2 files or > 30min of work. No code without a plan.
- **`tdd-guide`** — while implementing. Tests first (RED), implementation (GREEN), refactor (IMPROVE), verify 80%+ coverage.
- **`code-reviewer`** — after every non-trivial edit. General quality, style, error handling.
- **`security-reviewer`** — anything touching auth / user input / DB / secrets / crypto / payments.
- **`critic`** — adversarial reviewer. Give it the spec + the diff, ask "why is this wrong?" Especially valuable for compliance-critical code.
- **`build-error-resolver`** — `bun run verify` or CI failing. Reads errors, fixes root cause, never disables the check.

## Slash commands — when to use each

- **`/work-on <task>`** — full pipeline (plan → TDD → parallel review). Use for anything non-trivial.
- **`/ship`** — feature done, ready for PR. Verify + commit + push + open PR.
- **`/review`** — standalone parallel review of current diff.
- **`/verify-adversarial`** — after `/review` passes, do the adversarial pass. Fresh session, builder-critic separation.
- **`/loop <goal-file>`** — Ralph loop. Burn down a backlog file until `bun run verify` passes on every item.
- **`/swarm <task-list>`** — fan out N independent tasks to worktree-isolated subagents. Each opens a draft PR.
- **`/deploy`** — deploy to configured cloud. Pre-flight checks. Refuses on dirty tree / red CI / missing env.
- **`/adr <topic>`** — scaffold an ADR.
- **`/prune-claude-md`** — enforce 200-line CLAUDE.md ceiling. Moves rules to hooks, scoped guidance to subdirs.

## What NOT to do

- **Don't add error handling for scenarios that can't happen.** Trust internal code + framework guarantees. Only validate at boundaries.
- **Don't create documentation files** (`*.md`, README) unless explicitly asked.
- **Don't add features / abstractions / helpers** beyond what the task requires. No speculative generality.
- **Don't add comments** unless the WHY is non-obvious. Identifiers self-document.
- **Don't add backwards-compatibility shims** for code that isn't shipped yet.
- **Don't use emojis in code output** unless explicitly asked.

## Cost meter awareness

Claude Code sessions cost real money. Approximate meter:

- **Simple edit** — $0.02 – $0.10
- **Feature via `/work-on`** — $0.15 – $0.60
- **Adversarial review** — +$0.10 – $0.20 on top of `/review`
- **Ralph loop overnight** — $5 – $40 depending on backlog size

Set `COST_CEILING_SESSION_CENTS` in `.env` to auto-close sessions past a cap (if the agent runtime supports it).
