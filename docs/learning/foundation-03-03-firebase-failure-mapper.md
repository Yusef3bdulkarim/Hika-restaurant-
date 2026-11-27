# foundation-03-03 — Firebase exception → Failure mapper

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Every Firebase data source will catch `FirebaseException`. Without one shared mapping, each repository would translate error codes differently and some would leak raw codes.

## Assumptions
- Verified in the package sources: `FirebaseAuthException` and `FirebaseFunctionsException` both `extend FirebaseException` → one mapper covers all SDKs.
- Auth-specific codes (`wrong-password`, `user-disabled`…) → `ServerFailure` for now; E3 adds `AuthFailure` and maps them before falling back to this function.
- `unauthenticated` → `ServerFailure` for now; E3 decides (likely session-expired → `AuthFailure`).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| Map by `e.code` with a `switch` expression | Map by exception class / `e.plugin` | Codes are shared across SDKs (`unavailable`, `permission-denied`…); one table | Same code could mean slightly different things per SDK |
| Network group: `unavailable`, `network-request-failed`, `deadline-exceeded` | Only `unavailable` | Firestore/Functions use `unavailable`/`deadline-exceeded`, Auth uses `network-request-failed` | A slow server timeout shows as "offline" |
| `RateLimitFailure()` without `retryAfter` | Parse a time | Firebase codes don't carry a retry time; server-side limits (E3 callables) can return it later | UI shows a generic "try later" |
| Fallback `ServerFailure` | Throw / `UnexpectedFailure` | Decision 3 of sub-feature 02 | — |
| Top-level pure function | Class with `call` | Stateless mapping; no DI needed | — |

## Thinking steps
1. Confirm the class hierarchy before relying on it.
2. Group codes by what the **user** should see (offline / not allowed / missing / slow down / generic).
3. Default everything else to `ServerFailure` — never throw from the mapper.
4. Table-driven tests: one `test()` per code.

## Files
- `lib/core/firebase/firebase_failure_mapper.dart` — the mapping.
- `test/core/firebase/firebase_failure_mapper_test.dart` — 5 tests.

## Principles & patterns
- **Error boundary** — technical errors stop at the data layer; only `Failure` types go up.
- **Single source of truth** — one table for all repositories — overkill with one data source.
- **Total function** — every input has an output (wildcard `_`), so the mapper itself can't crash.

## Tests
- One generated `test()` per code (10 tests) from a code → expected `Failure` table — a wrong code is named in the failing test (changed after review: loops inside one test hid later failures).
- `unauthenticated` and `wrong-password` pinned to `ServerFailure` — E3 must change these tests on purpose when it adds `AuthFailure`.
- Not tested: real SDK exceptions — the mapper only reads `code`, which `FirebaseException(plugin:, code:)` reproduces exactly.

## Quiz
1. Why can one function handle Auth, Firestore and Functions errors?
2. What does the user see for `deadline-exceeded`, and is that the right message?
3. Why must the mapper never throw?
4. Where will `wrong-password` be handled in E3, and in what order relative to this mapper?
5. Why is the `_` case important in this `switch`?
