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

## Current state (2026-07-18)

- Registered with App Factory as **existing**; product lifecycle state is **`verified`** (registration/onboarding complete)
- v1 implementation present and **on-device validated** on iPhone 16 Pro Max (2026-07-18)
- Automated suite: **62 tests (52 unit/flow + 10 UI), all passing**
- Platforms: **iOS / iPhone only** (DEC-003)
- Standard lock: `pri8771/iOS_app_factory_rules` @ `0.4.0` (upgraded from `0.2.0` on 2026-07-17 — DEC-004)
- **TestFlight deployment automation committed** (`docs/DEPLOYMENT.md`, DEC-005); needs App Store Connect secrets + one verified run
- Canonical Jira project is **`JAPA`** (the `JALA-*` project was retired — do not use it)

## Read first

1. `.factory/repository-map.json`
2. `.factory/project-context.json`
3. `.factory/standard-lock.json`
4. `docs/README.md`
5. `docs/STATUS.md`
6. `docs/ARCHITECTURE.md`
7. `LAUNCH_READINESS.md`
8. `quality/feature-contracts/FEAT-001*.json` through `FEAT-003*.json`

## Do not

- Re-scaffold or rewrite the engine
- Add streaks, notifications, backend, or third-party SDKs
- Claim iPad support
- Mark work `done` without evidence

## Next verification

Remaining human gates: seed-mantra content sign-off (JAPA-6) and VoiceOver user validation (JAPA-8). For distribution, configure the four App Store Connect secrets and run the TestFlight workflow once (JAPA-9), then record evidence under `quality/evidence/` and flip `docs/DEPLOYMENT.md`'s end-to-end row to `verified`. Device haptics + full round + all 21 mala styles were validated on physical iPhone 16 Pro Max on 2026-07-18.
