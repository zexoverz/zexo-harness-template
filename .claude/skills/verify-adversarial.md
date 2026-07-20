---
name: verify-adversarial
description: "Builder/critic separation — after /review passes, spawn a fresh-context critic agent to attack the diff against the spec. Bypasses the self-validation echo chamber. Use before shipping anything compliance-critical, security-sensitive, or payment-touching."
---

# /verify-adversarial

Adversarial verification of the current diff. Runs AFTER `/review` — this catches what `/review` and the builder both rationalized past.

## Why this exists

`code-reviewer` and `security-reviewer` share context with the builder. They see the code with the same framing the builder used. Even at their best, they inherit the builder's blind spots.

The `critic` subagent starts fresh. It reads the spec first, THEN the diff, and defaults to "there is something wrong, and I'll find it." This is the single cheapest quality jump for high-stakes code. Costs ~$0.10 per verification.

Field research: [ASDLC — Adversarial Code Review pattern](https://asdlc.io/patterns/adversarial-code-review/).

## Instructions

1. **Locate the spec.** In order of preference:
   - Explicit user prompt describing what should ship
   - GitHub issue linked in current branch / PR
   - `docs/ADR/` entry for the feature
   - Latest commit message body
   - If none of the above, ASK the user for the spec. Do not proceed without one — a critic without a spec is just a second reviewer.

2. **Locate the diff.** `git diff main...HEAD` (or `git diff` for uncommitted changes if pre-commit).

3. **Invoke `critic` subagent** with:
   - The spec verbatim
   - The diff
   - Explicit prompt: "Assume everything looks fine — that's exactly why you should look harder. Find the failure. Default to refuted=true if uncertain."

4. **Present findings.** Ranked most-severe first. For each:
   - Show the failure scenario (concrete input → wrong behavior)
   - Ask the user: **Fix**, **Skip (with rationale)**, or **Defer to ticket**

## Guardrails

- **Do NOT proceed to `/ship` while `critic` has CONFIRMED findings.** PLAUSIBLE findings can be judgment-called.
- Do not auto-apply fixes. Findings are informational — user decides.
- If `critic` returns empty findings, say so explicitly. That's a real signal.

## Cost estimate

~$0.08 – $0.15 depending on diff size. Compare to shipping a subtle bug: usually worth the spend on anything auth / payment / compliance.
