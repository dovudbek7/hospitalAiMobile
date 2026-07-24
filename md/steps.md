# Hospital AI — Flutter Patient App · Full Build Plan

**Repo:** `/Users/dovudbek/Documents/projects/hospitalAiMobile`
**Target:** award-ready MVP (President Tech Award + President AI Award). Sehat-dependent work is deferred.
**Toolchain verified:** Flutter 3.44.4 stable · Dart 3
**Backend verified live:** `https://api.hospital-ai.uz/v1` — 36 endpoints in `docs-json`, 14 of them patient-facing

## How to use this document

Phases are numbered **F0 … F14**. Screens are numbered **P1 … P17** (from the spec) — the two
numbering schemes are deliberately different so `F3` never gets confused with `P3`.

Give the command as **"F0 ni boshla"** or **"do F4"**. Each phase states its dependencies, the exact
files to create, and a done-when checklist. Do not start a phase before its dependencies are green.

Phases are ordered by dependency, not by screen number. Screens come late on purpose: the content
layer, the offline queue and the design system have to exist first, or every screen gets rewritten.

---

## Sources of truth — in priority order

| Rank | Source | What it decides |
|---|---|---|
| 1 | `md/HOSPITAL_AI_FLUTTER_HANDOFF.md` | Screen behaviour, golden rules, API surface, acceptance criteria |
| 2 | Notion → *Seed & Placeholder Content Pack* | Exact patient-visible strings, the 7 check-in questions, `placeholder-v1` tier rules, demo seed |
| 3 | Notion → *Build Decisions (ADR)* | Stack, structure, auth, conventions, time handling. **Do not re-decide these.** |
| 4 | Notion → *MVP Scope Decisions* | Production gate, what is in and out of scope |
| 5 | `design/index.html` | **Visual source of truth.** Layout, spacing, motion, component look |
| 6 | `https://api.hospital-ai.uz/v1/docs` | Exact request/response schemas — always more current than any doc |

Notion pages are only reachable through the browser: the `notion` MCP server is Cloudflare-403'd and
the `claude_ai_Notion` one is authenticated to a workspace that does not hold these pages.

---

## Standing rules — apply to every phase, no exceptions

These are the product's legal and safety foundation. Breaking one is a release blocker.

1. **No AI-generated text may reach a patient's screen.** There must be no code path from a model to
   patient UI. Not disabled — absent.
2. **Every patient-visible string resolves from the content library by key.** No string literals in
   patient-facing widgets, ever. Enforced by a CI gate from F0 onward.
3. **Unapproved content fails closed.** No sign-off → render nothing and raise. Never a fallback,
   never another language.
4. **The app never judges.** It never says a symptom is normal, safe, or concerning. It delivers the
   clinic's instructions and routes to humans.
5. **Instructions are attributed to the clinic:** "Your clinic's instruction: …".
6. **No clinical free text in telemetry.** Events carry IDs and categorical values only.
7. **Tier is assigned server-side.** The client renders whichever screen the `tier` field names. No
   client-side triage logic, not even as a fallback.
8. **Red is reserved for medical emergency.** Overdue is grey. A patient who sees red for a missed
   vitamin learns to ignore red, and then ignores it when it matters.
9. **Never render the API's `message` field to a patient.** Map `code` → content-library string.
10. **The only hardcoded strings in the whole app** are the three language names on P1:
    `Oʻzbekcha`, `Русский`, `English`.

---

## Stack — decided in the ADR, not open

| Layer | Choice |
|---|---|
| Framework | Flutter 3.x stable, Dart 3 |
| State | **Riverpod** (`flutter_riverpod` + `riverpod_generator`) |
| Routing | **go_router** |
| HTTP | `dio` with interceptors |
| Models | `freezed` + `json_serializable` |
| Local DB | `drift` (task cache, action queue, content cache) |
| Secure storage | `flutter_secure_storage` (Keychain / Keystore) — tokens never in SharedPreferences |
| Notifications | **`flutter_local_notifications` only. No FCM, no push service.** Reminders are scheduled locally from the 30-day task list. |
| Localization | **Content library API, not ARB files.** Every string, including UI chrome. |
| Time | `timezone` + `intl`. Store UTC, compute recovery day in the clinic timezone |
| Tests | `flutter_test`, `integration_test`, `mocktail` |

Folder layout is **feature-first**, per the ADR:

```
lib/
├─ main.dart
├─ app.dart                       ProviderScope + MaterialApp.router
├─ core/
│  ├─ config/                     env, clinic config, feature flags
│  ├─ theme/                      tokens, typography, theme
│  ├─ widgets/                    design-system components
│  ├─ network/                    dio, interceptors, error mapping
│  ├─ storage/                    secure storage, drift database
│  ├─ content/                    content repository, cache, Txt widget
│  ├─ sync/                       action queue, sync worker, connectivity
│  ├─ telemetry/                  client-side events
│  ├─ router/                     go_router config + guards
│  └─ time/                       recovery-day + timezone helpers
└─ features/
   ├─ onboarding/                 P1 P2 P3 P4 P5
   ├─ today/                      P6 P7
   ├─ medication/                 P8
   ├─ progress/                   P9
   ├─ checkin/                    P10 P11 P12 P13
   ├─ learn/                      P14 P15
   ├─ settings/                   P16
   └─ survey/                     P17
```

