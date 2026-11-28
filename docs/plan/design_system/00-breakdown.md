# E1 — Design System · Breakdown

_Status: **approved** · 2026-11-28 — decision 1 = (b), 2 = (c), 3 = mix, 4-5 = recommended_
Based on `00-roadmap.md` (E1 row), `00-architecture.md`, `docs/brief/02_design_system.md`,
`HO-00-Decisions` and the M1 / HO-C pages pulled into `docs/brief/design/project/`.
Goal: every screen in E2+ is assembled from ready, token-only blocks. No feature logic here.

## Design sources (pulled 2026-11-28)
| Area | Pages |
|---|---|
| Tokens | `M1-Colors`, `M1-Contrast`, `M1-Type` (type, spacing, radii, shadows, motion) |
| Assets | `M1-Icons` (63 icons × Regular/Fill, inline SVG), `Icons`, `M1-Illustrations` (inline SVG), `M1-Images`, `M1-Stamp` |
| Components | `M1-Buttons`, `M1-Inputs`, `M1-Selections`, `M1-Navigation`, `M1-Feedback`, `HO-C-Feedback`, `HO-C-Controls`, `HO-C-Overlays`, `HO-C-Cards` |
| Feature parts (see decision 1) | `M1-Cards`, `M1-Payment`, `M1-Loyalty`, `Loyalty-Tiers`, `HO-C-Order` |
| States table | `HO-00-States` |

