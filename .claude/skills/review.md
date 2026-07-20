---
name: review
description: "Parallel code-reviewer + security-reviewer of the current diff. Use before /ship."
---

# /review

Fires `code-reviewer` and `security-reviewer` in parallel over the current diff.

## Instructions

1. Run `git diff --stat main...HEAD` to establish scope. If HEAD == main or no diff, say so and stop.
2. Invoke two subagents in a SINGLE message (parallel):
   - `code-reviewer` — general quality
   - `security-reviewer` — OWASP + Foru-specific
3. Collect findings from both. Deduplicate — same file+line reported by both means both are worth flagging but the CRITICAL wins on severity.
4. Present findings ranked most-severe first. Grouped by file.
5. For each finding, offer: **Fix**, **Skip (with rationale)**, or **Defer to ticket**.

## Guardrails

- Never auto-apply fixes. Findings are informational — user decides.
- If either reviewer returns 0 findings, say so explicitly (don't manufacture concerns).
- CRITICAL from `security-reviewer` always blocks `/ship` — flag this clearly in the summary.
