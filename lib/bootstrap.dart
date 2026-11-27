import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_options.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptionsFor(flavor));
  configureDependencies();
  runApp(const App());
}
