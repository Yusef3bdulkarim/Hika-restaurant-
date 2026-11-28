# foundation-01-04 — l10n (Arabic) + forced RTL

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Project rule: no hard-coded text — every string is an l10n key. App is Arabic only and must always lay out right-to-left, whatever the phone's language.

## Assumptions
- Only one key for now (`appTitle`); the planned `placeholderMessage` was dropped — the placeholder shows `appTitle`, a second key would be unused.
- `app_en.arb` stays empty (overview: kept for later). Missing keys fall back to the Arabic template.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `flutter gen-l10n` (built-in, `generate: true`) | `easy_localization`, `intl_utils` | Official, no extra package, no build_runner, type-safe getters | Must re-run gen-l10n (auto on `flutter run`/`pub get`) after ARB edits |
| `locale: Locale('ar')` forced | Follow device locale | Arabic-only app; device in English must still get RTL | Ignores device language — intended |
| ARB in `lib/core/l10n`, output in `lib/core/l10n/generated` | Default `lib/l10n` | Architecture §2 puts l10n under `core/`; generated code in its own folder, excluded from lints | — |
| `nullable-getter: false` | Default nullable | `AppLocalizations.of(context)` returns non-null → no `!` everywhere | Throws if delegates are missing (fails loudly — wanted) |
| `onGenerateTitle` instead of `title` | `title: 'هيكا'` | `title` is built before localizations exist → would need a hard-coded string | — |

## Thinking steps
1. Add `flutter_localizations` (SDK) + `intl` via `flutter pub add`, `generate: true`.
2. Configure `l10n.yaml` (Arabic is the template).
3. Generate, then wire delegates + forced locale into `MaterialApp`.
4. Tests: text comes from ARB, and direction is RTL even though the test environment defaults to `en_US`.

## Files
- `l10n.yaml` — gen-l10n config.
- `lib/core/l10n/app_ar.arb` / `app_en.arb` — strings (Arabic template, English empty).
- `lib/core/l10n/generated/*` — generated `AppLocalizations` (do not edit).
- `lib/app.dart` — locale, delegates, title, placeholder page.
- `pubspec.yaml` / `pubspec.lock` — packages + `generate: true`.
- `test/app_test.dart` — l10n + RTL checks.

## Principles & patterns
- **Single source of truth for text** — ARB files — overkill for a one-screen internal tool.
- **Fail loudly** — non-null getter crashes early if l10n is not wired.

## Tests
- `should render Arabic app title when app starts` — proves the text comes through l10n.
- `should lay out right-to-left when app starts` — tests default to `en_US`; this fails if `locale: Locale('ar')` is removed. Most important test here.
- Not tested: generated code (Flutter's responsibility).

## Quiz
1. Why does RTL work without wrapping anything in `Directionality`?
2. Why `onGenerateTitle` and not `title`?
3. If you add a key only to `app_ar.arb`, what does the English locale show?
4. What does `nullable-getter: false` change at call sites?
5. Why would the text test still pass without the forced locale, but the RTL test fail?
