---
id: DOC-HANDOFF
canonicalFor: next-agent-context
status: active
lastVerified: 2026-07-18
readWhen:
  - starting work in a fresh session with no prior context
related:
  - STATUS.md
  - DECISIONS.md
supersedes: []
---

# Handoff

## What the project is

Japa is a local-first iOS digital mala for daily mantra repetition. Differentiator: eyes-free, interruption-safe, haptic-confirmed counting with a distinct end-of-round signal.

## Current state (2026-07-19)

- Registered with App Factory as **existing**; product lifecycle state is **`verified`** (registration/onboarding complete)
- **Enrolled in Studio OS** as **`PROD-JAPA`** (`pri8771/studio-ios`); product-side pointer in `.factory/studio-link.json`, authoritative record proposed at `products/japa/` (PR)
- v1 implementation present and **on-device validated** on iPhone 16 Pro Max (2026-07-18)
- Automated suite: **64 tests (53 unit/flow + 11 UI), all passing** on simulator (2026-07-19)
- **Automated-UI-testing foundation** in `quality/ui/` (screens/journeys/safe-actions + generated Maestro flows); deterministic `UI_TEST_MODE`/`UI_FIXTURE` contract in `Japa/JapaApp.swift`
- Platforms: **iOS / iPhone only** (DEC-003)
- Standard lock: `pri8771/iOS_app_factory_rules` @ `0.4.0` (upgraded from `0.2.0` on 2026-07-17 — DEC-004)
- **TestFlight deployment automation committed** (`docs/DEPLOYMENT.md`, DEC-005); needs App Store Connect secrets + one verified run
- Canonical Jira project is **`JAPA`** (the `JALA-*` project was retired — do not use it)

## Read first

1. `.factory/repository-map.json`
2. `.factory/project-context.json`
3. `.factory/standard-lock.json`
4. `.factory/studio-link.json`
5. `docs/README.md`
6. `docs/STATUS.md`
7. `docs/ARCHITECTURE.md`
8. `LAUNCH_READINESS.md`
9. `quality/feature-contracts/FEAT-001*.json` through `FEAT-003*.json`
10. `quality/ui/README.md` (automated UI-testing foundation)

## Do not

- Re-scaffold or rewrite the engine
- Add streaks, notifications, backend, or third-party SDKs
- Claim iPad support
- Mark work `done` without evidence

## Next verification

Remaining human gates: seed-mantra content sign-off (JAPA-6) and VoiceOver user validation (JAPA-8). For distribution, configure the four App Store Connect secrets and run the TestFlight workflow once (JAPA-9), then record evidence under `quality/evidence/` and flip `docs/DEPLOYMENT.md`'s end-to-end row to `verified`. Device haptics + full round + all 21 mala styles were validated on physical iPhone 16 Pro Max on 2026-07-18.
