# Hika — Roadmap

_Status: **approved** · 2026-11-27_
Based on `00-project-overview.md` + `00-architecture.md` (both approved).
Each epic ships **app + its backend slice** (Firestore schema, Rules + tests, Functions + tests, seed data).
Each epic gets its own breakdown: `docs/plan/{epic}/00-breakdown.md`.

## Epics in order

| # | Epic | Contents | Depends on |
|---|---|---|---|
| E0 | `foundation` | Flavors dev/prod, Firebase config for `hika-dev` + `Hika`, `functions/` TS scaffold + Emulator, `ApiResult` / `Failure` / `UseCase`, get_it, go_router skeleton, l10n (ARB), shared_preferences wrapper, analysis options | — |
| E1 | `design_system` | Tokens → `core/theme` (light only), fonts, SVG icons / illustrations / logo pulled from the Design artifact, all `core/widgets` components + state widgets, `HikaStamp`, `DesignGalleryPage` (dev only) | E0 |
| E2 | `app_shell` | `cloud_firestore` + dev app→Emulator switch, `AppConfig` (Firestore `config/app` + seed + `AppConfigBloc`), `ConnectivityBloc`, 5-tab shell (`StatefulShellRoute`), splash + routing logic, welcome (direction ج, text 1), force update / maintenance gates | E1 |
| E3 | `auth` | Email/password, Google, Apple; register, login (lock 10 → 5 min), forgot password (limits), guest login sheet (5 variants), `AuthBloc`, user doc creation, session-expired sheet | E2 |
| E4 | `menu` | Menu schema + seed (test data from brief module 4), menu tabs, item details (sizes / addons / flavors / notes / qty, live price), combos, sold-out, search (local, recent + popular), offers, **Home v1** (banners, categories, offers, best sellers, new) | E2 (E3 for favorites heart → guest sheet) |
| E5 | `cart` | `CartBloc` (global, persisted), cart screen, piece counter badge, edit from cart, promo code (callable validate), use balance toggle, price summary (server preview), min order | E4, E3 |
| E6 | `address` | Zones + distance tiers (config), address form + zone sheet + location permission, GPS via `geolocator`, fee calc (distance priority, out-of-range), my addresses (max 5, callable save/delete) | E3, E2 |
| E7 | `checkout_payment` | Checkout (delivery/pickup, time slots today/tomorrow, payment method), `placeOrder` callable (server pricing + points preview), cash flow, transfer flow (hold 1h, receipt upload to Storage, 3 attempts, hold extension), confirmation + stamp, **Telegram**: new order, receipt uploaded, hold expired | E5, E6 |
| E8 | `orders` | Tracking (snapshots, stages, ETA, late / review-overdue jobs), my orders, order details (invoice, refund), cancel rules, reorder (incl. partial), rating sheet (push +20 min, 12h window), receipt rejected flow, order push notifications, **Telegram**: cancelled, bad rating, receipt overdue, late, scheduled reminder, daily summary, sold-out; **Home v2**: active order card, previous order | E7 |
| E9 | `wallet` | Points on delivery (round down to whole pound), tiers (lifetime, never drop), balance expiry (90d) + 10-day alert, system paused, wallet screen + history, **Home v3**: loyalty card | E8 |
| E10 | `account` | Account tab, edit profile, settings (notification switches), change password, delete account (3 steps, callable), favorites screen, help (call / WhatsApp / FAQ), about (hours, social, delivery areas sheet) | E3, E6, E4 |
| E11 | `notifications_release` | Notifications list (by day, guest/empty), permission sheet, deep links from push, global states polish (unexpected error, global offline), full states audit, Play Store build + internal testing → production | all |

## Milestones
| Milestone | After | What you can do |
|---|---|---|
| **M1 — Skeleton** | E2 | App opens on `hika-dev`, design gallery, splash → welcome → tabs |
| **M2 — Browse** | E5 | Guest/customer browses the menu, builds a cart, applies a code |
| **M3 — First order** | E7 | Real end-to-end order (cash + transfer) on `hika-dev`; staff get Telegram |
| **M4 — Full lifecycle** | E9 | Track, cancel, rate, earn points, wallet |
| **M5 — Release** | E11 | Play Store production (Android). iOS after (Mac / cloud CI) |

## Notes
- Admin work in v1 = Firebase console + seed scripts (`functions/scripts/`, Admin SDK). Separate admin panel later.
- Real restaurant data replaces seed data before M5 (open question in overview).
- Design screens for each epic are pulled from the Design artifact into `docs/brief/design/` at breakdown time.
- `@code-reviewer` with `opus` is mandatory for E3 (auth), E5/E7 (money), and every Rules change.
