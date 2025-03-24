/// AlarmSoundPopupMenuButton
/// 
/// A customizable dropdown menu widget for selecting notification sounds in the application. // Ein anpassbares Dropdown-Menü-Widget zur Auswahl von Benachrichtigungstönen in der Anwendung.
/// Displays the current sound name and allows users to select from a list of available sounds. // Zeigt den aktuellen Klang-Namen an und ermöglicht Benutzern die Auswahl aus einer Liste verfügbarer Klänge.
/// 
/// Usage:
/// ```dart
/// AlarmSoundPopupMenuButton(
///   sounds: soundsList,
///   currentSound: selectedSound.friendlyName,
///   onSoundSelected: (sound) => handleSoundSelection(sound),
/// )
/// ```
/// 
/// EN: Provides a dark-themed dropdown menu for sound selection with custom styling and callback handling.
/// DE: Bietet ein Dropdown-Menü im dunklen Design zur Klangauswahl mit individueller Gestaltung und Callback-Verarbeitung.

import 'package:flutter/material.dart'; // Imports Flutter material design widgets. // Importiert Flutter Material-Design-Widgets.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for text styling. // Importiert Google Fonts für die Textstilisierung.
import '../../common/widgets/domain/entities/sound_entity.dart'; // Imports the Sound entity model. // Importiert das Sound-Entitätsmodell.

class AlarmSoundPopupMenuButton extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod consumer capabilities. // Definiert ein Stateful-Widget mit Riverpod-Consumer-Fähigkeiten.
  final List<Sound> sounds; // List of available sounds. // Liste der verfügbaren Klänge.
  final String currentSound; // Name of the currently selected sound. // Name des aktuell ausgewählten Klangs.
  final Function(Sound) onSoundSelected; // Callback function when a sound is selected. // Callback-Funktion, wenn ein Klang ausgewählt wird.

  const AlarmSoundPopupMenuButton({ // Constructor with required parameters. // Konstruktor mit erforderlichen Parametern.
    required this.sounds, // Required list of sounds. // Erforderliche Liste von Klängen.
    required this.currentSound, // Required current sound name. // Erforderlicher aktueller Klangname.
    required this.onSoundSelected, // Required selection callback. // Erforderlicher Auswahl-Callback.
    super.key, // Optional key parameter. // Optionaler Schlüssel-Parameter.
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => // Creates state for this widget. // Erstellt den State für dieses Widget.
      _AlarmSoundPopupMenuButtonState(); // Returns state class instance. // Gibt eine Instanz der State-Klasse zurück.
}

class _AlarmSoundPopupMenuButtonState // Defines the state class for the widget. // Definiert die State-Klasse für das Widget.
    extends ConsumerState<AlarmSoundPopupMenuButton> { // Extends ConsumerState for Riverpod access. // Erweitert ConsumerState für Riverpod-Zugriff.
  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
   
    return Material( // Creates a Material widget for proper elevation and ink effects. // Erstellt ein Material-Widget für korrekte Erhöhung und Tinteneffekte.
      borderRadius: BorderRadius.circular(10.0), // Rounds the corners of the material. // Rundet die Ecken des Materials ab.
      child: Theme( // Creates a localized Theme. // Erstellt ein lokalisiertes Theme.
        data: Theme.of(context).copyWith( // Copies current theme with modifications. // Kopiert aktuelles Theme mit Änderungen.
            splashFactory: NoSplash.splashFactory, // Disables splash animation. // Deaktiviert Splash-Animation.
            splashColor: Colors.transparent, // Makes splash color transparent. // Macht Splash-Farbe transparent.
            highlightColor: Colors.transparent, // Makes highlight color transparent. // Macht Hervorhebungsfarbe transparent.
            hoverColor: Colors.transparent), // Makes hover color transparent. // Macht Hover-Farbe transparent.
        child: PopupMenuButton<Sound>( // Creates a popup menu for sound selection. // Erstellt ein Popup-Menü für die Klangauswahl.
          color: const Color(0xff1c1b1f), // Sets dark background color for menu. // Setzt dunkle Hintergrundfarbe für das Menü.
          tooltip: null, // Disables default tooltip. // Deaktiviert Standard-Tooltip.
          shape: RoundedRectangleBorder( // Defines menu shape. // Definiert Menüform.
            borderRadius: BorderRadius.circular(10.0), // Rounds menu corners. // Rundet Menüecken ab.
          ),
          onSelected: (sound) { // Function called when sound is selected. // Funktion, die bei Klangauswahl aufgerufen wird.
            widget.onSoundSelected(sound); // Calls the provided callback with selected sound. // Ruft den bereitgestellten Callback mit ausgewähltem Klang auf.
          },
          itemBuilder: (BuildContext context) => widget.sounds // Builds menu items from sounds list. // Erstellt Menüelemente aus der Klängeliste.
              .map((sound) => PopupMenuItem<Sound>( // Maps each sound to a menu item. // Ordnet jeden Klang einem Menüelement zu.
                    value: sound, // Sets sound as item value. // Setzt Klang als Elementwert.
                    child: Text(sound.friendlyName), // Displays the sound's friendly name. // Zeigt den benutzerfreundlichen Namen des Klangs an.
                  ))
              .toList(), // Converts map to list. // Wandelt Map in Liste um.
          child: SizedBox( // Container for the button. // Container für die Schaltfläche.
            width: 165, // Sets fixed width. // Setzt feste Breite.
            child: Material( // Creates material with elevation effect. // Erstellt Material mit Erhöhungseffekt.
              type: MaterialType.transparency, // Makes material background transparent. // Macht Materialhintergrund transparent.
              elevation: 2, // Adds slight shadow. // Fügt leichten Schatten hinzu.
              borderRadius: BorderRadius.circular(14.0), // Rounds material corners. // Rundet Materialecken ab.
              child: Container( // Creates visual container for button. // Erstellt visuellen Container für die Schaltfläche.
                width: 200, // Sets container width. // Setzt Container-Breite.
                height: 50, // Sets container height. // Setzt Container-Höhe.
                decoration: BoxDecoration( // Defines container styling. // Definiert Container-Styling.
                  color: const Color(0xff1c1b1f), // Sets dark background color. // Setzt dunkle Hintergrundfarbe.
                  borderRadius: BorderRadius.circular(10.0), // Rounds container corners. // Rundet Container-Ecken ab.
                  border: Border.all(color: Colors.transparent), // Adds transparent border. // Fügt transparenten Rand hinzu.
                ),
                padding: const EdgeInsets.all(10.0), // Adds internal padding. // Fügt inneren Abstand hinzu.
                child: Center( // Centers content. // Zentriert Inhalt.
                  child: Text( // Displays current sound name. // Zeigt aktuellen Klangnamen an.
                    widget.currentSound, // Text is current sound name. // Text ist aktueller Klangname.
                    textAlign: TextAlign.center, // Centers text horizontally. // Zentriert Text horizontal.
                    style: GoogleFonts.nunito( // Uses Nunito font. // Verwendet Nunito-Schrift.
                      color: const Color(0xffF2F2F2), // Sets light text color. // Setzt helle Textfarbe.
                      fontSize: 16.0, // Sets font size. // Setzt Schriftgröße.
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
