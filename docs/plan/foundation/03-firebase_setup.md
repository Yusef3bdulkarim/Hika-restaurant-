# Foundation / 03 — Firebase setup

- **Goal:** each flavor starts Firebase against its own project; Firebase errors map to typed `Failure`s.
- **Branch:** `feat/firebase-setup` (from `develop`)
- **API:** none (no reads/writes yet)
- **Projects:** dev = `hika-dev-3fb2e` (Android app `com.hika.app.dev`) · prod = `hika-279b8` (Android app `com.hika.app`)
- **Out of scope:** `cloud_firestore` + app→Emulator switch (E2, first Firestore read) · `firebase_auth` + `AuthFailure` (E3) · `cloud_functions` (E5) · iOS config (needs Mac) · Functions/Rules/Emulator Suite (04).
- **Decision points for the user:** resolved 2026-11-27 —
  1. Only `firebase_core` now; each Firebase package is added by the epic that first uses it.
  2. Generic mapper on `FirebaseException.code` (Auth/Functions exceptions extend it — verify at implementation).
  3. App→Emulator switch moved to E2.
- **Assumptions:** Firestore offline persistence is on by default on Android/iOS → no explicit `Settings` until E2 needs cache options. `flutterfire_cli` updated to latest (1.5.0) before task 01.

---

## 01 — FlutterFire config per flavor
- **Layer:** wiring
- **Goal:** Firebase config files for both flavors, Google Services Gradle plugin applied.
- **Owner:** **Shared** — the user runs the commands (they register Android apps in the user's Firebase projects); Claude checks the output.
- **Commands (from repo root):**
  - `flutterfire configure --project=hika-dev-3fb2e --platforms=android --android-package-name=com.hika.app.dev --out=lib/core/firebase/firebase_options_dev.dart --android-out=android/app/src/dev/google-services.json --yes`
  - `flutterfire configure --project=hika-279b8 --platforms=android --android-package-name=com.hika.app --out=lib/core/firebase/firebase_options_prod.dart --android-out=android/app/src/prod/google-services.json --yes`
- **Touch (generated / edited by the CLI):** the two options files, two `google-services.json`, `android/settings.gradle.kts`, `android/app/build.gradle.kts` (google-services plugin), `firebase.json` (FlutterFire section); `firebase_core` added here (generated files import it); Google Services plugin bumped 4.3.15 → 4.6.0.
- **Do NOT touch:** `ios/`, `lib/bootstrap.dart` (task 02).
- **Done when:** files exist with the right project ids; `flutter build apk --debug --flavor dev -t lib/main_dev.dart` and `--flavor prod -t lib/main_prod.dart` succeed. All committed (breakdown decision 2).
- **Model:** Sonnet · **Status:** done

## 02 — Initialize Firebase by flavor
- **Layer:** wiring
- **Goal:** `bootstrap()` initializes Firebase with the options of the running flavor before DI and `runApp`.
- **Touch:** (`firebase_core` already added in 01) create `lib/core/firebase/firebase_options.dart` (`FirebaseOptions firebaseOptionsFor(Flavor flavor)` — exhaustive `switch`), `lib/bootstrap.dart` (`await Firebase.initializeApp(options: firebaseOptionsFor(flavor))`); test `test/core/firebase/firebase_options_test.dart`.
- **Do NOT touch:** generated options files, DI registrations.
- **Tests:** `should return dev project options when flavor is dev` · `should return prod project options when flavor is prod` (compare `projectId`).
- **Done when:** analyze clean, tests pass; both flavors run on a device with no Firebase init error (manual).
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 03 — Firebase exception → Failure mapper
- **Layer:** data (core)
- **Goal:** one function every Firebase data source/repository uses to turn `FirebaseException` into a `Failure`.
- **Touch:** create `lib/core/firebase/firebase_failure_mapper.dart` (`Failure mapFirebaseException(FirebaseException e)`); test `test/core/firebase/firebase_failure_mapper_test.dart`.
- **Mapping:** `unavailable`, `network-request-failed`, `deadline-exceeded` → `NetworkFailure` · `permission-denied` → `PermissionFailure` · `not-found` → `NotFoundFailure` · `resource-exhausted`, `too-many-requests` → `RateLimitFailure()` · anything else → `ServerFailure` (decision 3 of 02).
- **Do NOT touch:** `failure.dart` (no new types).
- **Tests:** one per mapped group + `should return ServerFailure when code is unknown`.
- **Done when:** analyze clean, tests pass; file not imported from any `domain/`.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

---

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/firebase-setup` → PR to `develop`.
- Manual check: dev and prod start without Firebase errors; Firebase console shows both Android apps.
