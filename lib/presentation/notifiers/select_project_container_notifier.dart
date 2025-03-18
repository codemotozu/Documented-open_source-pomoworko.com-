import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports the Riverpod package for state management.  // Importiert das Riverpod-Paket für die Zustandsverwaltung. 
// This provider changes the color of the project container.  // Dieser Provider ändert die Farbe des Projektcontainers.
class SelectedProjecContainerColortNotifier extends StateNotifier<int> {  // Defines a class that extends StateNotifier with integer state to manage selected project container color.  // Definiert eine Klasse, die StateNotifier mit Integer-Zustand erweitert, um die ausgewählte Projektcontainerfarbe zu verwalten.
  SelectedProjecContainerColortNotifier() : super(0);  // Constructor initializes the state to 0 (default color index).  // Konstruktor initialisiert den Zustand auf 0 (Standard-Farbindex).
  void updateSelectedContainerColorProject(int index) {  // Method to update the selected container color project index.  // Methode zur Aktualisierung des ausgewählten Container-Farbprojektindex.
    state = index;  // Updates the state to the new index value.  // Aktualisiert den Zustand auf den neuen Indexwert.
  }
}
final selectedProyectContainerProvider = StateNotifierProvider<SelectedProjecContainerColortNotifier, int>((ref) {  // Creates a provider that exposes the SelectedProjecContainerColortNotifier and its integer state.  // Erstellt einen Provider, der den SelectedProjecContainerColortNotifier und seinen Integer-Zustand bereitstellt.
  return SelectedProjecContainerColortNotifier();  // Returns a new instance of the notifier class.  // Gibt eine neue Instanz der Notifier-Klasse zurück.
});
