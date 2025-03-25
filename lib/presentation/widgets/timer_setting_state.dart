/// TimerSettingState
/// 
/// A customizable timer setting widget that allows users to input and modify time values for different timer modes. // Ein anpassbares Timer-Einstellungs-Widget, das Benutzern ermöglicht, Zeitwerte für verschiedene Timer-Modi einzugeben und zu ändern.
/// Used in the application to configure durations for Pomodoro sessions, short breaks, and long breaks. // Wird in der Anwendung verwendet, um Dauern für Pomodoro-Sitzungen, kurze Pausen und lange Pausen zu konfigurieren.
/// 
/// Usage:
/// ```dart
/// TimerSettingState(
///   title: 'Pomodoro',
///   stateProvider: pomodoroTimerProvider,
/// )
/// ```
/// 
/// EN: Creates a list tile with a title and a numeric input field for configuring timer duration values with validation.
/// DE: Erstellt eine Listenzeile mit einem Titel und einem numerischen Eingabefeld zur Konfiguration von Timer-Dauerwerter mit Validierung.

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter/services.dart'; // Imports services like text input formatters. // Importiert Dienste wie Texteingabe-Formatierer.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for custom typography. // Importiert das Google Fonts-Paket für benutzerdefinierte Typografie.

import '../notifiers/providers.dart'; // Imports app-specific state providers. // Importiert anwendungsspezifische Zustandsanbieter.

class TimerSettingState extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  final String title; // The title displayed for this timer setting. // Der für diese Timer-Einstellung angezeigte Titel.
  final StateProvider<int> stateProvider; // The state provider that holds the timer value. // Der Zustandsanbieter, der den Timer-Wert enthält.

  const TimerSettingState({ // Constructor for the TimerSettingState widget. // Konstruktor für das TimerSettingState-Widget.
    super.key, // Parent class key parameter. // Elternklassen-Key-Parameter.
    required this.title, // Required title parameter. // Erforderlicher Titel-Parameter.
    required this.stateProvider, // Required state provider parameter. // Erforderlicher Zustandsanbieter-Parameter.
  });

  @override
  TimerSettingStateState createState() => TimerSettingStateState(); // Creates the state object for this widget. // Erstellt das Zustandsobjekt für dieses Widget.
}

class TimerSettingStateState extends ConsumerState<TimerSettingState> { // Defines the state class for TimerSettingState widget. // Definiert die Zustandsklasse für das TimerSettingState-Widget.
  late TextEditingController stateController; // Controller for the text input field. // Controller für das Texteingabefeld.

  @override
  void initState() { // Initializes the widget state. // Initialisiert den Widget-Zustand.
    super.initState(); // Calls parent initialization. // Ruft die Elterninitialisierung auf.
    stateController = TextEditingController( // Creates a text controller. // Erstellt einen Text-Controller.
      text: ref.read(widget.stateProvider).toString(), // Sets initial text to current timer value. // Setzt den anfänglichen Text auf den aktuellen Timer-Wert.
    );
  }

