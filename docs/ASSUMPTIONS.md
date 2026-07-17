# Assumptions

| ID | Assumption | Evidence | Validation plan | Status |
|----|------------|----------|-----------------|--------|
| A1 | Distinct completion haptic is perceptible vs per-bead tick eyes-free | Implemented in `HapticPlayer`; unvalidated on device | On-device A/B on ≥2 iPhone classes | open |
| A2 | Users can complete a full round without looking | Product differentiator; UI tests cover tap flow only | Manual eyes-closed round on device | open |
| A3 | Seed mantra transliterations are accurate/respectful | Draft in `SeedMantras.swift` | Human review in `CONTENT_REVIEW.md` | open |
| A4 | Local JSON persistence is sufficient for v1 (no sync) | Product constraint; PrivacyInfo audited | Keep no-network; relaunch tests | accepted |
| A5 | iPhone-only is correct for v1 | `TARGETED_DEVICE_FAMILY = 1`; launch scope | DEC-003; revisit post-v1 | accepted |
