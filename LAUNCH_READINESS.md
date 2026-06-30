# Japa — Launch Readiness (v1)

> Japa is a local-first iOS app for *japa* — the repetition of a mantra a fixed number of times (classically 108, one full *mala*). It is for anyone with a daily repetition practice — Hindu, Buddhist, Sikh, or secular-meditative — who wants a quiet, eyes-free way to keep count without a physical bead string and without the practice becoming a noisy, gamified phone app. The core loop is a single tactile practice screen: the practitioner advances one bead at a time (tap/thumb-swipe) without looking, each advance is confirmed by a crisp haptic, and reaching the target (the 108th bead, or a chosen target) fires a **distinct completion haptic plus a gentle tone** so the round's end is unmistakable without looking at or listening hard to the device. Sessions complete and are saved to a quiet local history.
>
> **Implementation maturity: PRE-BUILD (docs-only).** The repository at this writing contains exactly two files — an empty `.gitkeep` and `docs/PROJECT_DOCUMENTATION.md` — plus this document. There is **no Xcode project, no SwiftUI app, no Swift source, no repetition engine, no tests, no content catalog, and no CI.** Every feature below is therefore *Not built* unless explicitly noted. This document is the authoritative build-to specification; the concrete build path to first running code is in §8. Verified against the repo file tree on 2026-06-30 (`find` shows only `.gitkeep` and `docs/PROJECT_DOCUMENTATION.md`) and against the product-definition thread in `pri8771/conversation` (`Japa.md`).

---

## 1. PRD / Launch Scope

### Problem & insight
A physical mala already counts beads better than any screen — so a digital mala that merely "counts to 108" is strictly worse than a string of beads and pointless to ship. The only thing software adds that a bead string cannot: **eyes-free, interruption-safe, haptic-confirmed repetition with an unmistakable end-of-round signal.** You advance without looking; the device confirms each bead through a haptic; it keeps your place if you are interrupted (a call, putting the phone down mid-round); and it marks the completion of the round (the 108th bead) with a *distinct* haptic + gentle tone so you never have to count, glance, or break concentration. If the build cannot deliver that eyes-free, look-down-free feel, it is a skinned counter and **should not ship standalone** (this is the explicit gating insight from the product thread).

### Target user
- **Primary:** Someone with an existing daily japa/mantra-repetition practice who currently uses a physical mala or a tally and wants a calmer, pocketable, eyes-free aid — not a habit-tracker, not a social app.
- **Secondary:** A newer meditator who wants a simple, low-pressure way to do a fixed number of repetitions (e.g. 108) without manual counting, and without being pushed by streaks or notifications.

### Value proposition (one sentence)
A quiet digital mala you can use with your eyes closed: advance one bead at a time, feel each repetition confirmed, and know the moment your round is complete — without ever looking at the screen.

### Positioning / category & one-sentence pitch
- **Category:** Spiritual / meditation utility (a focused single-purpose practice tool, *not* a meditation-content platform or habit tracker).
- **Pitch:** "Japa is a digital mala for daily mantra practice — eyes-free, interruption-safe, and respectfully quiet, with a distinct haptic at the 108th bead so you always know your round is done."

### Platform & tech baseline
- **Platform:** iOS, native. Target **iOS 17+** (so Swift Concurrency, SwiftData, and modern `SwiftUI` + `CoreHaptics` are available without back-compat shims). Final minimum to be locked in §8 step 1.
- **Frameworks (planned — none present yet):**
  - `SwiftUI` — UI.
  - `CoreHaptics` — the differentiator: crisp per-bead haptic and a *distinct* completion haptic. With `UIFeedbackGenerator` as a graceful fallback on devices without the Taptic Engine / Core Haptics support.
  - `AVFoundation` (minimal) — the single gentle completion tone at target. (Full audio/chanting is out of scope; see §3.)
  - `SwiftData` (or a small `Codable`-to-disk store) — local persistence of mantras, preferences, and session history.
- **No backend, no network, no accounts.** Local-first by construction.

