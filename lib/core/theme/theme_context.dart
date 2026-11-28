import 'package:flutter/material.dart';

import 'hika_colors.dart';
import 'hika_text_styles.dart';

/// `context.colors.primary`, `context.textStyles.body`.
/// Throws if the widget is not under `HikaTheme` — a wiring bug, not a runtime case.
extension HikaThemeContext on BuildContext {
  HikaColors get colors => Theme.of(this).extension<HikaColors>()!;

  HikaTextStyles get textStyles => Theme.of(this).extension<HikaTextStyles>()!;
}
