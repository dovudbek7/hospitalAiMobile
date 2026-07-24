# Hospital AI — Flutter App Build Handoff

**For:** the mobile developer building the patient app
**Backend status:** complete, deployed, and live. You are not blocked on anything.
**Date:** 24 July 2026

---

## 0. Read this first

Hospital AI is a **30-day post-operative recovery programme**. A patient is discharged from
hospital, installs this app, and for 30 days it tells them what to do each day and collects a
short structured symptom check-in. If a check-in looks dangerous, the clinic is alerted — or the
patient is told to call an ambulance.

You are building **17 screens (P1–P17)**. The backend, the clinician dashboard, and the AI layer
already exist and are deployed.

### The one rule that shapes everything

> **No AI-generated text ever reaches a patient's screen.**
> **Every patient-visible string comes from the content library, by key.**

This is not a style preference — it is why the product is not legally a medical device. Practically,
for you, it means:

- **You never hardcode patient-facing text.** Not a heading, not a button label, not an error
  message. You fetch it from `GET /v1/content/:key?lang=`.
- The **only** hardcoded strings permitted in the entire app are the three language names on P1
  (`Oʻzbekcha`, `Русский`, `English`) — because a patient who cannot read the current interface
  language must still be able to act.
- **The app never judges.** It must never say a symptom is normal, fine, safe, or concerning. No
  "that sounds normal", no "nothing to worry about", no "you're recovering well". The app delivers
  the clinic's instructions and routes to humans.
- **Instructions are attributed to the clinic, never the app**: "Your clinic's instruction: …".
- **Unapproved content fails closed** — if the API returns `CONTENT_NOT_APPROVED`, render nothing
  and show an error. Never fall back to another language, and never ship a default string.

There is an automated safety gate in CI that blocks releases if these are violated on the backend.
The equivalent discipline on the app side is yours.

---

## 1. Production URLs

| What | URL |
|---|---|
| **API base** | `https://api.hospital-ai.uz/v1` |
| **Swagger / OpenAPI (live, browsable)** | `https://api.hospital-ai.uz/v1/docs` |
| Clinician dashboard (not yours, but useful to see the other side) | `https://dashboard.hospital-ai.uz` |

Every endpoint below is relative to the API base. So `GET /me/today` means
`https://api.hospital-ai.uz/v1/me/today`.

**Open the Swagger page first.** It is generated from the running code, so it is always more current
than this document. This document explains *intent and sequencing*; Swagger gives you exact schemas.

### Demo credentials

The server is seeded with a demo clinic (**Sehat Clinic (DEMO)**, timezone `Asia/Tashkent`,
09:00–18:00 Mon–Sat, emergency number 103) and 6 demo patients `DEMO-01` … `DEMO-06` sitting at
recovery days 6, 3, 12, 8, 29 and 1 — deliberately covering the interesting states (mid-programme,
early, late, day-29 for the survey, day-1 for onboarding).

Ask for a current enrolment code + phone pair before you start — codes are single-use and expire
after 14 days, so any code written into a document would be stale by the time you read it.

---

## 2. Stack and conventions

Decided already, in the project ADR — please don't re-decide these:

- **Flutter**, Android + iOS.
- **Riverpod** for state management.
- Target device: **mid-range Android on a poor connection**. This is a real constraint, not a
  nicety — the pilot region has patchy connectivity and the users are frequently elderly.
- Minimum body text size is **18sp**, not 16.
- Everything must survive **200% system font scale** without layout breakage.

---

## 3. Auth — how a patient gets in

There is **no password and no self-registration**. A patient is created by clinic staff in the
dashboard, who hand them a 6-character code at discharge.

```
POST /auth/patient/session
Content-Type: application/json

{ "code": "H7K9QP", "phone": "+998901234567" }
```

Returns:

```json
{
  "audience": "patient",
  "accessToken":  "<JWT, valid 24h>",
  "refreshToken": "<JWT, valid 60 days>",
  "patientId": "…",
  "clinicId": "…"
}
```

Send the access token as `Authorization: Bearer <accessToken>` on every subsequent call.

**Session rules:**

