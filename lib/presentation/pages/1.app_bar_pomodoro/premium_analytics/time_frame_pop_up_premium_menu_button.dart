/// TimeFramePopupPremiumMenuButton
/// 
/// A popup menu button widget that displays time frame options with premium feature indicators. // Ein Popup-Menü-Button-Widget, das Zeitrahmenoptionen mit Premium-Funktionsanzeigen anzeigt.
/// Used to allow users to select different time frames, with some options marked as premium-only. // Wird verwendet, um Benutzern die Auswahl verschiedener Zeitrahmen zu ermöglichen, wobei einige Optionen als nur für Premium-Nutzer gekennzeichnet sind.
/// 
/// Usage: 
/// ```dart
/// TimeFramePopupPremiumMenuButton(
///   timeFrames: ['Daily', 'Weekly', 'Monthly', 'Yearly'],
///   currentTimeFrame: 'Daily',
///   onTimeFrameSelected: (selectedTimeFrame) {
///     // Handle time frame selection
///   },
///   isPremium: false,
/// ),
/// ```
/// 
/// EN: Displays a customized popup menu button with time frame options and premium indicators.
/// DE: Zeigt eine angepasste Popup-Menüschaltfläche mit Zeitrahmenoptionen und Premium-Indikatoren an.

import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets for iOS-style components. // Importiert Cupertino-Widgets für iOS-Stil-Komponenten.
import 'package:flutter/material.dart'; // Imports Material Design widgets for Android-style components. // Importiert Material Design-Widgets für Android-Stil-Komponenten.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for text styling. // Importiert das Google Fonts-Paket für die Textgestaltung.

class TimeFramePopupPremiumMenuButton extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod consumer capabilities. // Definiert ein Stateful-Widget mit Riverpod-Consumer-Fähigkeiten.
  final List<String> timeFrames; // List of time frame options to display. // Liste der anzuzeigenden Zeitrahmenoptionen.
  final String currentTimeFrame; // Currently selected time frame. // Aktuell ausgewählter Zeitrahmen.
  final Function(String) onTimeFrameSelected; // Callback function when a time frame is selected. // Callback-Funktion, wenn ein Zeitrahmen ausgewählt wird.
  final bool isPremium; // Flag indicating if user has premium access. // Flag, das anzeigt, ob der Benutzer Premium-Zugang hat.

  const TimeFramePopupPremiumMenuButton({ // Constructor for the widget. // Konstruktor für das Widget.
    required this.timeFrames, // Required parameter for time frame options. // Erforderlicher Parameter für Zeitrahmenoptionen.
    required this.currentTimeFrame, // Required parameter for the current time frame. // Erforderlicher Parameter für den aktuellen Zeitrahmen.
    required this.onTimeFrameSelected, // Required callback for time frame selection. // Erforderlicher Callback für die Zeitrahmenauswahl.
    this.isPremium = false, // Optional parameter with default value false. // Optionaler Parameter mit Standardwert false.
    super.key, // Key parameter passed to parent class. // Key-Parameter, der an die Elternklasse übergeben wird.
  });

  @override
  ConsumerState<TimeFramePopupPremiumMenuButton> createState() => // Creates the state object for this widget. // Erstellt das State-Objekt für dieses Widget.
      _TimeFramePopupPremiumMenuButtonState(); // Returns a new instance of the state class. // Gibt eine neue Instanz der State-Klasse zurück.
}

