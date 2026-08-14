---
id: DOC-PROJECT-DOCUMENTATION
canonicalFor: cross-functional-overview
status: active
lastVerified: 2026-08-03
readWhen:
  - needing the cross-functional (product/design/eng/business/legal/ops) overview
related:
  - ../LAUNCH_READINESS.md
  - STATUS.md
  - TEST_PLAN.md
supersedes: []
---

# Mala — Project Documentation

_Cross-functional overview, mirrored to the Notion App Factory Command Center. Product scope and acceptance criteria are owned by [`../LAUNCH_READINESS.md`](../LAUNCH_READINESS.md); current status, test counts, and verification dates by [`STATUS.md`](STATUS.md) and [`TEST_PLAN.md`](TEST_PLAN.md). This document links to them rather than restating them._

> **Implementation status: v1 in TestFlight beta.** Build 2, containing explicit Finish early and the current fixes, was uploaded manually, processed to `Ready to Submit`, and confirmed working through TestFlight on 2026-08-06. The repository contains a building, tested SwiftUI app: a pure `JapaEngine` with the frozen contract and a passing unit-test suite, the eyes-free haptic practice screen, explicit Finish early with honest partial-session recording, a distinct completion haptic + synthesized gentle tone, interruption-safe local persistence, neutral Counting plus private custom labels, a quiet non-gamified history, settings, Dynamic Type support, CI and optional TestFlight deployment automation, a 21-style Change Mala picker with Classic as the default, an app icon, and a truthful `PrivacyInfo.xcprivacy`. **Current test counts, verification dates, and production-readiness live in [`STATUS.md`](STATUS.md) and [`TEST_PLAN.md`](TEST_PLAN.md), not here.** Remaining to ship: human approval/upload of App Store metadata and refreshed screenshots, questionnaires, and App Review. [`../LAUNCH_READINESS.md`](../LAUNCH_READINESS.md) is the authoritative spec.

GitHub is the source of truth for this project documentation. Notion indexes this file in the Priyansh App Factory Command Center.

## 00. Executive Summary
Mala is a local-first iOS app for *japa* — the repetition of a mantra a fixed number of times (classically 108, one full *mala*). The single differentiator that justifies a standalone app is **eyes-free, interruption-safe, haptic-confirmed repetition with an unmistakable end-of-round signal**: the user advances bead-by-bead without looking, each advance is confirmed by a crisp haptic, the place is preserved across interruptions, and reaching the target (the 108th/chosen bead) fires a **distinct completion haptic plus a gentle tone**. A digital mala that merely "counts to 108" is strictly worse than a physical mala and must not ship — the eyes-free, look-down-free feel is the product. The v1 end product is one tactile practice screen, a neutral counting mode plus private user-created labels, session completion, and a simple quiet history. Local-first storage, no backend, no accounts.

## 01. Product
**v1 MVP scope (corrected):** repetition engine (count + place-keeping + distinct round-completion), eyes-free tactile practice screen, distinct end-of-round completion haptic + gentle tone, neutral Counting plus private user-created labels, session completion, a simple non-gamified history, and a quiet 21-style mala visual picker. Minimal preferences (target count, sound on/off, haptic intensity where supported, mala style).

**Explicitly out of v1 (corrected from prior scope):**
- **Streaks / "don't break the chain"** — removed. Devotional practice plus streak/loss-aversion pressure is a tone failure; v1 shows gentle history only, never a streak counter.
- **Reminders / push notifications** — removed from v1 (same tone risk; adds a permission/privacy surface for no core value).
- **Audio (chanting / per-bead audio)** — later expansion; v1 ships at most one gentle completion tone.

## 02. Design
Quiet, calm, abstract-tactile, devotional. Designed to be usable **eyes-closed / screen-off** — the haptic, not the visual, is the confirmation. Visual mala styles are native SwiftUI/Canvas renderers and do not change the count contract. Screens: Home, Mantra Select, Practice, Completion, History, Settings, Change Mala.