- The session persists **indefinitely** for the 30-day programme. **Do not force re-login.** A
  patient locked out mid-recovery is a patient who stops using the app.
- The token is audience-scoped. A staff token on a patient endpoint returns `WRONG_TOKEN_AUDIENCE`.
- Store tokens in secure storage (Keychain / Keystore), never in plain shared preferences.

**Error handling on enrolment (security-relevant — read carefully):**

| Situation | Behaviour required |
|---|---|
| Invalid code | Inline error. **Never reveal whether the code exists** — that would let someone guess codes. |
| Already-used code | Error + "contact your clinic". |
| Expired code (>14 days) | Error + "contact your clinic". |
| Phone mismatch | Generic error. **Never reveal the stored number** or confirm a partial match. |
| 3 failed phone attempts | The code locks; staff must reissue. Enforced server-side. |
| No connection | Clear retry message, **keep the code the patient typed**. |

Rate limit is 5 attempts per device per hour, enforced server-side. Don't rely on client-side checks
for any of this — mirror them for UX only.

---

## 4. Localization (Uzbek · Russian · English)

All three languages ship at launch. **Uzbek is Latin script.**

### How text actually reaches the screen

There are exactly **two** sources of patient-visible text:

**1. The content library** — for everything that is prose.

```
GET /content/{key}?lang=UZ        →  { "contentKey": "...", "language": "UZ",
                                       "text": "...", "version": 1,
                                       "isPlaceholder": true }
```

`lang` is **required** and must be `UZ`, `RU` or `EN`. The resolver **never falls back**. If the
translation isn't approved you get `CONTENT_NOT_APPROVED` — show "not yet available in your
language" plus the clinic contact. Do **not** silently show another language: a patient who expects
Uzbek and is shown Russian may misread it entirely, and this is medical instruction text.

**2. Structured API responses** — for things that are data, not prose. The check-in answer options
(`GET /me/checkin/questions`) come back **already translated into the patient's own language**. You
render `option.label` directly.

### Setting and changing language

- P1 stores the choice locally **before** the patient has a session (there is no patient yet).
- After enrolment, persist it server-side with `PATCH /me/language`.
- `GET /me/profile` returns the authoritative `language` — use it on app start.
- Changing language in Settings must **re-render everything instantly, with no restart**.
- **Read the device language but NEVER auto-select.** Always ask. A wrong guess strands an elderly
  patient in an interface they cannot read.

### Caching

Cache resolved content aggressively (keyed by `contentKey` + `language` + `version`) — the app must
work offline. Invalidate when `version` changes.

---

## 5. The 17 screens

Bottom navigation is **Today · Progress · Learn · Settings** (P6, P9, P14, P16).

```
First launch:  P1 → P2 → P3 → P4 → P5 → P6
Returning:     P6 (Today) directly
From Today:    P7 task detail · P8 medication · P10 check-in
From check-in: P11 routine | P12 urgent | P13 EMERGENCY
Day 30:        P17 survey
```

---

### Group 1 — Onboarding & Consent (P1–P5)

> The whole flow must be completable by a 70-year-old, one-handed, on a mid-range Android phone, on
> a poor connection, **in under three minutes**. If a step needs explaining, the step is wrong.

#### P1 · Language selection
- **Elements:** app logo; three large tap targets, **each written in its own language** —
  `Oʻzbekcha` · `Русский` · `English`. No other text on the screen.
- **The only hardcoded strings in the app.**
- **Events:** `language_selected` (`is_change: false`)
- **Rules:** read device language but never auto-select. Tap targets ≥ 64dp. Choice persists across
  restart. Changeable later in P16.

#### P2 · Enrolment code entry
- **Elements:** heading + one explanatory line (content library); code input — 6 chars, uppercase
  alphanumeric, **large monospace, 24pt, letter-spaced, centred**, auto-uppercase, autocorrect off;
  `Continue` (disabled until 6 chars); secondary "No code? Contact your clinic" + tappable clinic
  phone.
- **API:** `POST /auth/patient/session` (together with P3 — validate the pair).
- **Rules:** works offline up to the point of submission, then explains clearly. Code survives
  rotation and backgrounding.

