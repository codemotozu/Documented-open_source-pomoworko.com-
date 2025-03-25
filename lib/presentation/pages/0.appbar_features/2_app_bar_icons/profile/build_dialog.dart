/// DialogContentItem
/// 
/// A reusable widget that renders standardized dialog content with a title and description. // Ein wiederverwendbares Widget, das standardisierte Dialog-Inhalte mit Titel und Beschreibung rendert.
/// Used throughout the application to maintain consistent styling in dialog boxes. // Wird in der gesamten Anwendung verwendet, um ein einheitliches Styling in Dialogfenstern zu gewährleisten.
/// 
/// Usage:
/// ```dart
/// BuildDialogItem(
///   "Feature Unavailable",
///   "This feature will be available in a future update."
/// )
/// ```
/// 
/// EN: Creates uniformly styled dialog content with a bold title and gray description text.
/// DE: Erstellt einheitlich gestaltete Dialog-Inhalte mit fettem Titel und grauem Beschreibungstext.

import 'package:flutter/material.dart';  // Imports the Flutter Material Design package.  // Importiert das Flutter Material Design Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports the Riverpod state management package.  // Importiert das Riverpod State-Management-Paket.

class BuildDialogItem extends ConsumerStatefulWidget {  // Defines a stateful widget that can access Riverpod providers.  // Definiert ein zustandsbehaftetes Widget, das auf Riverpod-Provider zugreifen kann.
  final String title;  // Declares a final variable to store the title.  // Deklariert eine finale Variable zur Speicherung des Titels.
  final String description;  // Declares a final variable to store the description.  // Deklariert eine finale Variable zur Speicherung der Beschreibung.
  const BuildDialogItem(
    this.title,
    this.description, {super.key}  // Constructor that initializes title and description with optional key parameter.  // Konstruktor, der Titel und Beschreibung mit optionalem Key-Parameter initialisiert.
  );
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BuildDialogItemState();  // Creates the state object for this widget.  // Erstellt das State-Objekt für dieses Widget.
}

class _BuildDialogItemState extends ConsumerState<BuildDialogItem> {  // Defines the state class for BuildDialogItem.  // Definiert die State-Klasse für BuildDialogItem.
  @override
  Widget build(
    BuildContext context,  // Receives the build context as parameter.  // Erhält den Build-Kontext als Parameter.
  ) {
    return Column(  // Returns a Column widget that arranges its children vertically.  // Gibt ein Column-Widget zurück, das seine Kinder vertikal anordnet.
      crossAxisAlignment: CrossAxisAlignment.start,  // Aligns children to the start (left) of the cross axis.  // Richtet Kinder am Anfang (links) der Querachse aus.
      children: [  // List of widgets to display as children.  // Liste der Widgets, die als Kinder angezeigt werden.
        Text(
          widget.title,  // Displays the title passed to the widget.  // Zeigt den an das Widget übergebenen Titel an.
          textAlign: TextAlign.left,  // Aligns the text to the left.  // Richtet den Text linksbündig aus.
          style: const TextStyle(  // Defines the text style as a constant.  // Definiert den Textstil als Konstante.
              fontWeight: FontWeight.w700,  // Sets the font weight to bold (700).  // Setzt die Schriftstärke auf fett (700).
              fontSize: 22,  // Sets the font size to 22 logical pixels.  // Setzt die Schriftgröße auf 22 logische Pixel.
              fontFamily: 'San Francisco'),  // Sets the font family to San Francisco.  // Setzt die Schriftfamilie auf San Francisco.
        ),
        const SizedBox(height: 5),  // Adds a fixed vertical space of 5 logical pixels.  // Fügt einen festen vertikalen Abstand von 5 logischen Pixeln hinzu.
        Text(
          widget.description,  // Displays the description passed to the widget.  // Zeigt die an das Widget übergebene Beschreibung an.
          textAlign: TextAlign.left,  // Aligns the text to the left.  // Richtet den Text linksbündig aus.
          style: const TextStyle(  // Defines the text style as a constant.  // Definiert den Textstil als Konstante.
            fontSize: 18,  // Sets the font size to 18 logical pixels.  // Setzt die Schriftgröße auf 18 logische Pixel.
            fontFamily: 'San Francisco',  // Sets the font family to San Francisco.  // Setzt die Schriftfamilie auf San Francisco.
            color: Colors.grey,  // Sets the text color to grey.  // Setzt die Textfarbe auf Grau.
          ),
        ),
      ],
    );
  }
}
