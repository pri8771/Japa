---
id: DOC-JIRA-SYNC-PENDING
canonicalFor: jira-sync-record
status: active
lastVerified: 2026-07-17
readWhen:
  - checking which Jira issue tracks a given launch gate
related:
  - STATUS.md
supersedes: []
---

# Jira Sync — Complete

All 6 items below were **synced to Jira on 2026-07-17** once the Atlassian Rovo connector was reconnected. This file is retained as a record of the sync, not a pending queue.

**Jira project:** `JALA` (project id 10248, cloud `priyanshchordia-1779372280524.atlassian.net`)

**Date Recorded:** 2026-07-16 (synced 2026-07-17)  
**Related Prompt:** App Factory existing registration + onboarding; documentation/Notion/Jira update pass  
**Notion sync:** completed (Projects row + Tasks JAP-010..015)

---

## Live update history — 2026-07-17

Two earlier attempts this same day to read/update `project = JALA` returned `UNAUTHORIZED` / `oauth_token_invalid_grant` (connector needed reauthentication at the time). **Reauthentication has since completed.** A later session confirmed live read access (`project = JALA` returns all 6 issues) and successfully pushed the Change Mala / Dynamic Type / CI / design-audit verification update:

- `JALA-4` description and Current State field updated: Dynamic Type is now implemented and smoke-tested (was previously described as not implemented); VoiceOver human validation remains the open item.
- `JALA-1` (epic) received a progress comment covering the Change Mala picker ship, Dynamic Type, CI workflow, and the 3 design-audit fixes, with the 56/56 test result.

Local docs below were already accurate; this section is the connector-status log, kept for traceability rather than because the sync itself was blocked.

---

### EPIC — Japa App Factory onboarding / launch gates

- **Jira Key:** [JALA-1](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-1)
- **Jira Project:** JALA
- **Summary:** Japa existing-project App Factory registration and remaining launch gates
- **Description:** Register and govern `pri8771/Japa` under `pri8771/iOS_app_factory_rules` as an existing iOS app. v1 is implemented (~90%). Remaining work is content sign-off, device haptics, VoiceOver/accessibility user validation, and TestFlight/signing.
- **Acceptance Criteria:**
  - Registered existing project verified
  - Factory docs + FEAT-001/002/003 contracts present
  - Launch gate issues tracked and linked
