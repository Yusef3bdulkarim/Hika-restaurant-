import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/l10n/generated/app_localizations.dart';
import 'package:hika_app/core/utils/formatters.dart';

void main() {
  const nbsp = ' ';

  group('formatNumber', () {
    test('should group thousands with a comma when value is 25000', () {
      expect(formatNumber(25000), '25,000');
    });

    test('should show no decimals when value is whole', () {
      expect(formatNumber(220), '220');
      expect(formatNumber(220.0), '220');
    });

    test('should show two decimals when value has a fraction', () {
      expect(formatNumber(13.35), '13.35');
      expect(formatNumber(13.5), '13.50');
    });

    test('should keep the minus sign when value is negative', () {
      expect(formatNumber(-20), '-20');
    });

    test('should use Western digits when value is formatted', () {
      expect(formatNumber(1234567.89), matches(RegExp(r'^[0-9,.]+$')));
    });
  });

  group('HikaFormatters.money', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));

    test('should join amount and ج.م with a non-breaking space when money is formatted', () {
      expect(l10n.money(25000), '25,000$nbspج.م');
    });
  });
}