#### P3 · Phone number
- **Elements:** heading + explanation (library); `+998` prefix **visible but not editable**;
  9-digit national number, numeric keypad only; `Continue`.
- **Rules:** strip spaces/dashes before sending. Mismatch reveals nothing. Lock after 3 attempts.

#### P4 · Consent — *legally load-bearing, build carefully*
- **Elements:** title (library); **full scrollable consent text** covering what data is collected,
  who sees it, how long it is kept, how to withdraw; the safety disclaimer verbatim from the
  library; an explicit checkbox "I have read and agree", **unchecked by default**; primary
  `Agree and continue` — **disabled until the checkbox is ticked AND the text has been scrolled to
  the end**; secondary `Decline`.
- **API:** `POST /me/consent` with `{ "version": "<consent_version>" }`.
- **Events:** `patient_enrolled` (fires server-side at consent, includes `consent_version`).
- **Rules:** no pre-ticking, ever. **Decline must write zero personal data** — exit with a message
  to contact the clinic. If the consent version changes mid-programme, re-consent on next open.
  Must render correctly in all three languages.

#### P5 · Welcome / ready
- **Elements:** confirmation heading with the patient's first name; three short lines (library) —
  what the app does daily, how long the programme runs, and **that staff review check-ins during
  clinic hours only**; notification permission request with a plain explanation *before* the OS
  prompt; `Start`.
- **API:** `GET /me/profile` for the name and clinic cover hours.
- **Events:** `app_opened` → `POST /me/app-opened`.
- **Rules:** **never block the programme on notification permission.** If denied, continue and show
  a persistent, non-blocking banner on Today explaining reminders are off and how to enable them.
  Re-prompt once at day 3, then never again. Patient must reach Today in ≤ 5 taps from first launch.

---

### Group 2 — Daily Recovery (P6–P9)

> The core loop — 90% of app time is spent on Today. Adherence, the pilot's primary metric, is
> produced entirely by these four screens. Optimise them above everything else.

#### P6 · Today (home)
- **Elements:** header `Day {recovery_day} of 30` + slim progress bar; **persistent emergency
  banner** (library, always visible, never dismissible, tappable to dial); today's task list ordered
  by scheduled time — each row an icon by `taskType`, title (from `contentRef`), scheduled time, and
  a large checkbox; completed tasks **stay visible**, greyed with a tick; overdue tasks marked
  **neutrally**; check-in entry point, visually distinct, when one is due; bottom nav.
- **API:** `GET /me/today`

  ```json
  { "recoveryDay": 6,
    "groups": { "medication": [ { "id": "…", "taskType": "medication",
                                  "contentRef": "medication.paracetamol_500",
                                  "scheduledFor": "2026-07-24T08:00:00Z",
                                  "windowClosesAt": "2026-07-24T10:00:00Z",
                                  "status": "pending", "onTime": null } ] },
    "checkinDue": true }
  ```

  Tick a task → `POST /tasks/{id}/complete` with an `Idempotency-Key` header (**required**).
- **Events:** `app_opened` on open; `task_completed` on tick.
- **Rules:**
  - **Overdue styling is grey, never red, and never scolding.** No "you missed". Red is reserved
    exclusively for medical emergency — a patient who sees red for a missed vitamin learns to ignore
    red, and then ignores it when it matters.
  - Recovery day is computed in the patient's local timezone.
  - Day 0 may have no tasks — show a welcoming empty state, never a blank screen.
  - No tasks today → an explicit "nothing scheduled today", never an empty list.
  - After day 30 → programme-complete state, route to P17.
  - Checkbox tap target ≥ 48dp (design system says 64dp for this one).
  - **Loads and is usable in under 2 seconds on a mid-range Android device.**

#### P7 · Task detail
- **Elements:** task title + scheduled time; full instruction text (library, clinician-approved);
  optional approved image; large `Mark as done`; back to Today.
- **API:** resolve `contentRef` via `GET /content/{key}?lang=`; complete via
  `POST /tasks/{id}/complete`.
- **Rules:** already-completed tasks show a completed state and **allow un-completing** (patients
  mis-tap) — the correction is logged as a **new event** (`task_uncompleted`), never a mutation of
  the original. Missing content **fails closed**: show an error, render nothing.

