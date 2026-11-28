import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/theme/hika_colors.dart';
import 'package:hika_app/core/theme/hika_theme.dart';
import 'package:hika_app/core/widgets/hika_logo.dart';

void main() {
  Future<SvgPicture> pumpLogo(WidgetTester tester, HikaLogo logo) async {
    await tester.pumpWidget(MaterialApp(theme: HikaTheme.light(), home: logo));
    return tester.widget<SvgPicture>(find.byType(SvgPicture));
  }

  group('HikaLogoVariant', () {
    test('should have an asset file for every variant', () {
      for (final variant in HikaLogoVariant.values) {
        expect(File(variant.asset).existsSync(), isTrue, reason: variant.name);
      }
    });
  });

  group('HikaLogo', () {
    testWidgets('should use primary color when no color is given', (
      tester,
    ) async {
      final picture = await pumpLogo(tester, const HikaLogo(width: 120));

      expect(
        picture.colorFilter,
        ColorFilter.mode(HikaColors.light.primary, BlendMode.srcIn),
      );
    });

    testWidgets('should load rings asset when variant is rings', (
      tester,
    ) async {
      final picture = await pumpLogo(
        tester,
        const HikaLogo(width: 120, variant: HikaLogoVariant.rings),
      );

      final loader = picture.bytesLoader as SvgAssetLoader;
      expect(loader.assetName, HikaLogoVariant.rings.asset);
    });

    testWidgets('should be excluded from semantics when no label is given', (
      tester,
    ) async {
      final picture = await pumpLogo(tester, const HikaLogo(width: 120));

      expect(picture.excludeFromSemantics, isTrue);
    });
  });
}
