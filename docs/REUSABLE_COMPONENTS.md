---
id: DOC-REUSABLE
canonicalFor: reusable-code-inventory
status: active
lastVerified: 2026-07-17
readWhen:
  - adding infrastructure or a dependency
  - evaluating extraction of app-local code into a shared library
related:
  - ../.factory/library-catalog.json
supersedes: []
---

# Reusable Components

Track shared-library discovery, adopted packages, app-local reusable candidates, and upstream contribution work.

## Catalog reviewed

- Catalog version: `0.1.0` (`pri8771/iOS_app_factory_rules/registry/libraries.json` — currently empty)
- Date reviewed: 2026-07-17
- Capabilities searched: JSON persistence, write-behind/resumable-state storage, atomic file writes, Core Haptics playback + fallback, tone/audio synthesis, XCTest file-storage fixtures

## Adopted shared libraries

| Capability | Library | Version | Product adapter | Verification |
|---|---|---|---|---|
| — | — | — | — | None adopted yet — central registry is empty (catalogVersion 0.1.0, 0 libraries) |

## App-local reusable candidates

| Module | Capability | Why local for now | Genericity evidence | Promotion trigger |
|---|---|---|---|---|
| `Japa/Persistence/Persistence.swift` | Generic Codable JSON load/save/delete against a directory | Only one consumer today; error handling (`try?`-and-swallow) is a v1 simplicity choice a shared library would need to redesign | Struct is generic over `Codable`; only the `"Japa"` path segment in `.live` is product-specific | A second App Factory app that wants zero-dependency JSON-file storage for prefs/small collections |
| `Japa/Persistence/ActiveSessionStore.swift` | Write-behind persistence of one resumable in-progress item (async save off the hot path, sync flush/clear) | Best-tested candidate in the app, but hardcoded to `ActiveSessionState` and one file name — the *pattern* is generic, the *code* isn't yet | ~10-line wrapper around `Persistence`; genericizing to `WriteBehindStore<T: Codable>` is a small, low-risk refactor | A second app with an analogous single-resumable-item requirement |
| `Japa/Views/RootView.swift` + `PracticeController.persistNow()` | Lifecycle flush-on-background hook (`scenePhase` → synchronous flush before suspend) | A few lines of glue tightly coupled to `scenePhase` and `PracticeController`; no `FlushableOnBackground`-style abstraction exists | Concept generalizes; implementation doesn't — zero automated coverage of the actual `scenePhase` wiring | 3+ apps with the same write-behind-plus-flush-on-background need |
| `Japa/Haptics/HapticPlayer.swift` (`startEngineIfNeeded`, `resume`, `play`, `attemptPlay`, capability check) | Core Haptics resilience: capability detection, engine restart, retry-once, fallback to `UIFeedbackGenerator` | The single most novel piece of engineering in the app, but **zero automated test coverage** of the retry/fallback/restart logic — no engine-abstraction protocol exists to make it independently testable | Retry/fallback machinery doesn't know about beads/mantras/rounds; only the `HapticFeedback` protocol's method names (tick/completion/back) are product-specific | Unit tests against an injectable engine protocol proving the retry-then-fallback sequence, **plus** a second consumer with different custom patterns |
| `Japa/Audio/CompletionTone.swift` (`makeWAV`, `encodeWAV`) | In-memory sine-wave tone synthesis + WAV encoding, no bundled audio asset | Zero test coverage of the binary WAV header/encoding correctness; envelope shape (attack/decay) is hardcoded, not parameterized | `encodeWAV`/`makeWAV` contain no Japa-specific concepts; only the static `toneData` frequency/weight choice is product-specific | Unit tests on header/sample correctness, plus a second consumer wanting a different tone/envelope |

**Not promoted, evaluated and rejected as standalone candidates:** atomic file replacement (`Data.write(options: [.atomic])` — a single stdlib flag, nothing to extract), haptic capability detection (`CHHapticEngine.capabilitiesForHardware()` — a single system call, inseparable from the fallback logic above), and "reusable async/error primitives" (not a distinct capability — collapses into the `ActiveSessionStore` write-behind pattern above).

**Local DRY note (not a library question):** `tempDirectory()`-style test helpers are retyped six times across `JapaTests`/`JapaUITests` with different literal prefixes. Worth a same-repo refactor into one shared test helper; too small to justify an external test-support package.

## Upstream edge cases

| Library | Edge case | Product workaround | Upstream issue/PR | Released version | Product upgraded |
|---|---|---|---|---|---|
| — | — | — | — | — | None — no adopted shared libraries yet |

## Rejected candidates

None formally rejected — no shared-library search has yet had a candidate to reject, since the central registry (`registry/libraries.json`) is currently empty for every capability this app needs.
