# foundation-02-03 — DI container

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Classes need their dependencies (e.g. `LocalStorage` needs prefs) without creating them inside. One place must build and hand out instances before the app starts.

## Assumptions
- `configureDependencies()` is **sync** (plan said `Future`) — nothing async to register yet; it becomes `async` when something needs it (Firebase in 03). Avoids a fake `Future`.
- Added dev dependency `shared_preferences_platform_interface` (official, already transitive) — needed for `InMemorySharedPreferencesAsync` in tests.
- Added `kotlin.incremental=false` to `android/gradle.properties` (not in the task's file list) — the dev build failed without it.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `get_it`, manual registration | `injectable` (codegen), Provider/`RepositoryProvider` | Project rules: `get_it`, no codegen | Registration written by hand |
| `registerLazySingleton` for prefs + `LocalStorage` | `registerSingleton`, `registerFactory` | One shared instance, created only when first used | — |
| Blocs will be `registerFactory` (rule) | Singleton Blocs | New Bloc per screen, no stale state | — |
| Global `sl` + one `configureDependencies()` called in `bootstrap()` | Per-feature containers | Single composition root; feature modules add `registerX()` functions later | Global service locator (used only in DI + page creation, never inside classes) |
| In-memory platform in the DI test | Mock prefs | Tests the real `configureDependencies()` wiring | Extra dev dependency |
| `kotlin.incremental=false` | Move project to `C:`; clean build each time | Known Kotlin cache bug when project and pub cache are on different drives; failure reproduced twice after clearing cache | Slightly slower Kotlin compile (plugins only) |

## Thinking steps
1. What exists to register now? Only prefs + `LocalStorage` → register only those.
2. Is anything async? No → sync function.
3. Test: real wiring with an in-memory platform (constructor throws without a platform).
4. Build dev APK → failed in `shared_preferences_android:compileDebugKotlin` ("Could not close incremental caches") → cleared that cache, failed again → root cause = cross-drive incremental cache → disabled incremental Kotlin → build OK.

## Files
- `lib/core/di/injection.dart` — `sl` + `configureDependencies()`.
- `lib/bootstrap.dart` — calls it before `runApp`.
- `test/core/di/injection_test.dart` — wiring test, `sl.reset()` in `tearDown`.
- `android/gradle.properties` — `kotlin.incremental=false`.
- `pubspec.yaml` / `.lock` — `get_it`, dev `shared_preferences_platform_interface`.

## Principles & patterns
- **Composition root** — all object creation in one place — overkill for a 2-class app.
- **Dependency inversion** — `LocalStorage` receives prefs, does not create them.
- **Service locator (limited)** — `sl` used only at the edges; classes still take constructor params so tests can inject mocks.
- **Fix root cause, not symptom** — cache clearing was tried first to prove it was not transient.

## Tests
- `should resolve LocalStorage when dependencies are configured` — fails if a registration is missing or wrong.
- `sl.reset()` in `tearDown` — keeps tests independent (deterministic).
- Not tested: `bootstrap()` — covered by the dev build/run.

## Quiz
1. Difference between `registerLazySingleton`, `registerSingleton` and `registerFactory`? Which one for a Bloc and why?
2. Why must the test reset `sl` after each test?
3. Why did the DI test need an in-memory platform but the `LocalStorage` test did not?
4. Why is calling `sl<X>()` inside a repository a bad idea even though it works?
5. Why make `configureDependencies()` sync now?
