# Hospital AI — Patient App

Flutter app for a 30-day post-operative recovery programme. A patient is
discharged, installs this app, and for 30 days it shows what to do each day and
collects a structured symptom check-in. Dangerous check-ins alert the clinic —
or tell the patient to call 103.

**Spec:** `md/HOSPITAL_AI_FLUTTER_HANDOFF.md` · **build plan:** `md/steps.md` ·
**approved visual prototype:** `design/index.html`

## The one rule that shapes everything

> No AI-generated text ever reaches a patient's screen.
> Every patient-visible string comes from the content library, by key.

Practically: never hardcode patient-facing text. `tool/check_no_patient_literals.dart`
enforces this in CI and fails the build on violations. The only permitted
hardcoded strings are the three language names on P1.

## Run

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define=API_BASE_URL=https://api.hospital-ai.uz/v1
```

The app refuses to start without `API_BASE_URL` — nothing is hardcoded.

### Enrolment

There is no self-registration. Clinic staff create the patient and hand over a
6-character code at discharge. For development, ask the backend owner for a
current code + phone pair — codes are single-use and expire after 14 days, so
none are written into this repo.

## Checks

```sh
dart run tool/check_no_patient_literals.dart   # golden rule 2 gate
flutter analyze
flutter test
```

## Structure

Feature-first, per the ADR — see `md/steps.md` for the full map and the
F0–F14 phase plan.
