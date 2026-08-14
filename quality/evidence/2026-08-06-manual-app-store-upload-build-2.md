# Manual App Store Connect upload — Mala 1.0 (2)

Date: 2026-08-06

## Outcome

Mala version `1.0`, build `2`, was archived locally and uploaded manually through
Xcode Organizer to App Store Connect.

- Bundle identifier: `com.priyansh.mala`
- Team: `796XH483R4` (Priyansh Chordia)
- Architecture: `arm64`
- Archive: `/private/tmp/Mala-Manual-Build-2.xcarchive` (local, ephemeral)
- Xcode Organizer result: **App upload complete**
- Organizer archive status: **Uploaded to Apple**
- Organizer submission status: **Uploaded**, build number `2`

App Store Connect subsequently processed Build 2 and reported status **Ready to
Submit**, expiring in 90 days. The processed build identifier is
`9c1bb007-34f3-490f-bb1f-0ce6f9b662c8`; the internal Family group is attached.

The archive used automatic signing overrides at archive time only. The canonical
`project.yml` remains CI-safe with signing disabled by default.

## Authentication path

This was a manual upload using the Apple account and signing assets configured
in Xcode. It did not use `ASC_KEY_CONTENT` or the GitHub Actions release
workflow. The App Store Connect API key remains optional future automation work.

## Human testing statement

The accountable user reported on 2026-08-06 that the intended testers had
tested the release-candidate behavior and found it acceptable. The accountable
user subsequently confirmed that processed Build 2 worked correctly through
TestFlight. This closes the final distribution-path smoke check for this release
candidate.
