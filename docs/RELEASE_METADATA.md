---
id: DOC-RELEASE-METADATA
canonicalFor: app-store-metadata-and-public-page-copy
status: draft
lastVerified: 2026-07-29
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

This is the canonical draft for the App Store product page and the two required public pages. It describes only verified v1 behavior. The privacy and support pages below were live-checked on 2026-07-29.

## Public URLs

- Privacy policy: `https://priyanshchordia.com/apps/mala/privacy/`
- Support: `https://priyanshchordia.com/apps/mala/support/`

The app links to both URLs from Settings. Both returned HTTP 200 and exposed `support@priyanshchordia.com` on 2026-07-29.

## App Store Connect record

| Field | Draft value | Notes |
|---|---|---|
| App name | Mala | Within Apple's 30-character limit. |
| Subtitle | A quiet digital mala | Within Apple's 30-character limit. |
| Bundle ID | `com.priyansh.japa` | Must match the archive. |
| SKU | `mala-ios-v1` | Internal, immutable once created; accountable human confirms before creation. |
| Primary category | Lifestyle | Avoids unsubstantiated health claims. |
| Secondary category | None | Optional; leave empty for v1. |
| Price | Free | No IAP or StoreKit in v1. |
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
- Pause and resume an in-progress round.
- Keep a simple on-device history, or clear it whenever you want.

Mala is local-first: no accounts, no ads, no analytics, and no network requests. Your practice stays on your device.

### Keywords

`mantra,meditation,prayer,counting,mala,breath,focus,practice,reflection`

### Review notes

Mala has no sign-in, purchase flow, ads, web content, or network functionality. The primary flow is: open the app, tap the main practice surface to advance the count, and use the top-right controls for label selection, history, and Settings. All user content and practice history remain on device.

## App privacy answers

Choose **“No, we do not collect data from this app”** only if the submitted build remains as audited: local persistence only, no analytics SDK, no advertising SDK, no account, and no network transmission. Reconfirm this at submission after any dependency or feature change.

## Age rating and export compliance

- Complete Apple's current age-rating questionnaire honestly in App Store Connect. The expected outcome is the lowest available rating because v1 contains no bundled spiritual text, user-generated sharing, mature content, or web access; Apple determines the final rating from the questionnaire.
- Complete the export-compliance questions for the archived build. Do not pre-answer this from this document; confirm against the build and Apple's current questionnaire.

## Screenshot set

Five portrait screenshots were captured from the release candidate on 2026-07-27 using the iPhone 17 Pro Max simulator (iOS 26.5). Each source PNG is 1320 × 2868, has no alpha channel, and is stored under `AppStoreAssets/Screenshots/en-US/6.9-inch/`. They use shipping UI and deterministic local test data, with no device frames or overlaid marketing claims.

| Order | Screen state | Caption |
|---|---|---|
| 1 | Main practice surface, classic mala, early in a short round | Keep your place, one bead at a time. |
| 2 | Completed round | A clear finish for every round. |
| 3 | Mantra selection with neutral Counting and a personal label | Practice your way. |
| 4 | Mala-style picker | A mala that fits your rhythm. |
| 5 | History with a completed local session | A quiet record of your practice. |

The raw set is technically ready for upload. Final human approval of the images and their ordering remains part of the App Store Connect submission gate.

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

## Release evidence to collect

- Final App Store Connect field values and privacy-answer screenshots
- Final human approval and App Store Connect upload of the captured screenshot set
- TestFlight processing and device-QA evidence
