/// ColorChoice
/// 
/// A color selection widget that displays a title and a row of color options. // Ein Farbauswahl-Widget, das einen Titel und eine Reihe von Farboptionen anzeigt.
/// Used to allow users to customize color settings in the application. // Wird verwendet, um Benutzern die Anpassung von Farbeinstellungen in der Anwendung zu ermöglichen.
/// 
/// Usage:
/// ```dart
/// final darkThemeColorProvider = StateProvider<Color>((ref) => Colors.blue);
/// 
/// ColorChoice(
///   title: 'Theme Color',
///   darkColorProvider: darkThemeColorProvider,
///   darkColorOptions: [Colors.blue, Colors.purple, Colors.red, Colors.green],
/// )
/// ```
/// 
/// EN: Creates a list tile with a title and a row of selectable color circles, with the currently selected color highlighted.
/// DE: Erstellt eine Listenzeile mit einem Titel und einer Reihe auswählbarer Farbkreise, wobei die aktuell ausgewählte Farbe hervorgehoben wird.

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for custom typography. // Importiert das Google Fonts-Paket für benutzerdefinierte Typografie.

class ColorChoice extends ConsumerWidget { // Defines a widget that can access Riverpod providers. // Definiert ein Widget, das auf Riverpod-Provider zugreifen kann.
  final String title; // The title text to display for this color choice. // Der Titeltext, der für diese Farbauswahl angezeigt wird.
  final StateProvider<Color> darkColorProvider; // The state provider that holds the currently selected color. // Der State-Provider, der die aktuell ausgewählte Farbe enthält.
  final List<Color> darkColorOptions; // The list of color options to display. // Die Liste der anzuzeigenden Farboptionen.

  const ColorChoice({ // Constructor for the ColorChoice widget. // Konstruktor für das ColorChoice-Widget.
    super.key, // Parent class key parameter. // Elternklassen-Key-Parameter.
    required this.title, // Required title parameter. // Erforderlicher Titel-Parameter.
    required this.darkColorProvider, // Required color provider parameter. // Erforderlicher Farbanbieter-Parameter.
    required this.darkColorOptions, // Required color options parameter. // Erforderlicher Farboptionen-Parameter.
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Overrides the build method to create the UI with Riverpod reference. // Überschreibt die build-Methode, um die Benutzeroberfläche mit Riverpod-Referenz zu erstellen.
    final currentColor = ref.watch(darkColorProvider); // Gets the current color value from the provider. // Ruft den aktuellen Farbwert vom Provider ab.

    return ListTile( // Returns a ListTile widget for consistent list-like appearance. // Gibt ein ListTile-Widget für ein konsistentes listenähnliches Erscheinungsbild zurück.
      title: Text( // Creates a text widget for the title. // Erstellt ein Text-Widget für den Titel.
        title, // Uses the provided title string. // Verwendet den bereitgestellten Titel-String.
        style: GoogleFonts.nunito( // Applies Google Font styling. // Wendet Google Fonts-Styling an.
          color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt die Textfarbe auf hellgrau.
        ),
      ),
      trailing: Row( // Creates a row of widgets for the color options. // Erstellt eine Reihe von Widgets für die Farboptionen.
        mainAxisSize: MainAxisSize.min, // Makes the row take minimum required space. // Lässt die Zeile minimalen erforderlichen Platz einnehmen.
        children:
            (darkColorOptions) // Uses the provided color options list. // Verwendet die bereitgestellte Liste der Farboptionen.
                .map((color) { // Maps each color to a button widget. // Ordnet jeder Farbe ein Button-Widget zu.
          return IconButton( // Creates an icon button for each color. // Erstellt einen Icon-Button für jede Farbe.
            onPressed: () { // Defines the button press handler. // Definiert den Button-Druck-Handler.
               ref.read(darkColorProvider.notifier).state = color; // Updates the state provider with the selected color. // Aktualisiert den State-Provider mit der ausgewählten Farbe.
              
            },
            icon: Container( // Creates a container for custom styling. // Erstellt einen Container für benutzerdefiniertes Styling.
              decoration: BoxDecoration( // Adds decoration to the container. // Fügt dem Container Dekoration hinzu.
                shape: BoxShape.circle, // Makes the container circular. // Macht den Container kreisförmig.
                border: Border.all( // Adds a border around the circle. // Fügt einen Rand um den Kreis hinzu.
                  color: currentColor == color // Checks if this is the currently selected color. // Prüft, ob dies die aktuell ausgewählte Farbe ist.
                      ? const Color.fromARGB(255, 168, 166, 166) // Light gray border for selected color. // Hellgrauer Rand für ausgewählte Farbe.
                      : Colors.transparent, // Transparent border for unselected colors. // Transparenter Rand für nicht ausgewählte Farben.
                  width: 2.0, // Sets the border width. // Setzt die Randbreite.
                ),
              ),
              child: Icon( // Creates an icon within the container. // Erstellt ein Symbol innerhalb des Containers.
                Icons.circle, // Uses a circle icon. // Verwendet ein Kreissymbol.
                color: color, // Sets the icon color to the current color option. // Setzt die Symbolfarbe auf die aktuelle Farboption.
              ),
            ),
            splashRadius: 24.0, // Sets the splash effect radius for the button. // Setzt den Radius des Splash-Effekts für die Schaltfläche.
          );
        }).toList(), // Converts the mapped buttons to a list. // Konvertiert die abgebildeten Schaltflächen in eine Liste.
      ),
    );
  }
}
