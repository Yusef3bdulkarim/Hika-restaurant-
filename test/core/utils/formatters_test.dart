import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/l10n/generated/app_localizations.dart';
import 'package:hika_app/core/utils/formatters.dart';

void main() {
  final nbsp = String.fromCharCode(0xA0);
  final l10n = lookupAppLocalizations(const Locale('ar'));

  group('formatNumber', () {
    test('should group thousands with a comma when value is 25000', () {
      expect(formatNumber(25000), '25,000');
    });

    test('should show no decimals when value is a whole int', () {
      expect(formatNumber(220), '220');
    });

    test('should show no decimals when value is a whole double', () {
      expect(formatNumber(220.0), '220');
    });

    test('should show two decimals when value has a fraction', () {
      expect(formatNumber(13.35), '13.35');
    });

    test('should pad to two decimals when fraction has one digit', () {
      expect(formatNumber(13.5), '13.50');
    });

    test('should show no decimals when fraction rounds away', () {
      expect(formatNumber(220.004), '220');
    });

    test('should show 0 without a sign when tiny negative rounds to zero', () {
      expect(formatNumber(-0.001), '0');
    });

    test('should keep the minus sign when value is negative', () {
      expect(formatNumber(-20), '-20');
    });

    test('should throw ArgumentError when value is NaN', () {
      expect(() => formatNumber(double.nan), throwsArgumentError);
    });

    test('should throw ArgumentError when value is infinite', () {
      expect(() => formatNumber(double.infinity), throwsArgumentError);
    });
  });

  group('formatClock', () {
    test('should pad minutes to two digits when minute is below 10', () {
      expect(formatClock(9, 5), (clock: '9:05', isAm: true));
    });

    test('should mark pm when hour is 12', () {
      expect(formatClock(12, 30), (clock: '12:30', isAm: false));
    });

    test('should accept 23:59 when it is the last minute of the day', () {
      expect(formatClock(23, 59), (clock: '11:59', isAm: false));
    });

    test('should throw ArgumentError when hour is above 23', () {
      expect(() => formatClock(24, 0), throwsArgumentError);
    });

    test('should throw ArgumentError when hour is negative', () {
      expect(() => formatClock(-1, 0), throwsArgumentError);
    });

    test('should throw ArgumentError when minute is above 59', () {
      expect(() => formatClock(10, 60), throwsArgumentError);
    });

    test('should throw ArgumentError when minute is negative', () {
      expect(() => formatClock(10, -1), throwsArgumentError);
    });
  });

  group('HikaFormatters.time', () {
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
    test('should join amount and ج.م with a non-breaking space when money is formatted', () {
      expect(l10n.money(25000), '25,000$nbspج.م');
    });

    test('should show two decimals when money has a fraction', () {
      expect(l10n.money(13.5), '13.50$nbspج.م');
    });

    test('should keep the minus sign when money is a discount', () {
      expect(l10n.money(-20), '-20$nbspج.م');
    });
  });
}
