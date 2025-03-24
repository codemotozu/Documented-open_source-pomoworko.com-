/// NotLoginCartesianChart
/// 
/// A placeholder analytics chart widget shown to users who are not logged in. // Ein Platzhalter-Analysegrafikwidget, das Benutzern angezeigt wird, die nicht angemeldet sind.
/// Displays a sample image of the full analytics view and encourages users to log in. // Zeigt ein Beispielbild der vollständigen Analyseansicht und ermutigt Benutzer, sich anzumelden.
/// 
/// Usage:
/// ```dart
/// NotLoginCartesianChart(
///   title: 'Analytics',
/// )
/// ```
/// 
/// EN: Provides a preview of analytics features available after login.
/// DE: Bietet eine Vorschau der Analysefunktionen, die nach der Anmeldung verfügbar sind.

import 'package:flutter/material.dart'; // Imports Material Design widgets. // Importiert Material Design Widgets.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.
import 'package:intl/intl.dart'; // Imports internationalization support for date formatting. // Importiert Internationalisierungsunterstützung für Datumsformatierung.
import 'package:syncfusion_flutter_charts/charts.dart'; // Imports Syncfusion charts package. // Importiert das Syncfusion-Diagrammpaket.
import '../../../../common/utils/responsive_web.dart'; // Imports utility for responsive web design. // Importiert Hilfsprogramm für responsives Webdesign.
import '../../../../infrastructure/data_sources/hive_services.dart'; // Imports Hive local storage services. // Importiert Hive-Lokalspeicherdienste.
import 'time_frame_pop_up_menu_button.dart'; // Imports custom popup menu for time frame selection. // Importiert benutzerdefiniertes Popup-Menü für Zeitrahmenauswahl.

class NotLoginCartesianChart extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod integration. // Definiert ein zustandsbehaftetes Widget mit Riverpod-Integration.
  final String title; // Title property for the chart. // Titeleigenschaft für das Diagramm.
  const NotLoginCartesianChart({super.key, required this.title}); // Constructor requiring a title parameter. // Konstruktor, der einen Titelparameter erfordert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartesianChartState(); // Creates the mutable state for this widget. // Erstellt den veränderbaren Zustand für dieses Widget.
}

class _CartesianChartState extends ConsumerState<NotLoginCartesianChart> { // State class for the NotLoginCartesianChart. // Zustandsklasse für das NotLoginCartesianChart.
  late TooltipBehavior _tooltipBehavior; // Will hold tooltip configuration (unused in this implementation). // Enthält Tooltip-Konfiguration (in dieser Implementierung ungenutzt).
  String selectedTimeFrame = 'Weekly'; // Default selected time frame. // Standardmäßig ausgewählter Zeitrahmen.
  List<String> timeFrames = ['Weekly', 'Monthly', 'Yearly']; // Available time frame options. // Verfügbare Zeitrahmenoptionen.
  @override
  void initState() { // Initializes widget state. // Initialisiert den Widget-Zustand.
    super.initState(); // Calls parent class initializer. // Ruft den Initialisierer der Elternklasse auf.
  }

