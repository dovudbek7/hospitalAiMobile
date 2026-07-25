# Hospital AI — Flutter ↔ API Connection & Integration Guide

**Companion to** `HOSPITAL_AI_FLUTTER_HANDOFF.md` (that one lists the 17 screens; this
one is the *plumbing* — how the Flutter app actually connects to and talks to the
backend, with copy-pasteable Dart).

**Backend:** live and deployed. **You are not blocked.**

---

## 1. Production connection details

| | |
|---|---|
| **API base URL** | `https://api.hospital-ai.uz/v1` |
| **Live API docs (Swagger/OpenAPI)** | `https://api.hospital-ai.uz/v1/docs` |
| **Transport** | HTTPS (TLS, Let's Encrypt). No plain HTTP. |
| **Auth** | Bearer JWT in the `Authorization` header |
| **Content type** | `application/json` everywhere EXCEPT the assistant stream, which is `text/event-stream` |
| **Default language of errors** | English `code` strings — map them, never show `message` to a patient |

Put the base URL in a single place and switch on build mode:

```dart
class Api {
  static const String base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://api.hospital-ai.uz/v1',
  );
}
// Run with a local backend:  flutter run --dart-define=API_BASE=http://10.0.2.2:3000/v1
// (10.0.2.2 is the host machine from the Android emulator; use your LAN IP on a real device.)
```

---

## 2. Suggested packages

```yaml
dependencies:
  dio: ^5.7.0                    # HTTP client + interceptors
  flutter_secure_storage: ^9.2.2 # Keychain / Keystore for tokens
  flutter_riverpod: ^2.5.1       # state (per the ADR)
  http: ^1.2.2                   # only for the SSE stream (Dio streaming works too)
```

You can do everything with `dio` alone; `http` is shown for the streaming example because
its `StreamedResponse` is slightly simpler to read line-by-line.

---

## 3. Token storage & the auth interceptor

There is **no password and no self-registration**. The patient exchanges a one-time
enrolment **code + phone** for tokens, then every call carries the access token.

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  static const _access = 'hospital_ai.access';
  static const _refresh = 'hospital_ai.refresh';
  final _s = const FlutterSecureStorage();

  Future<void> save(String access, String refresh) async {
    await _s.write(key: _access, value: access);
    await _s.write(key: _refresh, value: refresh);
  }
  Future<String?> access() => _s.read(key: _access);
  Future<String?> refresh() => _s.read(key: _refresh);
  Future<void> clear() async { await _s.delete(key: _access); await _s.delete(key: _refresh); }
}
```

```dart
import 'package:dio/dio.dart';

Dio buildDio(TokenStore tokens) {
  final dio = Dio(BaseOptions(
    baseUrl: Api.base,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final t = await tokens.access();
      if (t != null) options.headers['Authorization'] = 'Bearer $t';
      handler.next(options);
    },
    onError: (e, handler) {
      // 401 = token expired/invalid. The 24h access token expires during the
      // 30-day programme; re-bootstrap the session from the stored code path in
      // your app, or send the patient back to enrolment. NEVER force a password.
      handler.next(e);
    },
  ));
  return dio;
}
```

> **Session rule (from the spec):** the session persists for the whole 30-day
> programme — do **not** force re-login. Store the tokens; on 401, refresh silently or
> route to the enrolment screen, never a login wall.

---

## 4. Enrolment: code + phone → tokens (P2/P3)

```dart
Future<void> enrol(Dio dio, TokenStore tokens, String code, String phone) async {
  final res = await dio.post('/auth/patient/session', data: {
    'code': code,          // 6 chars, uppercase
    'phone': phone,        // '+998901234567'
  });
  await tokens.save(res.data['accessToken'], res.data['refreshToken']);
}
```

**Error handling (security-critical — never reveal existence):**

```dart
try {
  await enrol(dio, tokens, code, phone);
} on DioException catch (e) {
  final code = e.response?.data['code'];
  // Show a GENERIC "check your code and phone, or contact your clinic" message.
  // Do NOT tell the user whether the code exists or the phone matched — the
  // server deliberately doesn't, and neither should the UI.
}
```

---

## 5. Standard request pattern (the whole `me` surface)

Every patient endpoint is a normal JSON GET/POST with the bearer token. Examples:

```dart
Future<Map<String, dynamic>> today(Dio dio) async =>
    (await dio.get('/me/today')).data;

Future<void> completeTask(Dio dio, String taskId) async {
  await dio.post('/tasks/$taskId/complete',
      options: Options(headers: {'Idempotency-Key': uuidV4()})); // REQUIRED
}

Future<Map<String, dynamic>> submitCheckin(Dio dio, List<Map> answers) async =>
    (await dio.post('/checkins',
        data: {'answers': answers},
        options: Options(headers: {'Idempotency-Key': uuidV4()}))) // REQUIRED
      .data;
