# foundation-05-02 — Wire router into App

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- `App` still used `MaterialApp(home: ...)` with its own placeholder. It must use the router from 05-01, create it exactly once, and release it when the app widget is removed.

## Assumptions
- None beyond the plan.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `App` → `StatefulWidget` owning the router | `StatelessWidget` + `createRouter()` in `build` | `build` can run many times → a new router each time would reset navigation. Project rule: never create controllers in `build()`; dispose them | A bit more code |
| `late final _router = createRouter()` | Assign in `initState` | Created once, on first access (first `build`); `final` = cannot be replaced | — |
| `_router.dispose()` in `dispose` | No dispose | `GoRouter` is a `ChangeNotifier`; listeners must be released | — |
| `MaterialApp.router(routerConfig:)` | `routerDelegate` + `routeInformationParser` separately | One object carries parser, delegate and provider | — |

## Thinking steps
1. Replace `home:` with `routerConfig:`; delete the inline placeholder (now in `core/router/`).
2. Router lifetime = `App` state lifetime → `StatefulWidget`.
3. Keep existing l10n + RTL tests unchanged; add a start-route test.
4. Build dev APK.

## Files
- `lib/app.dart` — `StatefulWidget`, owns + disposes router, `MaterialApp.router`.
- `test/app_test.dart` — + `should start on placeholder page when app starts` (title and RTL tests unchanged and passing).

## Principles & patterns
- **Owner disposes** — whoever creates a `ChangeNotifier` disposes it — overkill only for objects that live for the whole process with no tests.
- **Don't create in build** — `build` must be cheap and side-effect free.

## Tests
- `should start on placeholder page when app starts` — router wired, initial location `/`.
- Title (`هيكا`) and RTL tests still pass → l10n and locale survived the switch to `MaterialApp.router`.

## Quiz
1. What goes wrong if `createRouter()` is called inside `build`?
2. Why `late final` here instead of initializing in the field declaration without `late`?
3. Why must `GoRouter` be disposed?
4. What three things does `routerConfig` provide to `MaterialApp.router`?
