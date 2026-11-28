# design_system-03-01 — Numbers and money

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Prices appear on almost every screen and must look exactly like the design: Western digits, comma thousands, `220 ج.م` with a non-breaking space so `ج.م` never wraps to a new line alone.

## Assumptions
- Plan assumptions 1-5 (location `core/utils`, Arabic words in l10n, `num` in pounds, decimals only when needed, `en` locale for digits).
- ARB key named `moneyAmount`, not `money` (see decisions).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `NumberFormat(…, 'en')` | Device / `ar` locale | Measured: `ar_EG` → `-٢٥٬٠٠٠٫٥٠` (Arabic-Indic digits); `ar` → hidden LRM mark before `-`; `en` → `-25,000.50` | Locale is hard-coded on purpose (design rule: always Western digits) |
| Pure `formatNumber` + `l10n.money()` extension | One function with `'ج.م'` hard-coded | Logic testable without Flutter; Arabic text stays in the ARB (project rule) | Two pieces instead of one |
| ARB key `moneyAmount(String)`, extension `money(num)` | Same name `money` for both | In Dart an **instance method always wins** over an extension with the same name → `l10n.money(220)` would call the generated `money(String)` and not compile | Two names to know (`money` is the one to use) |
| ` ` escape in the ARB | Literal NBSP character | Visible in review; JSON escape → the generated Dart holds the real character (checked bytes `C2 A0`) | — |

## Thinking steps
1. Rules from the design → 3 outputs: grouping, decimals, unit with NBSP.
2. First draft named both `money` → analyzer error → learned the extension-shadowing rule → renamed the ARB key.
3. Tools fight escapes: the Edit tool, `sed` and `perl` each turned ` ` into something else (`perl` reads `\u` as "uppercase next") → used `\x5C` (backslash) in perl.
4. Mutation: swap `en` → `ar` → the negative test failed (hidden LRM) → then measured `ar_EG` → Arabic-Indic digits. The `en` choice is now backed by evidence.

## Files
- `lib/core/utils/formatters.dart` — `formatNumber`, `HikaFormatters.money`.
- `lib/core/l10n/app_ar.arb` — `moneyAmount`; generated l10n updated.
- `test/core/utils/formatters_test.dart` — 6 tests.

## Principles & patterns
- **Separate logic from text** — pure function + l10n wrapper — overkill for a one-language app with no l10n rule.
- **Know your language's resolution rules** — instance member beats extension.
- **Measure, don't assume** — locale output printed for `en` / `ar` / `ar_EG`.

## Tests
- `should group thousands with a comma when value is 25000`.
- `should show no decimals when value is whole` (incl. `220.0` — a double that is whole).
- `should show two decimals when value has a fraction` (`13.5` → `13.50`).
- `should keep the minus sign when value is negative` — this is the one that caught the hidden LRM mark under `ar`.
- `should use Western digits when value is formatted` — fails under `ar_EG`.
- `should join amount and ج.م with a non-breaking space when money is formatted` — real generated l10n, no widget (`lookupAppLocalizations`).

## Quiz
1. Why does `l10n.money(220)` work only because the ARB key is `moneyAmount`?
2. What would a customer with an `ar_EG` phone see if we used the device locale?
3. Why a non-breaking space before `ج.م`?
4. Why is `formatNumber(220.0)` `220` and not `220.00`?
5. Why can the money test run without `pumpWidget`?
