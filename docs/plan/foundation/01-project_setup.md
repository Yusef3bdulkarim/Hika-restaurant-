# Foundation / 01 — Project setup

- **Goal:** app runs as two Android flavors (`dev` / `prod`) with Arabic l10n, forced RTL and strict lints — no counter demo left.
- **Branch:** `feat/project-setup` (from `develop`)
- **API:** none
- **Out of scope:** Firebase (03), DI / core contracts (02), router (05), theme / fonts / app icon (E1), iOS flavors (needs Mac).
- **Decision points for the user:** none — breakdown decisions 1 + 3 apply (dev id `com.hika.app.dev`, hand-picked lints).
- **Assumptions:** launcher names «هيكا» (prod) and «هيكا Dev» (dev); `flutter gen-l10n` output is committed (it is Flutter's built-in tool, not build_runner).

---

## 01 — Strict lints
- **Layer:** wiring
- **Goal:** turn on stricter analysis before writing any code.
- **Touch:** `analysis_options.yaml`
- **Do NOT touch:** `pubspec.yaml` (no new lint package)
- **Content:** `analyzer.language`: `strict-casts`, `strict-inference`, `strict-raw-types`; exclude `lib/core/l10n/generated/**`. Rules (only those not already in `flutter_lints`): `prefer_single_quotes`, `prefer_final_locals`, `prefer_final_in_for_each`, `always_declare_return_types`, `avoid_dynamic_calls`, `unawaited_futures`, `directives_ordering`, `prefer_const_constructors`, `prefer_const_declarations`, `avoid_redundant_argument_values`, `use_super_parameters`, `require_trailing_commas` only if it does not fight `dart format`.
- **Done when:** `dart analyze` clean (fix the demo code or leave it for task 02 if it is deleted there).
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 02 — Flavor + entrypoints
- **Layer:** wiring
- **Goal:** `main_dev.dart` / `main_prod.dart` both start the app through one `bootstrap()`.
- **Touch:** create `lib/core/config/flavor.dart` (`enum Flavor { dev, prod }`), `lib/bootstrap.dart` (`Future<void> bootstrap(Flavor flavor)`: `WidgetsFlutterBinding.ensureInitialized()` → `runApp(App(flavor: flavor))`), `lib/main_dev.dart`, `lib/main_prod.dart`, `lib/app.dart` (minimal `MaterialApp`, placeholder `Scaffold`); delete `lib/main.dart`, `test/widget_test.dart` (counter demo).
- **Do NOT touch:** `android/`, `pubspec.yaml`
- **Done when:** analyze clean; `flutter run -t lib/main_dev.dart` shows the placeholder (before flavors exist, without `--flavor`).
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 03 — Android flavors + package id
- **Layer:** wiring
- **Goal:** `com.hika.app` (prod) and `com.hika.app.dev` (dev) installable side by side with their own names.
- **Touch:** `android/app/build.gradle.kts` (`namespace` + `applicationId` = `com.hika.app`; `flavorDimensions += "env"`; `productFlavors` `dev` with `applicationIdSuffix = ".dev"` + `resValue("string", "app_name", "هيكا Dev")`, `prod` with `resValue(... "هيكا")`), `android/app/src/main/AndroidManifest.xml` (`android:label="@string/app_name"`), move `MainActivity.kt` → `android/app/src/main/kotlin/com/hika/app/MainActivity.kt` (package `com.hika.app`), delete old `com/example/` folder.
- **Do NOT touch:** release signing (Play release in E11), `ios/`
- **Done when:** `flutter build apk --debug --flavor dev -t lib/main_dev.dart` and `--flavor prod -t lib/main_prod.dart` both succeed; both apps install on one device with the right names.
- **Model:** Sonnet · **Owner:** Claude · **Status:** done

## 04 — l10n (Arabic) + forced RTL
- **Layer:** wiring + presentation
- **Goal:** all text comes from ARB keys; app always runs in `ar` (RTL).
- **Touch:** `pubspec.yaml` (`flutter_localizations` SDK, `intl` via `flutter pub add`, `flutter: generate: true`), create `l10n.yaml` (`arb-dir: lib/core/l10n`, `template-arb-file: app_ar.arb`, `output-dir: lib/core/l10n/generated`, `nullable-getter: false`), `lib/core/l10n/app_ar.arb` (`appTitle` = «هيكا», `placeholderMessage`), `lib/core/l10n/app_en.arb` (`{"@@locale": "en"}` only), generated files, `lib/app.dart` (`locale: Locale('ar')`, delegates, `supportedLocales`, `onGenerateTitle`, placeholder text from l10n); create `test/app_test.dart`.
- **Do NOT touch:** theme / fonts (E1)
- **Tests:** `should render Arabic placeholder text when app starts` · `should lay out right-to-left when app starts` (`Directionality.of` == `TextDirection.rtl`).
- **Done when:** analyze clean; tests pass; no hard-coded string in `lib/` outside ARB.
- **Model:** Sonnet · **Owner:** Claude · **Status:** todo

---

## After all tasks
- `@code-reviewer` (`sonnet`) on `git diff develop...feat/project-setup` → PR to `develop`.
- Manual check by user: both flavors installed side by side, Arabic placeholder, RTL.
