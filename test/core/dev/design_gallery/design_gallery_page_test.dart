import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/dev/design_gallery/design_gallery_page.dart';
import 'package:hika_app/core/theme/hika_theme.dart';

void main() {
  group('DesignGalleryPage', () {
    testWidgets(
      'should render every section without overflow when width is 360 and font scale is 130%',
      (tester) async {
        // Arrange: smallest supported width, largest supported font scale
        tester.view.physicalSize = const Size(360, 2400);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: HikaTheme.light(),
            home: const MediaQuery(
              data: MediaQueryData(
                size: Size(360, 2400),
                textScaler: TextScaler.linear(1.3),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DesignGalleryPage(),
              ),
            ),
          ),
        );

        // The list is lazy: scroll to the last section so all get laid out.
        await tester.scrollUntilVisible(find.text('Shadows'), 500);

        // Assert: an overflow is reported as an exception
        expect(tester.takeException(), isNull);
        expect(find.text('Shadows'), findsOneWidget);
      },
    );
  });
}
