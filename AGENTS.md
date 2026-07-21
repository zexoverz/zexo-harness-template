# AGENTS.md

**Cross-tool AI-agent rules for this repo.** Read by Claude Code, Cursor, Cline, Windsurf, Aider, and any tool that respects the AGENTS.md convention.

Bring your preferred IDE — this file guarantees consistent behavior. Claude Code additionally reads `CLAUDE.md` (superset).

## Base rules — ECC (Everything Claude Code)

Coding style, testing, security, code review, git workflow, and agent orchestration all defer to **ECC** (vendored at `.claude/rules/ecc/`, pinned by git submodule to [affaan-m/ECC](https://github.com/affaan-m/ECC)).

Tools that support `@`-imports (Claude Code) load ECC directly from `CLAUDE.md`. Tools that don't should manually read these files before working in this repo:

- `.claude/rules/ecc/rules/common/coding-style.md` — immutability, KISS/DRY/YAGNI, small files, naming, error handling
- `.claude/rules/ecc/rules/common/testing.md` — 80% coverage, TDD workflow, AAA pattern
- `.claude/rules/ecc/rules/common/security.md` — secret management, security response protocol
- `.claude/rules/ecc/rules/common/code-review.md` — review triggers, severity levels
- `.claude/rules/ecc/rules/common/git-workflow.md` — commit format, PR workflow
- `.claude/rules/ecc/rules/common/agents.md` — subagent orchestration, parallel execution
- `.claude/rules/ecc/rules/common/hooks.md` — Pre/PostToolUse/Stop hook guidance
- `.claude/rules/ecc/rules/common/patterns.md` — design patterns, skeleton reuse
- `.claude/rules/ecc/rules/common/performance.md` — model selection strategy (Haiku vs Sonnet vs Opus)
- `.claude/rules/ecc/rules/common/development-workflow.md` — Research → Plan → TDD → Review → Commit
- `.claude/rules/ecc/rules/typescript/*.md` — TypeScript overrides

**This file does NOT duplicate ECC rules.** If it's about immutability, file size, naming, `any`, coverage, or security checklists — read the ECC file. This file only adds project-specific extensions.

## Project-specific overrides (in addition to ECC)

### Repo shape

Assumes Bun + TypeScript. Adapt per-project as needed.

- **Package manager:** Bun. Never mix with npm/pnpm.
- **Lint / format:** `oxlint` + `oxfmt` via `bun run verify`.
- **Test:** `bun test` (unit), Playwright (E2E), real DB (integration — never mocked).
- **Commit format:** conventional commits — `<type>: <description>` (type ∈ feat|fix|refactor|docs|test|chore|perf|ci).

### Non-negotiables

1. **Never commit secrets.** `.env` is gitignored.
2. **Never skip pre-commit hooks** (no `--no-verify`).
3. **Never `git push --force` to `main`.**
4. **Always run `bun run verify` before declaring work complete.**
5. **Every architectural decision → ADR** in `docs/ADR/`.

### Framework opinions (defaults; adapt per-project)

- **Frontend:** React 19 with TanStack Router/Query, Tailwind v4.
- **Backend:** Elysia (Bun) or Hono. **No Express.**
- **Validation:** Zod at every boundary.
- **ORM:** Drizzle. **No Prisma.**
- **State:** `useState` + TanStack Query. No global-state library unless a component tree genuinely needs it.

### What NOT to do (this repo-specific, on top of ECC)

- **Don't create documentation files** (`*.md`, README) unless explicitly asked.
- **Don't use emojis in code output** unless explicitly asked.
