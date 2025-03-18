import 'dart:async';  // Imports async functionality for Futures and Streams.  // Importiert asynchrone Funktionalität für Futures und Streams. 
import 'dart:html' as html;  // Imports HTML functionality for web interactions.  // Importiert HTML-Funktionalität für Web-Interaktionen.
import 'dart:js' as js;  // Imports JavaScript interoperability.  // Importiert JavaScript-Interoperabilität.
import 'package:flutter/material.dart';  // Imports Flutter's material design package.  // Importiert Flutters Material-Design-Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management.  // Importiert Riverpod für die Zustandsverwaltung.
import 'package:just_audio/just_audio.dart';  // Imports audio playback package.  // Importiert Audioabspiel-Paket.
import '../../infrastructure/data_sources/hive_services.dart';  // Imports local storage services.  // Importiert lokale Speicherdienste.
import '../widgets/custom_timer_palette.dart';  // Imports custom timer UI components.  // Importiert benutzerdefinierte Timer-UI-Komponenten.
import 'persistent_container_notifier.dart';  // Imports container state management.  // Importiert Container-Zustandsverwaltung.
import 'project_time_notifier.dart';  // Imports project time tracking.  // Importiert Projektzeitverfolgung.
import 'providers.dart';  // Imports providers for state management.  // Importiert Provider für die Zustandsverwaltung.

class TimerNotifier extends StateNotifier<int> {  // Class that manages timer state, extending Riverpod's StateNotifier.  // Klasse, die den Timer-Zustand verwaltet und Riverpods StateNotifier erweitert.
  TimerNotifier(int state, this.ref, this._audioPlayer) : super(state) {  // Constructor taking initial state, reference, and audio player.  // Konstruktor, der den Anfangszustand, die Referenz und den Audio-Player übernimmt.
    _setupJavaScriptHandlers();  // Initializes JavaScript handlers when created.  // Initialisiert JavaScript-Handler bei der Erstellung.
  }

  AnimationController? controller;  // Optional animation controller for timer visuals.  // Optionaler Animationscontroller für Timer-Visualisierungen.
  CustomTimePainter? painter;  // Optional custom painter for timer UI.  // Optionaler benutzerdefinierter Painter für Timer-UI.
  AudioPlayer _audioPlayer;  // Audio player for timer sounds.  // Audio-Player für Timer-Töne.
  final Ref ref;  // Reference to access providers.  // Referenz für den Zugriff auf Provider.
  
  bool _isRunning = false;  // Tracks if timer is currently running.  // Verfolgt, ob der Timer gerade läuft.
  bool _mounted = false;  // Tracks if widget is mounted.  // Verfolgt, ob das Widget eingebunden ist.
  bool _isDisposed = false;  // Tracks if notifier is disposed.  // Verfolgt, ob der Notifier verworfen wurde.
  String _currentSoundPath = '';  // Tracks current loaded sound path.  // Verfolgt den aktuell geladenen Soundpfad.
  DateTime? startTime;  // Optional start time for timer.  // Optionale Startzeit für den Timer.
  int _initialDuration = 0;  // Initial duration of timer in seconds.  // Anfängliche Dauer des Timers in Sekunden.
  bool isFirstStart = true;  // Tracks if this is first start of timer.  // Verfolgt, ob dies der erste Start des Timers ist.

  void _setupJavaScriptHandlers() {  // Sets up handlers for JavaScript callbacks.  // Richtet Handler für JavaScript-Callbacks ein.
    js.context['flutter_inappwebview'] = js.JsObject.jsify({  // Creates a JavaScript object for communication.  // Erstellt ein JavaScript-Objekt für die Kommunikation.
      'callHandler': (String method, [dynamic arg1, dynamic arg2]) async {  // Defines a callback method with optional arguments.  // Definiert eine Callback-Methode mit optionalen Argumenten.
        switch (method) {  // Switches based on method name.  // Wechselt basierend auf dem Methodennamen.
          case 'updateTimer':  // Case for updating timer.  // Fall für Timer-Aktualisierung.
            _handleTimerUpdate(arg1 as int);  // Handles timer update with integer argument.  // Behandelt Timer-Aktualisierung mit Integer-Argument.
            break;
          case 'timerComplete':  // Case for timer completion.  // Fall für Timer-Abschluss.
            await _handleTimerComplete();  // Handles timer completion asynchronously.  // Behandelt Timer-Abschluss asynchron.
            break;
          case 'onVisibilityChange':  // Case for visibility changes.  // Fall für Sichtbarkeitsänderungen.
            _handleVisibilityChange(arg1 as String, arg2 as int);  // Handles visibility change with string and integer arguments.  // Behandelt Sichtbarkeitsänderung mit String- und Integer-Argumenten.
            break;
        }
      }
    });
  }