```

**Idempotency-Key** is REQUIRED on `POST /checkins` and `POST /tasks/:id/complete`.
Generate one UUID per logical action, persist it with the queued action, and **reuse
the same key on every retry** so an offline-sync replay produces exactly one effect.

The full 14-endpoint table + request/response shapes is in `HOSPITAL_AI_FLUTTER_HANDOFF.md`
§6, and the live truth is always `…/v1/docs`.

---

## 6. Resolving patient-visible text (content library)

Golden rule: **you never hardcode patient text.** Every string resolves from the content
library by key, in the patient's language. Cache aggressively (offline support), keyed by
`key+lang+version`.

```dart
class ContentClient {
  ContentClient(this.dio);
  final Dio dio;
  final _cache = <String, String>{};

  Future<String> resolve(String key, String lang) async {
    final ck = '$key.$lang';
    if (_cache.containsKey(ck)) return _cache[ck]!;
    try {
      final r = await dio.get('/content/$key', queryParameters: {'lang': lang});
      return _cache[ck] = r.data['text'] as String;
    } on DioException catch (e) {
      if (e.response?.data['code'] == 'CONTENT_NOT_APPROVED') {
        // Fail closed. Show "not yet available in your language" + clinic contact.
        // NEVER fall back to another language silently — it's medical text.
        rethrow;
      }
      rethrow;
    }
  }
}
```

`lang` is **required** and is one of `UZ`, `RU`, `EN`. The resolver never falls back.

---

## 7. The AI Assistant — streaming chat (SP7)

> **What it is:** a grounded assistant. It EXPLAINS the clinic's approved guidance
> ("your clinic's guidance says…") and ROUTES to humans. It never assesses a symptom,
> never diagnoses, never reassures. Decisions always stay with the clinician.
>
> **Safety is enforced server-side, not by you.** The backend screens every message on
> the way in (emergency red-flags → approved emergency content, model bypassed) and every
> sentence on the way out (anything that reads as a medical judgment is withheld). Your job
> on the client is only to render the stream and honour the `contentKey` the server sends.

### 7.1 Endpoints

| Method | Path | Purpose |
|---|---|---|
| `POST` | `/me/assistant/messages` | Send a message; **streams** the reply as SSE |
| `GET` | `/me/assistant/threads` | List the patient's conversations |
| `POST` | `/me/assistant/threads` | Start a new conversation → `{ id }` |
| `GET` | `/me/assistant/threads/:id` | Message history (to resume the UI) |

### 7.2 The stream format

`POST /me/assistant/messages` responds with `Content-Type: text/event-stream`. The body is
a sequence of SSE lines:

```
data: {"type":"delta","text":"Your clinic's guidance "}

data: {"type":"delta","text":"says to take paracetamol with water."}

data: {"type":"done","verdict":"passed"}
```

Chunk shapes (`AssistantChunk`):

| `type` | fields | meaning |
|---|---|---|
| `delta` | `text` | append this **already-safe** text to the bubble |
| `done` | `verdict`, `contentRefs?`, `contentKey?` | end of turn |
| `error` | `code` | a failure occurred — show approved contact-clinic content |

`verdict` on `done`:
- `passed` — a grounded reply streamed normally.
- `red_flag_bypass` — the message looked like an emergency; the server sent approved
  emergency content and set `contentKey: "emergency.headline"`. **Render your P13-style
  emergency UI**, do not treat it as normal chat.
- `replaced` — the reply was withheld (guard block, or no model configured) and the server
  set `contentKey: "contact.body"`. Resolve that key and show it as the assistant's answer.

**Rule of thumb:** if `done` carries a `contentKey`, resolve it via `GET /content/:key` and
show THAT as the final message (it is approved content). If `verdict` is `passed`, the text
you already streamed IS the message.

### 7.3 Dart: consume the stream

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Stream<Map<String, dynamic>> assistantStream({
  required String accessToken,
  required String message,
  String? threadId,
}) async* {
  final req = http.Request('POST', Uri.parse('${Api.base}/me/assistant/messages'))
    ..headers['Authorization'] = 'Bearer $accessToken'
    ..headers['Content-Type'] = 'application/json'
    ..headers['Accept'] = 'text/event-stream'
    ..body = jsonEncode({'message': message, if (threadId != null) 'threadId': threadId});

  final res = await http.Client().send(req);
  // Parse SSE: split on double-newline, strip the "data: " prefix.
  var buffer = '';
  await for (final chunk in res.stream.transform(utf8.decoder)) {
    buffer += chunk;
    while (buffer.contains('\n\n')) {
      final i = buffer.indexOf('\n\n');
      final line = buffer.substring(0, i).trim();
      buffer = buffer.substring(i + 2);
      if (line.startsWith('data:')) {
        yield jsonDecode(line.substring(5).trim()) as Map<String, dynamic>;
      }
    }
  }
}
```

```dart
// Usage in a controller/notifier:
final sb = StringBuffer();
await for (final c in assistantStream(accessToken: token, message: text, threadId: id)) {
  switch (c['type']) {
    case 'delta':
      sb.write(c['text']);          // append to the live bubble
      break;
    case 'done':
      final key = c['contentKey'] as String?;
      if (key != null) {
        // red_flag_bypass or replaced → show APPROVED content instead.
        final approved = await content.resolve(key, patientLang);
        if (c['verdict'] == 'red_flag_bypass') showEmergencyScreen(approved);
        else showAssistantMessage(approved);
      } else {
        showAssistantMessage(sb.toString()); // 'passed' → streamed text is the answer
      }
      break;
    case 'error':
      final approved = await content.resolve('contact.body', patientLang);
      showAssistantMessage(approved);
      break;
  }
}
```

