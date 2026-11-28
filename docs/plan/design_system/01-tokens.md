# Design System / 01 — Tokens

- **Goal:** all design tokens in `core/theme/` (light only), fonts bundled, `ThemeData` built from them and wired into `App`, plus a dev-only `DesignGalleryPage` that shows the tokens.
- **Branch:** `feat/ds-tokens` (from `develop`)
- **API:** none
- **Out of scope:** dark theme · components (sub-features 04-07) · icons / illustrations / logo (02) · money / time formatting (03) · press-scale behavior (04).
- **Decision points for the user:** resolved in the breakdown — theme API = **mix** (decision 3), static fonts (decision 5), no goldens (decision 4).
- **Source of truth:** `M1-Colors` + `M1-Type` (not `02_design_system.md` §1, which misses `borderInput #8F8378`).
- **Assumptions (say if you disagree):**
  1. **Theme API shape:** colors and text styles live in two `ThemeExtension`s (`HikaColors`, `HikaTextStyles`) with a `const` light instance each; widgets read them with `context.colors` / `context.textStyles`. Spacing, radii, shadows and motion are `abstract final class`es with `static const` values.
  2. **Text styles carry no color.** The color comes from where the text is used (`context.colors.textSecondary`). Default text color = `textPrimary` through `ThemeData.textTheme`.
  3. **Fonts:** the static TTFs from the Google Fonts family download (`static/` folder). Families `BalooBhaijaan2` (700) and `ReadexPro` (400/500/600/700). OFL license text is committed next to the fonts and registered with `LicenseRegistry`.
  4. **Dev gallery text is plain English, not l10n.** It's a dev-only tool and never ships in prod, so it doesn't need to go through `app_ar.arb`. Arabic sample text in the gallery is sample data, not UI copy.
  5. **Reaching the gallery:** `App` gets the `Flavor`; `createRouter(flavor:)` registers `/dev/gallery` **only in dev**, and the dev app opens on it until E2 adds the splash. Prod keeps `/` → placeholder.

---

## 01 — Bundle fonts
- **Layer:** wiring
- **Goal:** both font families render offline, and their licenses show on the licenses page.
- **Touch:** create `assets/fonts/` (`BalooBhaijaan2-Bold.ttf`, `ReadexPro-Regular|Medium|SemiBold|Bold.ttf`, `OFL-BalooBhaijaan2.txt`, `OFL-ReadexPro.txt`); `pubspec.yaml` (`fonts:` + license assets); create `lib/core/theme/hika_fonts.dart` (family-name constants); `lib/bootstrap.dart` (`LicenseRegistry.addLicense` for both).
- **Do NOT touch:** `app.dart`, any widget.
- **Tests:** none (no logic). Checked in task 06: gallery shows both families.
- **Done when:** analyze clean, existing tests pass, `flutter build apk --debug --flavor dev -t lib/main_dev.dart` succeeds.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — Colors
- **Layer:** presentation (core)
- **Goal:** every color in `M1-Colors` as a `HikaColors` `ThemeExtension` with a `const light` instance.
- **Touch:** create `lib/core/theme/hika_colors.dart` with these groups:
  - brand: `primary`, `primaryPressed`, `primaryDeep`, `primaryTint`, `positive`, `positiveDeep`, `positiveTint`
  - neutrals: `background`, `surface`, `surfaceMuted`, `border`, `borderStrong`, `borderInput`, `textPrimary`, `textSecondary`, `textDisabled`, `onPrimary`, `scrim`
  - status: `successFg/Bg`, `infoFg/Bg`, `warningFg/Icon/Bg`, `errorFg/Bg`, `star`
  - tiers: `tierBronze/Tint`, `tierSilver/Tint`, `tierGold/Tint`

  Plus `copyWith` and `lerp`. Test file: `test/core/theme/hika_colors_test.dart`.
