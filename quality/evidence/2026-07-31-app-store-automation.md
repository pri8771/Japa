# App Store metadata and submission automation — 2026-07-31

## Scope

Added repository-backed English (U.S.) App Store metadata, screenshot staging,
and a manual-only GitHub Actions workflow with separate metadata and submission
paths.

## Safety properties

- `store_metadata` sets `skip_binary_upload: true` and
  `submit_for_review: false`.
- `submit_review` selects an exact `APP_VERSION` and `BUILD_NUMBER`, skips
  binary/metadata/screenshot upload, sets `submit_for_review: true`, and sets
  `automatic_release: false`.
- The workflow has no push or tag trigger.
- The submission path requires `SUBMIT-MALA-<version>` exactly before Fastlane
  runs.
- App privacy, age rating, export compliance, price, territories, agreements,
  public release, and final public claims remain human gates.

## Local verification

- `ruby -c fastlane/Fastfile` → `Syntax OK`.
- Ruby/Psych parsed `.github/workflows/release-app-store.yml`.
- Ruby/JSON parsed `.factory/repository-map.json`.
- Aligned `quality/quality-manifest.json`'s application name with the canonical
  `Mala` project identity so the registration verifier remains consistent.
- Fastlane 2.230.0's installed `deliver/options.rb` contains the used
  `build_number`, `skip_binary_upload`, `overwrite_screenshots`,
  `automatic_release`, and `precheck_include_in_app_purchases` options.
- App Store field lengths: name 4, subtitle 20, promotional text 132, keywords
  71 bytes.
- `git diff --check` passed.
- Full app suite independently passed on the same worktree before this
  release-only change: 67 passed, 0 failed, 0 skipped on iPhone 17 Pro / iOS
  26.5 simulator.

## Limitations

- No App Store Connect request, metadata upload, TestFlight upload, review
  submission, or public release was executed.
- A full `fastlane lanes` startup under the host's legacy system Ruby was
  interrupted while loading Fastlane's global Google/Android dependencies. The
  Fastfile itself passed Ruby syntax, and used action parameters were verified
  against the locked Fastlane 2.230.0 source. CI uses Ruby 3.3.
- Authenticated end-to-end verification requires the missing
  `ASC_KEY_CONTENT` secret, the App Store Connect app record, and explicit human
  approval.
