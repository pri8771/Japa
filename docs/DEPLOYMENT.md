---
id: DOC-DEPLOYMENT
canonicalFor: release-deployment-process
status: active
lastVerified: 2026-07-27
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
| TestFlight automation (Fastlane `beta` lane + `release-testflight.yml`) | `implemented`, signing path requires correction/verification |
| End-to-end upload verified against App Store Connect | `unverified` — requires signing setup, the four secrets below, and one real run |
| App Store public submission automation | `planned` — not built; blocked on human gates |

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
  → GitHub Actions: release-testflight.yml (macos-latest)
    → brew install xcodegen; xcodegen generate
    → fastlane beta
      → app_store_connect_api_key   (unattended auth)
      → build_app                   (Release archive, app-store export,
                                     signing injected via xcargs)
      → upload_to_testflight        (processes on App Store Connect)
```

Files:

- `fastlane/Fastfile` — the `beta` lane (archive + upload).
- `fastlane/Appfile` — bundle identifier only; no Apple ID stored.
- `Gemfile` — declares `fastlane`; `Gemfile.lock` is committed (regenerated 2026-07-27 via `bundle install`) so `ruby/setup-ruby@v1`'s `bundler-cache: true` step in `release-testflight.yml` has a lockfile to restore instead of hard-failing before it can run anything.
- `.github/workflows/release-testflight.yml` — tag/dispatch-triggered runner.

## Required secrets

Configure these under **GitHub → Settings → Secrets and variables → Actions**.
Until all four exist, the workflow runs but fails fast.

| Secret | Value |
|---|---|
| `ASC_KEY_ID` | App Store Connect API key ID |
| `ASC_ISSUER_ID` | App Store Connect API issuer ID |
| `ASC_KEY_CONTENT` | base64 of `AuthKey_XXXX.p8` — `base64 -i AuthKey_XXXX.p8 \| pbcopy` |
| `DEVELOPMENT_TEAM` | Apple Developer team ID (`796XH483R4`) |

## One-time human setup (cannot be automated)

1. **Fact:** an Apple Developer Program membership is required.
2. Create an **App Store Connect API key**: App Store Connect → Users and Access
   → Integrations → Keys → App Store Connect API → generate a key with **App
   Manager** access. Download the `.p8` once and record the Key ID + Issuer ID.
3. Create the app record in App Store Connect for bundle id `com.priyansh.japa`
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

## What is NOT automated

- **Apple App Review.** The upload is automatic; public release still waits on
  Apple's human review.
- **App Store metadata / screenshots / privacy nutrition label.** Authored once
  in App Store Connect (or later via a `fastlane deliver` step). Tracked in MALA.
- **Product launch gates.** Public URLs, final assets, and release-candidate
  device QA gate the public release regardless of the pipeline.

## Verification status

- **Fact:** pipeline files are present and Ruby/YAML syntax was validated.
- **Fact:** the end-to-end TestFlight upload has **not** been run — no evidence
  exists yet. When the first real run succeeds, record it under
  `quality/evidence/` and flip the "End-to-end upload verified" row above to
  `verified`.
- **Known gap:** the current fresh-runner workflow does not install a signing
  certificate/private key or pass App Store Connect authentication flags to
  `xcodebuild`; `-allowProvisioningUpdates` and a team ID alone are not accepted
  as verified signing setup.

## Potential improvements — Not Approved

- Add `fastlane match` (a private certs/profiles repo) instead of
  `-allowProvisioningUpdates` automatic signing, for fully reproducible signing
  across runners.
- Add a `fastlane deliver` step to sync App Store metadata from the repo.
- Pin the Xcode version on the runner (`maxim-lobanov/setup-xcode`) once a
  minimum is chosen.
