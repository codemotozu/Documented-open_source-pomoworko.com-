/// PomodoroStateManagement
/// 
/// A comprehensive collection of state providers that manage all aspects of the Pomodoro productivity application. // Eine umfassende Sammlung von State-Providern, die alle Aspekte der Pomodoro-Produktivitätsanwendung verwalten.
/// Coordinates timers, sounds, notifications, themes, UI states, and user preferences throughout the application. // Koordiniert Timer, Sounds, Benachrichtigungen, Themes, UI-Zustände und Benutzereinstellungen in der gesamten Anwendung.
/// 
/// Usage / Verwendung:
/// ```dart
/// // Access timer values
/// final pomodoroLength = ref.watch(pomodoroTimerProvider);
/// final shortBreakLength = ref.watch(shortBreakProvider);
/// 
/// // Check if timer is running
/// final isRunning = ref.watch(isTimerRunningProvider);
/// 
/// // Change notification sound
/// ref.read(selectedSoundProvider.notifier).updateSound(newSound);
/// 
/// // Toggle dark/light theme
/// ref.read(themeModeProvider.notifier).toggle();
/// ```
/// 
/// EN: Centralizes the application's state management using Riverpod providers for a consistent, reactive, and synchronized user experience across features.
/// DE: Zentralisiert das Zustandsmanagement der Anwendung mithilfe von Riverpod-Providern für eine konsistente, reaktive und synchronisierte Benutzererfahrung über alle Funktionen hinweg.

import 'package:flutter/material.dart';  // Imports Flutter material design package for UI components.  // Importiert das Flutter Material-Design-Paket für UI-Komponenten. 
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management.  // Importiert Riverpod für State-Management.
import 'package:just_audio/just_audio.dart';  // Imports Just Audio package for audio playback.  // Importiert das Just Audio-Paket für die Audiowiedergabe.
import '../../common/widgets/domain/entities/sound_entity.dart';  // Imports the Sound entity class.  // Importiert die Sound-Entitätsklasse.
import '../../common/widgets/domain/entities/todo_entity.dart';  // Imports the Todo entity class.  // Importiert die Todo-Entitätsklasse.
import '../../infrastructure/data_sources/hive_services.dart';  // Imports Hive services for local data storage.  // Importiert Hive-Dienste für lokale Datenspeicherung.
import '../repository/local_storage_repository.dart';  // Imports the local storage repository.  // Importiert das lokale Speicher-Repository.
import 'pomodoro_notifier.dart';  // Imports the Pomodoro notifier for state updates.  // Importiert den Pomodoro-Notifier für State-Updates.


final completedWorkPeriodsProvider = StateProvider<int>((ref) => 0);  // Provider to track completed work periods, initialized to 0.  // Provider, der abgeschlossene Arbeitsperioden zählt, initialisiert mit 0.

final pomodoroTimerProvider = StateProvider<int>((ref) => 0);  // Provider for the Pomodoro timer value, initialized to 0.  // Provider für den Pomodoro-Timer-Wert, initialisiert mit 0.

final shortBreakProvider = StateProvider<int>((ref) => 0);  // Provider for the short break timer value, initialized to 0.  // Provider für den Kurzpausen-Timer-Wert, initialisiert mit 0.
final longBreakProvider = StateProvider<int>((ref) => 0);  // Provider for the long break timer value, initialized to 0.  // Provider für den Langpausen-Timer-Wert, initialisiert mit 0.

final currentTimerProvider =
    StateProvider<int>((ref) => ref.read(pomodoroTimerProvider));  // Provider for the current active timer, initialized with the Pomodoro timer value.  // Provider für den aktuell aktiven Timer, initialisiert mit dem Pomodoro-Timer-Wert.

final longBreakIntervalProvider = StateProvider<int>((ref) => 4);  // Provider for the number of Pomodoros before a long break, default is 4.  // Provider für die Anzahl der Pomodoros vor einer langen Pause, Standardwert ist 4.