---

## Patient API surface — the whole thing, 14 calls

All require `Authorization: Bearer <patient accessToken>` except the first.

| # | Method | Path | Screen | Notes |
|---|---|---|---|---|
| 1 | `POST` | `/auth/patient/session` | P2 P3 | No auth. `{code, phone}` → tokens |
| 2 | `POST` | `/me/consent` | P4 | `{version}`. Fires `patient_enrolled`. Idempotent |
| 3 | `GET` | `/me/profile` | P5 P16 | name, recoveryDay, language, procedureType, clinic contact + hours |
| 4 | `GET` | `/me/today` | P6 | tasks grouped by type + `checkinDue` |
| 5 | `POST` | `/tasks/{id}/complete` | P6 P7 | **`Idempotency-Key` required** |
| 6 | `GET` | `/me/progress` | P9 | adherence with denominator, per-day series |
| 7 | `GET` | `/me/checkin/questions` | P10 | option labels arrive pre-translated |
| 8 | `POST` | `/checkins` | P10 | **`Idempotency-Key` required** → returns `tier` |
| 9 | `GET` | `/content/{key}?lang=` | all | **`lang` required, no fallback** |
| 10 | `GET` | `/me/content?category=education` | P14 | unlocked content keys |
| 11 | `POST` | `/me/survey` | P17 | idempotent, day-30 gated |
| 12 | `PATCH` | `/me/language` | P16 | `{language}` |
| 13 | `POST` | `/me/leave` | P16 | self-withdraw, retains data |
| 14 | `POST` | `/me/app-opened` | P5 P6 | engagement telemetry |

**Error envelope:** `{ "code": "MACHINE_READABLE", "message": "…", "details": {} }`

Codes to handle: `VALIDATION_ERROR`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`,
`WRONG_TOKEN_AUDIENCE`, `DUPLICATE_REQUEST`, `CONTENT_NOT_APPROVED`,
`CLINICAL_CONTENT_NOT_APPROVED`, `CROSS_CLINIC_FORBIDDEN`, `INTERNAL_ERROR`.

Verified live behaviour:

- `GET /v1/content/today.title?lang=EN` → `{"code":"CONTENT_NOT_APPROVED", …}` — the fail-closed path is real
- `GET /v1/me/today` with no token → `{"code":"UNAUTHORIZED","message":"Missing bearer token."}`

**Client-side telemetry (ours to fire):** `language_selected` (with `is_change`),
`medication_reminder_sent`, `medication_confirmed` (with `on_time`), `content_viewed` (with
`content_ref`), `emergency_screen_shown`.

Everything else fires server-side when we call the endpoint.

---

## Design system — ratified from `design/index.html`

### Colour

```
brand-50  #EEF3FF   brand-100 #DDE7FF   brand-200 #C2D3FF   brand-300 #9DB8FF
brand-400 #6E93FF   brand-500 #4C7CFF   brand-600 #3B6EF6   brand-700 #2F5FE0
brand-800 #2450C8
ink       #1A2430   muted     #5B6673   line      #E6EAF2
surface   #FFFFFF   canvas    #F2F5FA
```

**Safety tokens — never re-mapped, never reused for anything else:**

```
emergency #B3261E    urgent #B36B00    routine #7A6A00
success   #1B7F5A    overdue #5B6673
```

### Type — Inter, bundled. Line height 1.5 throughout.

| Style | Size / weight | Use |
|---|---|---|
| Display | 28 / 700 | Screen titles |
| H1 | 22 / 700 | Section headings |
| H2 | 18 / 600 | Card titles |
| **Body-L** | **18 / 400** | **Patient default body — the floor, not a suggestion** |
| Body | 16 / 400 | Secondary, non-essential text only |
| Caption | 14 / 400 | Timestamps, helper text |
| Button | 18 / 600 | All buttons |

> **Correction to carry into F1.** The HTML prototype uses 16.5–17px for task titles and some body
> text. That is below the spec's 18sp patient minimum, which exists because post-operative patients
> are frequently older, tired and medicated. **Flutter uses 18 as the floor.** Task rows and cards
> therefore need slightly more vertical room than the prototype shows — let titles wrap to two lines
> rather than shrinking the type.

### Spacing — 4pt grid, permitted values only: `4 8 12 16 24 32 48 64`

Screen padding 16–20 · card padding 16 · section gap 24

### Radii and elevation — softer than the spec's flat 12px, matching the prototype

```
card 20   ·   button 16   ·   icon tile 15   ·   sheet 30   ·   pill full
shadow-card  0 1px 2px rgba(16,24,40,.04), 0 8px 24px rgba(16,24,40,.06)
shadow-lift  0 2px 6px rgba(16,24,40,.06), 0 16px 40px rgba(16,24,40,.10)
shadow-nav   0 8px 32px rgba(16,24,40,.16)
```

### Touch targets

Minimum **48dp** · primary patient actions (task checkbox, Continue, Taken) **64dp** ·
emergency call button in the sheet **68dp, full width**.

### Ratified deviations from the written spec

| Deviation | Why | Status |
|---|---|---|
| **Bundled placeholder seed** — `assets/content/seed_content.json` ships the Content Pack strings (EN verbatim; UZ/RU carry the server's own `[XX PLACEHOLDER — NOT CLINICALLY APPROVED]` prefix). Served ONLY when the server explicitly lacks a key AND `ALLOW_BUNDLED_PLACEHOLDERS` (dart-define, default true) is set — the app-side mirror of the backend's `ALLOW_PLACEHOLDER_CONTENT` gate. Server always wins; production builds set it false and are strictly fail-closed. | The live server seeds only `emergency.*`, `checkin.*`, `contact.*` — without the seed every other screen fails closed and nothing is demonstrable for the award. **The real fix is backend seeding of the full Pack** (list below). | Implemented in F3 — flag it to the backend owner |
|---|---|---|
| Brand is blue, not teal `#0F5F6B` | Matches the clinician dashboard and the references | **Ratified** — you chose the blue references and dashboard match |
| Emergency instruction is a persistent 44dp red button that expands into a sheet, not a full-width 44dp bar | The approved string is 103 chars and wraps to 3 lines at 360dp — the bar could never actually be 44 tall. The button is on every screen and not dismissible; the sheet carries the full verbatim text plus both dial actions. **Trade: the words are one tap away rather than always on screen.** | **Ratified** — you requested the round button + animated sheet yourself |
| Softer radii and shadows than flat 12px cards | The iOS feel you asked for | Accepted |
| Bottom nav is a floating pill, active item a 50dp inner pill | Reference designs | Accepted |

