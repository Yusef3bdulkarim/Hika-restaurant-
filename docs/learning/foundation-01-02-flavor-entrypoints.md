# foundation-01-02 — Flavor + entrypoints

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- One `main.dart` cannot start the app against two environments (dev / prod). We need one entrypoint per flavor that share the same startup code.

## Assumptions
- `bootstrap(Flavor flavor)` receives the flavor now but does not use it yet — Firebase init per flavor uses it in 03.
- Placeholder screen is an empty `Scaffold` (no text) — text must come from l10n, which arrives in task 04.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `main_dev.dart` / `main_prod.dart` → shared `bootstrap()` | One `main.dart` + `--dart-define=FLAVOR=dev` | Flavor is chosen at compile time by the file (`-t`), impossible to mistype; matches Android `productFlavors` | Two tiny files instead of one |
| `enum Flavor { dev, prod }` | String / bool `isDev` | Exhaustive `switch` — compiler forces handling every flavor | — |
| `bootstrap` is `async` | Sync | Firebase init (03) and DI (02) are async and go here | — |
| Added `test/app_test.dart` now (planned for 04) | Leave `test/` empty | Deleting the counter test would leave zero tests; 04 extends this file | Small deviation from the task's file list |

## Thinking steps
1. Separate "which environment" (entrypoint) from "how the app starts" (bootstrap) from "what the app is" (`App`).
2. Keep `App` free of flavor logic — it only builds UI.
3. Remove the counter demo and its test.
4. Verify: analyze, test, `flutter build apk --debug -t lib/main_dev.dart`.

## Files
- `lib/core/config/flavor.dart` — the two environments.
- `lib/bootstrap.dart` — shared startup: binding init → `runApp`. Future home of Firebase + DI init.
- `lib/main_dev.dart` / `lib/main_prod.dart` — one-line entrypoints per flavor.
- `lib/app.dart` — root widget (`MaterialApp`, placeholder).
- `test/app_test.dart` — boot smoke test.
- Deleted: `lib/main.dart`, `test/widget_test.dart`.

## Principles & patterns
- **Composition root / bootstrap** — all wiring in one place before `runApp` — overkill for a single-environment toy app.
- **Single responsibility** — entrypoint picks env, bootstrap wires, `App` renders.

## Tests
- `should render placeholder scaffold when app starts` — proves `App` builds without errors. Replaced/extended in 04 with l10n + RTL checks.
- `bootstrap()` not tested — it calls `runApp` and binding init; covered by the manual run.

## Quiz
1. Why is `-t lib/main_dev.dart` safer than `--dart-define=FLAVOR=dev`?
2. Why does `WidgetsFlutterBinding.ensureInitialized()` have to run before Firebase init?
3. Why should `App` not know which flavor it is running?
4. What would you lose if `Flavor` was a `String`?
