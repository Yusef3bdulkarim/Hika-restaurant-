# design_system-01-05 — ThemeData + wire into App

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Our tokens exist but the app still runs on Material's default theme (purple, Roboto). Connect them so our widgets **and** Material's own widgets use the design.

## Assumptions
- `secondary` = `primary`: the design has one brand color; Material widgets that use `secondary` should look the same.
- Material text slots with no design twin get the closest style (e.g. all `display*` → `display`), so no slot is left on Roboto.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Full `ColorScheme(...)` | `ColorScheme.fromSeed(primary)` | `fromSeed` **generates** colors that aren't in the design (rule: no color outside the tokens) | More lines to map |
| No `fontFamily:` in `ThemeData` | `fontFamily: readex` | `ThemeData` applies `fontFamily` to **every** text slot → would turn Baloo headings into Readex | Must fill all 15 slots ourselves |
| Fill all 15 `TextTheme` slots | Only the ones we use | Unset slots fall back to Roboto → wrong Arabic font in Material widgets | Some slots share a style |
| `letterSpacing: 0` in the theme mapping | Leave Material's default | Material's type geometry adds `0.25` etc. → breaks Arabic letter joining look; design has no letter spacing | — |
| `context.colors` with `!` | Nullable + fallback | Missing theme = wiring bug → fail loudly (project rule: no silent defaults) | Crash if a test forgets the theme |
| `const` removed on `ColorScheme` | Keep `const` | A `const` expression can't read fields of another object (`colors.primary`) | Built once per `light()` call — negligible |

## Thinking steps
1. Map tokens → Material `ColorScheme` slots by **role** (container = tint, outline = border…).
2. Map text styles → `TextTheme` slots by what Material uses them for (`bodyMedium` = default `Text`, `bodyLarge` = `TextField`, `titleLarge` = `AppBar`).
3. Find hidden defaults: `fontFamily` overrides everything; geometry adds letter spacing.
4. Prove the hidden default with a test, then break the code on purpose and watch the test fail (mutation check: `0.25` came back).

## Files
- `lib/core/theme/hika_theme.dart` — `HikaTheme.light()` → `ThemeData`.
- `lib/core/theme/theme_context.dart` — `context.colors` / `context.textStyles`.
- `lib/app.dart` — `theme: HikaTheme.light()`.
- `test/core/theme/hika_theme_test.dart` — 4 tests.

## Principles & patterns
- **Adapter** — `HikaTheme` translates our tokens into Material's vocabulary — overkill if no Material widget is used.
- **Extension methods on `BuildContext`** — short, discoverable access — overkill for a value read in one place.
- **Mutation check** — break the code, the test must fail — overkill for trivial getters.

## Tests
- `should expose HikaColors and HikaTextStyles when theme is built` — extensions are registered.
- `should map primary and background into ColorScheme and scaffold when theme is built` — Material widgets and screens get our colors.
- `should read colors from context when widget is under HikaTheme` — the `context` API works end to end.
- `should render unstyled text in Readex textPrimary when widget is under HikaTheme` — default `Text` font, color, and zero letter spacing; verified it fails (`0.25`) without the fix.
- Not tested: each of the 18 `ColorScheme` / 15 `TextTheme` mappings — a copy of the file; checked in the gallery (01-06).

## Quiz
1. Why not `ColorScheme.fromSeed(seedColor: primary)`?
2. What happens to the Baloo headings if we pass `fontFamily: HikaFonts.readex` to `ThemeData`?
3. Where did the `0.25` letter spacing come from, and why is it bad for Arabic?
4. Why does `context.colors` use `!` instead of returning a default theme?
5. Why did `const ColorScheme(primary: colors.primary)` not compile even though `colors` is `const`?
