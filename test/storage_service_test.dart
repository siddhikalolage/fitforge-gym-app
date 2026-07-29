import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fitforge_ai/models/progress_entry.dart';
import 'package:fitforge_ai/models/user_profile.dart';
import 'package:fitforge_ai/services/secure_key_value_store.dart';
import 'package:fitforge_ai/services/storage_service.dart';
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

  test('rejects an invalid profile before writing secure storage', () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );
    final invalidProfile = UserProfile(
      name: 'Asha',
      age: 12,
      height: 170,
      weight: 72,
      gender: 'female',
      activityLevel: 'moderate',
      goal: 'maintain',
    );

    await expectLater(
      service.saveUserProfile(invalidProfile),
      throwsArgumentError,
    );
    expect(await secureStore.containsKey('user_profile'), isFalse);
  });

  test('rejects an invalid progress entry before writing secure storage',
      () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );
    final invalidEntry = ProgressEntry(
      date: DateTime(2026, 7, 14),
      weight: 0,
      bmi: 24.9,
    );

    await expectLater(
      service.saveProgressEntry(invalidEntry),
      throwsArgumentError,
    );
    expect(await secureStore.containsKey('progress_history'), isFalse);
  });

  test('hides profile storage failures behind a safe exception', () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final service = StorageService.test(
      secureStore: FailingSecureKeyValueStore(),
      legacyPreferences: legacyPrefs,
    );

    try {
      await service.saveUserProfile(_profile());
      fail('Expected profile storage failure');
    } on StorageServiceException catch (error) {
      expect(error.message, StorageServiceException.saveProfile.message);
      expect(error.toString(), isNot(contains('platform detail')));
    }
  });

  test('hides progress storage failures behind a safe exception', () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final service = StorageService.test(
      secureStore: FailingSecureKeyValueStore(),
      legacyPreferences: legacyPrefs,
    );
    final entry = ProgressEntry(
      date: DateTime(2026, 7, 14),
      weight: 72,
      bmi: 24.9,
    );

    try {
      await service.saveProgressEntry(entry);
      fail('Expected progress storage failure');
    } on StorageServiceException catch (error) {
      expect(error.message, StorageServiceException.saveProgress.message);
      expect(error.toString(), isNot(contains('platform detail')));
    }
  });

  test('exports profile and progress data without storage metadata', () async {
    SharedPreferences.setMockInitialValues({});
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );
    final progress = ProgressEntry(
      date: DateTime(2026, 7, 14),
      weight: 72,
      bmi: 24.9,
    );

    await service.saveUserProfile(_profile());
    await service.saveProgressEntry(progress);

    final export = jsonDecode(await service.exportData()) as Map<String, dynamic>;

    expect(export['schemaVersion'], 1);
    expect(export['profile'], _profile().toJson());
    expect(export['progress'], [progress.toJson()]);
    expect(export.containsKey('secureStore'), isFalse);
    expect(export['exportedAt'], isA<String>());
  });

  test('reset removes secure and legacy profile and progress data', () async {
    SharedPreferences.setMockInitialValues({
      'user_profile': jsonEncode(_profile().toJson()),
      'progress_history': '[]',
    });
    final legacyPrefs = await SharedPreferences.getInstance();
    final secureStore = InMemorySecureKeyValueStore();
    await secureStore.write('user_profile', jsonEncode(_profile().toJson()));
    await secureStore.write('progress_history', '[]');
    await secureStore.write('future_auth_key', 'must-remain');
    final service = StorageService.test(
      secureStore: secureStore,
      legacyPreferences: legacyPrefs,
    );

    await service.resetAll();

    expect(await secureStore.containsKey('user_profile'), isFalse);
    expect(await secureStore.containsKey('progress_history'), isFalse);
    expect(await secureStore.containsKey('future_auth_key'), isTrue);
    expect(legacyPrefs.containsKey('user_profile'), isFalse);
    expect(legacyPrefs.containsKey('progress_history'), isFalse);
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

class FailingSecureKeyValueStore implements SecureKeyValueStore {
  @override
  Future<bool> containsKey(String key) async => false;

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> deleteAll() async {}

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {
    throw StateError('platform detail');
  }
}