#### P8 · Medication reminder & confirm
- **Elements:** medication name, dose and time — all from the clinic-approved schedule; **exactly
  two actions: `Taken` and `Not yet`**. No third option, no snooze menu, no free text.
- **Delivery:** local notification at the scheduled time; tapping it opens **this screen directly**.
- **Events:** `medication_reminder_sent`, `medication_confirmed` (with `on_time`).
- **Rules:** `Not yet` → close, repeat the reminder **once** after 30 minutes. Confirmed late is
  still recorded, with `on_time: false` — that is valuable data, not a failure. **The patient must
  never be able to edit a dose or schedule anywhere in the app.** Missed windows fire
  `task_missed` server-side, so patients who never open the app are still counted.

#### P9 · My progress
- **Elements:** days completed of 30 (visual); completion percentage so far; a **30-day grid** filled
  for days with completed tasks; one rotating encouraging line (library).
- **API:** `GET /me/progress`

  ```json
  { "adherence": { "value": 0.8, "numerator": 8, "denominator": 10 },
    "daysCompleted": 5, "programmeDays": 30,
    "perDay": [ { "recoveryDay": 1, "value": 1, "numerator": 2, "denominator": 2 } ] }
  ```
- **Rules:**
  - The percentage **excludes future tasks** (the API already does this — otherwise it always looks
    terrible on day 2).
  - **No clinical interpretation anywhere.** Never "you are recovering well".
  - **Low adherence must never produce discouraging copy.** A struggling patient is a clinical
    concern, not someone to shame — and shame drives abandonment, which loses both the patient and
    the data.
  - Works offline from cached data.

#### Offline behaviour — applies across P6–P9

Connectivity in the pilot region cannot be assumed. Required:

- Cache the **next 7 days** of tasks locally.
- All task completions work offline and queue for sync.
- **Preserve the original action timestamp through sync — never overwrite it with the sync time.**
  Send the same `Idempotency-Key` on retry so a replay produces exactly one effect.
- Show a discreet offline indicator, never a blocking error.
- **Check-in submission is the one action that requires connectivity.** If offline, say so plainly
  and show the clinic phone and the emergency instruction. **A patient reporting symptoms must never
  be silently queued.**

---

### Group 3 — Symptom Check-in & Escalation (P10–P13)

> The highest-liability screens in the product. A patient reporting a dangerous symptom must reach a
> human, or be told to call an ambulance — and must **never**, under any circumstance, receive an
> assessment from the app.

#### P10 · Symptom check-in form
- **Elements:** progress indicator (question n of N); **one question per screen**, large text, large
  tap targets; `Back` / `Next`; emergency banner visible **on every question**.
- **Answer types allowed:** yes/no, single-select from fixed options, multi-select, 0–10 scale.
  **Nothing else. There is no free-text field anywhere on this screen.**
- **API:** `GET /me/checkin/questions`

  ```json
  [ { "ref": "q1_temp", "questionContentKey": "checkin.q1_temp", "type": "single",
      "options": [ { "code": "under_37_5",    "label": "37,5 dan past" },
                   { "code": "38_5_or_above", "label": "38,5 va undan yuqori" } ] },
    { "ref": "q2_pain", "questionContentKey": "checkin.q2_pain", "type": "scale",
      "scale": { "min": 0, "max": 10 } } ]
  ```

  Question **text** is a content key (resolve it). Option **labels** arrive already translated into
  the patient's language — render them directly.

  Submit:

  ```
  POST /checkins
  Idempotency-Key: <uuid>        ← REQUIRED

  { "answers": [ { "ref": "q1_temp", "value": "38_5_or_above" },
                 { "ref": "q2_pain", "value": 7 },
                 { "ref": "q5_redflags", "value": ["chills", "chest_pain"] } ] }
  ```

  Response:

  ```json
  { "checkinId": "…", "tier": "urgent", "ruleVersion": "placeholder-v1",
    "recoveryDay": 6, "withinClinicHours": true,
    "contentKey": "checkin.submitted.urgent",
    "body": "…already resolved and clinic-interpolated, or null if unapproved…",
    "escalationId": "…" }
  ```

