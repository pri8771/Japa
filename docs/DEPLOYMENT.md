---
id: DOC-DEPLOYMENT
canonicalFor: release-deployment-process
status: active
lastVerified: 2026-08-06
readWhen:
  - shipping a build to TestFlight or the App Store
  - changing signing, CI, or release automation
related:
  - RELEASE_CHECKLIST.md
  - DECISIONS.md
  - STATUS.md
supersedes: []
---

# Deployment

## Purpose

How a Mala build gets from the repository to TestFlight (and, later, the App
Store). This is the canonical owner of the **release/deployment process**;
`RELEASE_CHECKLIST.md` owns the release *gates*, and `STATUS.md` owns current
status.

## Authority and scope

- **Fact:** authoritative for the automated deployment pipeline (Fastlane +
  GitHub Actions) and the signing approach used to produce distribution builds.
- Does **not** own product-launch gates (public URLs, App Store metadata/assets,
  device QA) — those live in `RELEASE_CHECKLIST.md`; Jira MALA mirrors them.

## Current summary

| Item | Status |
|---|---|
| TestFlight automation (Fastlane `beta` lane + `release-testflight.yml`) | `implemented`, corrected signing path requires end-to-end verification |
| TestFlight beta | Build 1 is in Testing; Build 2 was uploaded manually and processed to `Ready to Submit` on 2026-08-06 |
| Current release-candidate upload | `complete` — Mala 1.0 (2) is processed and `Ready to Submit` |
| GitHub automated upload | `deferred` — workflow runs 30778381551 and 30778424180 failed because `ASC_KEY_CONTENT` is empty; this no longer blocks the manual release |
| End-to-end upload verified against App Store Connect | `verified-manual` — evidence in `quality/evidence/2026-08-06-manual-app-store-upload-build-2.md` |
| Repository-backed store metadata/screenshots (`store_metadata`) | `implemented`, unverified against App Store Connect |
| Approval-gated App Review submission (`submit_review`) | `implemented`, unverified; manual release is enforced |

**Decision (DEC-005):** authenticate with an App Store Connect API key and inject
distribution signing only at archive time. `project.yml` is left unchanged
(`CODE_SIGNING_ALLOWED: NO`) so the simulator CI (`ios-ci.yml`) stays green and
the repo is not tied to an Apple team. See `DECISIONS.md`.

## Read next

- `RELEASE_CHECKLIST.md` — the gates that must pass before a public release.
- `DECISIONS.md` DEC-005 — the signing/authentication decision and its rationale.
- `.github/workflows/release-testflight.yml` and `fastlane/Fastfile` — the pipeline itself.

## Pipeline

```text
git tag vX.Y.Z  (or manual "Release to TestFlight" run)
  → GitHub Actions: release-testflight.yml (macos-26; rejects Xcode < 26)
    → brew install xcodegen; xcodegen generate
    → fastlane beta
      → app_store_connect_api_key   (unattended auth)
      → build_app                   (Release archive, app-store export,
                                     signing injected via xcargs)
      → upload_to_testflight        (processes on App Store Connect)
```

The public-store workflow is separate and manual-only:

```text
Actions → "App Store Metadata and Submission"
  → action=metadata
      → store_metadata             (copy/screenshots only; never submits)
  → action=submit + exact build + SUBMIT-MALA-<version>
      → submit_review              (existing processed build; manual release)
```

Files:

- `fastlane/Fastfile` — the `beta` lane (archive + upload).
- `fastlane/Appfile` — bundle identifier only; no Apple ID stored.
- `Gemfile` — declares `fastlane`; `Gemfile.lock` is committed (regenerated 2026-07-27 via `bundle install`) so `ruby/setup-ruby@v1`'s `bundler-cache: true` step in `release-testflight.yml` has a lockfile to restore instead of hard-failing before it can run anything.
- `.github/workflows/release-testflight.yml` — tag/dispatch-triggered runner.
  It decodes the API key into the runner's temporary directory with mode `0600`;
  the key is never written to the repository or uploaded as an artifact.
- `fastlane/metadata/` — versioned English (U.S.) App Store fields sourced from
  `RELEASE_METADATA.md`.
- `.github/workflows/release-app-store.yml` — manual-only metadata/submission
  workflow. It uses an exact confirmation phrase and build number for review
  submission; there is no tag or push trigger.

## Required secrets

