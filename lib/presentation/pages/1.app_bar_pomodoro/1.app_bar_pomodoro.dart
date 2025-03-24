/// PomodoroLogo
/// 
/// A widget that displays the application logo in the app bar. // Ein Widget, das das Anwendungslogo in der App-Leiste anzeigt. 
/// Used as the main header component for the application, featuring the "pomoworko.com" branding. // Wird als Hauptkopfkomponente für die Anwendung verwendet und zeigt das "pomoworko.com"-Branding.
/// 
/// Usage:
/// ```dart
/// Scaffold(
///   appBar: AppBar(
///     title: const PomodoroLogo(),
///   ),
///   body: ...
/// )
/// ```
/// 
/// EN: Displays a stylized "pomoworko.com" logo text with the "work" portion underlined.
/// DE: Zeigt einen stilisierten "pomoworko.com"-Logotext mit dem unterstrichenen Teil "work".

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for text styling. // Importiert das Google Fonts-Paket für die Textgestaltung.

import '../../notifiers/providers.dart'; // Imports application providers for state management. // Importiert Anwendungsprovider für die Zustandsverwaltung.

class PomodoroLogo extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const PomodoroLogo({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  _PomodoroLogoState createState() => _PomodoroLogoState(); // Creates the state object for this widget. // Erstellt das State-Objekt für dieses Widget.
}

class _PomodoroLogoState extends ConsumerState<PomodoroLogo> { // Defines the state class for PomodoroLogo widget. // Definiert die State-Klasse für das PomodoroLogo-Widget.
  @override
  Widget build(BuildContext context) { // Overrides build method to create the UI. // Überschreibt die build-Methode, um die Benutzeroberfläche zu erstellen.
    return Scaffold( // Creates a Material Design basic page layout. // Erstellt ein Material Design-Grundseitenlayout.
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Sets the background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
      appBar: AppBar( // Creates an app bar for the scaffold. // Erstellt eine App-Leiste für das Scaffold.
        backgroundColor: ref.watch(currentColorProvider), // Sets app bar color from a Riverpod provider. // Setzt die App-Leisten-Farbe aus einem Riverpod-Provider.
        title: Row( // Creates a row layout for the title. // Erstellt ein Zeilenlayout für den Titel.
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Places children at start and end of the row. // Platziert Kinder am Anfang und Ende der Zeile.
          children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
            Text.rich( // Creates a rich text widget with multiple styles. // Erstellt ein Rich-Text-Widget mit mehreren Stilen.
              TextSpan( // Root text span for rich text. // Stamm-TextSpan für den Rich-Text.
                text: ' pomo', // First part of the logo text. // Erster Teil des Logotextes.
                style: GoogleFonts.nunito( // Applies Nunito font style from Google Fonts. // Wendet den Nunito-Schriftstil von Google Fonts an.
                  fontSize: 22, // Sets the font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                  color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt die Textfarbe auf Hellgrau.
                  fontWeight: FontWeight.w600, // Sets the font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                ),
                children: <TextSpan>[ // List of additional text spans. // Liste zusätzlicher TextSpans.
                  TextSpan( // Text span for the "work" part. // TextSpan für den "work"-Teil.
                    text: 'work', // Middle part of the logo text. // Mittlerer Teil des Logotextes.
                    style: GoogleFonts.nunito( // Applies Nunito font style with additional decoration. // Wendet den Nunito-Schriftstil mit zusätzlicher Dekoration an.
                      fontSize: 22, // Sets the font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                      color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt die Textfarbe auf Hellgrau.
                      decoration: TextDecoration.underline, // Adds underline decoration to the text. // Fügt dem Text eine Unterstreichungsdekoration hinzu.
                      decorationColor: const Color(0xffF2F2F2), // Sets the underline color to light gray. // Setzt die Unterstreichungsfarbe auf Hellgrau.
                      decorationThickness: 3, // Sets the underline thickness to 3 logical pixels. // Setzt die Unterstreichungsdicke auf 3 logische Pixel.
                      fontWeight: FontWeight.w600, // Sets the font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                    ),
                  ),
                  TextSpan( // Text span for the ".com" part. // TextSpan für den ".com"-Teil.
                    text: 'o.com', // Last part of the logo text. // Letzter Teil des Logotextes.
                    style: GoogleFonts.nunito( // Applies Nunito font style. // Wendet den Nunito-Schriftstil an.
                        fontSize: 22, // Sets the font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                        color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt die Textfarbe auf Hellgrau.
                        fontWeight: FontWeight.w600), // Sets the font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