final timerInitProvider = FutureProvider<void>((ref) async {  // Future provider that initializes timer values from local storage.  // Future-Provider, der Timer-Werte aus dem lokalen Speicher initialisiert.
  final pomodoroTime = await HiveServices.retrieveDefaultPomodoroTimerValue(
      HiveServices.pomodoroKey);  // Retrieves the saved Pomodoro timer value from Hive storage.  // Ruft den gespeicherten Pomodoro-Timer-Wert aus dem Hive-Speicher ab.
  ref.read(pomodoroTimerProvider.notifier).state = pomodoroTime;  // Updates the Pomodoro timer state with the retrieved value.  // Aktualisiert den Pomodoro-Timer-State mit dem abgerufenen Wert.

  final shortBreakTime = await HiveServices.retrieveDefaultShortBreakTimerValue(
      HiveServices.shortBreakKey);  // Retrieves the saved short break timer value from Hive storage.  // Ruft den gespeicherten Kurzpausen-Timer-Wert aus dem Hive-Speicher ab.
  ref.read(shortBreakProvider.notifier).state = shortBreakTime;  // Updates the short break timer state with the retrieved value.  // Aktualisiert den Kurzpausen-Timer-State mit dem abgerufenen Wert.

  final longBreakTime = await HiveServices.retrieveDefaultLongBreakTimerValue(
      HiveServices.longBreakKey);  // Retrieves the saved long break timer value from Hive storage.  // Ruft den gespeicherten Langpausen-Timer-Wert aus dem Hive-Speicher ab.
  ref.read(longBreakProvider.notifier).state = longBreakTime;  // Updates the long break timer state with the retrieved value.  // Aktualisiert den Langpausen-Timer-State mit dem abgerufenen Wert.

  final longBreakInterval =
      await HiveServices.retrieveDefaultLongBreakIntervalValue(
          HiveServices.longBreakIntervalKey);  // Retrieves the saved long break interval value from Hive storage.  // Ruft den gespeicherten Wert für das Langpausen-Intervall aus dem Hive-Speicher ab.
  ref.read(longBreakIntervalProvider.notifier).state = longBreakInterval;  // Updates the long break interval state with the retrieved value.  // Aktualisiert den State für das Langpausen-Intervall mit dem abgerufenen Wert.
});

final soundInitProvider = FutureProvider<void>((ref) async {  // Future provider that initializes sound settings from local storage.  // Future-Provider, der Soundeinstellungen aus dem lokalen Speicher initialisiert.
  final alarmSoundPath = await HiveServices.retrieveAlarmSoundValue();  // Retrieves the saved alarm sound path from Hive storage.  // Ruft den gespeicherten Alarm-Sound-Pfad aus dem Hive-Speicher ab.
  final soundList = ref.read(soundListProvider);  // Reads the list of available sounds.  // Liest die Liste der verfügbaren Sounds.
  final sound = soundList.firstWhere((sound) => sound.path == alarmSoundPath);  // Finds the sound object that matches the saved path.  // Findet das Sound-Objekt, das dem gespeicherten Pfad entspricht.

  ref.read(selectedSoundProvider.notifier).updateSound(sound);  // Updates the selected sound state with the found sound.  // Aktualisiert den ausgewählten Sound-State mit dem gefundenen Sound.
});

final isTimerRunningProvider = StateProvider<bool>((ref) => false);  // Provider to track whether the timer is currently running, initialized to false.  // Provider, der verfolgt, ob der Timer gerade läuft, initialisiert mit false.

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());  // Provider that creates an AudioPlayer instance for playing sounds.  // Provider, der eine AudioPlayer-Instanz zum Abspielen von Sounds erstellt.


final selectedSoundProvider = StateNotifierProvider<SelectedSoundNotifier, Sound>((ref) {  // StateNotifierProvider for managing the currently selected sound.  // StateNotifierProvider zur Verwaltung des aktuell ausgewählten Sounds.
  final soundMap = ref.watch(soundMapProvider);  // Watches the sound map to get all available sounds.  // Beobachtet die Sound-Map, um alle verfügbaren Sounds zu erhalten.
  return SelectedSoundNotifier(soundMap: soundMap);  // Returns a new SelectedSoundNotifier with the sound map.  // Gibt einen neuen SelectedSoundNotifier mit der Sound-Map zurück.
});

