# Evidence: Maestro UI flows executed on simulator

- **Date:** 2026-07-19
- **Tooling:** Maestro 2.6.1 (mobile.dev), OpenJDK 26
- **Device:** iPhone 17 Pro simulator, iOS 26.5 (udid 36A957C4-1083-46D0-8C91-051059910FBB)
- **App:** Debug build, `com.priyansh.japa`, installed via `xcrun simctl install`
- **Flows:** `quality/ui/runnable/` (intro-aware copies of `quality/ui/generated/`)

## Result

```
[Passed] journey-open-settings-mala (20s)
[Passed] journey-open-history (15s)
[Passed] screen-screen-practice (10s)
[Passed] journey-launch-practice (10s)

4/4 Flows Passed in 55s
```

## What this verifies

Every registered accessibility identifier resolves in a real running app, and
the declared navigation works black-box:

- `advanceRing`, `mantraRow`, `settingsButton`, `historyButton` — practice
  surface (launch + screen contract).
- `settingsButton → malaStyleRow → malaApplyButton` — settings → mala picker.
- `historyButton → historyRoot` — history (the one identifier added during
  enrollment).

## Notes / limitations

- Run in the app's **normal** mode (Maestro cannot set the environment variables
  that drive `UI_TEST_MODE`); the flows dismiss the first-run intro with a real
  `tapOn: introBegin` step. See `quality/ui/runnable/README.md`.
- The raw generated flows (`quality/ui/generated/`) fail on a cold install
  because they do a bare `launchApp` and hit the intro gate — expected; the
  intro-aware runnable copies are the executable form on this app.
- Deterministic env-driven fixtures remain verified separately by the XCUITest
  `UITestModeContractTests` (53 unit + 11 UI green, same day).
