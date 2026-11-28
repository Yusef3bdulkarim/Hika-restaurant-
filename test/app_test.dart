import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/app.dart';
import 'package:hika_app/core/router/placeholder_page.dart';

void main() {
  group('App', () {
    testWidgets('should start on placeholder page when app starts', (
      tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(PlaceholderPage), findsOneWidget);
    });

    testWidgets('should render Arabic app title when app starts', (
      tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('هيكا'), findsOneWidget);
    });

    testWidgets('should lay out right-to-left when app starts', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Scaffold));
      expect(Directionality.of(context), TextDirection.rtl);
    });
  });
}