### Business model (only what the repo supports/plans)
- **Free core practice.** The repetition loop, the seed mantra set, free-text mantras, and history are free.
- Future, *not in v1 scope*: optional audio/content packs, a one-time "supporter" unlock, or bundling into a larger spiritual product. The current docs mention these as future possibilities only; v1 ships with **no IAP, no StoreKit configuration** (see §3, §9).

### North-star / success signals (local-only / beta-observable; privacy-respecting)
Because the app is local-first with no analytics backend, success is observed through TestFlight feedback and (at most) privacy-preserving on-device counts, never personal practice content:
- **Primary:** a beta user can complete a full round (e.g. 108) **eyes-free** — phone face-down or screen off — and correctly feel the completion signal. (Qualitative: "I didn't have to look.")
- **Interruption safety:** a session interrupted mid-round (call/backgrounding) resumes at the exact bead with no loss.
- **Return practice:** users come back to do another session the next day *without* being nudged by streaks or notifications.
- Explicitly **not** a north-star: streak length, daily-active pressure, or notification opt-in rate (these are tone failures for devotional practice — see §3).

---

## 2. MVP Feature List (with acceptance criteria)

Status legend: **Built** = implemented and working in repo · **Partial** = scaffolding/some logic present · **Not built** = specified here, no code yet. Per repo reality on 2026-06-30, **all features are Not built** (pre-build repo). Acceptance criteria below are the build-to gates.

### F1. Repetition engine (count + place-keeping + round completion) — **Not built**
The pure, UI-independent core: tracks current bead within a round, current round, and configured target; advances; detects target reached; preserves place across interruption. This is the differentiator and must be built and unit-tested **first** (per build order in the product thread).
- **Given** a target of N (default 108) and a fresh session, **when** `advance()` is called k times (k < N), **then** current bead = k and "completion" has not fired.
- **Given** current bead = N−1, **when** `advance()` is called once more, **then** current bead = N, a **round-completion event** fires exactly once, and the engine is ready to start the next round (or end, per session config).
- **Given** an in-progress session, **when** the app is backgrounded/terminated and relaunched (interruption), **then** the engine restores the exact current bead and round (no off-by-one, no reset to 0).
- **Given** any target N where 1 ≤ N ≤ a sane max (e.g. 1080 = 10 malas), **when** the session runs, **then** completion fires only at N. Invalid targets (≤0) are rejected.
- **Given** a user undo/back-tap, **when** invoked, **then** current bead decrements by 1 without going below 0 and without firing completion.
- **Verifiable by:** unit tests covering advance, round-completion (fires once, at N only), interruption-resume, target-config (including boundary and invalid values), and decrement/undo. These tests are themselves a launch gate (see §8).

### F2. Eyes-free tactile practice screen — **Not built**
One screen with a single large advance target. Each advance fires a crisp haptic; the target fires the distinct completion haptic + tone. Designed to be usable with the eyes closed / screen off.
- **Given** the practice screen is open, **when** the user taps/thumb-swipes the advance target anywhere in a large hit area, **then** the bead advances and a crisp per-bead haptic fires within perceptible latency (target < ~50 ms).
- **Given** a screen reader / eyes-closed use, **when** advancing, **then** no visual confirmation is *required* to know an advance registered — the haptic is the confirmation.
- **Given** the device is in silent mode, **when** advancing, **then** per-bead **haptics still fire** (haptics are independent of the mute switch); the completion **tone** respects the silent switch (haptic completion still fires).
- **Given** a large, forgiving hit target, **when** the user taps slightly off-center or repeatedly, **then** each deliberate tap advances exactly one bead (no double-count from a single tap; debounced).
- **Given** an accidental tap is possible, **when** the user taps, **then** there is an easy single-step **undo/back** (maps to F1 decrement) reachable without precise aiming.
- **Verifiable by:** manual device test for haptic crispness/latency and eyes-free use; UI test for advance→bead-increment and undo→decrement.

