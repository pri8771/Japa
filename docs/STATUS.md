---
id: DOC-STATUS
canonicalFor: current-status
status: active
lastVerified: 2026-07-17
readWhen:
  - onboarding
  - checking current progress or blockers
related:
  - DECISIONS.md
  - BUGS.md
  - TEST_PLAN.md
supersedes: []
---

# Project Status

## Lifecycle status

`onboarding_existing`

## Current objective

Close the remaining launch gates for the existing Japa codebase under App Factory standard 0.4.0: content sign-off, on-device haptic validation, Dynamic Type/accessibility, signing/TestFlight, and completion evidence.

## Product maturity

- **Implementation:** v1 feature set built (~86% production-ready per `LAUNCH_READINESS.md`; mala-style picker implemented 2026-07-17)
- **Factory registration:** existing project, standard `0.4.0` (upgraded from `0.2.0` on 2026-07-17), registered 2026-07-16
- **Ship blockers remaining:** content sign-off, on-device haptic validation, accessibility validation, App Store prep / signing for device builds

## Verified

- App Factory registration files present and verified (`verify-project-registration.sh`)
- Local-first, no networking, no third-party SDKs (source inventory)
- Automated suite exists: 47 unit/flow + 7 UI tests in source
- XcodeGen `project.yml` is source of truth for targets
- Baseline `xcodebuild test` on iPhone 17 (OS 26.5) exited 0 (2026-07-16)
- Re-verified `xcodebuild build` and `xcodebuild test` on iPhone 17 Pro (OS 26.5): build succeeded, 53/53 tests passed, 0 failures (2026-07-17, App Factory registration-upgrade pass)
- Re-verified mala-style implementation on iPhone 17 Pro (OS 26.5): `xcodegen generate`, `xcodebuild build`, `xcodebuild -only-testing:JapaTests test` (47/47 unit+flow passed), and focused UI smoke `JapaUITests/JapaUITests/testNavigateSettingsAndHistory` passed. Full UI suite was attempted but not cleanly verified because the Simulator test runner was repeatedly killed before several tests established a session.

## Verification pending

- On-device haptic feel across ≥2 iPhone classes
- Accessibility validation with VoiceOver / Dynamic Type users
- Full UI suite re-run after Simulator runner instability observed during the 2026-07-17 mala-style verification attempt
- Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`)
- Jira connector re-verification from this session (`docs/JIRA_SYNC_PENDING.md` records synced JALA keys, but Atlassian Rovo currently requires reauthentication before live reads/updates)

## External trackers

- **Notion Projects:** updated to MVP Ready, reviewed 2026-07-17 — [Japa](https://app.notion.com/p/38eab1f2276581d1aa80e3b10432820c)
- **Notion Tasks:** JAP-004 Done; JAP-005 Ready; JAP-010 Done; JAP-011..014 Ready; JAP-015 Done (re-checked/updated 2026-07-17)
- **Jira:** recorded as synced 2026-07-17 — project `JALA`: [JALA-1](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-1) (Epic) with [JALA-2](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-2)..[JALA-5](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-5) (launch-gate stories) and [JALA-6](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-6) (sync task, Done) — see `docs/JIRA_SYNC_PENDING.md`. Live Jira re-verification/update could not run in this session because Atlassian Rovo returned `UNAUTHORIZED` / reauthentication required.

## Blockers

- `CODE_SIGNING_ALLOWED: NO` and empty `DEVELOPMENT_TEAM` in `project.yml` block device/TestFlight evidence until release signing is enabled (tracked: JALA-5)
- Seed mantra content review unsigned (App Store blocker for spiritual content) (tracked: JALA-2)
- On-device haptic and accessibility validation still required (tracked: JALA-3, JALA-4)

## Documentation reconciliation (2026-07-17)

- App Factory registration upgraded 0.2.0 → 0.4.0; repository-map.json, library-catalog.json, docs/README.md, docs/REUSABLE_COMPONENTS.md created; verify-project-registration.sh passes clean
- Stale test-count claims (41+3) corrected to the actual 46+7=53 across README.md, docs/PROJECT_DOCUMENTATION.md, LAUNCH_READINESS.md (B-DOC resolved)
- docs/RELEASE_CHECKLIST.md reconciled against verified evidence (was an unstarted template despite several items being done)
- BUGS.md B-A11Y corrected: Dynamic Type is not implemented, not just unvalidated; new O5/signing-blocker row added to LAUNCH_READINESS.md §7/§9
- FEAT-001 extended with explicit completion-signal-distinctness requirements; verification gap (no spy-based test) documented rather than silently left implied-covered

## Next action

1. Reauthenticate Atlassian Rovo before the next live Jira update; local docs already record the synced JALA issue keys.
2. Close launch gates: content, device haptics, a11y (incl. implementing Dynamic Type), signing/TestFlight.
3. Decide whether to add the spy-based haptic/tone tests FEAT-001 now calls for.
