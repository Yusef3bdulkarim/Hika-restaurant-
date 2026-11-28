# Hika — Project Overview

_Status: **approved** · 2026-11-27_
Sources: `docs/brief/*`, Claude Design artifacts (links in `00-discovery-notes.md`), `docs/brief/design/project/HO-00-Decisions`.

## 1. Goal
Customer mobile app for **Hika** (pizza & feteer, Egypt, one branch) to browse the menu, order
delivery or pickup, pay cash or by transfer, track orders and earn loyalty points.

## 2. Platform & constraints
- Flutter. **Android first**; iOS later (needs Mac or cloud CI). Store accounts exist.
- Package id `com.hika.app`, flavors `dev` / `prod`.
- **Arabic only, full RTL**, neutral simplified Fusha. All text as l10n keys; `app_en.arb` kept empty for later.
- **Light theme only** (no dark mode in v1). Strict design tokens — no color/spacing/radius outside them.
- Numbers always Western digits; currency `220 ج.م` (non-breaking space); 12h time `9:30 م`.
- Supports font scale 130%, min touch target 48, reduced motion → fade only.
- Offline is part of the design: cached menu, cart persisted locally, offline states on every data screen.
- No deadline.

## 3. Users & roles
| Role | Can |
|---|---|
| Guest | Browse menu, offers, search, build a cart. Any account action → guest login sheet (5 variants) |
| Customer | Everything: order, pay, track, rate, wallet, addresses, favorites, notifications, settings |
| Restaurant owner / staff (outside app) | Review receipts, update order status, refunds, edit menu/config — via **Firebase console** in v1, separate admin panel later. Gets **Telegram alerts** for new orders and receipts |

## 4. Features (v1)
- **Onboarding:** splash with routing (first launch / guest / session / deep link), welcome — direction **ج · تايبوجرافي**, text option **1** (M2-02-Directions).
- **Auth:** **Google Sign-In + Sign in with Apple** + email & password. Google/Apple buttons and their states are not in the design — built by Claude from the existing tokens/components. Email flow — register, login, forgot password (link, valid 1h, resend after 60s, max 5/h; never reveals if email exists), change password, logout, delete account (3 steps). Lock 5 min after 10 wrong attempts. Password ≥ 8, no symbol rules. No OTP. Guest cart replaces old account cart after login.
- **Menu:** categories, item details (sizes, addons, flavors with counters — same flavor allowed twice, max per item), notes, quantity; combos with swappable slots (price diff); sold-out items ("نفد اليوم، ويعود غداً") + 3 similar items.
- **Home:** active order card (closest to delivery, "+1 more", stays 1h after delivery with rate CTA), loyalty card, banners (max 5, auto 5s), categories, previous order, offers, best sellers, new. One operational alert at a time: closed → last call → kitchen busy.
- **Search:** on the locally cached menu; recent + popular searches; live from 2 chars.
- **Offers:** promo codes, combos, discounted items. "Use code" works offline; validated in cart.
- **Cart:** lines (addons inline, price inclusive), one promo code (new replaces old), use wallet balance (off by default, min 15 ج.م), clear price summary, min order per zone, sold-out lines faded and excluded. **Cart badge counts pieces**, not lines.
- **Address:** zone + place description + optional GPS + optional details; max 5 (admin value); warning if GPS > 3 km from the zone (does not block saving).
- **Delivery fee:** by GPS distance tier if location shared (priority), else by zone. **Out of range** (past last tier): order continues, cash only, no fee shown, restaurant agrees fee by phone. Changing address re-prices fee/min/code with a snackbar. Free delivery: admin toggle, threshold after promo, off at start.
- **Checkout:** delivery / pickup, address, time (now or scheduled today/tomorrow, 30-min slots), contact, payment method, notes, summary. Price/availability changes at confirm are highlighted.
- **Payment:** cash, or transfer (Vodafone Cash / InstaPay): order held 1h (admin), upload one receipt image at a time, 3 attempts, hold extends while uploading, review time `{minutes}` (admin), rejected receipt → new upload. Confirmation screen with stamp animation.
- **Orders:** tracking by stages (no map) + ETA; auto "late" 15 min after ETA; "review taking longer" after 15 min; my orders (current/past), invoice details, reorder (incl. partial), rating (push 20 min after delivery, available 12h; pickup hides courier questions; bad rating → WhatsApp).
- **Cancellation rules:** cash — in app until preparation starts. Transfer — in app only before receipt upload. After receipt upload or after preparation starts → call the restaurant only. Restaurant cancel reason: free text ≤ 150.
- **Refund:** cash from the branch only, ready within 24h.
- **Wallet & loyalty:** points → EGP balance; tiers bronze / silver / gold computed on all paid orders since signup (after code & balance, without delivery), never drops; points earned on subtotal before discounts, without delivery, **rounded down to the whole pound** (445 × 3% = 13.35 → 13 ج.م = 260 points); balance expires 90 days, alert 10 days before; "system paused" state. All rates/limits from admin.
- **Account:** profile, addresses, favorites (items only, not combos), settings (notification switches), help (call / WhatsApp / FAQ), about (hours, address, social, delivery areas).
- **Notifications:** in-app list grouped by day + FCM push with deep links; permission sheet.
- **Global states:** force update, optional update, maintenance, global offline, unexpected error, session expired sheet titled «تسجيل الدخول مطلوب» (session never expires on its own; cart kept).

## 5. Screens
33 screens in 7 design modules + global states (M2–M8 in the Design artifact). Every screen has a
states table (loading / skeleton / empty / offline-cached / offline-empty / error / refreshing…) that
must be covered. Feature ↔ screen map: `docs/brief/03_features_roadmap.md`.

## 6. Backend & integrations
- **Firebase** project `Hika` (user's account, Blaze plan + budget alert).
  - Auth (email/password, Google, Apple), Firestore, Storage (receipt images), FCM, Cloud Functions (**TypeScript, in this repo**).
- **Server-side (trusted) logic in Cloud Functions:** price calculation, promo validation, points & tiers, order creation, order status rules, holds/timeouts, staff Telegram alerts, push notifications.
- **Admin-controlled config** (`AppConfig`, never hard-coded): points rates per tier, point value, tier thresholds, balance expiry (90d), min balance use (15), zones + fees + times, distance tiers, min order per zone, free delivery, promo codes, opening hours (11:00 ص – 3:00 ص), open/closed, maintenance message, min supported version, transfer hold (1h), review minutes, banners, offers, FAQ, about, max addresses (5), admin text lengths.
- **Telegram bot** → staff group: new order · receipt uploaded · customer cancelled · bad rating ·
  receipt waiting longer than `{minutes}` · order 15 min past ETA · scheduled order 45 min before its slot ·
  hold expired without receipt · item marked sold out · daily summary at closing (orders, revenue, cash vs transfer, cancellations).
- Location: GPS only when saving an address; never tracked after.

## 7. Data
- Test/seed data until the restaurant sends real data: menu (from brief, module 4), zones, distance tiers, payment account names/numbers, hours, contacts, social links, FAQ, legal text.

## 8. Out of scope (v1)
Visible map · live courier tracking · English UI · invite friends · admin panel
(separate project later) · dark mode · iOS release (later).

## 9. Open questions
1. **Real data from restaurant** (using test data meanwhile): zones/fees/tiers & max range, branch address/hours/phone/WhatsApp, item descriptions & photos, drink prices, Vodafone Cash / InstaPay names + logo usage, legal text, FAQ, about.
