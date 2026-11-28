# Design System / 02 — Assets

- **Goal:** all icons, illustrations and the logo as SVG assets, each behind a typed widget (`HikaIcon`, `HikaIllustration`, `HikaLogo`) and shown in the gallery.
- **Branch:** `feat/ds-assets` (from `develop`, after PR #7 is merged)
- **API:** none
- **Out of scope:** `HikaStamp` + its animation (07) · app icon / launcher (E2/E11) · images from the network (07) · any component that uses icons (04+).
- **Decision points for the user:** none big. Breakdown decision 2 = Claude vectorizes the logo. Defaults below, say if you disagree.
- **Sources:**
  - `M1-Icons`: 59 icons × `regular` / `fill`, inline SVG with `data-icon` names, 24 grid, stroke 1.75.
  - `M1-Illustrations`: 15 illustrations, inline SVG, 160 viewBox, token colors.
  - Logo: the artifact's PNG masks `hk-full`, `hk-rings`, `hk-word`.
- **Assumptions:**
  1. **One-off extraction, not committed.** A script in the scratchpad pulls the SVGs out of the design HTML. The generated `.svg` files are committed; the script is not, since nothing in the build needs it. If the design changes, it is re-run the same way.
  2. **Icons are tinted, not colored.** Every icon has one color, so `HikaIcon` paints it with a `ColorFilter` (`srcIn`). The default color comes from `IconTheme`, so icons inside buttons and nav pick the right color with no extra code.
  3. **Illustrations keep their own colors.** They use 6 token colors baked in, so no tint is applied.
  4. **Directional icons:** only `back`, `see-all` and `logout`, the ones the design marks «بيتعكس». Clock, search, cart and the rest never mirror. _Revised in 01:_ the assets are drawn **for RTL** (`back` = chevron pointing right), so they mirror when the direction is **LTR**.
  5. **Names:** `assets/icons/ic_{name}.svg` + `ic_{name}_fill.svg` (snake_case from `data-icon`). `assets/illustrations/ill_{name}.svg`. `assets/logo/logo_{full|rings|word}.svg`.
  6. **Vectorizing the logo:** `potrace` via `npx` in the scratchpad (no project dependency). Accepted when the SVG drawn over the PNG at 168 px shows no visible drift. If it fails, fall back to the PNG behind the same `HikaLogo` API.

---

## 01 — Icon assets
- **Layer:** wiring
- **Goal:** 118 icon SVGs in the project that render correctly with `flutter_svg`, including the 32 `fill` variants that use `<mask>`.
- **Touch:** `pubspec.yaml` (`flutter pub add flutter_svg`, `assets/icons/`); create `assets/icons/*.svg`. In each file: drop `width`/`height` (keep `viewBox`), keep shapes and masks as they are.
- **Do NOT touch:** `lib/`. A spike to check masks is allowed, but it isn't committed.
- **Tests:** none (assets only).
- **Done when:**
  - 118 files exist: 59 names × 2.
  - A spike shows a masked `fill` icon (e.g. `menu`) rendering its cut-outs on a device.
  - If masks aren't supported: stop and report before going on.
  - Build OK.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — `HikaIcons` + `HikaIcon` widget
- **Layer:** presentation (core)
- **Goal:** type-safe icons with tint, size and RTL mirroring.
- **Touch:**
  - create `lib/core/widgets/hika_icon.dart`:
    - `enum HikaIcons` with 59 values. Each value has its asset paths and a `directional` flag.
    - `HikaIcon(icon, {filled = false, size = 24, color, semanticLabel})`. `color` falls back to `IconTheme`. The icon is mirrored when `directional` is set and `Directionality` is LTR.
  - gallery: create `lib/core/dev/design_gallery/asset_sections.dart` (`IconsSection`: every icon, regular + fill) and add it to the page.
  - test: `test/core/widgets/hika_icon_test.dart`.
- **Do NOT touch:** theme files, router.
- **Tests:**
  - `should mirror icon when icon is directional and direction is ltr`
  - `should not mirror icon when icon is directional and direction is rtl`
  - `should not mirror icon when icon is not directional`
  - `should use IconTheme color when no color is given`
  - `should load fill asset when filled is true`
  - `should be excluded from semantics when no label is given`
  - Gallery overflow test still passes.
- **Done when:** analyze clean, tests pass, every asset path in the enum exists (test: `should have an asset file for every icon and variant`).
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 03 — Illustrations
- **Layer:** presentation (core)
- **Goal:** the 15 illustrations as assets behind a typed widget.
- **Touch:**
  - create `assets/illustrations/ill_*.svg`, one per illustration: `empty_cart`, `no_orders`, `no_notifications`, `no_offers`, `no_addresses`, `empty_favorites`, `no_search_results`, `offline`, `server_error`, `maintenance`, `app_update`, `link_sent`, `location_permission`, `notification_permission`, `restaurant_closed`.
  - `pubspec.yaml` (assets dir).
  - create `lib/core/widgets/hika_illustration.dart`: `enum HikaIllustrations` + `HikaIllustration(name, {size = HikaIllustrationSize.screen})`. Sizes: `inline` = 120 (empty template), `screen` = 140 (full screens). Decorative, so excluded from semantics: the title next to it carries the meaning.
  - gallery: `IllustrationsSection`.
  - test: `test/core/widgets/hika_illustration_test.dart`.
- **Do NOT touch:** `hika_icon.dart`.
- **Tests:**
  - `should render at 120 when size is inline`
  - `should render at 140 when size is screen`
  - `should have an asset file for every illustration`
  - `should be excluded from semantics when rendered`
- **Done when:** analyze clean, tests pass, all 15 seen in the gallery on device.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 04 — Logo (vectorized)
- **Layer:** presentation (core)
- **Goal:** the logo as SVG with one color, ready for splash/welcome (E2) and the stamp (07).
- **Touch:**
  - download the 3 PNG masks into the scratchpad and trace them with `potrace` (`npx`, isolated folder).
  - create `assets/logo/logo_full.svg`, `logo_rings.svg`, `logo_word.svg` and add them to `pubspec.yaml`.
  - create `lib/core/widgets/hika_logo.dart`: `HikaLogo({variant = full, size, color})`, where `color` defaults to `primary`.
  - gallery: `LogoSection`, which shows each SVG over its PNG at 168 px for the drift check. The PNGs stay in the scratchpad and the overlay is a dev-only check.
  - test: `test/core/widgets/hika_logo_test.dart`.
- **Do NOT touch:** stamp (07).
- **Tests:**
  - `should use primary color when no color is given`
  - `should load rings asset when variant is rings`
  - `should have an asset file for every variant`
- **Done when:** analyze clean, tests pass, you approve the overlay on device. If you reject it → PNG fallback (assumption 6).
- **Done as:** trace checked by pixel diff of the `flutter_svg` render vs the source mask (full 0.59 %, rings 0.43 %, word 0.60 %, edges only), instead of an in-app overlay. `HikaLogo` takes `width`, not `size` (word is 391 × 179).
- **Model:** Opus (brand mark, judgment on trace quality) · **Owner:** Claude · **Status:** done

---

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/ds-assets` → device check of the gallery → PR to `develop`.
- Next: `03-formatters`.
