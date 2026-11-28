import 'package:flutter/animation.dart';

/// Durations and curves (source: design `M1-Type`).
/// With reduced motion on, components fade only.
abstract final class HikaMotion {
  /// Press.
  static const fast = Duration(milliseconds: 120);

  /// Chip, toggle, price change, cart counter.
  static const base = Duration(milliseconds: 200);

  /// Sheets and snackbar in.
  static const slowIn = Duration(milliseconds: 300);

  /// Sheets and snackbar out.
  static const slowOut = Duration(milliseconds: 200);

  /// Stamp, item flying to the cart.
  static const moment = Duration(milliseconds: 450);

  /// Scale of a pressed element.
  static const pressedScale = 0.97;

  /// Light spring with a small overshoot, used with [moment].
  static const spring = Cubic(0.34, 1.56, 0.64, 1);
}
