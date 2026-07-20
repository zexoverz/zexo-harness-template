---
name: adr
description: "Scaffold a new Architectural Decision Record in docs/ADR/. Use when a non-obvious technical choice needs documenting (Hermes vs OpenClaw, which DB, which chat channel first, etc.)."
---

# /adr <topic>

Create a new ADR (Architectural Decision Record) in `docs/ADR/`.

## Instructions

1. **List existing ADRs** — `ls docs/ADR/` to determine next number.
2. **Create `docs/ADR/NNN-<kebab-topic>.md`** using the template at `docs/ADR/000-adr-template.md`.
3. **Prefill:**
   - Number, date (2026-07-21 or the current date), status (`proposed`)
   - Title from the argument
   - Context section — one paragraph summarizing why this decision is being made
4. **Leave blank:** Decision, Consequences, Alternatives sections — the user fills these in during discussion.
5. **Print the file path** so the user can open it.

## Guardrails

- ADRs are immutable once accepted. If a later decision changes course, write a NEW ADR that supersedes the old one (mark the old one `superseded by NNN`), don't edit the old one.
- Numbers are monotonic and never reused. If ADR 007 was proposed and rejected, use 008 next.

## Argument form

- `/adr agent-runtime-choice` — kebab-case, becomes ADR-NNN-agent-runtime-choice.md
- `/adr "which chat channel first"` — quotes for spaces; kebab-cased automatically