class SelectedSoundNotifier extends StateNotifier<Sound> {  // StateNotifier class to manage the selected sound state.  // StateNotifier-Klasse zur Verwaltung des ausgewählten Sound-States.
  final Map<String, Sound> soundMap;  // Map of sound paths to Sound objects.  // Map von Sound-Pfaden zu Sound-Objekten.

  SelectedSoundNotifier({required this.soundMap}) 
    : super(soundMap['assets/sounds/Flashpoint.wav']!);  // Constructor that initializes with the default Flashpoint sound.  // Konstruktor, der mit dem Standard-Flashpoint-Sound initialisiert wird.

  void updateSound(Sound newSound) {  // Method to update the selected sound with a new Sound object.  // Methode zum Aktualisieren des ausgewählten Sounds mit einem neuen Sound-Objekt.
    state = newSound;  // Sets the state to the new sound.  // Setzt den State auf den neuen Sound.
  }

  void updateSoundFromPath(String path) {  // Method to update the selected sound using a path string.  // Methode zum Aktualisieren des ausgewählten Sounds mit einem Pfad-String.
    state = soundMap[path] ?? soundMap['assets/sounds/Flashpoint.wav']!;  // Sets the state to the sound at the given path, or defaults to Flashpoint if not found.  // Setzt den State auf den Sound am angegebenen Pfad oder standardmäßig auf Flashpoint, wenn nicht gefunden.
  }
}


final soundMapProvider = Provider<Map<String, Sound>>((ref) {  // Provider that creates a map of sound paths to Sound objects.  // Provider, der eine Map von Sound-Pfaden zu Sound-Objekten erstellt.
  final sounds = ref.watch(soundListProvider);  // Watches the sound list to get all available sounds.  // Beobachtet die Sound-Liste, um alle verfügbaren Sounds zu erhalten.
  return {for (var sound in sounds) sound.path: sound};  // Creates a map with sound paths as keys and Sound objects as values.  // Erstellt eine Map mit Sound-Pfaden als Schlüssel und Sound-Objekten als Werte.
});

final soundListProvider = Provider<List<Sound>>((ref) => [  // Provider that defines the list of available sounds.  // Provider, der die Liste der verfügbaren Sounds definiert.
      const Sound(
        path: 'assets/sounds/Flashpoint.wav',
        friendlyName: 'Flashpoint ⚡',
      ),  // Defines the Flashpoint sound with its path and friendly name.  // Definiert den Flashpoint-Sound mit seinem Pfad und benutzerfreundlichen Namen.
      const Sound(
        path: 'assets/sounds/Plink.wav',
        friendlyName: 'Plink 🎯',
      ),  // Defines the Plink sound with its path and friendly name.  // Definiert den Plink-Sound mit seinem Pfad und benutzerfreundlichen Namen.
      const Sound(
        path: 'assets/sounds/Blink.wav',
        friendlyName: 'Blink 👁️',
      ),  // Defines the Blink sound with its path and friendly name.  // Definiert den Blink-Sound mit seinem Pfad und benutzerfreundlichen Namen.
    ]);


final browserNotificationsProvider = StateNotifierProvider<BrowserNotificationsNotifier, bool>((ref) {  // StateNotifierProvider for managing browser notification settings.  // StateNotifierProvider zur Verwaltung der Browser-Benachrichtigungseinstellungen.
  return BrowserNotificationsNotifier();  // Returns a new BrowserNotificationsNotifier.  // Gibt einen neuen BrowserNotificationsNotifier zurück.
});

class BrowserNotificationsNotifier extends StateNotifier<bool> {  // StateNotifier class to manage the browser notifications state.  // StateNotifier-Klasse zur Verwaltung des Browser-Benachrichtigungs-States.
  BrowserNotificationsNotifier() : super(false);  // Constructor that initializes with notifications disabled.  // Konstruktor, der mit deaktivierten Benachrichtigungen initialisiert wird.

  void toggle() {  // Method to toggle the notifications state.  // Methode zum Umschalten des Benachrichtigungs-States.
    state = !state;  // Inverts the current state.  // Kehrt den aktuellen State um.
  }

