import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/error/failure.dart';

void main() {
  group('Failure', () {
    test('should be equal when two failures have same type and fields', () {
      expect(const NetworkFailure(), const NetworkFailure());
      expect(
        const RateLimitFailure(retryAfter: Duration(seconds: 60)),
        const RateLimitFailure(retryAfter: Duration(seconds: 60)),
      );
    });

    test('should not be equal when failures have different types', () {
      expect(const ServerFailure(), isNot(const NetworkFailure()));
    });

    test('should not be equal when ValidationFailure field errors differ', () {
      expect(
        const ValidationFailure({'email': 'invalid'}),
        isNot(const ValidationFailure({'email': 'required'})),
      );
    });

    test('should not be equal when RateLimitFailure retryAfter differs', () {
      expect(
        const RateLimitFailure(retryAfter: Duration(seconds: 60)),
        isNot(const RateLimitFailure(retryAfter: Duration(seconds: 30))),
      );
    });
  });
}
