import 'package:intl/intl.dart';

import '../l10n/generated/app_localizations.dart';

// `en` on purpose: Western digits and a comma for thousands on any device locale.
final _whole = NumberFormat('#,##0', 'en');
final _fraction = NumberFormat('#,##0.00', 'en');

/// `25000` → `25,000`, `13.5` → `13.50`. No decimals when [value] is whole.
String formatNumber(num value) =>
    (value % 1 == 0 ? _whole : _fraction).format(value);

/// Display text built from l10n strings, e.g. `l10n.money(220)`.
extension HikaFormatters on AppLocalizations {
  /// `220` → `220 ج.م` (non-breaking space). [amount] is in pounds.
  String money(num amount) => moneyAmount(formatNumber(amount));
}
