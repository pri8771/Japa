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

- [ ] Production configuration builds (Release) — only Debug has been built/tested so far
- [ ] Signing enabled for device/TestFlight with real Development Team (B-SIGN)
- [x] `xcodegen generate` from `project.yml` keeps project consistent — verified 2026-07-17, regenerated cleanly, exit 0
- [x] Fake / UITest-only data paths excluded from production — `JapaApp.swift` only substitutes an ephemeral/fixed-directory `Persistence` when `JAPA_UITEST*` env vars are set

## Quality

- [x] Required automated unit/flow tests pass — 47/47 passed on iPhone 17 Pro, iOS 26.5, 2026-07-17 after the mala-style change. Baseline full UI suite passed 53/53 earlier on 2026-07-17; latest full UI rerun is pending after Simulator runner kills, with focused Settings/History UI smoke passing.
- [x] Persistence relaunch verified — `PersistenceTests` + `FeatureAuditUITests.testResumeAfterInterruptionRestoresExactBead` (real background+terminate+relaunch)
- [x] No network / no analytics / PrivacyInfo truthful — source-grep audit found no networking code; `PrivacyInfo.xcprivacy` declares no tracking/collection
- [x] No streak / notification surfaces — structurally asserted by `PracticeFlowTests.testModelsHaveNoStreakOrChainConcept`; no notification permission triggered anywhere in source

## Launch gates (from LAUNCH_READINESS)

- [ ] Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`)
- [ ] On-device haptic validation (≥2 iPhone classes + fallback)
- [ ] Accessibility validation (VoiceOver, reduce motion coded but unvalidated; **Dynamic Type not yet implemented** — corrected 2026-07-17)
- [ ] App Store metadata, screenshots, support URL, age rating
- [ ] TestFlight crash-free E2E on device

## Factory

- [x] Registered as existing project (standard 0.4.0, upgraded from 0.2.0 on 2026-07-17 — DEC-004)
- [x] Feature contracts for highest-risk workflows (FEAT-001 extended 2026-07-17 with completion-signaling requirements)
- [ ] Completion evidence recorded under `quality/evidence/` — only the template `README.md` exists there, no real evidence artifacts yet
