# AGENTS.md

**Cross-tool AI-agent rules for this repo.** Read by Claude Code, Cursor, Cline, Windsurf, Aider, and any tool that respects the `AGENTS.md` convention.

Team members can bring their preferred AI IDE — this file guarantees the same behavior everywhere. Claude Code additionally reads `CLAUDE.md` (superset).

## Repo shape

- **Package manager:** Bun (default). Fallback to pnpm only if a specific library demands it.
- **Runtime:** Bun for services; Node LTS only if a library forces it.
- **Lint / format:** `oxlint` + `oxfmt` via `bun run verify`.
- **Test:** `bun test` for unit, Playwright for E2E.
- **Commit format:** conventional commits — `<type>: <description>` (type ∈ feat|fix|refactor|docs|test|chore|perf|ci).

## Non-negotiables

1. **Never commit secrets.** `.env` is gitignored; API keys stay local.
2. **Never skip pre-commit hooks** (no `--no-verify`).
3. **Never `git push --force` to `main`** or any protected branch.
4. **Always run `bun run verify` before declaring work complete.**
5. **Every architectural decision → ADR** in `docs/ADR/`.

## Coding style

- **Immutability first** — never mutate objects; use spread / immutable update patterns.
- **Small files** — 200-400 lines typical, 800 max.
- **Small functions** — < 50 lines. Split when they grow.
- **Named constants** — no magic numbers.
- **Early returns** over deep nesting (max 4 levels).
- **Explicit error handling** — never silently swallow errors.
- **No `any` in TypeScript** — use `unknown` + narrowing, or generics.

## Framework opinions

- **React 19** with TanStack Router / Query, Tailwind v4.
- **Backend**: Elysia (Bun) or Hono (Node fallback). No Express.
- **Validation**: Zod.
- **ORM**: Drizzle. No Prisma (too heavy for our stack).
- **State**: `useState` + TanStack Query for server state. No Redux / Zustand unless a component tree genuinely needs global state (rare).

## Testing

- **Coverage target:** 80% minimum on new code.
- **AAA pattern** — Arrange / Act / Assert.
- **Test names describe behavior** — `test('returns empty array when no markets match query', ...)`.
- **Integration tests hit a real database**, not mocks. Reason: mocked tests can pass while prod migrations break.

## Security checklist (before every commit)

- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] All user inputs validated with Zod
- [ ] SQL injection prevention (parameterized queries via Drizzle)
- [ ] XSS prevention (sanitized HTML)
- [ ] CSRF protection if applicable
- [ ] Error messages don't leak sensitive data

## What NOT to do

- **Don't add error handling for scenarios that can't happen.** Trust internal code and framework guarantees. Only validate at boundaries.
- **Don't create documentation files** (`*.md`, README) unless explicitly asked.
- **Don't add features / abstractions / helpers** beyond what the task requires. No speculative generality.
- **Don't add comments** unless the WHY is non-obvious. Identifiers should self-document.
- **Don't add backwards-compatibility shims** for code that isn't shipped yet.
- **Don't use emojis in code output** unless the user explicitly asks.

## Git workflow

Prefer creating a NEW commit over amending. If a hook fails, the commit didn't happen — so `--amend` would modify a previous commit, potentially destroying work. Instead: fix the issue, re-stage, create a new commit.

Never stage files with `git add -A` blindly — review with `git status` after, and check for accidentally-included `.env`, credentials, or large binaries.
