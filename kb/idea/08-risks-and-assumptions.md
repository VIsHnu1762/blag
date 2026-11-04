# 08 · Risks and assumptions

Status: **Proposal**. Last updated: 2026-11-04.

## Assumptions to test

| ID | Assumption | How to test | Pass if |
|---|---|---|---|
| A-01 | Friend groups want a **daily** game, not an occasional one | Two-week hand-run test (below) | Most circles still playing on day 14 |
| A-02 | Bluffing about real stats is **fun**, not awkward | Hand-run test plus short interviews | Players describe it as fun; few ask to skip |
| A-03 | Friends who live apart **miss small daily moments** | Interviews with 10–15 people from distant friend groups | Most recognise the problem unprompted |
| A-04 | Typed-in numbers with **seal before you claim** feel fair | Hand-run test, with seals done by a neutral helper | Few disputes about the truth |
| A-05 | Ten minutes a day is **enough and not too much** | Time each session in the hand-run test | Median session 5–15 minutes |
| A-06 | A **monthly** season keeps interest better than weekly | Compare two circles in the test, or a later beta | Engagement holds through week 4 |
| A-07 | Players will use **focus lanes** | Ask players to pick one in the test | Most pick a lane other than "just for fun" |
| A-08 | Players **share** the recap card | Count shares in the beta | A meaningful share of players post one |

## The two-week hand-run test (no code)

The cheapest way to test A-01 to A-07 before writing code.

1. Recruit **three friend groups** of 4–6 people (for example a hostel group, a
   class group and a long-distance group).
2. Each group gets a **WhatsApp group and a shared sheet**. One team member is
   the "app".
3. Every day, the "app" posts the drop: today's Speaker and topic.
4. The Speaker privately sends their real number to the "app" (the seal), then
   posts a claim in the group.
5. Others vote with emoji within the window. The "app" reveals the truth and
   updates points in the sheet.
6. At day 14, run a mini finale with titles, then a 10-minute interview with
   each player.

**Measure:** daily participation, time per session, disputes, passes, what
players say they enjoyed, and what made anyone uncomfortable.

## Risks

| ID | Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| R-01 | **iOS won't allow auto-reading Screen Time** for sharing | High (based on Apple developer forum answers [S-29]) | High | Design for typed-in numbers; seal before you claim; trust tiers; never promise auto-sync on iOS |
| R-02 | **Fake stats** make the reveal meaningless | Medium | High | Seal before you claim; screenshot badges; on Android, optional auto-read |
| R-03 | **Novelty fades** like BeReal and Gas | High | High | League, knowing scores and yearbook build value over time; twist cards |
| R-04 | **Cold start**: needs 3+ friends to be fun | High | High | Invite whole circles; a web join for live mode; works with as few as three |
| R-05 | **Someone is uncomfortable** or becomes a target | Medium | High | Invisible pass, rest days, no free-text, skill-only points, comfort prompts |
| R-06 | **Health-data rules** for steps and sleep | Medium | Medium | Treat as sensitive; extra consent; legal review (Q-04) |
| R-07 | **Under-18 users** sign up | Medium | High | Launch 18+ with an age gate; legal review (Q-03) |
| R-08 | **Scope creep** from extra card types | High | Medium | One loop first (D-09) |
| R-09 | **Different time zones** make "today" confusing | Medium | Medium | One drop per circle with a 24-hour window (D-11) |
| R-10 | **Android permission flow** confuses users | Medium | Medium | Clear explanation screen; manual entry fallback |
| R-11 | The **name** clashes with an existing app or trademark | Unknown | Medium | Search stores and trademark databases (Q-06) |
