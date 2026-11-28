# design_system-01-03 — Typography

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The 12 text styles of `M1-Type` in one place, read through the theme like the colors.

## Assumptions
- Styles have **no color** (plan assumption 2): the widget picks the color (`textPrimary` default comes from `ThemeData` in 01-05).
- Instance named `standard` (not `light`): the type scale doesn't change with dark mode.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `ThemeExtension<HikaTextStyles>` | Static styles; Material `TextTheme` only | Same API as colors; `TextTheme` names (`headlineSmall`…) don't match the design names (`price`, `micro`) | `copyWith` / `lerp` boilerplate |
| No color in styles | Color baked in (`textPrimary`) | One style works on any background (`caption` in secondary gray, `price` in positive) without `copyWith` everywhere | Each widget must set its color (or inherit the default) |
| `height: 40 / 32` | `height: 1.25` | The design gives line height in px; writing the division keeps it readable and exact | — |
| Table-driven test | 12 separate tests | One behavior ("matches M1-Type"), 12 rows; `reason: name` shows which row failed | — |

## Thinking steps
1. `M1-Type` → 12 rows of family / size / weight / line height.
2. Flutter's `height` is a **multiplier** of `fontSize`, not px → `line / size`.
3. Test the contract (values from the design) since a wrong weight is a real bug; check line height as `size × height` to test the px the design promised.

## Files
- `lib/core/theme/hika_text_styles.dart` — extension + `standard` instance.
- `test/core/theme/hika_text_styles_test.dart` — family, values table, `copyWith`.

## Principles & patterns
- **Separate concerns: shape vs color** — style = size/weight/font; color = context — overkill if every text in the app had one color.
- **Table-driven tests** — same check over many rows — overkill for 1-2 cases.

## Tests
- `should use Baloo for display and headings when standard styles are read` — catches a heading set to the wrong family (brief rule: Baloo for headings only).
- `should match M1-Type size weight and line height when standard styles are read` — all 12 rows; fails if any value drifts from the design.
- `should replace only the given style when copyWith is called` — `copyWith` contract.
- Not tested: `lerp` — same pattern as `HikaColors` (already tested there) and uses Flutter's `TextStyle.lerp`.

## Quiz
1. `height: 24 / 15` — what does Flutter compute from it, and why not write `24`?
2. Why don't the styles carry a color? Give one design example where that helps.
3. Why `HikaTextStyles` and not just Material's `TextTheme`?
4. In the table test, what does `reason: name` give you when a test fails?
5. What does `closeTo(line, 0.001)` protect against?
