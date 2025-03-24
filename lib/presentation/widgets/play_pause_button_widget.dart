/// PlayPauseButton
/// 
/// A control button widget for a Pomodoro timer application that handles starting and pausing timer sessions. // Ein Steuerungsbutton-Widget für eine Pomodoro-Timer-Anwendung, das das Starten und Pausieren von Timer-Sitzungen verwaltet.
/// Used as the main interaction point for users to control their work/break sessions with additional functionality like tracking time, saving session data, and updating browser indicators. // Wird als Hauptinteraktionspunkt für Benutzer verwendet, um ihre Arbeits-/Pausensitzungen zu steuern, mit zusätzlichen Funktionen wie Zeiterfassung, Speichern von Sitzungsdaten und Aktualisierung von Browser-Indikatoren.
/// 
/// Usage:
/// ```dart
/// AnimationController controller = AnimationController(
///   vsync: this,
///   duration: Duration(minutes: 25),
/// );
/// 
/// PlayPauseButton(
///   controller: controller,
/// )
/// ```
/// 
/// EN: Creates a floating action button that toggles between start and pause states, controlling the timer animation and tracking Pomodoro sessions.
/// DE: Erstellt einen schwebenden Aktionsbutton, der zwischen Start- und Pause-Zuständen wechselt, die Timer-Animation steuert und Pomodoro-Sitzungen verfolgt.

import 'dart:html' as html; // Imports HTML functionality for browser interactions. // Importiert HTML-Funktionalität für Browser-Interaktionen.
import 'dart:js' as js; // Imports JavaScript interoperability. // Importiert JavaScript-Interoperabilität.

import 'package:flutter/cupertino.dart'; // Imports Cupertino (iOS-style) widgets from Flutter. // Importiert Cupertino (iOS-Stil) Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for custom typography. // Importiert das Google Fonts-Paket für benutzerdefinierte Typografie.

import '../../infrastructure/data_sources/hive_services.dart'; // Imports Hive database services. // Importiert Hive-Datenbankdienste.
import '../notifiers/persistent_container_notifier.dart'; // Imports persistent container state management. // Importiert Verwaltung des persistenten Container-Zustands.
import '../notifiers/project_state_notifier.dart'; // Imports project state management. // Importiert Projektzustandsverwaltung.
import '../notifiers/providers.dart'; // Imports general providers for state management. // Importiert allgemeine Provider für die Zustandsverwaltung.
import '../notifiers/timer_notifier_provider.dart'; // Imports timer-specific state management. // Importiert timer-spezifische Zustandsverwaltung.
import '../repository/auth_repository.dart'; // Imports authentication repository for user data. // Importiert Authentifizierungs-Repository für Benutzerdaten.



