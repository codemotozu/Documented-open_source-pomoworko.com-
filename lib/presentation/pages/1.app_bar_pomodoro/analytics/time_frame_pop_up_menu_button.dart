/// TimeFramePopupMenuButton
/// 
/// A custom dropdown widget for selecting time frames (Weekly, Monthly, Yearly). // Ein benutzerdefiniertes Dropdown-Widget zur Auswahl von Zeiträumen (Wöchentlich, Monatlich, Jährlich).
/// Shows lock icons on premium-only options for non-premium users. // Zeigt Schloss-Symbole bei Premium-Optionen für Nicht-Premium-Benutzer.
/// 
/// Usage:
/// ```dart
/// TimeFramePopupMenuButton(
///   timeFrames: ['Weekly', 'Monthly', 'Yearly'],
///   currentTimeFrame: selectedTimeFrame,
///   onTimeFrameSelected: (value) => setState(() => selectedTimeFrame = value),
///   isPremium: userIsPremium,
/// )
/// ```
/// 
/// EN: Creates a customized popup menu for time frame selection with premium feature indicators.
/// DE: Erstellt ein angepasstes Popup-Menü zur Zeitrahmenauswahl mit Anzeigen für Premium-Funktionen.

import 'package:flutter/cupertino.dart'; // Imports iOS-style widgets from Flutter. // Importiert iOS-Stil-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets and theme. // Importiert Material Design Widgets und Theme.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.

class TimeFramePopupMenuButton extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod integration. // Definiert ein zustandsbehaftetes Widget mit Riverpod-Integration.
  final List<String> timeFrames; // List of available time frame options. // Liste der verfügbaren Zeitrahmenoptionen.
  final String currentTimeFrame; // Currently selected time frame. // Aktuell ausgewählter Zeitrahmen.
  final Function(String) onTimeFrameSelected; // Callback when a time frame is selected. // Callback, wenn ein Zeitrahmen ausgewählt wird.
  final bool isPremium; // User premium status flag. // Benutzer-Premium-Status-Flag.

  const TimeFramePopupMenuButton({ // Constructor for the widget. // Konstruktor für das Widget.
    required this.timeFrames, // Required parameter for time frame options. // Erforderlicher Parameter für Zeitrahmenoptionen.
    required this.currentTimeFrame, // Required parameter for currently selected time frame. // Erforderlicher Parameter für aktuell ausgewählten Zeitrahmen.
    required this.onTimeFrameSelected, // Required parameter for selection callback. // Erforderlicher Parameter für Auswahl-Callback.
    this.isPremium = false, // Optional parameter for premium status, defaults to false. // Optionaler Parameter für Premium-Status, standardmäßig falsch.
    super.key, // Optional key parameter passed to parent. // Optionaler Schlüsselparameter an übergeordnetes Element übergeben.
  });

  @override
  ConsumerState<TimeFramePopupMenuButton> createState() =>
      _TimeFramePopupMenuButtonState(); // Creates the mutable state for this widget. // Erstellt den veränderbaren Zustand für dieses Widget.
}

