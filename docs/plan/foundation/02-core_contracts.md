# Foundation / 02 — Core contracts

- **Goal:** shared result / error / use-case contracts, local JSON storage and the DI container that every feature builds on.
- **Branch:** `feat/core-contracts` (from `develop`, after `feat/project-setup` is merged)
- **API:** none (local `shared_preferences` only)
- **Out of scope:** Firebase exception mapper + `AuthFailure(AuthFailureReason)` (03), `StreamUseCase` (E8), Bloc packages (E2), any feature registration in DI.
- **Decision points for the user:** resolved 2026-11-27 —
  1. Names `ApiSuccess` / `ApiFailure` (not `Success` / `Error` — clashes with `dart:core` `Error`).
  2. `Failure` carries **no message** — typed only; presentation maps type → l10n key.
  3. Unknown errors → `ServerFailure` (8 types, no `UnexpectedFailure`).
- **Assumptions:** data sources **throw** (`CacheException`); repositories catch and return `ApiResult` — same pattern as Firebase data sources in later epics. Shared-preferences API (`SharedPreferencesAsync` vs `SharedPreferencesWithCache`) verified against the installed version in task 02.

---

## 01 — ApiResult + Failure + UseCase
- **Layer:** domain (core, pure Dart)
- **Goal:** the typed contracts every repository and use case returns.
- **Touch:** `pubspec.yaml` (`equatable`; dev `mocktail`), create `lib/core/result/api_result.dart` (sealed `ApiResult<T>`, `ApiSuccess<T>(data)`, `ApiFailure<T>(failure)`), `lib/core/error/failure.dart` (sealed `Failure extends Equatable`: `Server`, `Network`, `Cache`, `Permission`, `NotFound`, `RateLimit(Duration? retryAfter)`, `Validation(Map<String, String> fieldErrors)` — `AuthFailure` + its reason enum are added in 03 with the mapper, so no placeholder enum now), `lib/core/usecase/usecase.dart` (`abstract interface class UseCase<T, P>`, `NoParams`); tests `test/core/result/api_result_test.dart`, `test/core/error/failure_test.dart`.
- **Do NOT touch:** `lib/app.dart`, `bootstrap.dart`; no `package:flutter` import in these files.
- **Tests:** `should be equal when two failures have same type and fields` · `should not be equal when ValidationFailure field errors differ` · `should not be equal when RateLimitFailure retryAfter differs` · `should expose data when result is ApiSuccess` (via `switch`) · `should expose failure when result is ApiFailure` (via `switch`).
- **Done when:** analyze clean, tests pass, `switch` over `ApiResult` / `Failure` is exhaustive without `default`.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — LocalStorage (shared_preferences wrapper)
- **Layer:** data (core)
- **Goal:** read / write / remove JSON values by key; failures surface as `CacheException`.
- **Touch:** `pubspec.yaml` (`shared_preferences`), create `lib/core/error/exceptions.dart` (`CacheException`), `lib/core/storage/local_storage.dart` (`Future<Object?> readJson(String key)` — `null` when key missing, throws `CacheException` on corrupt JSON or plugin error; `Future<void> writeJson(String key, Object value)`; `Future<void> remove(String key)`); test `test/core/storage/local_storage_test.dart` (mock prefs with mocktail).
- **Do NOT touch:** DI (task 03); no bool/int helpers (added by the epic that needs them).
- **Tests:** `should return decoded map when key holds valid JSON` · `should return null when key is missing` · `should throw CacheException when stored value is not valid JSON` · `should throw CacheException when plugin read fails` · `should store encoded JSON when writeJson is called` · `should throw CacheException when plugin write fails` · `should delete key when remove is called`.
- **Done when:** analyze clean, tests pass.
- **Model:** Sonnet · **Owner:** Claude · **Status:** todo

## 03 — DI container
- **Layer:** wiring
- **Goal:** one `get_it` container, configured in `bootstrap()` before `runApp`.
- **Touch:** `pubspec.yaml` (`get_it`), create `lib/core/di/injection.dart` (`final sl = GetIt.instance;` `Future<void> configureDependencies()` registering the prefs instance + `LocalStorage` as lazy singletons), `lib/bootstrap.dart` (call it); test `test/core/di/injection_test.dart`.
- **Do NOT touch:** `lib/app.dart`; no feature registrations.
- **Tests:** `should resolve LocalStorage when dependencies are configured` (with `sl.reset()` in `tearDown`).
- **Done when:** analyze clean, tests pass, `flutter build apk --debug --flavor dev -t lib/main_dev.dart` succeeds.
- **Model:** Sonnet · **Owner:** Claude · **Status:** todo

---

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/core-contracts` → PR to `develop`.
