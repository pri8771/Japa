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

Complete App Factory onboarding for the existing Japa codebase: document baseline architecture/features/risks, align platform registration with iPhone-only product scope, create high-risk feature contracts, and sync Notion/Jira.

## Product maturity

- **Implementation:** v1 feature set built (~85% production-ready per `LAUNCH_READINESS.md`)
- **Factory registration:** existing project, standard `0.4.0` (upgraded from `0.2.0` on 2026-07-17), registered 2026-07-16
- **Ship blockers remaining:** content sign-off, on-device haptic validation, accessibility validation, App Store prep / signing for device builds

## Verified

- App Factory registration files present and verified (`verify-project-registration.sh`)
- Local-first, no networking, no third-party SDKs (source inventory)
- Automated suite exists: 46 unit/flow + 7 UI tests in source
- XcodeGen `project.yml` is source of truth for targets
- Baseline `xcodebuild test` on iPhone 17 (OS 26.5) exited 0 (2026-07-16)
- Re-verified `xcodebuild build` and `xcodebuild test` on iPhone 17 Pro (OS 26.5): build succeeded, 53/53 tests passed, 0 failures (2026-07-17, App Factory registration-upgrade pass)

## Verification pending

- On-device haptic feel across ≥2 iPhone classes
- Accessibility validation with VoiceOver / Dynamic Type users
- Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`)
- Jira issue sync (`docs/JIRA_SYNC_PENDING.md` — Atlassian MCP auth required)

## External trackers

- **Notion Projects:** updated to MVP Ready (2026-07-16) — [Japa](https://app.notion.com/p/38eab1f2276581d1aa80e3b10432820c)
- **Notion Tasks:** JAP-010 Done; JAP-011..015 created; JAP-004 Done; JAP-005 Ready
- **Jira:** not synced — pending auth (see `docs/JIRA_SYNC_PENDING.md`)

## Blockers

- `CODE_SIGNING_ALLOWED: NO` and empty `DEVELOPMENT_TEAM` in `project.yml` block device/TestFlight evidence until release signing is enabled
- Seed mantra content review unsigned (App Store blocker for spiritual content)
- Atlassian MCP auth incomplete — cannot create Jira issues yet

## Documentation reconciliation (2026-07-17)

- App Factory registration upgraded 0.2.0 → 0.4.0; repository-map.json, library-catalog.json, docs/README.md, docs/REUSABLE_COMPONENTS.md created; verify-project-registration.sh passes clean
- Stale test-count claims (41+3) corrected to the actual 46+7=53 across README.md, docs/PROJECT_DOCUMENTATION.md, LAUNCH_READINESS.md (B-DOC resolved)
- docs/RELEASE_CHECKLIST.md reconciled against verified evidence (was an unstarted template despite several items being done)
- BUGS.md B-A11Y corrected: Dynamic Type is not implemented, not just unvalidated; new O5/signing-blocker row added to LAUNCH_READINESS.md §7/§9
- FEAT-001 extended with explicit completion-signal-distinctness requirements; verification gap (no spy-based test) documented rather than silently left implied-covered

## Next action

1. Complete Atlassian auth and sync `docs/JIRA_SYNC_PENDING.md` (Jira project confirmed as **Jala**; still blocked on connector auth).
2. Close launch gates: content, device haptics, a11y (incl. implementing Dynamic Type), signing/TestFlight.
3. Decide whether to add the spy-based haptic/tone tests FEAT-001 now calls for.
