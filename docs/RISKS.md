# Risks

| ID | Risk | Probability | Impact | Mitigation | Owner | Status |
|----|------|-------------|--------|------------|-------|--------|
| R1 | Haptic feel fails eyes-free claim on some devices | high | high | Device matrix ≥2 iPhone classes + fallback validation | owner | open |
| R2 | Spiritual seed content inaccurate / disrespectful | medium | high | Human sign-off via `CONTENT_REVIEW.md` before submit | owner | open |
| R3 | Accessibility gaps undermine eyes-free promise | medium | high | VoiceOver / Dynamic Type validation pass | owner | open |
| R4 | Signing/config drift blocks TestFlight | medium | high | Enable signing only for release lane; keep yml SoT | owner | open |
| R5 | Factory docs vs Notion/Jira drift | medium | medium | Sync Notion + Jira on status changes | owner | in progress |
| R6 | No CI allows silent regressions | medium | medium | Add GitHub Actions xcodebuild smoke later | owner | open |
