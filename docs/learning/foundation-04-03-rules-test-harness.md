# foundation-04-03 — Rules test harness (deny-all tests)

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- Security Rules are the app's real security layer (architecture D1). Every Rules change must be proven by tests on the emulator, starting with the deny-all baseline.

## Assumptions
- Only `test:rules` script now; a plain `test` script (unit tests) comes with the first function in E5 — no script with nothing to run.
- Tests use the project id from `GCLOUD_PROJECT` (set by `firebase emulators:exec` = `.firebaserc` default) — matches `singleProjectMode`.

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `@firebase/rules-unit-testing` + Vitest, run inside `firebase emulators:exec` | Start emulators by hand, then run tests | One command starts emulators, runs tests, stops everything | ~20 s startup per run |
| npm `overrides`: `@firebase/firestore` → `@grpc/grpc-js ^1.14.7` | Ignore audit; `npm audit fix --force` | `firebase` 13.4.0 pins `grpc-js` 1.9.16 (2 high advisories: GHSA-m9gg-hp2v-232j, GHSA-f596-whhp-79r4). Override → 0 vulnerabilities, tests pass | Override must be removed when `firebase` ships a fixed version |
| `tsconfig.json` (editor/lint/tests, `noEmit`, `skipLibCheck`) + `tsconfig.build.json` (`src` only, full lib check) | One tsconfig | Type-aware ESLint needs test files in a project; build must not compile tests | Two configs |
| `skipLibCheck` for tests only | Add `dom` + `esnext.temporal` libs | Firebase **client** `.d.ts` files need browser + Temporal types; we don't want those types available to our code | Third-party `.d.ts` errors are hidden in tests (build still checks fully) |
| `scripts/vitest.mjs` wrapper | Always open the project as `F:\` | Vitest bug: cwd with lower-case drive letter (`f:\`, how VS Code opens it) loads Vitest twice → "failed to find the runner". Setting `root` in config did not help; running from `realpathSync.native` (`F:\`) does | One small extra script |
| `fileParallelism: false` | Parallel files | Both files share one emulator; `clearFirestore` in one file could race the other | Slower (only matters with many files) |
| `Promise.resolve(uploadTask)` | Cast | `UploadTask` is thenable, not a `Promise`; `assertFails` needs a Promise | — |

## Thinking steps
1. Install test packages → `npm audit` = 5 high → traced to `grpc-js` 1.9.16 via `@firebase/firestore` → override + clean reinstall → 0.
2. Write a shared `createTestEnv()` that loads the real rules files from the repo root.
3. Type check failed (Temporal, ServiceWorkerRegistration from client SDK types) → tests-only `skipLibCheck`; build keeps full checks.
4. Runner failed only from `f:\` (reproduced: `F:\` works) → wrapper re-runs Vitest from the real path.
5. 5/5 pass. **Mutation check:** set both rules to `if true` → 5/5 fail → restored (no diff).

## Files
- `functions/test/rules/test-env.ts` — creates the test environment from `firestore.rules` / `storage.rules`.
- `functions/test/rules/firestore.rules.test.ts` (5) / `storage.rules.test.ts` (4).
- `functions/vitest.config.ts` — node env, sequential files, timeout.
- `functions/scripts/vitest.mjs` — Windows drive-letter workaround.
- `functions/tsconfig.json` / `tsconfig.build.json` — split configs.
- `functions/package.json` / `package-lock.json` — test deps, `overrides`, `build` + `test:rules` scripts.

## Principles & patterns
- **Test the guard, not the guarded** — Rules tests run real rules on the real emulator engine.
- **Mutation check** — break the code on purpose; a test that still passes protects nothing.
- **Fix supply-chain findings, don't ignore them** — even for dev-only deps.

## Tests
- Firestore: deny read unauthenticated · deny read authenticated · deny write authenticated · deny write unauthenticated · deny list authenticated.
- Storage: deny upload authenticated · deny read unauthenticated · deny upload unauthenticated · deny read authenticated.
- Review (opus) added the opposite-auth-state cases — when rules start allowing paths, bugs hide in the auth state nobody tested. 9 tests total.
- Run: `cd functions && npm run test:rules` (needs Java 21+).

## Quiz
1. Why run tests inside `emulators:exec` instead of against the real project?
2. What does the npm `overrides` entry do, and when should it be removed?
3. Why is `skipLibCheck` on for tests but off for the build?
4. What was the root cause of "Vitest failed to find the runner", and how did we prove it?
5. What did the mutation check prove that "5 passed" alone did not?
