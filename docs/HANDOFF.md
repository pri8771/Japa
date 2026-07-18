---
id: DOC-HANDOFF
canonicalFor: next-agent-context
status: active
lastVerified: 2026-07-17
readWhen:
  - starting work in a fresh session with no prior context
related:
  - STATUS.md
  - DECISIONS.md
supersedes: []
---

# Handoff

## What the project is

Japa is a local-first iOS digital mala for daily mantra repetition. Differentiator: eyes-free, interruption-safe, haptic-confirmed counting with a distinct end-of-round signal.

## Current state (2026-07-17)

- Registered with App Factory as **existing** (`onboarding_existing`)
- v1 implementation present (~90% production-ready)
- Platforms: **iOS / iPhone only** (DEC-003)
- Standard lock: `pri8771/iOS_app_factory_rules` @ `0.4.0` (upgraded from `0.2.0` on 2026-07-17 — DEC-004)
- Notion project/tasks are aligned; Jira keys JALA-1..JALA-6 are recorded, but the Atlassian connector currently requires reauthentication for live updates.

## Read first

1. `.factory/repository-map.json`
2. `.factory/project-context.json`
3. `.factory/standard-lock.json`
4. `docs/README.md`
5. `docs/STATUS.md`
6. `docs/ARCHITECTURE.md`
7. `LAUNCH_READINESS.md`
8. `quality/feature-contracts/FEAT-001*.json` through `FEAT-003*.json`

## Do not

- Re-scaffold or rewrite the engine
- Add streaks, notifications, backend, or third-party SDKs
- Claim iPad support
- Mark work `done` without evidence

## Next verification

Device haptic + content + VoiceOver/accessibility launch gates, then signed TestFlight/device verification. Latest simulator verification passed 56/56 tests on iPhone 17 Pro on 2026-07-17, plus compact-phone accessibility text-size smoke on iPhone 17e.
