---
id: DOC-GOVERNANCE
canonicalFor: repository-authority-and-external-mirror-policy
status: active
lastVerified: 2026-07-29
readWhen:
  - planning or assigning work
  - updating Jira, Notion, or Studio OS
  - resolving conflicting project information
  - changing scope, status, estimates, or completion
related:
  - README.md
  - STATUS.md
  - DECISIONS.md
supersedes: []
---

# Repository Authority and External Mirrors

## Authority

The code, configuration, contracts, evidence, and canonical documents committed
to this repository are the source of truth for Mala.

The authoritative document for each topic is listed in `docs/README.md` and
`.factory/repository-map.json`. Jira, Notion, Studio OS, dashboards, and agent
chat history are external mirrors and convenience views. They are not separate
authorities and cannot redefine repository facts.

## Synchronization direction

Synchronization is repository-first:

```text
verified code / evidence / canonical repo document
  → Jira work item and status mirror
  → Notion planning and knowledge mirror
  → Studio OS portfolio/index mirror
```

An external event that occurs outside the repository, such as an App Store
Connect status change or a human approval, becomes canonical only after its
outcome and evidence are recorded in the applicable repository document.

## Topic ownership inside the repository

| Topic | Repository authority |
|---|---|
| Product scope and acceptance criteria | `LAUNCH_READINESS.md` and feature contracts |
| Current priorities, progress, and blockers | `docs/STATUS.md` |
| Release gates | `docs/RELEASE_CHECKLIST.md` |
| Bugs and defects | `docs/BUGS.md` |
| Decisions and scope changes | `docs/DECISIONS.md` |
| Risks and assumptions | `docs/RISKS.md` and `docs/ASSUMPTIONS.md` |
| Test requirements and verified counts | `docs/TEST_PLAN.md` and `quality/evidence/` |
| Architecture and implemented behavior | `docs/ARCHITECTURE.md`, source, and feature contracts |
| App Store copy and public URLs | `docs/RELEASE_METADATA.md` |
| Deployment process | `docs/DEPLOYMENT.md` |

## Jira and Notion usage

Jira and Notion remain useful for:

- board, calendar, and filtered views;
- assignments and execution-agent routing;
- estimates, remaining time, and worklogs;
- dependencies, parallel-work coordination, and human gates;
- searchable copies of decisions, research, lessons, and evidence links.

Those values are operational mirrors. If an estimate, date, assignment, risk,
decision, or status materially affects the project, update the applicable
canonical repository document in the same work unit.

Every mirrored work item should link back to the relevant repository document,
contract, commit, or evidence artifact. A Jira or Notion item may be more
detailed for operational convenience, but it must not contradict or expand the
approved repository scope.

## Conflict resolution

When repository and external trackers disagree:

1. Treat the repository as authoritative.
2. Verify the repository claim against code, tests, evidence, and human gates.
3. Correct Jira, Notion, and Studio OS to match.
4. Record the reconciliation if the mismatch affected delivery or caused a
   mistake.
5. Do not modify repository scope or mark work complete merely to match an
   external tracker.

## Completion rule

Work is complete only when the requested change and required verification are
represented in the repository. Tracker status changes follow that repository
update. A Jira or Notion `Done` state by itself is not completion evidence.