  Future<void> showWebNotification(String title, String body) async {  // Method to show web notifications with title and body.  // Methode zum Anzeigen von Web-Benachrichtigungen mit Titel und Inhalt.
    try {  // Try block for error handling.  // Try-Block für Fehlerbehandlung.
      if (html.Notification.supported) {  // Checks if notifications are supported.  // Prüft, ob Benachrichtigungen unterstützt werden.
        if (html.Notification.permission == "granted") {  // Checks if permission is already granted.  // Prüft, ob die Berechtigung bereits erteilt wurde.
          html.Notification(title, body: body);  // Creates notification with title and body.  // Erstellt Benachrichtigung mit Titel und Inhalt.
        } else {  // If permission not granted.  // Wenn Berechtigung nicht erteilt.
          await html.Notification.requestPermission().then((permission) {  // Requests permission asynchronously.  // Fordert Berechtigung asynchron an.
            if (permission == "granted") {  // If permission granted.  // Wenn Berechtigung erteilt.
              html.Notification(title, body: body);  // Creates notification with title and body.  // Erstellt Benachrichtigung mit Titel und Inhalt.
            }
          });
        }
      }
    } catch (e) {  // Catch block for errors.  // Catch-Block für Fehler.
      print('Error showing notification: $e');  // Logs error message.  // Protokolliert Fehlermeldung.
    }
  }

Future<void> playSound({required bool userTriggered}) async {  // Method to play sound with parameter indicating if user triggered.  // Methode zum Abspielen von Sound mit Parameter, der angibt, ob vom Benutzer ausgelöst.
  try {  // Try block for error handling.  // Try-Block für Fehlerbehandlung.
    print("playSound called. User triggered: $userTriggered");  // Logs method call and user trigger status.  // Protokolliert Methodenaufruf und Benutzerauslösestatus.

    final selectedSound = ref.watch(selectedSoundProvider.notifier).state;  // Gets currently selected sound.  // Holt aktuell ausgewählten Sound.
    print("Selected sound path: ${selectedSound.path}");  // Logs selected sound path.  // Protokolliert ausgewählten Soundpfad.

    // Ensure audio player is ready  // Stellt sicher, dass Audio-Player bereit ist
    if (_audioPlayer.processingState != ProcessingState.ready) {  // Checks if audio player needs initialization.  // Prüft, ob Audio-Player initialisiert werden muss.
      print("Audio player not ready, reinitializing...");  // Logs reinitialization message.  // Protokolliert Reinitialisierungsmeldung.
      await _audioPlayer.dispose();  // Disposes current audio player.  // Verwirft aktuellen Audio-Player.
      _audioPlayer = AudioPlayer();  // Creates new audio player.  // Erstellt neuen Audio-Player.
      await _audioPlayer.setAsset(selectedSound.path);  // Sets audio asset path.  // Setzt Audio-Asset-Pfad.
      await _audioPlayer.load();  // Loads the audio.  // Lädt den Audio.
    }

    // Attempt playback with retries  // Versucht Wiedergabe mit Wiederholungen
    for (int i = 0; i < 3; i++) {  // Loop for retry attempts.  // Schleife für Wiederholungsversuche.
      try {  // Try block for each attempt.  // Try-Block für jeden Versuch.
        print("Attempting to play sound. Attempt #$i");  // Logs attempt number.  // Protokolliert Versuchsnummer.
        await _audioPlayer.seek(Duration.zero);  // Seeks to beginning of audio.  // Sucht den Anfang der Audiodatei.
        await _audioPlayer.play();  // Plays the audio.  // Spielt den Audio ab.
        print("Sound played successfully.");  // Logs success message.  // Protokolliert Erfolgsmeldung.
        break;  // Exits loop on success.  // Beendet Schleife bei Erfolg.
      } catch (e) {  // Catch block for each attempt.  // Catch-Block für jeden Versuch.
        print("Error in playSound: $e");  // Logs error message.  // Protokolliert Fehlermeldung.
        if (i == 2) rethrow;  // Rethrows after final retry.  // Wirft nach letztem Versuch erneut.
        await Future.delayed(Duration(milliseconds: 100));  // Delays before retry.  // Verzögert vor Wiederholung.
      }
    }
  } catch (e) {  // Catch block for overall function.  // Catch-Block für gesamte Funktion.
    print("Final error in playSound: $e");  // Logs final error message.  // Protokolliert endgültige Fehlermeldung.
  }
}


