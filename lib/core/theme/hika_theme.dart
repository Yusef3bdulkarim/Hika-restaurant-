import 'package:flutter/material.dart';

import 'hika_colors.dart';
import 'hika_text_styles.dart';

/// Builds the app `ThemeData` from the design tokens (light only in v1).
abstract final class HikaTheme {
  static ThemeData light() {
    const colors = HikaColors.light;
    const styles = HikaTextStyles.standard;

    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.primaryTint,
        onPrimaryContainer: colors.primaryDeep,
        secondary: colors.primary,
        onSecondary: colors.onPrimary,
        error: colors.errorFg,
        onError: colors.onPrimary,
        errorContainer: colors.errorBg,
        onErrorContainer: colors.errorFg,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        onSurfaceVariant: colors.textSecondary,
        surfaceContainerHighest: colors.surfaceMuted,
        outline: colors.borderStrong,
        outlineVariant: colors.border,
        scrim: colors.scrim,
      ),
      scaffoldBackgroundColor: colors.background,
      textTheme: _textTheme(styles, colors.textPrimary),
      // Text on primary-colored surfaces; would fall back to Roboto otherwise.
      primaryTextTheme: _textTheme(styles, colors.onPrimary),
      extensions: const [colors, styles],
    );
  }

  /// Fills every Material slot so no widget falls back to Roboto, and
  /// zeroes letter spacing that Material's type geometry would add.
  static TextTheme _textTheme(HikaTextStyles s, Color color) {
    TextStyle on(TextStyle style) =>
        style.copyWith(color: color, letterSpacing: 0);

    return TextTheme(
      displayLarge: on(s.display),
      displayMedium: on(s.display),
      displaySmall: on(s.display),
      headlineLarge: on(s.h1),
      headlineMedium: on(s.h1),
      headlineSmall: on(s.h1),
      titleLarge: on(s.h2),
      titleMedium: on(s.title),
      titleSmall: on(s.label),
      bodyLarge: on(s.body),
      bodyMedium: on(s.body),
      bodySmall: on(s.caption),
      labelLarge: on(s.bodyStrong),
      labelMedium: on(s.label),
      labelSmall: on(s.micro),
    );
  }
}
