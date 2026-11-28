# design_system-02-03 — Illustrations

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Empty / offline / error / permission states each need their illustration (15 in `M1-Illustrations`), as assets behind a typed widget at the two design sizes.

## Assumptions
- Page order = plan name order; the script prints `name <- Arabic label` to prove each pairing.
- Illustrations are decorative: the state's title says what happened (design: the illustration always sits above a title).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Keep baked token colors, no tint | Tint like icons | 6 colors per illustration; a single tint would flatten them | Dark mode later needs dark copies (not in v1) |
| `enum HikaIllustrationSize { inline(120), screen(140) }` | `double size` param | Only two sizes exist in the design → impossible to pass 133 by mistake | New size = new enum value |
| Same pattern as `HikaIcons` (enum + asset getter + "files exist" test) | Different shape | One pattern across asset widgets → nothing new to learn | — |
| Element check before rendering (`path`, `circle`, `ellipse`, `rect`, `g`) | Render only | Quick proof nothing unsupported (filters, `text`, `use`) is inside | — |

## Thinking steps
1. Extract by order + labels → verify the name ↔ label pairing in the script output.
2. List the SVG element types → all basic.
3. Widget + size enum + tests; gallery section; overflow test extended.
4. Render all 15 to a PNG and look → all correct (then delete the spike).

## Files
- `assets/illustrations/ill_*.svg` — 15 files.
- `pubspec.yaml` — `assets/illustrations/`.
- `lib/core/widgets/hika_illustration.dart` — enums + widget.
- `lib/core/dev/design_gallery/asset_sections.dart` — `IllustrationsSection`; page + gallery test updated.
- `test/core/widgets/hika_illustration_test.dart` — 4 tests.

## Principles & patterns
- **Make invalid states unrepresentable** — size enum instead of a free number — overkill when sizes are truly open.
- **Consistency over cleverness** — same structure as `HikaIcon`.

## Tests
- `should have an asset file for every illustration` — enum ↔ files in sync.
- `should render at 120 when size is inline` / `should render at 140 when size is screen` — the two design sizes.
- `should be excluded from semantics when rendered` — no "image" noise for screen readers.
- Not tested: pixels → rendered once and checked by eye; gallery on device.

## Quiz
1. Why are illustrations not tinted like icons?
2. What does the size enum prevent that `double size` allows?
3. Why is the illustration excluded from semantics but an icon can have a label?
4. What would you check if an illustration rendered blank in the app?
5. What changes for illustrations when dark mode arrives?
