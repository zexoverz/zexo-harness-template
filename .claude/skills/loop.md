---
name: loop
description: "Ralph-loop autonomous burndown. Given a goal file (default docs/backlog.md), iterate: pick next item → implement → verify → commit → mark done → next. Halts when goal file is empty OR bun run verify fails 3 times in a row. Best for well-specified verifiable backlogs (feature checklists, port work, migration lists)."
---

# /loop <goal-file>

Ralph loop — the autonomous overnight burndown pattern. Named after Ralph Wiggum's "me fail English? that's unpossible!" — the loop just... keeps going.

## When this wins

- You have a **well-specified backlog** (checklist items with clear DONE criteria)
- Each item is **independently verifiable** (`bun run verify` passes = it's done)
- The backlog is **large enough that context would explode** if handled in one session

## When this LOSES

- Ambiguous or research-heavy items (LLM will thrash)
- Items with cross-dependencies (Ralph is stateless per iteration — deps break)
- No machine-checkable DONE criterion (nothing prevents drift)

## Instructions

Argument: `<goal-file>` — default `docs/backlog.md`. The file must contain a checklist with the format:

```markdown
## Backlog

- [ ] Add /catalog/:id endpoint returning product details
- [ ] Add /catalog/search endpoint with query + group filters
- [ ] Wire fake-catalog seeds for insurance wedge (5 products)
```

Loop body:

1. **Read `<goal-file>`.** Parse for unchecked items (`- [ ]`).
2. **If no unchecked items → STOP.** Announce completion, exit cleanly.
3. **Pick the first unchecked item.** Log it to `LOG.md` — `<timestamp> loop → starting: <item>`.
4. **Fresh sub-context:** invoke `/work-on <item>` with the item as the task. This starts a plan → TDD → review pipeline for THIS item only.
5. **After `/work-on` completes:**
   - Run `bun run verify`. If it passes, proceed. If it fails, log the failure to `LOG.md` and increment the failure counter.
   - **If 3 consecutive failures → STOP.** Escalate to the user.
6. **Commit.** Conventional commit message: `feat|fix: <item description>`. Include a footer `refs: <goal-file>#<line-number>`.
7. **Mark the item done in `<goal-file>`.** Change `- [ ]` to `- [x]`. Add a footer link to the commit SHA.
8. **Log completion to `LOG.md`.** `<timestamp> loop → done: <item> (<sha>)`.
9. **Reset the failure counter.** Go to step 1.

## Iteration constraints

- **Max iterations: 30.** Even if the backlog is longer, exit after 30. Long loops eat unbounded money.
- **Cost ceiling: honor `COST_CEILING_SESSION_CENTS` from `.env`.** If the ceiling is hit, exit cleanly.
- **Per-iteration timeout: 20 minutes.** If a single item hasn't completed in 20 min, exit and log.

## Safety guarantees

- Every iteration must produce a passing `bun run verify` OR the item is reverted (git reset) and marked failed.
- Never `git push --force`.
- Never delete files unless the item explicitly says to.
- Never modify `<goal-file>` beyond marking items done + adding SHA footers.

## Output

At the end of the loop, print:

- **Items completed:** N / M
- **Items failed:** list with commit SHAs (if any) and failure reason
- **Estimated total cost:** $X.XX
- **Duration:** X hours Y minutes

## Field references

- [awesomeclaude.ai/ralph-wiggum](https://awesomeclaude.ai/ralph-wiggum)
- [amplitude.com — week-long Ralph case study](https://amplitude.com/blog/ralph-loop)
- [linearb.io — Inventing the Ralph Wiggum Loop](https://linearb.io/dev-interrupted/podcast/inventing-the-ralph-wiggum-loop)

## Cost estimate

$5 – $40 per full loop depending on backlog size + per-item complexity. Overnight runs typically $15 – $25.
