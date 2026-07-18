---
id: DOC-TEST-PLAN
canonicalFor: test-plan
status: active
lastVerified: 2026-07-17
readWhen:
  - running or changing tests
  - preparing a release
related:
  - RELEASE_CHECKLIST.md
  - ../quality/quality-manifest.json
supersedes: []
---

# Test Plan

## Required suites

| Suite | Status | Location |
|-------|--------|----------|
| Unit | present | `JapaTests/JapaEngineTests.swift`, `PersistenceTests.swift` |
| Integration / flow | present | `JapaTests/PracticeFlowTests.swift` |
| UI smoke | present | `JapaUITests/JapaUITests.swift`, `FeatureAuditUITests.swift` |

## Coverage summary (source inventory 2026-07-16)

- **47** unit/flow tests
- **7** UI tests
- Engine: advance, completion-once, undo floor, boundaries, reconstruct from count
- Persistence: prefs/sessions/active-session round-trip + flush
- Practice flow: resume across relaunch, honest partials, no streak fields
- UI: advance/undo/complete, settings/history, resume after terminate, mantra custom, history delete

## Not automatable (device-only)

- Haptic crispness / latency / distinctness
- Silent-mode haptics behavior
- Full eyes-closed round feel
- Hardware without Core Haptics fallback quality

## Baseline checks for this onboarding

- [x] `xcodebuild -scheme Japa -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.5' test` — exit 0 on 2026-07-16 (~380s; DebuggerLLDB version-store warnings observed, non-blocking)
- [x] Source inventory of tests and modules
- [x] Registration verify script
- [x] Re-verified 2026-07-17 (registration-upgrade pass): `xcodegen generate`, `xcodebuild build`, and `xcodebuild test` on iPhone 17 Pro (OS 26.5) — build succeeded, 53/53 tests passed (0 failures), confirming the then-current 46+7 count
- [x] Re-verified 2026-07-17 (mala-style implementation): `xcodegen generate`; `xcodebuild build`; `xcodebuild -only-testing:JapaTests test` on iPhone 17 Pro (OS 26.5) — 47/47 unit+flow tests passed; focused UI smoke `JapaUITests/JapaUITests/testNavigateSettingsAndHistory` passed. Full UI suite was attempted but the Simulator test runner was repeatedly killed before several tests established a session, so the full UI suite remains unverified for this change.

## Quality manifest alignment

`quality/quality-manifest.json` requires accessibility, dark mode, persistence relaunch tests, fake-data isolation, and completion evidence. UITests isolate via `JAPA_UITEST*` env; persistence relaunch covered in flow + FeatureAudit UI tests. Accessibility remains **verification pending** (code present, user validation not done). Responsive layout tests are **not** a v1 iPad requirement after DEC-003 (iPhone only).