Both open items block F1. Everything before F1 proceeds regardless.

---

# PHASES

## F0 · Project foundation ✅

**Goal:** an empty app that builds, lints, and already refuses hardcoded patient strings.

**Depends on:** nothing

**Files**

- `pubspec.yaml` — add: `flutter_riverpod` `riverpod_annotation` `go_router` `dio`
  `freezed_annotation` `json_annotation` `drift` `sqlite3_flutter_libs` `path_provider`
  `flutter_secure_storage` `flutter_local_notifications` `timezone` `connectivity_plus` `uuid`
  `intl` `url_launcher` `package_info_plus` `permission_handler` `app_settings`
  `shared_preferences`
  · dev: `build_runner` `riverpod_generator` `freezed` `json_serializable` `drift_dev`
  `custom_lint` `riverpod_lint` `mocktail` `integration_test`
- `assets/fonts/Inter-*.ttf` plus the font declaration in `pubspec.yaml`
- `analysis_options.yaml` — strict mode, `prefer_const_constructors`,
  `always_declare_return_types`, `custom_lint` plugin enabled
- `lib/main.dart`, `lib/app.dart` — `ProviderScope` + `MaterialApp.router` shell
- `lib/core/config/env.dart` — `API_BASE_URL` via `--dart-define`, never hardcoded
- `tool/check_no_patient_literals.dart` — the CI gate, see below
- `.github/workflows/ci.yml` — `flutter analyze` · `dart run tool/check_no_patient_literals.dart` ·
  `flutter test`
- `README.md` — how to run, how to pass the enrolment code

**The literal gate.** A Dart script that walks `lib/features/**` and `lib/core/widgets/**`, parses
each file, and fails on any string literal reaching a `Text`, `Semantics.label`, `hintText`,
`labelText` or `tooltip`. Allowlist: `lib/features/onboarding/p1_language_screen.dart` for the three
language names, plus `debugLabel` and `Key(...)` arguments. Run it in CI from day one — retrofitting
this after 17 screens is how the rule quietly dies. F3 replaces it with a proper `custom_lint` rule;
the script stays as the belt to that braces.

**Done when**

- [x] `flutter analyze` clean, `flutter test` green, `flutter build apk --debug` succeeds
- [x] The gate fails on a deliberately added `Text('hello')` in a feature file, and passes once removed
- [x] `API_BASE_URL` is absent from source; the app refuses to start without the define
- [x] Inter renders in a smoke-test widget

---

## F1 · Design system layer ✅

**Goal:** every token and component from `design/index.html`, as Flutter widgets, reviewable on a
device before a single screen exists.

**Depends on:** F0 · **and the two ratification questions above being answered**

**Files**

- `lib/core/theme/tokens.dart` — colours, spacing constants, radii, shadows, durations
- `lib/core/theme/typography.dart` — the seven styles, 18sp floor enforced
- `lib/core/theme/app_theme.dart` — `ThemeData` wiring both
- `lib/core/widgets/`
  - `primary_button.dart` · `secondary_button.dart` · `disabled_button.dart`
    (border fill + muted text — **visible, never ghosted away**)
  - `app_card.dart` · `glass_card.dart`
  - `task_row.dart` — 46dp icon tile, wrapping title, 34dp check inside a 64dp target. States:
    pending · completed (success tick, muted, strikethrough, **still visible**) · overdue
    (grey text, grey dot, **no red, no exclamation, no scolding copy**)
  - `emergency_button.dart` + `emergency_sheet.dart` — 44dp red circle, slow halo pulse, animated
    sheet with the verbatim text and both dial actions. **No dismiss path on the button itself.**
  - `bottom_nav.dart` — floating pill, 64dp bar, 50dp active inner pill
  - `app_text_field.dart` · `code_field.dart` (mono, 24pt, letter-spaced, centred, auto-uppercase)
  - `scale_selector.dart` — 11 circular 48dp targets; the **only** horizontally scrollable thing in
    the whole app
  - `tier_chip.dart` — icon + text label + colour, **never colour alone**
  - `content_slot.dart` · `fail_closed_panel.dart`
  - `offline_strip.dart` · `progress_ring.dart` · `day_grid.dart`
  - `app_sheet.dart` — the shared animated bottom sheet
