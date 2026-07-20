# Sprint: Project Zero — Coinfest Asia 2026 demo

**Status:** planning
**Deadline:** 2026-08-07 (~17 days from 2026-07-21)
**Owner:** Faisal (tech lead)
**Team:** Naufal, Toriq, Ariq
**Origin doc:** [Lark — "Demo Idea"](https://hjf3rx3aoy2.sg.larksuite.com/docx/AhsadtcbMosBW7xvTt9lEAYAgdf)

## Deliberately NOT the foru-invest MVP

This is a **demo** — "keren-kerenan aja" per Faisal. Not compliance-audited, not the real product. Its purpose is:

- Impress stakeholders live at Coinfest Asia (offline demo)
- Produce marketing / BD video footage
- Test the "Zero" persona concept end-to-end
- De-risk the multi-channel chat + voice architecture ahead of the real MVP

Compliance posture is **demo-only** — no personal-advice guardrails needed, no OJK cross-check, no lead-routing to real partners. The whole catalog is fake.

## Deliverable spec (from Lark doc)

**"ForU Project Zero MVP"** — a chatbot agent named **Zero**, capable of:

1. **Chat interface (base):** WhatsApp + Telegram
2. **Voice interface (ideal):** phone-call-style ("imagine calling Jarvis")
3. **Animated blob visualization (stretch):** scaling blob synced to voice activity

## User journey

Each session is stateless (fresh start).

```
1. Trigger (new chat / new call)
2. Zero:   "Hi, good morning/afternoon/night — with whom I'm speaking and how can I help?"
3. User:   introduces self + shares financial needs / concerns
4. Zero:   back-and-forth (text or voice, with on-screen transcription)
           - if user goes off-topic → "I'm a financial expert agent, I'm only able to talk finance"
5. Zero:   compares products (NEVER advise / recommend — unless explicitly asked)
6. User:   picks a product
7. Zero:   walks user through a simulated transaction flow
8. Zero:   "hope that's helped — nudge me anytime if you need further support, thank you"
9. Close   (closing animation optional)
```

## Fake catalog structure

**4 wedges × 3 product types × 3-5 products = ~48 fake catalog entries.**

### Wedges

| Wedge                     | Example product types                              |
| ------------------------- | -------------------------------------------------- |
| Saving & Cash Management  | Saving accounts, term deposits, e-money            |
| Loan & Financing          | Personal loans, auto loans, mortgage               |
| Wealth & Investment       | Mutual funds, ETFs, robo-advisors                  |
| Insurance & Risks         | Life, health, auto, property                       |

### Naming convention (made-up, similar-sounding)

Use invented company names + product names that sound plausible but aren't real. Example from the spec:

- **PT BAP** — `Tahapan BAP` (savings), `Deposito Bunga Indah BAP` (term deposit)

Suggested fake providers:

- PT BAP (Bank Angkasa Pertiwi)
- PT MSC (Merah Sejahtera Capital)
- KanaKu Finance
- Sentosa Insurance
- Cipta Wealth Management
- Nusantara Digital Bank
- Prima Modal
- Bumi Asuransi
- Terang Investasi
- Harmoni Kredit

## Language

- **Bahasa Indonesia first** — Jakarta-casual register, informal ("kamu" not "Anda").
- **English second** — SEA-friendly, clear, no jargon.
- Currency: IDR ("Rp" prefix, dot as thousands separator).

## Open architectural decisions (need ADRs)

| # | Topic                                            | Owner    | Deadline           |
| - | ------------------------------------------------ | -------- | ------------------ |
| 1 | Agent runtime — **Hermes vs OpenClaw**           | Team     | Week 1 (Jul 28)    |
| 2 | Chat channel — WhatsApp first, Telegram, or both | Team     | Week 1             |
| 3 | Voice API — ElevenLabs, OpenAI Realtime, other   | Team     | Week 2 if we go for voice |
| 4 | Deployment target — Railway, Cloud Run, VM       | Team     | Week 1             |
| 5 | LLM choice — Claude, GPT, Gemini, local          | Team     | Week 1             |

Faisal's leaning is Hermes (per meeting notes — "OpenClaw team is moving away, security concerns"). Team confirms during Week 1.

**Faisal will NOT decide these** — the team decides + writes ADRs. That's the point of the sprint.

## Suggested phase breakdown

### Week 1 (Jul 21 - Jul 27): Foundation
- Decide agent runtime (ADR-001)
- Decide chat channel (ADR-002)
- Scaffold repo from this template
- Set up webhook receiving on chosen channel
- Wire agent runtime end-to-end (echo test)
- Seed fake catalog (structure, not content)

### Week 2 (Jul 28 - Aug 3): Zero persona + catalog
- Implement Zero's system prompt (greeting, off-topic redirect, no-advice guardrail)
- Fill fake catalog with 5-10 companies × 3 product types × 3-5 products
- Implement product-comparison flow
- Implement fake transaction flow
- End-to-end demo works via chat

### Week 3 (Aug 4 - Aug 7): Polish + optional voice
- Polish Zero's tone (Jakarta-casual Bahasa)
- Practice demo runs offline
- Optional: voice interface (if Week 2 slack allows)
- Optional: animated blob (if voice works and time remains)
- Deploy to Railway with public URL
- Rehearse demo → record video

## Success criteria

- [ ] Zero handles a full user journey (greet → collect needs → compare products → fake transaction → close) via at least one chat channel
- [ ] Fake catalog visibly comprehensive (4 wedges × 3+ types × 3+ products)
- [ ] Bahasa Indonesia works naturally
- [ ] Zero refuses off-topic requests with the exact phrasing from the spec
- [ ] Public URL live for demo day
- [ ] Video-quality run recorded

## What's out of scope

- Real product data (foru-invest handles real catalog)
- Real partner integration (routing is simulated)
- Compliance guardrails (P1/P2/P3 — these live in foru-invest)
- User accounts / auth (session is a chat/phone ID)
- Payment (transaction is fake)
- Persistent memory across sessions
- Multi-user concurrency load testing

## Communication

- **Daily standup async** — team channel, 1 line: what shipped yesterday, what's up today, blockers
- **Weekly sync** — 30 min with Faisal + Arief, Wednesday
- **Demo dry-run** — 3 days before Coinfest, whole team present

## Recipes for this sprint

See [`AGENT-RECIPES.md`](./AGENT-RECIPES.md). Especially useful:

- Recipe #7 (scaffold a whole new module fast) — for the chat webhook
- Recipe #8 (ADR) — for the 5 open decisions
- Recipe #1 (start a new feature) — for each catalog wedge
