/// Spacing scale, multiples of 4 (source: design `M1-Type`).
abstract final class HikaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 48.0;

  /// Side margin of every screen.
  static const screenMargin = lg;

  /// Every button, link and chip, even when it looks smaller.
  static const minTouchTarget = 48.0;

  /// Bottom nav height, without the safe area.
  static const bottomNavHeight = 64.0;

  /// Fixed bottom button bar height, without the safe area.
  static const fixedBottomBarHeight = 72.0;
}
