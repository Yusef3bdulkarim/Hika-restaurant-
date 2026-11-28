import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/theme/hika_colors.dart';
import 'package:hika_app/core/theme/hika_shadows.dart';

void main() {
  group('HikaShadows', () {
    // Shadows are const, so their color is a copy of textPrimary: keep them tied.
    final textPrimary = HikaColors.light.textPrimary;

    test('should use textPrimary at 12% when elevation1 is read', () {
      final color = HikaShadows.elevation1.single.color;

      expect(color.withValues(alpha: 1), textPrimary);
      expect(color.a, closeTo(0.12, 0.005));
    });

    test('should use textPrimary at 16% when elevation2 is read', () {
      final color = HikaShadows.elevation2.single.color;

      expect(color.withValues(alpha: 1), textPrimary);
      expect(color.a, closeTo(0.16, 0.005));
    });
  });
}
