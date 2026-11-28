import 'package:intl/intl.dart';

import '../l10n/generated/app_localizations.dart';

// `en` on purpose: Western digits and a comma for thousands on any device locale.
final _whole = NumberFormat('#,##0', 'en');
final _fraction = NumberFormat('#,##0.00', 'en');

/// `25000` → `25,000`, `13.5` → `13.50`. No decimals when [value] is whole.
String formatNumber(num value) =>
    (value % 1 == 0 ? _whole : _fraction).format(value);

/// 24h → 12h clock: `(21, 30)` → `9:30` (pm), `(1, 0)` → `1:00` (am).
/// Midnight is `12` with no minutes, as the design writes it («12 ص»).
({String clock, bool isAm}) formatClock(int hour, int minute) {
  if (hour < 0 || hour > 23) {
    throw ArgumentError.value(hour, 'hour', 'must be 0-23');
  }
  if (minute < 0 || minute > 59) {
    throw ArgumentError.value(minute, 'minute', 'must be 0-59');
  }
  final isAm = hour < 12;
  if (hour == 0 && minute == 0) return (clock: '12', isAm: isAm);
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return (clock: '$hour12:${minute.toString().padLeft(2, '0')}', isAm: isAm);
}

/// Display text built from l10n strings, e.g. `l10n.money(220)`.
extension HikaFormatters on AppLocalizations {
  /// `220` → `220 ج.م` (non-breaking space). [amount] is in pounds.
  String money(num amount) => moneyAmount(formatNumber(amount));

  /// `21:30` → `9:30 م` (non-breaking space). Uses the local hour and minute.
  String time(DateTime value) {
    final (:clock, :isAm) = formatClock(value.hour, value.minute);
    return isAm ? timeAm(clock) : timePm(clock);
  }
}