- `lib/features/dev/design_gallery_screen.dart` — every component in every state, on a debug-only route

**Done when**

- [x] The gallery renders all components side by side with `design/index.html`, and they match
- [x] Every component honours the 18sp body floor
- [x] No raw `Color(0x…)` exists outside `tokens.dart`
- [x] Golden tests for `task_row` (3 states), `tier_chip` (3 tiers), buttons (4 states) — plus an automated no-red-pixels check on the overdue row
- [x] Nothing overflows in the gallery at 200% text scale
- [x] Contrast check: every text/background pair meets WCAG AA (4.5:1 body, 3:1 large) — automated in `test/theme/contrast_test.dart`

---

## F2 · Network layer and typed API client ✅

**Goal:** all 14 patient calls, typed, with interceptors that make the safety rules structural rather
than remembered.

**Depends on:** F0

**Files**

- `lib/core/network/dio_client.dart` — base URL, timeouts tuned for a poor connection
  (connect 10s, receive 20s), backoff retry on idempotent verbs only
- `lib/core/network/auth_interceptor.dart` — attaches the bearer, refreshes once on 401,
  **never forces re-login inside the 30-day programme**
- `lib/core/network/idempotency_interceptor.dart` — asserts an `Idempotency-Key` on
  `POST /tasks/{id}/complete` and `POST /checkins`; **throws in debug when one is missing**
- `lib/core/network/api_error.dart` — parses the envelope into a sealed `ApiError`. `message` is
  marked `@visibleForTesting` so it cannot casually reach UI
- `lib/core/network/error_content_map.dart` — every error `code` → content key
- `lib/core/api/patient_api.dart` — the 14 methods
- `lib/core/models/*.dart` — freezed models: `PatientSession` `Profile` `Clinic` `TodayResponse`
  `Task` `ProgressResponse` `CheckinQuestion` `CheckinOption` `CheckinResult` `ContentItem`
  `EducationIndex` `SurveyPayload`
- `test/network/*` — one test per error code, plus a duplicate-key replay test

**Done when**

- [x] Every model round-trips — `ContentItem` + both error envelopes against LIVE captures in `test/fixtures/`; authenticated shapes against the handoff's canonical payloads *(live captures blocked until an enrolment code exists — F4 prerequisite)*
- [x] A missing `Idempotency-Key` on either endpoint throws in debug AND is refused before reaching the wire in release
- [x] `WRONG_TOKEN_AUDIENCE` and `CROSS_CLINIC_FORBIDDEN` map to content keys, not raw text
- [x] No test asserts on `message` reaching a widget — `message` is `@visibleForTesting`
- [x] Retry/backoff verified against simulated transport failures *(real throttled-connection pass lands in F12)*

---

## F3 · Content resolution layer ✅

**Goal:** the mechanism that makes rules 2 and 3 true, plus text that survives offline.

**Depends on:** F2

**Files**

- `lib/core/content/content_repository.dart` — resolve by `key + lang`, returning a sealed result:
  `Resolved(text, version, isPlaceholder)` · `NotApproved` · `Unavailable`
- `lib/core/storage/content_cache.dart` (drift table) — keyed by `contentKey + language + version`,
  invalidated when the version changes. **Unapproved content is never cached.**
- `lib/core/content/txt.dart` — the `Txt('key.name')` widget: resolves, renders, and on `NotApproved`
  renders the fail-closed panel instead. **This is the only way text reaches a patient screen.**
- `lib/core/content/interpolate.dart` — `{CLINIC_NAME}` `{CLINIC_PHONE}` `{FIRST_NAME}`
  `{OPENING_TIME}` `{WORKING_HOURS}` `{WORKING_DAYS}` `{N}`, filled from profile + clinic config
- `lib/core/content/emergency_bundle.dart` — caches `emergency.headline`, `emergency.body`,
  `emergency.banner` and both numbers **at enrolment**, so P13 works with no network, ever
- `tool/lints/no_patient_literals.dart` — the proper `custom_lint` rule replacing the F0 script
- `test/content/*` — fail-closed, no-fallback, cache-invalidation and interpolation tests

**Done when**

- [x] `Txt` on an unapproved key renders nothing / `TxtGate` shows the fail-closed panel — never a fallback *(telemetry hook lands in F11)*
- [x] Switching language never shows the previous language's text, not even for a single frame — asserted in `txt_widget_test.dart`
- [x] With the network off, cached content renders and the emergency bundle survives a cold start with no network
- [x] ~~custom_lint IDE rule~~ **Deviation:** the F0 CI gate script covers enforcement; a custom_lint plugin package was judged not worth its build-time cost for a solo repo. Revisit if more devs join.
- [x] The cache invalidates when `version` increments

---

## F4 · Auth, secure session, routing ✅ *(live-code verification pending)*

**Goal:** a patient gets in once and is never logged out for 30 days.

