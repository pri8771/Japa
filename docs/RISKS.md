# Risks

| ID | Risk | Probability | Impact | Mitigation | Owner | Status |
|----|------|-------------|--------|------------|-------|--------|
| R1 | Haptic feel differs on untested device classes | medium | high | iPhone 16 Pro Max passed; add broader device coverage post-v1 | owner | accepted |
| R2 | Spiritual seed content inaccurate / disrespectful | low | high | Bundled spiritual content removed; reactivate review if reintroduced | owner | resolved |
| R3 | Accessibility gaps undermine eyes-free promise | medium | high | Dynamic Type passes; VoiceOver user testing explicitly deferred and tracked in MALA-7 | owner | accepted post-v1 |
| R4 | Signing/config drift blocks TestFlight | medium | high | Enable signing only for release lane; keep yml SoT | owner | open |
| R5 | Factory docs vs Notion/Jira drift | medium | medium | Sync Notion + Jira on status changes | owner | in progress |
| R6 | No CI allows silent regressions | low | medium | GitHub Actions build/test workflow exists | owner | resolved |
