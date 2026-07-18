# Verification Evidence — Change Mala, Dynamic Type, CI

Date: 2026-07-17

Environment:
- macOS local development machine
- Xcode destination: `platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5`
- Compact simulator check: `iPhone 17e`, iOS 26.4.1 runtime

Commands run:

```bash
xcodegen generate
xcodebuild -scheme Japa -configuration Release -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5' CODE_SIGNING_ALLOWED=NO build
xcodebuild -scheme Japa -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5' CODE_SIGNING_ALLOWED=NO test
xcodebuild -scheme Japa -destination 'id=9D4954EB-0BD7-49AF-9C0F-6A0D22B2C198' CODE_SIGNING_ALLOWED=NO -only-testing:JapaUITests/JapaUITests/testPrimaryFlowAtAccessibilityTextSize test
```

Results:
- XcodeGen generation: passed
- Release simulator build: passed
- Full automated suite: passed, 56/56 tests
  - 47 unit/flow tests
  - 9 UI tests
- Accessibility Dynamic Type smoke: passed on iPhone 17 Pro and iPhone 17e

Notes:
- Simulator emitted non-blocking `DebuggerLLDB.DebuggerVersionStore` and duplicate `UIAccessibilityLoaderWebShared` runtime warnings.
- Simulator haptic feel cannot be validated; physical-device haptic validation remains a launch gate.
- Code signing remains disabled for repository-local CI/build verification and still needs a real Apple Development Team before TestFlight/device distribution.
