# Hika — Architecture

_Status: **approved** · 2026-11-27 (D4 approved — user creates `hika-dev`)_
Based on `00-project-overview.md` (approved). Project rules in `CLAUDE.md` override the brief's stack.

## 1. Big decisions (your answer vs final)

### D1 — How the app talks to Firebase
- **Your answer:** (b) everything through Cloud Functions.
- **Final (proposed): (c) hybrid.**
  - **Reads → Firestore directly**, protected by Security Rules: menu, `AppConfig`, banners/offers, own user doc, own orders, wallet, notifications.
  - **Writes with money, limits or state → callable Cloud Functions only**: place order, validate promo, use balance, cancel order, confirm receipt upload, submit rating, save/delete address (max 5 + fee), delete account.
  - **Simple user-owned writes → Firestore directly** with Rules validation: favorites, notification settings, profile name/phone, FCM token.
- **Why not (b):** it conflicts with your D2 and D3 answers — Firestore offline cache and snapshots only work when the app reads Firestore directly. All-Functions also adds cold-start latency on every screen and costs more invocations.
- **Trade-off:** security now depends on Rules being right for every direct read/write → Rules get their own tests (emulator).

### D2 — Offline cache
- **Your answer:** Firestore for the menu, Hive for the cart. ✅ Same direction.
- **Final (proposed):**
  - Menu, `AppConfig`, orders, wallet → **Firestore offline persistence** (built-in; reads from cache when offline, `metadata.isFromCache` drives `offlineCached` state).
  - Cart, recent searches, first-launch flag → **`shared_preferences`** storing JSON, instead of Hive.
- **Why not Hive:** original `hive` (2.2.3) is unmaintained; the maintained fork is `hive_ce`. Typed boxes need `hive_ce_generator` (code generation — against project rules); without it we'd store JSON maps anyway. The cart is one small JSON document → `shared_preferences` (official flutter.dev package) is enough with one less dependency.
- **Trade-off:** no querying inside local data — not needed here. If local data grows later, `hive_ce` with JSON maps is the upgrade path.

### D3 — Order tracking
- **Your answer:** snapshots. ✅ **Final:** Firestore `snapshots()` stream on the order doc, exposed as `Stream` from the repository, consumed by `OrderTrackingBloc` with `emit.forEach`. No polling.

### D4 — dev / prod environments (needs your OK)
- **Proposed:** two Firebase projects — `Hika` (prod, exists) + **`hika-dev`** (new). Flavor `dev` → `hika-dev`, `prod` → `Hika`. Firebase **Emulator Suite** used for Functions + Rules tests.
- **Why:** test orders, seed data and Telegram alerts never touch the real restaurant data.

## 2. Layers & folders
Clean Architecture, feature-first: `presentation → domain → data`. Domain is pure Dart (no Flutter, no Firebase).

```
lib/
├── main_dev.dart / main_prod.dart   # flavor entrypoints → bootstrap()
├── app.dart                         # MaterialApp.router, theme, l10n, RTL
├── core/
│   ├── config/        # Flavor, env (--dart-define)
│   ├── di/            # get_it registration (manual, per feature module)
│   ├── error/         # Failure (sealed), exception → Failure mappers
│   ├── result/        # ApiResult<T> (sealed: ApiSuccess / ApiFailure)
│   ├── usecase/       # UseCase<T, P> base
│   ├── router/        # go_router, routes, guards (guest/session/deep link)
│   ├── theme/         # tokens → ThemeData (colors, type, spacing, radii, shadows, motion)
│   ├── l10n/          # app_ar.arb (+ empty app_en.arb)
│   ├── storage/       # shared_preferences wrapper
│   ├── connectivity/  # ConnectivityBloc
│   ├── app_config/    # AppConfig entity + AppConfigBloc (global admin values)
│   ├── utils/         # formatters (currency, 12h time, digits), validators
│   └── widgets/       # design system components + state widgets
├── features/<feature>/{data,domain,presentation}
functions/                            # Cloud Functions (TypeScript) + tests
firestore.rules · storage.rules · firebase.json · firestore.indexes.json
```

