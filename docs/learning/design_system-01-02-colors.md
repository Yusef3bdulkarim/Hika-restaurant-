# design_system-01-02 — Colors

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- All 34 design colors in one place, read through the theme (decision 3 = mix), so dark mode later = a second instance, not a rewrite.

## Assumptions
- `scrim` = `textPrimary` at 50 % → alpha `0x80` (128/255 ≈ 50.2 %).
- `M1-Colors` wins over the brief: it adds `borderInput #8F8378` (inputs, checkbox, radio).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `ThemeExtension<HikaColors>` | Static `HikaColors.primary`; Material `ColorScheme` only | Swappable per theme (dark later); `ColorScheme` has no slots for tiers, status, `positive` | Needs `context`; long `copyWith` / `lerp` |
| `static const light` instance | Build it in a function | `const` → one object, zero cost, usable in `const ThemeData` extensions | — |
| Semantic names (`errorFg`, `tierGold`) | Raw names (`red700`) | The name says **where** a color is allowed → enforces the design rules (green = gain only) | More names to learn |
| `lerp` via local `mix()` | 34 × `Color.lerp(a, b, t)!` | Shorter, one place for the `!` | — |
| Script check design hex ↔ code | Eye check | 34 values: a typo is easy, a set diff catches it | Checks values, not name ↔ value pairing (done by reading) |

## Thinking steps
1. Source = `M1-Colors` (it is the newer contract than the brief) → list every token with its group.
2. `ThemeExtension` needs `copyWith` + `lerp` → Flutter uses `lerp` to animate between themes.
3. Tests cover only the logic (`copyWith`, `lerp`), not the 34 constants.
4. Verify values with a set diff against the design file.

## Files
- `lib/core/theme/hika_colors.dart` — the extension + `light` instance.
- `test/core/theme/hika_colors_test.dart` — `copyWith` / `lerp` tests.

## Principles & patterns
- **ThemeExtension** — custom design tokens that travel with `ThemeData` — overkill for an app with one theme forever and no custom tokens.
- **Semantic tokens** — name by role, not by hue — overkill for a throwaway prototype.

## Tests
- `should replace only the given color when copyWith is called` — the core contract of `copyWith`; checks a far field too (a missed `??` line fails).
- `should return this when lerp other is not HikaColors` — Flutter calls `lerp` with `null` when a theme lacks the extension.
- `should return other colors when lerp t is 1` — end of an animation must land exactly on the target.
- Not tested: each constant value (that would just copy the file) → covered by the script check.

## Quiz
1. Why doesn't `ColorScheme` alone fit Hika's colors? Name two tokens with no slot.
2. When does Flutter call `lerp` on a `ThemeExtension`?
3. Why is `lerp(null, t)` returning `this` correct, not throwing?
4. `0x802B2523` — what does each part mean?
5. The design says green = customer gain only. How does naming `positive` instead of `green` help keep that rule?
