# Progress

_Last updated: 2026-11-28_

## Now
- **Epic:** E0 — `foundation`
- **Sub-feature:** 05 `router` — plan `docs/plan/foundation/05-router.md`
- **Branch:** `feat/router`
- **Current task:** 05 tasks done — waiting: user commits (05-01 staged, 05-02), then `@code-reviewer` + PR
- Done: 01-04 merged to `develop` (PR #1-#5)

## Next
- 05-01 router config → 05-02 wire into App → review + PR
- Then E1 `design_system` breakdown (new chat, Opus, Plan Mode)

## Open decisions
- Discovery: Telegram cost decision + iOS-later confirmation still marked pending in `00-discovery-notes.md`

## Known issues
- `ApiSuccess` / `ApiFailure` have no value equality — add `Equatable` when the first repository test needs `expect(result, ApiSuccess(x))` (review 02)
- iOS: Firebase options not generated — `firebaseOptionsFor` throws `UnsupportedError` on iOS; run `flutterfire configure --platforms=ios` per flavor before any iOS build
- Emulators need Java 21+ — JDK 25 (Temurin) installed, first on PATH; Flutter still uses Android Studio JBR 21
- Vitest fails from a lower-case drive path (`f:`) — `functions/scripts/vitest.mjs` re-runs it from `F:`
- `functions/package.json` `overrides` pins `@grpc/grpc-js ^1.14.7` under `@firebase/firestore` — remove when `firebase` ships a fixed version
- Kotlin incremental compile disabled (`android/gradle.properties`) — cross-drive cache bug (project F:, pub cache C:)
- Plain `flutter run` fails (no `lib/main.dart`) — always `--flavor dev -t lib/main_dev.dart`
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

## Starter message for a new chat
> كمّل من docs/progress.md — التاسك الجاية: @code-reviewer على feat/router ثم PR، وبعدها E1 design_system breakdown.