- **Priority:** P1
- **Status:** in progress
- **Story Points:** 13
- **Estimated Time:** 20h
- **Actual Time:** ~6h (onboarding docs/registration + 2026-07-17 upgrade/reconciliation pass)
- **Estimated Start Date:** 2026-07-16
- **Actual Start Date:** 2026-07-16
- **Estimated End Date:** 2026-08-10
- **Actual End Date:**
- **Related Prompt:** Register existing + onboard; update Jira and Notion
- **Related Decision:** DEC-002, DEC-003, DEC-004
- **Related Files:** `.factory/`, `docs/`, `quality/feature-contracts/`
- **Suggested Issue Type:** Epic
- **Suggested Parent / Epic:**
- **Sync Action:** ~~create~~ **synced 2026-07-17**
- **Notion mirror:** [JAP-010](https://app.notion.com/p/39fab1f2276581cd8fdcf09e68bc2318)

---

### STORY — Content sign-off (B6)

- **Jira Key:** [JALA-2](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-2)
- **Jira Project:** JALA
- **Summary:** Seed mantra human content sign-off
- **Description:** Human-review bundled seed mantras for accuracy/respect before App Store submit. Record in `docs/CONTENT_REVIEW.md`.
- **Acceptance Criteria:** `CONTENT_REVIEW.md` signed; seed set approved
- **Priority:** P0
- **Status:** open
- **Story Points:** 2
- **Estimated Time:** 2h
- **Actual Time:**
- **Estimated Start Date:** 2026-07-17
- **Actual Start Date:**
- **Estimated End Date:** 2026-07-24
- **Actual End Date:**
- **Related Prompt:** onboarding
- **Related Decision:**
- **Related Files:** `docs/CONTENT_REVIEW.md`, `Japa/Content/SeedMantras.swift`
- **Suggested Issue Type:** Story
- **Suggested Parent / Epic:** Japa App Factory onboarding / launch gates
- **Sync Action:** ~~create~~ **synced 2026-07-17**
- **Notion mirror:** [JAP-011](https://app.notion.com/p/39fab1f227658199b1c0e226b50fc2f4)

---

### STORY — On-device haptic validation

- **Jira Key:** [JALA-3](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-3)
- **Jira Project:** JALA
- **Summary:** Validate eyes-free distinct completion haptic on ≥2 iPhone classes
- **Description:** Core differentiator cannot be proven in Simulator. Need device evidence + fallback path check.
- **Acceptance Criteria:** Distinctness confirmed; silent-mode OK; evidence in `quality/evidence/`
- **Priority:** P0
- **Status:** open
- **Story Points:** 3
- **Estimated Time:** 4h
- **Actual Time:**
- **Estimated Start Date:** 2026-07-17
- **Actual Start Date:**
- **Estimated End Date:** 2026-07-31
- **Actual End Date:**
- **Related Prompt:** onboarding
- **Related Decision:**
- **Related Files:** `Japa/Haptics/`, `LAUNCH_READINESS.md`
- **Suggested Issue Type:** Story
- **Suggested Parent / Epic:** Japa App Factory onboarding / launch gates
- **Sync Action:** ~~create~~ **synced 2026-07-17**
- **Notion mirror:** [JAP-012](https://app.notion.com/p/39fab1f2276581819283d529671910d8)

---

### STORY — Accessibility validation

- **Jira Key:** [JALA-4](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-4)
- **Jira Project:** JALA
- **Summary:** VoiceOver / Dynamic Type validation pass
- **Description:** Accessibility code exists; needs real-user validation for an eyes-free app.
- **Acceptance Criteria:** Round completable with VoiceOver; Dynamic Type usable; findings logged
- **Priority:** P1
- **Status:** open
- **Story Points:** 3
- **Estimated Time:** 4h
- **Actual Time:**
- **Estimated Start Date:** 2026-07-20
- **Actual Start Date:**
- **Estimated End Date:** 2026-08-03
- **Actual End Date:**
- **Related Prompt:** onboarding
- **Related Decision:**
- **Related Files:** `docs/BUGS.md`, practice views
- **Suggested Issue Type:** Story
- **Suggested Parent / Epic:** Japa App Factory onboarding / launch gates
- **Sync Action:** ~~create~~ **synced 2026-07-17**
- **Notion mirror:** [JAP-013](https://app.notion.com/p/39fab1f2276581589dd5c5ff118ed461)

---

### STORY — Signing + TestFlight / App Store prep

- **Jira Key:** [JALA-5](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-5)
- **Jira Project:** JALA
- **Summary:** Enable signing and prepare TestFlight / App Store
- **Description:** `project.yml` has `CODE_SIGNING_ALLOWED: NO` and empty team — blocks device evidence and distribution.
- **Acceptance Criteria:** Signed device build; TestFlight; metadata/screenshots/support URL drafted
- **Priority:** P0
- **Status:** open
- **Story Points:** 5
- **Estimated Time:** 6h
- **Actual Time:**
- **Estimated Start Date:** 2026-07-20
- **Actual Start Date:**
- **Estimated End Date:** 2026-08-10
- **Actual End Date:**
- **Related Prompt:** onboarding
- **Related Decision:**
- **Related Files:** `project.yml`, `docs/RELEASE_CHECKLIST.md`
- **Suggested Issue Type:** Story
- **Suggested Parent / Epic:** Japa App Factory onboarding / launch gates
- **Sync Action:** ~~create~~ **synced 2026-07-17**
- **Notion mirror:** [JAP-014](https://app.notion.com/p/39fab1f22765811cae2fcefe3eb82a41)

---

### TASK — Sync Jira issues and write keys back

- **Jira Key:** [JALA-6](https://priyanshchordia-1779372280524.atlassian.net/browse/JALA-6) — status **Done**
- **Jira Project:** JALA
- **Summary:** Create the above Jira issues and write keys back to docs
- **Description:** Execute Jira sync and mark this file entries synced with keys. Completed 2026-07-17; future live Jira updates require a valid Atlassian Rovo connection.
- **Acceptance Criteria:** Jira keys present; pending entries marked synced
- **Priority:** P2
- **Status:** blocked
- **Story Points:** 1
- **Estimated Time:** 1h
- **Actual Time:**
- **Estimated Start Date:** 2026-07-16
- **Actual Start Date:** 2026-07-16
- **Estimated End Date:** 2026-07-17
- **Actual End Date:**
- **Related Prompt:** onboarding
- **Related Decision:**
- **Related Files:** `docs/JIRA_SYNC_PENDING.md`
- **Suggested Issue Type:** Task
- **Suggested Parent / Epic:** Japa App Factory onboarding / launch gates
- **Sync Action:** ~~create~~ **synced and completed 2026-07-17**
- **Notion mirror:** [JAP-015](https://app.notion.com/p/39fab1f227658175af7eded79bbdd29d)
