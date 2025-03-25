/// SoundStateManager
/// 
/// A state management component that handles the selection and updating of notification sounds. // Eine Zustandsverwaltungskomponente, die die Auswahl und Aktualisierung von Benachrichtigungstönen verwaltet.
/// Used to maintain the current sound selection throughout the application for consistent audio feedback. // Wird verwendet, um die aktuelle Soundauswahl in der gesamten Anwendung für konsistentes Audio-Feedback zu erhalten.
/// 
/// Usage:
/// ```dart
/// // Create a provider with the sound notifier
/// final soundProvider = StateNotifierProvider<SoundNotifier, Sound>((ref) {
///   return SoundNotifier(initialSound: defaultSound);
/// });
/// 
/// // Update the selected sound
/// ref.read(soundProvider.notifier).updateSound(newSound);
/// 
/// // Access the current sound
/// final currentSound = ref.watch(soundProvider);
/// ```
/// 
/// EN: Manages the application's currently selected notification sound with Riverpod state management.
/// DE: Verwaltet den aktuell ausgewählten Benachrichtigungston der Anwendung mit Riverpod-Zustandsverwaltung.

import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports the Riverpod package for state management.  // Importiert das Riverpod-Paket für die Zustandsverwaltung. 
import '../../common/widgets/domain/entities/sound_entity.dart';  // Imports the Sound entity class from the project structure.  // Importiert die Sound-Entitätsklasse aus der Projektstruktur.

class SoundNotifier extends StateNotifier<Sound> {  // Defines a class that extends StateNotifier with Sound type to manage the sound state.  // Definiert eine Klasse, die StateNotifier mit dem Typ Sound erweitert, um den Sound-Zustand zu verwalten.
  SoundNotifier({required Sound initialSound}) : super(initialSound);  // Constructor that requires an initial Sound and passes it to the parent constructor.  // Konstruktor, der einen initialen Sound erfordert und diesen an den übergeordneten Konstruktor weitergibt.
  void updateSound(Sound newSound) {  // Method to update the current sound with a new one.  // Methode zur Aktualisierung des aktuellen Sounds mit einem neuen.
    state = newSound;  // Sets the state to the new Sound value.  // Setzt den Zustand auf den neuen Sound-Wert.
  }
}
