# Runnable Maestro flows (intro-aware)

These are execution-ready copies of the generated flows in `../generated/`, with
one difference: each dismisses the first-run intro sheet (`tapOn: introBegin`)
after a `clearState` launch.

## Why they differ from `../generated/`

The App Factory generator emits a bare `- launchApp` for each flow. Two facts
about Japa make that insufficient on a cold install:

1. **First-run intro gate.** A fresh launch shows the intro sheet, which covers
   the practice surface, so the first `assertVisible` fails until it is
   dismissed.
2. **Env-driven test mode can't be reached from Maestro.** The app's deterministic
   mode is driven by *environment* variables (`UI_TEST_MODE`, `UI_FIXTURE`, …),
   which XCUITest can set via `launchEnvironment` but Maestro's `launchApp`
   cannot. So Maestro runs the app in normal mode and must handle the intro like
   a real user.

These flows therefore add a real `tapOn: introBegin` step. Fixture seeding
(`one-record`, …) is not available in this mode; `journey-open-history` asserts
`historyRoot`, which is present in both the empty and populated states.

## Verified run

- 2026-07-19, Maestro 2.6.1, iPhone 17 Pro simulator (iOS 26.5): **4/4 flows
  passed** in ~55s. Evidence: `../../evidence/2026-07-19-maestro-ui-flows.md`.

## Recommended upstream follow-ups

- Have the generator translate each journey's declared `launchArguments` into a
  `launchApp: arguments:` block, and teach the app to read the `UI_*` flags from
  launch *arguments* (Maestro-settable) in addition to environment — including a
  test-mode intro skip. That would let the raw generated flows run without the
  hand-added intro step. Tracked in the Studio OS Atlas task.
