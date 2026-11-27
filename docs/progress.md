# Progress

_Last updated: 2026-11-27_

## Now
- **Epic:** E0 — `foundation`
- **Sub-feature:** 01 `project_setup` — plan `docs/plan/foundation/01-project_setup.md`
- **Branch:** `feat/project-setup`
- **Current task:** 01 `@code-reviewer` PASS WITH NITS (no fixes needed) — waiting: user manual check + PR to `develop`
- Done: roadmap + E0 breakdown approved; `hika-dev` created; tools installed (2026-11-27)

## Next
- `@code-reviewer` + manual check (both flavors side by side, Arabic title, RTL) + PR `feat/project-setup` → `develop`
- Then plan `02-core_contracts` — user proposes `ApiResult` / `Failure` design first

## Open decisions
- Discovery: Telegram cost decision + iOS-later confirmation still marked pending in `00-discovery-notes.md`

## Known issues
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

## Starter message for a new chat
> كمّل من docs/progress.md — التاسك الجاية: @code-reviewer على feat/project-setup ثم PR، وبعدها plan 02-core_contracts (اقتراحي لـ ApiResult/Failure الأول).