- **The seven questions** are: temperature band (incl. "haven't measured") · pain 0–10 · pain vs
  yesterday · wound appearance · red-flag multi-select · eating and drinking · passed urine.
- **Events:** `checkin_submitted` (`tier_assigned`, `rule_version`, `within_clinic_hours`).
- **Rules:**
  - **Tier is assigned server-side. Never client-side** — a client cannot be trusted with a safety
    decision. You render whichever screen the `tier` field tells you to.
  - Route on the response: `routine` → P11, `urgent` → P12, `emergency` → P13.
  - Partial completion → save progress, resume within the same day.
  - **A failed submission must never render as success.** Show an explicit failure with the clinic
    phone.
  - Offline → block submission, show contact options, do not queue.

#### P11 · Submitted — ROUTINE
- **Elements:** neutral confirmation heading (library); body — answers sent, the team reviews on the
  next working day; the clinic's standing instruction on worsening symptoms + clinic phone;
  `Back to Today`.
- **Content key:** `checkin.submitted.routine`
- **Forbidden:** "That sounds normal" · "Nothing to worry about" · "Your answers look fine" · **any
  interpretation whatsoever.** This is the screen most likely to tempt a well-meaning developer into
  adding reassurance. Don't.

#### P12 · Submitted — URGENT
- **Elements:** confirmation heading (library); body verbatim from approved copy; **two large
  buttons: `Call clinic` · `Call 103`**.
- **Content keys:** `checkin.submitted.urgent`, or `checkin.submitted.out_of_hours` when the clinic
  is closed (use `withinClinicHours` from the response).
- **Rules:**
  - Clinic name and phone are **injected from config** (`GET /me/profile` → `clinic`), never
    hardcoded.
  - **No time promise anywhere on this screen.** Do not show "within 2 hours". The SLA is an
    internal target, not a patient guarantee — an unmet promise is worse than none.
  - Out of hours: different approved copy showing the opening time. No staff call is placed, but the
    escalation is still created and queued.
  - Call buttons must dial correctly on both Android and iOS.

#### P13 · EMERGENCY — *this screen does not wait for anyone*
- **Elements:** **full-screen, high-contrast, unmistakable**; heading verbatim: "Your clinic's
  instruction: call 103 now."; body from `emergency.body`; **giant `Call 103` button** (full width,
  72dp tall); secondary `Call {clinic}`; dismiss available but **deliberately de-emphasised** — the
  patient must be able to leave, but not by accident.
- **Content keys:** `emergency.headline`, `emergency.body`
- **Events:** `emergency_screen_shown` — **log every single time, without exception**, including
  offline (queue it).
- **Rules — all of these are hard requirements:**
  - **Must render and dial with no network connection.** If nothing else in the app works, this
    must. Cache the emergency strings and the numbers locally at enrolment.
  - Identical behaviour in and out of clinic hours — it has no staff dependency, which is exactly
    what makes clinic-hours-only cover safe.
  - Shown **before** any notification is sent to staff — the patient is never made to wait on the
    clinic.
  - **Cannot be suppressed, deduplicated, or rate-limited**, however many times it triggers.
  - Emergency number comes from per-clinic config.
  - **Verify on a real device with a real call attempt before launch.**

> **Why three separate screens instead of one with variable text:** it makes each independently
> reviewable by the clinician, independently testable by QA, and impossible to show the wrong
> reassurance level through a templating mistake. **The duplication is the safety feature** — please
> don't refactor it into one parameterised screen.

---

### Group 4 — Learn, Survey & Settings (P14–P17)

#### P14 · Learn
- **Elements:** list of articles grouped by category (Wound care · Medication · Activity · What to
  expect); each row title + estimated read time; items relevant to the current recovery day at the
  top; emergency banner persists.
- **API:** `GET /me/content?category=education`

  ```json
  { "category": "education", "procedureType": "laparoscopic_appendectomy", "recoveryDay": 6,
    "items": [ { "contentKey": "clinical.laparoscopic_appendectomy.day_5",
                 "unlockDay": 5, "category": "clinical" } ] }
  ```
