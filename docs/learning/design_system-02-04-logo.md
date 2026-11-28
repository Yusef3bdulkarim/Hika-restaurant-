# design_system-02-04 — Logo (vectorized)

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The design only has the logo as PNG **masks** (512 px). We need a vector logo (sharp at any size, recolorable) for splash / welcome (E2) and the stamp (07) — breakdown decision 2 = Claude vectorizes it.

## Assumptions
- The shape is in the PNG's **alpha** channel (the CSS uses them as `mask`), so the RGB is white everywhere → convert alpha to black-on-white before tracing.
- Variants: `full` (rings + word), `rings`, `word` — the three masks the design uses.
- `width` instead of `size`: `word` is not square (391 × 179), so only the width is given and the height follows the aspect ratio.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `potrace` (JS) in an isolated scratch folder | Add a package to the project; trace by hand in a vector tool | No project dependency; reproducible; standard tracer | Third-party code run once, outside the repo |
| Measure the trace: render the SVG with **`flutter_svg`** and diff pixels against the source | Overlay in the gallery (plan) | A number beats an eye check; uses the same renderer as the app | Plan deviation (the PNGs never enter the app) |
| Accept ≤ 0.6 % pixel difference | Retrace at higher resolution | The differing pixels sit on edges (anti-aliasing); by eye the renders match the source | — |
| One-color SVG + `ColorFilter` (`primary` default) | Bake the red into the SVG | The stamp needs `positive` green too (delivered moment) | — |
| Decorative unless labelled | Always labelled «هيكا» | Usually next to the app name / title; splash can pass a label | Caller must remember the label when the logo stands alone |

## Thinking steps
1. Looked at the PNGs → blank → realized they're masks → the shape is in alpha.
2. Alpha → black on white → `potrace` → one `evenodd` path per variant.
3. Verified with the real renderer: `flutter_svg` draws each SVG at the original size → pixel diff vs source: full 0.59 %, rings 0.43 %, word 0.60 %.
4. Looked at the renders → rings and letters clean.
5. Widget = same pattern as `HikaIcon` / `HikaIllustration`; gallery shows each variant at 168 px (stamp size), rings also in `positive`.

## Files
- `assets/logo/logo_full.svg`, `logo_rings.svg`, `logo_word.svg`.
- `pubspec.yaml` — `assets/logo/`.
- `lib/core/widgets/hika_logo.dart` — `HikaLogoVariant` + `HikaLogo`.
- `lib/core/dev/design_gallery/asset_sections.dart` — `LogoSection`; page + gallery test updated.
- `test/core/widgets/hika_logo_test.dart` — 4 tests.

## Principles & patterns
- **Verify by measuring** — pixel diff with the production renderer — overkill for assets you drew yourself in a vector tool.
- **Isolate third-party tools** — install in a throwaway folder, run with an explicit path — overkill for packages the project already trusts.
- **Same widget pattern** for every asset type (enum + asset getter + files-exist test).

## Tests
- `should have an asset file for every variant`.
- `should use primary color when no color is given` — design: the stamp/logo is primary unless it's the "delivered" moment.
- `should load rings asset when variant is rings`.
- `should be excluded from semantics when no label is given`.
- Not in the suite: the pixel diff (one-off check, numbers recorded above). Device check of the gallery by you.

## Quiz
1. Why did the downloaded PNGs look completely blank?
2. Why is a pixel diff with `flutter_svg` a better check than viewing the SVG in a browser?
3. Where do the ~0.5 % differing pixels come from, and why is that acceptable?
4. Why does `HikaLogo` take `width` and not `size`?
5. Why keep the SVG one-color instead of baking in the brand red?
