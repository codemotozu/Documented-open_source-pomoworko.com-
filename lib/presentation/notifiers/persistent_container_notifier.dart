import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../repository/local_storage_repository.dart';
import 'providers.dart';

class PersistentContainerIndexNotifier extends StateNotifier<int> {
  final LocalStorageRepository _localStorageRepository;
  final AuthRepository _authRepository;

  PersistentContainerIndexNotifier(this._localStorageRepository, this._authRepository) : super(0) {
    _init();
  }

  Future<void> _init() async {
    // Load the saved index from local storage
    final savedIndex = await _localStorageRepository.getSelectedContainerIndex();
    state = savedIndex;
  }

  Future<void> updateIndex(int newIndex) async {
    state = newIndex;
    // Save to local storage
     _localStorageRepository.setSelectedContainerIndex(newIndex);
    // Update server state
    await _authRepository.updateUserContainerIndex(newIndex);
  }
}

final persistentContainerIndexProvider = StateNotifierProvider<PersistentContainerIndexNotifier, int>((ref) {
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  final authRepository = ref.read(authRepositoryProvider);
  return PersistentContainerIndexNotifier(localStorageRepository, authRepository);
});