# foundation-03-01 — FlutterFire config per flavor

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The app must talk to `hika-dev-3fb2e` when built as `dev` and to `hika-279b8` when built as `prod`. Each Firebase project needs its own registered Android app and config files.

## Assumptions
- Android only (iOS needs a Mac).
- `firebase_core` added here instead of 02 — the generated options files import it; without it `dart analyze` fails and the commit would be broken.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Two `flutterfire configure` runs with `--out` + `--android-out` per flavor | One config + switch project at runtime only | Gradle picks `src/dev/` or `src/prod/google-services.json` automatically by flavor; Dart side picks options by `Flavor` | Two generated Dart files |
| Files under `lib/core/firebase/` | Default `lib/firebase_options.dart` | Architecture: shared infra lives in `core/` | Longer paths in commands |
| Commit options + `google-services.json` | gitignore them | Breakdown decision 2: client keys are not secrets; security = Rules | Keys visible in repo (expected for Firebase) |
| Google Services Gradle plugin `4.6.0` | `4.3.15` written by the CLI | Project rule: latest stable (checked Google Maven `release` = 4.6.0) | — |
| User ran the CLI | Claude runs it | It creates apps in the user's Firebase projects — outward-facing action | — |

## Thinking steps
1. One Android app per Firebase project, ids match flavors (`com.hika.app.dev` / `com.hika.app`).
2. Generate per-flavor files to flavor source sets (`android/app/src/{flavor}/`).
3. Check generated `projectId` / `package_name` values match.
4. Analyze failed (missing `firebase_core`) → added it now.
5. CLI pinned an old plugin → bumped to latest.
6. Built both flavors.

## Files
- `lib/core/firebase/firebase_options_dev.dart` / `_prod.dart` — generated `FirebaseOptions` (do not edit; rerun CLI).
- `android/app/src/dev/google-services.json` / `src/prod/…` — Android config per flavor.
- `android/settings.gradle.kts` / `android/app/build.gradle.kts` — Google Services plugin.
- `firebase.json` — FlutterFire CLI record of what was generated (used when re-running).
- `pubspec.yaml` / `.lock` + `linux/ macos/ windows/` generated registrants — `firebase_core`.

## Principles & patterns
- **Environment isolation** — test data never touches the real restaurant project — overkill for a solo hobby app.
- **Flavor source sets** — Android merges `src/main` + `src/{flavor}` automatically.

## Tests
- None — generated config. Verified by `dart analyze`, building both flavors, and checking ids in the generated files.

## Quiz
1. How does Gradle know which `google-services.json` to use?
2. Why are Firebase Android API keys safe to commit, and what actually protects the data?
3. What breaks if `--android-package-name` does not match the flavor's `applicationId`?
4. Why was `firebase_core` added in this task and not in 02?
5. What is `firebase.json` used for here?
