# Automated UI-testing manifests

Canonical UI contract for App Factory automated UI testing
(`iOS_app_factory_rules` standard 0.4.0,
`standards/testing/AUTOMATED_UI_TESTING_STANDARD.md`).

## Files

- `screens.yaml` — registered screens, their stable accessibility identifiers,
  supported fixtures, required elements, navigation exits, and prohibited
  actions.
- `journeys.yaml` — critical, non-destructive user journeys with deterministic
  launch arguments.
- `safe-actions.yaml` — explicit allow/deny list for automated exploration.
- `generated/` — Maestro flows produced by the factory generator
  (`scripts/generate-maestro-flows.rb`). Derived output; do not edit by hand.

## Generating flows

```bash
MAESTRO_APP_ID=com.priyansh.mala \
  ruby /path/to/iOS_app_factory_rules/scripts/generate-maestro-flows.rb \
  quality/ui/screens.yaml quality/ui/journeys.yaml quality/ui/generated
```

## Deterministic test mode

`Japa/JapaApp.swift` honors both the app's original `JAPA_UITEST=1` contract and
the App Factory standard contract:

| Variable | Effect |
| --- | --- |
| `UI_TEST_MODE=1` | Ephemeral store; equivalent to `JAPA_UITEST=1`. |
| `UI_RESET_STATE=1` | Wipe the store before launch. |
| `UI_FIXTURE=<name>` | Seed local state: `empty`, `one-record`, `many-records`, `long-text`. |
| `UI_DISABLE_ANIMATIONS=1` | Disable UIKit-backed animations. |

`error`, `offline`, and `permission-denied` fixtures from the standard
vocabulary are **not applicable**: Japa is local-first with no network calls and
no OS permission prompts, so those states cannot occur.

## Open follow-ups (not done during enrollment — scoped out to avoid churn)

1. **Selector-convention alignment.** The standard prefers
   `<product>.<screen>.<element>.<role>`. Japa predates it and uses short
   camelCase identifiers (`settingsButton`, `advanceRing`, …) referenced by the
   existing XCUITest suite. This manifest documents the real identifiers rather
   than renaming them (which would break `JapaUITests`). A rename + test-update
   pass is deferred.
2. **Full SwiftUI animation suppression.** `UI_DISABLE_ANIMATIONS` currently
   disables UIKit-level animations; a couple of SwiftUI `withAnimation` sites are
   not yet routed through a test-mode flag.
3. **Maestro simulator execution.** DONE (2026-07-19). Executed on Maestro 2.6.1
   against an iPhone 17 Pro simulator: **4/4 flows passed**. The raw generated
   flows need one intro-dismiss step on this app (first-run gate + env-only test
   mode); the executable copies live in `runnable/` and evidence is in
   `../evidence/2026-07-19-maestro-ui-flows.md`. Remaining upstream improvement
   (generator emits `launchApp: arguments:` + app reads launch-arg test mode) is
   tracked in the Studio OS Atlas task.