## 3. State management
- **Bloc only** (no Cubit). Events & states are `sealed class`es (+ `equatable`). Blocs depend only on use cases.
- `bloc_concurrency`: `droppable` on submits (login, place order, upload), `restartable` on search typing.
- **Global Blocs** (singletons, provided above the router): `AuthBloc` (session), `CartBloc` (persisted), `AppConfigBloc`, `ConnectivityBloc`. Screen Blocs: `registerFactory`, created with the page.
- **Screen states** follow the design's states table: `initial / loading / success / refreshing / empty / offlineCached / offlineEmpty / error`. Shared state widgets in `core/widgets` (Skeleton, Empty, OfflineBar, OfflineFullScreen, InlineError, ErrorFullScreen).

## 4. Data & errors
- Data sources wrap Firebase SDKs (`cloud_firestore`, `firebase_auth`, `cloud_functions`, `firebase_storage`). **No Dio** — there is no REST API.
- Models: hand-written `fromJson/fromFirestore` + `toJson`; **fail loudly** on missing required fields (no `?? ''`).
- `FirebaseException` / `FirebaseAuthException` / `FirebaseFunctionsException` are caught in the data layer and mapped to a sealed `Failure`:
  `ServerFailure · NetworkFailure · CacheFailure · ValidationFailure(fieldKeys) · AuthFailure(reason) · RateLimitFailure(retryAfter) · PermissionFailure · NotFoundFailure`.
- Repositories return `ApiResult<T>` (or `Stream<ApiResult<T>>`); presentation maps `Failure` → l10n message key. `Failure` carries no message (typed only); unknown errors → `ServerFailure`. No technical codes reach the UI.

## 5. Backend (Firebase)
- **Auth:** email/password, Google, Apple. Login lock (10 attempts → 5 min) and reset-link limits (60 s, 5/h) enforced server-side.
- **Firestore (high level):** `config/app` · `menu_categories` · `menu_items` · `combos` · `banners` · `offers` · `users/{uid}` (+ `addresses`, `favorites`, `notifications`, `wallet_transactions`) · `orders/{orderId}` · `promo_codes` (server-only). Exact schema per epic.
- **Cloud Functions (TypeScript, Node, `functions/`):** callable APIs from D1 + triggers (order status → push + Telegram) + scheduled jobs (hold expiry, late/review-overdue flags, scheduled-order reminders, balance expiry, daily summary).
- **Storage:** `receipts/{uid}/{orderId}/…`, image compressed on device before upload; Rules: owner write once per attempt, size/type limits.
- **Push:** FCM, deep links routed by go_router.
- **Telegram:** bot token in Functions secrets (never in the app or repo).

## 6. Packages (app) — pinned to latest stable at `flutter pub add` time
| Need | Package | Why |
|---|---|---|
| State | `flutter_bloc`, `bloc_concurrency`, `equatable` | Project rule |
| DI | `get_it` | Project rule (no `injectable`) |
| Routing | `go_router` | Guards, `StatefulShellRoute` for 5 tabs, deep links |
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `cloud_functions`, `firebase_storage`, `firebase_messaging` | Backend |
| Social login | `google_sign_in`, `sign_in_with_apple` | Auth |
| Local | `shared_preferences` | D2 |
| Connectivity | `connectivity_plus` | Offline bar/states |
| Images | `cached_network_image`, `image_picker` (+ image compression pkg, chosen in payment epic) | Menu images, receipts |
| SVG | `flutter_svg` | Custom icons, illustrations, stamp |
| Location | `geolocator` | GPS on address save only |
| Links | `url_launcher` | Call / WhatsApp |
| Version | `package_info_plus` | Force/optional update |
| l10n | `flutter_localizations`, `intl` | Arabic ARB |
| Tests | `mocktail`, `bloc_test` | Project rule |

Fonts (Baloo Bhaijaan 2, Readex Pro) bundled as assets — not `google_fonts` (works offline, no runtime fetch).
Not used: Dio, freezed, json_serializable, injectable, dartz/fpdart, hive.

## 7. Testing
- App: unit tests for use cases, repositories, mappers, formatters/validators; `bloc_test` for every Bloc state; widget tests for shared components and critical screens (cart, checkout, payment).
- Backend: Functions unit tests + Rules tests on the Firebase Emulator (pricing, points rounding, promo, cancellation rules).

## 8. Non-negotiable rules
1. UI never touches a data source: Widget → Bloc → UseCase → Repository.
2. No hard-coded text, color, spacing or radius — l10n keys and theme tokens only.
3. Every screen covers its full states table.
4. Admin values come from `AppConfig`, never constants.
5. Prices, points, promos and order state are computed on the server; the app only displays them.
6. RTL: `start/end`, never `left/right`.
