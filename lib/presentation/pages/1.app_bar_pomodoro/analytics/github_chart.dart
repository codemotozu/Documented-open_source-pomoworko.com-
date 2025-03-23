/// GitHubChart
/// 
/// A widget that displays a GitHub-style contribution heat map for Pomodoro tracking data. // Ein Widget, das eine GitHub-Stil-Beitragsheatmap für Pomodoro-Tracking-Daten anzeigt.
/// Shows a grid of colored squares representing work hours on different days, similar to GitHub's contribution graph. // Zeigt ein Raster aus farbigen Quadraten, die Arbeitsstunden an verschiedenen Tagen darstellen, ähnlich wie GitHub's Beitragsdiagramm.
/// 
/// Usage:
/// ```dart
/// GitHubChart()
/// ```
/// 
/// EN: Visualizes project time data in a year-long calendar view with color intensity indicating work duration.
/// DE: Visualisiert Projektzeit-Daten in einer Jahreskalenderansicht, wobei die Farbintensität die Arbeitsdauer anzeigt.

import 'package:flutter/cupertino.dart'; // Imports iOS-style widgets from Flutter. // Importiert iOS-Stil-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.
import 'package:intl/intl.dart'; // Imports internationalization support for date formatting. // Importiert Internationalisierungsunterstützung für Datumsformatierung.
import '../../../../infrastructure/data_sources/hive_services.dart'; // Imports services for local data storage using Hive. // Importiert Dienste für lokale Datenspeicherung mit Hive.
import '../../../notifiers/persistent_container_notifier.dart'; // Imports state notifier for project container selection. // Importiert State-Notifier für Projektcontainer-Auswahl.
import '../../../notifiers/project_state_notifier.dart'; // Imports state notifier for project data. // Importiert State-Notifier für Projektdaten.
import '../../../notifiers/project_time_notifier.dart'; // Imports state notifier for project time tracking. // Importiert State-Notifier für Projektzeit-Tracking.
import '../../../repository/auth_repository.dart'; // Imports repository for authentication data. // Importiert Repository für Authentifizierungsdaten.


class GitHubChart extends ConsumerWidget { // Defines a stateless widget with Riverpod integration. // Definiert ein zustandsloses Widget mit Riverpod-Integration.
  const GitHubChart({super.key}); // Constructor with an optional key parameter. // Konstruktor mit einem optionalen Key-Parameter.

  final List<Color> projectColors = const [ // Defines colors for different projects. // Definiert Farben für verschiedene Projekte.
    Color(0xffF04442), // Red color for project 1. // Rote Farbe für Projekt 1.
    Color(0xffF4A338), // Orange color for project 2. // Orange Farbe für Projekt 2.
    Color(0xFFF8CD34), // Yellow color for project 3. // Gelbe Farbe für Projekt 3.
    Color(0xff4FCE5D), // Green color for project 4. // Grüne Farbe für Projekt 4.
    Color(0xff4584DB), // Blue color for project 5. // Blaue Farbe für Projekt 5.
    Color(0xffAE73D1), // Purple color for project 6. // Lila Farbe für Projekt 6.
    Color(0xffEA73AD), // Pink color for project 7. // Rosa Farbe für Projekt 7.
    Color(0xff9B9A9E), // Gray color for project 8. // Graue Farbe für Projekt 8.
  ];

  Color getColorShade(Color baseColor, double factor) { // Function to adjust color intensity by a factor. // Funktion zur Anpassung der Farbintensität um einen Faktor.
    int r = (baseColor.red * factor).round().clamp(0, 255); // Calculates and clamps red channel value. // Berechnet und begrenzt den Rotkanalwert.
    int g = (baseColor.green * factor).round().clamp(0, 255); // Calculates and clamps green channel value. // Berechnet und begrenzt den Grünkanalwert.
    int b = (baseColor.blue * factor).round().clamp(0, 255); // Calculates and clamps blue channel value. // Berechnet und begrenzt den Blaukanalwert.
    return Color.fromRGBO(r, g, b, 1); // Returns new color with adjusted intensity. // Gibt neue Farbe mit angepasster Intensität zurück.
  }

