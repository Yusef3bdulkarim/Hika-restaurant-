# design_system-02-01 — Icon assets

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The 59 Hika icons (× Regular / Fill) live only as inline SVG inside the design HTML. The app needs them as asset files that `flutter_svg` can draw, including 32 Fill icons that use `<mask>`.

## Assumptions
- First occurrence of each `data-icon` + `data-v` on the page = the catalog tile. Later copies are usage demos and are skipped.
- Colors stay as drawn (`#2B2523` / `#8E1B25`): `HikaIcon` (02) tints the whole icon, so the baked color doesn't matter.
- Mask check done with an offscreen render in a throwaway test (real rendering, viewed as a PNG), instead of on a device. Same engine; faster.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Extract with a one-off Node script (not committed) | Copy by hand; commit the script | 118 files by hand = typos; the build never needs the script (plan assumption 1) | Re-sync means re-writing ~20 lines |
| Strip `width`/`height`, keep `viewBox` | Keep the 28 px size | The widget decides the size; `viewBox` keeps the shape scaling right | — |
| Check mask support in the compiler's **source** before rendering | Trust docs / memory | `vector_graphics_compiler 1.3.7` has `MaskNode` + `masking_optimizer` → facts, not guesses | — |
| Render all 118 into one PNG and look at it | Only check "no exception" | A parse can succeed and still draw wrong (e.g. mask ignored → solid shape) | Manual look, not automated |
| `flutter_svg` | `vector_graphics` precompiled; icon font | Already approved in architecture; reads plain SVG; supports masks | Parses at runtime (cached) |

## Thinking steps
1. Inspect the markup → each icon has `data-icon` (English name) + `data-v` → clean, scriptable.
2. Extract → 118 files, unique names.
3. Risk = masks → check the parser source → supported.
4. Prove it: render every icon → look → cut-outs visible (pizza dots, receipt lines) ✔.
5. While looking: `back` is a **right** chevron → icons are drawn for RTL → mirror on **LTR**. Fixed the plan for task 02 before writing code.

## Files
- `assets/icons/ic_{name}.svg`, `ic_{name}_fill.svg` — 118 icons.
- `pubspec.yaml` — `flutter_svg`, `assets/icons/`.

## Principles & patterns
- **Spike, then delete** — answer one risky question with throwaway code — overkill when the answer is already in docs you trust.
- **Read the source of a dependency** — settles "does it support X?" in minutes — overkill for well-documented basics.
- **Look at the output** — catches the "passes but wrong" class of bugs.

## Tests
- None committed: assets only. Typed access + an "every asset exists" test come in 02.
- Spike (deleted): rendered all 118 icons with `SvgPicture.asset` → no exceptions, masks drawn.

## Quiz
1. Why remove `width`/`height` but keep `viewBox`?
2. What would a Fill icon look like if the renderer ignored `<mask>`?
3. Why render to a PNG instead of only asserting no exception?
4. How did looking at the `back` icon change task 02's plan?
5. When would you commit the extraction script instead of throwing it away?
