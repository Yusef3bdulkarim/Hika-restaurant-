import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/error/failure.dart';
import 'package:hika_app/core/result/api_result.dart';

String describe(ApiResult<int> result) => switch (result) {
  ApiSuccess(:final data) => 'data:$data',
  ApiFailure(:final failure) => 'failure:${failure.runtimeType}',
};

void main() {
  group('ApiResult', () {
    test('should expose data when result is ApiSuccess', () {
      expect(describe(const ApiSuccess(220)), 'data:220');
    });

    test('should expose failure when result is ApiFailure', () {
      expect(
        describe(const ApiFailure(CacheFailure())),
        'failure:CacheFailure',
      );
    });
  });
}
