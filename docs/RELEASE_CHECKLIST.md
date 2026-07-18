---
id: DOC-RELEASE-CHECKLIST
canonicalFor: release-readiness
status: active
lastVerified: 2026-07-18
readWhen:
  - preparing a release
related:
  - TEST_PLAN.md
  - DEPLOYMENT.md
  - ../LAUNCH_READINESS.md
supersedes: []
---

# Release Checklist

Reconciled 2026-07-17 (re-dated 2026-07-18) against `LAUNCH_READINESS.md` §9 and live build/test + on-device evidence — checkboxes below reflect actual verified evidence, not a fresh unstarted template. The *deployment process* is owned by `DEPLOYMENT.md`; this doc owns the *gates*.

## Build / config

- [x] Production configuration builds (Release simulator) — verified 2026-07-17 with `CODE_SIGNING_ALLOWED=NO`
- [~] Signing for device/TestFlight — `project.yml` stays `CODE_SIGNING_ALLOWED: NO` by decision (DEC-005/JAPA-9); distribution signing is injected at archive time by the CD pipeline (team `796XH483R4`). Not yet exercised end-to-end (needs App Store Connect secrets).
- [x] `xcodegen generate` from `project.yml` keeps project consistent — verified 2026-07-17, regenerated cleanly, exit 0
- [x] Fake / UITest-only data paths excluded from production — `JapaApp.swift` only substitutes an ephemeral/fixed-directory `Persistence` when `JAPA_UITEST*` env vars are set

## Quality

- [x] Required automated tests pass — 62/62 (52 unit/flow + 10 UI), all passing; current canonical count per `TEST_PLAN.md` (earlier 53/56 counts superseded)
- [x] Persistence relaunch verified — `PersistenceTests` + `FeatureAuditUITests.testResumeAfterInterruptionRestoresExactBead` (real background+terminate+relaunch)
- [x] No network / no analytics / PrivacyInfo truthful — source-grep audit found no networking code; `PrivacyInfo.xcprivacy` declares no tracking/collection
- [x] No streak / notification surfaces — structurally asserted by `PracticeFlowTests.testModelsHaveNoStreakOrChainConcept`; no notification permission triggered anywhere in source

## Launch gates (from LAUNCH_READINESS)

- [ ] Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`; JAPA-6)
- [x] On-device haptic validation — verified on physical iPhone 16 Pro Max 2026-07-18 (tick + distinct completion + fallback path); closes JAPA-7. Evidence: `quality/evidence/2026-07-18-device-validation-iphone16promax.md`. (Single hardware class; additional classes optional.)
- [ ] Accessibility validation (VoiceOver/reduce motion coded but unvalidated with users; Dynamic Type implemented and smoke-tested; JAPA-8)
- [ ] App Store metadata, screenshots, support URL, age rating (JAPA-9)
- [ ] TestFlight crash-free E2E on device — CD pipeline committed (`DEPLOYMENT.md`); needs secrets + first real upload before this can be checked (JAPA-9)

## Deployment automation

- [x] TestFlight pipeline committed — `fastlane/Fastfile` (`beta` lane), `.github/workflows/release-testflight.yml`, `Gemfile`; Ruby/YAML syntax validated 2026-07-18 (DEC-005)
- [x] Signing kept out of `project.yml` — injected at archive time only; simulator CI (`ios-ci.yml`) unaffected
- [ ] App Store Connect secrets configured (`ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT`, `DEVELOPMENT_TEAM`)
- [ ] First real TestFlight upload verified and recorded under `quality/evidence/` (flip `DEPLOYMENT.md`'s end-to-end row to `verified`)

## Factory

- [x] Registered as existing project (standard 0.4.0, upgraded from 0.2.0 on 2026-07-17 — DEC-004)
- [x] Feature contracts for highest-risk workflows (FEAT-001 extended 2026-07-17 with completion-signaling requirements)
- [x] Completion evidence recorded under `quality/evidence/` — see `quality/evidence/2026-07-17-change-mala-dynamic-type-ci.md`
