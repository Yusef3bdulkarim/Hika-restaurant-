import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/utils/formatters.dart';
import 'package:intl/intl.dart';

// Own file = own isolate: the default locale is set before the formatter's
// cached NumberFormat instances are first created.
void main() {
  setUpAll(() => Intl.defaultLocale = 'ar_EG'); // uses Arabic-Indic digits

  group('formatNumber', () {
    test('should use Western digits when device locale is ar_EG', () {
      expect(formatNumber(-1234567.89), '-1,234,567.89');
    });
  });
}
