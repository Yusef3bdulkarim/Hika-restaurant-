import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/flavor.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_options.dart';

Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  await Firebase.initializeApp(options: firebaseOptionsFor(flavor));
  configureDependencies();
  runApp(const App());
}

/// Bundled fonts are OFL: their license must ship with the app.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (family, path) in const [
      ('Baloo Bhaijaan 2', 'assets/fonts/OFL-BalooBhaijaan2.txt'),
      ('Readex Pro', 'assets/fonts/OFL-ReadexPro.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString(path));
    }
  });
}