## 03. Frontend Technical
Native iOS, **SwiftUI**, local-first (target iOS 17+, to be locked at scaffold time). **CoreHaptics** powers the per-bead and distinct completion haptics, with `UIFeedbackGenerator` as a graceful fallback on devices without Core Haptics. Minimal **AVFoundation** for the single completion tone. Local persistence of mantras, sessions, and preferences via SwiftData or a small `Codable`-to-disk store. **Build order: repetition engine first (with unit tests on advance / interruption-resume / round-completion / target-config), then the practice screen, then content/preferences.**

## 04. Backend Technical
No backend for v1. No accounts, no network calls, no analytics SDKs. Future (post-v1, optional) services could include an audio/content catalog or opt-in sync, but none are in v1 scope.

## 05. Business
Free core practice (the repetition loop, neutral Counting, private custom labels, and history are all free). **No in-app purchases / StoreKit in v1.**

## 06. Marketing
Positioning: a quiet digital mala for daily japa that you can use with your eyes
closed. The primary audience is people who already practice japa or fixed-count
repetition; the secondary audience is meditation users who want a private,
low-pressure counter. The central proof is eyes-free, tactile,
interruption-safe counting—not a broad claim that Mala is another meditation
platform. Tone must remain respectful, useful, and non-gamified.

## 07. User Acquisition
Initial acquisition is organic and evidence-led: existing testers and personal
network, relevant practice communities, a focused product website and search
content, short product demonstrations, and outreach to small meditation, yoga,
and spiritual-practice creators. Broad paid acquisition is gated until the App
Store page converts and qualitative usage shows the product solves the core
problem.

**Privacy-respecting success signals (no analytics SDK):** App Store Connect
product-page views, downloads and conversion; crash-free usage; TestFlight and
support feedback; ratings/reviews; voluntary interviews; and reports that a
user completed a round eyes-free and resumed correctly after interruption.
Explicitly not a metric: streak length, notification opt-in, or personal mantra
content.

## 08. Execution
Done: scaffolded the app (XcodeGen + SwiftUI, iOS 17+); built and unit-tested the repetition engine first; implemented per-bead + distinct completion haptics (CoreHaptics with `UIFeedbackGenerator` fallback); built the eyes-free practice screen; added local persistence + interruption-resume; added explicit Finish early with honest partial-session recording; added neutral Counting plus private custom labels; added quiet history (no streaks); added settings, Dynamic Type support, CI, and the 21-style Change Mala picker; ran a privacy/no-network audit and shipped `PrivacyInfo.xcprivacy`; generated an app icon; uploaded Build 2 manually on 2026-08-06. Remaining: processed-build smoke check, human approval/upload of App Store metadata and refreshed screenshots, questionnaires, and App Review.

### Go-to-market work breakdown

The tasks below are the repository authority for post-beta, launch, and growth
execution. Mirror them to Jira/Notion without changing scope. Subtasks appear
only where the work has a real assignment, dependency, approval, or evidence
boundary; see `GOVERNANCE.md`.

#### Phase 0 — TestFlight release candidate

**GTM-001 — Upload the follow-up TestFlight build — completed manually 2026-08-06**

Outcome: the build containing explicit Finish early is uploaded to App Store
Connect and available to the intended testers after processing.

- **GTM-001A — Manual archive/upload — completed:** Build 2 was archived and
  uploaded through Xcode Organizer; evidence is recorded under `quality/evidence/`.
- **GTM-001B — Confirm distribution:** verify the processed build is attached to
  the correct TestFlight groups and available to Priyansh, Sonakshi, and Supriya.
- **GTM-001C — Optional automation — deferred:** add the base64-encoded `.p8`
  value as GitHub secret `ASC_KEY_CONTENT` before relying on unattended releases;
  never commit or paste the private key into project documentation.

**GTM-002 — Run structured beta validation**

Outcome: each intended tester completes the core scenarios and reports results.

- **GTM-002A — Prepare the beta script:** clean install or upgrade, start and
  finish a full round, finish early, background/resume, force-quit/resume,
  inspect history duration, change target/style, and verify haptic completion.
- **GTM-002B — Collect tester results:** capture tester, device/iOS version,
  build, scenario, result, evidence, and qualitative “didn't have to look”
  feedback.