- **Do NOT touch:** `ThemeData` (task 05).
- **Tests:** `should replace only the given color when copyWith is called` · `should return this when lerp other is not HikaColors` · `should return other colors when lerp t is 1`.
- **Done when:** analyze clean, tests pass, values match `M1-Colors` one by one.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 03 — Typography
- **Layer:** presentation (core)
- **Goal:** the 12 text styles from `M1-Type` as a `HikaTextStyles` `ThemeExtension`.
- **Touch:** create `lib/core/theme/hika_text_styles.dart` with `display`, `h1`, `h2` (Baloo) and `h3`, `title`, `body`, `bodyStrong`, `label`, `caption`, `micro`, `price`, `priceLarge` (Readex). Each style uses `height` = line / size. Plus `copyWith` and `lerp` (`TextStyle.lerp`). Test file: `test/core/theme/hika_text_styles_test.dart`.
- **Do NOT touch:** `hika_colors.dart`.
- **Tests:** `should use Baloo for display and headings when standard styles are read` · `should match M1-Type size weight and line height when standard styles are read` (table-driven, all 12) · `should replace only the given style when copyWith is called`.
- **Done when:** analyze clean, tests pass.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 04 — Spacing, radii, shadows, motion
- **Layer:** presentation (core)
- **Goal:** the `const`-only tokens.
- **Touch:** create:
  - `lib/core/theme/hika_spacing.dart`: `xs` 4, `sm` 8, `md` 12, `lg` 16, `xl` 24, `xxl` 32, `xxxl` 48, plus `screenMargin` 16, `minTouchTarget` 48, `bottomNavHeight` 64, `fixedBottomBarHeight` 72.
  - `lib/core/theme/hika_radii.dart`: `sm` 8, `md` 12, `lg` 20, `full` 999.
  - `lib/core/theme/hika_shadows.dart`: `elevation1` (0 4 16, 12 %), `elevation2` (0 −4 24, 16 %). Shadow color = `textPrimary` with alpha, not black.
  - `lib/core/theme/hika_motion.dart`: `fast` 120, `base` 200, `slowIn` 300, `slowOut` 200, `moment` 450, `pressedScale` 0.97, `spring` curve `Cubic(.34, 1.56, .64, 1)`.
- **Do NOT touch:** other theme files.
- **Tests:** none (constants only, no logic).
- **Done when:** analyze clean.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 05 — ThemeData + wire into App
- **Layer:** wiring
- **Goal:** the app runs on our theme, and Material widgets pick up our tokens.
- **Touch:**
  - create `lib/core/theme/hika_theme.dart`: `HikaTheme.light()` builds a `ThemeData` with Material 3, a `ColorScheme` mapped from `HikaColors.light`, scaffold background, `fontFamily` Readex, `textTheme` mapped from `HikaTextStyles` with color `textPrimary`, and `extensions: [HikaColors.light, HikaTextStyles.standard]`.
  - create `lib/core/theme/theme_context.dart`: `BuildContext` extension exposing `colors` and `textStyles`.
  - `lib/app.dart`: `theme: HikaTheme.light()`.
  - test file: `test/core/theme/hika_theme_test.dart`.
- **Do NOT touch:** router, `bootstrap.dart`.
- **Tests:** `should expose HikaColors and HikaTextStyles when theme is built` · `should map primary and background into ColorScheme and scaffold when theme is built` · `should read colors from context when widget is under HikaTheme` (pump a widget).
- **Done when:** analyze clean, all tests pass (including `app_test.dart`).
- **Model:** Sonnet · **Owner:** Claude · **Status:** todo

## 06 — Design gallery (dev only)
- **Layer:** presentation (core) + wiring
- **Goal:** a dev-only page that shows every token, so you can check them on a device; later sub-features add their sections to it.
- **Touch:**
  - create `lib/core/dev/design_gallery/design_gallery_page.dart`: one scrolling list of sections (colors with name + hex, type scale with Arabic samples, spacing, radii, shadows).
  - `lib/core/router/app_routes.dart`: `devGallery`.
  - `lib/core/router/app_router.dart`: `createRouter({required Flavor flavor})`; in dev only, the gallery route + `initialLocation`.
  - `lib/app.dart`: `App({required this.flavor})`.
  - `lib/bootstrap.dart`: pass the flavor.
  - tests: `test/app_test.dart`, `test/core/router/app_router_test.dart`.
- **Do NOT touch:** theme files (unless a bug is found).
- **Tests:** `should open design gallery when flavor is dev` · `should show not-found page when gallery path is opened in prod` · existing router + app tests updated to pass `flavor`.
- **Done when:** analyze clean, all tests pass, gallery checked on device at 360 / 430 width and font scale 130 %.
- **Model:** Sonnet · **Owner:** Claude · **Status:** todo

---

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/ds-tokens` → you check the gallery on device → PR to `develop`.
- Next: `02-assets` (icons, illustrations, vectorized logo).