- **Rules:** only signed-off content appears. Items **not yet unlocked are hidden, not greyed** —
  greying invites patients to seek out later-stage advice early. Education unlocks on days
  **1, 3, 5, 7, 14, 21**. Friendly empty state if the procedure has no content. Available offline
  from cache.

#### P15 · Article detail
- **Elements:** title, body, optional approved images; **footer disclaimer on every article**,
  verbatim from `content.disclaimer`; back to Learn.
- **API:** `GET /content/{contentKey}?lang=`
- **Events:** `content_viewed` (with `content_ref`)
- **Rules:** render **exactly** what the clinician approved — **no summarisation, no simplification,
  no AI adaptation**. Missing translation → explicit "not yet available in your language" + clinic
  contact. **Never a silent language fallback.**

#### P16 · Settings
- **Elements:** language switcher (all three); notification preferences → deep-link to OS settings;
  clinic contact card (name, phone, hours) with a tappable call button; **prominent cover
  statement** (library) — check-ins are reviewed during clinic hours only, with the emergency
  instruction; programme info (start date, current day, end date); `Leave programme` (with
  confirmation); app version + support contact.
- **API:** `PATCH /me/language` `{ "language": "RU" }` · `POST /me/leave` · `GET /me/profile`
- **Events:** `language_selected` (`is_change: true`) → `language_changed`; `patient_withdrawn`
- **Rules:** language change applies **instantly across the app, no restart**. Leaving requires
  explicit confirmation and notifies the clinic — a patient dropping out is clinically relevant
  information, not just a churn metric. **Withdrawal does not delete data**; it stops the programme
  (the API returns `tasksStopped`).

#### P17 · Satisfaction survey (day 30)
- **Elements:** intro line (library); **exactly five questions, no more**:
  1. Overall, how helpful was the app during your recovery? — 1 Not helpful … 5 Very helpful
  2. How easy was the app to use? — 1 Very difficult … 5 Very easy
  3. Did it help you remember your medication and daily tasks? — Yes / Somewhat / No
  4. Would you recommend it to another patient having surgery? — Yes / Maybe / No
  5. What would you change? *(optional free text)*
- **API:** `POST /me/survey` — `q1Helpful`, `q2Easy`, `q3AdherenceSupport`, `q4Recommend` (1–5, all
  optional) + optional free text. Idempotent; allowed only near day 30.
- **Events:** `survey_submitted` / `survey_completed` — **scores and categorical answers only**.
  Send `has_free_text: true/false`; **the free-text content itself must never appear in an analytics
  event.**
- **Rules:** appears on day 30 when the programme completes. **One reminder after 48 hours, then
  never again.** Always skippable — never block programme completion on it. Scale direction
  identical in all three languages (1 = worst). A patient who withdrew early still gets it once.

---

## 6. Complete endpoint reference (patient audience)

All require `Authorization: Bearer <patient accessToken>` except where noted.

| Method | Path | Screen | Notes |
|---|---|---|---|
| `POST` | `/auth/patient/session` | P2/P3 | **No auth.** `{code, phone}` → tokens |
| `GET` | `/content/{key}?lang=UZ\|RU\|EN` | all | **`lang` required, no fallback** |
| `POST` | `/me/consent` | P4 | `{version}` → fires `patient_enrolled`. Idempotent |
| `GET` | `/me/profile` | P5, P16 | name, recoveryDay, programmeDay, language, procedureType, clinic contact + hours |
| `GET` | `/me/today` | P6 | tasks grouped by type + `checkinDue` |
| `POST` | `/tasks/{id}/complete` | P6, P7 | **`Idempotency-Key` required** |
| `GET` | `/me/progress` | P9 | adherence with denominator, per-day series |
| `GET` | `/me/checkin/questions` | P10 | options pre-translated to the patient's language |
| `POST` | `/checkins` | P10 | **`Idempotency-Key` required** → returns `tier` |
| `GET` | `/me/content?category=education` | P14 | unlocked content **keys** |
| `POST` | `/me/survey` | P17 | idempotent, day-30 gated |
| `PATCH` | `/me/language` | P16 | `{language}` |
| `POST` | `/me/leave` | P16 | self-withdraw, retains data |
| `POST` | `/me/app-opened` | P5, P6 | engagement telemetry |

