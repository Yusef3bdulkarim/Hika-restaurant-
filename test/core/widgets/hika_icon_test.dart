import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/widgets/hika_icon.dart';

void main() {
  Future<void> pumpIcon(
    WidgetTester tester,
    HikaIcon icon, {
    TextDirection direction = TextDirection.rtl,
    Color iconThemeColor = const Color(0xFF000001),
  }) => tester.pumpWidget(
    Directionality(
      textDirection: direction,
      child: IconTheme(
        data: IconThemeData(color: iconThemeColor),
        child: icon,
      ),
    ),
  );

  SvgPicture picture(WidgetTester tester) =>
      tester.widget<SvgPicture>(find.byType(SvgPicture));

  Finder flip() => find.descendant(
    of: find.byType(HikaIcon),
    matching: find.byType(Transform),
  );

  group('HikaIcons', () {
    test('should have an asset file for every icon and variant', () {
      for (final icon in HikaIcons.values) {
        expect(File(icon.regularAsset).existsSync(), isTrue, reason: icon.name);
        expect(File(icon.fillAsset).existsSync(), isTrue, reason: icon.name);
      }
    });

    test('should have an enum value for every icon file', () {
      final files = Directory('assets/icons')
          .listSync()
          .map((f) => 'assets/icons/${f.uri.pathSegments.last}')
          .toSet();
      final fromEnum = {
        for (final icon in HikaIcons.values) ...[
          icon.regularAsset,
          icon.fillAsset,
        ],
      };

      expect(files, fromEnum);
    });
  });

  group('HikaIcon', () {
    testWidgets(
      'should mirror icon when icon is directional and direction is ltr',
      (tester) async {
        await pumpIcon(
          tester,
          const HikaIcon(HikaIcons.back),
          direction: TextDirection.ltr,
        );

        expect(flip(), findsOneWidget);
      },
    );

    testWidgets(
      'should not mirror icon when icon is directional and direction is rtl',
      (tester) async {
        await pumpIcon(tester, const HikaIcon(HikaIcons.back));

        expect(flip(), findsNothing);
      },
    );

    testWidgets('should not mirror icon when icon is not directional', (
      tester,
    ) async {
      await pumpIcon(
        tester,
        const HikaIcon(HikaIcons.search),
        direction: TextDirection.ltr,
      );

      expect(flip(), findsNothing);
    });

    testWidgets('should use IconTheme color when no color is given', (
      tester,
    ) async {
      const themeColor = Color(0xFF123456);

      await pumpIcon(
        tester,
        const HikaIcon(HikaIcons.home),
        iconThemeColor: themeColor,
      );

      expect(
        picture(tester).colorFilter,
        const ColorFilter.mode(themeColor, BlendMode.srcIn),
      );
    });

    testWidgets(
      'should render with fallback color when no IconTheme is above',
      (tester) async {
        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.rtl,
            child: HikaIcon(HikaIcons.home),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(picture(tester).colorFilter, isNotNull);
      },
    );

    testWidgets('should use given color when color is given', (tester) async {
      const given = Color(0xFF654321);

      await pumpIcon(tester, const HikaIcon(HikaIcons.home, color: given));

      expect(
        picture(tester).colorFilter,
        const ColorFilter.mode(given, BlendMode.srcIn),
      );
    });

    testWidgets('should load fill asset when filled is true', (tester) async {
      await pumpIcon(tester, const HikaIcon(HikaIcons.home, filled: true));

      final loader = picture(tester).bytesLoader as SvgAssetLoader;
      expect(loader.assetName, HikaIcons.home.fillAsset);
    });

    testWidgets('should be excluded from semantics when no label is given', (
      tester,
    ) async {
      await pumpIcon(tester, const HikaIcon(HikaIcons.home));

      expect(picture(tester).excludeFromSemantics, isTrue);
    });
  });
}
