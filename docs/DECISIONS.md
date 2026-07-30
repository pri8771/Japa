---
id: DOC-DECISIONS
canonicalFor: approved-decisions
status: active
lastVerified: 2026-07-30
readWhen:
  - a change crosses a previously locked decision
related:
  - STATUS.md
supersedes: []
---

# Decisions

## DEC-001 — Project registration

- **Status:** accepted
- **Date Recorded:** 2026-07-16
- **Context:** This repository is governed by the App Factory standards.
- **Decision:** Use `.factory/project-context.json` as the authoritative project classification marker.
- **Consequences:** Agents must read the registration and quality files before coding.

## DEC-002 — Register as existing project

- **Status:** accepted
- **Date Recorded:** 2026-07-16
- **Actual Start Date:** 2026-07-16
- **Actual End Date:** 2026-07-16
- **Context:** Japa already has a built SwiftUI app, tests, and launch docs. User requested App Factory registration via `bootstrap-project.sh --mode existing`.
- **Options Considered:** `new` scaffold vs `existing` registration
- **Decision:** Register as `existing` with lifecycle `onboarding_existing`; do not re-scaffold.
- **Consequences:** Preserve working engine/practice/persistence behavior; introduce contracts and evidence incrementally.
- **Related Prompt:** App Factory existing registration + onboarding
- **Related Files:** `.factory/project-context.json`, `AGENTS.md`, `quality/quality-manifest.json`

## DEC-003 — Platforms = iOS only (not iPadOS)

- **Status:** accepted
- **Date Recorded:** 2026-07-16
- **Context:** Bootstrap initially used `--platforms ios,ipados`, but `project.yml` uses `TARGETED_DEVICE_FAMILY = 1` and v1 explicitly excludes iPad layout.
- **Options Considered:** Keep ipados registration and add iPad support; align registration to iPhone-only reality
- **Decision:** Align factory registration and quality manifest to **`ios` only**. iPad remains out of scope for v1.
- **Consequences:** Agents must not claim iPad support or require responsive iPad layout tests as ship criteria for v1.
- **Related Files:** `.factory/project-context.json`, `.factory/standard-lock.json`, `quality/quality-manifest.json`, `project.yml`

## DEC-004 — Upgrade to standard 0.4.0 and close registration gap

- **Status:** accepted
- **Date Recorded:** 2026-07-17
- **Context:** Central standard advanced 0.2.0 → 0.4.0 (0.3.0 added the library-catalog layer, 0.4.0 added the repository-map + `docs/README.md` navigation layer). `bootstrap-project.sh` refuses to re-run against an already-registered project (`.factory/project-context.json` present → exit 3), so the gap had to be closed manually rather than via the automated bootstrap script.
- **Options Considered:** Leave Japa on 0.2.0; manually reconcile the 4 missing files (`.factory/repository-map.json`, `.factory/library-catalog.json`, `docs/README.md`, `docs/REUSABLE_COMPONENTS.md`) and bump versions; open a PR to add an "upgrade" mode to the central bootstrap tooling first and block on it.
- **Decision:** Manually reconcile Japa to 0.4.0 now (non-destructive — only added missing files/fields, never overwrote Japa-specific facts); flag the missing "upgrade an already-registered project" bootstrap mode as a global gap candidate for the central repository rather than block this registration on it.
- **Consequences:** Japa's `.factory/standard-lock.json`, `quality/quality-manifest.json`, and `.factory/project-context.json` now declare `0.4.0`. Future re-onboarding prompts against Japa should treat it as fully registered at 0.4.0, not re-run bootstrap.
- **Related Files:** `.factory/standard-lock.json`, `.factory/project-context.json`, `.factory/repository-map.json`, `.factory/library-catalog.json`, `quality/quality-manifest.json`, `docs/README.md`, `docs/REUSABLE_COMPONENTS.md`

## DEC-005 — TestFlight deployment via Fastlane + App Store Connect API key, without changing project.yml signing

