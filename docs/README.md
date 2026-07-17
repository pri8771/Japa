---
id: DOC-INDEX
canonicalFor: documentation-navigation
status: active
lastVerified: 2026-07-17
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
4. `STATUS.md`
5. `ARCHITECTURE.md`
6. Only the task-relevant documents below

## Canonical documents

| Topic | Canonical document | Authority |
|---|---|---|
| Project identity and type | `../.factory/project-context.json` | Machine-readable project classification |
| Standards and catalog versions | `../.factory/standard-lock.json` | Installed central versions |
| Repository navigation | `../.factory/repository-map.json` | Reading and location map |
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
| Reusable code | `REUSABLE_COMPONENTS.md` | Packages, local candidates, upstream work |
| Handoff | `HANDOFF.md` | Next-agent context |
| Prompt/change activity log | `PROMPT_LOG.md` | Working log of App-Factory-governance sessions — **not** a full project history (see gaps) |
| Pending external tracker sync | `JIRA_SYNC_PENDING.md` | Working queue of intended Jira state — **not** a record of actual Jira state (see gaps) |

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

Note: `RELEASE_CHECKLIST.md`'s checkboxes are currently unreconciled against `../LAUNCH_READINESS.md` §9 — see documentation gaps below before trusting either in isolation.

## Historical and superseded documents

| Document | Status | Superseded by | Reason retained |
|---|---|---|---|
| — | — | — | No document is currently historical or superseded. All documents listed above are live and current as of 2026-07-17 (verified during the App Factory registration-upgrade pass). |

## Documentation gaps

- **Test-count contradiction.** `../README.md` and `PROJECT_DOCUMENTATION.md` both say "41 unit/flow tests + 3 UI tests"; `STATUS.md` and `TEST_PLAN.md` say "46 unit/flow + 7 UI tests" (53 total). A live `xcodebuild test` run on 2026-07-17 (iPhone 17 Pro, iOS 26.5) confirms **53 passed, 0 failed** — `STATUS.md`/`TEST_PLAN.md` are correct. Already tracked as `BUGS.md` B-DOC; not yet corrected in the three stale documents.
- **Two bug-ID schemes.** `BUGS.md` (B6, B-SIGN, B-A11Y, B-HAPT, B-DOC, B-CI) and `../LAUNCH_READINESS.md` §7 (B1–B9 remapped to O1–O4 open / N1–N8 non-blocking) cover overlapping ground with no 1:1 mapping. `BUGS.md` B-SIGN has no LAUNCH_READINESS.md counterpart; LAUNCH_READINESS.md O3 (App Store metadata) has no BUGS.md counterpart. No single list is complete.
- **`RELEASE_CHECKLIST.md` vs `LAUNCH_READINESS.md` §9.** RELEASE_CHECKLIST.md shows nearly every box unchecked, including items independently confirmed done elsewhere (tests passing, no-network audit, no streak surfaces). LAUNCH_READINESS.md §9 already checks off the equivalent items and is the more accurate record; the two have not been reconciled.
- **Signing blocker missing from the launch spec.** `../LAUNCH_READINESS.md` (last touched 2026-06-30) does not mention `CODE_SIGNING_ALLOWED: NO` / empty `DEVELOPMENT_TEAM` in `project.yml`, which the newer 2026-07-16 App-Factory layer (`STATUS.md`, `RISKS.md` R4, `BUGS.md` B-SIGN) treats as an open high-priority blocker.
- **`BUGS.md` B-A11Y understates the accessibility gap.** It reads "VoiceOver / Dynamic Type coded but not user-validated." Source verification (2026-07-17) shows VoiceOver semantics are coded, but Dynamic Type is **not** implemented — `Japa/Design/Theme.swift` hard-codes fixed-point font sizes with no scaling. Corrected in `BUGS.md` during this pass.
- **`PROMPT_LOG.md`** contains exactly one entry (the 2026-07-16 App Factory onboarding session) and does not capture the sessions that built the v1 app itself. Treat it as a factory-governance activity log, not a full project history.
- **`JIRA_SYNC_PENDING.md`** explicitly states "Jira was not updated in this session" — it records intended future Jira state (5 items, all `Sync Action: create`), not actual Jira state. Supersede its entries once Atlassian MCP auth completes and real Jira keys are written back.
- **`STATUS.md` "External trackers"** references Notion tasks "JAP-004 Done; JAP-005 Ready" with no explanation in any read document of what those tasks are (unlike JAP-010–015, which `JIRA_SYNC_PENDING.md` explains). Minor traceability gap.
- **`CONTENT_REVIEW.md`** carries no "Date Recorded" line, unlike every other 2026-07-16-layer document — cannot independently confirm it reflects the current state of `Japa/Content/SeedMantras.swift`.
- **Feature contract completion-signaling gap.** `quality/feature-contracts/FEAT-001-practice-advance-undo-complete.json` did not, prior to 2026-07-17, state the eyes-free haptic/tone distinctness guarantee as an explicit requirement, and no automated test spies on `HapticFeedback`/`TonePlaying` to verify it. Extended in this pass; the test-coverage gap itself remains open — see the contract's `verificationGaps` field and `BUGS.md`.
