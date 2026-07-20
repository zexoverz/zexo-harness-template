---
name: swarm
description: "Fan out N independent tasks to worktree-isolated subagents in parallel. Each subagent runs in its own git worktree, opens a draft PR when done. Best when tasks have no cross-dependencies (independent bug fixes, unrelated feature branches, parallel research)."
---

# /swarm <task-list>

Parallel worktree-isolated task execution. N subagents work simultaneously without stepping on each other, each opening a draft PR.

## When this wins

- **Independent tasks** that can be worked on in parallel
- **Bug backlog** — 5 bugs, no shared code paths → 5 subagents in worktrees → 5 draft PRs
- **Migration sweeps** — rename a symbol across 10 files → 10 subagents, one per file
- **Research spikes** — evaluate 3 libraries → 3 subagents, each prototyping one

## When this LOSES

- Tasks that touch overlapping files (worktree isolation prevents this, but the result is 5 conflicting PRs)
- Tasks with sequential dependencies
- Tasks requiring shared state or feedback loops

## Instructions

Argument: `<task-list>` — one of:

- Comma-separated tasks: `/swarm "fix bug #123, fix bug #124, add /health endpoint"`
- Path to a task file: `/swarm docs/swarm-tasks.md` (file contains numbered task list)
- GitHub label: `/swarm gh:label=parallel-ok` (queries GitHub for open issues with that label)

For each task:

1. **Create a git worktree.** `git worktree add ../swarm-<sanitized-task-slug>-<n> -b feat/swarm/<n>-<slug>` from `main`.
2. **Spawn a subagent** using the `Agent` tool with `isolation: 'worktree'`. Prompt structure:
   ```
   Task: <task description>
   Working directory: <worktree path>
   Constraints:
   - Do not touch files outside <task's expected scope>
   - Follow all rules in CLAUDE.md + AGENTS.md
   - Run bun run verify before committing
   - Commit with conventional message
   - Open a DRAFT PR when done (gh pr create --draft)
   ```
3. **Wait for all subagents to complete** (they run in parallel, but this skill blocks on all).
4. **Collect results.** For each:
   - Worktree path
   - Branch name
   - Draft PR URL (or reason for failure)
   - `bun run verify` status

## Constraints

- **Max concurrent subagents: 5.** More than that hits the concurrent-agent cap + confuses the git worktree state. If the task list has > 5, batch them.
- **Each subagent has a 30-minute time budget.** Runaway subagents auto-terminate.
- **Cost ceiling: honor `COST_CEILING_SESSION_CENTS` from `.env`.**
- **Worktrees are ephemeral.** After the swarm completes + you've merged (or closed) the PRs, run `git worktree remove <path>` for each.

## Safety guarantees

- Every subagent works in an isolated worktree — they cannot corrupt your main working directory.
- Every subagent creates a DRAFT PR by default (not ready-for-review). You review + convert to ready when confident.
- No subagent can push to `main` directly (branch protection should already enforce this; skill respects it either way).
- If a subagent fails, its worktree is preserved so you can inspect state.

## Output

Table:

```
| # | Task                              | Status | Branch                | PR   | Verify |
|---|-----------------------------------|--------|-----------------------|------|--------|
| 1 | Fix bug #123                      | ✓ done | feat/swarm/1-bug-123  | #45  | pass   |
| 2 | Fix bug #124                      | ✗ fail | feat/swarm/2-bug-124  | —    | fail   |
| 3 | Add /health endpoint              | ✓ done | feat/swarm/3-health   | #46  | pass   |
```

## Cost estimate

~$0.15 – $0.40 per subagent depending on task size. A 5-task swarm typically $1.50 – $3.00.

## Field references

- Claude Code changelog v2.1.212+ — `isolation: 'worktree'` + agent-teams
- Anti-pattern: don't use `/swarm` for cross-dependent tasks. Use `/loop` (sequential) or one `/work-on` (context-shared).
