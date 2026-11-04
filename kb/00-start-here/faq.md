---
id: start.faq
title: FAQ
section: 00-start-here
status: living
summary: Short answers to the questions people ask most about BLAG.
order: 2
last_updated: 2026-11-04
audience: [everyone, judges]
related: [idea.vision, game.rules, privacy.home, pitch.home]
---

# FAQ

> **In short:** the questions friends, teammates and judges ask most, each with a two-line answer and a link.

## The idea

**What is BLAG in one line?**
A ten-minute daily game where close friends bluff about their real phone and
life stats, catch each other out, and get closer doing it. → [Vision](../01-idea/01-vision.md)

**Is it social media?**
No. There is no public feed, no followers, and it's designed to end after
about ten minutes. It's a private social game. → Decision D-04

**Isn't it encouraging people to use their phones more?**
No. Points never depend on whether a number is high or low, only on how well
you read your friends. Awareness comes as a side effect of the reveal. → [Red lines](../01-idea/05-principles-and-red-lines.md)

**Why would anyone lie about their screen time?**
Because it's the game. Like poker or Among Us, bluffing is the fun, inside a
clearly marked game. We call it a bluff, never a lie. → [Inspiration library](../01-idea/04-inspiration-library.md)

## Playing

**How long does it take each day?**
About ten minutes in total, spread across the day: a minute to read the claim,
a minute or two at the reveal. → [Game rules](../03-game-design/rules.md)

**What if I miss a day?**
Nothing happens. Nobody sees it, and your season score counts only your best
20 days. → Decisions D-08 and D-16

**What if I don't want to share a stat?**
Every stat is off until you turn it on, and you can pass any day without
anyone knowing. → [Rules: passing](../03-game-design/rules.md#passing-and-absence)

**Who wins?**
The player with the highest season score at the end of the month, but every
member gets a title at the finale. → [Seasons and titles](../03-game-design/seasons-and-titles.md)

**Can I cheat by typing a fake number?**
You can bluff in your claim, but your real number is sealed first and can't be
changed. Typing a false seal only fools yourself and is easy to spot with
screenshot proof. → [Sealing and fairness](../07-architecture/sealing-and-fairness.md)

## Technology and privacy

**Does BLAG read my screen time automatically?**
Not at first. On iPhone, Apple doesn't let apps export Screen Time numbers,
so everyone types them in. Android auto-reading may come later. → [Mobile dependencies](../09-mobile-dependencies/README.md)

**Who can see my numbers?**
Only your circle, and only the one number revealed in a round. Your history is
private to you. → [Privacy and security](../10-privacy-security/README.md)

**Can I delete everything?**
Yes, inside the app or from a web page. → Feature F-18

**What is it built with?**
Proposed: React Native with Expo, and Supabase for the backend. → [Tech stack](../08-tech-stack/README.md)

## The project

**What stage is BLAG at?**
Pre-development. The next step is a two-week test run by hand in WhatsApp. → [Validation plan](../01-idea/07-validation-plan.md)

**Who is it for?**
Close friend groups of 3–8, roughly 18–30, starting with university friends. → [Users](../02-users/README.md)
