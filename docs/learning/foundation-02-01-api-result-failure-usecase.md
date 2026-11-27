# foundation-02-01 — ApiResult + Failure + UseCase

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Every repository and use case needs one way to say "here is the data" or "this went wrong, and how" — without throwing exceptions across layers and without leaking technical text to the UI.

## Assumptions
- `AuthFailure` + its reason enum come in 03 (with the Firebase mapper) — no placeholder enum now.
- Tests use `flutter_test` (already a dev dependency) even for pure-Dart code — no extra `test` package.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `sealed class ApiResult<T>` → `ApiSuccess` / `ApiFailure` | `dartz` / `fpdart` `Either`; throwing exceptions | No package; `switch` is exhaustive — compiler errors if a case is forgotten | No `map`/`fold` helpers (added only if needed) |
| Names `ApiSuccess` / `ApiFailure` | `Success` / `Error` | `Error` exists in `dart:core` → name clash | Longer names |
| `Failure` without `message` | `Failure(String message)` (flutter-feature skill) | Presentation maps type → l10n key; Firebase/English text can never reach the Arabic UI | Debug info is not carried (no logging infra yet) |
| Unknown errors → `ServerFailure` | 9th `UnexpectedFailure` | UI shows the same generic error anyway; keeps 8 types from the architecture | Cannot tell "server error" from "unexpected" later |
| `Failure extends Equatable` | Override `==` manually | Value equality needed by `bloc_test` / `expect` | Extra package (official-style, widely used) |
| `UseCase<T, P>` as `abstract interface class` with `call` | Plain functions; abstract class | One shape for all use cases, mockable, callable as `useCase(params)`; `interface` forbids inheriting implementation | One class per use case |
| `P` can be a record | One `Params` class per use case | Records are free, typed and have value equality | Big inputs may still deserve a class |

## Thinking steps
1. What does the UI need from an error? Only its **kind** (+ a few fields like `retryAfter`, `fieldErrors`) → typed classes, no strings.
2. How do we force every caller to handle both outcomes? → `sealed` + `switch`.
3. Which failures need extra data? Only `RateLimit` and `Validation` → only they override `props`.
4. Keep everything pure Dart so `domain/` can import it.

## Files
- `lib/core/result/api_result.dart` — success/failure wrapper.
- `lib/core/error/failure.dart` — 7 failure types (+ `AuthFailure` in 03).
- `lib/core/usecase/usecase.dart` — use case contract + `NoParams`.
- `test/core/error/failure_test.dart`, `test/core/result/api_result_test.dart`.
- `pubspec.yaml` / `.lock` — `equatable`, dev `mocktail`.

## Principles & patterns
- **Result type (errors as values)** — repositories never throw to the domain — overkill for scripts where a crash is fine.
- **Sealed hierarchy + exhaustive switch** — compiler checks every case — overkill when only one outcome is possible.
- **Separation of error *kind* from error *text*** — text lives in l10n.

## Tests
- Equality (same type, different type, different `fieldErrors`, different `retryAfter`) — `bloc_test` compares states containing failures; broken equality = flaky Bloc tests.
- `switch` over `ApiSuccess` / `ApiFailure` — proves the pattern consumers will use and that data/failure are reachable.
- Not tested: `UseCase` / `NoParams` — no behavior, only a contract.

## Quiz
1. What happens at compile time if a new `Failure` subtype is added and a `switch` does not handle it?
2. Why does `NetworkFailure` not override `props`, but `ValidationFailure` does?
3. Why is `Failure` without a message safer for an Arabic-only app?
4. Write the signature of a login use case using a record as `P`.
5. Why `abstract interface class` and not just `abstract class` for `UseCase`?
