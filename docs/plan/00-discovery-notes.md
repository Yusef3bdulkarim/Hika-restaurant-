# Level 0 — Discovery notes

Q&A log while reading `docs/brief/`. Answers are saved here as they come, then turned into
`00-project-overview.md` → `00-architecture.md` → `00-roadmap.md`.

## Brief summary (what is already clear)
- Customer app for Hika (pizza/feteer, Egypt, 1 branch). Flutter Android + iOS. Arabic only, RTL, l10n keys from day 1 (`app_en.arb` empty).
- 33 screens / 7 design modules. Guest browsing; email+password account.
- Menu, item details (sizes/addons/flavors), combos, search, offers, cart, promo codes, wallet balance.
- Delivery (zone or GPS distance tier) or pickup. Cash or transfer (Vodafone Cash / InstaPay) + receipt upload & review. Scheduled orders (today/tomorrow, 30-min slots).
- Order tracking by stages (no map), history, reorder, rating. Loyalty: points → EGP balance, tiers, wallet.
- Admin-controlled values come from backend as `AppConfig` (no hard-coding).
- Offline/cache is required by the design (cached menu, cart persisted locally).
- Light + dark theme; tokens given in `02_design_system.md`.
- Out of scope v1: visible map, live courier tracking, English, Google/Apple login, invites, admin panel.

## Conflicts: brief vs project rules (CLAUDE.md)
| Brief says | Project rule |
|---|---|
| Bloc + Cubit | Bloc only |
| get_it + injectable | get_it only, manual registration |
| freezed + json_serializable | no code generation |
| dartz / fpdart Either | sealed `ApiResult` + `switch` |
| hive | (hive is unmaintained — decide in architecture) |

## Referenced files not in docs/brief
- Design Brief (Claude Design artifact), `DECISIONS.md`, `tokens.json`, strings file, SVG icons/illustrations/logo, menu data.

## Questions & answers
### Batch 1 (2026-11-27)
- **Backend:** Firebase.
- **Stack conflicts:** project rules win (Bloc only, manual get_it, no codegen, sealed `ApiResult` + `switch`).
- **Package id:** `com.hika.app`, flavors `dev` / `prod`.
- **Missing design files:** user asked which are actually needed → listed in chat (DECISIONS.md, strings, SVG assets, tokens.json/dark palette, menu data, per-screen states). Awaiting what exists.

### Batch 2 (2026-11-27)
- **Firebase project:** user's own account; Blaze plan approved.
- **Server logic:** Cloud Functions (TypeScript) in this repo, written by Claude — pricing, points, promo validation, order creation.
- **Admin ops v1:** Firebase console first; admin panel built later.
- **Dark mode:** not in v1 — light theme only.
- **Deadline:** none.
- **Git:** init with `main` + `develop`.

### Batch 3
- (pending)
