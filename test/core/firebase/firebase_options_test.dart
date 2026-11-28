import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/config/flavor.dart';
import 'package:hika_app/core/firebase/firebase_options.dart';

void main() {
  group('firebaseOptionsFor', () {
    test('should return dev project options when flavor is dev', () {
      expect(firebaseOptionsFor(Flavor.dev).projectId, 'hika-dev-3fb2e');
    });

    test('should return prod project options when flavor is prod', () {
      expect(firebaseOptionsFor(Flavor.prod).projectId, 'hika-279b8');
    });
  });
}