### Idempotency

`POST /checkins` and `POST /tasks/{id}/complete` **require** an `Idempotency-Key` header. Generate a
UUID per logical action, persist it with the queued action, and reuse the **same** key on every
retry. A replay returns the original result rather than creating a duplicate — this is what makes
offline sync safe. Reusing a key for a *different* action returns `DUPLICATE_REQUEST`.

### Error format

```json
{ "code": "CONTENT_NOT_APPROVED", "message": "…", "details": { } }
```

**Map `code` to a content-library string. Never render `message` to a patient** — it is a developer
diagnostic, in English, and is not clinician-approved.

Codes you will encounter: `VALIDATION_ERROR`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`,
`WRONG_TOKEN_AUDIENCE`, `DUPLICATE_REQUEST`, `CONTENT_NOT_APPROVED`,
`CLINICAL_CONTENT_NOT_APPROVED`, `CROSS_CLINIC_FORBIDDEN`, `INTERNAL_ERROR`.

---

## 7. Telemetry events

Server-side (fired automatically — you just call the endpoint): `patient_enrolled`,
`task_completed`, `task_uncompleted`, `task_missed`, `checkin_submitted`, `escalation_created`,
`escalation_notified`, `escalation_breached`, `language_changed`, `patient_withdrawn`,
`survey_submitted`, `app_opened`.

Client-side (**yours to fire**): `language_selected` (with `is_change`), `medication_reminder_sent`,
`medication_confirmed` (with `on_time`), `content_viewed` (with `content_ref`),
`emergency_screen_shown`.

> **No clinical free text in telemetry, ever.** Events carry IDs and categorical values only. This is
> a golden rule, and the backend has an automated test asserting it.

---

## 8. Design system — exact values, please don't invent any

Direction: **clean clinical minimal.** Calm, high-contrast, generous spacing, large type. Built for
elderly post-operative users on mid-range Android phones — and for an award demo, so it should look
considered rather than default.

### Colour

| Token | Hex | Use |
|---|---|---|
| `primary` | `#0F5F6B` | Primary actions, headers, active states |
| `primary-dark` | `#0A464F` | Pressed states |
| `primary-light` | `#EDF4F5` | Section backgrounds, selected rows |
| `text` | `#1A2430` | Body text |
| `text-muted` | `#5B6673` | Secondary text, captions |
| `border` | `#C9DBDE` | Dividers, input borders |
| `surface` | `#FFFFFF` | Cards, sheets |
| `background` | `#F7FAFB` | App background |

**Semantic — tier colours are fixed and must never be reused for anything else:**

| Token | Hex | Use |
|---|---|---|
| `emergency` | `#B3261E` | **Tier 1 only. Never anything else, ever.** |
| `urgent` | `#B36B00` | Tier 2 only |
| `routine` | `#7A6A00` | Tier 3 only |
| `success` | `#1B7F5A` | Completed tasks |
| `neutral-overdue` | `#5B6673` | Overdue tasks — **grey, never red** |

### Typography — Inter (bundled), fallback system sans

| Style | Size / weight | Use |
|---|---|---|
| Display | 28 / 700 | Screen titles |
| H1 | 22 / 700 | Section headings |
| H2 | 18 / 600 | Card titles |
| Body-L | 18 / 400 | **Patient app default body** |
| Body | 16 / 400 | Secondary text |
| Caption | 14 / 400 | Timestamps, helper text |
| Button | 18 / 600 | All buttons |

Line height 1.5 throughout.

### Spacing — 4pt grid, permitted values only: 4, 8, 12, 16, 24, 32, 48, 64

- Screen padding 16 · card padding 16 · card radius 12 · gap between cards 12
- Section gap 24 · input height 56 · input radius 8

### Touch targets

- Minimum **48dp**
- Primary patient actions (task checkbox, Continue, Taken): **64dp**
- Emergency call button: **full width, 72dp tall**

### Components

- **Buttons** — Primary: filled `primary`, white text, radius 8, height 56 (64 for key actions).
  Secondary: outlined, primary text. Emergency: filled `emergency`, white, 72 tall, full width.
  Disabled: border fill + `text-muted` text — **never invisible**.
