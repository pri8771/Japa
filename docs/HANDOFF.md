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
- v1 implementation present (~85% production-ready)
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

Device haptic + content + a11y launch gates, then signed TestFlight/device verification. Baseline simulator tests passed 53/53 on 2026-07-17 before the mala-style change; latest mala-style verification passed 47/47 unit+flow and a focused Settings/History UI smoke, with full UI-suite rerun still pending because the Simulator runner was repeatedly killed.
