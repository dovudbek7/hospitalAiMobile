# Hospital AI — Demo login & how to test

**Short version:** run a debug build and you're in. No real code needed.

---

## 1. Demo mode (what you have right now)

Debug builds default to **DEMO MODE** — an in-app fake of the whole backend.
No network, no real credentials.

```sh
flutter run -d <device>          # e.g. -d A89187EE (iPhone 17 sim)
```

- **Enrolment code:** pre-filled `H7K9QP` (any 6-char code is accepted)
- **Phone:** pre-filled `90 123 45 67` (any number is accepted)
- Tap through: Language → Code → Phone → Consent → Welcome → **Today**
- You land as **Aziz**, recovery **day 6**, 6 tasks (2 done, wound-care overdue), a check-in due.

### What works end-to-end in demo

| Area | Try this |
|---|---|
| Today | tick a task, open a medication → **Taken / Not yet** |
| Check-in | answer calmly → **Routine** (P11) · pain 8 or "worse" → **Urgent** (P12) · tick **Chest pain** or **wound Opening** → **EMERGENCY** (P13) |
| AI Assistant | Today → **Ask about your care**. Ask "what did my doctor say about walking?" → grounded reply. Type **"chest pain"** / **"nafas"** / **"боль в груди"** → red-flag → **emergency screen** |
| Progress | 30-day grid, adherence with denominator |
| Learn | 3 unlocked articles (day 1/3/5) |
| Settings | switch **Oʻzbekcha / Русский / English** — everything re-renders instantly |
| Survey | Settings → "Day-30 survey (demo)" |

The tier decision and the assistant red-flag both run **server-side-in-miniature**
(`lib/core/demo/demo_server.dart`) — the app never decides urgency itself.

---

## 2. Testing against the LIVE backend

The live API (`https://api.hospital-ai.uz/v1`) is real and needs real credentials:

- **Patient login** = a one-time **enrolment code + phone** the clinic issues at
  discharge. There is **no self-registration** — `POST /patients` (create a
  patient / get a code) requires a **staff token**, and staff accounts aren't
  public. I could not fabricate a working code; the server correctly rejects
  invented ones (`UNAUTHORIZED`, revealing nothing).
- **The assistant** (`/me/assistant/messages`) also needs a patient token, so it
  only works after a real enrolment.

**To test live, get from the backend owner one of:**
1. a fresh enrolment **code + phone** pair (single-use, 14-day expiry), **or**
2. **staff credentials** (email + password) — then the app/dashboard can create
   patients itself.

Then run against the live API with demo mode off:

```sh
flutter run -d <device> \
  --dart-define=DEMO_MODE=false \
  --dart-define=API_BASE_URL=https://api.hospital-ai.uz/v1
```

Enter the real code + phone on P2/P3 (the pre-fill only appears in demo mode).

### Quick check the live API is up (no login needed)

```sh
curl -s "https://api.hospital-ai.uz/v1/content/emergency.headline?lang=EN"
# → {"contentKey":"emergency.headline",...,"text":"Your clinic's instruction: call 103 now."}
```

---

## 3. Registration

Self-registration is **out of scope by design** (spec §9 / MVP Scope):
patients are enrolled by clinic staff, never by the app. So there is no patient
"sign up" screen to ship. If you want to create patients for testing, that's the
staff path (item 2 above) — the dashboard, not this app.

---

*Demo mode is debug-only. Release builds always talk to the live API and require
a real code, unless explicitly built with `--dart-define=DEMO_MODE=true`.*
