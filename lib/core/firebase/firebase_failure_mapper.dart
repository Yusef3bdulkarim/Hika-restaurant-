import 'package:firebase_core/firebase_core.dart';

import '../error/failure.dart';

/// Maps any Firebase SDK error (Firestore, Auth, Functions, Storage — all
/// extend [FirebaseException]) to a typed [Failure]. Unknown codes →
/// [ServerFailure].
Failure mapFirebaseException(FirebaseException e) => switch (e.code) {
  'unavailable' ||
  'network-request-failed' ||
  'deadline-exceeded' => const NetworkFailure(),
  'permission-denied' => const PermissionFailure(),
  'not-found' => const NotFoundFailure(),
  'resource-exhausted' || 'too-many-requests' => const RateLimitFailure(),
  _ => const ServerFailure(),
};
