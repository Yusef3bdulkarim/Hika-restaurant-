import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hika_app/core/config/flavor.dart';
import 'package:hika_app/core/dev/design_gallery/design_gallery_page.dart';
import 'package:hika_app/core/l10n/generated/app_localizations.dart';
import 'package:hika_app/core/router/app_router.dart';
import 'package:hika_app/core/router/app_routes.dart';
import 'package:hika_app/core/router/not_found_page.dart';
import 'package:hika_app/core/router/placeholder_page.dart';
import 'package:hika_app/core/theme/hika_theme.dart';

void main() {
  Future<GoRouter> pumpRouter(WidgetTester tester, Flavor flavor) async {
    final router = createRouter(flavor: flavor);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: HikaTheme.light(),
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  group('createRouter', () {
    testWidgets('should show placeholder page when flavor is prod', (
      tester,
    ) async {
      await pumpRouter(tester, Flavor.prod);

      expect(find.byType(PlaceholderPage), findsOneWidget);
    });

    testWidgets('should show not-found page when location is unknown', (
      tester,
    ) async {
      final router = await pumpRouter(tester, Flavor.prod);

      router.go('/nope');
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundPage), findsOneWidget);
      expect(find.text('الصفحة غير موجودة'), findsOneWidget);
    });

    testWidgets('should open design gallery when flavor is dev', (
      tester,
    ) async {
      await pumpRouter(tester, Flavor.dev);

      expect(find.byType(DesignGalleryPage), findsOneWidget);
    });

    testWidgets(
      'should show not-found page when gallery path is opened in prod',
      (tester) async {
        final router = await pumpRouter(tester, Flavor.prod);

        router.go(AppRoutes.devGallery);
        await tester.pumpAndSettle();

        expect(find.byType(NotFoundPage), findsOneWidget);
        expect(find.byType(DesignGalleryPage), findsNothing);
      },
    );
  });
}
