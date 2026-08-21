---
id: DOC-HANDOFF
canonicalFor: next-agent-context
status: active
lastVerified: 2026-08-20
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

## Current state (2026-08-20)

- Registered with App Factory as **existing**; factory registration/onboarding is complete. Product lifecycle state (per `PROJECT_LIFECYCLE.md`'s controlled vocabulary, see `docs/STATUS.md`) is **`released`** — version 1.0 Build 2 is live on the public App Store as of 2026-08-20.
- **Enrolled in Studio OS** as **`PROD-JAPA`** (`pri8771/studio-ios`); product-side pointer in `.factory/studio-link.json`; Studio OS is an external portfolio mirror, not the product authority
- v1 implementation present and **on-device validated** on iPhone 16 Pro Max (2026-07-18)
- Automated suite: **69 tests (56 unit/flow + 13 UI), all passing** — re-verified 2026-08-06; the added UI case validates the deterministic 9m 0s App Store history fixture; see `docs/STATUS.md`/`TEST_PLAN.md`
- **Automated-UI-testing foundation** in `quality/ui/` (screens/journeys/safe-actions + generated Maestro flows); deterministic `UI_TEST_MODE`/`UI_FIXTURE` contract in `Japa/JapaApp.swift`
- Platforms: **iOS / iPhone only** (DEC-003)
- Standard lock: `pri8771/iOS_app_factory_rules` @ `0.4.0` (upgraded from `0.2.0` on 2026-07-17 — DEC-004)
- **TestFlight:** Build 1 is in Testing. Build 2 was uploaded manually through Xcode Organizer, processed, confirmed working through TestFlight on 2026-08-06, and is now the released App Store build. `ASC_KEY_CONTENT` remains missing but blocks only optional GitHub automation.
- **App Store submission:** five final screenshots and all required product metadata are accepted; Data Not Collected is published; non-trader DSA status is Active in 27 EU regions; version 1.0 Build 2 was submitted on 2026-08-06 at 11:40 PM under submission `897d1493-c2f1-474f-afa6-01d3e92694c4`, approved by Apple App Review, and **released to the public App Store on 2026-08-20** (Processing for Distribution → Ready for Distribution, both 8:20 PM). Mala 1.0 (Build 2) is now live worldwide, free, no IAP. Exact store name `Mala` was unavailable, so the store record remains `Mala: A Quiet Digital Mala`; the device display name is still `Mala`. See `docs/STATUS.md` and `quality/evidence/2026-08-20-app-store-release.md`.
- Jira mirror project is **`MALA`**; repository documents are authoritative and the older `JAPA`/`JALA` trackers are historical only (see `docs/GOVERNANCE.md` and `docs/JIRA_SYNC_PENDING.md`)

## Read first

1. `.factory/repository-map.json`
2. `.factory/project-context.json`
3. `.factory/standard-lock.json`
4. `.factory/studio-link.json`
5. `docs/README.md`
6. `docs/GOVERNANCE.md`
7. `docs/STATUS.md`
8. `docs/ARCHITECTURE.md`
9. `LAUNCH_READINESS.md`
10. `quality/feature-contracts/FEAT-001*.json` through `FEAT-003*.json`
11. `quality/ui/README.md` (automated UI-testing foundation)

## Do not

- Re-scaffold or rewrite the engine
- Add streaks, notifications, backend, or third-party SDKs
- Claim iPad support
- Mark work `done` without evidence

## Next verification

Bundled spiritual content has been removed. Mala 1.0 Build 2 is live on the public App Store as of 2026-08-20; there is no pending submission to monitor. Nothing is blocking. Open items going forward: monitor App Store reviews and crash reports for the live version; VoiceOver support is out of scope by product decision (DEC-010) and is not tracked as residual risk (MALA-7 is closed, not deferred); GitHub Actions release automation (`ASC_KEY_CONTENT`) remains an optional, non-blocking follow-up (R4) whenever the owner wants unattended future releases. Device haptics + full round + all 21 mala styles were validated on physical iPhone 16 Pro Max on 2026-07-18.
