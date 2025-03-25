/// PersistentContainerIndexNotifier
/// 
/// A state management class that synchronizes the selected container index across local state, storage, and server. // Eine State-Management-Klasse, die den ausgewählten Container-Index zwischen lokalem State, Speicher und Server synchronisiert.
/// Used to maintain consistent UI selection state across app sessions and device logins. // Wird verwendet, um einen konsistenten UI-Auswahlzustand über App-Sitzungen und Geräte-Logins hinweg aufrechtzuerhalten.
/// 
/// Usage:
/// ```dart
/// // Read the current container index
/// final currentIndex = ref.watch(persistentContainerIndexProvider);
/// 
/// // Update the container index
/// ref.read(persistentContainerIndexProvider.notifier).updateIndex(2);
/// ```
/// 
/// EN: Manages and persists the selected tab or container index with three-way synchronization between UI state, local storage, and server.
/// DE: Verwaltet und persistiert den ausgewählten Tab- oder Container-Index mit Drei-Wege-Synchronisation zwischen UI-Zustand, lokalem Speicher und Server.

import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod for state management.  // Importiert Riverpod für das State-Management. 
import '../repository/auth_repository.dart';  // Import the authentication repository.  // Importiert das Authentifizierungs-Repository.
import '../repository/local_storage_repository.dart';  // Import the local storage repository.  // Importiert das lokale Speicher-Repository.
import 'providers.dart';  // Import other providers.  // Importiert andere Provider.

class PersistentContainerIndexNotifier extends StateNotifier<int> {  // Create a state notifier class for managing container index.  // Erstellt eine StateNotifier-Klasse zur Verwaltung des Container-Index.
  final LocalStorageRepository _localStorageRepository;  // Reference to local storage repository.  // Referenz zum lokalen Speicher-Repository.
  final AuthRepository _authRepository;  // Reference to authentication repository.  // Referenz zum Authentifizierungs-Repository.

  PersistentContainerIndexNotifier(this._localStorageRepository, this._authRepository) : super(0) {  // Constructor with dependency injection, initializing with default value 0.  // Konstruktor mit Dependency Injection, initialisiert mit Standardwert 0.
    _init();  // Call initialization method.  // Ruft die Initialisierungsmethode auf.
  }

  Future<void> _init() async {  // Private initialization method.  // Private Initialisierungsmethode.
    // Load the saved index from local storage  // Lädt den gespeicherten Index aus dem lokalen Speicher.
    final savedIndex = await _localStorageRepository.getSelectedContainerIndex();  // Get the saved index.  // Holt den gespeicherten Index.
    state = savedIndex;  // Update the state with the saved index.  // Aktualisiert den State mit dem gespeicherten Index.
  }

  Future<void> updateIndex(int newIndex) async {  // Method to update the index.  // Methode zum Aktualisieren des Index.
    state = newIndex;  // Update the state with the new index.  // Aktualisiert den State mit dem neuen Index.
    // Save to local storage  // Speichert im lokalen Speicher.
     _localStorageRepository.setSelectedContainerIndex(newIndex);  // Save the new index to local storage.  // Speichert den neuen Index im lokalen Speicher.
    // Update server state  // Aktualisiert den Server-State.
    await _authRepository.updateUserContainerIndex(newIndex);  // Update the index on the server.  // Aktualisiert den Index auf dem Server.
  }
}

final persistentContainerIndexProvider = StateNotifierProvider<PersistentContainerIndexNotifier, int>((ref) {  // Create a StateNotifierProvider for the container index.  // Erstellt einen StateNotifierProvider für den Container-Index.
  final localStorageRepository = ref.read(localStorageRepositoryProvider);  // Get the local storage repository.  // Holt das lokale Speicher-Repository.
  final authRepository = ref.read(authRepositoryProvider);  // Get the authentication repository.  // Holt das Authentifizierungs-Repository.
  return PersistentContainerIndexNotifier(localStorageRepository, authRepository);  // Return a new notifier instance with dependencies.  // Gibt eine neue Notifier-Instanz mit Abhängigkeiten zurück.
});
