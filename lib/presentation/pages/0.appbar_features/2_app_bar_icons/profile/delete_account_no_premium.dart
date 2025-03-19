import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets from Flutter. // Importiert Cupertino-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package. // Importiert das Google Fonts-Paket.
import 'package:routemaster/routemaster.dart'; // Imports Routemaster for navigation. // Importiert Routemaster für die Navigation.

import '../../../../../router.dart'; // Imports router configuration from parent directory. // Importiert Router-Konfiguration aus übergeordnetem Verzeichnis.
import '../../../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert das Authentifizierungs-Repository.

class DeleteAccountNoPremium extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const DeleteAccountNoPremium({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => // Overrides createState to return a state object. // Überschreibt createState, um ein State-Objekt zurückzugeben.
      _DeleteAccountNoPremiumState(); // Returns instance of the state class. // Gibt eine Instanz der State-Klasse zurück.
}

class _DeleteAccountNoPremiumState // Defines the state class for DeleteAccountNoPremium widget. // Definiert die State-Klasse für das DeleteAccountNoPremium-Widget.
    extends ConsumerState<DeleteAccountNoPremium> { // Extends ConsumerState to access Riverpod providers. // Erweitert ConsumerState, um auf Riverpod-Provider zuzugreifen.
  @override
  Widget build(BuildContext context) { // Overrides build method, which returns the widget tree. // Überschreibt die build-Methode, die den Widget-Baum zurückgibt.
    return Padding( // Returns a Padding widget. // Gibt ein Padding-Widget zurück.
      padding: const EdgeInsets.all(8.0), // Sets padding of 8 logical pixels on all sides. // Setzt einen Abstand von 8 logischen Pixeln auf allen Seiten.
      child: Column( // Creates a vertical column of widgets. // Erstellt eine vertikale Spalte von Widgets.
        mainAxisSize: MainAxisSize.max, // Sets column to take maximum available height. // Legt fest, dass die Spalte die maximale verfügbare Höhe einnimmt.
        children: <Widget>[ // List of widgets to display vertically. // Liste von Widgets, die vertikal angezeigt werden.
          AppBar( // Creates an app bar at the top. // Erstellt eine App-Leiste oben.
            backgroundColor: Colors.transparent, // Makes the app bar background transparent. // Macht den Hintergrund der App-Leiste transparent.
            automaticallyImplyLeading: false, // Disables automatic back button. // Deaktiviert automatische Zurück-Schaltfläche.
            title: const Padding( // Title with padding. // Titel mit Abstand.
              padding: EdgeInsets.only(top: 10.0), // Adds 10 logical pixels padding at the top. // Fügt 10 logische Pixel Abstand oben hinzu.
              child: Text( // Text widget for the title. // Text-Widget für den Titel.
                "Delete Account", // The title text. // Der Titeltext.
                style: TextStyle( // Style configuration for the text. // Stilkonfiguration für den Text.
                  fontWeight: FontWeight.w700, // Sets font weight to 700 (bold). // Setzt die Schriftstärke auf 700 (fett).
                  fontSize: 22, // Sets font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                ),
              ),
            ),
            actions: [ // Widgets to display at the end of app bar. // Widgets, die am Ende der App-Leiste angezeigt werden.
              IconButton( // Button with an icon. // Schaltfläche mit einem Symbol.
                icon: const Icon( // Icon widget. // Symbol-Widget.
                  Icons.close, // Close (X) icon. // Schließen (X) Symbol.
                  size: 24, // Icon size of 24 logical pixels. // Symbolgröße von 24 logischen Pixeln.
                ),
                onPressed: () { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
                  Navigator.of(context).pop(); // Closes the current screen. // Schließt den aktuellen Bildschirm.
                },
              ),
            ],
            centerTitle: true, // Centers the title in the app bar. // Zentriert den Titel in der App-Leiste.
            elevation: 0, // Removes app bar shadow. // Entfernt den Schatten der App-Leiste.
            toolbarHeight: 35, // Sets app bar height to 35 logical pixels. // Setzt die Höhe der App-Leiste auf 35 logische Pixel.
          ),
          const Divider( // Horizontal dividing line. // Horizontale Trennlinie.
            color: Colors.grey, // Sets divider color to grey. // Setzt die Farbe der Trennlinie auf Grau.
            thickness: 0.5, // Sets divider thickness to 0.5 logical pixels. // Setzt die Dicke der Trennlinie auf 0,5 logische Pixel.
          ),
          const Material( // Material widget to apply Material Design. // Material-Widget, um Material Design anzuwenden.
            color: Colors.transparent, // Makes material background transparent. // Macht den Materialhintergrund transparent.
            child: ListTile( // List tile widget for structured layout. // ListTile-Widget für strukturiertes Layout.
              title: Column( // Column of widgets inside the list tile. // Spalte von Widgets innerhalb der ListTile.
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left in LTR). // Richtet Kinder am Anfang aus (links in LTR).
                children: [ // List of widgets in the column. // Liste von Widgets in der Spalte.
                  Text( // Text widget. // Text-Widget.
                    'Are you sure you want to delete your account?', // Question about account deletion. // Frage zur Kontolöschung.
                    style: TextStyle( // Text style configuration. // Textstil-Konfiguration.
                      fontSize: 18, // Font size of 18 logical pixels. // Schriftgröße von 18 logischen Pixeln.
                      fontFamily: 'San Francisco', // Sets font family to San Francisco. // Setzt die Schriftfamilie auf San Francisco.
                    ),
                    textAlign: TextAlign.center, // Centers the text horizontally. // Zentriert den Text horizontal.
                  ),
                  SizedBox( // Empty box for spacing. // Leere Box für Abstand.
                    height: 5, // Height of 5 logical pixels. // Höhe von 5 logischen Pixeln.
                  ),

                  Divider( // Another horizontal dividing line. // Weitere horizontale Trennlinie.
                    color: Colors.grey, // Grey color for the divider. // Graue Farbe für die Trennlinie.
                    thickness: 0.5, // Thickness of 0.5 logical pixels. // Dicke von 0,5 logischen Pixeln.
                  ),

                  Center( // Center widget to center its child. // Center-Widget, um sein Kind zu zentrieren.
                    child: Text( // Text widget. // Text-Widget.
                      'Data Loss', // Text showing "Data Loss". // Text zeigt "Datenverlust".
                      style: TextStyle( // Text style configuration. // Textstil-Konfiguration.
                        fontWeight: FontWeight.bold, // Bold font weight. // Fette Schriftstärke.
                        fontSize: 20, // Font size of 20 logical pixels. // Schriftgröße von 20 logischen Pixeln.
                        fontFamily: 'San Francisco', // San Francisco font family. // San Francisco Schriftfamilie.
                      ),
                      textAlign: TextAlign.center, // Centers the text horizontally. // Zentriert den Text horizontal.
                    ),
                  ),
                  Divider( // Another dividing line. // Weitere Trennlinie.
                    color: Colors.grey, // Grey color. // Graue Farbe.
                    thickness: 0.5, // 0.5 logical pixels thick. // 0,5 logische Pixel dick.
                  ),
                  Column( // Nested column for more content. // Verschachtelte Spalte für mehr Inhalt.
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left in LTR). // Richtet Kinder am Anfang aus (links in LTR).
                    children: [ // List of widgets in this column. // Liste von Widgets in dieser Spalte.
                      Row( // Horizontal row of widgets. // Horizontale Reihe von Widgets.
                        children: [ // Widgets in the row. // Widgets in der Reihe.
                          Icon( // Icon widget. // Symbol-Widget.
                            CupertinoIcons.exclamationmark_triangle, // Warning triangle icon. // Warndreieck-Symbol.
                            color: Colors.yellow, // Yellow color for the icon. // Gelbe Farbe für das Symbol.
                            size: 24, // Size of 24 logical pixels. // Größe von 24 logischen Pixeln.
                          ),
                          SizedBox( // Empty box for spacing. // Leere Box für Abstand.
                            width: 7.5, // Width of 7.5 logical pixels. // Breite von 7,5 logischen Pixeln.
                          ),
                          Expanded( // Expanded widget to fill available horizontal space. // Expanded-Widget, um verfügbaren horizontalen Raum zu füllen.
                            child: Wrap(children: [ // Wrap widget to wrap its children if needed. // Wrap-Widget, um seine Kinder bei Bedarf umzubrechen.
                              Text( // Text widget. // Text-Widget.
                                "Any data or content associated with your account will be permanently deleted and cannot be recovered after account deletion.", // Warning about permanent data loss. // Warnung vor dauerhaftem Datenverlust.
                                style: TextStyle( // Text style configuration. // Textstil-Konfiguration.
                                  fontSize: 18, // Font size of 18 logical pixels. // Schriftgröße von 18 logischen Pixeln.
                                  fontFamily: 'San Francisco', // San Francisco font family. // San Francisco Schriftfamilie.
                                  color: Colors.grey, // Grey color for the text. // Graue Farbe für den Text.
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 5), // Empty box for vertical spacing. // Leere Box für vertikalen Abstand.
                  Divider( // Another dividing line. // Weitere Trennlinie.
                    color: Colors.grey, // Grey color. // Graue Farbe.
                    thickness: 0.5, // 0.5 logical pixels thick. // 0,5 logische Pixel dick.
                  ),
                ],
              ),
            ),
          ),
          Row( // Horizontal row for buttons. // Horizontale Reihe für Schaltflächen.
            children: [ // Widgets in the row. // Widgets in der Reihe.
              Expanded( // Expanded widget to take available space. // Expanded-Widget, um verfügbaren Platz einzunehmen.
                flex: 1, // Flex factor of 1 (equal distribution). // Flex-Faktor von 1 (gleichmäßige Verteilung).
                child: Padding( // Padding widget for spacing. // Padding-Widget für Abstand.
                  padding: const EdgeInsets.fromLTRB(16, 0, 22, 0), // Padding on left and right sides. // Polsterung auf der linken und rechten Seite.
                  child: FloatingActionButton.extended( // Extended floating action button (rectangular). // Erweiterter schwebender Aktionsbutton (rechteckig).
                      backgroundColor: const Color(0xFF222225), //#222225 // Dark background color for the button. // Dunkle Hintergrundfarbe für die Schaltfläche.
                      onPressed: () { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
                        Navigator.of(context).pop(); // Closes the current screen. // Schließt den aktuellen Bildschirm.
                      },
                      label: const SizedBox( // SizedBox containing the button label. // SizedBox, die die Schaltflächenbeschriftung enthält.
                        child: Text( // Text widget for button label. // Text-Widget für Schaltflächenbeschriftung.
                          'Cancel', // Cancel button text. // Text der Abbrechen-Schaltfläche.
                          textAlign: TextAlign.center, // Centers the text horizontally. // Zentriert den Text horizontal.
                          style: TextStyle( // Text style configuration. // Textstil-Konfiguration.
                              fontFamily: 'San Francisco', // San Francisco font family. // San Francisco Schriftfamilie.
                              fontSize: 18, // Font size of 18 logical pixels. // Schriftgröße von 18 logischen Pixeln.
                              fontWeight: FontWeight.w700, // Font weight of 700 (bold). // Schriftstärke von 700 (fett).
                              color: Colors.white), // White text color. // Weiße Textfarbe.
                        ),
                      )),
                ),
              ),
              Expanded( // Another expanded widget for the second button. // Ein weiteres Expanded-Widget für die zweite Schaltfläche.
                flex: 1, // Flex factor of 1 (equal distribution). // Flex-Faktor von 1 (gleichmäßige Verteilung).
                child: Padding( // Padding for spacing. // Polsterung für Abstand.
                  padding: const EdgeInsets.fromLTRB(16, 0, 22, 0), // Padding on left and right sides. // Polsterung auf der linken und rechten Seite.
                  child: FloatingActionButton.extended( // Extended floating action button. // Erweiterter schwebender Aktionsbutton.
                      backgroundColor: const Color(0xFFFF4433), // Red background color for delete button. // Rote Hintergrundfarbe für Lösch-Schaltfläche.
                      onPressed: () async { // Async function for button press. // Asynchrone Funktion für Schaltflächendruck.
                        Navigator.of(context).pop(); // Closes the current screen. // Schließt den aktuellen Bildschirm.
                        final errorModel = await ref // Calls repository method to delete user account. // Ruft Repository-Methode zum Löschen des Benutzerkontos auf.
                            .read(authRepositoryProvider)
                            .deletePremiumOrNotPremiumUser(ref);

                        if (errorModel.error == null) { // Checks if operation completed without errors. // Prüft, ob der Vorgang ohne Fehler abgeschlossen wurde.
                          ScaffoldMessenger.of(context).showSnackBar( // Shows success message as a snackbar. // Zeigt Erfolgsmeldung als Snackbar an.
                            SnackBar(
                              content: Text(
                                'Account deleted successfully', // Success message. // Erfolgsmeldung.
                                style: GoogleFonts.nunito( // Sets Nunito font. // Setzt Nunito-Schrift.
                                  fontSize: 20, // Font size of 20 logical pixels. // Schriftgröße von 20 logischen Pixeln.
                                ),
                              ),
                            ),
                          );

                          ref // Updates user provider to null (logs out user). // Aktualisiert den Benutzer-Provider auf null (meldet Benutzer ab).
                              .read(userProvider.notifier)
                              .update((state) => null);
                          Routemaster.of(context).replace(HOME_ROUTE); // Navigates to home screen. // Navigiert zum Startbildschirm.
                        } else { // If there was an error. // Wenn ein Fehler aufgetreten ist.
                          ScaffoldMessenger.of(context).showSnackBar( // Shows error message as a snackbar. // Zeigt Fehlermeldung als Snackbar an.
                            SnackBar(
                              content: Text(errorModel.error!), // Displays the error message. // Zeigt die Fehlermeldung an.
                            ),
                          );
                        }
                      },
                      label: const SizedBox( // SizedBox for button label. // SizedBox für Schaltflächenbeschriftung.
                        child: Text( // Text widget for button label. // Text-Widget für Schaltflächenbeschriftung.
                          'Delete', // Delete button text. // Text der Löschen-Schaltfläche.
                          textAlign: TextAlign.center, // Centers the text horizontally. // Zentriert den Text horizontal.
                          style: TextStyle( // Text style configuration. // Textstil-Konfiguration.
                              fontFamily: 'San Francisco', // San Francisco font family. // San Francisco Schriftfamilie.
                              fontSize: 18, // Font size of 18 logical pixels. // Schriftgröße von 18 logischen Pixeln.
                              fontWeight: FontWeight.w700, // Font weight of 700 (bold). // Schriftstärke von 700 (fett).
                              color: Colors.black), // Black text color. // Schwarze Textfarbe.
                        ),
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
