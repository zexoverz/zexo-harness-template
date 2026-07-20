---
name: prune-claude-md
description: "Enforce 200-line CLAUDE.md ceiling. Diagnoses bloat, moves enforceable rules into hooks, scoped guidance into subdirectory CLAUDE.md files. Runs as advisory (proposes changes, user approves)."
---

# /prune-claude-md

CLAUDE.md gets fat. Every "the agent did X wrong, add a rule to prevent it" grows the file. Past ~200 lines, rules dilute each other — signal-to-noise collapses.

This skill diagnoses the bloat and proposes surgery.

## Rules of pruning

1. **Enforceable rules → hooks.** If a rule can be checked deterministically (lint, format, git hook), move it OUT of CLAUDE.md and INTO a hook. Prose can't enforce what code can.
2. **Scoped guidance → subdirectory CLAUDE.md.** Rules that only apply to `services/agent/` belong in `services/agent/CLAUDE.md`. The root file stays generic.
3. **"Twice = pattern, once = noise."** If you've hit the same issue only once, delete the rule. Two occurrences = worth a rule. One = the issue was random.
4. **Never redundant with AGENTS.md.** Anything cross-tool goes in AGENTS.md, and CLAUDE.md refers to it. No copy-paste.
5. **Every rule earns its line.** If deleting the rule wouldn't visibly change future behavior, delete it.

## Instructions

1. **Measure.** `wc -l CLAUDE.md`. If < 200, stop and say "no pruning needed."
2. **Categorize every section.** For each ## heading, decide:
   - **Enforceable** → propose a hook that would enforce it
   - **Scoped** → propose the subdirectory where it belongs
   - **Duplicative with AGENTS.md** → propose deletion + `See AGENTS.md`
   - **Cruft** → propose deletion (with rationale)
   - **Genuinely root-level and needed** → keep
3. **Propose the diff.** Show:
   - What moves where
   - What gets deleted
   - What hooks get created (with the hook script content)
   - Final line count estimate
4. **Ask for approval.** Do not apply changes unsupervised.
5. **On approval, apply.** Create the subdirectory CLAUDE.md files, add the hooks, delete the redundancies. Update the top of CLAUDE.md with a comment noting the last prune date + line count.

## Anti-patterns you'll find

- **"Do NOT do X"** rules that repeat something already in AGENTS.md → delete
- **Codebase tour** — file/directory maps → move to `docs/ARCHITECTURE.md`, link from CLAUDE.md
- **Stack details** — "we use Bun + Elysia" — move to AGENTS.md if cross-tool, otherwise leave a one-liner
- **Historical context** — "we tried X, it didn't work" → move to `docs/ADR/`
- **Task lists** — belong in issues or `docs/backlog.md`, not CLAUDE.md
- **Cost meter details** — move to `docs/AGENT-RECIPES.md`

## References

- [Anthropic — CLAUDE.md deep dive](https://redreamality.com/blog/claude-md-agents-md-deep-dive/)
- [aicodex.to — Anti-patterns](https://www.aicodex.to/articles/claude-code-antipatterns)
- [dev.to/tacoda — subdirectory CLAUDE.md files](https://dev.to/tacoda/building-the-agent-harness-subdirectory-claudemd-files-dcl)

## Output

- **Before:** N lines
- **After:** M lines (must be < 200)
- **Files created:** list of new CLAUDE.md files + hook scripts
- **Files deleted:** none (pruning doesn't delete files, just moves content)
- **Rationale:** one-line summary per moved section
