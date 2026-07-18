---
id: DOC-RELEASE-CHECKLIST
canonicalFor: release-readiness
status: active
lastVerified: 2026-07-17
readWhen:
  - preparing a release
related:
  - TEST_PLAN.md
  - ../LAUNCH_READINESS.md
supersedes: []
---

# Release Checklist

Reconciled 2026-07-17 against `LAUNCH_READINESS.md` §9 and a live build/test run — checkboxes below now reflect actual verified evidence, not a fresh unstarted template.

## Build / config

- [x] Production configuration builds (Release simulator) — verified 2026-07-17 with `CODE_SIGNING_ALLOWED=NO`
- [ ] Signing enabled for device/TestFlight with real Development Team (B-SIGN)
- [x] `xcodegen generate` from `project.yml` keeps project consistent — verified 2026-07-17, regenerated cleanly, exit 0
- [x] Fake / UITest-only data paths excluded from production — `JapaApp.swift` only substitutes an ephemeral/fixed-directory `Persistence` when `JAPA_UITEST*` env vars are set

## Quality

- [x] Required automated tests pass — 56/56 passed on iPhone 17 Pro, iOS 26.5, 2026-07-17 after mala-style + Dynamic Type changes (47 unit/flow + 9 UI)
- [x] Persistence relaunch verified — `PersistenceTests` + `FeatureAuditUITests.testResumeAfterInterruptionRestoresExactBead` (real background+terminate+relaunch)
- [x] No network / no analytics / PrivacyInfo truthful — source-grep audit found no networking code; `PrivacyInfo.xcprivacy` declares no tracking/collection
- [x] No streak / notification surfaces — structurally asserted by `PracticeFlowTests.testModelsHaveNoStreakOrChainConcept`; no notification permission triggered anywhere in source

## Launch gates (from LAUNCH_READINESS)

- [ ] Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`)
- [ ] On-device haptic validation (≥2 iPhone classes + fallback)
- [ ] Accessibility validation (VoiceOver/reduce motion coded but unvalidated with users; Dynamic Type implemented and smoke-tested)
- [ ] App Store metadata, screenshots, support URL, age rating
- [ ] TestFlight crash-free E2E on device

## Factory

- [x] Registered as existing project (standard 0.4.0, upgraded from 0.2.0 on 2026-07-17 — DEC-004)
- [x] Feature contracts for highest-risk workflows (FEAT-001 extended 2026-07-17 with completion-signaling requirements)
- [x] Completion evidence recorded under `quality/evidence/` — see `quality/evidence/2026-07-17-change-mala-dynamic-type-ci.md`