### F3. Distinct end-of-round completion signal — **Not built**
The unmistakable signal that the round (108th/target bead) is complete: a **distinct completion haptic pattern** (clearly different from the per-bead tick) plus a single **gentle tone**.
- **Given** the per-bead haptic, **when** the completion haptic fires, **then** the two are **perceptibly different** (different Core Haptics pattern — e.g. tick vs. a short rising/sustained pattern) so the user can tell "round done" from "another bead" with eyes closed.
- **Given** target reached, **when** completion fires, **then** it fires **exactly once** per round (no repeat, no double-fire), accompanied by one gentle tone (subject to silent switch for the tone only).
- **Given** a device without Core Haptics support, **when** completion would fire, **then** a graceful fallback (`UINotificationFeedbackGenerator` success / strongest available) is used and the tone still plays.
- **Given** the user has muted the tone in settings (F6), **when** completion fires, **then** only the completion haptic fires.
- **Verifiable by:** manual A/B device test confirming the per-bead vs. completion haptics are distinguishable eyes-free; unit/UI test that completion event maps to exactly one signal invocation.

### F4. Mantra selection: tiny reviewed seed set **plus** user free-text — **Not built**
A small, human-reviewed set of common mantras to pick from, *plus* the ability to enter your own free text — so practice is never gated behind a content library.
- **Given** the seed set, **when** the user opens mantra selection, **then** a small list of **reviewed** mantras is shown (each with correct text/transliteration; see content sign-off in §9).
- **Given** a user with their own mantra, **when** they choose "custom" and type free text, **then** that mantra is usable for a session and saved locally for reuse.
- **Given** a custom mantra, **when** the user runs a session with it, **then** the engine/screen behave identically to a seed mantra (mantra text never affects counting logic).
- **Given** the user does not want any mantra text shown, **when** they start a session, **then** practice can proceed with a mantra selected by default or with a neutral/blank label (mantra display must not be a hard blocker to counting).
- **Verifiable by:** unit test for save/load of custom mantra; manual check that seed entries match the reviewed source-of-truth list.

### F5. Session completion + simple history — **Not built**
After a session, record it; show a quiet history list. **No streaks** (deliberate — see §3).
- **Given** a completed round/session, **when** it ends, **then** a record is saved locally with at least: mantra (or "custom"), target, count actually completed, date/time, duration.
- **Given** saved sessions, **when** the user opens history, **then** sessions are listed reverse-chronologically in a calm, non-gamified presentation (no streak counter, no "don't break the chain" framing).
- **Given** a session that was abandoned before target, **when** it ends, **then** it is recorded honestly as partial (or discarded per a clear rule) — history must not silently inflate completions.
- **Given** the user wants privacy, **when** they delete a history entry (or all history), **then** it is removed from local storage permanently.
- **Verifiable by:** unit test for session persistence and delete; manual check that no streak/loss-aversion UI exists anywhere.

### F6. Practice preferences — **Not built**
Minimal settings: target count, sound on/off, haptic intensity (where supported).
- **Given** settings, **when** the user sets a target (e.g. 108, 27, 1080), **then** subsequent sessions use that target and it persists across launches.
- **Given** settings, **when** the user toggles the completion tone off, **then** F3's tone is suppressed while the completion haptic remains.
- **Given** a device with adjustable haptics, **when** the user lowers intensity, **then** the per-bead haptic respects it; **given** a device without it, **then** the control is hidden/disabled gracefully.
- **Given** any preference, **when** changed, **then** it is stored locally and applied without requiring a restart.
- **Verifiable by:** unit test for preference persistence; UI test that target/tone changes take effect.

### F7. Local-first persistence & privacy posture — **Not built**
All data (mantras, preferences, sessions) stored **on device only**; no network, no accounts, no analytics SDKs.
- **Given** the app, **when** inspected, **then** it makes **no network calls** and links no analytics/ad SDKs (verifiable in build/Info; declared in PrivacyInfo — see §9).
- **Given** app data, **when** stored, **then** it lives in app-sandbox local storage (SwiftData/`Codable` file), readable only by the app.
- **Given** App Store privacy requirements, **when** the app ships, **then** the privacy "nutrition label" and `PrivacyInfo.xcprivacy` declare **no data collection** truthfully.
- **Verifiable by:** network-link audit (no `URLSession` usage in product paths); presence and correctness of `PrivacyInfo.xcprivacy`.

---

## 3. Out of Scope (v1 non-goals)