Configure these under **GitHub → Settings → Secrets and variables → Actions**
when unattended deployment is desired. They are required for the GitHub
workflow, not for a manual Xcode Organizer upload.

| Secret | Value |
|---|---|
| `ASC_KEY_ID` | App Store Connect API key ID |
| `ASC_ISSUER_ID` | App Store Connect API issuer ID |
| `ASC_KEY_CONTENT` | base64 of `AuthKey_XXXX.p8` — `base64 -i AuthKey_XXXX.p8 \| pbcopy` |
| `DEVELOPMENT_TEAM` | Apple Developer team ID (`796XH483R4`) |

The App Store metadata/submission workflow uses the first three secrets. The
TestFlight archive additionally requires `DEVELOPMENT_TEAM`. A 2026-08-03
GitHub Actions audit found `ASC_KEY_ID`, `ASC_ISSUER_ID`, and
`DEVELOPMENT_TEAM` present; `ASC_KEY_CONTENT` is the only missing secret. The
workflow fails before archive/upload when this value is empty.

## One-time human setup (cannot be automated)

1. **Fact:** an Apple Developer Program membership is required.
2. Create an **App Store Connect API key**: App Store Connect → Users and Access
   → Integrations → Keys → App Store Connect API → generate a key with **App
   Manager** access. Download the `.p8` once and record the Key ID + Issuer ID.
3. Create the app record in App Store Connect for bundle id `com.priyansh.mala`
   (name, primary category, etc.) if it does not exist.
4. Add the four secrets above to the GitHub repository.

## How to ship a TestFlight build

- **Tag:** `git tag v1.0.0 && git push origin v1.0.0` → the workflow runs
  automatically.
- **Manual:** Actions tab → "Release to TestFlight" → Run workflow (optionally
  set a build-number override).

The build number is the GitHub run number by default (monotonic), so successive
uploads always satisfy TestFlight's strictly-increasing requirement without
mutating committed files.

## How to upload metadata or submit for review

1. Obtain human approval for the exact screenshots, copy, and questionnaire
   answers.
2. Actions → "App Store Metadata and Submission" → `metadata`, with the target
   version. This uploads repository metadata and the five captured screenshots
   but cannot submit a build.
3. After a TestFlight build processes and release-candidate device QA passes,
   obtain explicit submission approval.
4. Run the same workflow with `submit`, the exact App Store version and processed
   build number, and confirmation `SUBMIT-MALA-<version>`.
5. The lane submits that existing build for review with `automatic_release:
   false`; public release remains a later human action.

## What is NOT automated

- **Apple App Review and public release.** Submission is approval-gated; Apple
  reviews the app, and public release remains manual.
- **App privacy nutrition label, age rating, export-compliance, pricing,
  territories, and legal agreements.** These remain human-reviewed App Store
  Connect gates. Repository automation does not infer their answers.
- **Product launch gates.** Public URLs, final assets, and release-candidate
  device QA gate the public release regardless of the pipeline.

## Verification status

- **Fact:** pipeline files are present and Ruby/YAML syntax was validated.
- **Verified 2026-08-06:** Build 2 was manually archived and uploaded through
  Xcode Organizer using the locally configured Apple account and signing assets.
  The API-key workflow was not used. GitHub automation remains deferred until
  `ASC_KEY_CONTENT` is added.
- **Implemented 2026-07-29:** the fresh-runner workflow passes
  `-authenticationKeyPath`, `-authenticationKeyID`, and
  `-authenticationKeyIssuerID` during both archive and export, alongside
  `-allowProvisioningUpdates` and the team ID. This follows Xcode's supported
  automatic-provisioning authentication path but remains `unverified` until the
  first real upload succeeds.
- **Implemented 2026-07-31:** `store_metadata` and `submit_review` lanes plus a
  manual-only workflow. The metadata lane cannot submit. The submission lane
  requires an exact confirmation phrase and processed build number and keeps
  automatic release off. Ruby syntax, workflow YAML, metadata lengths, and
  repository whitespace were validated locally; authenticated execution is
  still unverified.

## Potential improvements — Not Approved

- Add `fastlane match` (a private certs/profiles repo) instead of
  `-allowProvisioningUpdates` automatic signing, for fully reproducible signing
  across runners.
- Pin a specific Xcode 26 minor version if runner-image drift causes a
  reproducibility problem; the current workflow pins `macos-26` and enforces
  Xcode major version 26 or newer.