  Color getColorBasedOnMinutes(double minutes, Color baseColor) { // Determines cell color based on minutes worked. // Bestimmt Zellenfarbe basierend auf gearbeiteten Minuten.
    if (minutes >= 480) return getColorShade(baseColor, 1.6); // 8+ hours: darkest shade. // 8+ Stunden: dunkelste Schattierung.
    if (minutes >= 360) return getColorShade(baseColor, 1.2); // 6+ hours: dark shade. // 6+ Stunden: dunkle Schattierung.
    if (minutes >= 240) return getColorShade(baseColor, 0.8); // 4+ hours: medium shade. // 4+ Stunden: mittlere Schattierung.
    if (minutes >= 120 || minutes >= 1) return getColorShade(baseColor, 0.4); // 2+ hours or any activity: light shade. // 2+ Stunden oder jede Aktivität: leichte Schattierung.
    return const Color(0xff262626); // No activity: dark gray. // Keine Aktivität: Dunkelgrau.
  }

  String formatDuration(Duration duration) { // Formats duration as HH:MM:SS. // Formatiert Dauer als HH:MM:SS.
    String twoDigits(int n) => n.toString().padLeft(2, "0"); // Helper function to ensure two digits with leading zero. // Hilfsfunktion zur Sicherstellung von zwei Stellen mit führender Null.
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60)); // Gets minutes part with two digits. // Holt Minutenteil mit zwei Stellen.
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60)); // Gets seconds part with two digits. // Holt Sekundenteil mit zwei Stellen.
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"; // Returns formatted duration string. // Gibt formatierte Dauerzeichenfolge zurück.
  }

  String formatDate(DateTime date, {bool useShortFormat = false}) { // Formats date for display. // Formatiert Datum zur Anzeige.
    String dayOfWeek = useShortFormat
        ? DateFormat('E').format(date) // Short day name (e.g., Mon). // Kurzer Tagesname (z.B. Mo).
        : DateFormat('EEEE').format(date); // Full day name (e.g., Monday). // Vollständiger Tagesname (z.B. Montag).
    String dayOfMonth = DateFormat('d').format(date); // Day of month (1-31). // Tag des Monats (1-31).
    String month = useShortFormat
        ? DateFormat('MMM').format(date) // Short month name (e.g., Jan). // Kurzer Monatsname (z.B. Jan).
        : DateFormat('MMMM').format(date); // Full month name (e.g., January). // Vollständiger Monatsname (z.B. Januar).
    return "$dayOfWeek, $month $dayOfMonth"; // Returns formatted date string. // Gibt formatierte Datumszeichenfolge zurück.
  }

  Widget _buildColorBox(BuildContext context, Color color, String tooltip) { // Creates a colored box with tooltip for the legend. // Erstellt ein farbiges Kästchen mit Tooltip für die Legende.
    return Tooltip( // Wrapper to show tooltip on hover. // Wrapper zum Anzeigen von Tooltips beim Überfahren.
      message: tooltip, // Text to show in tooltip. // Text, der im Tooltip angezeigt wird.
      textStyle: const TextStyle( // Style for tooltip text. // Stil für Tooltip-Text.
        color: Colors.white, // White text. // Weißer Text.
        fontFamily: 'San Francisco', // San Francisco font. // San Francisco Schriftart.
        fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
      ),
      decoration: BoxDecoration( // Visual style for tooltip box. // Visueller Stil für Tooltip-Box.
        color: const Color(0xff6E7681), // Dark gray background. // Dunkelgrauer Hintergrund.
        borderRadius: BorderRadius.circular(10), // Rounded corners. // Abgerundete Ecken.
      ),
      child: Padding( // Adds padding around box. // Fügt Abstand um das Kästchen hinzu.
        padding: const EdgeInsets.symmetric(horizontal: 2.0), // Horizontal padding. // Horizontaler Abstand.
        child: Container( // Color box container. // Farbkästchen-Container.
          height: 12.5, // Box height. // Kästchenhöhe.
          width: 12.5, // Box width. // Kästchenbreite.
          decoration: BoxDecoration( // Box visual style. // Visueller Stil des Kästchens.
            borderRadius: BorderRadius.circular(2), // Slightly rounded corners. // Leicht abgerundete Ecken.
            color: color, // Color from parameter. // Farbe aus Parameter.
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Builds the widget UI using Riverpod reference. // Erstellt die Widget-UI mit Riverpod-Referenz.
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider) ?? 0; // Gets selected project index or defaults to 0. // Holt ausgewählten Projektindex oder verwendet 0 als Standard.
    final projectNames = ref.watch(projectStateNotifierProvider); // Gets list of project names. // Holt Liste der Projektnamen.
    final isUserPremium = ref.watch(userProvider)?.isPremium ?? false; // Checks if user has premium status. // Prüft, ob Benutzer Premium-Status hat.
    final isPremiumContainer = selectedContainerIndex >= 4; // Determines if selected project requires premium. // Bestimmt, ob ausgewähltes Projekt Premium erfordert.

    final String currentProjectName; // Variable for current project name. // Variable für aktuellen Projektnamen.
    if (projectNames.isEmpty || selectedContainerIndex >= projectNames.length) { // If no projects or invalid index. // Wenn keine Projekte oder ungültiger Index.
      currentProjectName = 'Add a project'; // Default project name. // Standard-Projektname.
    } else { // If project exists. // Wenn Projekt existiert.
      currentProjectName = projectNames[selectedContainerIndex]; // Get actual project name. // Hole tatsächlichen Projektnamen.
    }

    final Color currentColor = projectColors[selectedContainerIndex % projectColors.length]; // Gets color for current project. // Holt Farbe für aktuelles Projekt.

    return Column( // Creates a vertical layout. // Erstellt ein vertikales Layout.
      children: [
        Expanded( // Flexible container that fills available space. // Flexibler Container, der verfügbaren Platz füllt.
          child: FutureBuilder<Map<String, Duration>>( // Async builder for time tracking data. // Asynchroner Builder für Zeiterfassungsdaten.
            future: HiveServices.retrieveGithubYearlyChartData(), // Loads yearly data from local storage. // Lädt Jahresdaten aus lokalem Speicher.
            builder: (context, snapshot) { // Builder function based on async state. // Builder-Funktion basierend auf asynchronem Zustand.
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) { // If data loading completed successfully. // Wenn Datenladen erfolgreich abgeschlossen wurde.
                if (isPremiumContainer && !isUserPremium) { // If trying to use premium feature without premium account. // Wenn versucht wird, Premium-Funktion ohne Premium-Konto zu nutzen.
                  return Center( // Centered message. // Zentrierte Nachricht.
                    child: Text( // Text widget. // Text-Widget.
                      'This feature is only available for premium users.', // Premium restriction message. // Premium-Einschränkungsnachricht.
                      style: GoogleFonts.nunito( // Nunito font style. // Nunito-Schriftstil.
                        color: Colors.grey[200], // Light gray text. // Hellgrauer Text.
                        fontSize: 16.0, // 16 point font size. // 16 Punkt Schriftgröße.
                        fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                      ),
                    ),
                  );
                }

                return Padding( // Adds padding around grid. // Fügt Abstand um das Raster hinzu.
                  padding: const EdgeInsets.symmetric(horizontal: 32.0), // Horizontal padding. // Horizontaler Abstand.
                  child: GridView.builder( // Creates a grid of cells. // Erstellt ein Raster aus Zellen.
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( // Grid layout configuration. // Rasterlayout-Konfiguration.
                      crossAxisCount: 53, // 53 columns (weeks in a year + 1). // 53 Spalten (Wochen in einem Jahr + 1).
                      childAspectRatio: 1, // Square cells. // Quadratische Zellen.
                    ),
                    itemBuilder: (context, index) { // Builder function for each grid cell. // Builder-Funktion für jede Rasterzelle.
                      final int weekOfYear = 51 - (index % 53); // Calculates week of year (reversed). // Berechnet Woche des Jahres (umgekehrt).
                      final int dayOfWeek = index ~/ 53; // Calculates day of week (0-6). // Berechnet Tag der Woche (0-6).
                      final DateTime date = DateTime.now().subtract( // Calculates date for this cell. // Berechnet Datum für diese Zelle.
                        Duration(days: DateTime.now().weekday - dayOfWeek + 7 * weekOfYear), // Subtracts days to get correct date. // Subtrahiert Tage, um korrektes Datum zu erhalten.
                      );

                      if (date.isAfter(DateTime.now())) { // If date is in the future. // Wenn Datum in der Zukunft liegt.
                        return Container(); // Empty container for future dates. // Leerer Container für zukünftige Daten.
                      }

                      final Duration projectDuration = ref
                          .read(projectTimesProvider.notifier)
                          .getProjectTime(selectedContainerIndex, date); // Gets tracked time for project on this date. // Holt erfasste Zeit für Projekt an diesem Datum.
                      
                      final double minutes = projectDuration.inSeconds / 60.0; // Converts duration to minutes. // Konvertiert Dauer in Minuten.
                      final Color boxColor = getColorBasedOnMinutes(minutes, currentColor); // Gets color based on worked minutes. // Holt Farbe basierend auf gearbeiteten Minuten.

                      final bool isCurrentDay = date.year == DateTime.now().year &&
                          date.month == DateTime.now().month &&
                          date.day == DateTime.now().day; // Checks if cell represents today. // Prüft, ob Zelle das heutige Datum darstellt.

                      return Container( // Cell container. // Zellen-Container.
                        margin: const EdgeInsets.all(1), // Margin around cell. // Rand um die Zelle.
                        padding: const EdgeInsets.all(2), // Padding inside cell. // Innenabstand der Zelle.
                        decoration: BoxDecoration( // Cell visual styling. // Visuelle Gestaltung der Zelle.
                          color: boxColor, // Color based on activity level. // Farbe basierend auf Aktivitätsniveau.
                          borderRadius: BorderRadius.circular(3), // Rounded corners. // Abgerundete Ecken.
                        ),
                        child: Tooltip( // Tooltip showing details on hover. // Tooltip, der Details beim Überfahren anzeigt.
                          message: '${formatDate(date, useShortFormat: true)}, ${date.year}\n'
                              'Project: $currentProjectName\n'
                              'Hours Worked: ${formatDuration(projectDuration)}', // Detailed tooltip text. // Detaillierter Tooltip-Text.
                          textStyle: const TextStyle( // Tooltip text style. // Tooltip-Textstil.
                            color: Colors.white, // White text. // Weißer Text.
                            fontFamily: 'San Francisco', // San Francisco font. // San Francisco Schriftart.
                            fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                          ),
                          decoration: BoxDecoration( // Tooltip box styling. // Tooltip-Box-Styling.
                            color: const Color(0xff6E7681), // Dark gray background. // Dunkelgrauer Hintergrund.
                            borderRadius: BorderRadius.circular(10), // Rounded corners. // Abgerundete Ecken.
                          ),
                          padding: const EdgeInsets.all(8), // Padding inside tooltip. // Innenabstand des Tooltips.
                          verticalOffset: 20, // Vertical position adjustment. // Vertikale Positionsanpassung.
                          margin: const EdgeInsets.all(5), // Margin around tooltip. // Rand um den Tooltip.
                        ),
                      );
                    },
                    itemCount: 7 * 53, // Total cells: 7 days * 53 weeks. // Gesamtzellen: 7 Tage * 53 Wochen.
                  ),
                );
              } else { // If data is still loading. // Wenn Daten noch geladen werden.
                return const CircularProgressIndicator(); // Loading indicator. // Ladeindikator.
              }
            },
          ),
        ),
        Padding( // Legend container with activity level indicators. // Legenden-Container mit Aktivitätsniveau-Indikatoren.
          padding: const EdgeInsets.fromLTRB(50, 5, 50, 5), // Padding around legend. // Abstand um die Legende.
          child: Row( // Horizontal arrangement for legend items. // Horizontale Anordnung für Legendenelemente.
            mainAxisAlignment: MainAxisAlignment.end, // Aligns items to the right. // Richtet Elemente rechts aus.
            children: [
              Padding( // "Less" label. // "Weniger"-Beschriftung.
                padding: const EdgeInsets.only(right: 5.0), // Right padding. // Rechter Abstand.
                child: Text( // Text widget. // Text-Widget.
                  'Less', // Text content. // Textinhalt.
                  style: GoogleFonts.nunito( // Nunito font style. // Nunito-Schriftstil.
                    color: const Color(0xffF2F2F2), // Light gray text. // Hellgrauer Text.
                    fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                  ),
                ),
              ),
              _buildColorBox(context, const Color(0xff262626), 'No activity'), // Color box for no activity. // Farbkästchen für keine Aktivität.
              _buildColorBox(context, getColorShade(currentColor, 0.4), 'The first minute and two hours—or even more'), // Color box for light activity. // Farbkästchen für leichte Aktivität.
              _buildColorBox(context, getColorShade(currentColor, 0.8), 'Four hours—or even more'), // Color box for medium activity. // Farbkästchen für mittlere Aktivität.
              _buildColorBox(context, getColorShade(currentColor, 1.2), 'Six hours—or even more'), // Color box for high activity. // Farbkästchen für hohe Aktivität.
              _buildColorBox(context, getColorShade(currentColor, 1.6), 'Eight hours—or even more'), // Color box for very high activity. // Farbkästchen für sehr hohe Aktivität.
              Padding( // "More" label. // "Mehr"-Beschriftung.
                padding: const EdgeInsets.only(left: 5.0), // Left padding. // Linker Abstand.
                child: Text( // Text widget. // Text-Widget.
                  'More', // Text content. // Textinhalt.
                  style: GoogleFonts.nunito( // Nunito font style. // Nunito-Schriftstil.
                    color: const Color(0xffF2F2F2), // Light gray text. // Hellgrauer Text.
                    fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
