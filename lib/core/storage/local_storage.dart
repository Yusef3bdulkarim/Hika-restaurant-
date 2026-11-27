import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';

/// Stores JSON values by key. Throws [CacheException] on plugin exceptions
/// and corrupt stored JSON. Non-JSON values passed to [writeJson] throw an
/// [Error] on purpose (programmer bug).
class LocalStorage {
  const LocalStorage(this._prefs);

  final SharedPreferencesAsync _prefs;

  /// Returns `null` when [key] has no stored value.
  Future<Object?> readJson(String key) async {
    final String? raw;
    try {
      raw = await _prefs.getString(key);
    } on Exception catch (e) {
      throw CacheException(e);
    }
    if (raw == null) return null;
    try {
      return jsonDecode(raw);
    } on FormatException catch (e) {
      throw CacheException(e);
    }
  }

  Future<void> writeJson(String key, Object value) async {
    try {
      await _prefs.setString(key, jsonEncode(value));
    } on Exception catch (e) {
      throw CacheException(e);
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } on Exception catch (e) {
      throw CacheException(e);
    }
  }
}
