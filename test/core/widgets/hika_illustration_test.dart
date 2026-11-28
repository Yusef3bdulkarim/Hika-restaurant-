import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/widgets/hika_illustration.dart';

void main() {
  Future<SvgPicture> pumpPicture(
    WidgetTester tester,
    HikaIllustration illustration,
  ) async {
    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.rtl, child: illustration),
    );
    return tester.widget<SvgPicture>(find.byType(SvgPicture));
  }

  group('HikaIllustrations', () {
    test('should have an asset file for every illustration', () {
      for (final illustration in HikaIllustrations.values) {
        expect(
          File(illustration.asset).existsSync(),
          isTrue,
          reason: illustration.name,
        );
      }
    });
  });

  group('HikaIllustration', () {
    testWidgets('should render at 120 when size is inline', (tester) async {
      final picture = await pumpPicture(
        tester,
        const HikaIllustration(
          HikaIllustrations.emptyCart,
          size: HikaIllustrationSize.inline,
        ),
      );

      expect((picture.width, picture.height), (120, 120));
    });

    testWidgets('should render at 140 when size is screen', (tester) async {
      final picture = await pumpPicture(
        tester,
        const HikaIllustration(HikaIllustrations.offline),
      );

      expect((picture.width, picture.height), (140, 140));
    });

    testWidgets('should be excluded from semantics when rendered', (
      tester,
    ) async {
      final picture = await pumpPicture(
        tester,
        const HikaIllustration(HikaIllustrations.offline),
      );

      expect(picture.excludeFromSemantics, isTrue);
    });
  });
}
