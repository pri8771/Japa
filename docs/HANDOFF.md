---
id: DOC-HANDOFF
canonicalFor: next-agent-context
status: active
lastVerified: 2026-07-27
readWhen:
  - starting work in a fresh session with no prior context
related:
  - STATUS.md
  - DECISIONS.md
supersedes: []
---

# Handoff

## What the project is

Mala is a local-first iOS digital mala for daily repetition practice. Differentiator: eyes-free, interruption-safe, haptic-confirmed counting with a distinct end-of-round signal. Internal code, scheme, bundle, and persistence identifiers retain the original `Japa` name.

## Current state (2026-07-27)

- Registered with App Factory as **existing**; product lifecycle state is **`verified`** (registration/onboarding complete)
- v1 implementation present and **on-device validated** on iPhone 16 Pro Max (2026-07-18)
- Automated suite: **62 tests (52 unit/flow + 10 UI), all passing**
- Platforms: **iOS / iPhone only** (DEC-003)
- Standard lock: `pri8771/iOS_app_factory_rules` @ `0.4.0` (upgraded from `0.2.0` on 2026-07-17 — DEC-004)
- **TestFlight deployment automation present but unverified** (`docs/DEPLOYMENT.md`, DEC-005); signing configuration and secrets need one real run
- Canonical Jira project is **`MALA`**; the older JAPA/JALA trackers are historical only

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

Bundled spiritual content has been removed. Remaining release gates are live privacy/support pages, final screenshots and metadata, a signed TestFlight upload, and release-candidate device QA. VoiceOver user validation is explicitly deferred post-v1 with residual risk recorded in MALA-7. Device haptics + full round + all 21 mala styles were validated on physical iPhone 16 Pro Max on 2026-07-18.