**Depends on:** F2, F3
**Prerequisite from you:** a live enrolment code + phone pair. Codes are single-use and expire after
14 days, so any code written into a document is stale by the time it is read. **Ask before starting.**

**Files**

- `lib/core/storage/secure_store.dart` — tokens in Keychain / Keystore only
- `lib/features/onboarding/data/auth_repository.dart` — enrol, refresh, sign out
- `lib/core/router/app_router.dart` — go_router: `/language` `/code` `/phone` `/consent` `/welcome`,
  a shell route for `/today` `/progress` `/learn` `/settings`, plus `/task/:id` `/medication/:id`
  `/checkin` `/checkin/result` `/emergency` `/article/:key` `/survey`
- `lib/core/router/guards.dart` — no session → onboarding · session but no consent → `/consent` ·
  consent version changed → re-consent on next open · day > 30 → `/survey`
- `test/auth/*` — lockout after 3 phone attempts, rate limit surfaced as a content key, no token in
  plain preferences

**Done when**

- [ ] Real enrolment against the live API succeeds end to end — **BLOCKED: needs a live enrolment code + phone pair from you** (everything else is built and tested against fakes)
- [x] Killing and reopening the app lands on Today with no re-login — session snapshot loads before the first frame; tested
- [x] Silent-refresh is impossible until the backend adds a patient refresh endpoint (gap flagged above); what IS guaranteed and tested: failures never log the patient out mid-programme, tokens survive, errors surface as content keys
- [x] `flutter_secure_storage` holds the tokens; `SharedPreferences` carries only non-sensitive routing flags
- [x] Error copy never reveals whether a code exists, nor anything about the stored phone number — the code path renders content keys only

---

## F5 · Local persistence and the offline sync engine ✅

**Goal:** seven days offline, and a queue that cannot double-post.

**Depends on:** F2

**Files**

- `lib/core/storage/app_database.dart` (drift) — tables:
  - `cached_tasks` — the next 7 days
  - `pending_actions` — `id, type, payload, idempotencyKey, occurredAt, attempts, lastError`
  - `content_cache`
  - `telemetry_outbox`
- `lib/core/sync/action_queue.dart` — enqueue with a **persisted** `Idempotency-Key` (uuid v4),
  generated once per logical action and **reused on every retry**
- `lib/core/sync/sync_worker.dart` — drains on connectivity regain and on app resume, exponential
  backoff, and **preserves `occurredAt` — never overwrites it with the sync time**
- `lib/core/sync/connectivity.dart` — a Riverpod stream feeding the offline strip
- `lib/core/time/recovery_day.dart` — recovery day computed in the **clinic** timezone; discharge = day 0
- `test/sync/*` — replay produces exactly one effect; day-boundary and DST cases

**Done when**

- [x] Offline: cached tasks readable, completions tick locally and queue *(unit-tested with in-memory drift; on-device airplane-mode pass lands in F13)*
- [x] Sync sends the **original** `occurredAt`, never the sync time — asserted on the wire
- [x] Replaying the same persisted key: worker replays it verbatim; `DUPLICATE_REQUEST` settles the row as one effect
- [x] `DUPLICATE_REQUEST` is handled, not crashed
- [x] Recovery day correct across a clinic-local day boundary AND a DST transition (`recovery_day_test.dart`)
- [x] **Check-in submission is never enqueued** — the queue's type has no check-in member (unrepresentable), pinned by a test

---

## F6 · Onboarding · P1 → P5 ✅

**Goal:** discharge to Today in under three minutes, one-handed, by a 70-year-old, on a bad connection.

**Depends on:** F1, F3, F4

| Screen | Must be true |
|---|---|
| **P1** Language | Three 64dp targets, each in its own script. The **only** hardcoded strings in the app. Device language read, **never** auto-selected. Choice survives restart. `language_selected(is_change:false)` fires exactly once. No other element on the screen. |
| **P2** Code | 6 chars, uppercase alphanumeric, mono 24pt letter-spaced centred, autocorrect off. Continue disabled under 6. Errors never reveal whether a code exists. Code survives rotation and backgrounding. Works offline up to submission, then explains clearly. |
| **P3** Phone | `+998` visible, not editable. Numeric keypad only. Spaces and dashes stripped before sending. A mismatch reveals nothing. Lock after 3 attempts, server-enforced. |
| **P4** Consent | Full scrollable text from the library. Checkbox unticked, **no pre-ticking ever**. Agree disabled until scrolled to the end **and** ticked. Decline writes **zero** personal data. `consent_version` stored with a timestamp. Renders correctly in all three languages. |
| **P5** Welcome | First name from `/me/profile`. Three lines including the clinic-hours cover statement. Notification rationale shown **before** the OS prompt. Denial never blocks — Today then shows a persistent non-blocking banner; re-prompt once at day 3, then never again. |

**Done when**