- **GTM-002C — Triage findings:** classify each finding as launch blocker,
  post-launch improvement, support/documentation issue, or rejected/out of
  scope; create a bug only when reproduction and expected behavior are clear.

**GTM-003 — Approve the release candidate**

Outcome: a documented go/no-go decision exists for the exact build submitted.

- **GTM-003A — Verify engineering gates:** automated suite green, no open
  launch-blocking defect, clean install and upgrade pass, privacy declaration
  matches behavior, and release evidence retained.
- **GTM-003B — Complete human device QA:** accountable human validates haptics,
  completion, early finish, interruption recovery, duration accuracy, and the
  core 108-count flow on the release build.
- **GTM-003C — Record go/no-go:** approve the exact version/build or document the
  blocker and return it to implementation.

#### Phase 1 — App Store submission and launch foundation

**GTM-004 — Complete and submit the App Store product page**

Outcome: Apple has the approved build and complete, truthful product metadata.

- **GTM-004A — Approve product-page assets:** final screenshots, icon, name,
  subtitle, description, keywords, promotional text, support URL, and privacy
  URL match `RELEASE_METADATA.md`.
- **GTM-004B — Complete App Store questionnaires:** category, age rating,
  privacy nutrition label, export compliance, pricing, territories, and required
  agreements are reviewed by the accountable human.
- **GTM-004C — Submit the exact release candidate:** attach the approved build,
  submit for review with manual release enabled, and retain submission evidence.
- **GTM-004D — Resolve App Review communication:** answer Apple questions or
  address rejections as tracked work; do not silently change product scope.

**GTM-005 — Lock positioning and launch messaging**

Outcome: one consistent message is used across the App Store, website, demos,
and outreach. This is a single coherent copy decision and should remain one task
unless different languages or separately approved campaigns are introduced.

Acceptance criteria: primary audience, problem, one-sentence value proposition,
three proof points, privacy promise, respectful tone rules, and claims to avoid
are approved and reflected in `RELEASE_METADATA.md`.

**GTM-006 — Build the launch landing page and conversion path**

Outcome: a prospective user can understand Mala, reach the App Store, and get
support without confusion.

- **GTM-006A — Publish product page:** headline, short explanation, product
  visuals/demo, privacy statement, support contact, and App Store call to action.
- **GTM-006B — Verify the path:** mobile layout, page speed, links, support email,
  privacy page, and App Store destination work on production.
- **GTM-006C — Establish search foundations:** unique page title/description,
  indexable copy for digital mala/mantra counter/japa counter intent, social
  preview image, and canonical URL.

**GTM-007 — Produce the launch content kit**

Outcome: approved reusable materials exist before launch-day distribution.

- **GTM-007A — Create the product demonstration:** a short screen/device video
  shows starting, eyes-free counting, interruption resume, completion, and early
  finish without making unverifiable claims.
- **GTM-007B — Create channel copy:** launch announcement, short social variants,
  community-specific introduction, creator outreach note, and support FAQ.
- **GTM-007C — Review content:** confirm respectful language, accurate behavior,
  readable captions, and consistency with App Store metadata.

**GTM-008 — Establish launch measurement and support operations**

Outcome: the team can observe launch health without adding an analytics SDK.

- **GTM-008A — Define the baseline report:** App Store impressions, product-page
  views, conversion, downloads, crashes, ratings/reviews, support themes, and
  voluntary feedback.
- **GTM-008B — Configure feedback intake:** support email workflow, issue
  template, severity taxonomy, reproduction fields, and response ownership.
- **GTM-008C — Define reporting cadence:** daily review during launch week,
  weekly review for the first month, and monthly review thereafter.

#### Phase 2 — Controlled public launch

**GTM-009 — Release and verify production**

Outcome: the approved build is publicly downloadable and the production listing
works end to end.

- **GTM-009A — Release manually:** confirm agreements and status, release the
  approved build, and record the public version, build, time, and App Store URL.
- **GTM-009B — Production smoke test:** install from the public App Store on a
  clean device, complete the core flow, verify support/privacy links, and record
  the result.
- **GTM-009C — Decide whether to continue or pause promotion:** use crash,
  installation, and support evidence before expanding outreach.

**GTM-010 — Announce through owned channels**

