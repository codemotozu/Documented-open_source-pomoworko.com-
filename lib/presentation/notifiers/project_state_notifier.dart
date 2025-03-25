/// ProjectStateManager
/// 
/// A state management system for tracking and modifying project names in a productivity application. // Ein Zustandsverwaltungssystem zur Verfolgung und Änderung von Projektnamen in einer Produktivitätsanwendung.
/// Synchronizes project data between UI, local storage, and server for cross-device persistence. // Synchronisiert Projektdaten zwischen UI, lokalem Speicher und Server für geräteübergreifende Persistenz.
/// 
/// Usage:
/// ```dart
/// // Access the current list of project names
/// final projectNames = ref.watch(projectStateNotifierProvider);
/// 
/// // Add or update a project
/// ref.read(projectStateNotifierProvider.notifier).addProject("My New Project", 2, ref);
/// 
/// // Delete a project
/// ref.read(projectStateNotifierProvider.notifier).deleteProject(1);
/// 
/// // Get a specific project name
/// final projectName = ref.read(projectStateNotifierProvider.notifier).getProject(0);
/// ```
/// 
/// EN: Manages project data with multi-location persistence and provides utilities for creating, reading, updating, and deleting projects.
/// DE: Verwaltet Projektdaten mit Mehrfach-Persistenz und bietet Dienstprogramme zum Erstellen, Lesen, Aktualisieren und Löschen von Projekten.

import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import the Riverpod package for state management.  // Importiert das Riverpod-Paket für das Zustandsmanagement. 
import 'package:pomoworko/presentation/notifiers/providers.dart';  // Import local providers.  // Importiert lokale Provider.

import '../repository/auth_repository.dart';  // Import authentication repository.  // Importiert das Authentifizierungs-Repository.
import '../repository/local_storage_repository.dart';  // Import local storage repository.  // Importiert das lokale Speicher-Repository.
import 'persistent_container_notifier.dart';  // Import persistent container notifier.  // Importiert den persistenten Container-Notifier.
import 'project_time_notifier.dart';  // Import project time notifier.  // Importiert den Projektzeitnotifier.

class ProjectStateNotifier extends StateNotifier<List<String>> {  // Define a state notifier class to manage project names.  // Definiert eine StateNotifier-Klasse zur Verwaltung von Projektnamen.
  final LocalStorageRepository _localStorageRepository;  // Repository for local storage operations.  // Repository für lokale Speicheroperationen.
  final Ref _ref;  // Reference to the provider container.  // Referenz zum Provider-Container.
  ProjectStateNotifier(this._localStorageRepository, this._ref) : super(['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']);  // Constructor with initial state of four default projects.  // Konstruktor mit Anfangszustand von vier Standardprojekten.

  void selectProject(int index) async {  // Method to select a project by index.  // Methode zur Auswahl eines Projekts nach Index.
    if (index >= state.length) {  // If the index is out of bounds.  // Wenn der Index außerhalb der Grenzen liegt.
      state = [...state, ...List.filled(index - state.length + 1, 'Add a project ')];  // Expand the list to accommodate the index.  // Erweitert die Liste, um den Index aufzunehmen.
    }
    // Save selected index  // Speichert den ausgewählten Index.
    _localStorageRepository.setSelectedContainerIndex(index);  // Store the selected index in local storage.  // Speichert den ausgewählten Index im lokalen Speicher.
    print('Current Project Names: $state');  // Debug print of all project names.  // Debug-Ausgabe aller Projektnamen.
    print('Selected Project Index: $index');  // Debug print of selected index.  // Debug-Ausgabe des ausgewählten Index.
    print('Current Project Name: ${state[index]}');  // Debug print of current project name.  // Debug-Ausgabe des aktuellen Projektnamens.
  }

void addProject(String projectName, int index, WidgetRef ref) async {  // Method to add or update a project.  // Methode zum Hinzufügen oder Aktualisieren eines Projekts.
  final auth = ref.read(authRepositoryProvider);  // Get the auth repository.  // Holt das Auth-Repository.
  final result = await auth.updateProjectName(projectName, index);  // Update the project name on the server.  // Aktualisiert den Projektnamen auf dem Server.
  
  if (result.error == null) {  // If the server update was successful.  // Wenn die Serveraktualisierung erfolgreich war.
    List<String> newState;  // Declare a new state list.  // Deklariert eine neue Zustandsliste.
    if (index >= state.length) {  // If the index is out of bounds.  // Wenn der Index außerhalb der Grenzen liegt.
      newState = [...state, ...List.filled(index - state.length, 'Add a project '), projectName];  // Add empty projects and the new one.  // Fügt leere Projekte und das neue hinzu.
    } else {  // If the index is within bounds.  // Wenn der Index innerhalb der Grenzen liegt.
      newState = [...state];  // Create a copy of the current state.  // Erstellt eine Kopie des aktuellen Zustands.
      newState[index] = projectName;  // Update the project name at the specified index.  // Aktualisiert den Projektnamen am angegebenen Index.
    }
    state = newState;  // Update the state with the new project list.  // Aktualisiert den Zustand mit der neuen Projektliste.

    // Save to local storage  // Speichert im lokalen Speicher.
    _localStorageRepository.saveProjectNames(newState);  // Persist the project names in local storage.  // Speichert die Projektnamen dauerhaft im lokalen Speicher.
      
    // Update the selected container index  // Aktualisiert den ausgewählten Container-Index.
    ref.read(persistentContainerIndexProvider.notifier).updateIndex(index);  // Set the selected project in the UI.  // Setzt das ausgewählte Projekt in der Benutzeroberfläche.
  }
}

