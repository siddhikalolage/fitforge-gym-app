import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/progress_entry.dart';
import 'secure_key_value_store.dart';

class StorageServiceException implements Exception {
  final String message;

  const StorageServiceException._(this.message);

  static const initialization = StorageServiceException._(
    'Secure local storage is unavailable. Please restart the app and try again.',
  );
  static const saveProfile = StorageServiceException._(
    'Unable to save your profile securely. Please try again.',
  );
  static const loadProfile = StorageServiceException._(
    'Unable to load your profile securely. Please try again.',
  );
  static const saveProgress = StorageServiceException._(
    'Unable to save progress securely. Please try again.',
  );
  static const loadProgress = StorageServiceException._(
    'Unable to load progress securely. Please try again.',
  );
  static const export = StorageServiceException._(
    'Unable to prepare your data export. Please try again.',
  );
  static const reset = StorageServiceException._(
    'Unable to delete local data securely. Please try again.',
  );

  @override
  String toString() => 'StorageServiceException: $message';
}

class StorageService {
  static const String _userProfileKey = 'user_profile';
  static const String _progressHistoryKey = 'progress_history';

  static final StorageService instance = StorageService._internal();

  factory StorageService() => instance;

  StorageService._internal() : _secureStore = FlutterSecureKeyValueStore();

  StorageService.test({
    required SecureKeyValueStore secureStore,
    required SharedPreferences legacyPreferences,
  })  : _secureStore = secureStore,
        _prefs = legacyPreferences;

  final SecureKeyValueStore _secureStore;

  SharedPreferences? _prefs;
  Future<void>? _initFuture;

  Future<void> init() async {
    _initFuture ??= _initialize();
    try {
      await _initFuture;
    } catch (_) {
      _initFuture = null;
      throw StorageServiceException.initialization;
    }
  }

  Future<void> _initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _migrateLegacyValue(_prefs!, _userProfileKey);
    await _migrateLegacyValue(_prefs!, _progressHistoryKey);
  }

  Future<SharedPreferences> get _ready async {
    await init();
    return _prefs!;
  }

  Future<bool> hasUserProfile() async {
    try {
      await _ready;
      return _secureStore.containsKey(_userProfileKey);
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.loadProfile;
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    profile.validate();
    try {
      await _ready;
      await _secureStore.write(_userProfileKey, jsonEncode(profile.toJson()));
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.saveProfile;
    }
  }

  Future<UserProfile?> getUserProfile() async {
    String? data;
    try {
      await _ready;
      data = await _secureStore.read(_userProfileKey);
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.loadProfile;
    }
    if (data == null) return null;

    try {
      return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      try {
        await _secureStore.delete(_userProfileKey);
      } catch (_) {
        throw StorageServiceException.loadProfile;
      }
      return null;
    }
  }

  Future<void> saveProgressEntry(ProgressEntry entry) async {
    entry.validate();
    try {
      final entries = await getProgressHistory();
      entries.add(entry);
      final jsonList = entries.map((e) => e.toJson()).toList();
      await _secureStore.write(_progressHistoryKey, jsonEncode(jsonList));
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.saveProgress;
    }
  }

  Future<List<ProgressEntry>> getProgressHistory() async {
    String? data;
    try {
      await _ready;
      data = await _secureStore.read(_progressHistoryKey);
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.loadProgress;
    }
    if (data == null) return [];

    try {
      final list = jsonDecode(data) as List;
      return list
          .map((e) => ProgressEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      try {
        await _secureStore.delete(_progressHistoryKey);
      } catch (_) {
        throw StorageServiceException.loadProgress;
      }
      return [];
    }
  }

  Future<String> exportData() async {
    try {
      final profile = await getUserProfile();
      final progress = await getProgressHistory();
      return const JsonEncoder.withIndent('  ').convert({
        'schemaVersion': 1,
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'profile': profile?.toJson(),
        'progress': [
          for (final entry in progress) entry.toJson(),
        ],
      });
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.export;
    }
  }

  Future<void> resetAll() async {
    try {
      final prefs = await _ready;
      await _secureStore.delete(_userProfileKey);
      await _secureStore.delete(_progressHistoryKey);
      await prefs.remove(_userProfileKey);
      await prefs.remove(_progressHistoryKey);
    } catch (error) {
      if (error is StorageServiceException) rethrow;
      throw StorageServiceException.reset;
    }
  }

  Future<void> _migrateLegacyValue(SharedPreferences prefs, String key) async {
    final legacyValue = prefs.getString(key);
    if (legacyValue == null) return;

    final alreadyMigrated = await _secureStore.containsKey(key);
    if (!alreadyMigrated) {
      await _secureStore.write(key, legacyValue);
    }
    await prefs.remove(key);
  }
}
