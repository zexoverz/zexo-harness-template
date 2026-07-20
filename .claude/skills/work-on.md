---
name: work-on
description: "End-to-end feature workflow: plan (planner agent) → TDD (tdd-guide) → review (code-reviewer + security-reviewer) → ready to /ship. Provide a task description as the argument."
---

# /work-on <task>

Full feature-development pipeline. Use for anything non-trivial.

## Instructions

Do NOT execute manually — orchestrate the subagents in this order:

1. **Read the task**. If ambiguous, ask ONE clarifying question. Otherwise proceed.
2. **Invoke `planner` subagent** — pass the task description. Wait for the plan.
3. **Present the plan** to the user for approval. Do not skip this step, even if `auto` mode is on.
4. **On approval, invoke `tdd-guide` subagent** — pass the plan. It writes tests first (RED), implements (GREEN), refactors (IMPROVE), verifies 80% coverage.
5. **On implementation completion, invoke `code-reviewer` + `security-reviewer` in PARALLEL** (single message, two Agent calls).
6. **Address CRITICAL and HIGH findings.** Downgrade to `/ship` when clean.

## Guardrails

- If `planner` returns "task too big — split first," present the split proposal to the user.
- If `security-reviewer` returns CRITICAL findings, HALT — do not proceed to `/ship` until fixed.
- If `tdd-guide` reports coverage < 80% on any new file, add tests before continuing.

## Argument form

- `/work-on <freeform task description>` — plain English works
- `/work-on gh:<issue-number>` — pull description from GitHub issue
- `/work-on lark:<doc-token>` — pull spec from a Lark doc (uses lark-cli)