class _TimeFramePopupMenuButtonState
    extends ConsumerState<TimeFramePopupMenuButton> { // State class for TimeFramePopupMenuButton. // Zustandsklasse für TimeFramePopupMenuButton.
  bool isPremium = false; // Local premium flag (unused, uses widget.isPremium instead). // Lokales Premium-Flag (unbenutzt, verwendet stattdessen widget.isPremium).
  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    return Material( // Outer Material widget for visual effects. // Äußeres Material-Widget für visuelle Effekte.
      borderRadius: BorderRadius.circular(10.0), // Rounded corners with 10 pixel radius. // Abgerundete Ecken mit 10 Pixel Radius.
      child: Theme( // Theme override for popup. // Theme-Überschreibung für Popup.
        data: Theme.of(context).copyWith( // Copies current theme with modifications. // Kopiert aktuelles Theme mit Änderungen.
          splashFactory: NoSplash.splashFactory, // Disables ripple effect. // Deaktiviert Welleneffekt.
          splashColor: Colors.transparent, // Makes splash transparent. // Macht Splash transparent.
          highlightColor: Colors.transparent, // Makes highlight transparent. // Macht Hervorhebung transparent.
          hoverColor: Colors.transparent, // Makes hover effect transparent. // Macht Hover-Effekt transparent.
        ),
        child: PopupMenuButton<String>( // Popup menu for time frame selection. // Popup-Menü für Zeitrahmenauswahl.
          color: const Color((0xffF5F7FA)), // Light gray background for popup. // Hellgrauer Hintergrund für Popup.
          tooltip: "Select time frame", // Tooltip text on hover. // Tooltip-Text beim Darüberfahren.
          shape: RoundedRectangleBorder( // Shape of the popup menu. // Form des Popup-Menüs.
            borderRadius: BorderRadius.circular(10.0), // Rounded corners with 10 pixel radius. // Abgerundete Ecken mit 10 Pixel Radius.
          ),
          onSelected: (frame) { // Called when a time frame is selected. // Wird aufgerufen, wenn ein Zeitrahmen ausgewählt wird.
            widget.onTimeFrameSelected(frame); // Calls the provided callback with selected frame. // Ruft den bereitgestellten Callback mit ausgewähltem Rahmen auf.
          },
          itemBuilder: (BuildContext context) => widget.timeFrames // Builds menu items from timeFrames list. // Erstellt Menüelemente aus der timeFrames-Liste.
              .map( // Maps each time frame to a PopupMenuItem. // Ordnet jeden Zeitrahmen einem PopupMenuItem zu.
                (frame) => PopupMenuItem<String>( // Creates menu item for each time frame. // Erstellt Menüelement für jeden Zeitrahmen.
                  value: frame, // Value to be returned when selected. // Wert, der bei Auswahl zurückgegeben wird.
                  child: Row( // Horizontal layout for menu item. // Horizontales Layout für Menüelement.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces children with maximum space between. // Verteilt Kinder mit maximalem Abstand dazwischen.
                    children: [
                      //** icon open or lock
                      Text( // Time frame label text. // Zeitrahmen-Beschriftungstext.
                        frame, // The time frame name (Weekly/Monthly/Yearly). // Der Zeitrahmenname (Wöchentlich/Monatlich/Jährlich).
                        style: GoogleFonts.nunito( // Nunito font style. // Nunito-Schriftstil.
                          color: const Color.fromARGB(255, 0, 0, 0), // Black text color. // Schwarze Textfarbe.
                          fontWeight: FontWeight.w600, // Semi-bold font weight. // Halbfette Schriftstärke.
                        ),
                      ),

                      if ((frame == "Monthly" || frame == "Yearly") && // If premium time frame and user is not premium. // Wenn Premium-Zeitrahmen und Benutzer nicht Premium ist.
                          !widget.isPremium)
                        const Icon(CupertinoIcons.lock, // Lock icon for premium-only options. // Schloss-Symbol für Premium-Optionen.
                            size: 18, color: Colors.black), // Small black lock icon. // Kleines schwarzes Schloss-Symbol.
                      if ((frame == "Monthly" || frame == "Yearly") && // If premium time frame and user is premium. // Wenn Premium-Zeitrahmen und Benutzer Premium ist.
                          widget.isPremium)
                        const Icon(CupertinoIcons.lock_open, // Unlocked icon for available premium options. // Entsperrtes Symbol für verfügbare Premium-Optionen.
                            size: 18, color: Colors.black), // Small black unlocked icon. // Kleines schwarzes entsperrtes Symbol.
                    ],
                  ),
                ),
              )
              .toList(), // Converts map result to a list. // Konvertiert Map-Ergebnis in eine Liste.
          child: SizedBox( // Container for the button display. // Container für die Schaltflächenanzeige.
            width: 165, // Fixed width of 165 pixels. // Feste Breite von 165 Pixeln.
            child: Material( // Material widget for visual effects. // Material-Widget für visuelle Effekte.
              type: MaterialType.transparency, // Transparent material type. // Transparenter Material-Typ.
              elevation: 2, // Slight shadow elevation. // Leichte Schattenerhebung.
              borderRadius: BorderRadius.circular(14.0), // Rounded corners. // Abgerundete Ecken.
              child: Container( // Visual container for button. // Visueller Container für Schaltfläche.
                width: 200, // Container width (overridden by parent SizedBox). // Container-Breite (überschrieben durch übergeordneten SizedBox).
                height: 50, // Container height of 50 pixels. // Container-Höhe von 50 Pixeln.
                decoration: BoxDecoration( // Visual styling for container. // Visuelle Gestaltung für Container.
                   color: const Color((0xffF5F7FA)), // Light gray background. // Hellgrauer Hintergrund.

                  borderRadius: BorderRadius.circular(10.0), // Rounded corners. // Abgerundete Ecken.
                  border: Border.all(color: Colors.transparent), // Transparent border. // Transparenter Rand.
                ),
                padding: const EdgeInsets.all(10.0), // 10 pixel padding all around. // 10 Pixel Abstand rundum.
                child: Center( // Centers the text in the container. // Zentriert den Text im Container.
                  child: Text( // Text showing current selection. // Text, der aktuelle Auswahl anzeigt.
                    widget.currentTimeFrame, // Current time frame text. // Aktueller Zeitrahmentext.
                    textAlign: TextAlign.center, // Center-aligned text. // Zentrierter Text.
                    style: GoogleFonts.nunito( // Nunito font style. // Nunito-Schriftstil.
                      color: const Color.fromARGB(255, 0, 0, 0), // Black text color. // Schwarze Textfarbe.
                      fontSize: 16.0, // 16 point font size. // 16 Punkt Schriftgröße.
                       fontWeight: FontWeight.w600, // Semi-bold font weight. // Halbfette Schriftstärke.
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