  @override
  void didChangeDependencies() { // Called when dependencies change. // Wird aufgerufen, wenn sich Abhängigkeiten ändern.
    super.didChangeDependencies(); // Calls parent method. // Ruft die Elternmethode auf.

    final pomodoroTimer = ref.watch(widget.stateProvider); // Gets current timer value from provider. // Ruft den aktuellen Timer-Wert vom Provider ab.
    if (stateController.text != pomodoroTimer.toString()) { // Checks if text doesn't match current timer value. // Prüft, ob der Text nicht mit dem aktuellen Timer-Wert übereinstimmt.
      stateController.text = pomodoroTimer.toString(); // Updates text to match timer value. // Aktualisiert den Text, um dem Timer-Wert zu entsprechen.
      stateController.selection = TextSelection.fromPosition( // Sets cursor position. // Setzt die Cursorposition.
        TextPosition(offset: stateController.text.length), // Moves cursor to end of text. // Bewegt den Cursor ans Ende des Textes.
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    return Column( // Returns a column layout. // Gibt ein Spalten-Layout zurück.
      children: [ // List of child widgets. // Liste der Kind-Widgets.
        ListTile( // Creates a list tile widget. // Erstellt ein Listenzeilen-Widget.
          title: Text( // Creates a text widget for the title. // Erstellt ein Text-Widget für den Titel.
            widget.title, // Uses the provided title. // Verwendet den bereitgestellten Titel.
            style: GoogleFonts.nunito(), // Applies Google Font styling. // Wendet Google Fonts-Styling an.
          ),
          trailing: Container( // Creates a container for the input field. // Erstellt einen Container für das Eingabefeld.
            decoration: BoxDecoration( // Adds decoration to the container. // Fügt dem Container Dekoration hinzu.
              borderRadius: BorderRadius.circular(10.0), // Rounds the corners. // Rundet die Ecken ab.
            ),
            width: 60, // Sets fixed width for the input. // Setzt feste Breite für die Eingabe.
            child: Material( // Creates a Material widget for ink effects. // Erstellt ein Material-Widget für Tinte-Effekte.
              color: const Color(0xff1c1b1f), // Sets dark background color. // Setzt dunkle Hintergrundfarbe.
              borderRadius: BorderRadius.circular(10.0), // Rounds the corners. // Rundet die Ecken ab.
              child: TextField( // Creates a text input field. // Erstellt ein Texteingabefeld.
                controller: stateController, // Connects to the text controller. // Verbindet mit dem Text-Controller.
                keyboardType: TextInputType.number, // Sets keyboard to numeric. // Setzt die Tastatur auf numerisch.
                inputFormatters: [ // List of input formatters. // Liste von Eingabe-Formatierern.
                  FilteringTextInputFormatter.digitsOnly, // Allows only digits. // Erlaubt nur Ziffern.
                  LengthLimitingTextInputFormatter(4) // Limits to 4 characters. // Begrenzt auf 4 Zeichen.
                ],
                decoration: InputDecoration( // Configures the appearance of the input field. // Konfiguriert das Erscheinungsbild des Eingabefelds.
                  fillColor: const Color(0xff1c1b1f), // Sets fill color to dark. // Setzt die Füllfarbe auf dunkel.
                  border: OutlineInputBorder( // Configures the border. // Konfiguriert den Rand.
                    borderRadius: BorderRadius.circular(10.0), // Rounds the corners of the border. // Rundet die Ecken des Rands ab.
                    borderSide: BorderSide.none, // Removes visible border sides. // Entfernt sichtbare Randseiten.
                  ),
                  contentPadding: const EdgeInsets.all(10.0), // Sets padding around the content. // Setzt Polsterung um den Inhalt.
                  isDense: true, // Makes the input field more compact. // Macht das Eingabefeld kompakter.
                  filled: true, // Enables background filling. // Ermöglicht Hintergrundfüllung.
                ),
                style: GoogleFonts.nunito(), // Applies Google Font styling to input text. // Wendet Google Fonts-Styling auf Eingabetext an.
                onChanged: (value) { // Handler for text changes. // Handler für Textänderungen.
                  final enteredMinutes = int.tryParse(value); // Tries to parse text as integer. // Versucht, Text als Ganzzahl zu parsen.
                  if (enteredMinutes != null) { // If parsing succeeded. // Wenn das Parsen erfolgreich war.
                 
                    if (widget.title == 'Pomodoro') { // If this is the Pomodoro timer setting. // Wenn dies die Pomodoro-Timer-Einstellung ist.
                    ref.read(pomodoroTimerProvider.notifier).state = enteredMinutes; // Updates Pomodoro timer state. // Aktualisiert den Pomodoro-Timer-Zustand.
                  } else if (widget.title == 'Short Break') { // If this is the short break setting. // Wenn dies die Kurzpausen-Einstellung ist.
                    ref.read(shortBreakProvider.notifier).state = enteredMinutes; // Updates short break timer state. // Aktualisiert den Kurzpausen-Timer-Zustand.
                  } 

                  else if (widget.title == 'Long Break') { // If this is the long break setting. // Wenn dies die Langpausen-Einstellung ist.
                    ref.read(longBreakProvider.notifier).state = enteredMinutes; // Updates long break timer state. // Aktualisiert den Langpausen-Timer-Zustand.
                  }
                  
                    if (widget.title == 'Long Break Interval' && // If this is the long break interval setting and exceeds 4. // Wenn dies die Langpausen-Intervall-Einstellung ist und 4 überschreitet.
                        enteredMinutes > 4) {
                      ScaffoldMessenger.of(context).showSnackBar( // Shows a notification message. // Zeigt eine Benachrichtigungsmeldung an.
                        SnackBar( // Creates a snackbar notification. // Erstellt eine Snackbar-Benachrichtigung.
                          content: Text( // Text content for the notification. // Textinhalt für die Benachrichtigung.
                            'Max of 4 long breaks per day allowed for a healthy work-life balance. Consider adjusting work sessions or short breaks if needed', // Health-focused message. // Gesundheitsorientierte Nachricht.
                            style: GoogleFonts.nunito( // Applies styling to the text. // Wendet Styling auf den Text an.
                              fontSize: 16, // Sets font size. // Setzt die Schriftgröße.
                              color: const Color(0xffF2F2F2), // Sets light text color. // Setzt helle Textfarbe.
                            ),
                          ),
                          backgroundColor: const Color(0xff3B3B3B), // Sets dark gray background. // Setzt dunkelgrauen Hintergrund.
                          duration: const Duration(seconds: 8), // Shows for 8 seconds. // Zeigt für 8 Sekunden an.
                        ),
                      );
                      stateController.text = '4'; // Resets text to maximum value. // Setzt Text auf Maximalwert zurück.
                      stateController.selection = TextSelection.fromPosition( // Sets cursor position to end. // Setzt Cursorposition ans Ende.
                          TextPosition(offset: stateController.text.length));
                      ref.read(widget.stateProvider.notifier).state = 4; // Resets state to maximum value. // Setzt Zustand auf Maximalwert zurück.
                    } else if (enteredMinutes <= 1440) { // If value is within the allowed maximum (24 hours). // Wenn Wert innerhalb des erlaubten Maximums (24 Stunden) liegt.
                      ref.read(widget.stateProvider.notifier).state = // Updates the state provider. // Aktualisiert den Zustandsanbieter.
                          enteredMinutes;
                    } else { // If value exceeds maximum (24 hours). // Wenn Wert das Maximum (24 Stunden) überschreitet.
                      ScaffoldMessenger.of(context).showSnackBar( // Shows error message. // Zeigt Fehlermeldung an.
                        SnackBar( // Creates a snackbar notification. // Erstellt eine Snackbar-Benachrichtigung.
                          content: Text( // Text content for the error message. // Textinhalt für die Fehlermeldung.
                            'The maximum allowed value is 1440 minutes, equivalent to one day.', // Maximum value explanation. // Erklärung des Maximalwerts.
                            style: GoogleFonts.nunito( // Applies styling to the text. // Wendet Styling auf den Text an.
                              fontSize: 16, // Sets font size. // Setzt die Schriftgröße.
                              color: const Color(0xffF2F2F2), // Sets light text color. // Setzt helle Textfarbe.
                            ),
                          ),
                          backgroundColor: const Color(0xff3B3B3B), // Sets dark gray background. // Setzt dunkelgrauen Hintergrund.
                        ),
                      );
                      stateController.text = '1440'; // Sets text to maximum allowed value. // Setzt Text auf maximal erlaubten Wert.
                      stateController.selection = TextSelection.fromPosition( // Sets cursor position. // Setzt die Cursorposition.
                        TextPosition( // Creates a text position. // Erstellt eine Textposition.
                          offset: stateController.text.length, // Positions at end of text. // Positioniert am Ende des Textes.
                        ),
                      );
                      ref.read(widget.stateProvider.notifier).state = 1440; // Sets state to maximum allowed value. // Setzt Zustand auf maximal erlaubten Wert.
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
