---
id: game.prompts
title: Prompt engine
section: 03-game-design
status: proposal
summary: "How the server chooses each day's Speaker, stat and wording, plus the rest-day prompt bank and rules for safe prompts."
order: 5
last_updated: 2026-11-04
audience: [product, developers, agents]
related: [game.rules, game.stats, brand.voice]
---

# Prompt engine

> **In short:** each morning the server privately picks a Speaker who has spoken least, a stat they've opted into (preferably from their lane), and a friendly sentence to frame the claim.

## 1. Choosing the Speaker

Eligible members:
- are in the circle and haven't paused themselves,
- have at least one stat turned on,
- joined before today's drop opened.

Pick the eligible member who has been Speaker **the fewest times this
season**. Break ties with a random choice seeded by the drop id (repeatable).
The backup Speaker is chosen the same way, excluding today's Speaker.

## 2. Choosing the stat

From the Speaker's turned-on stats:

1. Prefer stats in their **focus lane**.
2. Avoid a stat they were asked about in the **last 7 days**.
3. Include `spicy` or `health` stats only if they confirmed the extra opt-in.
4. Prefer stats marked `MVP` in the catalogue while the Next ones are tested.
5. If nothing qualifies, fall back to any turned-on stat.

## 3. Wording

Templates use placeholders. The Speaker sees the **private** version; the
circle sees the **public** one after the claim.

| Stat | Private (to Speaker) | Public (after claim) |
|---|---|---|
| ST-01 | "How long was your screen time yesterday?" | "{name} says their screen time yesterday was {claim}." |
| ST-02 | "How much time did you spend on social apps yesterday?" | "{name} says they spent {claim} on social apps yesterday." |
| ST-05 | "How many times did you pick up your phone yesterday?" | "{name} says they picked up their phone {claim} times yesterday." |
| ST-07 | "How many minutes did you use your phone after 1am last night?" | "{name} says {claim} after 1am last night." |
| LF-01 | "How many steps did you take yesterday?" | "{name} says they walked {claim} steps yesterday." |
| PR-01 | "How many minutes of focused work did you do yesterday?" | "{name} says {claim} of focus time yesterday." |
| FN-01 | "How many cups of tea or coffee did you have yesterday?" | "{name} says {claim} cups yesterday." |

Every template needs a "where to find it" line (from the catalogue) and must
pass the [voice and tone](../05-brand/voice-and-tone.md) check: no judgement words.

## Rest-day prompts

Rest days use prompts with no right answer. Members pick a circle member or an
option; the reveal shows the spread.

| Type | Example |
|---|---|
| Who in the circle | "Who would last longest without their phone?" |
| Who in the circle | "Who's most likely to reply to a message within 10 seconds?" |
| Would you rather | "Would you rather lose your camera roll or your chat history?" |
| Memory | "Which circle moment this month made you laugh most?" (pick a revealed round) |
| Prediction | "Next week, who will fool the most people?" |

### Safety rules for prompts

- No prompts about bodies, weight, appearance, money, relationships, religion,
  politics or health conditions.
- "Who in the circle" prompts must be affectionate or neutral; never "Who is the
  most addicted/laziest/worst…".
- New prompts are reviewed by two team members before they go live.

## Later: twist cards (P-07)

| Twist | Change |
|---|---|
| Double or nothing | Correct reads score +4 today |
| Everyone bluffs | The Speaker must bluff; readers guess by how much |
| Silent round | No reactions until the reveal |
| Guess yourself | The Speaker guesses their own number before sealing (P-06) |
