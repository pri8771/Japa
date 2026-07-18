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

Close the remaining launch gates for the existing Japa codebase under App Factory standard 0.4.0: content sign-off, on-device haptic validation, VoiceOver/accessibility user validation, signing/TestFlight, and App Store evidence.

## Product maturity

- **Implementation:** v1 feature set built (~90% production-ready per `LAUNCH_READINESS.md`; mala-style picker, Dynamic Type, CI, and completion evidence updated 2026-07-17)
- **Factory registration:** existing project, standard `0.4.0` (upgraded from `0.2.0` on 2026-07-17), registered 2026-07-16
- **Ship blockers remaining:** content sign-off, on-device haptic validation, VoiceOver/accessibility user validation, App Store prep / signing for device builds

## Verified

- App Factory registration files present and verified (`verify-project-registration.sh`)
- Local-first, no networking, no third-party SDKs (source inventory)
- Automated suite exists: 47 unit/flow + 9 UI tests in source
- XcodeGen `project.yml` is source of truth for targets
- Baseline `xcodebuild test` on iPhone 17 (OS 26.5) exited 0 (2026-07-16)
- Re-verified `xcodebuild build` and `xcodebuild test` on iPhone 17 Pro (OS 26.5): build succeeded, 53/53 tests passed, 0 failures (2026-07-17, App Factory registration-upgrade pass)
- Re-verified mala-style + Dynamic Type + CI implementation on 2026-07-17: `xcodegen generate`, Release simulator build, full `xcodebuild test` on iPhone 17 Pro (OS 26.5) passed 56/56 tests (47 unit/flow + 9 UI). Compact-phone accessibility text-size smoke passed on iPhone 17e.
- Full suite grew to **62 tests (52 unit/flow + 10 UI), all passing** after the merged-surface, animation, red-final-bead, and stale-round-Finish work (2026-07-17/18).
- **On-device validated on a physical iPhone 16 Pro Max (2026-07-18):** signed dev build installed and run; eyes-free haptics (tick + distinct completion), full round flow, and all 21 animated mala styles confirmed working on hardware by the accountable human. Closes JAPA-7 and JAPA-12. Evidence: `quality/evidence/2026-07-18-device-validation-iphone16promax.md`.

## Verification pending

- VoiceOver validation with a real assistive-tech user on device (Dynamic Type portion is implemented + smoke-tested; JAPA-8)
- Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`; JAPA-6)
- Code signing in `project.yml` + App Store / TestFlight distribution prep (JAPA-9)

## External trackers

- **Notion Projects:** updated to MVP Ready, reviewed 2026-07-17 — [Japa](https://app.notion.com/p/38eab1f2276581d1aa80e3b10432820c)
- **Notion Tasks:** JAP-004 Done; JAP-005 Ready; JAP-010 Done; JAP-011..014 Ready; JAP-015 Done (re-checked/updated 2026-07-17)
- **Jira (canonical): project `JAPA`** — consolidated 2026-07-17 after discovering it pre-dated the `JALA` project (JALA was retired as Deferred/Replaced-By; mapping in `docs/JIRA_SYNC_PENDING.md`). Current JAPA state: [JAPA-1](https://priyanshchordia-1779372280524.atlassian.net/browse/JAPA-1) epic In Progress; JAPA-2/3 In Review; JAPA-4 In Progress; JAPA-5 Done; JAPA-10, JAPA-11 Done (2026-07-17); **JAPA-7 (device haptics) and JAPA-12 (device smoke) Done 2026-07-18 with on-device evidence**. Remaining open launch gates: JAPA-6 (content sign-off), JAPA-8 (VoiceOver human validation — Dynamic Type done), JAPA-9 (signing / App Store / TestFlight).

## Blockers

- Seed mantra content review unsigned (App Store blocker for spiritual content) (tracked: JAPA-6)
- `project.yml` still ships `CODE_SIGNING_ALLOWED: NO` (device installs used a command-line override); enabling committed signing + a real team is required for TestFlight/App Store distribution (tracked: JAPA-9)
- VoiceOver human validation on device still required (tracked: JAPA-8)

## Documentation reconciliation (2026-07-17)

- App Factory registration upgraded 0.2.0 → 0.4.0; repository-map.json, library-catalog.json, docs/README.md, docs/REUSABLE_COMPONENTS.md created; verify-project-registration.sh passes clean
- Stale test-count claims (41+3) corrected to the actual 46+7=53 across README.md, docs/PROJECT_DOCUMENTATION.md, LAUNCH_READINESS.md (B-DOC resolved)
- docs/RELEASE_CHECKLIST.md reconciled against verified evidence (was an unstarted template despite several items being done)
- BUGS.md B-A11Y updated: Dynamic Type is now implemented and smoke-tested; VoiceOver/accessibility user validation remains open. New O5/signing-blocker row added to LAUNCH_READINESS.md §7/§9
- FEAT-001 extended with explicit completion-signal-distinctness requirements; verification gap (no spy-based test) documented rather than silently left implied-covered

## Documentation reconciliation (2026-07-17, later session)

- Independent design-fidelity audit of the mala style picker against the source Claude Design spec (`Japa Concepts.dc.html`); found high overall fidelity with 3 confirmed cosmetic gaps, all fixed: Sculptural Monument's rotating engraved-surface texture, Celestial's twinkling starfield, Ceramic Glaze's craquelure detail
- Verified full suite still green after fixes: 56/56 (47 unit/flow + 9 UI)
- Jira connector reauthenticated; corrected `JALA-4`'s stale "Dynamic Type not implemented" description and posted a progress comment to the `JALA-1` epic
- **Jira tracker consolidation:** discovered the pre-existing `JAPA` project (12 tickets from a 2026-06-30 Codex audit) duplicated by `JALA`; per user decision JAPA is now canonical — JALA-1..5 retired as Deferred/Replaced-By, JAPA-10/11 closed Done with evidence, JAPA-1/8 updated with current state

## Next action

1. Close launch gates: content, device haptics, VoiceOver user validation, signing/TestFlight.
2. Decide whether to add the spy-based haptic/tone tests FEAT-001 calls for.
