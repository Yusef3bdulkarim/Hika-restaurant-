import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/flavor.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}
