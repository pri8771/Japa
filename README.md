# Mala

A quiet, local-first **digital mala** for daily mantra repetition (*japa*) on iOS.

> **Status: v1 built and device-validated.** The app is built and running: a tested
> repetition engine, the eyes-free
> haptic practice screen, a distinct completion signal, neutral Counting plus private custom labels, quiet history, settings, Dynamic Type support, CI + TestFlight deployment automation, and a 21-style Change Mala picker — all local-first. Current
> status, test counts, and readiness live in [`docs/STATUS.md`](docs/STATUS.md) and [`docs/TEST_PLAN.md`](docs/TEST_PLAN.md). Remaining
> work is the follow-up TestFlight upload, human approval/upload of App Store metadata and screenshots, and release-candidate QA
> (see [`LAUNCH_READINESS.md`](LAUNCH_READINESS.md) §9 and [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md)).

## What it is

Mala is for anyone with a daily repetition practice who wants to count a fixed
number of mantras (classically 108) **without looking at the screen**. The one
thing it does that a physical mala or a generic counter cannot:

- **Eyes-free** — advance bead-by-bead by feel; a crisp haptic confirms each one.
- **Interruption-safe** — a call or putting the phone down mid-round keeps your exact place.
- **Unmistakable end-of-round signal** — the target bead (108th/chosen) fires a *distinct* completion haptic + gentle tone, so you know your round is done without looking.

If it can't deliver that eyes-free, look-down-free feel, it's a skinned counter and shouldn't ship. That gate drives the whole scope.

## v1 scope (and non-goals)

**In:** repetition engine, eyes-free tactile practice screen, distinct completion haptic + tone, neutral Counting plus private user-created labels, session completion, simple quiet history, and 21 visual mala styles with Classic as the default. Local-first; no backend, accounts, or analytics.

**Out (v1):** streaks / loss-aversion mechanics, reminders/notifications, audio/chanting, content library, sync, IAP. (Streaks and reminders are deliberately excluded — gamifying a devotional practice is a tone failure.)

## Build & run

The Xcode project is generated from `project.yml` with [XcodeGen](https://github.com/yonyz/XcodeGen).

```bash
brew install xcodegen          # if you don't have it
xcodegen generate              # regenerates Japa.xcodeproj from project.yml
open Japa.xcodeproj            # build & run the "Japa" scheme (iOS 17+)
```

From the command line:

```bash
# Build
xcodebuild build -scheme Japa -destination 'platform=iOS Simulator,name=iPhone 17'
# Test (full suite; current counts in docs/TEST_PLAN.md)
xcodebuild test  -scheme Japa -destination 'platform=iOS Simulator,name=iPhone 17'
```

> Per-bead haptics and the distinct completion pattern require a physical device
> (the Simulator has no Taptic Engine). The logic is fully unit-tested; haptic
> *feel* must be validated on device — see `LAUNCH_READINESS.md`.

## Project layout

```
Japa/
  Engine/        JapaEngine (pure, frozen contract) + AdvanceResult
  Models/        Mantra, MalaStyle, PracticeSession, Preferences, ActiveSessionState
  Persistence/   Codable-to-disk store + interruption-safe ActiveSessionStore
  Haptics/       CoreHaptics player (+ UIFeedbackGenerator fallback)
  Audio/         synthesized gentle completion tone (respects silent switch)
  Content/       neutral built-in Counting option
  ViewModels/    AppModel, PracticeController
  Views/         Home, Practice, Completion, MantraSelect, History, Settings, MalaStylePicker, Intro
  Design/        Theme + native mala-style renderers
  Resources/     Assets.xcassets (app icon, accent), PrivacyInfo.xcprivacy
JapaTests/       engine, persistence, and end-to-end flow tests
JapaUITests/     core-flow UI tests (advance, undo, completion, navigation, Dynamic Type smoke)
```

## Architecture notes

- **Engine first.** `JapaEngine` is a pure value type with the frozen v1 contract: stop-at-target, completion fires exactly once, post-completion `advance()` is `.alreadyComplete`, explicit new round, input-agnostic `advance()`. It's the differentiator, so it's built and tested before any UI.
- **Haptics off the storage path.** The practice loop advances in memory and fires the haptic *first*, then persists asynchronously (`ActiveSessionStore`), with a resign-active flush as the backstop — storage latency never shapes the tap rhythm, and the place survives force-quit.
- **Local-first.** Everything is JSON in the app sandbox. No network, no accounts, no analytics — declared truthfully in `PrivacyInfo.xcprivacy`.

## Documents

- **[`docs/GOVERNANCE.md`](docs/GOVERNANCE.md)** — source-of-truth policy and repository-to-tracker synchronization rules.
- **[`LAUNCH_READINESS.md`](LAUNCH_READINESS.md)** — authoritative spec: scope, MVP features + acceptance criteria, flows, risk triage, readiness assessment, launch checklist.
- **[`docs/PROJECT_DOCUMENTATION.md`](docs/PROJECT_DOCUMENTATION.md)** — canonical project documentation (indexed by the App Factory Command Center).
- **[`docs/CONTENT_REVIEW.md`](docs/CONTENT_REVIEW.md)** — superseded historical seed-content review record.

Tech baseline: SwiftUI, CoreHaptics (with `UIFeedbackGenerator` fallback), minimal AVFoundation, Codable local storage. Target iOS 17+.