Outcome: the existing personal and website audience receives one clear launch
message. Publish the approved launch announcement on the product website and
the owner's selected social/email channels, then record links and response.

**GTM-011 — Introduce Mala to relevant communities**

Outcome: qualified practitioners discover the app through useful,
policy-compliant participation.

- **GTM-011A — Select communities:** document audience fit, posting rules,
  allowed format, and a useful non-promotional contribution angle.
- **GTM-011B — Publish tailored introductions:** disclose the builder
  relationship, explain the problem solved, invite feedback, and avoid repetitive
  cross-post spam.
- **GTM-011C — Respond and learn:** answer questions, capture objections and
  language users employ, and route product findings to triage.

**GTM-012 — Run small-creator outreach**

Outcome: relevant meditation, yoga, and practice creators test Mala and provide
honest feedback or coverage.

- **GTM-012A — Build a qualified list:** audience relevance, contact method,
  estimated reach, relationship status, and why Mala fits.
- **GTM-012B — Send personalized outreach:** offer access and ask for candid use
  feedback; do not require positive coverage.
- **GTM-012C — Manage follow-up and disclosure:** track replies, provide factual
  materials, record coverage, and ensure any compensation or gifted access is
  disclosed.

**GTM-013 — Operate launch-week feedback triage**

Outcome: launch signals are reviewed daily and urgent issues receive an owner.
This remains one recurring operational task: review crashes, reviews, support,
and feedback; document decisions; escalate launch blockers; and avoid creating
separate subtasks for each routine daily check.

#### Phase 3 — First 30 days: activation and trust

**GTM-014 — Conduct early-user research**

Outcome: the team understands whether users can begin, complete, and trust a
practice without assistance.

- **GTM-014A — Recruit interview participants:** include active users, people who
  tried and stopped, and at least one experienced mala practitioner where
  possible.
- **GTM-014B — Run structured interviews:** ask about first use, eyes-free
  completion, interruptions, history trust, terminology, and unmet needs without
  leading toward planned features.
- **GTM-014C — Synthesize evidence:** group repeated problems, retain quotes only
  with consent, distinguish requests from underlying needs, and update risks,
  lessons, and candidate backlog items.

**GTM-015 — Improve App Store conversion**

Outcome: listing changes are based on observed funnel data and user language.

- **GTM-015A — Establish baseline:** retain the first stable period of
  impressions, product-page views, downloads, conversion, and source context.
- **GTM-015B — Choose one meaningful experiment:** change one coherent variable
  such as first screenshot/message; document hypothesis and success measure.
- **GTM-015C — Evaluate and retain learning:** compare against the baseline,
  adopt or revert the change, and record the lesson without overstating small
  samples.

**GTM-016 — Ship the first evidence-led maintenance release**

Outcome: confirmed launch defects or high-friction issues are corrected without
scope expansion.

- **GTM-016A — Select scope:** prioritize stability, completion, duration trust,
  accessibility, and first-use comprehension using documented evidence.
- **GTM-016B — Implement and verify:** each code change receives its own
  independently assignable issue only when warranted by the decomposition rule;
  run regression and device QA.
- **GTM-016C — Release and observe:** distribute through TestFlight, submit the
  approved build, publish factual release notes, and compare post-release signals.

**GTM-017 — Establish a review and reputation practice**

Outcome: genuine users can review Mala and receive support. Respond respectfully
to reviews where possible, never incentivize ratings, do not gate support on a
review, and turn recurring confusion into product or documentation work.

#### Phase 4 — Days 31–90: validate repeatable growth

**GTM-018 — Evaluate acquisition-channel fit**

Outcome: the team knows which channels produce qualified users rather than
empty reach.

- **GTM-018A — Normalize channel evidence:** capture effort/cost, reach, App Store
  movement, feedback quality, and signs of meaningful practice use for each
  channel.
- **GTM-018B — Compare channels:** continue, revise, or stop each channel using
  the same decision criteria while acknowledging attribution limits.
- **GTM-018C — Select the next-cycle mix:** choose the small set of channels to
  repeat and state the budget/time cap and expected learning.

**GTM-019 — Build a search and education content loop**

