---
id: DOC-INDEX
canonicalFor: documentation-navigation
status: active
lastVerified: 2026-07-29
readWhen:
  - onboarding
  - locating authoritative project information
related:
  - ../.factory/repository-map.json
supersedes: []
---

# Documentation Index

## Purpose

Use this index to find the smallest authoritative set of documents for the current task. Do not read every document by default.

## Two-minute project context

Read in order:

1. `../AGENTS.md`
2. `../.factory/repository-map.json`
3. `../.factory/project-context.json`
4. `GOVERNANCE.md`
5. `STATUS.md`
6. `ARCHITECTURE.md`
7. Only the task-relevant documents below

## Canonical documents

| Topic | Canonical document | Authority |
|---|---|---|
| Project identity and type | `../.factory/project-context.json` | Machine-readable project classification |
| Standards and catalog versions | `../.factory/standard-lock.json` | Installed central versions |
| Repository navigation | `../.factory/repository-map.json` | Reading and location map |
| Repository authority and external mirrors | `GOVERNANCE.md` | Source precedence, synchronization, conflict resolution, completion |
| Product overview | `../README.md` | Front-door summary; defers scope detail to LAUNCH_READINESS.md |
| Launch scope and readiness | `../LAUNCH_READINESS.md` | Self-declared authoritative PRD, MVP acceptance criteria, launch checklist |
| Detailed cross-functional documentation | `PROJECT_DOCUMENTATION.md` | Product/Design/Frontend/Backend/Business/Marketing/UA/Execution/QA/Legal/Operations template, mirrored to Notion |
| Content review | `CONTENT_REVIEW.md` | Seed mantra tradition/gloss review + human sign-off gate |
| Current status | `STATUS.md` | Current progress, blockers, verification |
| Current architecture | `ARCHITECTURE.md` | Implemented architecture, not proposals |
| Feature inventory | `FEATURES.md` | Current feature status |
| Required feature behavior | `../quality/feature-contracts/` | Acceptance and state contracts |
| Current bugs | `BUGS.md` | Known defects and unverified behavior |
| Decisions | `DECISIONS.md` | Approved product and architecture decisions |
| Risks | `RISKS.md` | Active risks and mitigations |
| Assumptions | `ASSUMPTIONS.md` | Unconfirmed facts |
| Testing | `TEST_PLAN.md` | Commands, environments, and required scenarios |
| Release readiness | `RELEASE_CHECKLIST.md` | Release gates |
| App Store metadata and public-page copy | `RELEASE_METADATA.md` | Draft product-page, privacy, support, and screenshot content |
| Deployment / release process | `DEPLOYMENT.md` | How builds reach TestFlight/App Store (Fastlane + CI) |
| Reusable code | `REUSABLE_COMPONENTS.md` | Packages, local candidates, upstream work |
| Handoff | `HANDOFF.md` | Next-agent context |
| Prompt/change activity log | `PROMPT_LOG.md` | Working log of App-Factory-governance sessions — **not** a full project history (see gaps) |
| Historical external tracker migration | `JIRA_SYNC_PENDING.md` | Historical migration record — **not** current project authority or current Jira state |

## Task-based reading routes

### Implement or change a feature

Read:

1. `STATUS.md`
2. `ARCHITECTURE.md`
3. the relevant feature contract;
4. `DECISIONS.md` when the change crosses a locked decision;
5. `TEST_PLAN.md` for applicable verification.

See also the finer-grained routes in `../.factory/repository-map.json` (`change-core-practice`, `change-persistence`, `change-haptics`, `change-audio`, `change-content`, `change-ui`).

### Fix a bug

Read:

1. `BUGS.md`
2. the relevant feature contract;
3. `ARCHITECTURE.md`;
4. `TEST_PLAN.md`.

### Add infrastructure or a dependency

Read:

1. `../.factory/library-catalog.json`
2. `REUSABLE_COMPONENTS.md`
3. `ARCHITECTURE.md`
4. `DECISIONS.md`
5. the applicable central dependency and modular-library standards.

### Prepare a release

Read:

