import '../result/api_result.dart';

/// [P] can be a record, e.g. `({String email, String password})`,
/// or [NoParams] when the use case takes no input.
abstract interface class UseCase<T, P> {
  Future<ApiResult<T>> call(P params);
}

final class NoParams {
  const NoParams();
}