  Future<void> playSoundWithUserInteraction() async {  // Method to play sound with explicit user interaction.  // Methode zum Abspielen von Sound mit expliziter Benutzerinteraktion.
    await playSound(userTriggered: true);  // Calls playSound with userTriggered flag.  // Ruft playSound mit userTriggered-Flag auf.
  }


Future<void> loadSounds() async {  // Method to preload sound assets.  // Methode zum Vorladen von Sound-Assets.
  if (!_isDisposed) {  // Checks if notifier is not disposed.  // Prüft, ob Notifier nicht verworfen wurde.
    try {  // Try block for error handling.  // Try-Block für Fehlerbehandlung.
      final selectedSound = ref.read(selectedSoundProvider.notifier).state;  // Gets currently selected sound.  // Holt aktuell ausgewählten Sound.

      // Stop any ongoing playback and ensure player is ready  // Stoppt laufende Wiedergabe und stellt sicher, dass Player bereit ist
      if (_audioPlayer.playing) {  // Checks if audio is currently playing.  // Prüft, ob Audio gerade abgespielt wird.
        await _audioPlayer.stop();  // Stops playback.  // Stoppt Wiedergabe.
      }

      if (selectedSound.path != _currentSoundPath ||   // Checks if sound path changed or player not ready.  // Prüft, ob Soundpfad geändert oder Player nicht bereit.
          _audioPlayer.processingState != ProcessingState.ready) {
        await _audioPlayer.dispose();  // Disposes current audio player.  // Verwirft aktuellen Audio-Player.
        _audioPlayer = AudioPlayer();  // Creates new audio player.  // Erstellt neuen Audio-Player.

        await _audioPlayer.setAsset(selectedSound.path);  // Sets audio asset path.  // Setzt Audio-Asset-Pfad.
        await _audioPlayer.load();  // Loads the audio.  // Lädt den Audio.
        _currentSoundPath = selectedSound.path;  // Updates current sound path.  // Aktualisiert aktuellen Soundpfad.
        print("New sound loaded successfully: $_currentSoundPath");  // Logs success message.  // Protokolliert Erfolgsmeldung.
      }
    } catch (e) {  // Catch block for errors.  // Catch-Block für Fehler.
      print('Error loading sounds: $e');  // Logs error message.  // Protokolliert Fehlermeldung.
    }
  }
}

void init() {  // Initializes the timer and sets up listeners.  // Initialisiert den Timer und richtet Listener ein.
    _mounted = true;  // Sets the mounted flag to true.  // Setzt das Mounted-Flag auf true.
    loadSounds();  // Preloads sounds at startup.  // Lädt Töne beim Start vor.

    ref.listen<String>(currentTimerTypeProvider, (timerType, _) {  // Listens for changes in timer type.  // Überwacht Änderungen des Timer-Typs.
      if (timerType == 'Pomodoro') {  // If timer type is Pomodoro.  // Wenn der Timer-Typ Pomodoro ist.
        painter?.color = ref.read(darkPomodoroColorProvider);  // Sets color to Pomodoro color.  // Setzt die Farbe auf die Pomodoro-Farbe.
      } else if (timerType == 'Short Break') {  // If timer type is Short Break.  // Wenn der Timer-Typ Kurze Pause ist.
        painter?.color = ref.read(darkShortBreakColorProvider);  // Sets color to Short Break color.  // Setzt die Farbe auf die Kurze-Pause-Farbe.
      } else {  // For Long Break or any other type.  // Für Lange Pause oder andere Typen.
        painter?.color = ref.read(darkLongBreakColorProvider);  // Sets color to Long Break color.  // Setzt die Farbe auf die Lange-Pause-Farbe.
      }
    });

    ref.listen<String>(selectedSoundProvider.select((value) => value.path),  // Listens for changes in selected sound path.  // Überwacht Änderungen des ausgewählten Soundpfads.
        (previousSound, newSound) async {  // Callback with previous and new sound paths.  // Callback mit vorherigem und neuem Soundpfad.
      if (previousSound != newSound) {  // If the sound has changed.  // Wenn sich der Sound geändert hat.
        await _audioPlayer.stop();  // Stops any playing sound.  // Stoppt jeden spielenden Sound.
        await loadSounds();  // Loads the new sounds.  // Lädt die neuen Töne.
      }
    });
  }

