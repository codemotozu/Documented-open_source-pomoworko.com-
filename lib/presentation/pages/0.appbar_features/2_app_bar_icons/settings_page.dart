/// SettingsPage
/// 
/// A settings configuration screen for a Pomodoro timer application. // Ein Konfigurationsbildschirm für eine Pomodoro-Timer-Anwendung.
/// Allows users to customize timer durations, sounds, colors, and notification preferences. // Ermöglicht Benutzern die Anpassung von Timer-Dauern, Klängen, Farben und Benachrichtigungseinstellungen.
/// 
/// Usage:
/// ```dart
/// Navigator.of(context).push( 
///   MaterialPageRoute(builder: (context) => const SettingsPage()),
/// );
/// ```
/// 
/// EN: Displays a settings page with multiple customization options organized into cards.
/// DE: Zeigt eine Einstellungsseite mit mehreren Anpassungsoptionen, die in Karten organisiert sind.

import 'dart:html' as html; // Imports HTML library for browser interactions. // Importiert die HTML-Bibliothek für Browser-Interaktionen.

import 'package:flutter/cupertino.dart'; // Imports iOS-style (Cupertino) widgets. // Importiert iOS-Stil (Cupertino) Widgets.
import 'package:flutter/material.dart'; // Imports Material Design widgets. // Importiert Material Design Widgets.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.

import '../../../../common/utils/responsive_web.dart'; // Imports utility for responsive web design. // Importiert Hilfsprogramm für responsives Webdesign.
import '../../../../infrastructure/data_sources/hive_services.dart'; // Imports local storage services. // Importiert lokale Speicherdienste.
import '../../../notifiers/providers.dart'; // Imports Riverpod providers. // Importiert Riverpod-Provider.
import '../../../notifiers/timer_notifier_provider.dart'; // Imports timer state management provider. // Importiert Timer-Zustandsverwaltungsprovider.
import '../../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.
import '../../../widgets/alarm_sound_popup_menu_button.dart'; // Imports widget for selecting alarm sounds. // Importiert Widget zur Auswahl von Alarmtönen.
import '../../../widgets/color_choice.dart'; // Imports widget for color selection. // Importiert Widget für die Farbauswahl.
import '../../../widgets/timer_setting_state.dart'; // Imports widget for timer duration settings. // Importiert Widget für Timer-Dauereinstellungen.


final List<Color> darkModeColorOptions = [ // Defines color options for dark mode. // Definiert Farboptionen für den dunklen Modus.
  const Color(0xFF74F143), // Green color option. // Grüne Farboption.
  const Color(0xffff9933), // Orange color option. // Orange Farboption.
  const Color(0xFF0891FF), // Blue color option. // Blaue Farboption.
  const Color(0xFFAB67FF), // Purple color option. // Lila Farboption.
  const Color(0xFFEF4444), // Red color option. // Rote Farboption.
  const Color(0xFFFFDE00), // Yellow color option. // Gelbe Farboption.
  const Color.fromARGB(255, 30, 30, 30), // Dark gray/black color option. // Dunkelgrau/Schwarze Farboption.
  const Color(0xff6E7681), // Gray color option. // Graue Farboption.
];

class SettingsPage extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein zustandsbehaftetes Widget, das auf Riverpod-Provider zugreifen kann.
  const SettingsPage({super.key}); // Constructor that accepts an optional key parameter. // Konstruktor, der einen optionalen Schlüsselparameter akzeptiert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState(); // Creates the mutable state for this widget. // Erstellt den veränderbaren Zustand für dieses Widget.
}

