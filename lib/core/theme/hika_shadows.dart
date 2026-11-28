import 'package:flutter/painting.dart';

/// The only two shadows; everything else is flat with a border
/// (source: design `M1-Type`). Shadow color is textPrimary, not black.
abstract final class HikaShadows {
  /// Snackbar, sticky search. textPrimary at 12 %.
  static const elevation1 = [
    BoxShadow(color: Color(0x1F2B2523), offset: Offset(0, 4), blurRadius: 16),
  ];

  /// Bottom sheets, dialogs. textPrimary at 16 %.
  static const elevation2 = [
    BoxShadow(color: Color(0x292B2523), offset: Offset(0, -4), blurRadius: 24),
  ];
}
