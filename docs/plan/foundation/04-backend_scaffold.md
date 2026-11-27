# Foundation / 04 — Backend scaffold

- **Goal:** a Firebase backend skeleton in this repo — project aliases, deny-all Security Rules, Emulator Suite, a TypeScript Functions package and a Rules test harness — so every later epic adds its backend slice with tests.
- **Branch:** `feat/backend-scaffold` (from `develop`)
- **API:** none (no functions exported yet)
- **Out of scope:** any real Function, Firestore schema or Rules beyond deny-all · deploying anything (dev project is not on Blaze; Functions deploy needs Blaze) · app→Emulator switch (E2) · seed scripts (E2) · CI.
- **Prerequisite (user):** **JDK 21+** — `firebase-tools` 15.11 refuses Java < 21 for the emulators (`MIN_SUPPORTED_JAVA_MAJOR_VERSION = 21`); installed today: Java 17.
- **Decision points for the user:** none big — defaults below, say if you disagree:
  1. **One Node package** in `functions/` holds Functions code **and** Rules tests (dev dependencies are not deployed). Alternative: separate `rules-tests/` package — more files, no gain now.
  2. **Node 24** runtime (`engines.node = "24"`) — GA in Cloud Functions (deprecation 2028-04), same as local Node.
  3. **Vitest** (breakdown decision 4) + `@firebase/rules-unit-testing`; **ESLint flat config** + `typescript-eslint` (instead of the old `.eslintrc` + google style that `firebase init` generates).
- **Assumptions:** package versions = latest stable at `npm install` time; `firebase init` is **not** used (it writes old templates and prompts) — files written by hand.

---

## 01 — Firebase project config + deny-all Rules
- **Layer:** wiring (backend)
- **Goal:** CLI knows both projects; Firestore and Storage deny everything until an epic opens a path.
- **Touch:** create `.firebaserc` (`default` + `dev` → `hika-dev-3fb2e`, `prod` → `hika-279b8`), `firestore.rules` (`allow read, write: if false;`), `firestore.indexes.json` (empty), `storage.rules` (deny all); edit `firebase.json` (add `firestore`, `storage`, `functions` (`source: functions`, predeploy build), `emulators` — auth 9099, firestore 8080, functions 5001, storage 9199, UI on; keep the existing `flutter` section untouched).
- **Do NOT touch:** `lib/`, `android/`, the `flutter` section of `firebase.json`.
- **Done when:** `firebase emulators:start --only firestore,storage` starts and loads both rules files (Java 21).
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — Functions TypeScript package
- **Layer:** wiring (backend)
- **Goal:** compiling, linted TS package ready for the first callable (E5).
- **Touch:** create `functions/package.json` (`engines.node: "24"`, `main: lib/index.js`; deps `firebase-functions`, `firebase-admin`; dev `typescript`, `eslint`, `typescript-eslint`; scripts `build`, `lint`), `functions/tsconfig.json` (`strict: true`; in 04-03 split into `tsconfig.json` for editor/lint/tests + `tsconfig.build.json` with `outDir: lib`), `functions/eslint.config.mjs`, `functions/src/index.ts` (initializes Admin SDK only — no functions), `functions/.gitignore` (`lib/`, `node_modules/`); root `.gitignore` gets Firebase debug logs (`*-debug.log`, `.firebase/`).
- **Do NOT touch:** rules files, `lib/` (Flutter).
- **Done when:** `npm run build` and `npm run lint` clean; `firebase emulators:start --only functions` loads the package with 0 functions and no error.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 03 — Rules test harness (deny-all tests)
- **Layer:** tests (backend)
- **Goal:** Rules are tested on the emulator from day one; every future Rules change ships with tests.
- **Touch:** `functions/package.json` (dev `vitest`, `@firebase/rules-unit-testing`, `firebase`; script `test:rules` = `firebase emulators:exec --only firestore,storage "node scripts/vitest.mjs run test/rules"` — plain `test` deferred to E5; wrapper = Windows drive-letter fix), create `functions/vitest.config.ts`, `functions/test/rules/firestore.rules.test.ts`, `functions/test/rules/storage.rules.test.ts`.
- **Tests:**
  - Firestore — `should deny read when user is unauthenticated` · `should deny read when user is authenticated` · `should deny write when user is authenticated`.
  - Storage — `should deny upload when user is authenticated` · `should deny read when user is unauthenticated`.
  - Added after review: Firestore deny write unauthenticated + deny list authenticated; Storage deny upload unauthenticated + deny read authenticated (9 total).
- **Do NOT touch:** rules files (tests only prove the current deny-all).
- **Done when:** `npm run test:rules` passes from `functions/`; changing a rule to `if true` makes tests fail (checked once, reverted).
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

---

## After all tasks
- `@code-reviewer` with **`opus`** (roadmap rule: every Rules change) on `git diff develop...feat/backend-scaffold` → PR to `develop`.
- Manual check by user: `cd functions && npm run test:rules` passes on their machine.
