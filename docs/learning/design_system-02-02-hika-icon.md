# design_system-02-02 — `HikaIcons` + `HikaIcon`

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- 118 icon files with string paths = typos and no autocomplete. We need typed access, the right color by default, and correct mirroring.

## Assumptions
- Default size 24 (design grid). Callers pass other sizes (e.g. 20 in icon buttons).
- Icons are decorative by default: the text or button next to them carries the meaning. A standalone icon passes `semanticLabel`.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `enum HikaIcons` with fields (file, `directional`) | Class of `static const String` paths | Enum = closed set, `values` for the gallery and the "all files exist" test; data (mirroring) lives with the icon | Adding an icon = one enum line + 2 files |
| Mirror when **LTR** (`Transform.flip`) | Mirror in RTL (as first planned) | Assets are drawn for RTL (found in 02-01) | If a future icon is drawn LTR-first, it needs its own flag |
| Default color from `IconTheme` | Fixed `textPrimary` | Buttons and nav set `IconTheme` → icons follow with zero code (like Material `Icon`) | Outside any theme it falls back to Flutter's default |
| `ColorFilter.mode(color, srcIn)` | Rewrite SVG colors | One-color icons: `srcIn` paints every drawn pixel the tint; masks keep the holes | Multi-color icons wouldn't work (none exist) |
| `excludeFromSemantics` unless labelled | Always announce | Screen readers would read "image" next to every button label | Must remember the label on icon-only buttons (04 `HikaIconButton` will require it) |

## Thinking steps
1. Turn file names into camelCase enum values; flag the 3 «بيتعكس» icons.
2. Widget = SVG + tint + size + semantics + mirroring.
3. Test behavior through the real `SvgPicture` props (filter, asset name, semantics), not internals.
4. Mutation check: swap LTR ↔ RTL → 2 tests fail ✔.
5. Gallery: every icon Regular + Fill, colors as in `M1-Icons`; overflow test extended with `Icons`.

## Files
- `lib/core/widgets/hika_icon.dart` — enum + widget.
- `lib/core/dev/design_gallery/asset_sections.dart` — `IconsSection`.
- `lib/core/dev/design_gallery/design_gallery_page.dart` — adds the section.
- `test/core/widgets/hika_icon_test.dart` — 8 tests.
- `test/core/dev/design_gallery/design_gallery_page_test.dart` — `Icons` added.

## Principles & patterns
- **Enhanced enums** — values carrying data + getters — overkill when the set is open (e.g. icons from a server).
- **Inherit context defaults (`IconTheme`)** — parent decides, child follows — overkill if the widget is only ever used one way.
- **Accessibility by default** — decorative unless told otherwise.

## Tests
- `should have an asset file for every icon and variant` — catches an enum entry with a missing / misspelled file.
- `should mirror icon when icon is directional and direction is ltr` / `should not mirror … rtl` / `… not directional` — the 3 mirroring cases.
- `should use IconTheme color when no color is given` / `should use given color when color is given`.
- `should load fill asset when filled is true`.
- `should be excluded from semantics when no label is given`.
- Not tested: pixel output → gallery + device.

## Quiz
1. Why does `back` mirror in LTR and not in RTL in this project?
2. What does `BlendMode.srcIn` do with the icon's own color?
3. Why default to `IconTheme.of(context).color` instead of `textPrimary`?
4. What would a screen reader say for a decorative icon without `excludeFromSemantics`?
5. What does the "every asset exists" test protect against that the compiler can't?