- **Status:** accepted
- **Date Recorded:** 2026-07-18
- **Context:** The user asked for automatic deployment to TestFlight, reusable across apps. Distribution requires real code signing, but DEC (JAPA-9, working agreement) deliberately keeps `project.yml` shipping `CODE_SIGNING_ALLOWED: NO` so the simulator CI (`ios-ci.yml`) stays green and the repo is not tied to an Apple team. The device-install flow already overrides signing at the command line (team `796XH483R4`, automatic provisioning).
- **Options Considered:** (a) flip `project.yml` to committed signing (rejected — breaks simulator CI, ties repo to the team, contradicts JAPA-9); (b) Xcode Cloud (rejected for now — less portable, not "works for any app" off-GitHub); (c) `fastlane match` with a private certs repo (more reproducible but adds a second repo + `MATCH_PASSWORD` setup — deferred as a hardening option); (d) **Fastlane `beta` lane authenticated by an App Store Connect API key, injecting distribution signing only at archive time via `xcargs` + `-allowProvisioningUpdates`, triggered by a tag/dispatch GitHub Actions workflow.**
- **Decision:** Option (d). `project.yml` is unchanged; signing is applied only inside the archive step, mirroring the existing device-install override. Authentication uses an ASC API key (no Apple ID/2FA) so runs are unattended. Build number = CI run number (monotonic).
- **Consequences:** `ios-ci.yml` simulator build/test is unaffected. Public release still waits on Apple App Review and the human launch gates (JAPA-6/8/9). The pipeline is `implemented` but the end-to-end TestFlight upload is `unverified` until the four secrets (`ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_CONTENT`, `DEVELOPMENT_TEAM`) are configured and one real run is recorded under `quality/evidence/`.
- **Related Prompt:** Automatic TestFlight deployment + doc reconciliation to App Factory standard
- **Related Files:** `fastlane/Fastfile`, `fastlane/Appfile`, `Gemfile`, `.github/workflows/release-testflight.yml`, `docs/DEPLOYMENT.md`, `docs/RELEASE_CHECKLIST.md`

## DEC-006 — Use support@priyanshchordia.com as the Mala public support contact

- **Status:** accepted
- **Date Recorded:** 2026-07-28
- **Context:** The App Store support URL and privacy policy require a real public contact path. The canonical page drafts still contained an unpublished-email placeholder.
- **Options Considered:** A personal mailbox; a product-specific mailbox; `support@priyanshchordia.com`.
- **Decision:** Publish `support@priyanshchordia.com` on both Mala public pages and use it for App Store support and privacy inquiries.
- **Consequences:** The mailbox or forwarding rule must be configured and tested before the URLs are marked live. Both pages should use a `mailto:support@priyanshchordia.com` link. If the address changes, update the public pages, App Store Connect, and `docs/RELEASE_METADATA.md` together.
- **Related Files:** `docs/RELEASE_METADATA.md`, `docs/RELEASE_CHECKLIST.md`

## DEC-007 — Repository documents are authoritative; external tools are mirrors

- **Status:** accepted
- **Date Recorded:** 2026-07-29
- **Context:** Jira and Notion improve assignment, time tracking, filtering, and visibility, but tracker state drifted from verified code and repository documents. Studio OS also described its product record as authoritative, creating conflicting ownership.
- **Options Considered:** Jira as execution source of truth; Notion as project source of truth; multiple equal authorities; repository-first authority with external mirrors.
- **Decision:** Code, evidence, feature contracts, and canonical documents committed to the product repository are the source of truth. Jira, Notion, Studio OS, dashboards, and chat history are external mirrors and convenience views.
- **Consequences:** Synchronization flows from verified repository state outward. Material external events must be recorded in the applicable repository document. Conflicts are resolved by verifying repository evidence and correcting mirrors. Tracker status alone cannot change scope or prove completion.
- **Related Files:** `AGENTS.md`, `.factory/AGENTS.factory.md`, `.factory/repository-map.json`, `docs/GOVERNANCE.md`, `docs/README.md`, `docs/STATUS.md`

## DEC-008 — Use the product-branded App Store bundle identifier

- **Status:** accepted
- **Date Recorded:** 2026-07-30
- **Context:** Before the first App Store Connect or TestFlight upload, the user chose a product-branded bundle identifier rather than retaining the original internal project name in the public release identity.
- **Options Considered:** Retain `com.priyansh.japa`; change the release bundle to `com.priyansh.mala` while preserving compatibility-sensitive internal target, scheme, engine, and persistence-directory names.
- **Decision:** Use `com.priyansh.mala` for the shipping app, with matching test-target and UI-automation identifiers. Preserve the internal `Japa` target/scheme and persistence directory.
- **Consequences:** Apple must accept and register `com.priyansh.mala` before the first upload. Development builds under the former bundle identifier use a different app sandbox and do not share local history with the new identifier; no customer migration is required because the app has not shipped.
- **Related Files:** `project.yml`, `fastlane/Appfile`, `quality/ui/`, `docs/ARCHITECTURE.md`, `docs/RELEASE_METADATA.md`, `docs/DEPLOYMENT.md`
