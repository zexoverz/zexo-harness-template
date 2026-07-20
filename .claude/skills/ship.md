---
name: ship
description: "Verify + commit + push + open PR. Use when a feature or fix is done and ready for review."
---

# /ship

End-to-end shipping flow for a completed feature or fix. Runs:

1. `bun run verify` (typecheck + lint + fmt:check) — must pass
2. `git status` + `git diff` review — no secrets, no unintended files
3. Draft conventional-commit message (feat|fix|refactor|docs|test|chore|perf|ci)
4. Commit + push to the current branch (never `main` directly)
5. Open a PR against `main` with body + test plan

## Instructions

- Before staging: run `git status`. If anything untracked looks sensitive (`.env`, `*.key`, credentials), STOP and ask the user.
- Never use `git add -A` blindly. Add specific files.
- Never pass `--no-verify` to `git commit`.
- If pre-commit hook fails, don't retry with `--no-verify` — fix the underlying issue, then create a NEW commit (not `--amend`).
- PR body must include:
  - **Summary** (1-3 bullets)
  - **Test plan** (checklist)
  - Optional: **Screenshots** if UI touched
- Never push `--force` to `main` or any protected branch.

## Refuse to ship if

- `bun run verify` fails
- Uncommitted files that look like secrets are staged
- Current branch is `main` (require a feature branch)
- No new commits vs `origin/main` (nothing to ship)
