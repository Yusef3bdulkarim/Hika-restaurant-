import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/error/failure.dart';
import 'package:hika_app/core/firebase/firebase_failure_mapper.dart';

FirebaseException exceptionWith(String code) =>
    FirebaseException(plugin: 'test', code: code);

void main() {
  group('mapFirebaseException', () {
    const expected = <String, Failure>{
      'unavailable': NetworkFailure(),
      'network-request-failed': NetworkFailure(),
      'deadline-exceeded': NetworkFailure(),
      'permission-denied': PermissionFailure(),
      'not-found': NotFoundFailure(),
      'resource-exhausted': RateLimitFailure(),
      'too-many-requests': RateLimitFailure(),
      // Until E3 adds AuthFailure, these fall back to ServerFailure on purpose.
      'unauthenticated': ServerFailure(),
      'wrong-password': ServerFailure(),
      'internal': ServerFailure(),
    };

    for (final MapEntry(key: code, value: failure) in expected.entries) {
      test('should return ${failure.runtimeType} when code is $code', () {
        expect(mapFirebaseException(exceptionWith(code)), failure);
      });
    }
  });
}
