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

  group('formatClock', () {
    test('should pad minutes to two digits when minute is below 10', () {
      expect(formatClock(9, 5), (clock: '9:05', isAm: true));
    });

    test('should throw ArgumentError when hour is out of range', () {
      expect(() => formatClock(24, 0), throwsArgumentError);
    });

    test('should throw ArgumentError when minute is out of range', () {
      expect(() => formatClock(10, 60), throwsArgumentError);
    });
  });

  group('HikaFormatters.time', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));
    String at(int hour, int minute) =>
        l10n.time(DateTime(2026, 11, 28, hour, minute));

    test('should show 9:30 م when time is 21:30', () {
      expect(at(21, 30), '9:30$nbspم');
    });

    test('should show 1:00 ص when time is 01:00', () {
      expect(at(1, 0), '1:00$nbspص');
    });

    test('should show 12 ص when time is midnight', () {
      expect(at(0, 0), '12$nbspص');
    });

    test('should show 12:30 ص when time is 00:30', () {
      expect(at(0, 30), '12:30$nbspص');
    });

    test('should show 12:00 م when time is noon', () {
      expect(at(12, 0), '12:00$nbspم');
    });
  });

  group('HikaFormatters.money', () {
    final l10n = lookupAppLocalizations(const Locale('ar'));

    test('should join amount and ج.م with a non-breaking space when money is formatted', () {
      expect(l10n.money(25000), '25,000$nbspج.م');
    });
  });
}
