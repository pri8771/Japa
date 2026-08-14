---
id: DOC-MARKETING-LANDING-PAGE-TASKS
canonicalFor: mala-landing-page-icon-and-waitlist-work
status: planned
lastVerified: 2026-08-03
readWhen:
  - designing or implementing the Mala marketing page
  - selecting a new icon candidate
  - capturing website screenshots
  - configuring the waitlist
related:
  - RELEASE_METADATA.md
  - RELEASE_CHECKLIST.md
  - STATUS.md
supersedes: []
---

# Mala landing page, icon, and waitlist tasks

Public route: `https://priyanshchordia.com/products/mala/`

## Outcome

Publish an honest, accessible Mala marketing page with a selected new icon
direction, real candidate screenshots, and an app-specific HubSpot waitlist.
Japa remains the internal repository/engine identity; **Mala** is the public
shipping identity.

The local Claude Design package is
`/Users/pchordia/Documents/claude-design-handoff-five-apps-2026-08-03.zip`.
It includes the current icon and five real screenshots. Claude Design is asked
for three complete Mala concepts and three corresponding icon candidates as
part of 15 total portfolio concepts. Generated concepts are not approvals.

## Product truth

- Positioning: a quiet digital mala for steady, distraction-free repetition.
- Market tactile counting, interruption-safe progress, private labels, local
  history, visual mala styles, and local-first privacy.
- Do not claim cloud sync, accounts, social features, analytics, streaks,
  medical outcomes, or public App Store availability.

## Task index

| ID | Task | Status | Depends on | Completion evidence |
|---|---|---|---|---|
| MALA-LP-001 | Reconcile landing claims with exact TestFlight candidate and release metadata | ready | candidate identity | Build/SHA claim matrix |
| MALA-LP-002 | Produce 3 complete clickable concepts and 3 icon candidates | ready | handoff ZIP | Ingestion report, diversity matrix, prototypes, icon board |
| MALA-LP-003 | Review product clarity, accessibility, originality, and static-site feasibility | blocked | MALA-LP-002 | Recorded dispositions and selected direction |
| MALA-LP-004 | Confirm supplied screenshots or recapture from selected exact candidate | blocked | selected direction, candidate | Shot manifest, checksums, device/build provenance |
| MALA-LP-005 | Finalize copy and limitations | blocked | MALA-LP-001 | Approved copy deck |
| MALA-LP-006 | Select and production-test an icon candidate | blocked | MALA-LP-003 | Owner approval, small-size, opacity, uniqueness checks |
| MALA-LP-007 | Approve portfolio privacy and Mala waitlist consent | blocked | HubSpot configuration, privacy owner | Disclosure, retention/deletion, consent approval |
| MALA-LP-008 | Deliver selected assets/copy to website repository | blocked | MALA-LP-004 through MALA-LP-007 | Versioned public-only handoff manifest |
| MALA-LP-009 | Verify page and waitlist | blocked | website implementation | Responsive/a11y/form/privacy/link evidence |
| MALA-LP-010 | Approve publication | blocked | MALA-LP-009 | Exact website commit and owner approval |

## Screenshot baseline

The supplied 1320×2868 images cover practice, completion, a personal label,
mala-style selection, and history. Before publication, compare every image with
the exact selected candidate and release copy. Do not retouch UI facts. Record
build, source SHA, device, capture method, checksum, and approval.

## Waitlist contract

Require email and Mala-specific consent. First name and device/testing interest
are optional. Hidden context may include `app_slug=mala`, page/source, and UTM
values. Do not enroll the contact in other app lists without separate consent.
Verify validation, submitting, success, duplicate, service-error, and email
fallback states.

## Done means

The track is done only after selected real assets and copy match the exact
candidate, icon and privacy approvals are recorded, the page and HubSpot path
pass responsive/accessibility/error-state checks, deployment is tied to an
exact website commit, and the owner approves publication.

## Website implementation update — 2026-08-03

The canonical website now implements Thread of 108, Eyes Closed, and Bead
Ledger as three persistent/query-addressable Mala directions with responsive
layouts and CSS-rendered icon previews. Automated checks and desktop/mobile
selector checks pass. The existing real screenshot set has not yet been tied
to these public layouts; exact-candidate screenshot approval, production icon
approval, HubSpot consent/form states, deployment evidence, and publication
approval remain open. The current CTA discloses an email fallback.
