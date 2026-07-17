# Release Checklist

## Build / config

- [ ] Production configuration builds (Release)
- [ ] Signing enabled for device/TestFlight with real Development Team
- [ ] `xcodegen generate` from `project.yml` keeps project consistent
- [ ] Fake / UITest-only data paths excluded from production

## Quality

- [ ] Required automated tests pass (unit + UI)
- [ ] Persistence relaunch verified
- [ ] No network / no analytics / PrivacyInfo truthful
- [ ] No streak / notification surfaces

## Launch gates (from LAUNCH_READINESS)

- [ ] Seed mantra human content sign-off (`docs/CONTENT_REVIEW.md`)
- [ ] On-device haptic validation (≥2 iPhone classes + fallback)
- [ ] Accessibility validation (VoiceOver, Dynamic Type, reduce motion)
- [ ] App Store metadata, screenshots, support URL, age rating
- [ ] TestFlight crash-free E2E on device

## Factory

- [x] Registered as existing project (standard 0.2.0)
- [x] Feature contracts for highest-risk workflows
- [ ] Completion evidence recorded under `quality/evidence/`
