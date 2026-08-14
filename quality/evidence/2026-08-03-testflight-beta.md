# TestFlight beta status — 2026-08-03

## Observed state

- App: **Mala: A Quiet Digital Mala** (`com.priyansh.mala`)
- App Store Connect app ID: `6796503849`
- Existing Build 1 is in the internal TestFlight group with status **Testing**.
- The external Family group contains the invited beta testers configured in App
  Store Connect, including Sonakshi and Supriya.

## Follow-up build

The repository commit `6ade6c6` adds an explicit **Finish early** action. The
follow-up TestFlight workflow was triggered from
`agent/change-mala-bundle-id` after the Ruby setup fix (`c7f2023`), but both
runs stopped at the authentication preflight:

- Run `30778381551`
- Run `30778424180`

The failure is deterministic and occurs because the GitHub Actions secret
`ASC_KEY_CONTENT` is empty/missing. The workflow did not archive or upload a
follow-up build. Add the base64-encoded App Store Connect `.p8` key as that
secret, rerun the workflow, and append the processed build number and device
verification results here.

## Beta testing record

Record tester feedback, defects, reproduction steps, and lessons learned in
the repository documentation before synchronizing Jira and Notion mirrors.
