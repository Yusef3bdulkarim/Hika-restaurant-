import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/theme/hika_colors.dart';

void main() {
  group('HikaColors', () {
    const light = HikaColors.light;
    const red = Color(0xFFFF0000);

    group('copyWith', () {
      test('should replace only the given color when copyWith is called', () {
        // Act
        final result = light.copyWith(primary: red);

        // Assert
        expect(result.primary, red);
        expect(result.primaryDeep, light.primaryDeep);
        expect(result.tierGoldTint, light.tierGoldTint);
      });
    });

    group('lerp', () {
      test('should return this when lerp other is not HikaColors', () {
        // Act
        final result = light.lerp(null, 0.5);

        // Assert
        expect(result, same(light));
      });

      test('should return other colors when lerp t is 1', () {
        // Arrange
        final other = light.copyWith(primary: red, tierGoldTint: red);

        // Act
        final result = light.lerp(other, 1);

        // Assert
        expect(result.primary, red);
        expect(result.tierGoldTint, red);
        expect(result.surface, light.surface);
      });
    });
  });
}
