---
id: DOC-STATUS
canonicalFor: current-status
status: active
lastVerified: 2026-07-18
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

Product lifecycle (per `iOS_app_factory_rules/governance/PROJECT_LIFECYCLE.md`
controlled vocabulary): **`verified`** — automated suite green and on-device
validated, with open `human_review_required` gates before `released`. Not
`done`: the standard reserves `done` for when all human gates or an approved
waiver exist (JAPA-6/8 open). Next state is `beta` once a TestFlight build is
distributed.

Factory registration is a separate axis and is **complete** (`projectType:
existing`, standard `0.4.0`); it is no longer an in-flight "onboarding" state.

## Current objective

Close the remaining launch gates for the existing Japa codebase under App Factory standard 0.4.0: content sign-off, on-device haptic validation, VoiceOver/accessibility user validation, signing/TestFlight, and App Store evidence.

## Product maturity

- **Implementation:** v1 feature set built and on-device validated (2026-07-18, iPhone 16 Pro Max); mala-style picker, Dynamic Type, merged practice surface, stale-round Finish, CI, and TestFlight deployment automation in place
- **Factory registration:** existing project, standard `0.4.0` (upgraded from `0.2.0` on 2026-07-17), registered 2026-07-16
- **Ship blockers remaining (human gates):** seed-mantra content sign-off (JAPA-6), VoiceOver user validation (JAPA-8), App Store metadata + first real signed TestFlight upload (JAPA-9). Deployment *automation* now exists (`docs/DEPLOYMENT.md`); it needs App Store Connect secrets + one verified run.

## Verified

- App Factory registration files present and verified (`verify-project-registration.sh`)
- Local-first, no networking, no third-party SDKs (source inventory)
- **Current automated suite: 62 tests (52 unit/flow + 10 UI), all passing** — canonical count; see `TEST_PLAN.md`
- XcodeGen `project.yml` is source of truth for targets
- **On-device validated on a physical iPhone 16 Pro Max (2026-07-18):** signed dev build installed and run; eyes-free haptics (tick + distinct completion), full round flow, and all 21 animated mala styles confirmed working on hardware by the accountable human. Closes JAPA-7 and JAPA-12. Evidence: `quality/evidence/2026-07-18-device-validation-iphone16promax.md`.
- TestFlight deployment pipeline committed (`fastlane/` + `release-testflight.yml`); Ruby/YAML syntax validated. End-to-end upload is `unverified` pending App Store Connect secrets — see `docs/DEPLOYMENT.md`.

### Test-count history (superseded — do not treat as current)

- 2026-07-16: baseline `xcodebuild test` on iPhone 17 (OS 26.5) exited 0.
- 2026-07-17: 53/53 on iPhone 17 Pro (registration-upgrade pass).
- 2026-07-17: 56/56 (47 unit/flow + 9 UI) after mala-style + Dynamic Type + CI; compact-phone text-size smoke on iPhone 17e.
- 2026-07-17/18: grew to the current 62 (52 unit/flow + 10 UI) after the merged-surface, animation, red-final-bead, and stale-round-Finish work.

## Verification pending