  void _handleTimerUpdate(int remainingTime) {  // Handles timer update events.  // Behandelt Timer-Update-Ereignisse.
    if (!_isDisposed && _isRunning && _mounted) {  // Checks if timer is active and component is mounted.  // Prüft, ob der Timer aktiv ist und die Komponente eingebunden ist.
      state = remainingTime;  // Updates the timer state with remaining time.  // Aktualisiert den Timer-Zustand mit der verbleibenden Zeit.
      
      if (remainingTime % 1 == 0) {  // Every second (or time unit).  // Jede Sekunde (oder Zeiteinheit).
        HiveServices.saveRemainingTimerValue(  // Saves remaining time to persistent storage.  // Speichert die verbleibende Zeit im persistenten Speicher.
          ref.read(currentTimerTypeProvider), remainingTime);  // Uses current timer type and remaining time.  // Verwendet aktuellen Timer-Typ und verbleibende Zeit.
      }
    }
  }

  void _handleVisibilityChange(String visibility, int elapsedSeconds) {  // Handles page visibility changes.  // Behandelt Sichtbarkeitsänderungen der Seite.
    if (!_isDisposed && _mounted && _isRunning) {  // Checks if timer is active and component is mounted.  // Prüft, ob der Timer aktiv ist und die Komponente eingebunden ist.
      if (visibility == 'visible') {  // If page becomes visible again.  // Wenn die Seite wieder sichtbar wird.
        if (elapsedSeconds > 0) {  // If time has passed while hidden.  // Wenn Zeit vergangen ist, während die Seite versteckt war.
          final newState = state - elapsedSeconds;  // Calculates new timer value.  // Berechnet neuen Timer-Wert.
          if (newState <= 0) {  // If timer would have finished.  // Wenn der Timer abgelaufen wäre.
            _handleTimerComplete();  // Completes the timer.  // Schließt den Timer ab.
          } else {  // If timer still has time left.  // Wenn der Timer noch Zeit übrig hat.
            state = newState;  // Updates the timer state.  // Aktualisiert den Timer-Zustand.
          }
        }
      }
      // Reloads sounds when page becomes visible again.  // Lädt Töne neu, wenn die Seite wieder sichtbar wird.
      loadSounds();
    }
  }

  String _getNotificationBody() {  // Generates notification text based on timer state.  // Generiert Benachrichtigungstext basierend auf dem Timer-Zustand.
    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {  // If current timer type is Pomodoro.  // Wenn der aktuelle Timer-Typ Pomodoro ist.
      int longBreakInterval = ref.read(longBreakIntervalProvider);  // Gets long break interval.  // Holt das Intervall für lange Pausen.
      int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);  // Gets completed work periods.  // Holt die abgeschlossenen Arbeitsperioden.
      
      if ((completedWorkPeriods + 1) % longBreakInterval == 0) {  // If next break should be a long break.  // Wenn die nächste Pause eine lange Pause sein sollte.
        return 'Time for a long break!';  // Returns long break message.  // Gibt Nachricht für lange Pause zurück.
      } else {  // If next break should be a short break.  // Wenn die nächste Pause eine kurze Pause sein sollte.
        return 'Time for a short break!';  // Returns short break message.  // Gibt Nachricht für kurze Pause zurück.
      }
    } else {  // If current timer is a break.  // Wenn der aktuelle Timer eine Pause ist.
      return 'Time to get back to work!';  // Returns work message.  // Gibt Arbeits-Nachricht zurück.
    }
  }

 void changeFavicon(String faviconPath) {  // Changes the browser tab favicon.  // Ändert das Browser-Tab-Favicon.
      final js.JsObject document = js.JsObject.fromBrowserObject(js.context['document']);  // Gets JavaScript document object.  // Holt das JavaScript-Dokument-Objekt.
      final link = document.callMethod('querySelector', ['link[rel="icon"]']);  // Finds the favicon link element.  // Findet das Favicon-Link-Element.
      if (link != null) {  // If link element exists.  // Wenn das Link-Element existiert.
        link.href = faviconPath;  // Updates the favicon path.  // Aktualisiert den Favicon-Pfad.
      } else {  // If link element doesn't exist.  // Wenn das Link-Element nicht existiert.
        print('Link element not found!');  // Logs error message.  // Protokolliert Fehlermeldung.
      }
    }