Outcome: useful evergreen content earns relevant discovery over time.

- **GTM-019A — Create the editorial map:** prioritize real user questions about
  digital malas, counting, interruptions, privacy, and eyes-free practice; avoid
  presenting spiritual instruction beyond reviewed expertise.
- **GTM-019B — Publish and distribute:** create focused articles or demos, link
  them to the product page, and share only where useful and permitted.
- **GTM-019C — Review search evidence quarterly:** update useful pages, retire
  misleading or low-value content, and record new language for ASO.

**GTM-020 — Run partnership experiments**

Outcome: determine whether trusted teachers, studios, or small creators can
introduce Mala authentically.

- **GTM-020A — Define one partnership hypothesis and safeguards:** audience,
  value exchange, disclosure, content boundaries, and success evidence.
- **GTM-020B — Run a bounded pilot:** one partner or small cohort, explicit
  duration, no product-scope promise, and a documented support path.
- **GTM-020C — Evaluate:** continue, modify, or stop based on qualified feedback,
  downloads where attributable, effort, and brand fit.

**GTM-021 — Decide whether paid acquisition is justified**

Outcome: a documented decision is made after organic conversion and user value
are credible. If the gate is not met, close this task with “not yet” and the
evidence. If met, create a separately approved, capped experiment with one
audience, one message, budget limit, stop condition, and privacy-safe measurement.

#### Phase 5 — Ongoing product and growth operations

**GTM-022 — Operate the monthly product cycle**

Outcome: feedback becomes deliberate product improvement. Review evidence,
select a bounded release goal, implement and verify it, distribute through
TestFlight, release when approved, and reconcile repository docs before Jira and
Notion. Individual feature/bug issues are created only when independently
assignable under the decomposition rule.

**GTM-023 — Maintain support, reliability, and compliance**

Outcome: production remains trustworthy.

- **GTM-023A — Support and incident operations:** monitor support, reviews,
  crashes, and App Store notices; assign severity and response ownership.
- **GTM-023B — Release-health maintenance:** keep dependencies/tooling,
  certificates, workflows, device compatibility, and regression evidence current.
- **GTM-023C — Privacy and store compliance review:** ensure actual behavior,
  `PrivacyInfo.xcprivacy`, App Store disclosures, public policies, and marketing
  claims remain aligned after every material change.

**GTM-024 — Run a quarterly strategy review**

Outcome: the next quarter follows evidence instead of accumulated requests.
Review audience/problem fit, product quality, channel results, support themes,
roadmap candidates, risks, and lessons; explicitly continue, stop, or defer each
major initiative.

**GTM-025 — Evaluate monetization only after value is proven**

Outcome: decide whether Mala should remain free or introduce a respectful paid
model. This is a future decision gate, not approval to add StoreKit. Inputs must
include repeat-use evidence, user research, support burden, operating cost,
competitive context, and the requirement that the core practice remain calm and
non-exploitative.

## 09. QA
Covered by automated tests (current counts in [`TEST_PLAN.md`](TEST_PLAN.md); latest result in [`STATUS.md`](STATUS.md)): count increments, one-step undo/decrement with a floor at 0, pause/resume across a simulated relaunch (exact bead restored), round-completion fires exactly once at target and pins past it, honest partial-session recording, history/preferences/custom-label/mala-style persistence, Dynamic Type primary-flow smoke, a structural assertion that no streak/chain concept exists, and the core UI flow. Physical iPhone validation covers haptics and the primary round flow; VoiceOver user validation is deferred post-v1. No automated test yet spies on haptic/tone invocation to verify tick-vs-completion distinctness.

## 10. Legal / Compliance
Document local-only data handling: all data (custom labels, sessions, preferences) stays on device; nothing is collected, tracked, or sent. Ship a truthful `PrivacyInfo.xcprivacy` and App Store privacy label declaring no data collection. Bundled spiritual seed content is out of v1 scope. No reminders/notifications and no tracking prompts in v1.

## 11. Operations
Release process: internal practice test → content review → community beta → TestFlight → App Store. Post-launch / future (out of v1): audio, external 3D/photoreal asset pipeline, widgets, broader mantra catalog, and possible Digital Temple integration.
