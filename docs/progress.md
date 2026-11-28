# Progress

_Last updated: 2026-11-28_

## Now
- **Epic:** E1 — `design_system`
- **Sub-feature:** 01 `tokens` — plan `docs/plan/design_system/01-tokens.md` (approved)
- **Branch:** `feat/ds-tokens`
- **Current task:** 01-03 typography done — waiting: user commit; next 01-04 const tokens
- E0 done: 01-05 merged to `develop` (PR #1-#6) · E1 breakdown approved

## Next
- 01-01 fonts → 01-02 colors → 01-03 typography → 01-04 const tokens → 01-05 ThemeData + App → 01-06 gallery

## Open decisions
- Discovery: Telegram cost decision + iOS-later confirmation still marked pending in `00-discovery-notes.md`

## Known issues
- `ApiSuccess` / `ApiFailure` have no value equality — add `Equatable` when the first repository test needs `expect(result, ApiSuccess(x))` (review 02)
- iOS: Firebase options not generated — `firebaseOptionsFor` throws `UnsupportedError` on iOS; run `flutterfire configure --platforms=ios` per flavor before any iOS build
- Emulators need Java 21+ — JDK 25 (Temurin) installed, first on PATH; Flutter still uses Android Studio JBR 21
- Lower-case drive path (`f:\`, how VS Code opens the folder) breaks tools: Vitest (fixed by `functions/scripts/vitest.mjs`) and `flutter pub get` sometimes deletes `lib/core/l10n/generated/*` → run `flutter gen-l10n`. Better: open the folder as `F:\work\hika\hika_app`
- `functions/package.json` `overrides` pins `@grpc/grpc-js ^1.14.7` under `@firebase/firestore` — remove when `firebase` ships a fixed version
- Kotlin incremental compile disabled (`android/gradle.properties`) — cross-drive cache bug (project F:, pub cache C:)
- Plain `flutter run` fails (no `lib/main.dart`) — always `--flavor dev -t lib/main_dev.dart`
- `NotFoundPage` has no way back home — add a "go home" action in E2 (splash/shell) or E11 (deep links)
- `docs/brief/*.md.crdownload` — files have the Chrome partial-download extension

## Learning stages
| Skill | Stage (1-3) | Notes |
|---|---|---|
| Tests | 1 | |
| Bloc | 1 | |
| Git | 1 | |

## Done log
- 2026-11-27 · foundation 01-01 Strict lints — `analysis_options.yaml`
- 2026-11-27 · foundation 01-02 Flavor + entrypoints — `bootstrap.dart`, `main_dev/prod.dart`, `app.dart`
- 2026-11-27 · foundation 01-03 Android flavors + package id — `com.hika.app` / `.dev`
- 2026-11-27 · foundation 01-04 l10n + RTL — `l10n.yaml`, `app_ar.arb`, forced `ar` locale
- 2026-11-27 · foundation 02-01 ApiResult + Failure + UseCase — `core/result`, `core/error`, `core/usecase`
- 2026-11-27 · foundation 02-02 LocalStorage — `core/storage`, `CacheException`
- 2026-11-27 · foundation 02-03 DI container — `core/di/injection.dart`, `kotlin.incremental=false`
- 2026-11-27 · foundation 03-01 FlutterFire config — options + google-services per flavor, `firebase_core`
- 2026-11-27 · foundation 03-02 Firebase init by flavor — `firebaseOptionsFor`, `bootstrap`
- 2026-11-28 · foundation 03-03 Firebase exception mapper — `mapFirebaseException`
- 2026-11-28 · foundation 04-01 Firebase config + deny-all Rules — `.firebaserc`, `firebase.json`, rules
- 2026-11-28 · foundation 04-02 Functions TS package — Node 24, TS ~6.0.3 (typescript-eslint limit), ESLint flat
- 2026-11-28 · foundation 04-03 Rules test harness — Vitest + rules-unit-testing, 9 deny-all tests, grpc-js override
- 2026-11-28 · foundation 05-01 Router config — `go_router` 18, `AppRoutes`, `createRouter()`, not-found page
- 2026-11-28 · foundation 05-02 Wire router into App — `MaterialApp.router`, router owned + disposed by `App`
- 2026-11-28 · E0 done (PR #6 merged) · E1 design pages pulled into `docs/brief/design/project/` · E1 breakdown draft
- 2026-11-28 · design_system 01-01 Bundle fonts — static TTFs (Baloo 700, Readex 400-700), OFL in `LicenseRegistry`
- 2026-11-28 · design_system 01-02 Colors — `HikaColors` ThemeExtension, 34 tokens from `M1-Colors` (+ `borderInput`)
- 2026-11-28 · design_system 01-03 Typography — `HikaTextStyles` ThemeExtension, 12 styles, no color

## Starter message for a new chat
> كمّل من docs/progress.md — التاسك الجاية: design_system 01-04 const tokens على `feat/ds-tokens`.
