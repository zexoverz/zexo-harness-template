# ADR-001: Autonomous agent runtime — Hermes vs OpenClaw

**Status:** proposed
**Date:** 2026-07-21
**Deciders:** Naufal, Toriq, Ariq (with Faisal + Arief sign-off)
**Context tag:** sprint / project-zero / infra

## Context

Coinfest demo needs a **full autonomous agent** ("Zero") that can drive a multi-turn conversation via chat (and optionally voice). Arief has floated two options:

1. **Hermes** — Faisal's preferred choice. Modern, actively developed, better security posture.
2. **OpenClaw** — Foru's existing agent runtime. Battle-tested inside Foru but the org is moving away from it due to security concerns (per pre-event workshop 2026-06-04 — team explicitly moving toward Codebuddy SDK, OpenClaw fleet is legacy).

The sprint has 3 weeks. The runtime choice affects every downstream integration (chat channel adapters, tool routing, session state, deployment shape).

## Decision

**TO BE FILLED BY THE TEAM** — Naufal, Toriq, Ariq: run a 2-day spike (Jul 21-22), evaluate both runtimes against the criteria below, write the decision here.

### Evaluation criteria

For each runtime, score 1-5:

| Criterion                                        | Hermes | OpenClaw |
| ------------------------------------------------ | ------ | -------- |
| Time-to-hello-world (fresh install → echo bot)   |        |          |
| Multi-turn state handling (built-in vs DIY)      |        |          |
| Tool-calling ergonomics                          |        |          |
| Chat channel adapters (WhatsApp / Telegram)      |        |          |
| Voice adapter possibility                        |        |          |
| Deployment shape (single binary, container, etc) |        |          |
| Docs quality                                     |        |          |
| Community / active dev                           |        |          |
| Security posture                                 |        |          |
| Cost (self-hosted vs SaaS)                       |        |          |

**Winning runtime:** _<fill in after spike>_

## Consequences

### Positive
_<fill in>_

### Negative
_<fill in>_

### Neutral
_<fill in>_

## Alternatives considered

Beyond Hermes / OpenClaw:

- **Codebuddy SDK** — mentioned as the direction Foru is moving. Consider if the spike reveals it's ready for demo work.
- **LangGraph** — mature, well-documented, but framework-heavy and adds a Python or TS runtime commitment.
- **CrewAI** — multi-agent orchestration; probably overkill for a single "Zero" persona.
- **Roll our own** — direct Anthropic SDK calls with manual tool loop. Faisal already has this pattern in `foru-invest`. Fastest path but no autonomous-agent branding.

## References

- Lark doc: [Demo Idea (Project Zero)](https://hjf3rx3aoy2.sg.larksuite.com/docx/AhsadtcbMosBW7xvTt9lEAYAgdf)
- Prior context: pre-event workshop 2026-06-04 — team moving away from OpenClaw due to security concerns
- Faisal's `foru-invest` agent-runtime approach — direct Anthropic SDK, no framework (in `services/agent/src/orchestrator.ts`)

---

**Note to team:** Faisal explicitly said this is YOUR decision. He'll review the ADR but won't pick for you. Take the 2-day spike seriously — the sprint hinges on this.
