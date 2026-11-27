/// Thrown by local data sources; repositories map it to `CacheFailure`.
final class CacheException implements Exception {
  const CacheException(this.cause);

  final Object cause;

  @override
  String toString() => 'CacheException: $cause';
}
