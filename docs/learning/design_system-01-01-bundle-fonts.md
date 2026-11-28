# design_system-01-01 — Bundle fonts

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The design uses Baloo Bhaijaan 2 (headings) and Readex Pro (everything else). They must render offline, with no runtime download.

## Assumptions
- Static TTFs from the Google Fonts CSS API (one file per weight) = the same font files as the Google Fonts family download.
- Weights = only what `M1-Type` uses: Baloo 700 · Readex 400 / 500 / 600 / 700.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Bundle TTFs as assets | `google_fonts` package | Works offline and on first launch; no extra package (architecture rule) | APK +~540 KB |
| Static file per weight | One variable font (`[wght]`) | Flutter maps `FontWeight` → file reliably with static files; variable fonts need `FontVariation` per style | 5 files instead of 2 |
| Only the used weights | All weights | Smaller app; `M1-Type` is the contract | Need a new file if the design adds a weight |
| Register OFL in `LicenseRegistry` | Ship the license file only | OFL requires the license to travel with the font; `showLicensePage` lists it | Two asset entries + a small function |
| Family-name constants in `HikaFonts` | Raw strings in each `TextStyle` | One place to change; no typo bugs | — |

## Thinking steps
1. Check the design → which families and weights are really used.
2. Find the static files → the CSS API returns a `.ttf` URL per weight.
3. Download into an isolated folder → check they're real TTFs (`00 01 00 00` header) **and contain Arabic glyphs** (`uni0627` = alef). A Latin-only file would look fine in tests and fail on device.
4. Copy into `assets/fonts/` → declare in `pubspec.yaml` → register the licenses → analyze, tests, build.

## Files
- `assets/fonts/*.ttf` — the 5 font files.
- `assets/fonts/OFL-*.txt` — license texts.
- `pubspec.yaml` — `fonts:` families + license assets.
- `lib/core/theme/hika_fonts.dart` — family-name constants.
- `lib/bootstrap.dart` — `_registerFontLicenses()` before `runApp`.

## Principles & patterns
- **Verify downloaded assets** — checking the file type and the Arabic coverage — overkill for an asset you made yourself.
- **Lazy stream (`async*`)** — license files are read only when the licenses page opens, not at startup.
- **Records + destructuring** (`for (final (family, path) in …)`) — pairs data with no extra class — overkill as soon as the data grows more fields → make a class.

## Tests
- None in this task: no logic. Verified: `dart analyze` clean, 33/33 tests pass, `flutter build apk --debug --flavor dev` OK.
- The fonts are checked visually in task 06 (gallery).

## Quiz
1. Why bundle the fonts instead of using `google_fonts`? Name one case where `google_fonts` breaks the design.
2. What does `weight: 600` in `pubspec.yaml` do when a `TextStyle` asks for `FontWeight.w600`? What happens if the file for that weight is missing?
3. Why check for the `uni0627` glyph after downloading?
4. Why is the license registered with `async*` instead of reading the files inside `bootstrap()`?
5. What does the OFL license require us to do when we ship the font in the app?