- **Task row** — height ≥ 72. Left: 24dp type icon. Centre: title (Body-L) + scheduled time
  (Caption). Right: 32dp checkbox with a 64dp tap area. Completed: success tick, title at 60%
  opacity, strikethrough. Overdue: `neutral-overdue` time text + small dot. **No red, no exclamation
  marks, no scolding copy.**
- **Emergency banner** — fixed to top below the status bar, **on every screen**. Background
  `emergency`, white text, 44 tall, **not dismissible**, tappable to dial. Content from the library.
- **Input** — height 56, radius 8, 1px border, 2px `primary` on focus. Label above (Caption), error
  below in `emergency`. Enrolment code field: monospace, 24pt, letter-spaced, centred.
- **Scale selector (0–10)** — horizontal row of 11 circular targets, 48dp each, scroll if needed.
  Selected: filled `primary`. End labels from the library.

### Accessibility — non-negotiable

- WCAG AA contrast minimum (4.5:1 body, 3:1 large text).
- **Never colour alone to convey meaning.** Tiers carry an icon and a text label as well as colour —
  roughly 8% of men have colour vision deficiency, and this app carries emergency information.
- Semantic labels on every interactive element for screen readers.
- 200% system font scale without layout breakage.
- No animation required to understand any state.

### Responsive

Single column, 320–480dp design range. **Nothing horizontally scrollable except the 0–10 scale.**

---

## 9. Explicitly out of scope — do not build

Deliberately cut, not reopenable before launch:

- Free-roaming AI chat with patients
- Diet engine or food lookup
- OCR / bulk document import
- Group or family care plans
- **Biometric login** (biometric data must be stored in-country — avoid entirely for now)
- Video or voice calling inside the app
- Patient-to-patient anything
- Clinic self-service onboarding

---

## 10. Definition of done

- [ ] Every screen meets its own acceptance criteria above
- [ ] All telemetry events fire correctly against a simulated 30-day patient
- [ ] **No patient-facing string exists outside the content library** — one grep for hardcoded text
      should come back empty except the three language names on P1
- [ ] Copy verified in **all three languages** on every screen
- [ ] Full 7-day offline usage tested with airplane mode; sync produces no duplicate events
- [ ] Offline check-in attempt shows contact options and does **not** queue
- [ ] **P13 renders and dials with no network**, verified on a real device with a real call attempt
- [ ] Works on a mid-range Android device on a poor connection
- [ ] 200% font scale, screen reader labels, WCAG AA contrast

---

## 11. If you are using Claude Code

This document is written to be usable as a spec. Suggested approach:

1. Drop this file into your Flutter repo root as `SPEC.md` and point Claude Code at it.
2. Have it fetch `https://api.hospital-ai.uz/v1/docs` for exact schemas rather than guessing.
3. Build a typed API client first (the endpoint table in §6 is the full patient surface — there are
   only 14 calls), then the content-resolution layer with caching, then screens in spec order
   P1→P17.
4. **Give it the golden rules in §0 as a standing instruction.** The single most likely failure mode
   for an AI-assisted build here is a well-meaning hardcoded English string or an invented
   reassuring message on P11 — both of which are release blockers on this product.

---

## 12. Two things to know about the current backend state

1. **Content is placeholder.** Every content item is real Uzbek/Russian/English text, but it is
   flagged `is_placeholder: true` — drafted, pending native-speaker review and clinician sign-off.
   You will see `"isPlaceholder": true` in content responses. Build against it normally; the strings
   will be replaced with signed-off copy without any key changes.
2. **A production gate exists.** Two server flags (`ALLOW_PLACEHOLDER_CONTENT`,
   `PATIENT_ENROLMENT_ENABLED`) make real patient enrolment impossible until a clinician signs the
   content off. The demo server has placeholders enabled so you can build; in production, an
   unapproved string returns `CLINICAL_CONTENT_NOT_APPROVED` instead of rendering. Make sure your
   error path handles that gracefully rather than showing a blank screen.

---

*Questions about anything in this document — ask before improvising. Three developers improvising
produces three different products, and on the check-in screens it produces an unsafe one.*