1. `STATUS.md`
2. `TEST_PLAN.md`
3. `RELEASE_CHECKLIST.md`
4. current bugs, risks, and waivers.

`RELEASE_CHECKLIST.md`'s checkboxes must be reconciled against verified repository evidence. Jira and Notion mirror this state but do not define it.

### Deploy to TestFlight

Read:

1. `DEPLOYMENT.md` — the pipeline, required secrets, and one-time setup;
2. `../fastlane/Fastfile` and `../.github/workflows/release-testflight.yml` — the automation;
3. `DECISIONS.md` DEC-005 — the signing/auth decision.

## Historical and superseded documents

| Document | Status | Superseded by | Reason retained |
|---|---|---|---|
| — | — | — | No document is currently historical or superseded. All documents listed above are live and current as of 2026-07-18. `LAUNCH_READINESS.md` and `PROJECT_DOCUMENTATION.md` now defer to `STATUS.md`/`TEST_PLAN.md` for volatile status, counts, and dates rather than restating them. |

## Documentation gaps

- **Resolved 2026-07-18: dual-PRD / duplicated-status overlap.** `../LAUNCH_READINESS.md` (PRD/launch scope) and `PROJECT_DOCUMENTATION.md` (cross-functional overview, mirrored to Notion) previously restated test counts, production-readiness, and verification dates, and had drifted (56/56 vs. the current 62). Both now carry metadata blocks and **defer to `STATUS.md` (current status) and `TEST_PLAN.md` (counts)** instead of restating them. Single source of truth for the suite count is `TEST_PLAN.md`.
- **Resolved 2026-07-17 (count re-based 2026-07-18): test-count contradiction.** Earlier docs disagreed on the suite size. Canonical current count lives in `TEST_PLAN.md` (**52 unit/flow + 10 UI = 62**), with the latest verified run recorded in `STATUS.md`. Other docs link to those rather than hardcoding numbers.
- **Resolved 2026-07-17: release-checklist drift.** `RELEASE_CHECKLIST.md` was reconciled against `../LAUNCH_READINESS.md` §9 and the live build/test evidence.
- **Resolved 2026-07-17: signing blocker missing from launch spec.** `../LAUNCH_READINESS.md` now tracks signing/TestFlight as O5, matching `BUGS.md` B-SIGN and `RISKS.md` R4.
- **Resolved 2026-07-17: `BUGS.md` B-A11Y understated the accessibility gap.** Source verification showed VoiceOver semantics are coded, but Dynamic Type is **not** implemented; `BUGS.md` and `../LAUNCH_READINESS.md` now state that accurately.
- **Superseded tracker history:** `JALA` and then `JAPA` were earlier trackers. Project **`MALA`** is the current Jira mirror, while repository documents remain authoritative. `JIRA_SYNC_PENDING.md` is retained only as historical migration context.
- **Mostly resolved 2026-07-17: two bug-ID schemes.** `BUGS.md` and `../LAUNCH_READINESS.md` now both include content sign-off, signing/TestFlight, accessibility/Dynamic Type, haptics, and CI/documentation status. Keep both lists aligned when adding or closing launch gates.
- **`PROMPT_LOG.md`** contains exactly one entry (the 2026-07-16 App Factory onboarding session) and does not capture the sessions that built the v1 app itself. Treat it as a factory-governance activity log, not a full project history.
- **`STATUS.md` "External trackers"** references Notion tasks "JAP-004 Done; JAP-005 Ready" with no explanation in any read document of what those tasks are (unlike JAP-010–015, which `JIRA_SYNC_PENDING.md` explains). Minor traceability gap.
- **Resolved 2026-07-17: `CONTENT_REVIEW.md` date metadata.** `CONTENT_REVIEW.md` now records its original date and latest verification date. The human sign-off itself remains open.
- **Feature contract completion-signaling gap.** `quality/feature-contracts/FEAT-001-practice-advance-undo-complete.json` now states the eyes-free haptic/tone distinctness guarantee as an explicit requirement, but no automated test spies on `HapticFeedback`/`TonePlaying` to verify it. The test-coverage gap itself remains open — see the contract's `verificationGaps` field and `BUGS.md`.
