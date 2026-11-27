# foundation-02-02 — LocalStorage

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Cart, recent searches and similar small data must survive app restarts (D2). Features should not talk to `shared_preferences` directly or parse JSON themselves.

## Assumptions
- `shared_preferences` 2.5.6 → uses `SharedPreferencesAsync` (the legacy `SharedPreferences` class is the old API).
- JSON only for now; bool/int helpers added by the epic that needs them (E2 first-launch flag).
- Added one test not in the plan: remove failure (same rule as read/write).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `SharedPreferencesAsync` | Legacy `SharedPreferences`, `SharedPreferencesWithCache` | Current recommended API; always reads the real stored value (no stale cache) | Every read is async |
| Data source **throws** `CacheException`; repository maps to `CacheFailure` | Return `ApiResult` from `LocalStorage` | Same shape as Firebase data sources later: data sources throw, repositories catch → one rule everywhere | Each repository has a try/catch |
| `CacheException(cause)` keeps the original error | No cause | Debugging (`toString`) without exposing it to UI | — |
| Catch `on Exception` / `on FormatException`, not everything | `catch (e)` | `jsonEncode` on a non-JSON object throws an `Error` = programmer bug → should crash in dev, not become a "cache" failure | Bug surfaces as crash (wanted) |
| Prefs injected in constructor | Create `SharedPreferencesAsync()` inside | Mockable in tests; DI decides the instance (task 03) | — |
| Returns `Object?` | `Map<String, dynamic>?` | Covers maps and lists (recent searches); caller casts with `strict-casts` | Caller must cast |

## Thinking steps
1. Define the contract by its consumers: read (may be missing), write, remove.
2. List what can fail: plugin I/O, corrupt stored text → both become `CacheException`.
3. Separate "missing" (`null`, normal) from "broken" (exception, abnormal).
4. Mock the plugin with mocktail; one test per behavior.

## Files
- `lib/core/error/exceptions.dart` — `CacheException`.
- `lib/core/storage/local_storage.dart` — JSON read/write/remove wrapper.
- `test/core/storage/local_storage_test.dart` — 8 tests.
- `pubspec.yaml` / `.lock` — `shared_preferences`.

## Principles & patterns
- **Adapter / wrapper** — hides the plugin behind our own small API — overkill if only one place ever used prefs.
- **Dependency injection via constructor** — enables mocking.
- **Exceptions in data sources, `Failure` from repositories** — the error boundary rule.

## Tests
- Valid JSON → decoded; missing key → `null` (empty state is not an error).
- Corrupt JSON / plugin read / write / remove failure → `CacheException` (no silent failures).
- Write stores exactly the encoded string (`verify`).
- Not tested: real device storage (plugin's responsibility).

## Quiz
1. Why is "key missing" `null` but "corrupt JSON" an exception?
2. Why does `LocalStorage` throw instead of returning `ApiResult`?
3. What happens if someone calls `writeJson(key, DateTime.now())`? Why is that OK?
4. Why inject `SharedPreferencesAsync` instead of creating it inside the class?
5. In a test, what would break if `readJson` used `catch (e)` for everything?