  void set(bool value) {  // Method to set the notifications state to a specific value.  // Methode zum Setzen des Benachrichtigungs-States auf einen bestimmten Wert.
    state = value;  // Sets the state to the given value.  // Setzt den State auf den angegebenen Wert.
  }
}

final currentTimerTypeProvider = StateProvider<String>((ref) => 'Pomodoro');  // Provider to track the current timer type, initialized to 'Pomodoro'.  // Provider, der den aktuellen Timer-Typ verfolgt, initialisiert mit 'Pomodoro'.

final currentTimerTypeDarkModeProvider =
    StateProvider<String>((ref) => 'Pomodoro');  // Provider to track the current timer type in dark mode, initialized to 'Pomodoro'.  // Provider, der den aktuellen Timer-Typ im Dunkelmodus verfolgt, initialisiert mit 'Pomodoro'.

final currentColorProvider = StateProvider<Color>((ref) {  // Provider for the current color based on timer type.  // Provider für die aktuelle Farbe basierend auf dem Timer-Typ.

    return ref.watch(darkPomodoroColorProvider);  // Returns the dark mode Pomodoro color.  // Gibt die Dunkelmodus-Pomodoro-Farbe zurück.
  
});

final colorInitProvider = FutureProvider<void>((ref) async {  // Future provider that initializes color settings from local storage.  // Future-Provider, der Farbeinstellungen aus dem lokalen Speicher initialisiert.
  await HiveServices.retrieveAllColorValues(ref);  // Retrieves all saved color values from Hive storage.  // Ruft alle gespeicherten Farbwerte aus dem Hive-Speicher ab.
});

final darkPomodoroColorProvider = StateProvider<Color>((ref) {  // Provider for the Pomodoro timer color in dark mode.  // Provider für die Pomodoro-Timer-Farbe im Dunkelmodus.
   return const Color(0xFF74F143);  // Returns a green color (#74F143).  // Gibt eine grüne Farbe (#74F143) zurück.
});

final darkShortBreakColorProvider = StateProvider<Color>((ref) {  // Provider for the short break timer color in dark mode.  // Provider für die Kurzpausen-Timer-Farbe im Dunkelmodus.
   return const Color(0xffff9933);  // Returns an orange color (#ff9933).  // Gibt eine orange Farbe (#ff9933) zurück.
});


final darkLongBreakColorProvider = StateProvider<Color>((ref) {  // Provider for the long break timer color in dark mode.  // Provider für die Langpausen-Timer-Farbe im Dunkelmodus.
  return const Color(0xFF0891FF);  // Returns a blue color (#0891FF).  // Gibt eine blaue Farbe (#0891FF) zurück.
});


final pomodoroColorModeProvider = Provider<Color>((ref) {  // Provider that returns the current Pomodoro color based on mode.  // Provider, der die aktuelle Pomodoro-Farbe basierend auf dem Modus zurückgibt.
    return ref.watch(darkPomodoroColorProvider.notifier).state;  // Returns the dark mode Pomodoro color state.  // Gibt den Dunkelmodus-Pomodoro-Farb-State zurück.
  
});

final shortBreakColorModeProvider = Provider<Color>((ref) {  // Provider that returns the current short break color based on mode.  // Provider, der die aktuelle Kurzpausen-Farbe basierend auf dem Modus zurückgibt.
    return ref.watch(darkShortBreakColorProvider.notifier).state;  // Returns the dark mode short break color state.  // Gibt den Dunkelmodus-Kurzpausen-Farb-State zurück.
  
});

final longBreakColorModeProvider = Provider<Color>((ref) {  // Provider that returns the current long break color based on mode.  // Provider, der die aktuelle Langpausen-Farbe basierend auf dem Modus zurückgibt.
    return ref.watch(darkLongBreakColorProvider.notifier).state;  // Returns the dark mode long break color state.  // Gibt den Dunkelmodus-Langpausen-Farb-State zurück.
  
});


class EventNotifier extends StateNotifier<String> {  // A class that notifies about events, extending StateNotifier with String type.  // Eine Klasse, die über Ereignisse benachrichtigt und StateNotifier mit String-Typ erweitert.
  EventNotifier() : super("");  // Constructor initializing with empty string as state.  // Konstruktor, der mit leerem String als Zustand initialisiert.

