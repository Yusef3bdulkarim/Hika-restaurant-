# foundation-04-01 — Firebase project config + deny-all Rules

<!-- Written by Claude. Short bullets only. Gemini explains ONLY what is written here + the diff. -->

## Problem
- The Firebase CLI did not know our two projects, and there were no Security Rules in the repo. Without Rules files under version control, whatever is in the console is the "truth" — untested and unreviewed.

## Assumptions
- `firebase init` not used (old templates, interactive) — files written by hand.
- `firebase.json` was rewritten as formatted JSON; the `flutter` section values are unchanged (only line breaks).
- `functions` entry points to `functions/`, which is created in 04-02 (emulators started with `--only firestore,storage` here).

## Decisions
| Decision | Alternatives considered | Why this one | Trade-off |
|---|---|---|---|
| `.firebaserc` default = **dev** | default = prod | A forgotten `--project` flag can never touch the real restaurant | Prod deploy must say `-P prod` explicitly |
| Deny-all Firestore + Storage Rules | Test-mode rules (`if true` until date) | Secure by default; each epic opens only its paths, with tests (architecture D1) | Nothing works from the app until opened — intended |
| `rules_version = '2'` | v1 | Required for recursive wildcards `{document=**}` in collection groups; current standard | — |
| Emulator ports = Firebase defaults (9099/8080/5001/9199) | Custom ports | Matches docs/tools; fewer surprises | Clash if another project's emulators run at the same time |
| `singleProjectMode: true` | Off | Emulator warns when the app uses another project id — catches dev/prod mix-ups | — |
| Functions `predeploy` runs lint + build | No predeploy | A broken or unlinted function can't be deployed | Slower deploy |

## Thinking steps
1. Name projects once (`.firebaserc`) so commands use aliases, not raw ids.
2. Start from "nothing allowed" — safest default.
3. Register rules, indexes, functions and emulators in `firebase.json`, keeping the FlutterFire section.
4. Start Firestore + Storage emulators (Java 25) → rules load, script runs, clean shutdown.

## Files
- `.firebaserc` — project aliases.
- `firebase.json` — rules, indexes, functions source, emulator ports (+ existing FlutterFire section).
- `firestore.rules` / `storage.rules` — deny-all.
- `firestore.indexes.json` — empty, filled when queries need composite indexes.

## Principles & patterns
- **Secure by default / least privilege** — open paths one by one — overkill for a throwaway prototype with no real users.
- **Infrastructure as code** — Rules live in git, reviewed and tested like app code.

## Tests
- No automated tests in this task — deny-all tests come in 04-03. Verified by `firebase emulators:exec --only firestore,storage` (rules loaded, exit 0).
- Known noise: Java 25 prints a `sun.misc.Unsafe` deprecation warning from the Storage rules runtime — harmless.

## Quiz
1. Why is the default alias `dev` and not `prod`?
2. What does `{document=**}` match, and why does it need `rules_version = '2'`?
3. Why are deny-all Rules safe even though the app already has Firebase config with API keys?
4. What would `singleProjectMode` catch?
5. What runs before a Functions deploy, and why?