- [x] First launch: P1→P4 in 3 taps (asserted); P4 agree + P5 start bring the total to 5
- [x] An integration test drives P1 → P4 against an in-process fake of the live API's exact shapes *(live-API pass blocked on the enrolment code, same as F4)*
- [x] Consent gating cannot be bypassed by scrolling alone or ticking alone — widget-tested
- [x] The decline path posts no consent and wipes tokens + local flags *(server-side zero-write is the backend's contract; nothing is sent)*
- [x] Every string except the three language names comes from a content key — literal gate is clean

---

## F7 · Daily recovery · P6, P7, P9

**Goal:** the core loop. 90% of app time. Adherence — the pilot's primary metric — is produced
entirely here, so optimise these above everything else.

**Depends on:** F1, F3, F5

| Screen | Must be true |
|---|---|
| **P6** Today | Hero: day ring, `Day {N} of 30`, tasks-done bar. Emergency affordance present. Check-in entry visually distinct when due. Task list ordered by scheduled time. **Completed tasks stay visible** (success tick, muted, strikethrough) — seeing what you finished is the motivation. **Overdue is grey with a grey dot — never red, never "you missed".** Day 0 empty state, never a blank screen. No tasks → an explicit "nothing scheduled today", never an empty list. After day 30 → programme-complete state, route to P17. Checkbox target 64dp. Contact-clinic button. **Loads and is usable in under 2 seconds on a mid-range Android.** |
| **P7** Task detail | Title, scheduled time, full instruction resolved from `contentRef`. Optional approved image. `Mark as done` at 64dp. An already-complete task shows a completed state and **allows un-completing** — patients mis-tap. The correction is logged as a **new** `task_uncompleted` event, never a mutation of the original. Missing content **fails closed**. |
| **P9** Progress | Days of 30, the percentage **with its denominator always shown**, a 30-day grid, one rotating encouraging line. The percentage **excludes future tasks** — otherwise it always looks terrible on day 2. **No clinical interpretation anywhere.** **No discouraging copy at any adherence level** — a struggling patient is a clinical concern, not someone to shame, and shame drives abandonment. Works offline from cache. |

**Done when**

- [ ] Cold start to interactive Today under 2s on a mid-range device — measured, not assumed
- [ ] Zero red pixels on P6 in every task state — automated golden check
- [ ] Un-complete produces a second event; the original row is untouched in the server log
- [ ] P9 renders from cache with the network off
- [ ] 200% font scale: no overflow on any of the three screens

---

## F8 · Notifications and medication · P8

**Goal:** the highest-value habit in the programme, with exactly two choices. Missed medication is a
leading cause of readmission.

**Depends on:** F5, F7

**Files:** `lib/core/notifications/` (scheduler, channels, timezone init) · `lib/features/medication/`

**Must be true**

- Local notifications only. Reminders scheduled from the 30-day task list generated at enrolment, so
  they fire with no connectivity and no server round-trip.
- Tapping a reminder opens **P8 directly** for that medication, not a generic screen.
- Medication name, dose and time come from the clinic-approved schedule. **The patient can never edit
  a dose or a schedule anywhere in the app.**
- **Exactly two actions: `Taken` · `Not yet`.** No third option, no snooze menu, no free text.
- `Not yet` → close, and repeat the reminder **once** after 30 minutes.
- Late confirmation is still recorded, with `on_time: false` — that is valuable data, not a failure.
- Notifications denied → medication tasks still appear on P6, and the P5 banner explains why
  reminders are off and how to enable them.
- Fire `medication_reminder_sent` and `medication_confirmed(on_time:)`.

**Done when**

- [ ] A reminder fires on a real device in airplane mode
- [ ] The deep link opens the correct medication
- [ ] The 30-minute repeat fires exactly once, never twice
- [ ] Reinstall and reboot both reschedule correctly
- [ ] No editable dose field exists anywhere — grep-verified

---

## F9 · Check-in and escalation · P10 → P13

**Goal:** the highest-liability screens in the product. Build these slowly.

**Depends on:** F1, F3, F5

**Must be true**

- **P10** — one question per screen, progress indicator, emergency affordance on **every** question.
  Answer types: yes/no, single-select, multi-select, 0–10 scale. **Zero free-text fields.**
  Question text is a content key; option labels arrive pre-translated and render directly.
  Partial completion saves and resumes **within the same day**.
  Submit with a required `Idempotency-Key`. `rule_version` recorded with every submission.
  **A failed submission must never render as success.**
  **Offline → block, show the clinic phone and the emergency instruction, and do not queue.**
- **Routing is entirely on the server's `tier`:** `routine` → P11 · `urgent` → P12 ·
  `emergency` → P13. There is no client-side rule, not even as a fallback for a malformed response —
  a malformed response is an explicit error.
- **P11 routine** — neutral acknowledgement. Body from `checkin.submitted.routine`. The clinic's
  standing instruction on worsening symptoms, plus the phone number.
  **Forbidden:** "that sounds normal", "nothing to worry about", "your answers look fine", or any
  interpretation at all. This is the screen most likely to tempt a well-meaning developer into adding
  reassurance.
- **P12 urgent** — `checkin.submitted.urgent` verbatim, or `checkin.submitted.out_of_hours` when
  `withinClinicHours` is false. Two large buttons: `Call clinic` · `Call 103`. Clinic name and phone
  injected from `/me/profile`, never hardcoded. **No response-time promise anywhere** — the SLA is an
  internal target, and an unmet promise is worse than none.
- **P13 emergency** — full-screen, high contrast. `emergency.headline` verbatim. `emergency.body`.
  Giant `Call 103`, secondary call clinic, dismiss present but deliberately de-emphasised.
  **Renders and dials with no network**, from the F3 emergency bundle.
  Identical in and out of clinic hours — it has no staff dependency, which is exactly what makes
  clinic-hours-only cover safe. Shown **before** staff are notified.
  **Cannot be suppressed, deduplicated, or rate-limited**, however many times it triggers.
  `emergency_screen_shown` logged **every single time**, queued when offline.

> Keep P11, P12 and P13 as three separate screens. Do not refactor them into one parameterised
> screen. The duplication is the safety feature: each is independently reviewable by the clinician,
> independently testable by QA, and impossible to show at the wrong reassurance level through a
> templating mistake.

**Done when**

- [ ] All 7 questions render and submit against the live API
- [ ] Every tier route verified with real answers, not mocks
- [ ] Grep proves no tier logic exists anywhere in `lib/features/checkin/`
- [ ] An offline attempt shows contact options and **nothing enters the queue** — asserted in a test
- [ ] A forced 500 renders an explicit failure with the clinic phone, never a success screen
- [ ] **P13 renders and places a real call in airplane mode, on a real device**
- [ ] `emergency_screen_shown` is present in the outbox after an offline trigger

---

## F10 · Learn, Settings, Survey · P14 → P17

**Depends on:** F1, F3, F5

| Screen | Must be true |
|---|---|
| **P14** Learn | Grouped by Wound care · Medication · Activity · What to expect. Each row: title + estimated read time. Items relevant to the current recovery day surfaced at the top. **Items not yet unlocked are hidden, not greyed** — greying invites patients to seek out later-stage advice early. Unlocks on days 1, 3, 5, 7, 14, 21. Friendly empty state if the procedure has no content. Available offline from cache. |
| **P15** Article | Title, body, optional approved images. Footer disclaimer verbatim from `content.disclaimer` on **every** article. **No summarisation, no simplification, no AI adaptation** — render exactly what the clinician approved. A missing translation → explicit "not yet available in your language" plus clinic contact, **never** a silent language fallback. Fire `content_viewed(content_ref:)`. |
| **P16** Settings | Language switcher, all three, applying **instantly with no restart**. Notification preferences deep-link to OS settings. Clinic contact card with a tappable call button. **Prominent** cover statement from `settings.cover_hours`. Programme info: start date, current day, end date. `Leave programme` with explicit confirmation → notifies the clinic, because a patient dropping out is clinically relevant information, not just a churn metric. **Withdrawal stops the programme but does not delete data.** App version + support contact. |
| **P17** Survey | Exactly **five** questions, no more. Two 1–5 scales, two categorical, one optional free text. Scale direction identical in all three languages (1 = worst). Always skippable — never blocks programme completion. One reminder after 48 hours, then never again. A patient who withdrew early still gets it once. **The free-text content must never appear in an analytics event** — send `has_free_text: true/false` only. |

**Done when**

- [ ] A language switch re-renders every visible string with no restart and no flash of the old language
- [ ] Locked articles are absent from the widget tree, not merely invisible
- [ ] The survey payload contains no free text — asserted in a test
- [ ] Leaving notifies the clinic and retains data — verified server-side

---

## F11 · Telemetry

**Depends on:** F5

**Files:** `lib/core/telemetry/telemetry.dart` · `event.dart` · `outbox.dart`

**Must be true**

- Five client events: `language_selected`, `medication_reminder_sent`, `medication_confirmed`,
  `content_viewed`, `emergency_screen_shown`
- Queued offline, flushed on reconnect, deduplicated by event id
- **No clinical free text, ever.** Events carry ids and categorical values only.
- A compile-time or test-time assertion that a payload cannot hold arbitrary strings

**Done when**

- [ ] A simulated 30-day patient fires every event with correct values
- [ ] A test proves no free text can enter a payload
- [ ] `emergency_screen_shown` is never dropped, including offline

---

## F12 · Accessibility, localization, resilience hardening

**Depends on:** F6 – F10

- Semantic labels on every interactive element; a screen-reader pass on all 17 screens
- 200% system font scale on all 17 screens, no layout breakage
- WCAG AA contrast verified on every combination
- **Never colour alone** to convey meaning — every tier carries an icon and a text label, because
  roughly 8% of men have colour vision deficiency and this app carries emergency information
- No animation required to understand any state; `prefers-reduced-motion` honoured
- Copy verified in all three languages on every screen
- Nothing horizontally scrollable except the 0–10 scale
- Single column, 320–480dp
- Mid-range Android on a throttled connection: usable, no ANRs

**Done when**

- [ ] TalkBack and VoiceOver both complete full onboarding and a check-in
- [ ] Screenshot matrix reviewed: 17 screens × 3 languages × {100%, 200%} scale
- [ ] An automated contrast test covers the token pairs

---

## F13 · Test suite and definition of done

**Depends on:** everything

- Widget tests on **all** patient screens
- Integration tests: full onboarding; a full check-in per tier
- Golden tests: design-system components, plus a **no-red-outside-emergency** check
- Adversarial suite mirroring the backend's: unapproved content renders nothing · patient token at a
  staff endpoint · duplicate check-in with the same key · offline check-in never queues · emergency
  screen never suppressed
- Simulated 30-day patient with telemetry validation

**The spec's definition of done — all must be true:**

- [ ] Every screen meets its own acceptance criteria
- [ ] All telemetry events fire correctly against a simulated 30-day patient
- [ ] **No patient-facing string exists outside the content library** — one grep comes back empty
      except the three language names on P1
- [ ] Copy verified in all three languages on every screen
- [ ] Full 7-day offline usage tested in airplane mode; sync produces no duplicate events
- [ ] An offline check-in attempt shows contact options and does **not** queue
- [ ] **P13 renders and dials with no network, verified on a real device with a real call attempt**
- [ ] Works on a mid-range Android device on a poor connection
- [ ] 200% font scale, screen reader labels, WCAG AA contrast

---

## F14 · Demo and release preparation

**Depends on:** F13

- Award-demo run-through against seeded patients at recovery days 1, 6, 14 and 29 — so Today, the
  day 5–10 surgical-site-infection window, mid-programme and completion are all immediately showable
- A demo control to advance a patient's recovery day — **staging and demo only, never production**
- Verify the production gate from the app side: with `ALLOW_PLACEHOLDER_CONTENT=false` the app
  **fails closed gracefully** and never shows a blank screen
- Verify `PATIENT_ENROLMENT_ENABLED=false` surfaces `CLINICAL_CONTENT_NOT_APPROVED` as a
  content-key message, not a crash
- Android release build: signing, `minSdk` for a mid-range fleet, R8, size check
- iOS release build: capabilities, notification entitlement
- A recorded walkthrough for the submission
- **The demo must never claim clinical outcomes.** Show adherence, engagement, escalations surfaced
  and response times. Never a readmission rate or an outcome claim. That restraint is defensible
  under scrutiny; the alternative is not.

**Done when**

- [ ] The whole product is demonstrable end to end in minutes rather than 30 days
- [ ] Both production-gate flags verified from the app, not only from the API
- [ ] Signed release builds install and run on a physical mid-range Android and a physical iPhone

---

## Explicitly out of scope — do not build

Deliberately cut, not reopenable before launch:

Free-roaming AI chat with patients · diet engine or food lookup · OCR / bulk document import ·
group or family care plans · **biometric login** (biometric data must be stored in-country) ·
video or voice calling in-app · patient-to-patient anything · clinic self-service onboarding ·
automated telephony · push notification service · more than two procedure types ·
patient data export by patients · multi-timezone patients.

---

## Dependency order at a glance

```
F0 foundation
 ├─ F1 design system      ← blocked on your two ratifications
 ├─ F2 network
 │   ├─ F3 content        ← the layer that makes the golden rules structural
 │   │   └─ F4 auth + routing   ← needs a live enrolment code from you
 │   └─ F5 offline + sync
 │
 ├─ F6  onboarding P1–P5         (F1 F3 F4)
 ├─ F7  daily recovery P6 P7 P9  (F1 F3 F5)
 ├─ F8  notifications P8         (F5 F7)
 ├─ F9  check-in P10–P13         (F1 F3 F5)   ← slowest, highest liability
 ├─ F10 learn/settings/survey    (F1 F3 F5)
 ├─ F11 telemetry                (F5)
 │
 ├─ F12 a11y + l10n hardening    (F6–F10)
 ├─ F13 tests + definition of done
 └─ F14 demo + release
```

F6, F7, F9 and F10 are independent of each other once F1–F5 are green, so they can be commanded in
any order — or in parallel if you want several running at once.

---

## What I need from you, and when

| When | What | Why it blocks |
|---|---|---|
| Before **F1** | **Blue brand, or back to the spec's teal `#0F5F6B`?** | Every token and component derives from it |
| Before **F1** | **The emergency affordance: persistent 44dp button + sheet, or the spec's full-width bar?** | Clinical, not cosmetic. It sets the app's chrome on every screen and changes how fast a patient reaches the emergency instruction |
| Before **F4** | **A live enrolment code + phone pair** | Codes are single-use and expire after 14 days; no real testing without one |
| Before **F8** | **A physical Android device** for reminder and call testing | An emulator cannot prove a real call or a real doze-mode reminder |
| Before **F14** | Confirmation that the Dev Build Board statuses may be updated | The board currently reads `Backlog` for work that is demonstrably done |

**Backend gaps found while building (send to the backend owner):**
- No patient token-refresh endpoint exists (`/auth/patient/session` is single-use). The 60-day refresh token is unusable until one exists; the app never force-logs-out, but a >24h access token will start failing.
- No telemetry ingestion endpoint exists for the five client-side events — the app queues them in a local outbox (never dropped), but they cannot reach the server until an endpoint ships.
- **Only `emergency.*`, `checkin.*`, `contact.*` are seeded in the content library.** Everything else the app needs (~128 keys) is missing and fails closed. The full required list is exactly the keys of `assets/content/seed_content.json` — seed the library from it (EN is Pack-verbatim; UZ/RU pending native-speaker review).

---

*Written 24 July 2026. Sources: `md/HOSPITAL_AI_FLUTTER_HANDOFF.md`; the Notion workspace
(Product Spec · Design System · Seed & Placeholder Content Pack · Build Decisions ADR ·
MVP Scope Decisions · Dev Build Board); the live OpenAPI at `api.hospital-ai.uz/v1/docs-json`;
and the prototype at `design/index.html`.*