**Finding:** the logo / stamp exist **only as PNG masks** (`hk-full`, `hk-rings`, `hk-word` in the
artifact's asset store) — no vector. The brief asks for SVG. → decision 2.

## Sub-features (in order)

| # | Sub-feature | Branch | Contents | Depends on | ~Tasks |
|---|---|---|---|---|---|
| 01 | `tokens` | `feat/ds-tokens` | Fonts bundled as assets (Baloo Bhaijaan 2: 700 · Readex Pro: 400/500/600/700, OFL); `core/theme/`: colors (light only, incl. status + tiers), typography (12 styles), spacing, radii, shadows, motion; `HikaTheme.light()` → `ThemeData` (Material widgets map to tokens); wired into `App`; `DesignGalleryPage` skeleton (dev flavor only, route not registered in prod) showing tokens | E0 | 5 |
| 02 | `assets` | `feat/ds-assets` | `flutter_svg`; icons extracted from `M1-Icons` → `assets/icons/ic_{name}[_fill].svg`, `HikaIcons` paths + `HikaIcon` widget (color from theme, RTL mirroring for directional icons only); illustrations → `assets/illustrations/` + `HikaIllustration` (120 / 140); `HikaLogo` (decision 2); gallery sections | 01 | 4 |
| 03 | `formatters` | `feat/ds-formatters` | `core/format/`: money (`220 ج.م`, NBSP, `25,000`, English digits), time (12h `9:30 م`, `1:00 ص`), relative helpers used by components. Pure Dart, unit-tested | 01 | 2 |
| 04 | `buttons_inputs` | `feat/ds-buttons-inputs` | Shared press behavior (scale 97%, `fast`, reduced motion); `HikaButton` (primary / secondary / text / danger × 52 / 48; normal, pressed, loading with fixed width, disabled + reason line; price variant); `HikaIconButton` (40 visual / 48 touch); `HikaTextField` (52, label always on top, error, disabled, LTR mode), `HikaPasswordField`, `HikaMultilineField` (counter), `HikaDropdownField`, `HikaSearchField` (48, full radius) | 01, 02 | 5 |
| 05 | `selections` | `feat/ds-selections` | `HikaChoiceChip` (selected tint + 1.5 border + shape mark, unavailable dashed), `HikaCheckRow` (whole row tappable, trailing price), `HikaRadioCard`, `QtyStepper` (+ right, − / delete at 1, 40/48), `HikaSegmented`, `HikaSwitch` (primary; positive variant for balance only), `StarRating` (fills from right, 48 per star), `HikaTabs` | 04 | 5 |
| 06 | `feedback_states` | `feat/ds-feedback-states` | `ViewStatus` (8 states from architecture) ; `HikaBadge`, `InlineAlert` (success / info / warning / error, icon + text), `HikaSnackbar` (above nav or fixed button, 4 s, variants), `HikaDialog`, `HikaBottomSheet` (handle 36×4, max 90 %, fixed bottom button, scrim); `Shimmer` + `SkeletonBox`; `EmptyState`, `InlineErrorBlock`, `ErrorFullScreen`, `OfflineBar`, `OfflineFullScreen`, `HikaRefresh` | 02, 04 | 6 |
| 07 | `navigation_media_stamp` | `feat/ds-nav-media-stamp` | `HikaAppBar` (56), `HikaBottomNav` (visual only: 5 tabs, active fill + tint, cart counter, orders dot — shell wiring is E2), `CategoryCircle` (64); `cached_network_image` + `HikaNetworkImage` (fit/crop per place, white-image surface rule, loading shimmer, failed, no-image placeholder); `HikaStamp` (static + 450 ms animation, reduced-motion fade, success haptic) | 02, 06 | 4 |

**Total ≈ 31 tasks.** Every component task adds its section to `DesignGalleryPage` (all states visible).
Order after 01: 02 and 03 are independent; 04 → 05; 06 needs 04; 07 last.

## Explicitly NOT in E1
Dark theme (v1 is light only) · shell routing / tabs logic, splash, welcome (E2) · any Bloc or
feature model · real screens · App icon (E2/E11) · Rive.
If decision 1 = recommended, also not here: item / combo / cart cards (E4/E5), promo + balance parts,
`FreeDeliveryBar` (E5), `PaymentMethodCard` content, `TimeSlotGrid`, `CopyField`, `AmountCard`,
`ReceiptUpload` (E7), `OrderTrackLine`, order card + status badges (E8), `LoyaltyCard`, `TierBadge` (E9).

## Packages added in E1 (latest stable at `flutter pub add` time)
`flutter_svg` (02), `cached_network_image` (07) — both already approved in `00-architecture.md`.
No shimmer / font package: shimmer is ~40 lines, fonts are bundled assets (architecture rule).

## Decision points
1. **Scope of `core/widgets`** — (a) build every component in the brief now, incl. feature parts
   (loyalty card, order track line, receipt upload, item cards…) vs (b) E1 = tokens + assets +
   generic primitives + state widgets + stamp; feature parts are built in the epic that first uses
   them, **from these primitives**, and move to `core/widgets` only when a 2nd feature uses them.
   _Recommend (b):_ feature parts need domain shapes (item, order stage, tier) that don't exist yet →
   building them now = guessing APIs ("no just in case code"). Trade-off: gallery isn't complete in E1;
   E4-E9 each get 1-2 extra UI tasks. _(Changes the roadmap E1 row → update it on approval.)_
   **Resolved 2026-11-28: (b)** — roadmap E1 row updated; each feature epic starts with a "UI parts"
   task built from E1 primitives (design files listed in the table above).
2. **Logo / stamp source** — (a) use the high-res PNG masks now behind `HikaLogo` / `HikaStamp`
   (tinted with `ColorFilter`, swap to SVG later = one file) + ask the client for the vector logo vs
   (b) block until a vector arrives vs (c) trace the PNG to SVG ourselves.
   _Recommend (a):_ unblocks E1, tint works the same; (c) risks a distorted brand mark.
   **Resolved 2026-11-28: (c)** — user: Claude converts the PNG masks to SVG in 02 (no client
   request). Check: SVG overlaid on PNG at 168 px shows no visible drift; if it fails → fall back to (a).
3. **Theme API (learning-mode — you propose first, in 01)** — how widgets read tokens: static
   constants, `ThemeExtension` via `Theme.of(context)`, or a mix. Think about: `const` widgets,
   future dark mode, Material widgets (`TextField`, `Switch`) picking up our colors, and tests.
   **Resolved 2026-11-28: mix** (user's answer, matches the recommendation) — spacing, radii,
   shadows, motion = static `const`; colors + text styles = `ThemeExtension` read via `context`.
   User's why: dark mode later + keep `const`. Also gained: Material widgets get our colors through
   `ThemeData`, and tests can pump a widget with a custom theme.
4. **Widget tests, no goldens** — behavior tests per component (states, semantics label, 48 touch
   target, RTL mirroring, reduced motion) vs golden screenshots. _Recommend: no goldens_ —
   font rendering differs across machines/CI → flaky. Gallery + manual check covers looks.
5. **Fonts** — Google Fonts ships both as variable fonts; Flutter picks weights reliably only from
   static files. _Recommend:_ static TTF instances per weight (checked at 01-01).

## Review
- Every sub-feature: `@code-reviewer` (`sonnet`) on `git diff develop...HEAD` before its PR.
- Manual check of each sub-feature in `DesignGalleryPage` on device (360 / 430 width, font 130 %).