class _TimeFramePopupPremiumMenuButtonState // Defines the state class for the TimeFramePopupPremiumMenuButton. // Definiert die State-Klasse für den TimeFramePopupPremiumMenuButton.
    extends ConsumerState<TimeFramePopupPremiumMenuButton> { // Extends ConsumerState to access Riverpod functionality. // Erweitert ConsumerState, um auf Riverpod-Funktionalität zuzugreifen.
  bool isPremium = false; // Local state variable for premium status. // Lokale State-Variable für den Premium-Status.
  
  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    return Material( // Creates a Material Design card. // Erstellt eine Material Design-Karte.
      borderRadius: BorderRadius.circular(10.0), // Rounds the corners with a 10.0 radius. // Rundet die Ecken mit einem Radius von 10.0.
      child: Theme( // Applies a custom theme to the child widget. // Wendet ein benutzerdefiniertes Theme auf das Kind-Widget an.
        data: Theme.of(context).copyWith( // Copies the current theme and modifies specific properties. // Kopiert das aktuelle Theme und ändert bestimmte Eigenschaften.
          splashFactory: NoSplash.splashFactory, // Disables splash animation. // Deaktiviert die Splash-Animation.
          splashColor: Colors.transparent, // Makes splash color transparent. // Macht die Splash-Farbe transparent.
          highlightColor: Colors.transparent, // Makes highlight color transparent. // Macht die Hervorhebungsfarbe transparent.
          hoverColor: Colors.transparent, // Makes hover color transparent. // Macht die Hover-Farbe transparent.
        ),
        child: PopupMenuButton<String>( // Creates a popup menu button that returns String values. // Erstellt eine Popup-Menüschaltfläche, die String-Werte zurückgibt.
          color: const Color((0xffF5F7FA)), // Sets background color of the popup menu. // Setzt die Hintergrundfarbe des Popup-Menüs.
          tooltip: "Select time frame", // Sets tooltip text. // Setzt den Tooltip-Text.
          shape: RoundedRectangleBorder( // Defines the shape of the popup menu. // Definiert die Form des Popup-Menüs.
            borderRadius: BorderRadius.circular(10.0), // Rounds the corners with a 10.0 radius. // Rundet die Ecken mit einem Radius von 10.0.
          ),
          onSelected: (frame) { // Callback when an item is selected. // Callback, wenn ein Element ausgewählt wird.
            widget.onTimeFrameSelected(frame); // Calls the parent widget's callback with the selected frame. // Ruft den Callback des Eltern-Widgets mit dem ausgewählten Rahmen auf.
          },
          itemBuilder: (BuildContext context) => widget.timeFrames // Builds the list of menu items from the timeFrames list. // Baut die Liste der Menüelemente aus der timeFrames-Liste auf.
              .map( // Maps each time frame string to a PopupMenuItem. // Ordnet jeden Zeitrahmen-String einem PopupMenuItem zu.
                (frame) => PopupMenuItem<String>( // Creates a popup menu item for each frame. // Erstellt ein Popup-Menüelement für jeden Rahmen.
                  value: frame, // Sets the value returned when this item is selected. // Setzt den Wert, der zurückgegeben wird, wenn dieses Element ausgewählt wird.
                  child: Row( // Creates a row layout for the menu item. // Erstellt ein Zeilenlayout für das Menüelement.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Places children at the start and end of the row. // Platziert Kinder am Anfang und Ende der Zeile.
                    children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
                      Text( // Text widget displaying the frame name. // Text-Widget, das den Rahmennamen anzeigt.
                        frame, // The time frame text to display. // Der anzuzeigende Zeitrahmentext.
                        style: GoogleFonts.nunito( // Applies Nunito font style from Google Fonts. // Wendet den Nunito-Schriftstil von Google Fonts an.
                          color: const Color.fromARGB(255, 0, 0, 0), // Sets text color to black. // Setzt die Textfarbe auf Schwarz.
                          fontWeight: FontWeight.w600, // Sets the font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                        ),
                      ),

                      if ((frame == "Monthly" || frame == "Yearly") && // Conditional widget that only shows for Monthly/Yearly frames when not premium. // Bedingtes Widget, das nur für Monats-/Jahresrahmen angezeigt wird, wenn nicht Premium.
                          !widget.isPremium)
                        const Icon( // Creates an icon widget. // Erstellt ein Icon-Widget.
                          CupertinoIcons.lock_open, // Uses the open lock icon from Cupertino icon set. // Verwendet das offene Schloss-Symbol aus dem Cupertino-Icon-Set.
                          size: 18, // Sets the icon size to 18 logical pixels. // Setzt die Symbolgröße auf 18 logische Pixel.
                          color: Colors.black, // Sets the icon color to black. // Setzt die Symbolfarbe auf Schwarz.
                        ),
                    ],
                  ),
                ),
              )
              .toList(), // Converts the mapped items to a list. // Konvertiert die zugeordneten Elemente in eine Liste.
          child: SizedBox( // Container with specific dimensions for the button. // Container mit bestimmten Abmessungen für die Schaltfläche.
            width: 165, // Sets the width to 165 logical pixels. // Setzt die Breite auf 165 logische Pixel.
            child: Material( // Creates a Material Design surface. // Erstellt eine Material Design-Oberfläche.
              type: MaterialType.transparency, // Makes the material background transparent. // Macht den Material-Hintergrund transparent.
              elevation: 2, // Adds a shadow with elevation of 2. // Fügt einen Schatten mit Erhöhung 2 hinzu.
              borderRadius: BorderRadius.circular(14.0), // Rounds the corners with a 14.0 radius. // Rundet die Ecken mit einem Radius von 14.0.
              child: Container( // Creates a container for styling. // Erstellt einen Container für Styling.
                width: 200, // Sets the width to 200 logical pixels. // Setzt die Breite auf 200 logische Pixel.
                height: 50, // Sets the height to 50 logical pixels. // Setzt die Höhe auf 50 logische Pixel.
                decoration: BoxDecoration( // Defines the visual decoration of the container. // Definiert die visuelle Dekoration des Containers.
                  color: const Color((0xffF5F7FA)), // Sets the background color. // Setzt die Hintergrundfarbe.
                  borderRadius: BorderRadius.circular(10.0), // Rounds the corners with a 10.0 radius. // Rundet die Ecken mit einem Radius von 10.0.
                  border: Border.all(color: Colors.transparent), // Adds a transparent border. // Fügt einen transparenten Rand hinzu.
                ),
                padding: const EdgeInsets.all(10.0), // Adds 10.0 pixels of padding on all sides. // Fügt auf allen Seiten 10.0 Pixel Polsterung hinzu.
                child: Center( // Centers the child widget. // Zentriert das Kind-Widget.
                  child: Text( // Creates a text widget for the current time frame. // Erstellt ein Text-Widget für den aktuellen Zeitrahmen.
                    widget.currentTimeFrame, // Displays the current time frame text. // Zeigt den aktuellen Zeitrahmentext an.
                    textAlign: TextAlign.center, // Centers the text horizontally. // Zentriert den Text horizontal.
                    style: GoogleFonts.nunito( // Applies Nunito font style from Google Fonts. // Wendet den Nunito-Schriftstil von Google Fonts an.
                      color: const Color.fromARGB(255, 0, 0, 0), // Sets text color to black. // Setzt die Textfarbe auf Schwarz.
                      fontSize: 16.0, // Sets the font size to 16.0 logical pixels. // Setzt die Schriftgröße auf 16.0 logische Pixel.
                      fontWeight: FontWeight.w600, // Sets the font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
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
