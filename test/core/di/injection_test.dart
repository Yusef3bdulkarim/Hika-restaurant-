import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/di/injection.dart';
import 'package:hika_app/core/storage/local_storage.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() => sl.reset());

  group('configureDependencies', () {
    test(
      'should return the same LocalStorage instance when resolved twice',
      () {
        configureDependencies();

        expect(sl<LocalStorage>(), same(sl<LocalStorage>()));
      },
    );
  });
}
