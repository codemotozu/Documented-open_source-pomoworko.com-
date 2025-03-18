import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management.  // Importiert Riverpod für die Zustandsverwaltung.
import '../repository/auth_repository.dart';  // Imports the authentication repository.  // Importiert das Authentifizierungs-Repository. 
import 'providers.dart';  // Imports other providers.  // Importiert andere Provider.
import 'timer_notifier.dart';  // Imports the timer notifier class.  // Importiert die Timer-Notifier-Klasse.

final userPomodoroTimerProvider = StateProvider<int>((ref) {  // Provider for user's personalized Pomodoro duration.  // Provider für die personalisierte Pomodoro-Dauer des Benutzers.
  final user = ref.watch(userProvider);  // Gets the current user.  // Holt den aktuellen Benutzer.
  final pomodoroTimer = ref.watch(pomodoroTimerProvider);  // Gets the default Pomodoro duration.  // Holt die Standard-Pomodoro-Dauer.
  return user != null ? user.pomodoroTimer : pomodoroTimer;  // Returns user's setting if logged in, otherwise default.  // Gibt die Benutzereinstellung zurück, wenn angemeldet, sonst Standard.
});

final userShortBreakTimerProvider = StateProvider<int>((ref) {  // Provider for user's personalized short break duration.  // Provider für die personalisierte Kurze-Pause-Dauer des Benutzers.
  final user = ref.watch(userProvider);  // Gets the current user.  // Holt den aktuellen Benutzer.
  final shortBreakTimer = ref.watch(shortBreakProvider);  // Gets the default short break duration.  // Holt die Standard-Kurze-Pause-Dauer.
  return user != null ? user.shortBreakTimer : shortBreakTimer;  // Returns user's setting if logged in, otherwise default.  // Gibt die Benutzereinstellung zurück, wenn angemeldet, sonst Standard.
});

final userLongBreakTimerProvider = StateProvider<int>((ref) {  // Provider for user's personalized long break duration.  // Provider für die personalisierte Lange-Pause-Dauer des Benutzers.
  final user = ref.watch(userProvider);  // Gets the current user.  // Holt den aktuellen Benutzer.
  final longBreakTimer = ref.watch(longBreakProvider);  // Gets the default long break duration.  // Holt die Standard-Lange-Pause-Dauer.
  return user != null ? user.longBreakTimer : longBreakTimer;  // Returns user's setting if logged in, otherwise default.  // Gibt die Benutzereinstellung zurück, wenn angemeldet, sonst Standard.
});

final timerNotifierProvider = StateNotifierProvider<TimerNotifier, int>((ref) {  // Main provider for the timer state and functionality.  // Haupt-Provider für den Timer-Zustand und die Funktionalität.
  final audioPlayer = ref.watch(audioPlayerProvider);  // Gets the audio player.  // Holt den Audio-Player.
  final userPomodoroTimer = ref.watch(userPomodoroTimerProvider);  // Gets user's Pomodoro duration.  // Holt die Pomodoro-Dauer des Benutzers.
  final userShortBreakTimer = ref.watch(userShortBreakTimerProvider);  // Gets user's short break duration.  // Holt die Kurze-Pause-Dauer des Benutzers.
  final userLongBreakTimer = ref.watch(userLongBreakTimerProvider);  // Gets user's long break duration.  // Holt die Lange-Pause-Dauer des Benutzers.
  
  TimerNotifier timerNotifier;  // Variable to hold the timer notifier.  // Variable, um den Timer-Notifier zu halten.
  
  if (ref.read(currentTimerTypeProvider.notifier).state == 'Pomodoro') {  // If current timer type is Pomodoro.  // Wenn der aktuelle Timer-Typ Pomodoro ist.
      timerNotifier = TimerNotifier(userPomodoroTimer * 60, ref, audioPlayer);  // Create timer with Pomodoro duration in seconds.  // Erstellt Timer mit Pomodoro-Dauer in Sekunden.
  } else if (ref.read(currentTimerTypeProvider.notifier).state ==
      'Short Break') {  // If current timer type is Short Break.  // Wenn der aktuelle Timer-Typ Kurze Pause ist.
        timerNotifier = TimerNotifier(userShortBreakTimer * 60, ref, audioPlayer);  // Create timer with short break duration in seconds.  // Erstellt Timer mit Kurze-Pause-Dauer in Sekunden.
  } else {  // If current timer type is Long Break.  // Wenn der aktuelle Timer-Typ Lange Pause ist.
    timerNotifier =
        TimerNotifier((userLongBreakTimer) * 60, ref, audioPlayer);  // Create timer with long break duration in seconds.  // Erstellt Timer mit Lange-Pause-Dauer in Sekunden.
  }
  
  timerNotifier.loadSounds();  // Load the notification sounds.  // Lädt die Benachrichtigungstöne.
  timerNotifier.init();  // Initialize the timer.  // Initialisiert den Timer.
  
  return timerNotifier;  // Return the configured timer notifier.  // Gibt den konfigurierten Timer-Notifier zurück.
});
