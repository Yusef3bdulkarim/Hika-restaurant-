# CLAUDE.md — Project

<!-- Global rules live in ~/.claude/CLAUDE.md — don't repeat them here.
Fill Project Context at the start of each app. -->

## Project Context
- **Client:** Hika — pizza & feteer restaurant, Egypt, single branch
- **App:** Hika customer app (Flutter, Android + iOS). Arabic only, full RTL, strings as l10n keys. Admin panel = later phase
- **API Base URL:** TBD (backend not decided)
- **API Docs:** TBD
- **Auth:** Email + password (guest browsing allowed). Provider TBD with backend
- **Brief:** `docs/brief/` (design brief source: Claude Design artifact)

---

## A) Flutter Rules

1. **State:** Bloc only — no Cubit, Riverpod, Provider or GetX
   - Events and states are `sealed class`es; Blocs depend only on use cases
   - Use `bloc_concurrency` transformers when event concurrency matters (e.g. `droppable` on submit)
   - `setState` only for local UI state, in the smallest widget possible
2. **No code generation:** no Freezed, build_runner, json_serializable, Retrofit or mockito
   - Use `sealed class`, `switch` expressions and records. Handle `ApiResult` with `switch`, never `.when()`
3. **Domain purity:** no `package:flutter/...` import anywhere under `domain/`
4. **Structure:** `lib/features/{feature}/data|domain|presentation`, shared code in `lib/core/`.
   Scaffolding patterns are in the `/flutter-feature` skill
5. **Errors:** data layer maps exceptions to typed `Failure`; repositories and use cases return
   `ApiResult<T>`; presentation maps failures to messages and states.
   `fromJson` fails loudly on missing required fields — no `?? ''` defaults
6. **DI:** `get_it`, registered in `lib/core/di/`. Blocs as `registerFactory`
7. **Build discipline:** `const` wherever possible; never create controllers or focus nodes in `build()`;
   dispose them; small composed widgets; `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state
8. **Tests:** `mocktail` + `bloc_test`; `test/` mirrors `lib/`; Arrange-Act-Assert;
   `group` per class/method; names read `should <result> when <condition>`

---

## B) Workflow

**Planning (Opus, Plan Mode, one chat each):**
- Project discovery (once, new project): read the user's project files in `docs/brief/`, ask
  questions in grouped batches until the picture is complete, saving answers as you go →
  `docs/plan/00-project-overview.md` (goal, users/roles, features, screens, APIs, constraints,
  open questions) → `docs/plan/00-architecture.md` (stack & package decisions with reasons) →
  `docs/plan/00-roadmap.md` (epics in order, dependencies, milestones). User approves each file
- Epic breakdown → `docs/plan/{epic}/00-breakdown.md`
- Sub-feature plan → `docs/plan/{epic}/NN-{name}.md` from `docs/templates/plan-template.md`.
  Small tasks (< ~150 diff lines), ordered domain → data → presentation → wiring

**Per task (Sonnet by default, Opus for sensitive or complex tasks):**
1. Implement only what the task says, touching only its listed files. Tests follow the current learning stage
2. Run `dart analyze` and `flutter test`
3. Run `/flutter-code-review`
4. Write the Handoff → `docs/learning/{epic}-NN-TT-{task}.md` from `docs/templates/handoff-template.md`
5. Update `docs/progress.md`
6. Give the git instructions for the current Git stage

**Task is done when:** only planned files changed · analyze clean · tests written and all passing ·
null/empty/loading/error covered · no print, dead code, unused imports or TODO ·
Handoff + progress updated · user reviewed and committed

**Sub-feature is done when:** all tasks done · `@code-reviewer` passes on `git diff develop...HEAD`
(`opus` for auth/security, `sonnet` otherwise) · user ran the flow manually · PR to `develop`.
`@code-reviewer` is mandatory before merging `develop` → `main`.

**Bugs:** use `@debugger`; it writes the root cause into the Handoff.

---

## C) Learning Mode

The user is growing to senior level. Teaching happens through written Handoffs (explained later by
Gemini), not long chat messages.

- Handoff = short bullets: assumptions · decisions + alternatives + why + trade-off · thinking steps ·
  principles/patterns used and when they would be overkill · 3-5 quiz questions
- Big architectural decisions: ask the user what they would do first, then compare
- Stages are tracked in `docs/progress.md`; follow them:

| Stage | Tests | Bloc | Git |
|---|---|---|---|
| 1 | I write all tests | I write the whole Bloc | Full commands + one-line meaning each |
| 2 | I write test names with empty bodies; user fills them | I design events/states; user writes handlers | Commit message + hint only |
| 3 | User writes all; I review missing cases | User designs and writes; I review | "Commit now" only |

- I advance a stage when the user is ready; the user can ask to stay longer

---

## D) Git
- `main` (releases) ← `develop` ← `feat/{name}` (branch from `develop`, PR back to `develop`)
- One commit per task; Conventional Commits `type(scope): summary`; no AI attribution
- The user runs git. If the user says "كمّل", I take over

## E) Context Handoff
On 60% context or `handoff`: update `docs/progress.md` (current task, next task, open decisions,
known issues) and give the starter message: "كمّل من docs/progress.md — التاسك الجاية: ..."
