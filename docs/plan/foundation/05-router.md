# Foundation / 05 — Router

- **Goal:** `go_router` skeleton in `core/router/` — route constants, one placeholder route, a not-found route — and the app built with `MaterialApp.router`.
- **Branch:** `feat/router` (from `develop`)
- **API:** none
- **Out of scope:** splash / welcome / tabs (`StatefulShellRoute`) and guards (E2) · deep links from push (E11) · real screens · theme (E1).
- **Decision points for the user:** none big — defaults below, say if you disagree:
  1. **Router owned by `App` state** (`createRouter()` called once in `initState`, `dispose()`d) — not a global variable (state would leak between widget tests) and not in DI (nothing else needs it yet). E2 guards will pass Blocs in as `refreshListenable`.
  2. Route **paths and names as constants** in `AppRoutes` — screens navigate by name (`context.goNamed(AppRoutes.homeName)`), never raw strings.
- **Assumptions:** placeholder page moves from `app.dart` to `core/router/placeholder_page.dart` (temporary until E2 splash). Not-found text from l10n (`routeNotFound` = «الصفحة غير موجودة»).

---

## 01 — Router config
- **Layer:** presentation (core)
- **Goal:** a router that knows `/` and shows a not-found page for anything else.
- **Touch:** `pubspec.yaml` (`go_router` via `flutter pub add`), create `lib/core/router/app_routes.dart` (`AppRoutes.home = '/'`, `AppRoutes.homeName = 'home'`), `lib/core/router/app_router.dart` (`GoRouter createRouter()` with the home route + `errorBuilder`), `lib/core/router/placeholder_page.dart`, `lib/core/router/not_found_page.dart`; `lib/core/l10n/app_ar.arb` (`routeNotFound`) + regenerated l10n; test `test/core/router/app_router_test.dart`.
- **Do NOT touch:** `lib/app.dart` (task 02), DI.
- **Tests:** `should show placeholder page when location is home` · `should show not-found page when location is unknown` (pump a `MaterialApp.router` with l10n + `createRouter()`; go to `/nope`).
- **Done when:** analyze clean, tests pass.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — Wire router into App
- **Layer:** wiring
- **Goal:** `App` becomes a `StatefulWidget` that creates the router once, disposes it, and uses `MaterialApp.router`.
- **Touch:** `lib/app.dart` (remove inline placeholder), `test/app_test.dart` (existing title + RTL tests keep passing; add `should start on placeholder page when app starts`).
- **Do NOT touch:** `bootstrap.dart`, router files from 01 (unless a bug is found).
- **Done when:** analyze clean, all tests pass, `flutter build apk --debug --flavor dev -t lib/main_dev.dart` succeeds.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

---

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/router` → PR to `develop`.
- **E0 done** → M1 needs E1 + E2. Next: E1 `design_system` breakdown.
