# Design

Status: **Seeded**. Last updated: 2026-11-04.

## What we already know

### Emotional design goals

| Moment | Feeling | Notes |
|---|---|---|
| Daily drop arrives | Curiosity | Short, fun prompt; no guilt in the notification |
| Making a claim | Mischief | Make bluffing feel like a skill |
| Voting | Suspense | Short timer feel even in async play |
| Reveal | Peak delight | Counting-up number, TRUTH/BLUFF! stamp, haptics |
| Being caught | Laughing at yourself | Copy is affectionate, never mocking |
| Missing days | Welcome back | Catch-up card; nobody sees you were away |
| Finale | Belonging | Everyone gets a title |

### Known screens (from the original spec, to be updated for the daily-league model)

Home · Create/join circle · Circle lobby · Stat entry · Today's drop · Claim ·
Vote · Reveal · Day recap · League · Finale and titles · Share card · My month
(private) · Settings and privacy.

### Constraints

- **Accessibility:** WCAG 2.2 AA; never rely on colour alone for TRUTH/BLUFF;
  reduced-motion option for the reveal.
- **No red/green or up/down arrows** for personal data.
- **Big, readable numbers.**
- **Mute toggle** for sounds; haptics optional.

## To do in this section

- [ ] Information architecture and navigation
- [ ] User flows for each journey in the [users section](../users/README.md)
- [ ] Wireframes for every MVP screen
- [ ] Interaction specs: reveal animation, stamps, timers, haptics
- [ ] Empty, loading, error, offline and "away" states
- [ ] Design system tokens (after brand decisions)
- [ ] Prototype for the hand-run test or the first usability test