  void updateProject(int index, String newProjectName) {  // Method to update a project name.  // Methode zur Aktualisierung eines Projektnamens.
    if (index < state.length) {  // If the index is valid.  // Wenn der Index gültig ist.
      final newState = [...state];  // Create a copy of the current state.  // Erstellt eine Kopie des aktuellen Zustands.
      newState[index] = newProjectName;  // Update the project name.  // Aktualisiert den Projektnamen.
      state = newState;  // Update the state.  // Aktualisiert den Zustand.

      // Save to local storage  // Speichert im lokalen Speicher.
      _localStorageRepository.saveProjectNames(newState);  // Persist the updated names.  // Speichert die aktualisierten Namen dauerhaft.
    }
    print('Updated project at index $index: $newProjectName');  // Debug print of the update.  // Debug-Ausgabe der Aktualisierung.
    print('Current Project Names: $state');  // Debug print of all project names.  // Debug-Ausgabe aller Projektnamen.
  }

  // In project_state_notifier.dart  // In project_state_notifier.dart
void deleteProject(int index) async {  // Method to delete (reset) a project.  // Methode zum Löschen (Zurücksetzen) eines Projekts.
  state = List.from(state);  // Create a mutable copy of the state.  // Erstellt eine veränderbare Kopie des Zustands.
  if (index < state.length) {  // If the index is valid.  // Wenn der Index gültig ist.
    state[index] = 'Add a project ';  // Reset the project name to default.  // Setzt den Projektnamen auf den Standardwert zurück.
    
    // Clear the project data in the time provider  // Löscht die Projektdaten im Zeitprovider.
    _ref.read(projectTimesProvider.notifier).clearProjectData(index);  // Clean up associated time tracking data.  // Bereinigt zugehörige Zeiterfassungsdaten.
    // Save to local storage  // Speichert im lokalen Speicher.
    _localStorageRepository.saveProjectNames(state);  // Persist the changes.  // Speichert die Änderungen dauerhaft.
  }
}

  String getProject(int index) {  // Method to get a project name by index.  // Methode zum Abrufen eines Projektnamens nach Index.
    return index < state.length ? state[index] : 'Add a project ';  // Return the project name or default if index is out of bounds.  // Gibt den Projektnamen oder den Standardwert zurück, wenn der Index außerhalb der Grenzen liegt.
  }
}

final projectStateNotifierProvider = StateNotifierProvider<ProjectStateNotifier, List<String>>((ref) {  // Provider for the project state notifier.  // Provider für den Projekt-Zustandsnotifier.
  final localStorageRepository = ref.read(localStorageRepositoryProvider);  // Get the local storage repository.  // Holt das lokale Speicher-Repository.
  return ProjectStateNotifier(localStorageRepository, ref);  // Create and return the notifier.  // Erstellt und gibt den Notifier zurück.
});

final selectedProjectIndexProvider = StateProvider<int>((ref) => 0);  // Provider to track the selected project index.  // Provider zur Verfolgung des ausgewählten Projektindex.
final currentProjectProvider = StateProvider<String?>((ref) => null);  // Provider to track the current project name.  // Provider zur Verfolgung des aktuellen Projektnamens.
