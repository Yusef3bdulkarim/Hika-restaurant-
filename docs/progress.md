# Progress

_Last updated: 2026-11-27_

## Now
- **Epic:** E0 — `foundation`
- **Sub-feature:** 03 `firebase_setup` — plan `docs/plan/foundation/03-firebase_setup.md`
- **Branch:** `feat/firebase-setup`
- **Current task:** 03-02 Initialize Firebase by flavor (todo) — 03-01 done, waiting for user commit
- Done: 01 + 02 merged to `develop` (PR #1, #2) 2026-11-27

## Next
- 03-02 init by flavor → 03-03 mapper → review + PR
- Then plan `04-backend_scaffold`

## Open decisions
- Discovery: Telegram cost decision + iOS-later confirmation still marked pending in `00-discovery-notes.md`

## Known issues
- `ApiSuccess` / `ApiFailure` have no value equality — add `Equatable` when the first repository test needs `expect(result, ApiSuccess(x))` (review 02)
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

## Starter message for a new chat
> كمّل من docs/progress.md — التاسك الجاية: foundation 03-02 Firebase init by flavor (docs/plan/foundation/03-firebase_setup.md).
