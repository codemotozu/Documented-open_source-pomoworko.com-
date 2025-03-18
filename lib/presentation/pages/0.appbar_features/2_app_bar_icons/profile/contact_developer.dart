import 'package:flutter/material.dart';  // Imports the Flutter Material Design package.  // Importiert das Flutter Material Design Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports the Riverpod state management package.  // Importiert das Riverpod State-Management-Paket.

import '../../../../notifiers/providers.dart';  // Imports providers from the notifiers folder.  // Importiert Provider aus dem notifiers-Ordner.
import '../../../../repository/auth_repository.dart';  // Imports the authentication repository.  // Importiert das Authentifizierungs-Repository.

class ContactDeveloper extends ConsumerStatefulWidget {  // Defines a stateful widget that can access Riverpod providers.  // Definiert ein zustandsbehaftetes Widget, das auf Riverpod-Provider zugreifen kann.
  const ContactDeveloper({super.key});  // Constructor with optional key parameter.  // Konstruktor mit optionalem key-Parameter.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactDeveloperState();  // Creates the state object for this widget.  // Erstellt das State-Objekt für dieses Widget.
}

class _ContactDeveloperState extends ConsumerState<ContactDeveloper> {  // Defines the state class for ContactDeveloper.  // Definiert die State-Klasse für ContactDeveloper.
  @override
  Widget build(BuildContext context) {  // Builds the UI for this widget.  // Baut die Benutzeroberfläche für dieses Widget.
    final themeMode = ref.watch(themeModeProvider);  // Gets the current theme mode from the provider.  // Holt den aktuellen Themenmodus vom Provider.
    final userModel = ref.watch(userProvider);  // Gets the current user model from the provider.  // Holt das aktuelle Benutzermodell vom Provider.

    return Padding(  // Returns a Padding widget to add space around its child.  // Gibt ein Padding-Widget zurück, um Abstand um sein Kind zu schaffen.
      padding: const EdgeInsets.all(8.0),  // Adds 8.0 pixels of padding on all sides.  // Fügt 8.0 Pixel Abstand an allen Seiten hinzu.
      child: Column(  // Creates a vertical column of widgets.  // Erstellt eine vertikale Spalte von Widgets.
        mainAxisSize: MainAxisSize.max,  // Makes the column take up all available vertical space.  // Lässt die Spalte den gesamten verfügbaren vertikalen Raum einnehmen.
        children: <Widget>[  // List of widgets to display as children.  // Liste der Widgets, die als Kinder angezeigt werden.
          AppBar(  // Creates an app bar.  // Erstellt eine App-Bar.
            backgroundColor: Colors.transparent,  // Makes the app bar background transparent.  // Macht den Hintergrund der App-Bar transparent.
            automaticallyImplyLeading: false,  // Disables automatic back button.  // Deaktiviert den automatischen Zurück-Button.
            title: const Padding(  // Title widget with padding.  // Titel-Widget mit Abstand.
              padding: EdgeInsets.only(top: 10.0),  // Adds 10.0 pixels of padding only at the top.  // Fügt nur oben 10.0 Pixel Abstand hinzu.
              child: Text(  // Text widget for the title.  // Text-Widget für den Titel.
                "Contact with the developer",  // The title text.  // Der Titeltext.
                style: TextStyle(  // Style for the title text.  // Stil für den Titeltext.
                  fontWeight: FontWeight.w700,  // Bold font weight.  // Fette Schriftstärke.
                  fontSize: 22,  // Font size of 22 pixels.  // Schriftgröße von 22 Pixeln.
                ),
              ),
            ),
            actions: [  // List of action widgets for the app bar.  // Liste von Aktions-Widgets für die App-Bar.
              IconButton(  // Creates an icon button.  // Erstellt einen Icon-Button.
                icon: const Icon(  // The icon to display.  // Das anzuzeigende Icon.
                  Icons.close,  // Close/X icon.  // Schließen/X-Symbol.
                  size: 24,  // Icon size of 24 pixels.  // Icon-Größe von 24 Pixeln.
                ),
                onPressed: () {  // Function to call when button is pressed.  // Funktion, die beim Drücken des Buttons aufgerufen wird.
                  Navigator.of(context).pop();  // Closes the current screen.  // Schließt den aktuellen Bildschirm.
                },
              ),
            ],
            centerTitle: true,  // Centers the title.  // Zentriert den Titel.
            elevation: 0,  // Removes shadow below app bar.  // Entfernt den Schatten unter der App-Bar.
            toolbarHeight: 35,  // Sets the app bar height to 35 pixels.  // Setzt die Höhe der App-Bar auf 35 Pixel.
          ),
          const Divider(  // Creates a horizontal divider line.  // Erstellt eine horizontale Trennlinie.
            color: Colors.grey,  // Grey color for the divider.  // Graue Farbe für die Trennlinie.
            thickness: 0.5,  // Thickness of 0.5 pixels.  // Dicke von 0,5 Pixeln.
          ),
          const Material(  // Creates a Material widget for its ink effects.  // Erstellt ein Material-Widget für seine Tinteneffekte.
            color: Colors.transparent,  // Transparent background.  // Transparenter Hintergrund.
            child: ListTile(  // Creates a list tile.  // Erstellt eine Listenkachel.
              title: Column(  // Column widget as the title.  // Spalten-Widget als Titel.
                crossAxisAlignment: CrossAxisAlignment.start,  // Aligns children to the start (left).  // Richtet Kinder am Anfang (links) aus.
                children: [  // List of child widgets.  // Liste der Kind-Widgets.
                  Center(  // Centers its child widget.  // Zentriert sein Kind-Widget.
                    child: Text(  // Text widget.  // Text-Widget.
                      'Email:',  // The text to display.  // Der anzuzeigende Text.
                      style: TextStyle(  // Style for the text.  // Stil für den Text.
                        fontWeight: FontWeight.w600,  // Semi-bold font weight.  // Halbfette Schriftstärke.
                        fontSize: 22,  // Font size of 22 pixels.  // Schriftgröße von 22 Pixeln.
                      ),
                      textAlign: TextAlign.center,  // Centers the text.  // Zentriert den Text.
                    ),
                  ),
                  SizedBox(height: 5),  // Adds 5 pixels of vertical spacing.  // Fügt 5 Pixel vertikalen Abstand hinzu.
                  SelectableText(  // Text that can be selected by the user.  // Text, der vom Benutzer ausgewählt werden kann.
                    'contact.pomoworko@gmail.com\n (for general inquiries, support, and bugs)',  // The email address with description.  // Die E-Mail-Adresse mit Beschreibung.
                    showCursor: true,  // Shows cursor when selecting.  // Zeigt den Cursor beim Auswählen.
                    scrollPhysics: ClampingScrollPhysics(),  // Physics type for scrolling behavior.  // Physiktyp für das Scrollverhalten.
                    style: TextStyle(  // Style for the text.  // Stil für den Text.
                      fontSize: 18,  // Font size of 18 pixels.  // Schriftgröße von 18 Pixeln.
                      fontFamily: 'San Francisco',  // San Francisco font family.  // San Francisco Schriftfamilie.
                    ),
                    textAlign: TextAlign.center,  // Centers the text.  // Zentriert den Text.
                  ),
                  SizedBox(height: 5),  // Adds 5 pixels of vertical spacing.  // Fügt 5 Pixel vertikalen Abstand hinzu.
                  Divider(  // Another divider line.  // Eine weitere Trennlinie.
                    color: Colors.grey,  // Grey color.  // Graue Farbe.
                    thickness: 0.5,  // Thickness of 0.5 pixels.  // Dicke von 0,5 Pixeln.
                  ),
                ],
              ),
            ),
          ),
          Row(  // Creates a horizontal row of widgets.  // Erstellt eine horizontale Reihe von Widgets.
            children: [  // List of child widgets.  // Liste der Kind-Widgets.
              Expanded(  // Expands to fill available horizontal space.  // Dehnt sich aus, um den verfügbaren horizontalen Raum zu füllen.
                flex: 1,  // Flex factor of 1.  // Flex-Faktor von 1.
                child: Padding(  // Adds padding around its child.  // Fügt Abstand um sein Kind hinzu.
                  padding: const EdgeInsets.fromLTRB(16, 0, 22, 0),  // Left: 16, Top: 0, Right: 22, Bottom: 0 padding.  // Links: 16, Oben: 0, Rechts: 22, Unten: 0 Abstand.
                  child: FloatingActionButton.extended(  // Creates an extended floating action button.  // Erstellt einen erweiterten schwebenden Aktionsbutton.
                      backgroundColor: const Color(0xFFFF4433),  // Red background color.  // Rote Hintergrundfarbe.
                      onPressed: () {  // Function to call when button is pressed.  // Funktion, die beim Drücken des Buttons aufgerufen wird.
                        Navigator.of(context).pop();  // Closes the current screen.  // Schließt den aktuellen Bildschirm.
                      },
                      label: const SizedBox(  // SizedBox as label.  // SizedBox als Beschriftung.
                      child: Text(  // Text widget.  // Text-Widget.
                          'Cancel',  // The button text.  // Der Button-Text.
                          textAlign: TextAlign.center,  // Centers the text.  // Zentriert den Text.
                          style: TextStyle(  // Style for the text.  // Stil für den Text.
                              fontFamily: 'San Francisco',  // San Francisco font family.  // San Francisco Schriftfamilie.
                              fontSize: 18,  // Font size of 18 pixels.  // Schriftgröße von 18 Pixeln.
                              fontWeight: FontWeight.w700,  // Bold font weight.  // Fette Schriftstärke.
                              color: Colors.black),  // Black text color.  // Schwarze Textfarbe.
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
