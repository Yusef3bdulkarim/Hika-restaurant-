import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/error/failure.dart';
import 'package:hika_app/core/firebase/firebase_failure_mapper.dart';

FirebaseException exceptionWith(String code) =>
    FirebaseException(plugin: 'test', code: code);

void main() {
  group('mapFirebaseException', () {
    test('should return NetworkFailure when code is a network error', () {
      for (final code in [
        'unavailable',
        'network-request-failed',
        'deadline-exceeded',
      ]) {
        expect(
          mapFirebaseException(exceptionWith(code)),
          const NetworkFailure(),
          reason: code,
        );
      }
    });

    test('should return PermissionFailure when code is permission-denied', () {
      expect(
        mapFirebaseException(exceptionWith('permission-denied')),
        const PermissionFailure(),
      );
    });

    test('should return NotFoundFailure when code is not-found', () {
      expect(
        mapFirebaseException(exceptionWith('not-found')),
        const NotFoundFailure(),
      );
    });

    test('should return RateLimitFailure when code is a rate-limit error', () {
      for (final code in ['resource-exhausted', 'too-many-requests']) {
        expect(
          mapFirebaseException(exceptionWith(code)),
          const RateLimitFailure(),
          reason: code,
        );
      }
    });

    test('should return ServerFailure when code is unknown', () {
      expect(
        mapFirebaseException(exceptionWith('internal')),
        const ServerFailure(),
      );
    });
  });
}
