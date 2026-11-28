# design_system-01-04 — Spacing, radii, shadows, motion

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The tokens that never change with a theme, as `const` values usable inside `const` widgets.

## Assumptions
- Shadow alpha: 12 % → `0x1F` (31/255), 16 % → `0x29` (41/255) — rounded to the nearest byte.
- Shadows are `const` with the textPrimary hex written in. If dark mode needs other shadows, they move to the theme then.
- Only the values in the plan. Component timings (snackbar 4 s, shimmer 1.2 s, pulse 1.6 s) come with their components.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `abstract final class` + `static const` | Top-level constants; `ThemeExtension` | Can't be instantiated or extended; grouped names (`HikaSpacing.lg`); works in `const` widgets | Not swappable per theme (not needed for these) |
| Named aliases (`screenMargin = lg`) | Use `lg` everywhere | The name says **why** 16; if the design changes the margin, one line changes | One more name |
| Shadows as `List<BoxShadow>` | Single `BoxShadow` | `BoxDecoration.boxShadow` takes a list → plug in directly | — |
| `Cubic(0.34, 1.56, 0.64, 1)` | `Curves.elasticOut`, `easeOutBack` | Same curve as the design's CSS (`cubic-bezier`) → same feel | — |

## Thinking steps
1. Split tokens: what could change in dark mode (colors, text) → theme; what can't → `const`.
2. Read values from `M1-Type` (spacing, radii, shadows, motion sections).
3. Convert CSS to Flutter: `0 4px 16px rgba(…, .12)` → `BoxShadow(offset, blurRadius, color alpha)`; `cubic-bezier` → `Cubic`.

## Files
- `lib/core/theme/hika_spacing.dart` — spacing scale + layout sizes.
- `lib/core/theme/hika_radii.dart` — 4 radii.
- `lib/core/theme/hika_shadows.dart` — 2 shadows.
- `lib/core/theme/hika_motion.dart` — durations, press scale, spring curve.

## Principles & patterns
- **`abstract final class` as a namespace** — Dart 3 way to group constants with no instances — overkill for one or two constants.
- **Design tokens as single source** — no magic numbers in widgets (project rule) — overkill in a one-screen prototype.

## Tests
- None: constants only, no logic. A test would just copy the values. Visual check in 01-06 (gallery).

## Quiz
1. Why are spacing and radii `const` but colors in a `ThemeExtension`?
2. What does `abstract final class` prevent, compared with a normal class?
3. Convert `box-shadow: 0 -4px 24px rgba(43,37,35,.16)` to Flutter — what's the alpha byte?
4. What does the `1.56` in the spring curve cause visually?
5. Why have `screenMargin` when it's equal to `lg`?