class PlayPauseButton extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  final AnimationController controller; // Animation controller for the timer visualization. // Animationscontroller für die Timer-Visualisierung.

  const PlayPauseButton({ // Constructor for the PlayPauseButton widget. // Konstruktor für das PlayPauseButton-Widget.
    super.key, // Parent class key parameter. // Elternklassen-Key-Parameter.
    required this.controller, // Required animation controller parameter. // Erforderlicher Animationscontroller-Parameter.
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayPauseButtonState(); // Creates the state object for this widget. // Erstellt das Zustandsobjekt für dieses Widget.
}

class _PlayPauseButtonState extends ConsumerState<PlayPauseButton> { // Defines the state class for PlayPauseButton widget. // Definiert die Zustandsklasse für das PlayPauseButton-Widget.
  DateTime? startTime; // Variable to track when the timer started. // Variable, um zu verfolgen, wann der Timer gestartet wurde.
  String? currentProject; // Variable to track the current project name. // Variable, um den aktuellen Projektnamen zu verfolgen.

  @override
  void initState() { // Initializes the widget state. // Initialisiert den Widget-Zustand.
    super.initState(); // Calls parent initialization. // Ruft die Eltern-Initialisierung auf.
    html.window.addEventListener('beforeunload', (html.Event e) { // Adds event listener for browser page unload. // Fügt Ereignislistener für das Entladen der Browser-Seite hinzu.
      html.BeforeUnloadEvent event = e as html.BeforeUnloadEvent; // Casts the generic event to BeforeUnloadEvent. // Wandelt das generische Ereignis in BeforeUnloadEvent um.
      final isTimerRunning = ref.read(isTimerRunningProvider); // Checks if timer is currently running. // Prüft, ob der Timer gerade läuft.
      if (isTimerRunning) { // If timer is running when page is about to unload. // Wenn der Timer läuft, wenn die Seite entladen werden soll.
        event.returnValue = "Please click on the 'Pause' button to save changes."; // Shows a warning message to the user. // Zeigt dem Benutzer eine Warnmeldung an.
      }
    });
  }

  @override
  void dispose() { // Cleans up resources when widget is removed. // Bereinigt Ressourcen, wenn das Widget entfernt wird.
    startTime = null; // Clears the start time. // Löscht die Startzeit.
    html.window.removeEventListener('beforeunload', (html.Event e) {}); // Removes the event listener. // Entfernt den Ereignislistener.
    super.dispose(); // Calls parent disposal. // Ruft die Eltern-Bereinigung auf.
  }

  Future<void> _savePomodoroStatesToDatabase() async { // Method to save pomodoro states to database. // Methode zum Speichern von Pomodoro-Zuständen in der Datenbank.
    final pomodoroStates = ref.read(pomodoroNotifierProvider).pomodoros; // Gets current pomodoro states. // Ruft aktuelle Pomodoro-Zustände ab.
    await ref.read(authRepositoryProvider).updatePomodoroStates(pomodoroStates); // Updates states in the database. // Aktualisiert Zustände in der Datenbank.
  }

  Duration _calculatePreciseDuration(DateTime start) { // Method to calculate precise elapsed time. // Methode zur Berechnung der genauen verstrichenen Zeit.
    final currentTime = DateTime.now(); // Gets current time. // Ruft aktuelle Zeit ab.
    final rawDifference = currentTime.difference(start); // Calculates time difference. // Berechnet Zeitunterschied.
    
    final elapsedSeconds = rawDifference.inSeconds; // Gets elapsed time in seconds. // Ruft verstrichene Zeit in Sekunden ab.
    
    print('⚡ Raw difference in ms: ${rawDifference.inMilliseconds}'); // Logs millisecond difference for debugging. // Protokolliert Millisekundenunterschied zur Fehlersuche.
    print('⏱️ Adjusted seconds: $elapsedSeconds'); // Logs adjusted seconds for debugging. // Protokolliert angepasste Sekunden zur Fehlersuche.
    
    return Duration(seconds: elapsedSeconds); // Returns duration in seconds. // Gibt Dauer in Sekunden zurück.
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    final isTimerRunning = ref.watch(isTimerRunningProvider); // Tracks if timer is running. // Verfolgt, ob der Timer läuft.
    final projectNames = ref.watch(projectStateNotifierProvider); // Gets list of project names. // Ruft Liste der Projektnamen ab.
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider) ?? 0; // Gets selected project index. // Ruft ausgewählten Projektindex ab.
    final currentTimerType = ref.watch(currentTimerTypeProvider); // Gets current timer type (Pomodoro, short break, long break). // Ruft aktuellen Timer-Typ ab (Pomodoro, kurze Pause, lange Pause).

    void changeFavicon(String faviconPath) { // Function to change browser tab favicon. // Funktion zum Ändern des Browser-Tab-Favicons.
      final js.JsObject document = js.JsObject.fromBrowserObject(js.context['document']); // Gets JS document object. // Ruft JS-Document-Objekt ab.
      final link = document.callMethod('querySelector', ['link[rel="icon"]']); // Finds icon link element. // Findet Icon-Link-Element.
      if (link != null) { // If link element exists. // Wenn Link-Element existiert.
        link.href = faviconPath; // Changes favicon path. // Ändert Favicon-Pfad.
      } else {
        print('Link element not found!'); // Logs error if link not found. // Protokolliert Fehler, wenn Link nicht gefunden.
      }
    }

    return Column( // Returns a column layout. // Gibt ein Spalten-Layout zurück.
      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally. // Dehnt Kinder horizontal aus.
      mainAxisAlignment: MainAxisAlignment.end, // Aligns children at the bottom. // Richtet Kinder am unteren Rand aus.
      children: [
        const Padding( // Adds padding space. // Fügt Polsterraum hinzu.
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0), // Sets horizontal padding. // Setzt horizontale Polsterung.
        ),
        FloatingActionButton.extended( // Creates an extended floating action button. // Erstellt einen erweiterten schwebenden Aktionsbutton.
          heroTag: 'fab', // Tag for hero animations. // Tag für Hero-Animationen.
          icon: Icon(isTimerRunning // Icon based on timer state. // Symbol basierend auf Timer-Zustand.
              ? CupertinoIcons.pause_fill // Pause icon when timer is running. // Pause-Symbol, wenn Timer läuft.
              : CupertinoIcons.play_fill), // Play icon when timer is stopped. // Play-Symbol, wenn Timer gestoppt ist.
          label: ConstrainedBox( // Adds size constraints to the label. // Fügt Größenbeschränkungen für das Label hinzu.
            constraints: const BoxConstraints(maxWidth: 67, maxHeight: 20), // Sets maximum dimensions. // Setzt maximale Abmessungen.
            child: RichText( // Uses rich text for styling options. // Verwendet Rich-Text für Styling-Optionen.
              text: TextSpan( // Creates text span. // Erstellt Text-Span.
                text: isTimerRunning ? 'Pause' : 'Start', // Text based on timer state. // Text basierend auf Timer-Zustand.
                style: GoogleFonts.nunito( // Applies Google Font styling. // Wendet Google Fonts-Styling an.
                  color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt Textfarbe auf hellgrau.
                  fontSize: 18, // Sets font size. // Setzt Schriftgröße.
                  fontWeight: FontWeight.w600, // Sets semi-bold font weight. // Setzt halbfette Schriftstärke.
                ),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF121212), // Sets button background to dark gray. // Setzt Buttonhintergrund auf dunkelgrau.
          onPressed: () async { // Button press handler. // Button-Druck-Handler.
            if (isTimerRunning) { // If timer is currently running. // Wenn Timer gerade läuft.
              ref.read(timerNotifierProvider.notifier).stopTimer(); // Stops the timer. // Stoppt den Timer.
              widget.controller.stop(); // Stops the animation. // Stoppt die Animation.

              changeFavicon('icons/orange_android-chrome-192x192.png'); // Changes favicon to orange. // Ändert Favicon zu orange.
              html.document.title = "Relax"; // Changes browser tab title to "Relax". // Ändert Browser-Tab-Titel zu "Relax".

              if (startTime != null && currentTimerType == 'Pomodoro') { // If we have a start time and this is a Pomodoro session. // Wenn wir eine Startzeit haben und dies eine Pomodoro-Sitzung ist.
                print('\n🔴 TIMER PAUSE -------------'); // Logs timer pause event. // Protokolliert Timer-Pause-Ereignis.
                final duration = _calculatePreciseDuration(startTime!); // Calculates session duration. // Berechnet Sitzungsdauer.
                final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day); // Gets today's date. // Ruft heutiges Datum ab.
                
                print('⏱️ Session duration: ${duration.inSeconds}s'); // Logs session duration. // Protokolliert Sitzungsdauer.
                
                await HiveServices.savePomodoroDuration(duration); // Saves duration to database. // Speichert Dauer in Datenbank.
                
                startTime = null; // Resets start time. // Setzt Startzeit zurück.
              }

              await _savePomodoroStatesToDatabase(); // Saves pomodoro states to database. // Speichert Pomodoro-Zustände in der Datenbank.
            } else { // If timer is currently stopped. // Wenn Timer gerade gestoppt ist.
              print('\n🟢 TIMER START -------------'); // Logs timer start event. // Protokolliert Timer-Start-Ereignis.
              print('⏰ Start time: ${DateTime.now()}'); // Logs current time. // Protokolliert aktuelle Zeit.
              
              if (currentTimerType == 'Pomodoro') { // If this is a Pomodoro session. // Wenn dies eine Pomodoro-Sitzung ist.
                startTime = DateTime.now(); // Sets start time to now. // Setzt Startzeit auf jetzt.
                print('💾 Timer started at: $startTime'); // Logs start time. // Protokolliert Startzeit.
              }

              bool ongoingPomodoro = await HiveServices.retrieveOngoingPomodoro(); // Checks if there's an ongoing pomodoro. // Prüft, ob es ein laufendes Pomodoro gibt.
              bool unfinishedPomodoro = await HiveServices.retrieveUnfinishedPomodoro(); // Checks if there's an unfinished pomodoro. // Prüft, ob es ein unvollendetes Pomodoro gibt.

              if (currentTimerType == 'Pomodoro') { // If this is a Pomodoro session. // Wenn dies eine Pomodoro-Sitzung ist.
                final pomodoroState = ref.read(pomodoroNotifierProvider); // Gets pomodoro state. // Ruft Pomodoro-Zustand ab.

                bool shouldStartNewPomodoro = pomodoroState.pomodoros.isEmpty || // Determines if we should start a new pomodoro. // Bestimmt, ob wir ein neues Pomodoro starten sollten.
                    (pomodoroState.pomodoros.isNotEmpty &&
                        pomodoroState.pomodoros.last);

                if (!ongoingPomodoro && (shouldStartNewPomodoro || unfinishedPomodoro)) { // If conditions are right to start a new pomodoro. // Wenn die Bedingungen für den Start eines neuen Pomodoro stimmen.
                  ref.read(currentPomodorosProvider.notifier).state++; // Increments pomodoro count. // Erhöht Pomodoro-Zähler.
                  ref.read(pomodoroNotifierProvider.notifier).startNewPomodoro(); // Starts a new pomodoro. // Startet ein neues Pomodoro.
                  await _savePomodoroStatesToDatabase(); // Saves pomodoro states to database. // Speichert Pomodoro-Zustände in der Datenbank.
                }
              }

              ref.read(timerNotifierProvider.notifier).startTimer(); // Starts the timer. // Startet den Timer.
              if (widget.controller.isCompleted) { // If animation is complete. // Wenn Animation abgeschlossen ist.
                widget.controller.reset(); // Resets the animation. // Setzt die Animation zurück.
              }
              widget.controller.forward(); // Starts the animation. // Startet die Animation.
              
              await HiveServices.saveOngoingPomodoro(true); // Marks pomodoro as ongoing. // Markiert Pomodoro als laufend.
              await HiveServices.saveUnfinishedPomodoro(false); // Marks pomodoro as not unfinished. // Markiert Pomodoro als nicht unvollendet.
              changeFavicon('icons/green_android-chrome-192x192.png'); // Changes favicon to green. // Ändert Favicon zu grün.
              html.document.title = "Focus"; // Changes browser tab title to "Focus". // Ändert Browser-Tab-Titel zu "Focus".
            }
          },
        ),
      ],
    );
  }
}
