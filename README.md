# Japa

A quiet, local-first **digital mala** for daily mantra repetition (*japa*) on iOS.

> **Status: pre-build (docs-only).** No app code yet. This repo currently holds the product definition and the launch-readiness spec; implementation has not started.

## What it is

Japa is for anyone with a daily repetition practice who wants to count a fixed number of mantras (classically 108) **without looking at the screen**. The one thing it does that a physical mala or a generic counter cannot:

- **Eyes-free** — advance bead-by-bead by feel; a crisp haptic confirms each one.
- **Interruption-safe** — a call or putting the phone down mid-round keeps your exact place.
- **Unmistakable end-of-round signal** — the target bead (108th/chosen) fires a *distinct* completion haptic + gentle tone, so you know your round is done without looking.

If it can't deliver that eyes-free, look-down-free feel, it's a skinned counter and shouldn't ship. That gate drives the whole scope.

## v1 scope (and non-goals)

**In:** repetition engine, eyes-free tactile practice screen, distinct completion haptic + tone, a tiny **reviewed** seed mantra set **plus** user free-text, session completion, and a simple quiet history. Local-first; no backend, accounts, or analytics.

**Out (v1):** streaks / loss-aversion mechanics, reminders/notifications, audio/chanting, literal bead rendering, content library, sync, IAP. (Streaks and reminders are deliberately excluded — gamifying a devotional practice is a tone failure.)

## Documents

- **[`LAUNCH_READINESS.md`](LAUNCH_READINESS.md)** — authoritative build-to spec: PRD/launch scope, MVP features with acceptance criteria, user flows, bug/risk triage, production-readiness assessment, and launch checklist.
- **[`docs/PROJECT_DOCUMENTATION.md`](docs/PROJECT_DOCUMENTATION.md)** — canonical project documentation (indexed by the App Factory Command Center).

## Build order (when implementation starts)

1. Repetition engine first — pure logic, **with unit tests** (advance, interruption-resume, round-completion, target-config).
2. Haptics (per-bead + distinct completion) and the practice screen.
3. Content (seed mantras + free-text), history, and preferences.

Tech baseline (planned): SwiftUI, CoreHaptics (with `UIFeedbackGenerator` fallback), minimal AVFoundation, SwiftData/local storage. Target iOS 17+.
