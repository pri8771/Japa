# Verification Evidence — On-device validation (iPhone 16 Pro Max)

Date: 2026-07-18

Device:
- iPhone 16 Pro Max (iPhone17,2), physical hardware
- Signed development build: team `796XH483R4`, automatic provisioning
- Bundle `com.priyansh.japa`, installed via `xcodectl device install` and launched via `devicectl device process launch`

Build:
- Commit `cca2baa` (branch `Dev`)
- `xcodebuild ... -destination 'id=<iPhone16ProMax>' -allowProvisioningUpdates CODE_SIGNING_ALLOWED=YES CODE_SIGN_STYLE=Automatic DEVELOPMENT_TEAM=796XH483R4 build` — BUILD SUCCEEDED

Validated (accountable human confirmation on hardware):
- Per-bead haptic tick fires crisply on each advance.
- Distinct completion haptic fires at the target and is distinguishable from an ordinary tick.
- Full practice flow works: always-live surface (no Begin), advance, completion, new round.
- All 21 mala styles render and animate on device.
- Reported-and-fixed on device: full-bleed styles briefly letterboxed (black bars) on tap because the whole-screen art scaled with the tap-press animation; fixed in `cca2baa` (press scale now applies only to Classic's centered ring). Re-verified on device after fix.

Closes launch gates:
- JAPA-7 (eyes-free haptics + completion signal on physical device) — Done.
- JAPA-12 (physical-device full-round smoke; interruption-resume also covered by an automated UI test) — Done.

Still open (unchanged):
- JAPA-6 seed mantra human content sign-off.
- JAPA-8 VoiceOver validation with a real assistive-tech user (Dynamic Type portion already implemented + smoke-tested).
- JAPA-9 code signing / App Store / TestFlight distribution prep (`project.yml` still ships with `CODE_SIGNING_ALLOWED: NO`; device install used a command-line override only).

Notes:
- Second, lower-tier iPhone class for haptic coverage is nice-to-have but not blocking.
- Simulator still cannot validate haptic feel; this evidence supersedes that limitation for the Pro Max class.
