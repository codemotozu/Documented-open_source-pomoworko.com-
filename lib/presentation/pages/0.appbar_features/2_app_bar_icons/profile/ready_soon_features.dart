/// PremiumReadySoon 
/// 
/// A dialog widget that informs users about upcoming premium features.
/// Used throughout the application when users attempt to access premium-only features.
/// 
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => const PremiumReadySoon(),
/// );
/// ```
/// 
/// EN: Displays a Cupertino-style alert dialog with information about upcoming premium features.
/// DE: Zeigt einen Dialog im Cupertino-Stil mit Informationen über kommende Premium-Funktionen an.

import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets from Flutter. // Importiert Cupertino-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.

class PremiumReadySoon extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const PremiumReadySoon({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => // Overrides createState to return a state object. // Überschreibt createState, um ein State-Objekt zurückzugeben.
      _PremiumReadySoonState(); // Returns instance of the state class. // Gibt eine Instanz der State-Klasse zurück.
}

class _PremiumReadySoonState extends ConsumerRef<PremiumReadySoon> { // Defines the state class for PremiumReadySoon widget. // Definiert die State-Klasse für das PremiumReadySoon-Widget.
  @override
  Widget build(BuildContext context) { // Overrides build method to create the UI. // Überschreibt die build-Methode, um die Benutzeroberfläche zu erstellen.
    return CupertinoAlertDialog( // Returns a Cupertino-style alert dialog. // Gibt einen Dialog im Cupertino-Stil zurück.
      title: const Text( // Creates a title text widget. // Erstellt ein Titel-Text-Widget.
        'The premium version is coming soon!', // The title text content. // Der Inhalt des Titeltextes.
        style: TextStyle( // Style configuration for the text. // Stilkonfiguration für den Text.
          fontWeight: FontWeight.bold, // Sets the font weight to bold. // Setzt die Schriftstärke auf fett.
          fontSize: 18, // Sets the font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
          fontFamily: 'San Francisco', // Sets the font family to San Francisco. // Setzt die Schriftfamilie auf San Francisco.
        ),
      ),
      content: const Text( // Creates a content text widget. // Erstellt ein Inhalts-Text-Widget.
        'We are working hard to bring you the premium version of the app. Stay tuned!', // The content message. // Die Inhaltsnachricht.
        style: TextStyle( // Style configuration for the content. // Stilkonfiguration für den Inhalt.
          fontSize: 16, // Sets the font size to 16 logical pixels. // Setzt die Schriftgröße auf 16 logische Pixel.
          fontFamily: 'San Francisco', // Sets the font family to San Francisco. // Setzt die Schriftfamilie auf San Francisco.
          color: Colors.grey, // Sets the text color to grey. // Setzt die Textfarbe auf Grau.
        ),
      ),
      actions: <Widget>[ // List of action buttons for the dialog. // Liste der Aktionsschaltflächen für den Dialog.
        CupertinoDialogAction( // Creates a Cupertino-style dialog action button. // Erstellt eine Dialogaktionsschaltfläche im Cupertino-Stil.
          child: const Text( // Text widget for the button. // Text-Widget für die Schaltfläche.
            'OK', // The button text. // Der Schaltflächentext.
            style: TextStyle( // Style configuration for the button text. // Stilkonfiguration für den Schaltflächentext.
              color: Color(0xff1BBF72), // Sets text color to a green shade. // Setzt die Textfarbe auf einen grünen Farbton.
              fontWeight: FontWeight.bold, // Sets the font weight to bold. // Setzt die Schriftstärke auf fett.
              fontSize: 18, // Sets the font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
              fontFamily: 'San Francisco', // Sets the font family to San Francisco. // Setzt die Schriftfamilie auf San Francisco.
            ),
          ),
          onPressed: () { // Function called when the button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
            Navigator.of(context).pop(); // Closes the dialog. // Schließt den Dialog.
          },
        ),
      ],
    );
  }
}



