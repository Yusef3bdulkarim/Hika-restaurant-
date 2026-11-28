import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/theme/hika_fonts.dart';
import 'package:hika_app/core/theme/hika_text_styles.dart';

void main() {
  group('HikaTextStyles', () {
    const s = HikaTextStyles.standard;

    group('standard', () {
      test('should use Baloo for display and headings when standard styles are read', () {
        // Arrange
        final baloo = [s.display, s.h1, s.h2];
        final readex = [
          s.h3, s.title, s.body, s.bodyStrong, s.label, //
          s.caption, s.micro, s.price, s.priceLarge,
        ];

        // Assert
        expect(baloo.map((e) => e.fontFamily), everyElement(HikaFonts.baloo));
        expect(readex.map((e) => e.fontFamily), everyElement(HikaFonts.readex));
      });

      test('should match M1-Type size weight and line height when standard styles are read', () {
        // Arrange: (style, size, weight, line height) from M1-Type
        final table = <(String, TextStyle, double, FontWeight, double)>[
          ('display', s.display, 32, FontWeight.w700, 40),
          ('h1', s.h1, 24, FontWeight.w700, 32),
          ('h2', s.h2, 20, FontWeight.w700, 28),
          ('h3', s.h3, 17, FontWeight.w600, 26),
          ('title', s.title, 16, FontWeight.w600, 24),
          ('body', s.body, 15, FontWeight.w400, 24),
          ('bodyStrong', s.bodyStrong, 15, FontWeight.w500, 24),
          ('label', s.label, 14, FontWeight.w500, 20),
          ('caption', s.caption, 13, FontWeight.w400, 20),
          ('micro', s.micro, 12, FontWeight.w500, 16),
          ('price', s.price, 16, FontWeight.w700, 24),
          ('priceLarge', s.priceLarge, 20, FontWeight.w700, 28),
        ];

        // Assert
        for (final (name, style, size, weight, line) in table) {
          expect(style.fontSize, size, reason: name);
          expect(style.fontWeight, weight, reason: name);
          expect(
            style.fontSize! * style.height!,
            closeTo(line, 0.001),
            reason: name,
          );
        }
      });
    });

    group('copyWith', () {
      test('should replace only the given style when copyWith is called', () {
        // Arrange
        const custom = TextStyle(fontSize: 99);

        // Act
        final result = s.copyWith(body: custom);

        // Assert
        expect(result.body, custom);
        expect(result.priceLarge, s.priceLarge);
      });
    });
  });
}
