---
id: DOC-JIRA-SYNC-PENDING
canonicalFor: pending-jira-sync-queue
status: active
lastVerified: 2026-07-17
readWhen:
  - syncing to Jira once Atlassian auth is available
related:
  - STATUS.md
supersedes: []
---

# Jira Sync Pending

Jira was **not updated** in this session. Atlassian MCP authentication is still required — no Jira/Atlassian connector is authorized in this environment; issue tools are unavailable until the user connects it (via claude.ai connector settings, or `/mcp` in an interactive session).

**Jira project:** `Jala` (confirmed by the user 2026-07-17 — previously unnamed in this doc; not yet verified to exist in Jira itself since no connector is available to query it).

**Date Recorded:** 2026-07-16 (project name added 2026-07-17)  
**Related Prompt:** App Factory existing registration + onboarding; documentation/Notion/Jira update pass  
**Notion sync:** completed (Projects row + Tasks JAP-010..015)

---

### EPIC — Japa App Factory onboarding / launch gates

- **Jira Project:** Jala
- **Summary:** Japa existing-project App Factory registration and remaining launch gates
- **Description:** Register and govern `pri8771/Japa` under `pri8771/iOS_app_factory_rules` as an existing iOS app. v1 is implemented (~85%). Remaining work is content sign-off, device haptics, a11y validation (incl. implementing Dynamic Type), and TestFlight/signing.
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
- **Sync Action:** create
- **Reason Pending:** auth unavailable
- **Notion mirror:** [JAP-010](https://app.notion.com/p/39fab1f2276581cd8fdcf09e68bc2318)

---

### STORY — Content sign-off (B6)

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
- **Jira Project:** Jala
- **Sync Action:** create
- **Reason Pending:** auth unavailable
- **Notion mirror:** [JAP-011](https://app.notion.com/p/39fab1f227658199b1c0e226b50fc2f4)

---

### STORY — On-device haptic validation

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
- **Jira Project:** Jala
- **Sync Action:** create
- **Reason Pending:** auth unavailable
- **Notion mirror:** [JAP-012](https://app.notion.com/p/39fab1f2276581819283d529671910d8)

---

### STORY — Accessibility validation

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
- **Jira Project:** Jala
- **Sync Action:** create
- **Reason Pending:** auth unavailable
- **Notion mirror:** [JAP-013](https://app.notion.com/p/39fab1f2276581589dd5c5ff118ed461)

---

### STORY — Signing + TestFlight / App Store prep

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
- **Jira Project:** Jala
- **Sync Action:** create
- **Reason Pending:** auth unavailable
- **Notion mirror:** [JAP-014](https://app.notion.com/p/39fab1f22765811cae2fcefe3eb82a41)

---

### TASK — Sync pending items once Atlassian auth works

- **Summary:** Create the above Jira issues and write keys back to docs
- **Description:** Execute sync after MCP auth completes; mark this file entries synced with keys.
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
- **Jira Project:** Jala
- **Sync Action:** create
- **Reason Pending:** auth unavailable
- **Notion mirror:** [JAP-015](https://app.notion.com/p/39fab1f227658175af7eded79bbdd29d)
