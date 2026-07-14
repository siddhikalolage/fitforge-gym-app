import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureKeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<bool> containsKey(String key);

  Future<void> deleteAll();
}

class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  FlutterSecureKeyValueStore({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  @override
  Future<bool> containsKey(String key) {
    return _storage.containsKey(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
