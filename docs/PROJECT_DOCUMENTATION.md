# Japa — Project Documentation

_Updated 2026-06-30 to match the shipped product and launch scope. See LAUNCH_READINESS.md._

> **Implementation status: v1 implemented (~85% production-ready).** The repository now contains a building, tested SwiftUI app: a pure `JapaEngine` with the frozen contract and a passing unit-test suite, the eyes-free haptic practice screen, a distinct completion haptic + synthesized gentle tone, interruption-safe local persistence, mantra selection (reviewed seed set + free-text), a quiet non-gamified history, settings, an app icon, and a truthful `PrivacyInfo.xcprivacy`. Builds in Debug and Release for iOS 17+; 41 unit/flow tests + 3 UI tests pass. The project is generated from `project.yml` via XcodeGen. Remaining to ship: human content sign-off (`docs/CONTENT_REVIEW.md`), on-device haptic tuning across iPhone classes, an accessibility pass, and App Store prep. `LAUNCH_READINESS.md` is the authoritative spec (PRD, MVP features with acceptance criteria, user flows, bug/risk triage, ordered build path, launch checklist).

GitHub is the source of truth for this project documentation. Notion indexes this file in the Priyansh App Factory Command Center.

## 00. Executive Summary
Japa is a local-first iOS app for *japa* — the repetition of a mantra a fixed number of times (classically 108, one full *mala*). The single differentiator that justifies a standalone app is **eyes-free, interruption-safe, haptic-confirmed repetition with an unmistakable end-of-round signal**: the user advances bead-by-bead without looking, each advance is confirmed by a crisp haptic, the place is preserved across interruptions, and reaching the target (the 108th/chosen bead) fires a **distinct completion haptic plus a gentle tone**. A digital mala that merely "counts to 108" is strictly worse than a physical mala and must not ship — the eyes-free, look-down-free feel is the product. The v1 end product is: one tactile practice screen, a tiny **reviewed** seed mantra set **plus** user free-text, session completion, and a simple quiet history. Local-first storage, no backend, no accounts.

## 01. Product
**v1 MVP scope (corrected):** repetition engine (count + place-keeping + distinct round-completion), eyes-free tactile practice screen, distinct end-of-round completion haptic + gentle tone, mantra selection (small reviewed seed set + user free-text), session completion, and a simple non-gamified history. Minimal preferences (target count, sound on/off, haptic intensity where supported).

**Explicitly out of v1 (corrected from prior scope):**
- **Streaks / "don't break the chain"** — removed. Devotional practice plus streak/loss-aversion pressure is a tone failure; v1 shows gentle history only, never a streak counter.
- **Reminders / push notifications** — removed from v1 (same tone risk; adds a permission/privacy surface for no core value).
- **Audio (chanting / per-bead audio)** — later expansion; v1 ships at most one gentle completion tone.

## 02. Design
Quiet, calm, abstract-tactile, devotional. Designed to be usable **eyes-closed / screen-off** — the haptic, not the visual, is the confirmation. Literal photoreal bead rendering is later polish, not v1. Screens: Home, Mantra Select, Practice, Completion, History, Settings.

## 03. Frontend Technical
Native iOS, **SwiftUI**, local-first (target iOS 17+, to be locked at scaffold time). **CoreHaptics** powers the per-bead and distinct completion haptics, with `UIFeedbackGenerator` as a graceful fallback on devices without Core Haptics. Minimal **AVFoundation** for the single completion tone. Local persistence of mantras, sessions, and preferences via SwiftData or a small `Codable`-to-disk store. **Build order: repetition engine first (with unit tests on advance / interruption-resume / round-completion / target-config), then the practice screen, then content/preferences.**

## 04. Backend Technical
No backend for v1. No accounts, no network calls, no analytics SDKs. Future (post-v1, optional) services could include an audio/content catalog or opt-in sync, but none are in v1 scope.

## 05. Business
Free core practice (the repetition loop, seed mantras, free-text, history are all free). **No in-app purchases / StoreKit in v1.** Possible future monetization (out of v1 scope): optional audio/content packs, a one-time supporter unlock, or bundling into a larger spiritual product.

## 06. Marketing
Positioning: a quiet digital mala for daily japa that you can use with your eyes closed. Channels: practice communities, simple practice demos, festival/seasonal content. Tone must stay respectful and non-gamified.

## 07. User Acquisition
Beta with real practice users and community testers. **Privacy-respecting** success signals (no analytics backend): a beta user can complete a full eyes-free round and feel the completion signal; an interrupted session resumes at the exact bead; users return to practice **without** streak/notification pressure. Explicitly *not* a metric: streak length or notification opt-in.

## 08. Execution
Done: scaffolded the app (XcodeGen + SwiftUI, iOS 17+); built and unit-tested the repetition engine first; implemented per-bead + distinct completion haptics (CoreHaptics with `UIFeedbackGenerator` fallback); built the eyes-free practice screen; added local persistence + interruption-resume (advance/haptic first, async persist, resign-active flush backstop); added mantra selection (reviewed seed + free-text); added quiet history (no streaks); added settings; ran a privacy/no-network audit and shipped `PrivacyInfo.xcprivacy`; generated an app icon. Remaining: human content sign-off; on-device haptic-feel validation across iPhone classes; accessibility pass with VoiceOver users; App Store prep + TestFlight. See `LAUNCH_READINESS.md` §8 for the ordered checklist and current status.

## 09. QA
Covered by automated tests (41 unit/flow + 3 UI, all passing): count increments, one-step undo/decrement with a floor at 0, pause/resume across a simulated relaunch (exact bead restored), round-completion fires exactly once at target and pins past it, honest partial-session recording, history/preferences/custom-mantra persistence, a structural assertion that no streak/chain concept exists, and the core UI flow (tap→advance, undo→decrement, completion event, navigation). Still requires manual on-device validation (cannot be automated): per-bead haptic crispness/latency, per-bead vs. completion distinctness eyes-free, haptics-in-silent-mode, eyes-closed full round, per-device fallback; plus human content review of the seed mantras. The repetition engine ships with a passing unit-test suite (the hard gate) — green.

## 10. Legal / Compliance
Document local-only data handling: all data (mantras, sessions, preferences) stays on device; nothing is collected, tracked, or sent. Ship a truthful `PrivacyInfo.xcprivacy` and App Store privacy label declaring no data collection. Seed mantra content must be human-reviewed for accuracy and respectfulness before build. No reminders/notifications and no tracking prompts in v1.

## 11. Operations
Release process: internal practice test → content review → community beta → TestFlight → App Store. Post-launch / future (out of v1): audio, literal bead visuals, widgets, broader mantra catalog, and possible Digital Temple integration.
