import 'package:flutter_test/flutter_test.dart';
import 'package:hika_app/core/error/exceptions.dart';
import 'package:hika_app/core/storage/local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferencesAsync extends Mock
    implements SharedPreferencesAsync {}

void main() {
  late MockSharedPreferencesAsync prefs;
  late LocalStorage storage;

  const key = 'cart';

  setUp(() {
    prefs = MockSharedPreferencesAsync();
    storage = LocalStorage(prefs);
  });

  group('readJson', () {
    test('should return decoded map when key holds valid JSON', () async {
      when(() => prefs.getString(key)).thenAnswer((_) async => '{"qty":2}');

      final result = await storage.readJson(key);

      expect(result, {'qty': 2});
    });

    test('should return null when key is missing', () async {
      when(() => prefs.getString(key)).thenAnswer((_) async => null);

      final result = await storage.readJson(key);

      expect(result, isNull);
    });

    test(
      'should throw CacheException when stored value is not valid JSON',
      () async {
        when(() => prefs.getString(key)).thenAnswer((_) async => '{broken');

        expect(storage.readJson(key), throwsA(isA<CacheException>()));
      },
    );

    test('should throw CacheException when plugin read fails', () async {
      when(() => prefs.getString(key)).thenThrow(Exception('io'));

      expect(storage.readJson(key), throwsA(isA<CacheException>()));
    });
  });

  group('writeJson', () {
    test('should store encoded JSON when writeJson is called', () async {
      when(() => prefs.setString(key, any())).thenAnswer((_) async {});

      await storage.writeJson(key, {'qty': 2});

      verify(() => prefs.setString(key, '{"qty":2}')).called(1);
    });

    test('should throw CacheException when plugin write fails', () async {
      when(() => prefs.setString(key, any())).thenThrow(Exception('io'));

      expect(
        storage.writeJson(key, {'qty': 2}),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('remove', () {
    test('should delete key when remove is called', () async {
      when(() => prefs.remove(key)).thenAnswer((_) async {});

      await storage.remove(key);

      verify(() => prefs.remove(key)).called(1);
    });

    test('should throw CacheException when plugin remove fails', () async {
      when(() => prefs.remove(key)).thenThrow(Exception('io'));

      expect(storage.remove(key), throwsA(isA<CacheException>()));
    });
  });
}
