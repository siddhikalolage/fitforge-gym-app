import '../models/progress_entry.dart';
import '../models/user_profile.dart';

class RepositoryException implements Exception {
  final String message;

  const RepositoryException._(this.message);

  static const initialization = RepositoryException._(
    'Secure local storage is unavailable. Please restart the app and try again.',
  );
  static const saveProfile = RepositoryException._(
    'Unable to save your profile securely. Please try again.',
  );
  static const loadProfile = RepositoryException._(
    'Unable to load your profile securely. Please try again.',
  );
  static const saveProgress = RepositoryException._(
    'Unable to save progress securely. Please try again.',
  );
  static const loadProgress = RepositoryException._(
    'Unable to load progress securely. Please try again.',
  );
  static const export = RepositoryException._(
    'Unable to prepare your data export. Please try again.',
  );
  static const reset = RepositoryException._(
    'Unable to delete local data securely. Please try again.',
  );

  @override
  String toString() => 'RepositoryException: $message';
}

abstract interface class FitForgeRepository {
  Future<void> init();

  Future<bool> hasUserProfile();

  Future<UserProfile?> getUserProfile();

  Future<void> saveUserProfile(UserProfile profile);

  Future<List<ProgressEntry>> getProgressHistory();

  Future<void> saveProgressEntry(ProgressEntry entry);

  Future<String> exportData();

  Future<void> resetAll();
}
