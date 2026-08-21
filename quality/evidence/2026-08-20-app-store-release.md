# App Store release — 2026-08-20

## Scope

Public release of Mala iOS version 1.0 Build 2 (`com.priyansh.mala`, App Store
Connect app id `6796503849`) to the App Store. This record captures verified
external state read live from App Store Connect's own History tab; repository
documents remain authoritative per `docs/GOVERNANCE.md`.

## App identity

- App id: `6796503849`
- Bundle identifier: `com.priyansh.mala`
- Version: `1.0`
- Build: `2`
- Submission id: `897d1493-c2f1-474f-afa6-01d3e92694c4`

## App Store Connect History (read live by the owner's assistant, authoritative)

| Event | Timestamp | Actor |
|---|---|---|
| Prepare for Submission | Jul 30, 2026 6:49 PM | priyansh.chordia@gmail.com |
| Ready for Review | Aug 6, 2026 11:39 PM | priyansh.chordia@gmail.com |
| Waiting for Review | Aug 6, 2026 11:40 PM | priyansh.chordia@gmail.com |
| In Review | Aug 20, 2026 6:22 AM | Apple |
| Pending Developer Release | Aug 20, 2026 7:34 AM | Apple (approved) |
| Processing for Distribution | Aug 20, 2026 8:20 PM | priyansh.chordia@gmail.com (owner clicked Release This Version) |
| Ready for Distribution | Aug 20, 2026 8:20 PM | priyansh.chordia@gmail.com (live on the App Store) |

The Waiting for Review row matches the submission already recorded in
`docs/STATUS.md` and `docs/HANDOFF.md` on 2026-08-06 under submission
`897d1493-c2f1-474f-afa6-01d3e92694c4`.

## Result

Mala 1.0 (Build 2) is live and publicly available worldwide: free, no IAP,
"Data Not Collected" privacy label already published (see
`quality/evidence/2026-08-06-app-store-connect-preparation.md` for the
publication record). No further release action is pending.

## Limitations

- This record captures the App Store Connect History timeline and release
  outcome. It does not add new physical-device QA evidence; see
  `docs/RELEASE_CHECKLIST.md` and `LAUNCH_READINESS.md` §9 for the honest
  disposition of the physical-device crash-free interruption gate, which
  remains owner-waived for 1.0 rather than evidenced by a dedicated test
  artifact.
- GitHub Actions release automation (`ASC_KEY_CONTENT`) remains unconfigured
  and deferred; it did not block this manual release (R4, `docs/RISKS.md`).
