# Design System / 03 — Formatters

- **Goal:** one place that turns numbers, money and clock times into the exact text the design shows: `220 ج.م`, `25,000`, `9:30 م`.
- **Branch:** `feat/ds-formatters` (from `develop`)
- **API:** none
- **Out of scope:**
  - time ranges and slot text: «11:30 م – 12 ص» and «(بعد منتصف الليل)», which are built in E7 time slots from `time()`.
  - durations («35–45 دقيقة»): l10n strings in their own features.
  - dates.
  - validators.
- **Decision points for the user:** none big. Defaults below, say if you disagree.
- **Design rules** (`M1-Type`, `00-project-overview`, `HO-00-Decisions`):
  - numbers are always English digits, with a comma for thousands: `25,000`.
  - money: number + non-breaking space + `ج.م`: `220 ج.م`.
  - time is 12h with `ص` / `م`: `9:30 م`, `1:00 ص`. Midnight is written `12 ص`.
- **Assumptions:**
  1. **Location: `lib/core/utils/formatters.dart`.** That's where `00-architecture.md` puts formatters. The breakdown said `core/format/`; the architecture wins.
  2. **Arabic words come from l10n, logic stays pure.** `formatNumber` / `formatClock` are plain Dart and tested directly. `ج.م`, `ص` and `م` live in `app_ar.arb` (project rule: UI strings are l10n keys). Screens call `l10n.money(220)` and `l10n.time(dt)`, through an extension on `AppLocalizations`.
  3. **Money input = `num` in pounds**, the display unit. How money is stored (pounds vs piasters) is a domain decision for E4/E5, where the domain converts before display. Whole amounts show no decimals (`220`). Fractions show 2 (`13.35`, `13.50`). Negatives keep the sign (`-20`) for discount lines.
  4. **Only midnight drops the minutes** (`12 ص`), as `HO-00-Decisions` writes it. Noon stays `12:00 م`, since the design shows no other exception.
  5. **No `intl` date or number locale for digits.** `NumberFormat` with the `en` locale gives Western digits and commas whatever the device locale is. Time is built by hand (simple 12h math), so `DateFormat('ar')` can't switch to Arabic-Indic digits.

---

## 01 — Numbers and money
- **Layer:** presentation (core)
- **Goal:** `formatNumber` + `l10n.money()`.
- **Touch:**
  - create `lib/core/utils/formatters.dart`:
    - `String formatNumber(num value)`: grouping, Western digits, no decimals when whole, otherwise 2.
    - `extension HikaFormatters on AppLocalizations` with `String money(num amount)`.
  - `lib/core/l10n/app_ar.arb`: `money` = `"{amount} ج.م"`, with an `amount` String placeholder and a description. Then regenerate l10n.
  - test: `test/core/utils/formatters_test.dart`.
- **Do NOT touch:** widgets, theme, gallery.
- **Tests:**
  - `should group thousands with a comma when value is 25000`
  - `should show no decimals when value is whole`
  - `should show two decimals when value has a fraction` (13.35 and 13.5 → `13.50`)
  - `should keep the minus sign when value is negative`
  - `should use Western digits when value is formatted`
  - `should join amount and ج.م with a non-breaking space when money is formatted` (uses `lookupAppLocalizations(Locale('ar'))`, no widget)
- **Done when:** analyze clean, tests pass.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — Clock time
- **Layer:** presentation (core)
- **Goal:** `formatClock` + `l10n.time()`.
- **Touch:**
  - `lib/core/utils/formatters.dart`:
    - `({String clock, bool isAm}) formatClock(int hour, int minute)`: `9:30` / `12` at midnight, plus the AM flag. Throws `ArgumentError` when the hour or minute is out of range.
    - `l10n.time(DateTime)`.
  - `app_ar.arb`: `timeAm` = `"{time} ص"`, `timePm` = `"{time} م"`. Then regenerate.
  - tests in the same test file.
- **Do NOT touch:** money code from 01 (unless a bug is found).
- **Tests:**
  - `should show 9:30 م when time is 21:30`
  - `should show 1:00 ص when time is 01:00`
  - `should show 12 ص when time is midnight`
  - `should show 12:30 ص when time is 00:30`
  - `should show 12:00 م when time is noon`
  - `should pad minutes to two digits when minute is below 10`
  - `should throw ArgumentError when hour is out of range`
- **Done when:** analyze clean, tests pass.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

---

## Changes from the plan
- **01:** the ARB key is `moneyAmount`, not `money`. A generated instance method named `money(String)` would shadow the `money(num)` extension, because an instance member always wins.
- **02:** a non-breaking space before `ص` / `م` too, for the same reason as `ج.م`.
- **Process:** this plan was first committed on `feat/ds-assets` but never pushed, so it was restored onto this branch from commit `892042d`.

## Review (2026-11-28)
- `@code-reviewer` (`sonnet`): **PASS WITH NITS**. Fixed:
  - `formatNumber` throws `ArgumentError` on NaN or infinity, so a bad amount never shows on screen.
  - The value is rounded to 2 decimals before the whole-number check: `220.004` → `220`, `-0.001` → `0` (no `-0.00`).
  - New tests:
    - money with a fraction and with a negative value.
    - clock bounds: `-1` hour or minute, `23:59`, `12:30` pm.
    - the old tests with two expects split into one behavior each.
  - The locale-pin test moved to its own file, `formatters_locale_test.dart`. The first version passed even with `'en'` removed, because the `NumberFormat`s are cached top-level finals already built by earlier tests. Its own isolate sets `ar_EG` first, and a mutation now fails with `-١٬٢٣٤٬٥٦٧٫٨٩`.
  - The `time()` doc now says it uses the `DateTime`'s hour as given and that callers convert with `toLocal()` first.
- Accepted: values ≥ 2^63 format wrong (`intl` uses 64-bit ints). That isn't realistic for prices.

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/ds-formatters` → PR to `develop`. No device check needed (no UI).
- Next: `04-buttons_inputs`.