Future<void> _handleTimerComplete() async {  // Handles timer completion event.  // Behandelt das Timer-Abschlussereignis.
    if (!_mounted || _isDisposed) return;  // Exits if component is not mounted or disposed.  // Beendet, wenn die Komponente nicht eingebunden oder verworfen ist.
    
    _isRunning = false;  // Sets running flag to false.  // Setzt das Laufend-Flag auf false.
    state = 0;  // Resets timer state to 0.  // Setzt den Timer-Zustand auf 0 zurück.

    // Changes document title to show completion message.  // Ändert den Dokumenttitel, um die Abschlussmeldung anzuzeigen.
 changeFavicon('icons/red_android-chrome-192x192.png');  // Changes favicon to red icon.  // Ändert das Favicon zu einem roten Symbol.
    html.document.title = "Time is up!";  // Sets page title to completion message.  // Setzt den Seitentitel auf die Abschlussmeldung.
    // Ensures sound and notification are executed.  // Stellt sicher, dass Sound und Benachrichtigung ausgeführt werden.
    try {  // Try block for error handling.  // Try-Block für Fehlerbehandlung.
      if (ref.read(browserNotificationsProvider)) {  // If browser notifications are enabled.  // Wenn Browser-Benachrichtigungen aktiviert sind.
        // Attempts to show notification even in background.  // Versucht, die Benachrichtigung auch im Hintergrund anzuzeigen.
        html.window.postMessage('showNotification', '*');  // Posts message to show notification.  // Sendet Nachricht zur Anzeige der Benachrichtigung.
        await showWebNotification('Timer Finished', _getNotificationBody());  // Shows web notification.  // Zeigt Web-Benachrichtigung an.
      }
      
      // Plays sound immediately.  // Spielt den Sound sofort ab.
      await playSound(userTriggered: false).timeout(  // Plays sound with timeout.  // Spielt Sound mit Zeitlimit ab.
       const Duration(seconds: 1),  // 1 second timeout.  // 1 Sekunde Zeitlimit.
        onTimeout: () async {  // On timeout callback.  // Timeout-Callback.
          // If playback fails, tries again.  // Wenn die Wiedergabe fehlschlägt, versucht es erneut.
          await loadSounds();  // Reloads sounds.  // Lädt die Töne neu.
          await playSound(userTriggered: false);  // Tries playing sound again.  // Versucht erneut, den Sound abzuspielen.
        },
      );
    } catch (e) {  // Catch block for errors.  // Catch-Block für Fehler.
      print('Error handling timer completion: $e');  // Logs error message.  // Protokolliert Fehlermeldung.
    }

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {  // If completed timer was Pomodoro.  // Wenn der abgeschlossene Timer ein Pomodoro war.
      final exactDuration = Duration(seconds: _initialDuration);  // Creates duration object from initial time.  // Erstellt Dauer-Objekt aus der Anfangszeit.
      await HiveServices.savePomodoroDuration(exactDuration);  // Saves Pomodoro duration.  // Speichert die Pomodoro-Dauer.
      
      final selectedContainerIndex = ref.read(persistentContainerIndexProvider) ?? 0;  // Gets selected project container.  // Holt den ausgewählten Projekt-Container.
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);  // Gets today's date.  // Holt das heutige Datum.
      ref.read(projectTimesProvider.notifier).addTime(  // Adds time to project tracking.  // Fügt Zeit zur Projektverfolgung hinzu.
        selectedContainerIndex,   // Selected project index.  // Ausgewählter Projektindex.
        today,   // Today's date.  // Heutiges Datum.
        exactDuration  // Exact Pomodoro duration.  // Genaue Pomodoro-Dauer.
      );
      
      ref.read(pomodoroNotifierProvider.notifier).finishCurrentPomodoro();  // Updates Pomodoro counter.  // Aktualisiert den Pomodoro-Zähler.
    }

    ref.read(isTimerRunningProvider.notifier).state = false;  // Updates timer running state.  // Aktualisiert den Timer-Laufzustand.
    int longBreakInterval = ref.read(longBreakIntervalProvider);  // Gets long break interval.  // Holt das Intervall für lange Pausen.
    int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);  // Gets completed work periods.  // Holt die abgeschlossenen Arbeitsperioden.

    await _updateTimerState(completedWorkPeriods, longBreakInterval);  // Updates timer state for next cycle.  // Aktualisiert den Timer-Zustand für den nächsten Zyklus.
}
  
