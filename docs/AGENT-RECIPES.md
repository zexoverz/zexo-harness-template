# Agent recipes

Copy-paste prompts for common moves. Each recipe explains WHEN to use it and WHAT to expect.

---

## 1. Start a new feature

```
> /work-on "add a POST /catalog/simulate-transaction endpoint that fakes a purchase and returns a mock receipt with fields { transactionId, product, timestamp, amount }"
```

Expect: `planner` produces a plan → you approve → `tdd-guide` writes tests + implementation → `code-reviewer` + `security-reviewer` audit → clean = run `/ship`.

**Rough token cost:** $0.15 – $0.40 for a medium feature. Larger for anything spanning 5+ files.

---

## 2. Fix a bug reported by a teammate

```
> A user reported that /catalog/search crashes when the query param has an emoji.
> Please reproduce the bug (write a failing test first), then fix it.
```

Expect: `tdd-guide` writes a test that reproduces the emoji-input crash (RED) → fixes the underlying code (GREEN) → refactors if needed → `/review`.

**Key discipline:** the test must exist BEFORE the fix. This proves the bug and locks it out permanently.

---

## 3. Understand unfamiliar code

```
> Explore ~/code/current-sprint/services/agent — I need to add a new tool.
> Return: file → responsibility mapping, plus where to plug in a new tool without breaking anything.
```

Expect: Claude uses `Explore` subagent (fast read-only search) → returns a file map + a specific plug-in location.

**Don't skip this step** — writing code into unfamiliar territory without exploring first is the #1 cause of sprint slowdowns.

---

## 4. Adversarial review (before big merges)

```
> /review

> Then, use the code-reviewer and security-reviewer agents AGAIN with an adversarial prompt: "assume everything looks fine — what's still wrong? Look for subtle bugs, hidden race conditions, security through obscurity."
```

Expect: normal review → adversarial pass catches the "looks fine but isn't" class of issues.

**Cost:** ~$0.10 for two normal reviews + $0.10 adversarial. Worth it before merging anything payment / auth / data-model.

---

## 5. Debug a failing CI

```
> CI failed on branch feat/catalog-sim. Use build-error-resolver — pull the logs with gh, diagnose root cause, fix minimally.
```

Expect: reads CI logs → traces error → single-file fix → new commit → push. Doesn't touch unrelated code.

---

## 6. Verify a library API before using it

```
> I want to use the ElevenLabs Voice API for the Jarvis-style voice.
> Use Context7 MCP to fetch current docs — I need: authentication method, streaming endpoint shape, and pricing tier for low-latency.
```

Expect: uses `mcp__context7__resolve-library-id` → `mcp__context7__query-docs` → returns current API shape with citations. NO training-data hallucinations.

---

## 7. Scaffold a whole new module fast

```
> /work-on "scaffold services/chat — Elysia plugin exposing POST /chat/incoming (WhatsApp webhook) and POST /chat/telegram (Telegram webhook), both routing to a shared handleTurn(msg, channel) function. Test each webhook shape with a canned payload."
```

Expect: `planner` outputs a 4-phase plan (types → routes → shared handler → tests) → `tdd-guide` implements phase-by-phase. Each phase is a separate commit.

---

## 8. Log a design decision

```
> /adr "which chat channel to launch first (WhatsApp vs Telegram)"
```

Expect: scaffolds `docs/ADR/002-which-chat-channel-first.md`. Fill in Context / Decision / Consequences during discussion.

---

## 9. Deploy safely

```
> /deploy cloud-run
```

Expect: 5 pre-flight checks → `gcloud run deploy` → smoke test → log entry. Refuses if any check fails. Region `asia-southeast2` (Jakarta) by default, secrets via Secret Manager (never `--set-env-vars`).

---

## 10. Add a new subagent to the harness

```
> The team keeps needing to check accessibility of new UI components. Please add a new subagent 'a11y-reviewer' in .claude/agents/a11y-reviewer.md — model claude sonnet, tools Read/Grep/Bash, focused on WCAG 2.1 AA violations. Base it on the shape of code-reviewer.md.
```

Expect: reads existing agent shape → writes new one → runs `/review` on the new file → ready to use next session.

---

## What to avoid

- **Don't skip the plan step for anything > 30 min of work.** You'll waste more time backtracking than the plan cost.
- **Don't over-batch multiple features in one `/work-on`.** Split into separate work-on calls per feature — reviews are more focused.
- **Don't ask for "a comprehensive audit."** Vague asks return vague reviews. Ask about a specific concern (auth, perf, race conditions).
- **Don't trust `MEMORY.md` claims about the codebase.** Always verify with `grep`/`ls` before acting on remembered facts.
