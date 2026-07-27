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
- **Enrolled in Studio OS** as **`PROD-JAPA`** (`pri8771/studio-ios`); product-side pointer in `.factory/studio-link.json`, authoritative record proposed at `products/japa/` (PR)
- v1 implementation present and **on-device validated** on iPhone 16 Pro Max (2026-07-18)
- Automated suite: full unit + UI count is being re-verified after merging `agent/fix-app-icon` with `origin/main` on 2026-07-27 (branches had diverged to 62 and 64 tests respectively); see `docs/STATUS.md`/`TEST_PLAN.md` for the post-merge canonical count
- **Automated-UI-testing foundation** in `quality/ui/` (screens/journeys/safe-actions + generated Maestro flows); deterministic `UI_TEST_MODE`/`UI_FIXTURE` contract in `Japa/JapaApp.swift`
- Platforms: **iOS / iPhone only** (DEC-003)
- Standard lock: `pri8771/iOS_app_factory_rules` @ `0.4.0` (upgraded from `0.2.0` on 2026-07-17 — DEC-004)
- **TestFlight CD workflow (`release-testflight.yml`) now has a committed `Gemfile.lock`** so `ruby/setup-ruby@v1`'s `bundler-cache: true` step no longer hard-fails before reaching signing; distribution signing/upload is still unverified pending Apple Developer account access
- Canonical Jira project is **`MALA`**; the older `JAPA`/`JALA` trackers are historical only (see `docs/JIRA_SYNC_PENDING.md`)

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

Bundled spiritual content has been removed. Remaining release gates are live privacy/support pages, final screenshots and metadata, a signed TestFlight upload, and release-candidate device QA. VoiceOver user validation is explicitly deferred post-v1 with residual risk recorded in MALA-7. Device haptics + full round + all 21 mala styles were validated on physical iPhone 16 Pro Max on 2026-07-18. The TestFlight CD workflow now clears the Ruby/bundler setup step with a committed `Gemfile.lock`; it is expected to fail cleanly at the signing step until Apple Developer account secrets are configured — that is a separate, human-gated blocker (MALA-8), not a CI defect.