Future<void> _updateTimerState(int completedWorkPeriods, int longBreakInterval) async {  // Updates timer state based on completed work periods.  // Aktualisiert den Timer-Zustand basierend auf abgeschlossenen Arbeitsperioden.
    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {  // If current timer is Pomodoro.  // Wenn der aktuelle Timer Pomodoro ist.
      completedWorkPeriods++;  // Increment completed work periods.  // Erhöht die abgeschlossenen Arbeitsperioden.
      ref.read(completedWorkPeriodsProvider.notifier).state = completedWorkPeriods;  // Update the provider state.  // Aktualisiert den Provider-Zustand.
      await HiveServices.saveOngoingPomodoro(false);  // Save that no Pomodoro is ongoing.  // Speichert, dass kein Pomodoro läuft.

      if (completedWorkPeriods % longBreakInterval == 0) {  // If long break interval is reached.  // Wenn das Intervall für lange Pausen erreicht ist.
        ref.read(currentTimerTypeProvider.notifier).state = 'Long Break';  // Set timer type to Long Break.  // Setzt den Timer-Typ auf Lange Pause.
      } else {  // If long break interval not reached.  // Wenn das Intervall für lange Pausen nicht erreicht ist.
        ref.read(currentTimerTypeProvider.notifier).state = 'Short Break';  // Set timer type to Short Break.  // Setzt den Timer-Typ auf Kurze Pause.
      }
      HiveServices.saveCurrentTimerType(ref.read(currentTimerTypeProvider));  // Save the current timer type.  // Speichert den aktuellen Timer-Typ.
    } else {  // If current timer is a break.  // Wenn der aktuelle Timer eine Pause ist.
      ref.read(currentTimerTypeProvider.notifier).state = 'Pomodoro';  // Set timer type to Pomodoro.  // Setzt den Timer-Typ auf Pomodoro.
      await HiveServices.saveOngoingPomodoro(true);  // Save that a Pomodoro is ongoing.  // Speichert, dass ein Pomodoro läuft.
      HiveServices.saveCurrentTimerType('Pomodoro');  // Save the timer type as Pomodoro.  // Speichert den Timer-Typ als Pomodoro.
      
      ref.read(currentPomodorosProvider.notifier).state++;  // Increment total Pomodoros count.  // Erhöht die Gesamtzahl der Pomodoros.
      ref.read(pomodoroNotifierProvider.notifier).startNewPomodoro();  // Start a new Pomodoro cycle.  // Startet einen neuen Pomodoro-Zyklus.
    }
  }


  void startTimer() async {  // Starts the timer.  // Startet den Timer.
    if (_isDisposed) return;  // If disposed, exit early.  // Wenn verworfen, frühzeitig beenden.
    
    _isRunning = true;  // Set running flag to true.  // Setzt das Laufend-Flag auf true.
    _initialDuration = state;  // Store initial duration.  // Speichert die Anfangsdauer.
    
    controller?.reset();  // Reset animation controller.  // Setzt den Animationscontroller zurück.
    controller?.forward();  // Start animation controller.  // Startet den Animationscontroller.
    
    await HiveServices.saveOngoingPomodoro(true);  // Save that a timer is ongoing.  // Speichert, dass ein Timer läuft.
    
    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {  // If current timer is Pomodoro.  // Wenn der aktuelle Timer Pomodoro ist.
      startTime = DateTime.now();  // Set start time to now.  // Setzt die Startzeit auf jetzt.
      await HiveServices.saveStartTime(startTime!);  // Save the start time.  // Speichert die Startzeit.
    } else {  // If current timer is a break.  // Wenn der aktuelle Timer eine Pause ist.
      startTime = null;  // Clear start time.  // Löscht die Startzeit.
    }

    js.context.callMethod('startTimer', [state]);  // Call JavaScript startTimer method.  // Ruft die JavaScript-Methode startTimer auf.
    ref.read(isTimerRunningProvider.notifier).state = true;  // Update timer running state.  // Aktualisiert den Timer-Laufzustand.
  }

  void stopTimer() async {  // Stops the timer.  // Stoppt den Timer.
    if (!_isRunning) return;  // If not running, exit early.  // Wenn nicht laufend, frühzeitig beenden.

    _isRunning = false;  // Set running flag to false.  // Setzt das Laufend-Flag auf false.
    
    final elapsedSeconds = js.context.callMethod('stopTimer') as int;  // Get elapsed seconds from JavaScript.  // Holt verstrichene Sekunden von JavaScript.

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro' && startTime != null) {  // If Pomodoro and has start time.  // Wenn Pomodoro und hat Startzeit.
      final duration = Duration(seconds: elapsedSeconds);  // Create duration from elapsed seconds.  // Erstellt Dauer aus verstrichenen Sekunden.
      await HiveServices.savePomodoroDuration(duration);  // Save Pomodoro duration.  // Speichert die Pomodoro-Dauer.
      
      final selectedContainerIndex = ref.read(persistentContainerIndexProvider) ?? 0;  // Get selected project index.  // Holt ausgewählten Projektindex.
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);  // Get today's date.  // Holt das heutige Datum.
      ref.read(projectTimesProvider.notifier).addTime(  // Add time to project tracking.  // Fügt Zeit zur Projektverfolgung hinzu.
        selectedContainerIndex, 
        today, 
        duration
      );
    }

    if (state > 0) {  // If timer still has time left.  // Wenn der Timer noch Zeit übrig hat.
      HiveServices.saveRemainingTimerValue('remainingTime', state);  // Save remaining time.  // Speichert die verbleibende Zeit.
      final timerType = ref.read(currentTimerTypeProvider);  // Get current timer type.  // Holt aktuellen Timer-Typ.
      HiveServices.saveRemainingTimerValue(timerType, state);  // Save remaining time for specific timer type.  // Speichert die verbleibende Zeit für bestimmten Timer-Typ.
    }
    
    ref.read(isTimerRunningProvider.notifier).state = false;  // Update timer running state.  // Aktualisiert den Timer-Laufzustand.
    _audioPlayer.pause();  // Pause audio player.  // Pausiert den Audio-Player.
    controller?.stop();  // Stop animation controller.  // Stoppt den Animationscontroller.
    await HiveServices.saveOngoingPomodoro(false);  // Save that no timer is ongoing.  // Speichert, dass kein Timer läuft.
  }

  void updateDuration(int newDuration) {  // Updates the timer duration.  // Aktualisiert die Timer-Dauer.
    stopTimer();  // Stop current timer.  // Stoppt den aktuellen Timer.
    int durationInSeconds;  // Variable for duration in seconds.  // Variable für Dauer in Sekunden.

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {  // If timer type is Pomodoro.  // Wenn der Timer-Typ Pomodoro ist.
      durationInSeconds = ref.read(pomodoroTimerProvider) * 60;  // Get Pomodoro duration in seconds.  // Holt Pomodoro-Dauer in Sekunden.
    } else if (ref.read(currentTimerTypeProvider) == 'Short Break') {  // If timer type is Short Break.  // Wenn der Timer-Typ Kurze Pause ist.
      durationInSeconds = ref.read(shortBreakProvider) * 60;  // Get Short Break duration in seconds.  // Holt Kurze-Pause-Dauer in Sekunden.
    } else {  // If timer type is Long Break.  // Wenn der Timer-Typ Lange Pause ist.
      durationInSeconds = ref.read(longBreakProvider) * 60;  // Get Long Break duration in seconds.  // Holt Lange-Pause-Dauer in Sekunden.
    }

    state = durationInSeconds;  // Update state with new duration.  // Aktualisiert Zustand mit neuer Dauer.
    _initialDuration = durationInSeconds;  // Update initial duration.  // Aktualisiert Anfangsdauer.
    controller?.duration = Duration(seconds: durationInSeconds);  // Update animation controller duration.  // Aktualisiert Animationscontroller-Dauer.
    HiveServices.saveCurrentTimerType(ref.read(currentTimerTypeProvider));  // Save current timer type.  // Speichert aktuellen Timer-Typ.
  }

  @override
  void dispose() {  // Disposes of resources when notifier is no longer needed.  // Gibt Ressourcen frei, wenn der Notifier nicht mehr benötigt wird.
    _mounted = false;  // Set mounted flag to false.  // Setzt das Eingebunden-Flag auf false.
    _isRunning = false;  // Set running flag to false.  // Setzt das Laufend-Flag auf false.
    _isDisposed = true;  // Set disposed flag to true.  // Setzt das Verworfen-Flag auf true.
    js.context.callMethod('stopTimer');  // Call JavaScript stopTimer method.  // Ruft die JavaScript-Methode stopTimer auf.
    _audioPlayer.dispose();  // Dispose audio player.  // Gibt den Audio-Player frei.
    controller?.dispose();  // Dispose animation controller.  // Gibt den Animationscontroller frei.
    super.dispose();  // Call parent dispose method.  // Ruft die übergeordnete dispose-Methode auf.
  }

  void updateColor() {  // Updates colors based on timer type and theme.  // Aktualisiert Farben basierend auf Timer-Typ und Thema.
    final themeMode = ref.read(themeModeProvider);  // Get current theme mode.  // Holt aktuellen Themenmodus.

    if (themeMode == ThemeMode.dark) {  // If theme is dark mode.  // Wenn das Thema der dunkle Modus ist.
      if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {  // If timer type is Pomodoro.  // Wenn der Timer-Typ Pomodoro ist.
        ref.read(currentColorProvider.notifier).state =
            ref.read(darkPomodoroColorProvider);  // Set current color to Pomodoro color.  // Setzt aktuelle Farbe auf Pomodoro-Farbe.
        _updateNextColorProvider(darkShortBreakColorProvider, darkLongBreakColorProvider);  // Update next color provider.  // Aktualisiert nächsten Farb-Provider.
      } else if (ref.read(currentTimerTypeProvider) == 'Short Break') {  // If timer type is Short Break.  // Wenn der Timer-Typ Kurze Pause ist.
        ref.read(currentColorProvider.notifier).state =
            ref.read(darkShortBreakColorProvider);  // Set current color to Short Break color.  // Setzt aktuelle Farbe auf Kurze-Pause-Farbe.
        ref.read(nextColorProvider.notifier).state =
            ref.read(darkPomodoroColorProvider);  // Set next color to Pomodoro color.  // Setzt nächste Farbe auf Pomodoro-Farbe.
      } else {  // If timer type is Long Break.  // Wenn der Timer-Typ Lange Pause ist.
        ref.read(currentColorProvider.notifier).state =
            ref.read(darkLongBreakColorProvider);  // Set current color to Long Break color.  // Setzt aktuelle Farbe auf Lange-Pause-Farbe.
        ref.read(nextColorProvider.notifier).state =
            ref.read(darkPomodoroColorProvider);  // Set next color to Pomodoro color.  // Setzt nächste Farbe auf Pomodoro-Farbe.
      }
    }
  }

  void _updateNextColorProvider(  // Helper method to update next timer color.  // Hilfsmethode zur Aktualisierung der nächsten Timer-Farbe.
    StateProvider<Color> shortBreakColorProvider,  // Provider for short break color.  // Provider für Kurze-Pause-Farbe.
    StateProvider<Color> longBreakColorProvider  // Provider for long break color.  // Provider für Lange-Pause-Farbe.
  ) {
    int longBreakInterval = ref.read(longBreakIntervalProvider);  // Get long break interval.  // Holt Intervall für lange Pausen.
    int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);  // Get completed work periods.  // Holt abgeschlossene Arbeitsperioden.

    if (longBreakInterval == 1) {  // If interval is 1 (every Pomodoro).  // Wenn Intervall 1 ist (nach jedem Pomodoro).
      ref.read(nextColorProvider.notifier).state =
          ref.read(longBreakColorProvider);  // Set next color to long break color.  // Setzt nächste Farbe auf Lange-Pause-Farbe.
    } else if (longBreakInterval == 2) {  // If interval is 2.  // Wenn Intervall 2 ist.
      if (completedWorkPeriods % longBreakInterval == 0) {  // If next break is short.  // Wenn nächste Pause kurz ist.
        ref.read(nextColorProvider.notifier).state =
            ref.read(shortBreakColorProvider);  // Set next color to short break color.  // Setzt nächste Farbe auf Kurze-Pause-Farbe.
      } else {  // If next break is long.  // Wenn nächste Pause lang ist.
        ref.read(nextColorProvider.notifier).state =
            ref.read(longBreakColorProvider);  // Set next color to long break color.  // Setzt nächste Farbe auf Lange-Pause-Farbe.
      }
    } else if (longBreakInterval == 3) {  // If interval is 3.  // Wenn Intervall 3 ist.
      if (completedWorkPeriods % longBreakInterval < 2) {  // If not yet time for long break.  // Wenn noch nicht Zeit für lange Pause.
        ref.read(nextColorProvider.notifier).state =
            ref.read(shortBreakColorProvider);  // Set next color to short break color.  // Setzt nächste Farbe auf Kurze-Pause-Farbe.
      } else {  // If time for long break.  // Wenn Zeit für lange Pause.
        ref.read(nextColorProvider.notifier).state =
            ref.read(longBreakColorProvider);  // Set next color to long break color.  // Setzt nächste Farbe auf Lange-Pause-Farbe.
      }
    } else if (longBreakInterval == 4) {  // If interval is 4.  // Wenn Intervall 4 ist.
      if (completedWorkPeriods % longBreakInterval < 3) {  // If not yet time for long break.  // Wenn noch nicht Zeit für lange Pause.
        ref.read(nextColorProvider.notifier).state =
            ref.read(shortBreakColorProvider);  // Set next color to short break color.  // Setzt nächste Farbe auf Kurze-Pause-Farbe.
      } else {  // If time for long break.  // Wenn Zeit für lange Pause.
        ref.read(nextColorProvider.notifier).state =
            ref.read(longBreakColorProvider);  // Set next color to long break color.  // Setzt nächste Farbe auf Lange-Pause-Farbe.
      }
    }
  }
}

