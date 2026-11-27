# E0 — Foundation · Breakdown

_Status: **approved** · 2026-11-27 — decisions 1-4 = recommended option; 5 = user proposes first (in 02)_
Based on `00-roadmap.md` (E0 row) + `00-architecture.md` (approved).
Goal: an empty but correctly wired app — flavors, Firebase (dev/prod), backend scaffold, core
contracts, DI, storage, router, l10n/RTL — so every later epic only adds features.

**No UI design here** (tokens, fonts, components = E1). Screens in E0 are plain placeholders.

## Prerequisites (user, before 03) — done 2026-11-27
- Firebase project **`hika-dev`** created (Blaze not required for dev; Emulator covers Functions).
- Installed: Node LTS, `firebase-tools` (`firebase login`), `flutterfire_cli`, JDK 17+ (Emulator).
- Untracked docs (`docs/brief/design/`, `docs/plan/*`) committed on `develop`.

## Sub-features (in order)

| # | Sub-feature | Branch | Contents | Depends on | ~Tasks |
|---|---|---|---|---|---|
| 01 | `project_setup` | `feat/project-setup` | Package id `com.hika.app`; Android `productFlavors` dev/prod (dev = `.dev` suffix, app name «هيكا Dev»); `main_dev.dart` / `main_prod.dart` → `bootstrap()`; `core/config/flavor.dart`; `app.dart` (`MaterialApp`, Arabic locale forced, RTL); l10n setup (`l10n.yaml`, `app_ar.arb`, empty `app_en.arb`, generated `AppLocalizations` via `flutter gen-l10n` — Flutter's built-in tool, not build_runner); stricter `analysis_options.yaml`; remove counter demo + its test | — | 4 |
| 02 | `core_contracts` | `feat/core-contracts` | `ApiResult<T>` (sealed Success / Error), `Failure` (sealed, 8 types from architecture §4), `UseCase<T, P>` + `NoParams`, `get_it` container + `configureDependencies()`, `LocalStorage` wrapper over `shared_preferences` (JSON read/write, errors → `CacheFailure`). All with unit tests | 01 | 4 |
| 03 | `firebase_setup` | `feat/firebase-setup` | `flutterfire configure` per flavor → `firebase_options_dev.dart` / `_prod.dart`; `firebase_core` init in `bootstrap()` by flavor; Firestore offline persistence settings; dev-only Emulator connect via `--dart-define=USE_EMULATOR=true`; `FirebaseException` / `FirebaseAuthException` / `FirebaseFunctionsException` → `Failure` mapper + tests | 02, user prerequisites | 3 |
| 04 | `backend_scaffold` | `feat/backend-scaffold` | `functions/` (TypeScript, ESLint, test runner); `firebase.json` + `.firebaserc` (aliases `dev` / `prod`); Emulator Suite config (Auth, Firestore, Functions, Storage); `firestore.rules` + `storage.rules` = **deny all**; Rules test harness (`@firebase/rules-unit-testing`) with deny-all tests; npm scripts `test`, `emulators`, `deploy:dev` | 03 | 3 |
| 05 | `router` | `feat/router` | `go_router` skeleton in `core/router/` (route names/paths as constants, one placeholder route, error route), `MaterialApp.router`; widget test that the app boots on the placeholder in RTL | 02 | 2 |

**Total ≈ 16 tasks.** 04 and 05 are independent of each other (05 can go before 04).
Detailed tasks are written per sub-feature in `docs/plan/foundation/NN-{name}.md` (plan template).

## Explicitly NOT in E0
Theme/tokens/fonts/icons (E1) · `ConnectivityBloc`, `AppConfig`, splash, tabs, guards (E2) · any
feature package (auth, geolocator, image_picker…) — added in the epic that uses it · App Check ·
iOS flavors/Xcode schemes (needs Mac — done at iOS release) · CI.

## Packages added in E0 (latest stable at `flutter pub add` time)
`flutter_localizations` (SDK), `intl`, `get_it`, `shared_preferences`, `equatable`,
`firebase_core`, `cloud_firestore`, `firebase_auth`, `cloud_functions`, `go_router` ·
dev: `mocktail`. (`flutter_bloc` / `bloc_test` / `bloc_concurrency` wait until the first Bloc in E2.)
`firebase_auth` + `cloud_functions` are added in 03 only because the exception mapper must handle their exception types.

## Decision points (resolved 2026-11-27)
1. **Dev app id** — `com.hika.app.dev` (dev + prod installed side by side; needs a second Android app in `hika-dev`) vs same id for both. _Recommend: `.dev` suffix._
2. **Firebase options files** — commit `firebase_options_*.dart` + `google-services.json` (Firebase client keys are not secrets; security = Rules) vs gitignore them. _Recommend: commit._
3. **Lints** — `flutter_lints` + hand-picked stricter rules (no new package) vs `very_good_analysis`. _Recommend: hand-picked._
4. **Functions test runner** — Vitest (TS native, fewer deps) vs Jest + ts-jest (more Firebase examples). _Recommend: Vitest._
5. **`ApiResult` / `Failure` shape (02)** — learning-mode big decision: you propose your design first, then we compare.

## Review
- Every sub-feature: `@code-reviewer` (`sonnet`) on `git diff develop...HEAD` before its PR.
- 04 (Rules): `@code-reviewer` with `opus` (roadmap rule: every Rules change).