  void notify(String eventName) {  // Method to notify about an event with a given name.  // Methode zur Benachrichtigung über ein Ereignis mit einem bestimmten Namen.
    state = "";  // First reset the state to empty.  // Zunächst den Zustand auf leer zurücksetzen.
    state = eventName;  // Then set the state to the event name.  // Dann den Zustand auf den Ereignisnamen setzen.
  }
}

final eventNotifierProvider =  // Definition of a provider for event notifications.  // Definition eines Providers für Ereignisbenachrichtigungen.
    StateNotifierProvider<EventNotifier, String>((ref) => EventNotifier());  // Creates a StateNotifierProvider that returns an EventNotifier instance.  // Erstellt einen StateNotifierProvider, der eine EventNotifier-Instanz zurückgibt.

final nextTimerTypeProvider = StateProvider<String>((ref) {  // Provider for the next timer type.  // Provider für den nächsten Timer-Typ.
  return 'Pomodoro';  // Returns 'Pomodoro' as the default timer type.  // Gibt 'Pomodoro' als Standard-Timer-Typ zurück.
});

final nextColorProvider = StateProvider<Color>((ref) {  // Provider for the color of the next timer.  // Provider für die Farbe des nächsten Timers.
  final nextTimerType = ref.watch(nextTimerTypeProvider);  // Watches the next timer type.  // Beobachtet den nächsten Timer-Typ.
  final themeMode = ref.read(themeModeProvider);  // Reads the current theme mode.  // Liest den aktuellen Themenmodus.

  if (themeMode == ThemeMode.dark) {  // If the theme mode is dark.  // Wenn der Themenmodus dunkel ist.

    switch (nextTimerType) {  // Switch based on the next timer type.  // Verzweigung basierend auf dem nächsten Timer-Typ.
      case 'Short Break':  // Case for Short Break.  // Fall für kurze Pause.
        return const Color(0xFF74F143);  // Return a green color.  // Gibt eine grüne Farbe zurück.
      case 'Long Break':  // Case for Long Break.  // Fall für lange Pause.
        return const Color(0xffff9933);  // Return an orange color.  // Gibt eine orangene Farbe zurück.
      default:  // Default case (Pomodoro).  // Standardfall (Pomodoro).
        return const Color(0xFF43DDF1);  // Return a blue color.  // Gibt eine blaue Farbe zurück.
    }
  } else {  // If the theme mode is light.  // Wenn der Themenmodus hell ist.
    switch (nextTimerType) {  // Switch based on the next timer type.  // Verzweigung basierend auf dem nächsten Timer-Typ.
      case 'Short Break':  // Case for Short Break.  // Fall für kurze Pause.
        return ref.watch(darkShortBreakColorProvider.notifier).state;  // Return the color from short break provider.  // Gibt die Farbe vom Provider für kurze Pausen zurück.
      case 'Long Break':  // Case for Long Break.  // Fall für lange Pause.
        return ref.watch(darkLongBreakColorProvider.notifier).state;  // Return the color from long break provider.  // Gibt die Farbe vom Provider für lange Pausen zurück.
      case 'Pomodoro':  // Case for Pomodoro.  // Fall für Pomodoro.
        int longBreakInterval =  // Get the long break interval.  // Holt das Intervall für lange Pausen.
            ref.read(longBreakIntervalProvider.notifier).state;  // Read the state from the long break interval provider.  // Liest den Zustand vom Provider für lange Pausenintervalle.
        int completedWorkPeriods =  // Get the number of completed work periods.  // Holt die Anzahl der abgeschlossenen Arbeitsperioden.
            ref.read(completedWorkPeriodsProvider.notifier).state;  // Read the state from the completed work periods provider.  // Liest den Zustand vom Provider für abgeschlossene Arbeitsperioden.

        if ((completedWorkPeriods + 1) % longBreakInterval == 0) {  // If the next period will be followed by a long break.  // Wenn auf die nächste Periode eine lange Pause folgt.
          return ref.watch(darkLongBreakColorProvider.notifier).state;  // Return color for long break.  // Gibt die Farbe für lange Pausen zurück.
        } else {  // Otherwise (will be followed by a short break).  // Andernfalls (wird von einer kurzen Pause gefolgt).
          return ref.watch(darkShortBreakColorProvider.notifier).state;  // Return color for short break.  // Gibt die Farbe für kurze Pausen zurück.
        }
      default:  // Default case (unexpected value).  // Standardfall (unerwarteter Wert).
        return Colors.black;  // Return black color.  // Gibt schwarze Farbe zurück.
    }
  }
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(  // Provider for theme mode (dark/light).  // Provider für den Themenmodus (dunkel/hell).
  (ref) => ThemeModeNotifier(),  // Creates and returns a ThemeModeNotifier instance.  // Erstellt und gibt eine ThemeModeNotifier-Instanz zurück.
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {  // Class to manage theme mode state.  // Klasse zur Verwaltung des Themenmodus-Zustands.
  ThemeModeNotifier() : super(ThemeMode.light) {  // Constructor initializing with light theme and loading saved theme.  // Konstruktor, der mit hellem Thema initialisiert und gespeichertes Thema lädt.
    loadThemeMode();  // Call method to load the saved theme mode.  // Ruft Methode zum Laden des gespeicherten Themenmodus auf.
  }

  Future<void> loadThemeMode() async {  // Asynchronous method to load the theme mode.  // Asynchrone Methode zum Laden des Themenmodus.
    final savedThemeMode = await HiveServices.retrieveThemeMode();  // Retrieve the saved theme mode from Hive storage.  // Ruft den gespeicherten Themenmodus aus dem Hive-Speicher ab.
    state = savedThemeMode;  // Set the state to the retrieved theme mode.  // Setzt den Zustand auf den abgerufenen Themenmodus.
  }

  void toggle() async {  // Method to toggle between light and dark mode.  // Methode zum Umschalten zwischen Hell- und Dunkelmodus.
    if (state == ThemeMode.dark) {  // If current theme is dark.  // Wenn das aktuelle Thema dunkel ist.
      state = ThemeMode.light;  // Switch to light theme.  // Wechselt zum hellen Thema.
      await HiveServices.saveThemeMode(ThemeMode.dark);  // Save the theme mode as dark (seems to be a bug).  // Speichert den Themenmodus als dunkel (scheint ein Fehler zu sein).
    } else {  // If current theme is light.  // Wenn das aktuelle Thema hell ist.
      state = ThemeMode.dark;  // Switch to dark theme.  // Wechselt zum dunklen Thema.
      await HiveServices.saveThemeMode(ThemeMode.dark);  // Save the theme mode as dark.  // Speichert den Themenmodus als dunkel.
    }
  }
}

final currentPomodorosProvider = StateProvider<int>((ref) => 0);  // Provider for tracking the current number of completed pomodoros.  // Provider zur Verfolgung der aktuellen Anzahl abgeschlossener Pomodoros.

final pomodoroNotifierProvider =  // Provider for the pomodoro state notifier.  // Provider für den Pomodoro-Zustandsbenachrichtiger.
    StateNotifierProvider<PomodoroNotifier, PomodoroState>(  // Creates a state notifier provider for pomodoro state.  // Erstellt einen State-Notifier-Provider für den Pomodoro-Zustand.
        (ref) => PomodoroNotifier(ref));  // Returns a new PomodoroNotifier with the ref.  // Gibt einen neuen PomodoroNotifier mit der Referenz zurück.

final isFirstStartProvider = StateProvider<bool>((ref) => true);  // Provider to track if this is the first start of the timer.  // Provider zur Verfolgung, ob dies der erste Start des Timers ist.

final timerFinishedProvider = StateProvider<bool>((ref) => false);  // Provider to track if the timer has finished.  // Provider zur Verfolgung, ob der Timer beendet wurde.

final focusedTaskTitleProvider = StateProvider<String>((ref) => '');  // Provider for the title of the currently focused task.  // Provider für den Titel der aktuell fokussierten Aufgabe.
final focusedTaskProvider = StateProvider<Todo?>((ref) => null);  // Provider for the currently focused task object.  // Provider für das aktuell fokussierte Aufgabenobjekt.

final taskColorsProvider = StateProvider<Map<String, Color>>((ref) => {});  // Provider for mapping task names to colors.  // Provider für die Zuordnung von Aufgabennamen zu Farben.

final selectedProyectContainerProvider = StateProvider<int?>((ref) => null);  // Provider for the currently selected project container index.  // Provider für den Index des aktuell ausgewählten Projektcontainers.

final toDoHappySadToggleProvider = StateNotifierProvider<ToDoHappySadToggleNotifier, bool>((ref) {  // Provider for toggling between happy/sad states for todos.  // Provider zum Umschalten zwischen Glücklich/Traurig-Zuständen für Todos.
  return ToDoHappySadToggleNotifier();  // Returns a new toggle notifier.  // Gibt einen neuen Toggle-Notifier zurück.
});

class ToDoHappySadToggleNotifier extends StateNotifier<bool> {  // Class to manage the happy/sad toggle state.  // Klasse zur Verwaltung des Glücklich/Traurig-Umschaltzustands.
  ToDoHappySadToggleNotifier() : super(false);  // Constructor initializing with false (sad state).  // Konstruktor, der mit false (trauriger Zustand) initialisiert.

  void toggle() async {  // Method to toggle the state.  // Methode zum Umschalten des Zustands.
    state = !state;  // Invert the current state.  // Invertiert den aktuellen Zustand.
  }

  void set(bool value) {  // Method to set the state to a specific value.  // Methode zum Setzen des Zustands auf einen bestimmten Wert.
    state = value;  // Set the state to the provided value.  // Setzt den Zustand auf den bereitgestellten Wert.
  }
}


final taskDeletionsProvider = StateNotifierProvider<TaskDeletionsToggleNotifier, bool>((ref) {  // Provider for toggling task deletion mode.  // Provider zum Umschalten des Löschmodus für Aufgaben.
  return TaskDeletionsToggleNotifier();  // Returns a new task deletions toggle notifier.  // Gibt einen neuen Toggle-Notifier für Aufgabenlöschungen zurück.
});

class TaskDeletionsToggleNotifier extends StateNotifier<bool> {  // Class to manage the task deletions toggle state.  // Klasse zur Verwaltung des Umschaltzustands für Aufgabenlöschungen.
  TaskDeletionsToggleNotifier() : super(false);  // Constructor initializing with false (deletion mode off).  // Konstruktor, der mit false (Löschmodus aus) initialisiert.

  void toggle() async {  // Method to toggle the deletion mode.  // Methode zum Umschalten des Löschmodus.
    state = !state;  // Invert the current state.  // Invertiert den aktuellen Zustand.
  }

  void set(bool value) {  // Method to set the deletion mode to a specific value.  // Methode zum Setzen des Löschmodus auf einen bestimmten Wert.
    state = value;  // Set the state to the provided value.  // Setzt den Zustand auf den bereitgestellten Wert.
  }
}


final taskCardTitleProvider = StateNotifierProvider<TaskCardTitleNotifier, String>((ref) {  // Provider for managing the task card title.  // Provider zur Verwaltung des Aufgabenkartentitels.
  return TaskCardTitleNotifier();  // Returns a new task card title notifier.  // Gibt einen neuen Aufgabenkartentitel-Notifier zurück.
});

class TaskCardTitleNotifier extends StateNotifier<String> {  // Class to manage the task card title state.  // Klasse zur Verwaltung des Aufgabenkartentitel-Zustands.
  TaskCardTitleNotifier() : super('');  // Constructor initializing with empty string.  // Konstruktor, der mit leerem String initialisiert.

  void updateTitle(String title) {  // Method to update the title.  // Methode zum Aktualisieren des Titels.
    state = title;  // Set the state to the new title.  // Setzt den Zustand auf den neuen Titel.
  }

  void reset() {  // Method to reset the title.  // Methode zum Zurücksetzen des Titels.
    state = '';  // Set the state to empty string.  // Setzt den Zustand auf einen leeren String.
  }
}

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {  // Provider for local storage repository.  // Provider für das lokale Speicher-Repository.
  return LocalStorageRepository();  // Returns a new local storage repository instance.  // Gibt eine neue Instanz des lokalen Speicher-Repositorys zurück.
});
