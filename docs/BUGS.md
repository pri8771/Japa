---
id: DOC-BUGS
canonicalFor: known-defects
status: active
lastVerified: 2026-07-17
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
| B6 | high | Content | Seed mantra set not human-signed off | open | `docs/CONTENT_REVIEW.md` unsigned |
| B-SIGN | high | Release | Signing disabled in `project.yml` (`CODE_SIGNING_ALLOWED: NO`, empty team) — blocks device/TestFlight | open | `project.yml` |
| B-A11Y | medium | Accessibility | VoiceOver is coded (labels/values/hints, reduce-motion) but not user-validated. Dynamic Type is **not implemented** — `Japa/Design/Theme.swift` hard-codes fixed-point `.system(size:)` fonts with no scaling. This corrects the prior claim that Dynamic Type was "coded but not validated." | open | `Japa/Design/Theme.swift:56-62`; source cross-check 2026-07-17 |
| B-HAPT | high | Haptics | Eyes-free distinct-completion claim unvalidated on physical devices. No automated test spies on `HapticFeedback`/`TonePlaying` to verify tick-vs-completion distinctness or the silent-switch fallback | open | Device-only; Simulator insufficient. See `quality/feature-contracts/FEAT-001-practice-advance-undo-complete.json` `verificationGaps` |
| B-DOC | low | Docs | `README.md` and `docs/PROJECT_DOCUMENTATION.md` test counts outdated vs source (say 41+3, actual is 46+7=53, confirmed by a passing 2026-07-17 `xcodebuild test` run) | open | README/PROJECT_DOCUMENTATION.md vs `JapaTests`/`JapaUITests`; see `docs/README.md` documentation gaps |
| B-CI | medium | CI | No GitHub Actions workflows | open | `.github/workflows` absent |

## Closed relative to original launch blockers

Original B1–B5 / B8 (no app / no engine / no haptics / no privacy / no persistence) are **resolved in code**. Treat remaining items above as launch gates, not missing scaffolding.
