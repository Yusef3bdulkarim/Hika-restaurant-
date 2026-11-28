# foundation-05-01 — Router config

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The app needs declarative routing (deep links from push, guards for guest/session, 5-tab shell later). Routes must be defined in one place and reachable by name, with a safe screen for unknown links.

## Assumptions
- `go_router` 18.1.4 (latest stable at `flutter pub add`).
- `app.dart` still has its own inline placeholder until task 02 wires the router — short-lived duplication between the two tasks.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `go_router` | Navigator 2.0 by hand, `auto_route` (codegen) | Architecture decision; official package; guards via `redirect`; `StatefulShellRoute` for tabs; no codegen | — |
| `createRouter()` factory | Global `final appRouter = GoRouter(...)` | Each test gets a fresh router (no leaked location between tests); `App` controls lifetime and `dispose` | Caller must dispose |
| `AppRoutes` with `abstract final class` + `static const` | Strings in each screen; enum | One source of paths/names; `abstract final` = cannot be instantiated or extended | — |
| Navigate by **name** | Navigate by path | Paths can change (e.g. `/menu/:id`) without touching callers | Two constants per route |
| `errorBuilder` → `NotFoundPage` (l10n text) | Default go_router error screen | Default shows an English technical message; broken deep links must show Arabic UI | — |
| Placeholder moved to `core/router/` | Keep in `app.dart` | Router needs a widget to build; temporary until E2 splash | — |

## Thinking steps
1. Add package → define constants → define the router as a function.
2. Unknown route must never show technical text → `errorBuilder` + l10n key.
3. Test with a real `MaterialApp.router` + l10n delegates; navigate with `router.go('/nope')`.
4. Dispose router in `tearDown` (it is a `ChangeNotifier`).

## Files
- `lib/core/router/app_routes.dart` — paths + names.
- `lib/core/router/app_router.dart` — `createRouter()`.
- `lib/core/router/placeholder_page.dart` — temporary start screen.
- `lib/core/router/not_found_page.dart` — unknown route screen.
- `lib/core/l10n/app_ar.arb` (+ generated) — `routeNotFound`.
- `test/core/router/app_router_test.dart` — 2 widget tests.
- `pubspec.yaml` / `.lock` — `go_router`.

## Principles & patterns
- **Declarative routing** — the URL describes the screen; enables deep links — overkill for a 2-screen app with no links.
- **Factory function for stateful objects** — fresh instance per owner/test.
- **No technical text in UI** — even error routes are localized.

## Tests
- `should show placeholder page when location is home` — default start location works.
- `should show not-found page when location is unknown` — broken deep link shows the Arabic not-found page (type + text).

## Quiz
1. Why a `createRouter()` function instead of a global router variable?
2. What is the benefit of `goNamed` over `go('/path')`?
3. What would a user see on a broken deep link without `errorBuilder`?
4. Why must the router be disposed?
5. What does `abstract final class` prevent?
