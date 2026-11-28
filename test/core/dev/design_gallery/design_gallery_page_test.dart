import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/dev/design_gallery/design_gallery_page.dart';
import 'package:hika_app/core/theme/hika_theme.dart';

void main() {
  group('DesignGalleryPage', () {
    const sections = [
      'Colors',
      'Type',
      'Spacing',
      'Radii',
      'Shadows',
      'Icons',
      'Illustrations',
    ];

    // Smallest and largest supported widths, at the largest supported font scale.
    for (final width in [360.0, 430.0]) {
      testWidgets(
        'should render every section without overflow when width is ${width.toInt()} and font scale is 130%',
        (tester) async {
          // Arrange
          final size = Size(width, 800);
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);

          // Act
          await tester.pumpWidget(
            MaterialApp(
              theme: HikaTheme.light(),
              home: MediaQuery(
                data: MediaQueryData(
                  size: size,
                  textScaler: const TextScaler.linear(1.3),
                ),
                child: const Directionality(
                  textDirection: TextDirection.rtl,
                  child: DesignGalleryPage(),
                ),
              ),
            ),
          );

          // Assert: the list is lazy, so scroll to each section in turn.
          // A missing section fails the find; an overflow is reported as an exception.
          for (final title in sections) {
            await tester.scrollUntilVisible(find.text(title), 300);
            expect(find.text(title), findsOneWidget);
            expect(tester.takeException(), isNull, reason: title);
          }
        },
      );
    }
  });
}
