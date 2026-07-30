# Mala product bundle identifier verification

Date: 2026-07-30

## Change

- Shipping app bundle identifier: `com.priyansh.mala`
- Unit-test bundle identifier: `com.priyansh.malaTests`
- UI-test bundle identifier: `com.priyansh.malaUITests`
- Internal Xcode target/scheme and persistence-directory identifiers remain
  `Japa` by DEC-008.

## Verification

- `xcodegen generate` completed successfully from canonical `project.yml`.
- Full simulator suite passed on iPhone 17 Pro / iOS 26.5:
  **67 passed, 0 failed, 0 skipped**.
- Signed Release archive completed successfully with automatic provisioning:
  - archive: `/private/tmp/Mala-Bundle-ID-20260730.xcarchive` (ephemeral local evidence)
  - bundle identifier: `com.priyansh.mala`
  - marketing version/build: `1.0` (1)
  - signing identity: Apple Development
  - team identifier: `796XH483R4`

## Limitations / remaining gates

- A signed development archive verifies Apple-team provisioning for the new
  identifier; it is not a TestFlight upload.
- The App Store Connect Mala app record still needs to be created against this
  bundle identifier.
- App Store Connect API access, key generation, the remaining encrypted GitHub
  secrets, and the first end-to-end TestFlight run remain pending.
