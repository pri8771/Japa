---
id: DOC-FEATURES
canonicalFor: feature-inventory
status: active
lastVerified: 2026-07-17
readWhen:
  - onboarding
  - implementing or changing a feature
related:
  - ../quality/feature-contracts
  - BUGS.md
supersedes: []
---

# Features

## Product outcome

A quiet, local-first digital mala for eyes-free mantra repetition: advance by feel, keep place across interruptions, and receive a distinct completion signal at the target bead.

## Feature inventory

| ID | Feature | Status | Notes |
|----|---------|--------|-------|
| F1 | Repetition engine | implemented | Unit-tested hard gate |
| F2 | Eyes-free practice screen | implemented | Device feel validation pending |
| F3 | Distinct completion haptic + tone | implemented | On-device A/B pending |
| F4 | Seed + free-text mantras | implemented | Content sign-off pending |
| F5 | Session completion + quiet history | implemented | No streaks |
| F6 | Preferences (target / tone / intensity) | implemented | |
| F7 | Local-first persistence + privacy | implemented | PrivacyInfo present |
| — | Intro (skippable) | implemented | |
| — | App icon | implemented | |

## Out of scope (v1)

Streaks / loss-aversion, reminders/notifications, chanting/per-bead audio, photoreal beads, large content library, accounts/sync/social, analytics/ads/SDKs, IAP, Watch/widgets/Live Activities, **iPad layout**, broad localization.

## Feature contracts

Highest-risk workflows live in `quality/feature-contracts/`:

- `FEAT-001` practice advance / undo / complete
- `FEAT-002` interruption resume
- `FEAT-003` engine round contract
