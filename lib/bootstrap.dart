import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/di/injection.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const App());
}
