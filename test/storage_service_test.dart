import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gym_app/models/progress_entry.dart';
import 'package:gym_app/models/user_profile.dart';
import 'package:gym_app/services/secure_key_value_store.dart';
import 'package:gym_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('stores user profile in secure storage', () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );

    await service.saveUserProfile(_profile());

    expect(await service.hasUserProfile(), isTrue);
    expect((await service.getUserProfile())?.name, 'Asha');
    expect(legacyPrefs.containsKey('user_profile'), isFalse);
    expect(await secureStore.containsKey('user_profile'), isTrue);
  });

  test('migrates legacy profile and progress data to secure storage', () async {
    final progress = ProgressEntry(
      date: DateTime(2026, 7, 14),
      weight: 72,
      bmi: 24.9,
    );
    SharedPreferences.setMockInitialValues({
      'user_profile': jsonEncode(_profile().toJson()),
      'progress_history': jsonEncode([progress.toJson()]),
    });
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );

    await service.init();

    expect(legacyPrefs.containsKey('user_profile'), isFalse);
    expect(legacyPrefs.containsKey('progress_history'), isFalse);
    expect((await service.getUserProfile())?.name, 'Asha');
    expect((await service.getProgressHistory()).single.weight, 72);
  });

  test('clears malformed secure profile data', () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    await secureStore.write('user_profile', 'not-json');
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );

    expect(await service.getUserProfile(), isNull);
    expect(await secureStore.containsKey('user_profile'), isFalse);
  });
}

UserProfile _profile() {
  return UserProfile(
    name: 'Asha',
    age: 28,
    height: 170,
    weight: 72,
    gender: 'female',
    activityLevel: 'moderate',
    goal: 'maintain',
  );
}

class InMemorySecureKeyValueStore implements SecureKeyValueStore {
  final Map<String, String> _data = {};

  @override
  Future<bool> containsKey(String key) async => _data.containsKey(key);

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _data.clear();
  }

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async {
    _data[key] = value;
  }
}