- VoiceOver validation with a real assistive-tech user on device (Dynamic Type portion is implemented + smoke-tested; JAPA-8)
- Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`; JAPA-6)
- First real TestFlight upload (JAPA-9): automation is committed (`docs/DEPLOYMENT.md`, DEC-005) but needs the four App Store Connect secrets and one verified run recorded under `quality/evidence/`. `project.yml` signing stays as-is by decision (JAPA-9); signing is injected at archive time only.

## External trackers

- **Notion Projects:** updated to MVP Ready, reviewed 2026-07-17 — [Japa](https://app.notion.com/p/38eab1f2276581d1aa80e3b10432820c)
- **Notion Tasks:** JAP-004 Done; JAP-005 Ready; JAP-010 Done; JAP-011..014 Ready; JAP-015 Done (re-checked/updated 2026-07-17)
- **Jira (canonical): project `JAPA`** — consolidated 2026-07-17 after discovering it pre-dated the `JALA` project (JALA was retired as Deferred/Replaced-By; mapping in `docs/JIRA_SYNC_PENDING.md`). Current JAPA state: [JAPA-1](https://priyanshchordia-1779372280524.atlassian.net/browse/JAPA-1) epic In Progress; JAPA-2/3 In Review; JAPA-4 In Progress; JAPA-5 Done; JAPA-10, JAPA-11 Done (2026-07-17); **JAPA-7 (device haptics) and JAPA-12 (device smoke) Done 2026-07-18 with on-device evidence**. Remaining open launch gates: JAPA-6 (content sign-off), JAPA-8 (VoiceOver human validation — Dynamic Type done), JAPA-9 (signing / App Store / TestFlight).

## Blockers

- Seed mantra content review unsigned (App Store blocker for spiritual content) (tracked: JAPA-6)
- TestFlight/App Store distribution not yet exercised: `project.yml` stays `CODE_SIGNING_ALLOWED: NO` by decision (DEC-005/JAPA-9); the CD pipeline injects signing at archive time but needs App Store Connect secrets and one verified run (tracked: JAPA-9; process in `docs/DEPLOYMENT.md`)
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

## Documentation reconciliation (2026-07-18)

- Reconciled docs to the App Factory standard (`iOS_app_factory_rules` @ 0.4.0, verified equal to the local lock):
  - Lifecycle field now uses the controlled `PROJECT_LIFECYCLE.md` vocabulary: product state is `verified` (was `onboarding_existing`, a registration mode) in `STATUS.md` and `.factory/project-context.json`. Clarified the app is not `done` while human gates are open.
  - Removed the in-doc test-count contradiction (a "47+9" summary line alongside "62"); current canonical count (62) now leads and older counts are marked superseded history.
  - `lastVerified` metadata advanced 2026-07-17 → 2026-07-18 across the docs whose current truth changed.
- Added the TestFlight deployment pipeline (DEC-005): `fastlane/` + `.github/workflows/release-testflight.yml`, canonical process doc `docs/DEPLOYMENT.md`, wired into `.factory/repository-map.json`. `project.yml` signing unchanged; simulator CI unaffected.

## Documentation reconciliation (2026-07-19)

- **Studio OS enrollment.** Linked this repo to Studio OS product `PROD-JAPA`
  (`pri8771/studio-ios`): product-side pointer `.factory/studio-link.json`,
  authoritative `products/japa/` record proposed via studio-ios PR. Registered in
  `.factory/repository-map.json` (`studioLink`, `studio-os-linkage` route).
- **Automated UI-testing foundation.** Added `quality/ui/{screens,journeys,safe-actions}.yaml`
  + generated Maestro flows (`quality/ui/generated/`) per App Factory standard
  0.4.0. `Japa/JapaApp.swift` now honors the standard `UI_TEST_MODE`/`UI_FIXTURE`/
  `UI_RESET_STATE`/`UI_DISABLE_ANIMATIONS` contract alongside the original
  `JAPA_UITEST` hooks; added one `historyRoot` accessibility identifier and a
  contract test. Maestro simulator execution is pending (CLI unavailable at
  enrollment; tracked in the Studio OS Atlas task ATLAS-JAPA-LAUNCH-001).
- **Test count.** Canonical automated suite is now **64 (53 unit/flow + 11 UI)**
  after adding a `Preferences` unknown-mala-style regression test and the
  `UI_TEST_MODE` contract test; verified green on iOS simulator 2026-07-19. The
  "62 (52 + 10)" figure elsewhere in this doc is prior history.

## Next action

1. Close launch gates: content sign-off (JAPA-6), VoiceOver user validation (JAPA-8).
2. Configure the four App Store Connect secrets and run the TestFlight workflow once; record evidence and flip `docs/DEPLOYMENT.md`'s end-to-end row to `verified` (JAPA-9).
3. Decide whether to add the spy-based haptic/tone tests FEAT-001 calls for.