class _SettingsPageState extends ConsumerState<SettingsPage> { // Defines the state class for the SettingsPage widget. // Definiert die Zustandsklasse für das SettingsPage-Widget.
  @override
  Widget build(BuildContext context) { // Describes the part of the user interface represented by this widget. // Beschreibt den Teil der Benutzeroberfläche, der durch dieses Widget dargestellt wird.
    ref.watch(timerInitProvider); // Watches timer initialization provider to rebuild when it changes. // Beobachtet Timer-Initialisierungs-Provider, um bei Änderungen neu zu bauen.
    ref.watch(soundInitProvider); // Watches sound initialization provider to rebuild when it changes. // Beobachtet Sound-Initialisierungs-Provider, um bei Änderungen neu zu bauen.

    return SafeArea( // Ensures content is visible and not obscured by system UI. // Stellt sicher, dass der Inhalt sichtbar und nicht durch die System-UI verdeckt ist.
      child: ResponsiveWeb( // Wraps content in responsive layout for web. // Umhüllt den Inhalt in einem responsiven Layout für das Web.
        child: Scaffold( // Creates a basic Material Design layout structure. // Erstellt eine grundlegende Material Design-Layoutstruktur.
          backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Sets background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
          resizeToAvoidBottomInset: false, // Prevents resizing when keyboard appears. // Verhindert die Größenänderung, wenn die Tastatur erscheint.
          appBar: AppBar( // Creates an app bar for the scaffold. // Erstellt eine App-Bar für das Gerüst.
            backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Sets app bar background color to black. // Setzt die Hintergrundfarbe der App-Bar auf Schwarz.
            iconTheme: const IconThemeData( // Sets the theme for icons in the app bar. // Legt das Thema für Symbole in der App-Bar fest.
              color: Color(0xffF2F2F2), // Sets icon color to off-white. // Setzt die Symbolfarbe auf Gebrochen-Weiß.
            ),
            title: Text( // Sets the app bar title. // Setzt den App-Bar-Titel.
              'Settings', // The text to display in the app bar. // Der in der App-Bar anzuzeigende Text.
              style: TextStyle( // Style for the title text. // Stil für den Titeltext.
                fontFamily: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                  color: const Color(0xffF2F2F2), // Sets font color to off-white. // Setzt die Schriftfarbe auf Gebrochen-Weiß.
                ).fontFamily, // Extracts just the font family name. // Extrahiert nur den Namen der Schriftfamilie.
                color: const Color(0xffF2F2F2), // Sets the text color to off-white. // Setzt die Textfarbe auf Gebrochen-Weiß.
              ),
            ),
            centerTitle: true, // Centers the title in the app bar. // Zentriert den Titel in der App-Bar.
          ),
          body: Padding( // Adds padding around the body content. // Fügt Polsterung um den Hauptinhalt hinzu.
            padding: const EdgeInsets.all(16.0), // 16 logical pixels padding on all sides. // 16 logische Pixel Polsterung auf allen Seiten.
            child: ListView( // Creates a scrollable list of widgets. // Erstellt eine scrollbare Liste von Widgets.
              children: <Widget>[ // The list of widgets in the ListView. // Die Liste der Widgets im ListView.
                _buildCard( // Creates a card for timer settings. // Erstellt eine Karte für Timer-Einstellungen.
                  'Adjust Timer Minutes', // Card title. // Kartentitel.
                  Column( // Vertical arrangement of timer settings. // Vertikale Anordnung der Timer-Einstellungen.
                    children: <Widget>[ // List of timer setting widgets. // Liste der Timer-Einstellungs-Widgets.
                      TimerSettingState( // Widget for Pomodoro duration setting. // Widget für die Pomodoro-Dauereinstellung.
                        title: 'Pomodoro', // Setting label. // Einstellungsbezeichnung.
                        stateProvider: pomodoroTimerProvider, // Provider for Pomodoro timer duration. // Provider für die Pomodoro-Timer-Dauer.
                      ),
                      TimerSettingState( // Widget for short break duration setting. // Widget für die Kurzpausen-Dauereinstellung.
                        title: 'Short Break', // Setting label. // Einstellungsbezeichnung.
                        stateProvider: shortBreakProvider, // Provider for short break duration. // Provider für die Kurzpausendauer.
                      ),
                      TimerSettingState( // Widget for long break duration setting. // Widget für die Langpausen-Dauereinstellung.
                        title: 'Long Break', // Setting label. // Einstellungsbezeichnung.
                        stateProvider: longBreakProvider, // Provider for long break duration. // Provider für die Langpausendauer.
                      ),
                      TimerSettingState( // Widget for long break interval setting. // Widget für die Langpausen-Intervalleinstellung.
                        title: 'Long Break Interval', // Setting label. // Einstellungsbezeichnung.
                        stateProvider: longBreakIntervalProvider, // Provider for number of pomodoros before long break. // Provider für die Anzahl der Pomodoros vor einer langen Pause.
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16), // Adds 16 logical pixels of vertical space. // Fügt 16 logische Pixel vertikalen Raum hinzu.
                _buildCard( // Creates a card for sound settings. // Erstellt eine Karte für Klangeinstellungen.
                  'Sound Settings', // Card title. // Kartentitel.
                  ListTile( // Creates a list tile for alarm sound setting. // Erstellt ein Listenelement für die Alarmtoneinstellung.
                    title: Text('Alarm Sound', // List tile title. // Listenelement-Titel.
                        style: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                          color: const Color(0xffF2F2F2), // Sets font color to off-white. // Setzt die Schriftfarbe auf Gebrochen-Weiß.
                        )),
                    trailing: AlarmSoundPopupMenuButton( // Dropdown button for selecting alarm sounds. // Dropdown-Schaltfläche zur Auswahl von Alarmtönen.
                      sounds: ref.watch(soundListProvider), // List of available alarm sounds. // Liste der verfügbaren Alarmtöne.
                      currentSound:
                          ref.watch(selectedSoundProvider).friendlyName, // Currently selected alarm sound display name. // Anzeigename des aktuell ausgewählten Alarmtons.
                     
                      onSoundSelected: (sound) async { // Function called when a new sound is selected. // Funktion, die aufgerufen wird, wenn ein neuer Klang ausgewählt wird.
                        print("New sound selected: ${sound.path}"); // Logs the selected sound path. // Protokolliert den Pfad des ausgewählten Klangs.
                        
                        // Save new sound and update
                        ref.read(selectedSoundProvider.notifier).updateSound(sound); // Updates the selected sound in state. // Aktualisiert den ausgewählten Klang im Zustand.
                        await HiveServices.saveAlarmSoundValue(sound.path); // Persists the sound selection locally. // Speichert die Klangauswahl lokal.

                        // Ensure the new sound is loaded and ready for playback
                        await ref.read(timerNotifierProvider.notifier).loadSounds(); // Loads the sound files. // Lädt die Klangdateien.

                        // Add a small delay to ensure player readiness
                        await Future.delayed(Duration(milliseconds: 200)); // Waits 200ms to ensure player is ready. // Wartet 200ms, um sicherzustellen, dass der Player bereit ist.

                        // Play the selected sound for immediate feedback
                        await ref.read(timerNotifierProvider.notifier).playSound(userTriggered: true); // Plays the sound for user feedback. // Spielt den Klang zur Benutzerrückmeldung ab.
                      },

                    ),
                  ),
                ),
                const SizedBox(height: 16), // Adds 16 logical pixels of vertical space. // Fügt 16 logische Pixel vertikalen Raum hinzu.
                _buildCard( // Creates a card for browser notification settings. // Erstellt eine Karte für Browser-Benachrichtigungseinstellungen.
                  'Browser Alerts', // Card title. // Kartentitel.
                  ListTile( // Creates a list tile for notification settings. // Erstellt ein Listenelement für Benachrichtigungseinstellungen.
                    title: Text( // List tile title. // Listenelement-Titel.
                      'Notify on timer end', // Title text. // Titeltext.
                      style: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                        color: const Color(0xffF2F2F2), // Sets font color to off-white. // Setzt die Schriftfarbe auf Gebrochen-Weiß.
                      ),
                    ),
                    subtitle: Text( // Subtitle text for the list tile. // Untertiteltext für das Listenelement.
                      'Please, save to commit changes', // Instruction to save changes. // Anweisung zum Speichern von Änderungen.
                      style: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                        color: const Color(0xffF2F2F2), // Sets font color to off-white. // Setzt die Schriftfarbe auf Gebrochen-Weiß.
                        fontSize: 12, // Sets text size to 12 logical pixels. // Setzt die Textgröße auf 12 logische Pixel.
                      ),
                    ),
                    trailing: Consumer(builder: (context, watch, child) { // Consumer widget to rebuild when providers change. // Consumer-Widget, um bei Änderungen der Provider neu zu bauen.
                      final toggleState =
                          ref.watch(browserNotificationsProvider); // Current state of browser notifications toggle. // Aktueller Zustand des Browser-Benachrichtigungsschalters.

                      return CupertinoSwitch( // iOS-style toggle switch. // Umschalter im iOS-Stil.
                        value: toggleState, // Current toggle state. // Aktueller Umschaltzustand.
                        onChanged: (value) async { // Function called when the switch is toggled. // Funktion, die aufgerufen wird, wenn der Schalter umgelegt wird.
                       
                          ref
                              .read(browserNotificationsProvider.notifier)
                              .toggle(); // Toggles the notification state. // Schaltet den Benachrichtigungszustand um.

                          if (value) { // If user is enabling notifications. // Wenn der Benutzer Benachrichtigungen aktiviert.
                            if (html.Notification.supported) { // Checks if browser supports notifications. // Prüft, ob der Browser Benachrichtigungen unterstützt.
                              html.Notification.requestPermission()
                                  .then((permission) { // Requests permission for browser notifications. // Fordert Erlaubnis für Browser-Benachrichtigungen an.
                                if (permission == "granted") { // If permission is granted. // Wenn die Erlaubnis erteilt wird.
                                  
                                } else { // If permission is denied. // Wenn die Erlaubnis verweigert wird.
                         
                                }
                              });
                            }
                          }
                          if (!toggleState) { // If notifications were disabled before this change. // Wenn Benachrichtigungen vor dieser Änderung deaktiviert waren.
                            showCupertinoModalPopup( // Shows a popup with notification instructions. // Zeigt ein Popup mit Benachrichtigungsanweisungen.
                              context: context, // Current build context. // Aktueller Build-Kontext.
                              builder: (context) { // Builder for the popup content. // Builder für den Popup-Inhalt.
                                return SimpleDialog( // Creates a simple dialog widget. // Erstellt ein einfaches Dialog-Widget.
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 0, 0), // Sets dialog background color to black. // Setzt die Hintergrundfarbe des Dialogs auf Schwarz.
                                    children: [ // List of widgets in the dialog. // Liste der Widgets im Dialog.
                                      SizedBox( // Fixed size box for the dialog content. // Feld mit fester Größe für den Dialoginhalt.
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4, // Sets width to 40% of screen width. // Setzt die Breite auf 40% der Bildschirmbreite.
                                        child: Column( // Vertical arrangement of dialog content. // Vertikale Anordnung des Dialoginhalts.
                                          children: [ // List of widgets in the column. // Liste der Widgets in der Spalte.
                                            Padding( // Adds padding around its child. // Fügt Polsterung um sein Kind hinzu.
                                              padding: const EdgeInsets.only(
                                                left: 7.5,
                                                right: 7.5,
                                              ), // Horizontal padding of 7.5 logical pixels. // Horizontale Polsterung von 7,5 logischen Pixeln.
                                              child: Row( // Horizontal arrangement of header widgets. // Horizontale Anordnung der Kopfzeilen-Widgets.
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end, // Aligns children to the end (right) of the row. // Richtet Kinder am Ende (rechts) der Zeile aus.
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center, // Centers children vertically. // Zentriert Kinder vertikal.
                                                children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
                                                  Flexible( // Makes its child flexible to fit in available space. // Macht sein Kind flexibel, um in den verfügbaren Platz zu passen.
                                                    flex: 1, // Proportion of space this widget should occupy. // Anteil des Platzes, den dieses Widget belegen soll.
                                                    child: IconButton( // Creates a button with an icon. // Erstellt eine Schaltfläche mit einem Symbol.
                                                      icon: const Icon(
                                                          Icons.close), // Close (X) icon. // Schließen (X) Symbol.
                                                      onPressed: () { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
                                                        Navigator.of(context)
                                                            .pop(); // Closes the dialog. // Schließt den Dialog.
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Padding( // Adds padding around the divider. // Fügt Polsterung um den Teiler hinzu.
                                              padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                              ), // Horizontal padding of 15 logical pixels. // Horizontale Polsterung von 15 logischen Pixeln.
                                              child: Divider( // Horizontal line for visual separation. // Horizontale Linie zur visuellen Trennung.
                                                color: Color.fromARGB(
                                                    255, 180, 180, 180), // Light gray divider color. // Hellgraue Teilerfarbe.
                                                thickness: 1.0, // Divider thickness in logical pixels. // Teilerdicke in logischen Pixeln.
                                              ),
                                            ),
                                            const SizedBox(height: 12), // Adds 12 logical pixels of vertical space. // Fügt 12 logische Pixel vertikalen Raum hinzu.
                                            Padding( // Adds padding around the instruction content. // Fügt Polsterung um den Anweisungsinhalt hinzu.
                                              padding: const EdgeInsets.only(
                                                left: 17.5,
                                                right: 17.5,
                                              ), // Horizontal padding of 17.5 logical pixels. // Horizontale Polsterung von 17,5 logischen Pixeln.
                                              child: Column( // Vertical arrangement of instruction content. // Vertikale Anordnung des Anweisungsinhalts.
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center, // Centers children horizontally. // Zentriert Kinder horizontal.
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center, // Centers children vertically. // Zentriert Kinder vertikal.
                                                children: [ // List of widgets in the column. // Liste der Widgets in der Spalte.
                                                  Center( // Centers its child. // Zentriert sein Kind.
                                                    child: Center( // Nested center widget. // Verschachteltes Zentrierungs-Widget.
                                                      child: Text( // Instruction text. // Anweisungstext.
                                                        'Turn on notifications in your browser and operating system', // Instruction to enable notifications. // Anweisung zum Aktivieren von Benachrichtigungen.
                                                        style:
                                                            GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                                                          fontWeight:
                                                              FontWeight.w600, // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                                                          fontSize: 18, // Sets font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
                                                          color: const Color(
                                                              0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochen-Weiß.
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12), // Adds 12 logical pixels of vertical space. // Fügt 12 logische Pixel vertikalen Raum hinzu.
                                                  Row( // Horizontal arrangement of instruction images. // Horizontale Anordnung von Anweisungsbildern.
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center, // Centers children vertically. // Zentriert Kinder vertikal.
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center, // Centers children horizontally. // Zentriert Kinder horizontal.
                                                    children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
                                                      Flexible( // Makes its child flexible to fit in available space. // Macht sein Kind flexibel, um in den verfügbaren Platz zu passen.
                                                        flex: 4, // Proportion of space this widget should occupy. // Anteil des Platzes, den dieses Widget belegen soll.
                                                        child: ClipRRect( // Clips its child to rounded rectangle. // Schneidet sein Kind zu einem abgerundeten Rechteck zu.
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0), // Rounds corners with 15 logical pixel radius. // Rundet Ecken mit 15 logischen Pixel Radius.
                                                          child: Image.asset( // Loads an image from asset bundle. // Lädt ein Bild aus dem Asset-Bundle.
                                                            'assets/images/pomodoro_timer_notification.jpg', // Path to image asset. // Pfad zum Bild-Asset.
                                                            fit: BoxFit.cover, // Scales image to cover its bounds. // Skaliert das Bild, um seinen Rahmen zu bedecken.
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12), // Adds 12 logical pixels of horizontal space. // Fügt 12 logische Pixel horizontalen Raum hinzu.
                                                      Flexible( // Makes its child flexible to fit in available space. // Macht sein Kind flexibel, um in den verfügbaren Platz zu passen.
                                                        flex: 4, // Proportion of space this widget should occupy. // Anteil des Platzes, den dieses Widget belegen soll.
                                                        child: ClipRRect( // Clips its child to rounded rectangle. // Schneidet sein Kind zu einem abgerundeten Rechteck zu.
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0), // Rounds corners with 15 logical pixel radius. // Rundet Ecken mit 15 logischen Pixel Radius.
                                                          child: Image.asset( // Loads an image from asset bundle. // Lädt ein Bild aus dem Asset-Bundle.
                                                            'assets/images/operating_system.jpg', // Path to image asset. // Pfad zum Bild-Asset.
                                                            fit: BoxFit.cover, // Scales image to cover its bounds. // Skaliert das Bild, um seinen Rahmen zu bedecken.
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12), // Adds 12 logical pixels of vertical space. // Fügt 12 logische Pixel vertikalen Raum hinzu.
                                                  Row( // Horizontal arrangement of additional instructions. // Horizontale Anordnung zusätzlicher Anweisungen.
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly, // Distributes space evenly between children. // Verteilt den Raum gleichmäßig zwischen den Kindern.
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center, // Centers children vertically. // Zentriert Kinder vertikal.
                                                    children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
                                                      Flexible( // Makes its child flexible to fit in available space. // Macht sein Kind flexibel, um in den verfügbaren Platz zu passen.
                                                        flex: 4, // Proportion of space this widget should occupy. // Anteil des Platzes, den dieses Widget belegen soll.
                                                        child: Center( // Centers its child. // Zentriert sein Kind.
                                                          child: Text( // Additional instruction text. // Zusätzlicher Anweisungstext.
                                                            'Be sure to untick the "Do Not Disturb" button or any similar option in your operating system.', // Warning about Do Not Disturb mode. // Warnung zum Nicht-Stören-Modus.
                                                            style: GoogleFonts
                                                                .nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600, // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                                                              fontSize: 18, // Sets font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
                                                              color: const Color(
                                                                  0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochen-Weiß.
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12), // Adds 12 logical pixels of vertical space. // Fügt 12 logische Pixel vertikalen Raum hinzu.
                                                  Row( // Horizontal arrangement of system notification warning image. // Horizontale Anordnung des Systembenachrichtigungswarnbildes.
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center, // Centers children vertically. // Zentriert Kinder vertikal.
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center, // Centers children horizontally. // Zentriert Kinder horizontal.
                                                    children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
                                                      Flexible( // Makes its child flexible to fit in available space. // Macht sein Kind flexibel, um in den verfügbaren Platz zu passen.
                                                        flex: 4, // Proportion of space this widget should occupy. // Anteil des Platzes, den dieses Widget belegen soll.
                                                        child: ClipRRect( // Clips its child to rounded rectangle. // Schneidet sein Kind zu einem abgerundeten Rechteck zu.
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0), // Rounds corners with 15 logical pixel radius. // Rundet Ecken mit 15 logischen Pixel Radius.
                                                          child: Image.asset( // Loads an image from asset bundle. // Lädt ein Bild aus dem Asset-Bundle.
                                                            'assets/images/system_notification_do_not_disturb_warning.png', // Path to image asset. // Pfad zum Bild-Asset.
                                                            fit: BoxFit.cover, // Scales image to cover its bounds. // Skaliert das Bild, um seinen Rahmen zu bedecken.
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]);
                              },
                            );
                          }
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16), // Adds 16 logical pixels of vertical space. // Fügt 16 logische Pixel vertikalen Raum hinzu.
                
                _buildCard( // Creates a card for color settings. // Erstellt eine Karte für Farbeinstellungen.
                  'Color Settings', // Card title. // Kartentitel.
                  Column( // Vertical arrangement of color settings. // Vertikale Anordnung der Farbeinstellungen.
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left) of the column. // Richtet Kinder am Anfang (links) der Spalte aus.
                    children: <Widget>[ // List of widgets in the column. // Liste der Widgets in der Spalte.
                      Text( // Instruction text for color selection. // Anweisungstext für die Farbauswahl.
                        'Please, click on the circle to select the color', // Instruction to click on color circles. // Anweisung, auf Farbkreise zu klicken.
                        style: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                          color: const Color(0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochen-Weiß.
                          fontSize: 12, // Sets font size to 12 logical pixels. // Setzt die Schriftgröße auf 12 logische Pixel.
                        ),
                      ),
                      const SizedBox(height: 16), // Adds 16 logical pixels of vertical space. // Fügt 16 logische Pixel vertikalen Raum hinzu.
                      ColorChoice( // Widget for Pomodoro color selection. // Widget für die Pomodoro-Farbauswahl.
                        title: 'Pomodoro Color', // Setting label. // Einstellungsbezeichnung.
                        darkColorProvider: darkPomodoroColorProvider, // Provider for Pomodoro color. // Provider für die Pomodoro-Farbe.
                        darkColorOptions: darkModeColorOptions, // Available color options. // Verfügbare Farboptionen.
                      ),
                      ColorChoice( // Widget for short break color selection. // Widget für die Kurzpausen-Farbauswahl.
                        title: 'Short Break Color', // Setting label. // Einstellungsbezeichnung.
                        darkColorProvider: darkShortBreakColorProvider, // Provider for short break color. // Provider für die Kurzpausenfarbe.
                        darkColorOptions: darkModeColorOptions, // Available color options. // Verfügbare Farboptionen.
                      ),
                      ColorChoice( // Widget for long break color selection. // Widget für die Langpausen-Farbauswahl.
                        title: 'Long Break Color', // Setting label. // Einstellungsbezeichnung.
                        darkColorProvider: darkLongBreakColorProvider, // Provider for long break color. // Provider für die Langpausenfarbe.
                        darkColorOptions: darkModeColorOptions, // Available color options. // Verfügbare Farboptionen.
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Adds 20 logical pixels of vertical space. // Fügt 20 logische Pixel vertikalen Raum hinzu.
                Center( // Centers the save button. // Zentriert die Speichern-Schaltfläche.
                  child: Column( // Vertical arrangement of save button. // Vertikale Anordnung der Speichern-Schaltfläche.
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally. // Dehnt Kinder horizontal.
                      mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically. // Zentriert Kinder vertikal.
                      children: [ // List of widgets in the column. // Liste der Widgets in der Spalte.
                        Padding( // Adds padding around the save button. // Fügt Polsterung um die Speichern-Schaltfläche hinzu.
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 4.0), // 4 logical pixels horizontal padding. // 4 logische Pixel horizontale Polsterung.
                          child: FloatingActionButton.extended( // Extended floating action button for save action. // Erweiterte schwebende Aktionsschaltfläche für Speicheraktion.
                            heroTag: 'btn8', // Unique tag for hero animations. // Eindeutiges Tag für Hero-Animationen.
                            elevation: 4, // Button elevation in logical pixels. // Schaltflächenerhebung in logischen Pixeln.
                            backgroundColor:
                                const Color.fromARGB(255, 0, 0, 0), // Sets button background to black. // Setzt den Schaltflächenhintergrund auf Schwarz.
                            shape: RoundedRectangleBorder( // Defines button shape. // Definiert die Schaltflächenform.
                              borderRadius: BorderRadius.circular(10), // Rounds corners with 10 logical pixel radius. // Rundet Ecken mit 10 logischen Pixel Radius.
                            ),
                            onPressed: () async { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
                              final providers = [ // List of timer-related providers to save. // Liste der zu speichernden Timer-bezogenen Provider.
                                pomodoroTimerProvider, // Provider for Pomodoro timer duration. // Provider für die Pomodoro-Timer-Dauer.
                                shortBreakProvider, // Provider for short break duration. // Provider für die Kurzpausendauer.
                                longBreakProvider, // Provider for long break duration. // Provider für die Langpausendauer.
                                longBreakIntervalProvider, // Provider for long break interval. // Provider für das Langpausenintervall.
                              ];
                              for (final provider in providers) { // Loop through each timer provider. // Schleife durch jeden Timer-Provider.
                                final enteredMinutes = int.tryParse(ref
                                    .read(provider.notifier)
                                    .state
                                    .toString()); // Gets the current value from the provider. // Holt den aktuellen Wert vom Provider.
                                if (enteredMinutes != null) { // If a valid number was entered. // Wenn eine gültige Zahl eingegeben wurde.
                                  ref.read(provider.notifier).state =
                                      enteredMinutes; // Updates provider state with parsed value. // Aktualisiert den Provider-Zustand mit dem analysierten Wert.
                                }
                              }
                              ref
                                  .read(timerNotifierProvider.notifier)
                                  .updateDuration(0); // Updates the timer duration to reflect new settings. // Aktualisiert die Timer-Dauer, um neue Einstellungen widerzuspiegeln.
                              ref
                                  .read(timerNotifierProvider.notifier)
                                  .updateColor(); // Updates the timer color to reflect new settings. // Aktualisiert die Timer-Farbe, um neue Einstellungen widerzuspiegeln.
                              ref
                                  .read(eventNotifierProvider.notifier)
                                  .notify("updateAnimationDuration"); // Notifies listeners to update animation duration. // Benachrichtigt Zuhörer, um die Animationsdauer zu aktualisieren.

                              HiveServices.saveAllTimerValues( // Persists all timer values to local storage. // Speichert alle Timer-Werte im lokalen Speicher.
                                ref.read(pomodoroTimerProvider.notifier).state, // Pomodoro timer duration. // Pomodoro-Timer-Dauer.
                                ref.read(shortBreakProvider.notifier).state, // Short break duration. // Kurzpausendauer.
                                ref.read(longBreakProvider.notifier).state, // Long break duration. // Langpausendauer.
                                ref
                                    .read(longBreakIntervalProvider.notifier)
                                    .state, // Long break interval. // Langpausenintervall.
                              );
                              HiveServices.saveAllColorValues( // Persists all color values to local storage. // Speichert alle Farbwerte im lokalen Speicher.
                                  ref
                                      .read(darkPomodoroColorProvider.notifier)
                                      .state, // Pomodoro color. // Pomodoro-Farbe.
                                  ref
                                      .read(
                                          darkShortBreakColorProvider.notifier)
                                      .state, // Short break color. // Kurzpausenfarbe.
                                  ref
                                      .read(darkLongBreakColorProvider.notifier)
                                      .state); // Long break color. // Langpausenfarbe.

                              final pomodoroTimer = ref
                                  .read(pomodoroTimerProvider.notifier)
                                  .state; // Gets current Pomodoro timer value. // Holt den aktuellen Pomodoro-Timer-Wert.
                              final shortBreakTimer =
                                  ref.read(shortBreakProvider.notifier).state; // Gets current short break value. // Holt den aktuellen Kurzpausenwert.

                              final longBreakTimer =
                                  ref.read(longBreakProvider.notifier).state; // Gets current long break value. // Holt den aktuellen Langpausenwert.

                              final longBreakInterval = ref
                                  .read(longBreakIntervalProvider.notifier)
                                  .state; // Gets current long break interval value. // Holt den aktuellen Langpausenintervallwert.

                              final selectedSound =
                                  ref.read(selectedSoundProvider); // Gets currently selected sound. // Holt den aktuell ausgewählten Klang.

                              final browserNotificationsEnabled =
                                  ref.read(browserNotificationsProvider); // Gets notification toggle state. // Holt den Benachrichtigungsschalter-Zustand.

                              final pomodoroColor =
                                  ref.read(darkPomodoroColorProvider); // Gets current Pomodoro color. // Holt die aktuelle Pomodoro-Farbe.
                              final shortBreakColor =
                                  ref.read(darkShortBreakColorProvider); // Gets current short break color. // Holt die aktuelle Kurzpausenfarbe.
                              final longBreakColor =
                                  ref.read(darkLongBreakColorProvider); // Gets current long break color. // Holt die aktuelle Langpausenfarbe.

                              final errorModel = await ref
                                  .read(authRepositoryProvider)
                                  .updateUserSettings( // Updates settings on server for logged-in user. // Aktualisiert Einstellungen auf dem Server für angemeldeten Benutzer.
                                      pomodoroTimer, // Pomodoro timer duration. // Pomodoro-Timer-Dauer.
                                      shortBreakTimer, // Short break duration. // Kurzpausendauer.
                                      longBreakTimer, // Long break duration. // Langpausendauer.
                                      longBreakInterval, // Long break interval. // Langpausenintervall.
                                      selectedSound, // Selected alarm sound. // Ausgewählter Alarmton.
                                      browserNotificationsEnabled, // Notification setting. // Benachrichtigungseinstellung.
                                      pomodoroColor, // Pomodoro color. // Pomodoro-Farbe.
                                      shortBreakColor, // Short break color. // Kurzpausenfarbe.
                                      longBreakColor); // Long break color. // Langpausenfarbe.

                              if (errorModel.error != null) { // If there was an error saving settings. // Wenn beim Speichern der Einstellungen ein Fehler aufgetreten ist.
                                ScaffoldMessenger.of(context).showSnackBar( // Shows an error notification. // Zeigt eine Fehlerbenachrichtigung.
                                  SnackBar(content: Text(errorModel.error!)), // Displays error message. // Zeigt die Fehlermeldung an.
                                );
                              }
                              Navigator.of(context).pop(); // Returns to previous screen after saving. // Kehrt nach dem Speichern zum vorherigen Bildschirm zurück.
                            },
                            label: Text( // Text label for the save button. // Textbezeichnung für die Speichern-Schaltfläche.
                              'Save', // Button text. // Schaltflächentext.
                              style: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                                color: const Color(0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochen-Weiß.
                                fontSize: 18, // Sets font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
                                fontWeight: FontWeight.w600, // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 20), // Adds 20 logical pixels of vertical space. // Fügt 20 logische Pixel vertikalen Raum hinzu.
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimerRow(String label, int value) { // Helper method to build a timer row (unused in current implementation). // Hilfsmethode zum Erstellen einer Timer-Zeile (in der aktuellen Implementierung nicht verwendet).
    return Row( // Returns a horizontal arrangement of children. // Gibt eine horizontale Anordnung von untergeordneten Elementen zurück.
      mainAxisAlignment: MainAxisAlignment.center, // Centers children horizontally. // Zentriert Kinder horizontal.
      children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
        Text( // Label text. // Bezeichnungstext.
          label, // The label to display. // Die anzuzeigende Bezeichnung.
          style: const TextStyle( // Style for the label text. // Stil für den Bezeichnungstext.
            fontSize: 16, // Sets font size to 16 logical pixels. // Setzt die Schriftgröße auf 16 logische Pixel.
          ),
        ),
        const SizedBox(width: 20), // Adds 20 logical pixels of horizontal space. // Fügt 20 logische Pixel horizontalen Raum hinzu.
        Expanded( // Makes the grid view expand to fill available space. // Lässt die Rasteransicht erweitern, um den verfügbaren Platz zu füllen.
          child: GridView.count( // Creates a grid of items. // Erstellt ein Raster von Elementen.
            shrinkWrap: true, // Sizes the grid to fit its children. // Passt das Raster an die Größe seiner Kinder an.
            crossAxisCount: 5, // Display 5 items per row. // Zeigt 5 Elemente pro Zeile an.
            childAspectRatio: 2.0, // Width to height ratio of grid items. // Breiten-zu-Höhen-Verhältnis der Rasterelemente.
            children: List.generate( // Generates a list of widgets. // Generiert eine Liste von Widgets.
              5, // Number of items to generate. // Anzahl der zu generierenden Elemente.
              (index) => Container( // Container for each grid item. // Container für jedes Rasterelement.
                margin: const EdgeInsets.all(5), // 5 logical pixels margin on all sides. // 5 logische Pixel Rand auf allen Seiten.
                decoration: BoxDecoration( // Visual styling for the container. // Visuelle Gestaltung für den Container.
                  borderRadius: BorderRadius.circular(10), // Rounds corners with 10 logical pixel radius. // Rundet Ecken mit 10 logischen Pixel Radius.
                  color: Colors.grey[800], // Dark gray background color. // Dunkelgraue Hintergrundfarbe.
                ),
                padding: const EdgeInsets.all(10), // 10 logical pixels padding on all sides. // 10 logische Pixel Polsterung auf allen Seiten.
                child: Center( // Centers the value text. // Zentriert den Werttext.
                  child: Text( // Value text. // Werttext.
                    '$value', // Displays the value passed to the method. // Zeigt den an die Methode übergebenen Wert an.
                    style: const TextStyle( // Style for the value text. // Stil für den Werttext.
                      fontSize: 18, // Sets font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
                      fontWeight: FontWeight.bold, // Sets font weight to bold. // Setzt die Schriftstärke auf fett.
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, Widget child) { // Helper method to build a settings card. // Hilfsmethode zum Erstellen einer Einstellungskarte.
    return Card( // Returns a Material Design card. // Gibt eine Material Design-Karte zurück.
      color: const Color.fromARGB(255, 0, 0, 0), // Sets card background to black. // Setzt den Kartenhintergrund auf Schwarz.
      elevation: 0.0, // Sets card elevation (shadow) to 0. // Setzt die Kartenerhebung (Schatten) auf 0.
      shape: RoundedRectangleBorder( // Defines card shape. // Definiert die Kartenform.
        borderRadius: BorderRadius.circular(10.0), // Rounds corners with 10 logical pixel radius. // Rundet Ecken mit 10 logischen Pixel Radius.
      ),
      child: Padding( // Adds padding around card content. // Fügt Polsterung um den Karteninhalt hinzu.
        padding: const EdgeInsets.all(16.0), // 16 logical pixels padding on all sides. // 16 logische Pixel Polsterung auf allen Seiten.
        child: Column( // Vertical arrangement of card content. // Vertikale Anordnung des Karteninhalts.
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left) of the column. // Richtet Kinder am Anfang (links) der Spalte aus.
          children: <Widget>[ // List of widgets in the column. // Liste der Widgets in der Spalte.
            Text( // Card title text. // Kartentiteltext.
              title, // The title to display. // Der anzuzeigende Titel.
              style: GoogleFonts.nunito( // Uses Nunito font from Google Fonts. // Verwendet Nunito-Schriftart von Google Fonts.
                fontSize: 18, // Sets font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
                fontWeight: FontWeight.w600, // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
              ),
            ),
            const SizedBox(height: 10), // Adds 10 logical pixels of vertical space. // Fügt 10 logische Pixel vertikalen Raum hinzu.
            child, // The content widget to display in the card. // Das Inhalts-Widget, das in der Karte angezeigt werden soll.
          ],
        ),
      ),
    );
  }
}
