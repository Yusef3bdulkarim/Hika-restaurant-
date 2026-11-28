import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hika_app/core/l10n/generated/app_localizations.dart';
import 'package:hika_app/core/router/app_router.dart';
import 'package:hika_app/core/router/not_found_page.dart';
import 'package:hika_app/core/router/placeholder_page.dart';

void main() {
  late GoRouter router;

  setUp(() => router = createRouter());

  tearDown(() => router.dispose());

  Future<void> pumpRouter(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('createRouter', () {
    testWidgets('should show placeholder page when location is home', (
      tester,
    ) async {
      await pumpRouter(tester);

      expect(find.byType(PlaceholderPage), findsOneWidget);
    });

    testWidgets('should show not-found page when location is unknown', (
      tester,
    ) async {
      await pumpRouter(tester);

      router.go('/nope');
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundPage), findsOneWidget);
      expect(find.text('الصفحة غير موجودة'), findsOneWidget);
    });
  });
}
