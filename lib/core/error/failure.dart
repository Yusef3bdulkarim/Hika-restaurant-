import 'package:equatable/equatable.dart';

/// Typed error passed from the data layer up to presentation.
/// Carries no message: presentation maps each type to an l10n key.
/// Unknown errors are mapped to [ServerFailure].
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

final class ServerFailure extends Failure {
  const ServerFailure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class CacheFailure extends Failure {
  const CacheFailure();
}

final class PermissionFailure extends Failure {
  const PermissionFailure();
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure();
}

final class RateLimitFailure extends Failure {
  const RateLimitFailure({this.retryAfter});

  final Duration? retryAfter;

  @override
  List<Object?> get props => [retryAfter];
}

/// [fieldErrors] maps a field key to an error code, e.g. `'email': 'invalid'`.
final class ValidationFailure extends Failure {
  const ValidationFailure(this.fieldErrors);

  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [fieldErrors];
}
