import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/progress_entry.dart';
import 'secure_key_value_store.dart';

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
    await _initFuture;
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
    await _ready;
    return _secureStore.containsKey(_userProfileKey);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    await _ready;
    await _secureStore.write(_userProfileKey, jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> getUserProfile() async {
    await _ready;
    final data = await _secureStore.read(_userProfileKey);
    if (data == null) return null;

    try {
      return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (_) {
      await _secureStore.delete(_userProfileKey);
      return null;
    }
  }

  Future<void> saveProgressEntry(ProgressEntry entry) async {
    final entries = await getProgressHistory();
    entries.add(entry);
    final jsonList = entries.map((e) => e.toJson()).toList();
    await _secureStore.write(_progressHistoryKey, jsonEncode(jsonList));
  }

  Future<List<ProgressEntry>> getProgressHistory() async {
    await _ready;
    final data = await _secureStore.read(_progressHistoryKey);
    if (data == null) return [];

    try {
      final list = jsonDecode(data) as List;
      return list
          .map((e) => ProgressEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await _secureStore.delete(_progressHistoryKey);
      return [];
    }
  }

  Future<void> resetAll() async {
    final prefs = await _ready;
    await _secureStore.deleteAll();
    await prefs.remove(_userProfileKey);
    await prefs.remove(_progressHistoryKey);
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
