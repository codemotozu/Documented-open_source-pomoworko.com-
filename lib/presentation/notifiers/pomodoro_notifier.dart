import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import the Riverpod package for state management.  // Importiert das Riverpod-Paket für das Zustandsmanagement.
import '../../infrastructure/data_sources/hive_services.dart';  // Import Hive services for local data storage.  // Importiert Hive-Dienste für die lokale Datenspeicherung.  
import '../repository/auth_repository.dart';  // Import the authentication repository.  // Importiert das Authentifizierungs-Repository.


class PomodoroNotifier extends StateNotifier<PomodoroState> {  // Define a state notifier class for Pomodoro management.  // Definiert eine StateNotifier-Klasse für die Pomodoro-Verwaltung.
  PomodoroNotifier(this.ref) : super(PomodoroState([])) {  // Constructor that initializes with empty state and loads existing progress.  // Konstruktor, der mit leerem Zustand initialisiert und bestehenden Fortschritt lädt.
    _loadProgress();  // Call method to load saved progress.  // Ruft die Methode zum Laden des gespeicherten Fortschritts auf.
  }

  final Ref ref;  // Reference to the Riverpod provider scope.  // Referenz auf den Riverpod-Provider-Scope.

    void updateStates(List<bool> newStates) {  // Method to update Pomodoro states.  // Methode zum Aktualisieren der Pomodoro-Zustände.
    state = PomodoroState(newStates);  // Update the state with new values.  // Aktualisiert den Zustand mit neuen Werten.
    HiveServices.saveUserProgress(newStates);  // Save the new states in local storage.  // Speichert die neuen Zustände im lokalen Speicher.
  }

  Future<void> _loadProgress() async {  // Asynchronous method to load saved Pomodoro progress.  // Asynchrone Methode zum Laden des gespeicherten Pomodoro-Fortschritts.
    final user = ref.read(userProvider);  // Read current user from the provider.  // Liest den aktuellen Benutzer aus dem Provider.
    if (user != null) {  // If a user is logged in...  // Wenn ein Benutzer angemeldet ist...
      state = PomodoroState(user.pomodoroStates);  // Set state from user's saved Pomodoro states.  // Setzt den Zustand aus den gespeicherten Pomodoro-Zuständen des Benutzers.
    } else {  // If no user is logged in...  // Wenn kein Benutzer angemeldet ist...
      final progress = await HiveServices.retrieveUserProgress();  // Retrieve progress from local storage.  // Ruft den Fortschritt aus dem lokalen Speicher ab.
      state = PomodoroState(progress);  // Set state from locally stored progress.  // Setzt den Zustand aus dem lokal gespeicherten Fortschritt.
    }
  }

  Future<void> _syncWithBackend() async {  // Asynchronous method to sync Pomodoro states with the backend.  // Asynchrone Methode zur Synchronisierung der Pomodoro-Zustände mit dem Backend.
    final result = await ref.read(authRepositoryProvider).updatePomodoroStates(state.pomodoros);  // Send update to backend and get result.  // Sendet Update an das Backend und erhält Ergebnis.
    if (result.error == null) {  // If the update was successful...  // Wenn das Update erfolgreich war...
      state = PomodoroState(result.data);  // Update local state with confirmed data from backend.  // Aktualisiert den lokalen Zustand mit bestätigten Daten vom Backend.
    }
  }

  void startNewPomodoro() {  // Method to start a new Pomodoro session.  // Methode zum Starten einer neuen Pomodoro-Sitzung.
    state = state.copyWith(
      pomodoros: [...state.pomodoros, false],  // Add a new incomplete Pomodoro to the list.  // Fügt einen neuen unvollständigen Pomodoro zur Liste hinzu.
    );
    HiveServices.saveUserProgress(state.pomodoros);  // Save updated progress locally.  // Speichert den aktualisierten Fortschritt lokal.
    _syncWithBackend();  // Sync changes with backend.  // Synchronisiert Änderungen mit dem Backend.
  }

  void finishCurrentPomodoro() {  // Method to mark the current Pomodoro as completed.  // Methode zum Markieren des aktuellen Pomodoros als abgeschlossen.
    if (state.pomodoros.isNotEmpty) {  // If there are any Pomodoros in the list...  // Wenn es Pomodoros in der Liste gibt...
      state = state.copyWith(
        pomodoros: List.from(state.pomodoros)
          ..[state.pomodoros.length - 1] = true,  // Mark the last Pomodoro as completed.  // Markiert den letzten Pomodoro als abgeschlossen.
      );
      HiveServices.saveUserProgress(state.pomodoros);  // Save updated progress locally.  // Speichert den aktualisierten Fortschritt lokal.
      _syncWithBackend();  // Sync changes with backend.  // Synchronisiert Änderungen mit dem Backend.
    }
  }

  void resetPomodoros() {  // Method to reset all Pomodoro progress.  // Methode zum Zurücksetzen des gesamten Pomodoro-Fortschritts.
    state = PomodoroState([]);  // Reset to empty state.  // Setzt auf leeren Zustand zurück.
    HiveServices.saveUserProgress([]);  // Save empty progress locally.  // Speichert leeren Fortschritt lokal.
    _syncWithBackend();  // Sync changes with backend.  // Synchronisiert Änderungen mit dem Backend.
  }
}


class PomodoroState {  // Define a class to represent Pomodoro state.  // Definiert eine Klasse zur Darstellung des Pomodoro-Zustands.
  final List<bool> pomodoros;  // List of boolean values representing completed/uncompleted Pomodoros.  // Liste von booleschen Werten, die abgeschlossene/unvollständige Pomodoros darstellen.

  PomodoroState(this.pomodoros);  // Constructor that takes a list of Pomodoro states.  // Konstruktor, der eine Liste von Pomodoro-Zuständen übernimmt.

  PomodoroState copyWith({List<bool>? pomodoros}) {  // Method to create a copy with optional new values.  // Methode zum Erstellen einer Kopie mit optionalen neuen Werten.
    return PomodoroState(
      pomodoros ?? this.pomodoros,  // Use provided pomodoros or current ones if not provided.  // Verwendet die übergebenen Pomodoros oder die aktuellen, wenn keine übergeben wurden.
    );
  }
}