### 7.4 Assistant UX rules (must-follow)

- The assistant is an **explanation & navigation** helper, not a triage tool. If the patient
  is reporting symptoms, nudge them to the **daily check-in** (which the care team reviews)
  or the **contact clinic / call 103** actions — the app decides urgency, not the chat.
- On `verdict: red_flag_bypass`, treat it like the emergency screen: prominent, `Call 103`,
  `Call clinic`. Do not bury it in a chat bubble.
- Keep the emergency banner visible above the chat, like every other screen.
- Never add your own reassurance text around a reply. The server guards its output; don't
  reintroduce judgment in the UI.

---

## 8. Error handling & the error envelope

Every non-2xx response is:

```json
{ "code": "CONTENT_NOT_APPROVED", "message": "…", "details": {} }
```

**Map `code` → an approved content string or a neutral UI state. Never render `message`
to a patient** — it's an English developer diagnostic and is not clinician-approved.

```dart
String uiKeyForError(String? code) {
  switch (code) {
    case 'CONTENT_NOT_APPROVED':
    case 'CLINICAL_CONTENT_NOT_APPROVED':
      return 'content.disclaimer'; // or a "not available in your language" state
    case 'UNAUTHORIZED':
    case 'WRONG_TOKEN_AUDIENCE':
      return '__reauth__';         // route to enrolment
    default:
      return 'contact.body';       // generic: contact your clinic
  }
}
```

Codes you'll see: `VALIDATION_ERROR`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`,
`WRONG_TOKEN_AUDIENCE`, `DUPLICATE_REQUEST`, `CONTENT_NOT_APPROVED`,
`CLINICAL_CONTENT_NOT_APPROVED`, `CROSS_CLINIC_FORBIDDEN`, `INTERNAL_ERROR`.

---

## 9. Offline & connectivity (pilot region has poor connectivity)

- Cache the next **7 days** of tasks and all resolved content locally.
- Task completions work offline → queue with their **original timestamp** and the same
  **Idempotency-Key**; sync when back online.
- **Check-in submission and the assistant require connectivity.** If offline, do NOT queue a
  symptom report or an assistant message silently — show the clinic phone + emergency
  instruction. A patient reporting symptoms must always reach a human path.
- The **emergency screen (P13) must work with no network** — cache `emergency.headline` /
  `emergency.body` and the clinic numbers at enrolment so the dial action works offline.

---

## 10. Quick connectivity smoke test (before you build UI)

Prove the connection end-to-end from your machine:

```bash
# 1. API is up:
curl -s https://api.hospital-ai.uz/v1/docs -o /dev/null -w "docs: %{http_code}\n"

# 2. Content resolves (public read):
curl -s "https://api.hospital-ai.uz/v1/content/emergency.headline?lang=EN"

# 3. Enrol (ask for a fresh code+phone — codes are single-use, 14-day expiry):
curl -s -X POST https://api.hospital-ai.uz/v1/auth/patient/session \
  -H "Content-Type: application/json" \
  -d '{"code":"XXXXXX","phone":"+998901234567"}'
# → { "accessToken": "...", "refreshToken": "...", ... }

# 4. Call a patient endpoint with the token:
curl -s https://api.hospital-ai.uz/v1/me/profile -H "Authorization: Bearer <accessToken>"

# 5. Stream the assistant:
curl -N -X POST https://api.hospital-ai.uz/v1/me/assistant/messages \
  -H "Authorization: Bearer <accessToken>" -H "Content-Type: application/json" \
  -d '{"message":"What did my doctor say about walking?"}'
```

If steps 1–2 work you have connectivity; 3–5 confirm auth + the full patient surface + the
assistant stream.

---

## 11. Notes on the current backend state

- **Content is placeholder-flagged.** Real UZ/RU/EN text exists, but every item is
  `is_placeholder: true` pending native-speaker + clinician sign-off. You'll see
  `"isPlaceholder": true` in content responses — build against it normally; keys won't change.
- **Production gate.** Real patient enrolment stays closed until a clinician signs off content
  (and, for the assistant, the not-a-medical-device argument). On the demo server the gate is
  open so you can build. In production an unapproved string returns `CLINICAL_CONTENT_NOT_APPROVED`
  — handle it gracefully (show approved fallback / contact clinic, never a blank screen).
- **Assistant availability.** The assistant needs an AI key configured server-side. If it isn't,
  the endpoint still responds safely: benign messages come back with `verdict: replaced` and
  `contentKey: contact.body`. Your rendering code (§7.3) already handles that path, so the app
  works whether or not the assistant model is switched on.

---

*If a step here disagrees with `…/v1/docs`, trust the docs — they're generated from the running
code. Ask before improvising on anything in the assistant or check-in flows; those are the
safety-critical paths.*
