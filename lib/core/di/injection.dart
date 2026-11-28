import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/local_storage.dart';

final sl = GetIt.instance;

void configureDependencies() {
  sl
    ..registerLazySingleton<SharedPreferencesAsync>(SharedPreferencesAsync.new)
    ..registerLazySingleton<LocalStorage>(() => LocalStorage(sl()));
}
