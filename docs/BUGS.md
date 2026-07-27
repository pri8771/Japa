---
id: DOC-BUGS
canonicalFor: known-defects
status: active
lastVerified: 2026-07-27
readWhen:
  - fixing a bug
  - checking known defects before claiming a feature is done
related:
  - ../quality/feature-contracts
  - RISKS.md
supersedes: []
---

# Bugs

Open product/engineering gaps tracked for launch. Pre-existing relative to App Factory onboarding (2026-07-16).

| ID | Severity | Area | Summary | Status | Evidence |
|----|----------|------|---------|--------|----------|
| B6 | high | Content | ~~Seed mantra set not human-signed off~~ | **resolved 2026-07-26** | Bundled spiritual seed content removed; neutral Counting + private custom labels remain |
| B-SIGN | high | Release | Fresh-runner TestFlight signing path is unverified and lacks a demonstrated signing identity setup | open | `fastlane/Fastfile`, `.github/workflows/release-testflight.yml` |
| B-URL | high | Release | Planned privacy and support URLs are not live | open | `https://priyanshchordia.com/mala/privacy`, `/mala/support` |
| B-A11Y | medium | Accessibility | VoiceOver is coded but user validation is deferred post-v1. Dynamic Type is implemented and smoke-tested. | accepted post-v1 risk | `Japa/Design/Theme.swift`; `JapaUITests.testPrimaryFlowAtAccessibilityTextSize`; MALA-7 |
| B-HAPT | medium | Haptics | Physical iPhone 16 Pro Max validation passed; automated tick-vs-completion spy coverage remains absent | partial | Device evidence 2026-07-18; FEAT-001 verification gap |
| B-DOC | low | Docs | ~~`README.md` and `docs/PROJECT_DOCUMENTATION.md` test counts outdated vs source~~ | **resolved 2026-07-17** | Corrected to 46+7=53 in README.md, docs/PROJECT_DOCUMENTATION.md, and LAUNCH_READINESS.md; confirmed by a passing `xcodebuild test` run |
| B-CI | medium | CI | ~~No GitHub Actions workflows~~ | **resolved 2026-07-17** | `.github/workflows/ios-ci.yml` added: XcodeGen, Release build, full tests |
| B-HIT | high | Practice UI | ~~On the 6.9-inch layout, the full-screen counting gesture could intercept History/Settings taps~~ | **resolved 2026-07-27** | Practice gesture excludes the top and bottom control bands; history UI flow passes on iPhone 17 Pro Max |

## Closed relative to original launch blockers

Original B1–B5 / B8 (no app / no engine / no haptics / no privacy / no persistence) are **resolved in code**. B-DOC (stale test counts) and B-CI resolved 2026-07-17. Treat remaining items above as launch gates, not missing scaffolding.
