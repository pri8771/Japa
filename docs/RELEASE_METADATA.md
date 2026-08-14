---
id: DOC-RELEASE-METADATA
canonicalFor: app-store-metadata-and-public-page-copy
status: active
lastVerified: 2026-08-06
readWhen:
  - creating the App Store Connect record
  - publishing Mala public pages
  - capturing App Store screenshots
related:
  - RELEASE_CHECKLIST.md
  - DEPLOYMENT.md
  - ../Japa/PrivacyInfo.xcprivacy
supersedes: []
---

# Mala v1.0 Release Metadata

This is the canonical App Store product-page record and the copy for the two required public pages. It describes only verified v1 behavior. The privacy and support pages below were live-checked on 2026-07-29. The product-page fields and screenshots were entered in App Store Connect on 2026-08-06. Build 2 was submitted the same day and is Waiting for Review under submission `897d1493-c2f1-474f-afa6-01d3e92694c4`.

The uploadable copy is mirrored in `../fastlane/metadata/` and the five source
screenshots remain in `../AppStoreAssets/Screenshots/`. This document owns the
meaning; the Fastlane files are the deployment representation.

## Public URLs

- Privacy policy: `https://priyanshchordia.com/apps/mala/privacy/`
- Support: `https://priyanshchordia.com/apps/mala/support/`

The app links to both URLs from Settings. Both returned HTTP 200 and exposed `support@priyanshchordia.com` on 2026-07-29.

## App Store Connect record

| Field | Draft value | Notes |
|---|---|---|
| App name | Mala: A Quiet Digital Mala | Apple reported that the exact name `Mala` is already in use. This available 26-character name is saved in App Store Connect; the installed display name remains `Mala`. |
| Subtitle | A quiet digital mala | Within Apple's 30-character limit. |
| Bundle ID | `com.priyansh.mala` | Must match the archive and Apple registration. |
| SKU | `mala-ios-v1` | Internal, immutable once created; accountable human confirms before creation. |
| Primary category | Lifestyle | Avoids unsubstantiated health claims. |
| Secondary category | None | Optional; leave empty for v1. |
| Price | Free | Saved for all 175 available countries or regions; no IAP or StoreKit in v1. |
| Privacy policy URL | `https://priyanshchordia.com/apps/mala/privacy/` | Required for iOS; live-checked 2026-07-29. |
| Support URL | `https://priyanshchordia.com/apps/mala/support/` | Contains the public support email; live-checked 2026-07-29. |

## Product-page copy

### Promotional text

Count one bead at a time with a calm, local-first digital mala. Haptics keep your place; your practice stays private on your device.

### Description

Mala is a quiet digital mala for steady, distraction-free repetition practice.

Advance one bead at a time and keep your place with clear haptic feedback. Choose a round length that fits your practice, from a short sit to a full 108-bead mala. A distinct completion signal marks the end of each round.

Make it yours:

- Count without a label, or add your own private practice label.
- Choose from visual mala styles.
- Adjust haptic strength and the completion tone.
- Finish a round early and save your partial progress honestly.
- Pause and resume an in-progress round.
- Keep a simple on-device history, or clear it whenever you want.

Mala is local-first: no accounts, no ads, no analytics, and no network requests. Your practice stays on your device.

### Keywords

`mantra,meditation,prayer,counting,mala,breath,focus,practice,reflection`

### Review notes

Mala has no sign-in, purchase flow, ads, web content, or network functionality. The primary flow is: open the app, tap the main practice surface to advance the count, and use the top controls for label selection, History, and Settings. Tap Finish early to save a partial round and begin a fresh round. All user-created labels, preferences, in-progress state, and practice history remain on device.

## App privacy answers

The App Store Connect questionnaire is published as **“No, we do not collect data from this app.”** This matches Build 2 as audited: local persistence only, no analytics SDK, no advertising SDK, no account, and no network transmission. The privacy policy URL and published response were verified on 2026-08-06.

## Age rating and export compliance

- Apple's age-rating questionnaire was completed on 2026-08-06 and returned 4+ globally with Apple's displayed regional equivalents.
- Build 2 metadata reports **App Uses Non-Exempt Encryption: No**, consistent with `INFOPLIST_KEY_ITSAppUsesNonExemptEncryption: NO` in `project.yml`; no export documentation is requested.

## Screenshot set

Five portrait screenshots were finalized from the release candidate on 2026-08-06 using the iPhone 17 Pro Max simulator (iOS 26.5). The upload set is 1284 × 2778 with no alpha channel and is stored under `AppStoreAssets/Screenshots/en-US/6.5-inch/`. It uses shipping UI and deterministic local test data, with no device frames or overlaid marketing claims. App Store Connect accepted all five screenshots in the order below.

| Order | Screen state | Caption |
|---|---|---|
| 1 | Main practice surface with the explicit Finish early control | Keep your place, one bead at a time. |
| 2 | Completed round | A clear finish for every round. |
| 3 | Mantra selection with neutral Counting and a personal label | Practice your way. |
| 4 | Mala-style picker | A mala that fits your rhythm. |
| 5 | History with a deterministic completed local session showing 9m 0s | A quiet record of your practice. |

The upload set and its ordering were verified in App Store Connect on 2026-08-06.

## Privacy policy draft

**Effective date:** Set this when the page is published.

Mala is a local-first repetition-practice app. This policy explains how the Mala iOS app handles information.

### Information the app handles

Mala stores the practice labels you create, your preferences, your in-progress practice state, and your practice history locally on your device. This information is used only to provide the app's features.

### No collection or sharing

Mala does not create user accounts, collect personal information, use analytics or advertising SDKs, track you across apps or websites, or transmit your practice data to the developer or to third parties. Mala does not make network requests as part of its app functionality.

### Your choices

You can delete individual history entries, clear all history, and delete your custom labels from within the app. Deleting the app may remove locally stored app data according to your device and backup settings.

### Children

Mala does not knowingly collect personal information from children because it does not collect personal information from any user.

### Changes

If Mala's data practices change, this policy and the App Store privacy information will be updated before the changed version is released.

### Contact

For privacy questions, contact **support@priyanshchordia.com**.

## Support-page draft

# Mala Support

Mala is a local-first digital mala for quiet repetition practice.

## Help

- To begin, tap the practice surface to advance one bead.
- Use the controls at the top of the practice screen to choose a label, view history, or open Settings.
- In Settings, you can adjust the round size, haptic strength, completion tone, and mala style.
- Your history and custom labels are stored on your device. Use Settings to clear all history, or delete an individual entry from History.

## Contact

For help, feedback, or a privacy question, email **support@priyanshchordia.com**.

When you contact support, do not include sensitive personal information or your private practice labels unless it is necessary to explain the issue.

## Submission state

- App Review contact information saved successfully.
- Account-level Digital Services Act status is active as non-trader in all 27 EU regions.
- Privacy response is published as Data Not Collected.
- Version 1.0, Build 2 is Waiting for Review. Submitted 2026-08-06 at 11:40 PM by Priyansh Chordia; submission ID `897d1493-c2f1-474f-afa6-01d3e92694c4`.
- Public release remains manual after approval.
