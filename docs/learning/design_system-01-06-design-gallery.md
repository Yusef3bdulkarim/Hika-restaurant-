# design_system-01-06 — Design gallery (dev only)

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Tokens are only numbers in code. We need to **see** them on a real device, and every later component needs a place to show all its states — without that page ever shipping to customers.

## Assumptions
- Plan assumptions 4-5: gallery text in plain English (not l10n); dev app opens on the gallery until E2 adds the splash.
- Two files not in the plan's list, both small and needed: `gallery_section.dart` (title + child block, reused by every future section) and a gallery overflow test.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Route registered **only** in dev (`if (isDev)` in the routes list) | Route always there + hidden button; `kDebugMode` check | Prod router has no path to it at all → can't be deep-linked; flavor ≠ debug mode (a dev release build still shows it) | `App` and `createRouter` now need the `Flavor` |
| `Flavor` passed as a parameter (`App(flavor:)`) | Read from `get_it` | Explicit, easy to test (`App(flavor: Flavor.prod)`), no global lookup in widgets | One more constructor param |
| Dev opens on the gallery | Button on the placeholder page | No extra UI in a page that dies in E2 | Placeholder not visible in dev until E2 |
| Sections as separate widgets + data lists of records | One big `build()` | Small widgets; adding a token = one list line | — |
| `_nbsp` named constant | Raw NBSP character; ` ` escape | A raw NBSP is invisible in code review; the name says why (design rule) | — (03 `formatters` will own this rule) |
| Overflow test at 360 px + 130 % font | Only manual check | Catches layout breaks on every `flutter test`; the device check stays for the look | Test fonts differ from real ones → not a full replacement |

## Thinking steps
1. Flavor must reach the router → `bootstrap` → `App` → `createRouter`.
2. Prod safety: test that `/dev/gallery` in prod shows **not-found**, not just "no button".
3. Build sections from tokens only (the gallery follows the same rules as the app).
4. Overflow test: lazy `ListView` builds only what's visible → scroll to the last section first.
5. Mutation check: the first mutation (wider box in a `Wrap`) didn't fail — `Wrap` clamps children, so it was **not** an overflow. Second mutation (wider swatch in a `Row`) → `RenderFlex overflowed` → test fails ✔.

## Files
- `lib/core/dev/design_gallery/design_gallery_page.dart` — page with the section list.
- `lib/core/dev/design_gallery/gallery_section.dart` — titled block.
- `lib/core/dev/design_gallery/token_sections.dart` — colors, type, spacing, radii, shadows.
- `lib/core/router/app_routes.dart` / `app_router.dart` — dev-only route, `createRouter(flavor:)`.
- `lib/app.dart`, `lib/bootstrap.dart` — pass the flavor.
- `test/core/router/app_router_test.dart`, `test/app_test.dart`, `test/core/dev/design_gallery/design_gallery_page_test.dart`.

## Principles & patterns
- **Compile-out vs hide** — a route that doesn't exist can't be reached; a hidden button can — overkill for harmless debug info.
- **Dependency passed explicitly** (flavor) — overkill when many deep widgets need it → then DI.
- **Validate your test (mutation)** — a test that can't fail proves nothing; pick a mutation that really triggers the bug.

## Tests
- `should open design gallery when flavor is dev`
- `should show not-found page when gallery path is opened in prod` — the safety rule.
- `should show placeholder page when flavor is prod` (renamed: start page now depends on flavor).
- `should render every section without overflow when width is 360 and font scale is 130%` — verified it fails on a real `Row` overflow.
- App tests updated to `App(flavor: Flavor.prod)`.
- Not tested: exact visuals → your device check (360 / 430, font 130 %).

## Quiz
1. Why register the gallery route only in dev instead of hiding a button to it?
2. Why is `kDebugMode` the wrong check here?
3. Why did the test need `scrollUntilVisible` before checking for overflow?
4. Why didn't a too-wide box inside `Wrap` fail the test, but inside `Row` it did?
5. What's the risk of a raw NBSP character in source code?
