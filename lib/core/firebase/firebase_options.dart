import 'package:firebase_core/firebase_core.dart';

import '../config/flavor.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;

FirebaseOptions firebaseOptionsFor(Flavor flavor) => switch (flavor) {
  Flavor.dev => dev.DefaultFirebaseOptions.currentPlatform,
  Flavor.prod => prod.DefaultFirebaseOptions.currentPlatform,
};
