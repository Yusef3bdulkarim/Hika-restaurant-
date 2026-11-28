# design_system-03-02 — Clock time

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Times show on tracking, slots, opening hours and order history. The design wants 12h with `ص` / `م` (`9:30 م`, `1:00 ص`) and writes midnight as `12 ص`.

## Assumptions
- Plan assumption 4: only midnight drops the minutes; noon stays `12:00 م`.
- **Added:** non-breaking space before `ص` / `م`, for the same reason as `ج.م` (the period never wraps alone). The design states it only for money.
- `time()` reads the `DateTime`'s own hour and minute (local time). Converting from server UTC is the caller's job, done once in the data layer.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Hand-made 12h math | `DateFormat.jm('ar')` | `intl` with Arabic locales can switch digits / add marks (measured in 03-01); 12h math is 3 lines | Not reused for other date formats (none needed yet) |
| Return a record `({String clock, bool isAm})` | Return the final Arabic string | Pure function knows no Arabic; the l10n extension picks `timeAm` / `timePm` | Two steps instead of one |
| Two ARB keys `timeAm` / `timePm` | One key with an `{period}` placeholder | Each key is a full phrase a translator can reorder; no Arabic word built in code | One more key |
| `ArgumentError` on bad hour / minute | Clamp or wrap | Bad input = caller bug → fail loudly (project rule: no silent defaults) | — |
| Midnight special case only | Drop `:00` for every whole hour | The design writes `1:00 ص` and `12 ص` → only midnight is special | Looks like an inconsistency, but it is the design |

## Thinking steps
1. List the cases from the design: `9:30 م`, `1:00 ص`, `12 ص`; derive the edges: `00:30`, noon, minutes < 10.
2. `hour % 12 == 0 ? 12 : hour % 12` covers both 0 and 12.
3. Midnight check before the general path.
4. Mutation: delete the midnight line → `12 ص` test fails with `12:00 ص` ✔.

## Files
- `lib/core/utils/formatters.dart` — `formatClock`, `HikaFormatters.time`.
- `lib/core/l10n/app_ar.arb` — `timeAm`, `timePm`; generated l10n updated.
- `test/core/utils/formatters_test.dart` — 8 new tests.

## Principles & patterns
- **Records for small multi-value returns** — no class needed — overkill when the values travel far (then a named class).
- **Edge-case-driven tests** — midnight, half past midnight, noon, padding, out of range.
- **Fail loudly** on invalid input.

## Tests
- `formatClock`: `should pad minutes to two digits when minute is below 10` · `should throw ArgumentError when hour is out of range` · `should throw ArgumentError when minute is out of range`.
- `time`: `should show 9:30 م when time is 21:30` · `should show 1:00 ص when time is 01:00` · `should show 12 ص when time is midnight` · `should show 12:30 ص when time is 00:30` · `should show 12:00 م when time is noon`.
- Not tested: `DateTime` with seconds (ignored by design).

## Quiz
1. Why does `hour % 12 == 0 ? 12 : hour % 12` give the right 12h hour for both 0 and 12?
2. Why is midnight `12 ص` but 1 am `1:00 ص`?
3. Why return `isAm` instead of the Arabic word?
4. Why throw on hour 24 instead of treating it as midnight?
5. Where should UTC → local conversion happen, and why not inside `time()`?
