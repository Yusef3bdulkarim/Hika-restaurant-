# Progress

_Last updated: 2026-11-27_

## Now
- **Epic:** E0 — `foundation`
- **Sub-feature:** 02 `core_contracts` — plan `docs/plan/foundation/02-core_contracts.md`
- **Branch:** `feat/core-contracts`
- **Current task:** 02 tasks all done — next: commit 02-03, `@code-reviewer` (sonnet), PR to `develop`
- Done: 01 `project_setup` merged to `develop` (PR #1) 2026-11-27

## Next
- `@code-reviewer` + PR `feat/core-contracts` → `develop`
- Then plan `03-firebase_setup`

## Open decisions
- Discovery: Telegram cost decision + iOS-later confirmation still marked pending in `00-discovery-notes.md`

## Known issues
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

## Starter message for a new chat
> كمّل من docs/progress.md — التاسك الجاية: @code-reviewer على feat/core-contracts ثم PR، وبعدها plan 03-firebase_setup.
