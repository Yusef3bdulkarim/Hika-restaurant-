import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/theme/hika_colors.dart';
import 'package:hika_app/core/theme/hika_fonts.dart';
import 'package:hika_app/core/theme/hika_text_styles.dart';
import 'package:hika_app/core/theme/hika_theme.dart';
import 'package:hika_app/core/theme/theme_context.dart';

void main() {
  group('HikaTheme', () {
    group('light', () {
      test(
        'should expose HikaColors and HikaTextStyles when theme is built',
        () {
          // Act
          final theme = HikaTheme.light();

          // Assert
          expect(theme.extension<HikaColors>(), HikaColors.light);
          expect(theme.extension<HikaTextStyles>(), HikaTextStyles.standard);
        },
      );

      test('should map primary and background into ColorScheme and scaffold when theme is built', () {
        // Act
        final theme = HikaTheme.light();

        // Assert
        expect(theme.colorScheme.primary, HikaColors.light.primary);
        expect(theme.scaffoldBackgroundColor, HikaColors.light.background);
      });

      testWidgets(
        'should read colors from context when widget is under HikaTheme',
        (tester) async {
          // Arrange
          late HikaColors colors;
          late HikaTextStyles styles;

          // Act
          await tester.pumpWidget(
            MaterialApp(
              theme: HikaTheme.light(),
              home: Builder(
                builder: (context) {
                  colors = context.colors;
                  styles = context.textStyles;
                  return const SizedBox();
                },
              ),
            ),
          );

          // Assert
          expect(colors, HikaColors.light);
          expect(styles, HikaTextStyles.standard);
        },
      );

      testWidgets(
        'should render unstyled text in Readex textPrimary when widget is under HikaTheme',
        (tester) async {
          // Act
          await tester.pumpWidget(
            MaterialApp(
              theme: HikaTheme.light(),
              home: const Scaffold(body: Text('هيكا')),
            ),
          );

          // Assert
          final style = DefaultTextStyle.of(tester.element(find.text('هيكا')))
              .style;
          expect(style.fontFamily, HikaFonts.readex);
          expect(style.color, HikaColors.light.textPrimary);
          expect(style.letterSpacing, 0);
        },
      );
    });
  });
}
