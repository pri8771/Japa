# Mala release identity and screenshot evidence

Date: 2026-07-27
Environment: macOS 26.5.2, Xcode simulator runtime iOS 26.5

## Scope

- Public product identity changed from Japa to Mala.
- Compatibility-sensitive internal identifiers remain unchanged: Xcode target/scheme/product `Japa`, bundle ID `com.priyansh.japa`, Swift type names, and the persistence directory.
- Bundled spiritual seed content is absent; the shipping default is neutral Counting plus private user labels.
- Five raw App Store screenshots were captured from an iPhone 17 Pro Max simulator.

## Verification

- `xcodegen generate`: exit 0.
- Full `xcodebuild test` scheme on iPhone 17 / iOS 26.5 with signing disabled: exit 0; canonical suite count is 62 (52 unit/flow + 10 UI).
- Targeted screenshot UI flows on iPhone 17 Pro Max / iOS 26.5: passed.
- Release simulator build with signing disabled: exit 0.
- Built Info.plist: display name `Mala`, bundle identifier `com.priyansh.japa`, version `1.0` (1).
- Screenshot files: 1320 × 2868 PNG, portrait, no alpha.
- Screenshot visual review: all five images show complete shipping UI without clipping, alerts, debug overlays, or private data.

## Defect found and corrected

The 6.9-inch history capture exposed a hit-testing collision: the practice surface's broad counting gesture could intercept taps intended for the compact top navigation controls. The gesture area now excludes the top and bottom control bands. The history record/delete UI flow subsequently passed on the iPhone 17 Pro Max simulator. See B-HIT in `docs/BUGS.md`.

## Remaining human/external gates

- Approve and upload screenshots in App Store Connect.
- Publish and validate the privacy and support URLs.
- Complete App Store Connect metadata, privacy, age-rating, and export-compliance answers.
- Configure distribution credentials, upload a signed TestFlight build, and complete release-candidate device QA.
