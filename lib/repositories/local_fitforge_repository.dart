import '../models/progress_entry.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import 'fitforge_repository.dart';

class LocalFitForgeRepository implements FitForgeRepository {
  LocalFitForgeRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  final StorageService _storageService;

  @override
  Future<void> init() => _storageService.init();

  @override
  Future<bool> hasUserProfile() => _storageService.hasUserProfile();

  @override
  Future<UserProfile?> getUserProfile() => _storageService.getUserProfile();

  @override
  Future<void> saveUserProfile(UserProfile profile) =>
      _storageService.saveUserProfile(profile);

  @override
  Future<List<ProgressEntry>> getProgressHistory() =>
      _storageService.getProgressHistory();

  @override
  Future<void> saveProgressEntry(ProgressEntry entry) =>
      _storageService.saveProgressEntry(entry);

  @override
  Future<String> exportData() => _storageService.exportData();

  @override
  Future<void> resetAll() => _storageService.resetAll();
}
