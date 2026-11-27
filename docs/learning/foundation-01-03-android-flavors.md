# foundation-01-03 — Android flavors + package id

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- App still used `com.example.hika_app` and had one build. We need the real id `com.hika.app` and two Android flavors so dev and prod install side by side and later point to different Firebase projects.

## Assumptions
- Launcher names «هيكا» (prod) / «هيكا Dev» (dev).
- iOS bundle id (`com.example.hikaApp`) left as is — iOS flavors need a Mac (out of scope).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `applicationIdSuffix = ".dev"` | Same id for both | Both installed on one phone; Firebase sees two separate Android apps | Second Android app must be registered in `hika-dev` (03) |
| App name via `manifestPlaceholders["appName"]` → `android:label="${appName}"` | `resValue("string", "app_name", …)` (planned) | The project's AGP disables `resValues` by default — build failed. Placeholders need no feature flag | Name is only usable in the manifest, not as an Android string resource (not needed) |
| Dimension `env` | No dimension | Gradle requires a dimension when flavors exist; name describes intent | — |
| `namespace` = `applicationId` base = `com.hika.app` | Keep `com.example` namespace | Namespace = Kotlin package of `MainActivity`; keeping them equal avoids confusion | `MainActivity.kt` had to move folders |

## Thinking steps
1. Rename `namespace` + `applicationId`, move `MainActivity` to the matching package folder.
2. Add `productFlavors` with a suffix for dev.
3. First build failed: `Product Flavor dev contains custom resource values, but the feature is disabled` → read the error, switched to manifest placeholders instead of enabling an extra feature.
4. Verified ids in `build/app/outputs/apk/*/debug/output-metadata.json`.

## Files
- `android/app/build.gradle.kts` — namespace, app id, flavors.
- `android/app/src/main/AndroidManifest.xml` — label from placeholder.
- `android/app/src/main/kotlin/com/hika/app/MainActivity.kt` — moved from `com/example/hika_app`.

## Principles & patterns
- **Build variants (flavor × build type)** — `devDebug`, `prodRelease`… — overkill when there is only one backend environment.
- **Read the error before changing approach** — the fix came from the exact Gradle message.

## Tests
- No Dart tests — Gradle config. Verified by building both flavors and checking `applicationId` in output metadata. User checks install side by side manually.

## Quiz
1. What is the difference between `namespace` and `applicationId`?
2. Why must `MainActivity.kt`'s folder match its `package` line?
3. Name the 4 build variants this config produces.
4. Why does the dev app need its own Android app in Firebase?
5. What would happen to installs if both flavors had the same `applicationId`?