- **Streaks / "don't break the chain" / loss-aversion mechanics — explicitly forbidden for v1.** Devotional practice plus streak pressure is a tone failure; the product thread directs us to show gentle history, not a streak counter. (Note: the *current* `docs/PROJECT_DOCUMENTATION.md` still lists "history/streak" — that is stale and has been corrected; see this doc and the updated PROJECT_DOCUMENTATION.)
- **Reminders / push notifications.** Out of scope for v1: nudging a devotional practice is the same tone risk as streaks, and notifications add a permission prompt and a privacy surface for no core value. (The old doc's "optional reminder" is deprioritized; if ever added, it is post-v1 and must be opt-in and non-nagging.)
- **Audio / guided chanting / per-bead recited mantra audio.** Out of scope. Haptics carry the core experience; v1 ships at most one *gentle completion tone*. Full audio is a later expansion.
- **Literal photoreal bead-string rendering / 3D mala.** Out of scope. v1 is **abstract-tactile** (haptic rhythm + a simple, calm visual). Literal bead rendering is polish for later, not the differentiator.
- **Content library / large curated mantra catalog, translations, meanings, pronunciation audio.** Out of scope. v1 ships a *tiny reviewed seed set + user free-text* only.
- **Accounts, cloud sync, cross-device, sharing, social, leaderboards.** Out of scope. Local-first, single-device.
- **Analytics, telemetry, ads, third-party SDKs.** Out of scope (and would break the privacy posture in F7/§9).
- **In-app purchases / StoreKit / supporter unlock / content packs.** Out of scope for v1 (no `.storekit`, no IAP). Monetization is a future consideration only.
- **Apple Watch / widgets / Live Activities / iPad-optimized layout.** Out of scope for v1 (single-screen iPhone app); attractive later, but not part of the differentiator.
- **Localization beyond what the seed mantras require.** UI localization is post-v1.

---

## 4. User Flows

Screen names below are *proposed* (no code exists yet); they define the intended structure for the build.

### Flow A — First run / onboarding (intentionally minimal)
1. App launches to **Home** (or directly to **Practice** with a sensible default mantra + target 108).
2. A brief, skippable one-line explainer: "Tap to advance a bead. Feel each one. You'll feel a distinct buzz at 108." No account, no permissions wall.
3. No notification permission is requested (none used). No tracking prompt (no tracking).
4. User proceeds to **Mantra Select** or accepts the default and lands on **Practice**.

### Flow B — Core loop (the product)
1. From **Home/Practice**, user has a selected mantra and a target (default 108).
2. User starts the session; **Practice** shows a single large advance target and a quiet progress indication (current bead / target) that is *not required* to read.
3. User advances bead-by-bead (tap/thumb-swipe), eyes open or closed. Each advance → **crisp per-bead haptic** (F2).
4. If interrupted (call, screen off, app backgrounded), the place is preserved; on return the user resumes at the exact bead (F1).
5. On the target bead (108th/chosen), the **distinct completion haptic + gentle tone** fires once (F3) — the unmistakable end-of-round signal.
6. Session ends → **Completion** screen: simple confirmation, count, mantra; saved to history (F5). No streak, no "come back tomorrow" pressure.

### Flow C — Choose / create a mantra
1. From **Practice** or **Home**, user opens **Mantra Select** (F4).
2. User picks from the **tiny reviewed seed set**, or selects **Custom** and types free text.
3. Custom mantras are saved locally for reuse; selecting any mantra returns to **Practice** ready to count.

### Flow D — History
1. User opens **History** (F5): a calm, reverse-chronological list of past sessions (date, mantra, count/target, duration).
2. User may delete an entry or clear all (privacy — F5/F7). No streaks or chains anywhere.

### Flow E — Settings / privacy
1. User opens **Settings** (F6): set default target, toggle completion tone, adjust haptic intensity (where supported), clear history.
2. Privacy: a short statement that all data stays on device; nothing is collected or sent (F7).

### Flow F — Eyes-free / screen-off practice (the acceptance scenario)
1. User starts a session on **Practice**, then closes eyes or turns the phone face-down.
2. User advances by feel; each bead is confirmed by haptic only; the round's completion is felt distinctly at the target — **the explicit "didn't have to look" success signal** (§1 north-star).

---

## 5. Acceptance Criteria Summary

Consolidated launch gate per MVP feature. A feature passes only when its §2 criteria are all met **and** it is exercised by the tests/manual checks named.

| ID | Feature | Status | Launch pass/fail gate (summary) |
|----|---------|--------|----------------------------------|
| F1 | Repetition engine | Not built | Unit tests green for advance, round-completion (once, at N only), interruption-resume, target-config (incl. boundary/invalid), undo/decrement. **Hard gate — the differentiator's logic.** |
| F2 | Eyes-free practice screen | Not built | Tap/swipe advances exactly one bead with crisp <~50 ms haptic; haptics fire in silent mode; forgiving hit area; one-step undo; usable eyes-closed. |
| F3 | Distinct completion signal | Not built | Completion haptic perceptibly distinct from per-bead tick; fires exactly once at target; graceful fallback w/o Core Haptics; respects tone-off setting. **Hard gate — without it, it's a skinned counter.** |
| F4 | Seed set + free-text mantras | Not built | Reviewed seed list shown; custom free-text usable and persisted; mantra never affects counting; practice not blocked by content. |
| F5 | Session completion + history | Not built | Sessions saved (mantra, target, count, date, duration); calm reverse-chron list; partial sessions honest; delete works; **no streak UI anywhere**. |
| F6 | Preferences | Not built | Target/tone/intensity persist and apply without restart; unsupported controls degrade gracefully. |
| F7 | Local-first persistence & privacy | Not built | No network calls, no analytics SDKs; sandbox-only storage; correct `PrivacyInfo.xcprivacy` + truthful privacy label. **Hard gate — privacy claim.** |

**Overall launch gate:** all hard gates (F1, F3, F7) pass; F2/F4/F5/F6 meet their criteria; §9 checklist complete; content sign-off done.

---

## 6. Known Limitations

- **Nothing is built yet.** This is a pre-build specification; every item in §2 is unimplemented. Timelines/feel claims are intentions to validate on device, not measured results.
- **Haptic feel is device-dependent.** Crispness, latency, and the distinctness of the completion pattern vary across iPhone models (Taptic Engine generations) and degrade on devices without Core Haptics. The "eyes-free distinct completion" claim must be validated per-device class; a fallback path is required (F3).
- **"Eyes-free" is a UX claim, not a guarantee.** It depends on haptic tuning and must be confirmed by real users in beta; it is the single highest-risk product assumption.
- **Silent-switch / tone behavior is nuanced.** Haptics ignore the mute switch; the tone respects it. This split behavior must be made obvious to users to avoid confusion ("why no sound?").
- **Seed mantra content correctness is a human-review dependency.** Mantra text/transliteration must be reviewed for accuracy and respectfulness before ship; this is outside what code can self-verify (§9).
- **Partial-session semantics are a product decision still to finalize** (record-as-partial vs. discard) — must be fixed before history ships so counts are never misleading.
- **No accessibility implementation yet.** VoiceOver labeling, Dynamic Type, and reduced-motion handling are specified intentions, not built; an eyes-free app must be exemplary here, so this is load-bearing, not optional.

---

## 7. Bug & Risk Triage

Because there is no code, there are no code-level bugs (no TODO/FIXME/stubs exist — `grep` over the repo returns none; the only files are `.gitkeep` and `docs/PROJECT_DOCUMENTATION.md`). The "blocking" list therefore captures the **must-resolve build/product/privacy/content gaps** that stand between "empty repo" and "shippable v1," plus the one **already-fixed documentation defect**. The non-blocking list captures deferrable polish.

### Launch-blocking (must fix before TestFlight/App Store)

| ID | Description | Where | Why blocking |
|----|-------------|-------|--------------|
| B1 | **No app exists** — no Xcode project, no SwiftUI target, no Swift source. | whole repo (`.gitkeep` only) | Cannot build, run, or submit anything. |
| B2 | **Repetition engine (F1) unbuilt and untested.** | n/a (to create) | It is *the* differentiator; without a tested advance/completion/interruption-resume engine the app is a guesswork counter. Tests are a hard gate. |
| B3 | **Distinct completion haptic + tone (F3) unbuilt.** | n/a (to create) | Without an unmistakable, distinct end-of-round signal the app is "a skinned counter and should not ship standalone" (product thread). |
| B4 | **Eyes-free per-bead haptic + forgiving advance (F2) unbuilt; latency/feel unvalidated.** | n/a (to create) | The eyes-free claim is the core value; unproven feel = unshippable core. |
| B5 | **Privacy artifacts missing.** No `PrivacyInfo.xcprivacy`, no privacy label, no verified no-network posture. | n/a (to create) | App Store requires accurate privacy disclosures; the "local-first, nothing collected" claim must be provably true and declared. |
| B6 | **Seed mantra content not written or human-reviewed.** | n/a (to create) | Spiritual content must be accurate and respectful; shipping wrong/garbled mantra text is a serious tone/credibility failure. Requires human sign-off. |
| B7 | **Streak/reminder scope leak in source docs (NOW FIXED).** Old `docs/PROJECT_DOCUMENTATION.md` listed "history/streak" and "optional reminder," which contradict the v1 no-streaks/no-reminders directive. | `docs/PROJECT_DOCUMENTATION.md` | Building to the stale doc would reintroduce the exact tone failure v1 must avoid. Corrected in this pass (doc rewritten; see top-of-file note). Listed here so the reviewer confirms the corrected scope is the one built. |
| B8 | **No persistence/interruption-resume implementation (F1/F7).** | n/a (to create) | Interruption safety is a named success signal; losing a user's place mid-round is a core-promise failure. |
| B9 | **App Store metadata: name/age-rating/category not set.** | n/a (to create) | Required to submit; spiritual content needs an appropriate age rating and respectful store presentation. |

### Non-blocking (ship-with, fix later)

| ID | Description | Rationale for deferral |
|----|-------------|------------------------|
| N1 | Haptic-intensity control on unsupported devices. | Degrade gracefully (hide control); not core. |
| N2 | Literal/visual bead-string rendering & richer animation. | Abstract-tactile is sufficient for v1; visual polish later. |
| N3 | Expanded mantra catalog with meanings/translations/pronunciation. | Seed set + free-text covers the core; library is a content expansion. |
| N4 | Audio (chanting, per-bead audio). | Explicitly post-v1; haptics carry v1. |
| N5 | Apple Watch app / widgets / Live Activities. | Nice-to-have; not the differentiator. |
| N6 | UI localization beyond seed-mantra needs. | Post-v1. |
| N7 | iCloud/cross-device sync. | Local-first by design; sync is opt-in future work. |
| N8 | Partial-session UX refinement (beyond the basic honest record). | Basic honest recording suffices for launch; richer handling later. |

---

## 8. Production-Readiness Assessment

### Current estimated readiness: **5%**
Justification: there is a **clear, sharp, and validated product definition** (the conversation thread converged on the differentiator and the smallest non-generic MVP) and now a complete build-to spec and reconciled docs — that's real, reusable groundwork. But **zero implementation exists**: no project, no engine, no UI, no tests, no content, no privacy artifacts. The 5% reflects "well-specified, nothing built." Readiness will jump meaningfully once F1 (engine + tests) and F3 (distinct completion) prove the core feel on a device.

### Concrete remaining work to reach 80–90% production-ready (ordered checklist)
1. **Scaffold the app.** Create the Xcode project / SwiftUI app target; lock minimum iOS (propose 17+); set bundle id, app name, category (Health & Fitness or Lifestyle — decide in §9), placeholder app icon; commit a `README.md`.
2. **Build & unit-test the repetition engine (F1) FIRST.** Pure Swift, no UI: `advance`, target config, round-completion event (fires once, at N only), interruption/resume via persisted state, undo/decrement, boundary/invalid targets. Ship with a passing test suite — this is the named hard gate (B2).
3. **Implement haptics (F2 + F3) with Core Haptics**, plus `UIFeedbackGenerator` fallback: crisp per-bead tick and a **distinct** completion pattern; verify per-bead haptic fires in silent mode and completion is perceptibly different. Validate latency/feel on at least two device classes (B3, B4).
4. **Build the practice screen (F2):** single large forgiving advance target, quiet progress, one-step undo; usable eyes-closed/screen-off. Wire the gentle completion tone via `AVFoundation` (respecting silent switch + tone-off setting).
5. **Implement local persistence (F7) + session model:** SwiftData (or `Codable` file); persist current session for interruption-resume (B8); save completed/partial sessions.
6. **Build mantra selection (F4):** tiny **reviewed** seed set + custom free-text (saved locally); ensure mantra never affects counting.
7. **Build history (F5)** as a calm reverse-chron list with delete/clear; **assert no streak UI** anywhere (guard against B7 regression).
8. **Build settings (F6):** target, tone toggle, haptic intensity (graceful where unsupported), clear-history.
9. **Privacy & no-network audit (F7/B5):** add `PrivacyInfo.xcprivacy` declaring no data collection; confirm no network/analytics in product paths; prepare a truthful privacy label.
10. **Content sign-off (B6):** finalize and human-review the seed mantra text/transliteration; document the review.
11. **Accessibility pass:** VoiceOver labels for advance/undo/completion, Dynamic Type, reduced-motion; re-verify eyes-free use with VoiceOver users.
12. **App Store prep (B9, §9):** age rating, screenshots, description with respectful copy, support URL, build & TestFlight.

### Test coverage summary
- **Currently:** **0% — no tests, no code.**
- **Required for launch (target):**
  - *Unit (highest priority, the hard gate):* repetition engine — advance, round-completion fires exactly once at N, interruption/resume restores exact bead, target-config including boundary (1, max) and invalid (≤0), undo/decrement floor at 0. Plus persistence (save/load session, preferences, custom mantra) and "no streak" structural assertion.
  - *UI tests:* advance→bead increment, undo→decrement, completion event → one signal, settings changes take effect.
  - *Manual/device tests (cannot be automated):* per-bead haptic crispness & latency; per-bead vs. completion haptic distinctness eyes-free; haptics-in-silent-mode; eyes-closed/screen-off full round; per-device-class fallback behavior.

---

## 9. Launch Checklist

App Store / privacy / safety / content items specific to Japa:

- [ ] **App identity:** final app name ("Japa") cleared for App Store, bundle id set, category chosen (Lifestyle or Health & Fitness), app icon (respectful, non-appropriative imagery).
- [ ] **Age rating:** set an appropriate rating; spiritual/religious content is acceptable but must be presented respectfully and rated honestly.
- [ ] **`PrivacyInfo.xcprivacy`:** present and declaring **no data collection / no tracking** (F7). Required Reason API usage declared if any.
- [ ] **App Store privacy "nutrition label":** declares no data collected, no tracking — and this is **provably true** (no network/analytics in the build).
- [ ] **No network / no SDKs audit:** confirm the shipped binary makes no network calls and links no analytics/ad SDKs.
- [ ] **No tracking prompt / no notification permission:** v1 requests **no** ATT and **no** notification permission (no reminders in v1, §3) — verify none are triggered.
- [ ] **Haptics & silent-switch behavior documented in-app:** users understand haptics work in silent mode and the tone follows the mute switch / tone setting (avoids "it's broken" confusion).
- [ ] **Eyes-free / completion-signal validated on real devices** across at least two iPhone classes, including the no-Core-Haptics fallback path (B3/B4).
- [ ] **Content sign-off:** seed mantra text & transliteration reviewed by a qualified human for accuracy and respectfulness; review recorded (B6).
- [ ] **No streaks / no loss-aversion / no nagging** anywhere in the shipped UI (deliberate tone gate; verify against the corrected scope — B7).
- [ ] **No StoreKit / IAP in v1** (free core, no `.storekit`); ensure no purchase UI is exposed.
- [ ] **Accessibility:** VoiceOver, Dynamic Type, reduced-motion verified — non-negotiable for an eyes-free app.
- [ ] **Local data controls:** user can delete individual history entries and clear all data (privacy, F5/F7).
- [ ] **Crash-free core loop:** a full 108-bead round completes end-to-end, including an interruption mid-round, on a clean install and on an upgrade.
- [ ] **Support/contact URL** and a short, respectful App Store description prepared.
- [ ] **TestFlight beta** with practice users; collect qualitative "didn't have to look" / interruption-safety feedback before public release.
