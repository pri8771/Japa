---
id: DOC-STATUS
canonicalFor: current-status
status: active
lastVerified: 2026-07-27
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
validated, with external release gates before `released`. VoiceOver user
validation is an explicitly accepted post-v1 risk, not a completed check. Next
state is `beta` once a signed TestFlight build is distributed.

Factory registration is a separate axis and is **complete** (`projectType:
existing`, standard `0.4.0`); it is no longer an in-flight "onboarding" state.

## Current objective

Prepare Mala v1 for App Store release: publish the privacy/support pages, approve and upload the captured screenshots, verify signing/TestFlight, and complete App Store Connect metadata and device QA.

## Product maturity

- **Implementation:** v1 feature set built and on-device validated (2026-07-18, iPhone 16 Pro Max); mala-style picker, Dynamic Type, merged practice surface, stale-round Finish, CI, and TestFlight deployment automation in place
- **Factory registration:** existing project, standard `0.4.0` (upgraded from `0.2.0` on 2026-07-17), registered 2026-07-16
- **Ship blockers remaining:** live privacy/support URLs, human approval/upload of the captured App Store assets and metadata, and the first real signed TestFlight upload. VoiceOver user validation is deferred post-v1 with residual risk recorded in MALA-7.

## Verified

- App Factory registration files present and verified (`verify-project-registration.sh`)
- Local-first, no networking, no third-party SDKs (source inventory)
- **Current automated suite: 62 tests (52 unit/flow + 10 UI), all passing** — canonical count; see `TEST_PLAN.md`
- XcodeGen `project.yml` is source of truth for targets
- **On-device validated on a physical iPhone 16 Pro Max (2026-07-18):** signed dev build installed and run; eyes-free haptics (tick + distinct completion), full round flow, and all 21 animated mala styles confirmed working on hardware by the accountable human. Closes JAPA-7 and JAPA-12. Evidence: `quality/evidence/2026-07-18-device-validation-iphone16promax.md`.
- Public product identity is **Mala**. The internal Xcode target/scheme, bundle ID, engine symbols, and persistence path retain `Japa` for compatibility.
- Bundled spiritual seed content was removed; v1 ships neutral Counting plus private user-created labels.
- Five App Store screenshots were captured from the iPhone 17 Pro Max simulator at 1320 × 2868 with no alpha and stored under `AppStoreAssets/Screenshots/en-US/6.9-inch/`.
- A 6.9-inch UI-test run exposed top-chrome taps being intercepted by the practice gesture; the counting hit area now excludes the control bands and the history flow passes.
- TestFlight deployment pipeline committed (`fastlane/` + `release-testflight.yml`); Ruby/YAML syntax validated. End-to-end upload is `unverified` pending App Store Connect secrets — see `docs/DEPLOYMENT.md`.
- Enrolled in Studio OS as `PROD-JAPA` (`pri8771/studio-ios`, 2026-07-19); `.factory/studio-link.json` is the product-side pointer. Automated-UI-testing manifests (`quality/ui/`) and generated Maestro flows were added the same day; Maestro simulator execution is still pending (CLI unavailable at enrollment time).
- `Gemfile.lock` is committed (regenerated via `bundle install` 2026-07-27) so the TestFlight CD workflow's `ruby/setup-ruby@v1` `bundler-cache: true` step no longer hard-fails before it can run.

### Test-count history (superseded — do not treat as current)

- 2026-07-16: baseline `xcodebuild test` on iPhone 17 (OS 26.5) exited 0.
- 2026-07-17: 53/53 on iPhone 17 Pro (registration-upgrade pass).
- 2026-07-17: 56/56 (47 unit/flow + 9 UI) after mala-style + Dynamic Type + CI; compact-phone text-size smoke on iPhone 17e.
- 2026-07-17/18: grew to the current 62 (52 unit/flow + 10 UI) after the merged-surface, animation, red-final-bead, and stale-round-Finish work.

## Verification pending

- Public privacy and support pages at `priyanshchordia.com/mala/privacy` and `/mala/support`
- Human approval/upload of the captured App Store screenshots and App Store Connect metadata
- First real TestFlight upload (MALA-8): automation is committed but needs credentials, corrected CI signing setup, and one verified run under `quality/evidence/`
- VoiceOver validation with a real assistive-tech user is deferred post-v1 (MALA-7); Dynamic Type remains implemented and smoke-tested

## External trackers

- **Notion:** [Mala Release Hub](https://app.notion.com/p/3a8ab1f22765811fb3cbcdbf485af251) with Work Items, Research & Design, Decisions, Lessons & Mistakes, and Release Evidence databases
- **Jira (canonical): project `MALA`** — MALA-1 is the v1 release epic; implementation, research, design, QA, and human gates are split into independently assignable work items with Execution Agent values

## Blockers

- Privacy and support URLs are not live yet (MALA-4/15)
- TestFlight/App Store distribution has not been exercised; CI signing needs a verified signing identity/configuration plus secrets (MALA-8)
- App Store Connect record, screenshot approval/upload, rating/privacy answers, and release-candidate device QA remain open (MALA-5/6/9)

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
- **Test count (superseded by the 2026-07-27 merge below).** Suite was **64
  (53 unit/flow + 11 UI)** on this branch of history, after adding a
  `Preferences` unknown-mala-style regression test and the `UI_TEST_MODE`
  contract test; verified green on iOS simulator 2026-07-19.

## Documentation reconciliation (2026-07-27, branch merge)

- Merged local branch `agent/fix-app-icon` (Mala rebrand, seed-content removal,
  App Store screenshot assets, chrome hit-testing fix, tag-driven Fastfile
  marketing version) with `origin/main` (Studio OS enrollment, Maestro
  UI-testing manifests) to unblock release — the two branches had diverged
  from a common ancestor and neither included the other's work. All
  non-conflicting additions from both sides are preserved; true conflicts were
  resolved file-by-file favoring whichever side reflected the more current,
  accurate state (see `docs/HANDOFF.md`).
- Added a real `Gemfile.lock` (via `bundle install`) so `release-testflight.yml`'s
  `ruby/setup-ruby@v1` `bundler-cache: true` step no longer hard-fails before
  reaching the (still-unconfigured) signing step.
- Post-merge canonical test count and full-suite/build verification are
  recorded once re-run; see the top of this document and `TEST_PLAN.md`.

## Next action

1. Publish and verify the public privacy/support pages.
2. Complete and verify CI signing, then upload the first TestFlight build (MALA-8).
3. Run release-candidate device QA and finalize App Store Connect fields/assets.
4. Decide whether to pursue Maestro simulator execution for the `quality/ui/` manifests now that the CLI can be installed.