  String formatDuration(Duration duration) { // Formats duration into hours:minutes:seconds. // Formatiert Dauer in Stunden:Minuten:Sekunden.
    String twoDigits(int n) => n.toString().padLeft(2, "0"); // Helper function to ensure two digits with leading zero. // Hilfsfunktion zur Sicherstellung von zwei Stellen mit führender Null.
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60)); // Gets minutes part with two digits. // Holt Minutenteil mit zwei Stellen.
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60)); // Gets seconds part with two digits. // Holt Sekundenteil mit zwei Stellen.
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"; // Returns formatted duration string. // Gibt formatierte Dauerzeichenfolge zurück.
  }

  List<String> generateWeekDays() { // Generates a list of dates for the week. // Generiert eine Liste von Daten für die Woche.
    List<String> weekDays = []; // Empty list for week days. // Leere Liste für Wochentage.
    DateTime now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
    for (int i = -1; i <= 7; i++) { // Loop to generate 9 days (-1 to 7). // Schleife zur Generierung von 9 Tagen (-1 bis 7).
      String day = DateFormat('dd/MM/yyyy').format( // Formats each date as day/month/year. // Formatiert jedes Datum als Tag/Monat/Jahr.
        now.subtract(
          Duration(days: i), // Subtracts i days from now. // Subtrahiert i Tage von jetzt.
        ),
      );
      weekDays.add(day); // Adds formatted date to the list. // Fügt formatiertes Datum zur Liste hinzu.
    }
    return weekDays; // Returns the list of week days. // Gibt die Liste der Wochentage zurück.
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    final textTheme = Theme.of(context).textTheme; // Gets current text theme. // Holt aktuelles Textthema.

    List<String> weekDays = generateWeekDays().reversed.toList(); // Gets reversed list of week days. // Holt umgekehrte Liste der Wochentage.
    Future<Map<String, Duration>> futureData; // Future for loading time tracking data. // Future zum Laden von Zeiterfassungsdaten.

    if (selectedTimeFrame == 'Weekly') { // For weekly view. // Für wöchentliche Ansicht.
      futureData = HiveServices.retrievePomodoroDurationsForWeek(); // Loads weekly data. // Lädt wöchentliche Daten.
    } else if (selectedTimeFrame == 'Monthly') { // For monthly view. // Für monatliche Ansicht.
      futureData = HiveServices.retrievePomodoroDurationsForMonth(); // Loads monthly data. // Lädt monatliche Daten.
    } else { // For yearly view. // Für jährliche Ansicht.
      futureData = HiveServices.retrievePomodoroDurationsForYear(); // Loads yearly data. // Lädt jährliche Daten.
    }
    return ResponsiveWeb( // Responsive wrapper for web layout. // Responsiver Wrapper für Web-Layout.
      child: Scaffold( // Material Design layout scaffold. // Material Design Layoutgerüst.
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Black background. // Schwarzer Hintergrund.
        appBar: AppBar( // App bar for navigation and title. // App-Bar für Navigation und Titel.
          backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Black app bar background. // Schwarzer App-Bar-Hintergrund.
          iconTheme: const IconThemeData( // Icon theme configuration. // Symbol-Thema-Konfiguration.
            color:  Color(0xffF2F2F2), // Light gray icon color. // Hellgraue Symbolfarbe.
          ),
          title: Text( // App bar title. // App-Bar-Titel.
            'Analytics', // Title text. // Titeltext.
            style: textTheme.titleLarge?.copyWith( // Style based on theme's large title. // Stil basierend auf großem Titel des Themas.
              fontFamily: GoogleFonts.nunito( // Nunito font. // Nunito-Schriftart.
                color:  const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
              ).fontFamily, // Gets just the font family name. // Holt nur den Schriftfamiliennamen.
              color:  const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
            ),
          ),
          centerTitle: true, // Centers the title in the app bar. // Zentriert den Titel in der App-Bar.
        ),
        body: FutureBuilder<Map<String, Duration>>( // Builds UI based on async data loading. // Erstellt UI basierend auf asynchronem Datenladen.
          future: futureData, // Future to wait for. // Future, auf das gewartet wird.
          builder: (context, snapshot) { // Builder function for async UI. // Builder-Funktion für asynchrone UI.
            if (snapshot.connectionState == ConnectionState.done) { // If data loading is complete. // Wenn Datenladen abgeschlossen ist.
              if (snapshot.hasData) { // If data was successfully loaded. // Wenn Daten erfolgreich geladen wurden.
                final data = snapshot.data!; // Gets the loaded data. // Holt die geladenen Daten.
                List<Duration> durationsData = []; // List to store duration data. // Liste zum Speichern von Dauerdaten.
                if (selectedTimeFrame == 'Weekly') { // For weekly view. // Für wöchentliche Ansicht.
                  durationsData = weekDays
                      .skip(1)
                      .take(7)
                      .map((day) => data[day] ?? Duration.zero)
                      .toList(); // Gets durations for 7 days, defaulting to zero if missing. // Holt Dauern für 7 Tage, Standardwert Null wenn fehlend.
                } else if (selectedTimeFrame == 'Monthly') { // For monthly view. // Für monatliche Ansicht.
                  durationsData = data.values.toList().reversed.toList(); // Reverses the monthly data. // Kehrt die monatlichen Daten um.
                } else if (selectedTimeFrame == 'Yearly') { // For yearly view. // Für jährliche Ansicht.
                  durationsData = data.values.toList(); // Uses yearly data. // Verwendet jährliche Daten.
                }
                return Column(children: [ // Vertical layout for content. // Vertikales Layout für Inhalt.
                  const Padding( // Adds padding around login message. // Fügt Abstand um Anmeldenachricht hinzu.
                    padding: EdgeInsets.all(8.0), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                    child: Text( // Login message text. // Anmeldenachrichtentext.
                      """The weekly data will be available if you log in with Google.
                      Example chart when logged in:""", // Message encouraging login. // Nachricht zur Ermutigung zur Anmeldung.
                      style: TextStyle( // Text style. // Textstil.
                        fontSize: 16.0, // Font size. // Schriftgröße.
                        fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                        color: Colors.grey, // Gray text color. // Graue Textfarbe.
                      ),
                    ),
                  ),
                   const Divider( // Horizontal dividing line. // Horizontale Trennlinie.
                        thickness: 2, // Divider thickness in pixels. // Dicke der Trennlinie in Pixeln.
                      ),
                   Flexible( // Flexible container for sample image. // Flexibler Container für Beispielbild.
                    child: Padding( // Adds padding around sample image. // Fügt Abstand um Beispielbild hinzu.
                      padding: EdgeInsets.all(16.0), // 16 pixel padding all around. // 16 Pixel Abstand rundum.
                      child: 
                      Center(child: Image.asset('assets/images/sample.png')), // Centered sample image. // Zentriertes Beispielbild.
                    ),
                  ),
                ]);
              } else { // If data loading failed. // Wenn Datenladen fehlgeschlagen ist.
                return Text( // Error message. // Fehlermeldung.
                  "Error loading data", // Error text. // Fehlertext.
                  style: TextStyle( // Text style. // Textstil.
                    color: Colors.grey[700], // Dark gray text color. // Dunkelgraue Textfarbe.
                  ),
                );
              }
            } else { // If still loading data. // Wenn noch Daten geladen werden.
              return const Center(child: CircularProgressIndicator()); // Centered loading spinner. // Zentrierter Ladeindikator.
            }
          },
        ),
      ),
    );
  }
}
