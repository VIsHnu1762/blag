---
id: design.language
title: UX language and moments map
section: 06-design
status: proposal
order: 1.5
summary: "The words BLAG uses in the app (familiar to social-media and productivity users), and a moment-by-moment map linking each screen's words and feeling to the proven product pattern behind it, BLAG's own twist, and the backend step that guarantees it."
last_updated: 2026-11-04
audience: [design, product, developers, agents, judges]
related: [design.emotional, brand.voice, arch.blueprint, start.glossary, idea.inspiration]
---

# UX language and moments map

> **In short:** BLAG speaks the language people already use on social and productivity apps (drops, lock it in, receipts, season wrap), so nothing needs explaining; every moment borrows a pattern that has worked elsewhere, adds one BLAG twist, and is backed by a specific backend guarantee.

Status: **Proposal**. All words are to be tested in the hand-run test (A-10)
before they're final. Code and database names don't change (see the
[glossary](../00-start-here/glossary.md), which now lists both).

## Adoption principles

| Principle | Meaning for BLAG |
|---|---|
| **Familiar first** | People prefer apps that work like the ones they already use (Jakob's Law) [S-76]. BLAG reuses known gestures and words: stories-style finale, Wordle-style share, chat-style invites |
| **One decision per screen** | More choices slow decisions (Hick's Law) [S-76]. Each game screen asks one thing: lock it, drop it, call it |
| **Fun in 60 seconds** | A new member sees a real claim within a minute of joining, before any setup beyond one stat |
| **Ask later, not upfront** | Join with one lane and one stat; offer more stats after the first reveal |
| **Thumb zone** | Main buttons in the bottom third; TRUTH and BLUFF full width |
| **One delight a day** | The reveal is the only big animation; everything else is calm |
| **No dark patterns** | No fake urgency, no guilt, no streak traps ([red lines](../01-idea/05-principles-and-red-lines.md)) |

## Vocabulary: system words → in-app words

| Concept (code name) | In the app | Why it lands | Avoid |
|---|---|---|---|
| circle | **Circle** | Same idea as close-friends lists on social apps | group, room |
| drop | **Today's Drop** | "Drops" are how music, sneakers and games release: new, timed, exciting | session, match |
| speaker | **On the mic 🎤** | Familiar from podcasts and live audio; playful, not formal | player of the day |
| seal | **Lock it in 🔒** | Everyday phrase for committing to something, also used for getting focused | submit, seal |
| truth_zone | **Honest range** | Self-explanatory | tolerance |
| claim | **Drop your number** | Echoes "drop"; short and active | statement |
| read | **Call it: TRUTH or BLUFF** | "Call it" is natural party-game language | vote, accuse |
| guess | **Bonus guess** | Makes the optional part clearly optional | bet |
| reveal | **The Reveal** at **reveal time** | Reality-TV and game-show familiarity | results |
| reactions | **Reacts** | Same word as messaging apps | likes |
| day_score | **Today's points** | Plain | score |
| season | **Season** | Games and streaming series both use seasons | month |
| league | **The League** | Fantasy-sports familiarity, but friendly | leaderboard, ranking |
| finale | **Season Wrap** | Recalls year-end music recaps people love to share | results |
| title | **Your title** | Like a superlative in a yearbook | badge |
| focus_lane | **Your lane** | "Stay in your lane" is everyday; doubles as the productivity idea of focus | goal |
| sensitivity=spicy | **🌶️ Spicy** | Instantly signals "a bit personal" | sensitive |
| pass | **Skip today** | Neutral; nothing to explain | pass, opt out |
| away | (nothing shown) | Absence is invisible | absent, inactive |
| catch_up | **While you were away** | Familiar from news and social apps | missed |
| card_type=rest | **Chill Day** | Signals a lighter day | rest day |
| my_month | **Just you** (only you can see this) | Privacy promise in the label itself | dashboard, stats |
| our_month | **Our story** | Stories format is familiar | timeline |
| trust_level / proof | **Receipts 🧾** | "Show the receipts" means "show proof" | verified |
| live | **Live** | Familiar from streaming | party mode |
| knowing score (Next) | **In sync** | Friendship language, not numbers | compatibility |

## Moments map

Each row: what the person sees, what they should feel, the proven pattern it
borrows, BLAG's twist, and the backend step that makes it reliable.

| # | Moment | In-app words | Feeling | Proven pattern (source) | BLAG twist | Backend guarantee |
|---|---|---|---|---|---|---|
| 1 | Invite | "Invite your circle" → link or QR | Belonging | Room codes and phone-first joining from party games [S-24] | One link brings the whole group; circle capped at 8 | `circles/join`; invite code stored hashed; rate-limited |
| 2 | Join | "Pick your lane" → one stat | In control | Small, close-friend networks [S-14] | Lane decides what *you* get asked about | `circles/lane-set`, `consent-set`; nothing shared until opted in |
| 3 | Drop opens | "Today's Drop is live 👀" | Curiosity | One shared daily moment [S-03, S-01] | The Speaker is a secret | `scheduler` opens drop; `drop.opened` event; Speaker hidden by row-level security |
| 4 | You're the Speaker | "You've got the mic 🎤🤫" | Mischief | Hidden roles in social-deduction games [S-25] | Your real life is the material | Private push to the Speaker only; generic lock-screen text |
| 5 | Lock it in | "Lock it in 🔒" + where to find your number | Fair play | — (BLAG's own) | Truth locked *before* the bluff | `game/seal` → `private.seals`; locked at claim |
| 6 | Honest range | "Anything from 7,200 to 8,800 counts as the truth" | Clever | — (BLAG's own) | Bluffing is always deliberate | Computed by `game-engine` `truthZone()` |
| 7 | Drop your number | "Drop your number" | Excitement | — | Name revealed only now | `game/claim`: claim + `round.claimed` in one transaction |
| 8 | Call it | "Priya says 9,400 steps. TRUTH or BLUFF?" | Playful suspicion | Voting on who's lying [S-25] | Real numbers, not made-up roles | `game/read`; others' calls hidden until reveal |
| 9 | Waiting | "Locked in. Reveal at 9pm" | Anticipation | Timed shared reveal [S-01] | Early reveal when everyone's in | Score-on-write; last read triggers early reveal |
| 10 | The Reveal | Number counts up → **BLUFF!** stamp | Delight | Reveal moments and celebration animations [S-05] | One big moment a day, then calm | `reveal_due_rounds()` every minute; within 2 minutes (SLO) |
| 11 | Reacts | Preset emoji | Laughter | Uncounted reactions [S-14] | No text, no pile-ons | Emoji from a fixed list; never aggregated |
| 12 | Skip today | "Skip today" | Relief | — | Nobody can tell | Backup Speaker chosen privately |
| 13 | Coming back | "While you were away…" | Welcome | — | No missed-day counts, ever | Best-20 scoring; no absence data exposed |
| 14 | Chill Day | "Who'd last longest without their phone?" | Lightness | — | A day off from numbers | Rest card type; no points |
| 15 | The League | Positions, joint places | Playful rivalry | Small groups that reset [S-06] | Points only for reading people | `league` from `round.revealed`; best-20 |
| 16 | Season Wrap | Titles dealt like cards, moments, share card | Pride, belonging | Year-end recaps people share [S-07]; friends mode [S-08] | Everyone gets a title; no stats on the card | `league` close + `assignTitles()`; `season.finale_ready` |
| 17 | Share | Card with stamps and titles | Showing off safely | Spoiler-free share grid [S-03] | Shows the play, never the numbers | Share image built on device from non-sensitive fields |
| 18 | Just you | "Only you can see this" | Calm insight | — | Compared only with your past self | Owner-only access rules |
| 19 | Receipts | "Add receipts 🧾" | Trust | — | Proof is optional and appears only after the reveal | `proofs` unlocks after `round.revealed`; deleted after 30 days |
| 20 | Leaving | "Leave circle" / "Delete everything" | Control | Store-required deletion [S-37, S-38] | No guilt copy | `account.deleted` → every service cleans its own data |

## What's borrowed and what's new

| Borrowed (proven) | New in BLAG |
|---|---|
| Daily drop and timed reveal | **Lock-it-in before you bluff**: fair bluffing with typed numbers |
| Hidden-role bluffing | **Real habits as the game material**, with consent per stat |
| Close-friend circles | **Points for reading people, never for the numbers** |
| Season recaps that people share | **Everyone gets a title**; share cards without stats |
| Party-game joining | **Invisible skipping** and a **secret Speaker** |
| Celebration animations | **Honest range** that makes every bluff deliberate |

## The 60-second first run

1. Tap the invite link → "Join Hostel 4B" (sign-in, 18+ check).
2. "Pick your lane" (one tap).
3. "Turn on one thing to bluff about" (one stat, plain explanation).
4. Land on **Today's Drop**: if a claim is already up, call it immediately.
5. After the first reveal: "Want more to bluff about?" offers more stats.

## Rules for trendy language

- Use words most 18–30-year-olds already use; avoid slang that dates fast or excludes people.
- Every label must make sense without the emoji.
- Never use words that judge habits ([voice and tone](../05-brand/voice-and-tone.md)).
- English first; keep every string in the catalogue so it can be translated and changed without code.
- Test with real users in the hand-run test and usability tests; replace anything that needs explaining.
