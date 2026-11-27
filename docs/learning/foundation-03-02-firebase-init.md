# foundation-03-02 — Initialize Firebase by flavor

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Firebase must be initialized before anything uses it, with the options of the flavor that is running.

## Assumptions
- Uses each generated file's `currentPlatform` (not `.android` directly) → an unsupported platform (iOS before it is configured) fails loudly with `UnsupportedError`.
- No device was available during the task → on-device run is part of the user's manual check.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `firebaseOptionsFor(Flavor)` with exhaustive `switch` | `if (flavor == Flavor.dev)` | Adding a flavor = compile error until handled | — |
| Import prefixes `as dev` / `as prod` | Rename generated classes | Both generated files declare `DefaultFirebaseOptions`; prefixes avoid editing generated code | Slightly longer names |
| Init order: binding → Firebase → DI → `runApp` | DI before Firebase | Later DI registrations will take Firebase instances (`FirebaseFirestore.instance`), which need an initialized app | Startup waits for Firebase init |
| Top-level function, not a class | `FirebaseConfig` class | One pure mapping; a class adds nothing | — |

## Thinking steps
1. `bootstrap` already receives `flavor` (left unused in 01-02 for this moment).
2. Two generated classes share a name → import prefixes.
3. Map flavor → options with a `switch` expression.
4. Test the mapping by `projectId` (the value that actually matters).
5. Build both flavors.

## Files
- `lib/core/firebase/firebase_options.dart` — flavor → `FirebaseOptions`.
- `lib/bootstrap.dart` — `await Firebase.initializeApp(...)` before DI.
- `test/core/firebase/firebase_options_test.dart` — 2 tests.

## Principles & patterns
- **Composition root** — environment decided once at startup.
- **Don't edit generated code** — wrap it instead.

## Tests
- `should return dev project options when flavor is dev` / `…prod…` — a swapped mapping would send test orders to the real restaurant project; this is the most expensive mistake this task could make.
- Not tested: `Firebase.initializeApp` itself (platform channel) — verified by running the app.

## Quiz
1. Why must Firebase init come before `configureDependencies()` in the future?
2. Why import with `as dev` / `as prod`?
3. What happens if you run the app on iOS now, and why is that better than silently using Android options?
4. Why test `projectId` and not the whole `FirebaseOptions` object?
