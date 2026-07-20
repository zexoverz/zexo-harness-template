# AGENTS.md

**Cross-tool AI-agent rules for this repo.** Read by Claude Code, Cursor, Cline, Windsurf, Aider, and any tool that respects the AGENTS.md convention.

Bring your preferred IDE — this file guarantees consistent behavior. Claude Code additionally reads `CLAUDE.md` (superset).

## Repo shape

Assumes Bun + TypeScript. Adapt per-project as needed.

- **Package manager:** Bun. Never mix with npm/pnpm.
- **Lint / format:** `oxlint` + `oxfmt` via `bun run verify`.
- **Test:** `bun test` (unit), Playwright (E2E), real DB (integration — never mocked).
- **Commit format:** conventional commits — `<type>: <description>` (type ∈ feat|fix|refactor|docs|test|chore|perf|ci).

## Non-negotiables

1. **Never commit secrets.** `.env` is gitignored.
2. **Never skip pre-commit hooks** (no `--no-verify`).
3. **Never `git push --force` to `main`.**
4. **Always run `bun run verify` before declaring work complete.**
5. **Every architectural decision → ADR** in `docs/ADR/`.

## Coding style

- **Immutability first** — never mutate objects; use spread / immutable update.
- **Small files** — 200–400 lines typical, 800 max.
- **Small functions** — < 50 lines.
- **Named constants** — no magic numbers.
- **Early returns** over deep nesting (max 4 levels).
- **Explicit error handling** — never silently swallow errors.
- **No `any`** — use `unknown` + narrowing, or generics.

## Framework opinions (defaults; adapt per-project)

- **Frontend:** React 19 with TanStack Router/Query, Tailwind v4.
- **Backend:** Elysia (Bun) or Hono. No Express.
- **Validation:** Zod at every boundary.
- **ORM:** Drizzle. No Prisma.
- **State:** `useState` + TanStack Query. No global-state library unless a component tree genuinely needs it.

## Testing

- **Coverage target:** 80% minimum on new code.
- **AAA pattern** — Arrange / Act / Assert.
- **Test names describe behavior** — `test('returns empty array when no markets match query')`.
- **Integration tests hit a real database, never mocked.**

## Security checklist (every commit)

- [ ] No hardcoded secrets
- [ ] All user inputs validated with Zod
- [ ] Parameterized queries (via Drizzle)
- [ ] XSS-safe HTML rendering
- [ ] CSRF protection if applicable
- [ ] Error messages don't leak sensitive data

## What NOT to do

- **Don't add error handling for scenarios that can't happen.**
- **Don't create documentation files** unless explicitly asked.
- **Don't add features / abstractions / helpers** beyond what the task requires.
- **Don't add comments** unless the WHY is non-obvious.
- **Don't add backwards-compatibility shims** for code not yet shipped.
- **Don't use emojis in code output** unless explicitly asked.

## Git workflow

Prefer NEW commits over amending. If a pre-commit hook fails, the commit didn't happen — `--amend` would modify the previous commit and potentially destroy work.

Never `git add -A` blindly. Review with `git status` after staging. Check for accidentally-included `.env`, credentials, or large binaries.
