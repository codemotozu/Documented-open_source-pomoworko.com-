/// CartesianPremiumChart
/// 
/// A comprehensive analytics chart widget for premium users. // Ein umfassendes Analyse-Diagramm-Widget für Premium-Benutzer.
/// Visualizes Pomodoro time tracking data across different time frames with project-specific filtering. // Visualisiert Pomodoro-Zeiterfassungsdaten über verschiedene Zeiträume mit projektspezifischer Filterung.
/// 
/// Usage:
/// ```dart
/// CartesianPremiumChart(
///   title: 'Project Analytics',
/// )
/// ```
/// 
/// EN: Displays advanced time tracking analytics with weekly, monthly, and yearly views for premium users.
/// DE: Zeigt erweiterte Zeiterfassungsanalysen mit wöchentlichen, monatlichen und jährlichen Ansichten für Premium-Benutzer an.

import 'package:flutter/cupertino.dart'; // Imports iOS-style widgets from Flutter. // Importiert iOS-Stil-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.
import 'package:intl/intl.dart'; // Imports internationalization support for date formatting. // Importiert Internationalisierungsunterstützung für Datumsformatierung.
import 'package:syncfusion_flutter_charts/charts.dart'; // Imports Syncfusion charts package. // Importiert das Syncfusion-Diagrammpaket.
import '../../../../common/utils/responsive_web.dart'; // Imports utility for responsive web design. // Importiert Hilfsprogramm für responsives Webdesign.
import '../../../../infrastructure/data_sources/hive_services.dart'; // Imports local storage services using Hive. // Importiert lokale Speicherdienste mit Hive.
import '../../../notifiers/persistent_container_notifier.dart'; // Imports notifier for persistent container selection. // Importiert Notifier für persistente Container-Auswahl.
import '../../../notifiers/project_state_notifier.dart'; // Imports notifier for project state management. // Importiert Notifier für Projektzustandsverwaltung.
import '../../../notifiers/project_time_notifier.dart'; // Imports notifier for project time tracking. // Importiert Notifier für Projekt-Zeiterfassung.
import '../../../notifiers/providers.dart'; // Imports Riverpod providers used in the app. // Importiert Riverpod-Provider, die in der App verwendet werden.
import '../../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.
import '../../../widgets/bar_chart_project.dart'; // Imports custom project bar chart widget. // Importiert benutzerdefiniertes Projekt-Balkendiagramm-Widget.
import '../analytics/github_chart.dart'; // Imports GitHub-style contribution chart widget. // Importiert GitHub-Stil-Beitragsdiagramm-Widget.
import 'time_frame_pop_up_premium_menu_button.dart'; // Imports custom popup menu button for time frame selection. // Importiert benutzerdefinierte Popup-Menüschaltfläche für Zeitrahmenauswahl.


class CartesianPremiumChart extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod integration. // Definiert ein zustandsbehaftetes Widget mit Riverpod-Integration.
  final String title; // Title property for the chart. // Titeleigenschaft für das Diagramm.
  const CartesianPremiumChart({super.key, required this.title}); // Constructor requiring a title parameter. // Konstruktor, der einen Titelparameter erfordert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CartesianPremiumChartState(); // Creates state class for this widget. // Erstellt Zustandsklasse für dieses Widget.
}

class _CartesianPremiumChartState extends ConsumerState<CartesianPremiumChart> { // State class for CartesianPremiumChart. // Zustandsklasse für CartesianPremiumChart.
  final int _hoveredIndex = -1; // Tracks which project is being hovered (none by default). // Verfolgt, welches Projekt gerade überfahren wird (standardmäßig keines).

  late TooltipBehavior _tooltipBehavior; // Will hold tooltip configuration. // Enthält Tooltip-Konfiguration.
  String selectedTimeFrame = 'Weekly'; // Default selected time frame is weekly. // Standardmäßig ausgewählter Zeitrahmen ist wöchentlich.
  List<String> timeFrames = [
    'Weekly',
    'Monthly',
    'Yearly',
  ]; // Available time frame options. // Verfügbare Zeitrahmenoptionen.
  @override
  void initState() { // Called when widget is first created. // Wird aufgerufen, wenn Widget zum ersten Mal erstellt wird.
    super.initState(); // Calls parent class initializer. // Ruft Initialisierer der Elternklasse auf.
    _tooltipBehavior = TooltipBehavior(enable: true); // Enables tooltips on chart elements. // Aktiviert Tooltips auf Diagrammelementen.
  }

  String formatDuration(Duration duration) { // Formats duration into hours:minutes:seconds. // Formatiert Dauer in Stunden:Minuten:Sekunden.
    String twoDigits(int n) => n.toString().padLeft(2, "0"); // Helper to ensure two digits with leading zero. // Hilfsfunktion zur Sicherstellung von zwei Stellen mit führender Null.
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60)); // Gets minutes part with two digits. // Holt Minutenteil mit zwei Stellen.
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60)); // Gets seconds part with two digits. // Holt Sekundenteil mit zwei Stellen.
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"; // Returns formatted duration. // Gibt formatierte Dauer zurück.
  }

  String formatDate(DateTime date, {bool useShortFormat = false}) { // Formats date for display, with option for short format. // Formatiert Datum zur Anzeige, mit Option für Kurzformat.
    String dayOfWeek = useShortFormat
        ? DateFormat('E').format(date) // Short day name (e.g., Mon). // Kurzer Tagesname (z.B. Mo).
        : DateFormat('EEEE').format(date); // Full day name (e.g., Monday). // Vollständiger Tagesname (z.B. Montag).
    String dayOfMonth = DateFormat('d').format(date); // Day of month (1-31). // Tag des Monats (1-31).
    String month = useShortFormat
        ? DateFormat('MMM').format(date) // Short month name (e.g., Jan). // Kurzer Monatsname (z.B. Jan).
        : DateFormat('MMMM').format(date); // Full month name (e.g., January). // Vollständiger Monatsname (z.B. Januar).
    return "$dayOfWeek \n$month $dayOfMonth"; // Returns formatted date with newline. // Gibt formatiertes Datum mit Zeilenumbruch zurück.
  }

  List<String> generateWeekDays() { // Generates a list of dates for the past week. // Generiert eine Liste von Daten für die vergangene Woche.
    List<String> weekDays = []; // Empty list for week days. // Leere Liste für Wochentage.
    DateTime now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
    for (int i = -1; i <= 7; i++) { // Loops from -1 to 7 (9 days). // Schleife von -1 bis 7 (9 Tage).
      String day = DateFormat('dd/MM/yyyy').format( // Formats each date as day/month/year. // Formatiert jedes Datum als Tag/Monat/Jahr.
        now.subtract(
          Duration(days: i), // Subtracts i days from now. // Subtrahiert i Tage von jetzt.
        ),
      );
      weekDays.add(day); // Adds formatted date to list. // Fügt formatiertes Datum zur Liste hinzu.
    }
    return weekDays; // Returns list of week days. // Gibt Liste der Wochentage zurück.
  }

  List<String> generateMonthDays() { // Generates a list of dates for the past month. // Generiert eine Liste von Daten für den vergangenen Monat.
    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
    DateTime startDate = DateTime(now.year, now.month - 1, now.day); // Date from one month ago. // Datum von vor einem Monat.
    DateTime endDate = DateTime(now.year, now.month, now.day); // Current date. // Aktuelles Datum.
    int daysDifference = endDate.difference(startDate).inDays; // Number of days between dates. // Anzahl der Tage zwischen den Daten.
    return List.generate( // Generates a list of formatted dates. // Generiert eine Liste formatierter Daten.
      daysDifference,
      (index) => DateFormat('dd/MM/yyyy').format( // Formats each date as day/month/year. // Formatiert jedes Datum als Tag/Monat/Jahr.
        startDate.add(
          Duration(days: index), // Adds index days to start date. // Fügt Index-Tage zum Startdatum hinzu.
        ),
      ),
    );
  }

  List<String> generateYearMonths() { // Generates a list of month names for a year. // Generiert eine Liste von Monatsnamen für ein Jahr.
    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
    List<String> months = List.generate( // Generates list of all 12 months. // Generiert Liste aller 12 Monate.
      12,
      (index) => DateFormat('MMM').format( // Short month name format (Jan, Feb, etc.). // Kurzes Monatsformat (Jan, Feb, usw.).
        DateTime(now.year, index + 1), // Date for each month in current year. // Datum für jeden Monat im aktuellen Jahr.
      ),
    );
    return [...months.sublist(now.month), ...months.sublist(0, now.month)]; // Reorders list to start from current month. // Ordnet Liste neu, beginnend mit aktuellem Monat.
  }

  Duration calculateTotalDuration(List<Duration> weekData) { // Calculates total duration from a list of durations. // Berechnet die Gesamtdauer aus einer Liste von Dauern.
    return weekData.fold(Duration.zero, (prev, curr) => prev + curr); // Sums all durations in the list. // Summiert alle Dauern in der Liste.
  }

  List<String> generateYearMonthsGithubStyle() { // Generates month labels in GitHub contribution style. // Generiert Monatsbeschriftungen im GitHub-Beitragsstil.
    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.

    List<String> months = List.generate(13, (index) { // Generates 13 months (full year + overlap). // Generiert 13 Monate (volles Jahr + Überlappung).
      int year = now.year; // Current year. // Aktuelles Jahr.
      int month = (now.month - 1 + index) % 12 + 1; // Month number with wraparound. // Monatsnummer mit Umbruch.

      if (month > now.month) year--; // Adjusts year for previous months. // Passt Jahr für vorherige Monate an.

      return DateFormat('MMM').format(DateTime(year, month)); // Returns short month name. // Gibt kurzen Monatsnamen zurück.
    });

    return months; // Returns list of month names. // Gibt Liste der Monatsnamen zurück.
  }

  CategoryAxis getXAxis() { // Creates X-axis configuration based on selected time frame. // Erstellt X-Achsen-Konfiguration basierend auf ausgewähltem Zeitrahmen.
    if (selectedTimeFrame == 'Weekly') { // For weekly view. // Für wöchentliche Ansicht.
      return const CategoryAxis( // Returns category axis for weekly view. // Gibt Kategorieachse für wöchentliche Ansicht zurück.
        minimum: -0.5, // Sets minimum value for axis range. // Legt Mindestwert für Achsenbereich fest.
        maximum: 6.5, // Sets maximum value for axis range. // Legt Höchstwert für Achsenbereich fest.
        interval: 1, // Sets interval between axis labels. // Legt Intervall zwischen Achsenbeschriftungen fest.
        labelPlacement: LabelPlacement.onTicks, // Places labels on tick marks. // Platziert Beschriftungen auf Tick-Marken.
        labelIntersectAction: AxisLabelIntersectAction.multipleRows, // Handles overlapping labels. // Behandelt überlappende Beschriftungen.
        axisLine: AxisLine(width: 0), // Hides axis line. // Versteckt die Achsenlinie.
        majorTickLines: MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
        rangePadding: ChartRangePadding.round, // Rounds axis range to nice values. // Rundet Achsenbereich auf schöne Werte.
      );
    } else if (selectedTimeFrame == 'Monthly') { // For monthly view. // Für monatliche Ansicht.
      List<String> monthDays = generateMonthDays(); // Gets list of days in month. // Holt Liste der Tage im Monat.
      return CategoryAxis( // Returns category axis for monthly view. // Gibt Kategorieachse für monatliche Ansicht zurück.
        interval: 5, // Shows label every 5 days. // Zeigt Beschriftung alle 5 Tage.
        minimum: -0.5, // Sets minimum value for axis range. // Legt Mindestwert für Achsenbereich fest.
        maximum: monthDays.length.toDouble() - 0.5, // Sets maximum based on number of days. // Legt Maximum basierend auf Anzahl der Tage fest.
        isInversed: true, // Reverses axis direction. // Kehrt die Achsenrichtung um.
        labelPlacement: LabelPlacement.onTicks, // Places labels on tick marks. // Platziert Beschriftungen auf Tick-Marken.
        labelIntersectAction: AxisLabelIntersectAction.multipleRows, // Handles overlapping labels. // Behandelt überlappende Beschriftungen.
        axisLine: const AxisLine(width: 0), // Hides axis line. // Versteckt die Achsenlinie.
        majorTickLines: const MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
        rangePadding: ChartRangePadding.round, // Rounds axis range to nice values. // Rundet Achsenbereich auf schöne Werte.
      );
    } else if (selectedTimeFrame == 'Yearly') { // For yearly view. // Für jährliche Ansicht.
      return const CategoryAxis( // Returns category axis for yearly view. // Gibt Kategorieachse für jährliche Ansicht zurück.
        interval: 1, // Shows label for each month. // Zeigt Beschriftung für jeden Monat.
        minimum: -0.5, // Sets minimum value for axis range. // Legt Mindestwert für Achsenbereich fest.
        maximum: 11.5, // Sets maximum for 12 months (0-11). // Legt Maximum für 12 Monate fest (0-11).
        labelPlacement: LabelPlacement.onTicks, // Places labels on tick marks. // Platziert Beschriftungen auf Tick-Marken.
        labelIntersectAction: AxisLabelIntersectAction.multipleRows, // Handles overlapping labels. // Behandelt überlappende Beschriftungen.
        axisLine: AxisLine(width: 0), // Hides axis line. // Versteckt die Achsenlinie.
        majorTickLines: MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
        rangePadding: ChartRangePadding.round, // Rounds axis range to nice values. // Rundet Achsenbereich auf schöne Werte.
      );
    } else { // Default fallback. // Standard-Rückfall.
      return const CategoryAxis( // Returns default category axis. // Gibt Standard-Kategorieachse zurück.
        interval: 1, // Default interval of 1. // Standardintervall von 1.
        minimum: -0.5, // Default minimum of -0.5. // Standardminimum von -0,5.
        maximum: 11.5, // Default maximum of 11.5. // Standardmaximum von 11,5.
        labelPlacement: LabelPlacement.onTicks, // Places labels on tick marks. // Platziert Beschriftungen auf Tick-Marken.
        labelIntersectAction: AxisLabelIntersectAction.multipleRows, // Handles overlapping labels. // Behandelt überlappende Beschriftungen.
        axisLine: AxisLine(width: 0), // Hides axis line. // Versteckt die Achsenlinie.
        majorTickLines: MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
        rangePadding: ChartRangePadding.round, // Rounds axis range to nice values. // Rundet Achsenbereich auf schöne Werte.
      );
    }
  }

  bool isPremium = false; // User premium status flag. // Benutzer-Premium-Status-Flag.
  DateTime now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.

  bool isSelected = false; // Selection state flag. // Auswahlzustand-Flag.
  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    bool isEditIconVisible = false; // Flag for edit icon visibility. // Flag für Bearbeitungssymbol-Sichtbarkeit.
    final currentProjectProvider = StateProvider<String?>((ref) => null); // Provider for current project name. // Provider für aktuellen Projektnamen.

    final textTheme = Theme.of(context).textTheme; // Gets current text theme. // Holt aktuelles Textthema.

    final focusedTaskTitle = ref.watch(focusedTaskTitleProvider); // Gets currently focused task title. // Holt aktuell fokussierten Aufgabentitel.

    final projectNames = ref.watch(projectStateNotifierProvider); // Gets list of project names. // Holt Liste der Projektnamen.

    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.

    int currentIndex = selectedContainerIndex; // Working copy of selected index. // Arbeitskopie des ausgewählten Index.
    if (currentIndex >= projectNames.length) { // If selected index is invalid. // Wenn ausgewählter Index ungültig ist.
      currentIndex = projectNames.length - 1; // Reset to last valid index. // Zurücksetzen auf letzten gültigen Index.
    }

    final List<Color> projectColors = [ // List of colors for different projects. // Liste von Farben für verschiedene Projekte.
      const Color(0xffF04442), // Red. // Rot.
      const Color(0xffF4A338), // Orange. // Orange.
      const Color(0xFFF8CD34), // Yellow. // Gelb.
      const Color(0xff4FCE5D), // Green. // Grün.
      const Color(0xff4584DB), // Blue. // Blau.
      const Color(0xffAE73D1), // Purple. // Lila.
      const Color(0xffEA73AD), // Pink. // Rosa.
      const Color(0xff9B9A9E), // Gray. // Grau.
    ];


    final projectTimes = ref.watch(projectTimesProvider); // Gets project time tracking data. // Holt Daten zur Projektzeiterfassung.
    final currentProjectName =
        projectNames.isNotEmpty ? projectNames[currentIndex] : 'No project'; // Gets current project name or default. // Holt aktuellen Projektnamen oder Standard.
    final currentProjectTimesMap = projectTimes[currentProjectName] ?? {}; // Gets time map for current project. // Holt Zeitübersicht für aktuelles Projekt.

    Duration getTotalDuration(Map<DateTime, Duration> timesMap) { // Helper to calculate total duration from a map. // Hilfsfunktion zur Berechnung der Gesamtdauer aus einer Map.
      return timesMap.values.fold(Duration.zero, (prev, curr) => prev + curr); // Sums all durations in the map. // Summiert alle Dauern in der Map.
    }

    final totalProjectTime = getTotalDuration(currentProjectTimesMap); // Calculates total time for current project. // Berechnet Gesamtzeit für aktuelles Projekt.

    Color currentColor = projectColors[currentIndex % projectColors.length]; // Gets color for current project. // Holt Farbe für aktuelles Projekt.

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
      child: Scaffold( // Material Design layout scaffold. // Material Design-Layoutgerüst.
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Black background. // Schwarzer Hintergrund.
        appBar: AppBar( // App bar for navigation and title. // App-Bar für Navigation und Titel.
          backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Black app bar background. // Schwarzer App-Bar-Hintergrund.
          iconTheme: const IconThemeData( // Icon theme configuration. // Symbol-Thema-Konfiguration.
            color: Color(0xffF2F2F2), // Light gray icon color. // Hellgraue Symbolfarbe.
          ),
          title: Text( // App bar title. // App-Bar-Titel.
            'Analytics', // Title text. // Titeltext.
            style: textTheme.titleLarge?.copyWith( // Style based on theme. // Stil basierend auf Thema.
              fontFamily: GoogleFonts.nunito( // Nunito font. // Nunito-Schriftart.
                color: const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
              ).fontFamily, // Gets just the font family name. // Holt nur den Schriftfamiliennamen.
              color: const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
            ),
          ),
          centerTitle: true, // Centers the title in the app bar. // Zentriert den Titel in der App-Bar.
        ),
        body: Consumer(builder: (context, ref, child) { // Consumer for Riverpod state access. // Consumer für Riverpod-Zustandszugriff.
          return FutureBuilder<Map<String, Duration>>( // Builds UI based on async data. // Erstellt UI basierend auf asynchronen Daten.
            future: futureData, // Future to wait for. // Future, auf das gewartet wird.
            builder: (context, snapshot) { // Builder function for async UI. // Builder-Funktion für asynchrone UI.
              if (snapshot.connectionState == ConnectionState.done) { // If data loading is complete. // Wenn Datenladen abgeschlossen ist.
                if (snapshot.hasData) { // If data was successfully loaded. // Wenn Daten erfolgreich geladen wurden.
                  final data = snapshot.data!; // Gets the loaded data. // Holt die geladenen Daten.
                  final projectTimesNotifier =
                      ref.read(projectTimesProvider.notifier); // Gets project times notifier. // Holt Projektzeit-Notifier.

                  final currentProjectName = projectNames[currentIndex]; // Gets current project name. // Holt aktuellen Projektnamen.

                  final selectedContainerIndex =
                      ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.
                  final currentColor = projectColors[
                      selectedContainerIndex % projectColors.length]; // Gets color for current project. // Holt Farbe für aktuelles Projekt.

                  List<Duration> durationsData = []; // List to store duration data for chart. // Liste zum Speichern von Dauerdaten für Diagramm.

                  if (selectedTimeFrame == 'Weekly') { // For weekly view. // Für wöchentliche Ansicht.
                    durationsData = weekDays.skip(1).take(7).map((day) { // Gets durations for past 7 days. // Holt Dauern für die letzten 7 Tage.
                      final date = DateFormat('dd/MM/yyyy').parse(day); // Parses date from string. // Analysiert Datum aus Zeichenfolge.
                      return ref
                          .read(projectTimesProvider.notifier)
                          .getProjectTime(selectedContainerIndex, date); // Gets time for project on that date. // Holt Zeit für Projekt an diesem Datum.
                    }).toList();
                  } else if (selectedTimeFrame == 'Monthly') { // For monthly view. // Für monatliche Ansicht.

                    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
                    final monthData = List.generate( // Generates list of durations for month. // Generiert Liste von Dauern für Monat.
                      generateMonthDays().length, // Number of days in month. // Anzahl der Tage im Monat.
                      (index) {
                        final date = DateTime( // Creates date for each day in month. // Erstellt Datum für jeden Tag im Monat.
                          now.year,
                          now.month,
                          now.day - index,
                        );
                        return ref
                            .read(projectTimesProvider.notifier)
                            .getProjectTimeForMonth(
                                selectedContainerIndex, date); // Gets time for project in month. // Holt Zeit für Projekt im Monat.
                      },
                    );
                    durationsData = monthData; // Sets data for chart. // Setzt Daten für Diagramm.

                  } else if (selectedTimeFrame == 'Yearly') { // For yearly view. // Für jährliche Ansicht.

                    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
                    final yearData = List.generate( // Generates list of durations for year. // Generiert Liste von Dauern für Jahr.
                      12, // 12 months in a year. // 12 Monate in einem Jahr.
                      (index) {
                        int month = now.month - index; // Month number (can be negative). // Monatsnummer (kann negativ sein).
                        int year = now.year; // Current year. // Aktuelles Jahr.

                        if (month <= 0) { // If month is 0 or negative. // Wenn Monat 0 oder negativ ist.
                          month += 12; // Adjust month (e.g., 0 → 12, -1 → 11). // Monat anpassen (z.B. 0 → 12, -1 → 11).
                          year -= 1; // Go to previous year. // Zum vorherigen Jahr wechseln.
                        }

                        final date = DateTime(year, month, 1); // First day of month. // Erster Tag des Monats.
                        return ref
                            .read(projectTimesProvider.notifier)
                            .getProjectTimeForYear(
                                selectedContainerIndex, date); // Gets time for project in year. // Holt Zeit für Projekt im Jahr.
                      },
                    ).reversed.toList(); // Reverses list for chronological order. // Kehrt Liste für chronologische Reihenfolge um.
                    durationsData = yearData; // Sets data for chart. // Setzt Daten für Diagramm.
                  }

                  Duration totalDuration =
                      calculateTotalDuration(durationsData); // Calculates total duration across all periods. // Berechnet Gesamtdauer über alle Perioden.
                  String formattedTotalDuration = formatDuration(totalDuration); // Formats total duration for display. // Formatiert Gesamtdauer für Anzeige.
                  return Column(children: [ // Main layout column. // Haupt-Layout-Spalte.
                    Row( // Row for time frame selector and delete button. // Zeile für Zeitrahmenwähler und Lösch-Schaltfläche.
                      mainAxisAlignment: MainAxisAlignment.center, // Centers children horizontally. // Zentriert Kinder horizontal.
                      children: [
                        Flexible( // Flexible container for time frame selector. // Flexibler Container für Zeitrahmenwähler.
                          flex: 4, // Flex ratio. // Flex-Verhältnis.
                          child: Padding( // Adds padding around selector. // Fügt Abstand um Wähler hinzu.
                            padding: const EdgeInsets.all(8.0), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                            child: TimeFramePopupPremiumMenuButton( // Custom dropdown for time frames. // Benutzerdefiniertes Dropdown für Zeitrahmen.
                              timeFrames: timeFrames, // List of available time frames. // Liste verfügbarer Zeitrahmen.
                              currentTimeFrame: selectedTimeFrame, // Currently selected time frame. // Aktuell ausgewählter Zeitrahmen.
                              isPremium: isPremium, // User premium status. // Benutzer-Premium-Status.
                              onTimeFrameSelected: (newValue) { // Callback when time frame is selected. // Callback, wenn Zeitrahmen ausgewählt wird.
                                if (newValue != selectedTimeFrame &&
                                    isPremium == false) { // If selection changed and not premium. // Wenn Auswahl geändert und nicht Premium.
                                  setState(() { // Updates state. // Aktualisiert Zustand.
                                    selectedTimeFrame = newValue; // Updates selected time frame. // Aktualisiert ausgewählten Zeitrahmen.
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                 
                        ElevatedButton( // Delete project button. // Projekt löschen-Schaltfläche.
                          onPressed: () { // Action when button is pressed. // Aktion bei gedrückter Schaltfläche.
                            showDialog( // Shows confirmation dialog. // Zeigt Bestätigungsdialog.
                              context: context, // Current build context. // Aktueller Build-Kontext.
                              builder: (context) => CupertinoAlertDialog( // iOS-style alert dialog. // Dialog im iOS-Stil.
                                title: const Text('Delete Project'), // Dialog title. // Dialog-Titel.
                                content: const Text(
                                    'Are you sure you want to delete this project? This action cannot be undone.'), // Warning message. // Warnmeldung.
                                actions: [ // Dialog buttons. // Dialog-Schaltflächen.
                                  CupertinoDialogAction( // Cancel button. // Abbrechen-Schaltfläche.
                                    child: const Text('Cancel'), // Button text. // Schaltflächentext.
                                    onPressed: () { // Action when cancel is pressed. // Aktion bei Betätigung von Abbrechen.
                                      Navigator.of(context).pop(); // Closes dialog. // Schließt Dialog.
                                    },
                                  ),
                                  CupertinoDialogAction( // Delete button. // Löschen-Schaltfläche.
                                    isDestructiveAction: true, // Marks as destructive action (red text). // Kennzeichnet als destruktive Aktion (roter Text).
                                    child: const Text('Delete'), // Button text. // Schaltflächentext.
                                    onPressed: () async { // Action when delete is pressed. // Aktion bei Betätigung von Löschen.
                                      try { // Error handling block. // Fehlerbehandlungsblock.
                                      
                                        final result = await ref
                                            .read(authRepositoryProvider)
                                            .deleteProject(
                                                selectedContainerIndex); // Deletes project on server. // Löscht Projekt auf Server.

                                        if (result.error == null) { // If deletion was successful. // Wenn Löschung erfolgreich war.
                                          ref
                                              .read(projectStateNotifierProvider
                                                  .notifier)
                                              .deleteProject(
                                                  selectedContainerIndex); // Removes project from state. // Entfernt Projekt aus Zustand.
                                          ref
                                              .read(
                                                  projectTimesProvider.notifier)
                                              .clearProjectData(
                                                  selectedContainerIndex); // Clears project time data. // Löscht Projektzeit-Daten.
                                        } else { // If there was an error. // Wenn ein Fehler aufgetreten ist.
                                          print(
                                              'Error deleting project: ${result.error}'); // Logs error. // Protokolliert Fehler.
                                        }
                                      } catch (e) { // Catches any exceptions. // Fängt alle Ausnahmen ab.
                                        print(
                                            'Error during project deletion: $e'); // Logs exception. // Protokolliert Ausnahme.
                                      }

                                      Navigator.of(context).pop(); // Closes dialog. // Schließt Dialog.
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ButtonStyle( // Button style configuration. // Schaltflächen-Stil-Konfiguration.
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20)), // Button padding. // Schaltflächen-Abstand.
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xffF23030)), // Red background color. // Roter Hintergrund.
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white), // White text color. // Weiße Textfarbe.
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>( // Button shape. // Schaltflächenform.
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners with 10 pixel radius. // Abgerundete Ecken mit 10 Pixel Radius.
                              ),
                            ),
                          ),
                          child: Text( // Button text. // Schaltflächentext.
                            'Delete Project', // Text content. // Textinhalt.
                            style: GoogleFonts.nunito( // Nunito font. // Nunito-Schriftart.
                                fontSize: 18, fontWeight: FontWeight.w600), // Font size and weight. // Schriftgröße und -gewicht.
                          ),
                        ),
                      ],
                    ),
                    Flexible( // Flexible container for project info. // Flexibler Container für Projektinfo.
                      flex: 5, // Flex ratio. // Flex-Verhältnis.
                      child: Padding( // Adds padding around project info. // Fügt Abstand um Projektinfo hinzu.
                        padding: const EdgeInsets.all(8.0), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                        child: Consumer( // Consumer for accessing Riverpod state. // Consumer für Zugriff auf Riverpod-Zustand.
                          builder: (context, ref, child) { // Builder function. // Builder-Funktion.
                            final selectedContainerIndex =
                                ref.watch(persistentContainerIndexProvider) ??
                                    0; // Gets selected container index or defaults to 0. // Holt ausgewählten Container-Index oder verwendet 0 als Standard.
                            final projectNames =
                                ref.watch(projectStateNotifierProvider); // Gets project names. // Holt Projektnamen.

                            final currentProjectName = projectNames
                                        .isNotEmpty &&
                                    selectedContainerIndex < projectNames.length
                                ? projectNames[selectedContainerIndex]
                                : 'No project'; // Gets current project name or default. // Holt aktuellen Projektnamen oder Standard.

                            final totalProjectTime = ref
                                .read(projectTimesProvider.notifier)
                                .getTotalProjectTime(selectedContainerIndex); // Gets total time for current project. // Holt Gesamtzeit für aktuelles Projekt.

                            return Text( // Project info text. // Projektinfo-Text.
                              textAlign: TextAlign.center, // Centers text horizontally. // Zentriert Text horizontal.
                              'Project: $currentProjectName, Total Hours Worked: $formattedTotalDuration', // Project name and total time. // Projektname und Gesamtzeit.
                              style: GoogleFonts.nunito( // Nunito font. // Nunito-Schriftart.
                                color: Colors.grey[200], // Light gray text color. // Hellgraue Textfarbe.
                                fontSize: 16.0, // Font size. // Schriftgröße.
                                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Flexible( // Flexible container for main chart area. // Flexibler Container für Hauptdiagrammbereich.
                      flex: 3 * 8, // Flex ratio. // Flex-Verhältnis.
                      child: Row( // Row for project list and chart. // Zeile für Projektliste und Diagramm.
                        children: [
                          Flexible( // Flexible container for project list. // Flexibler Container für Projektliste.
                            flex: 6, // Flex ratio. // Flex-Verhältnis.
                            child: Padding( // Adds padding around project list. // Fügt Abstand um Projektliste hinzu.
                              padding: const EdgeInsets.only(left: 30.0), // Left padding of 30 pixels. // Linker Abstand von 30 Pixeln.
                              child: Column( // Column for project list items. // Spalte für Projektlistenelemente.
                                crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left. // Richtet Kinder links aus.
                                mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the top. // Richtet Kinder oben aus.
                                children: List.generate( // Generates a list of project items. // Generiert eine Liste von Projektelementen.
                                  projectColors.length, // Number of projects to show. // Anzahl der anzuzeigenden Projekte.
                                  (index) { // Builder for each project item. // Builder für jedes Projektelement.
                                    bool isPremiumContainer = index >= 4; // Determines if this is a premium container. // Bestimmt, ob dies ein Premium-Container ist.
                                    bool isUserPremium =
                                        ref.watch(userProvider)?.isPremium ??
                                            false; // Checks if user has premium. // Prüft, ob Benutzer Premium hat.
                                    bool isLocked =
                                        isPremiumContainer && !isUserPremium; // Determines if container is locked. // Bestimmt, ob Container gesperrt ist.

                                    return Padding( // Padding for project item. // Abstand für Projektelement.
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0), // Horizontal and vertical padding. // Horizontaler und vertikaler Abstand.
                                      child: GestureDetector( // Touch detector for project item. // Berührungsdetektor für Projektelement.
                                        onTap: () { // Action when tapped. // Aktion bei Berührung.
                                          if (isLocked) { // If project is locked (premium required). // Wenn Projekt gesperrt ist (Premium erforderlich).
                                            } else { // If project is accessible. // Wenn Projekt zugänglich ist.
                                            ref
                                                .read(
                                                    persistentContainerIndexProvider
                                                        .notifier)
                                                .updateIndex(index); // Updates selected project index. // Aktualisiert ausgewählten Projektindex.
                                          }
                                        },
                                        child: BarChartProject( // Project bar chart widget. // Projekt-Balkendiagramm-Widget.
                                          projectColors[index], // Color for this project. // Farbe für dieses Projekt.
                                          index: index, // Project index. // Projektindex.
                                          isEditIconVisible:
                                              _hoveredIndex == index &&
                                                  !isLocked, // Shows edit icon only if hovered and not locked. // Zeigt Bearbeitungssymbol nur, wenn darüber geschwebt und nicht gesperrt.
                                          icon: isLocked
                                              ? const Icon(CupertinoIcons.lock,
                                                  color: Colors.white, size: 16) // Lock icon for premium projects. // Schlosssymbol für Premium-Projekte.
                                              : null,
                                          isPremiumLocked:
                                              isLocked, // Premium lock status. // Premium-Sperrstatus.
                                        ),
                                      ),
                                    );
                                  },

                                ),
                              ),
                            ),
                          ),
                          Flexible( // Flexible container for main chart. // Flexibler Container für Hauptdiagramm.
                            flex: 46, // Flex ratio (much larger than project list). // Flex-Verhältnis (viel größer als Projektliste).
                            child: Padding( // Adds padding around chart. // Fügt Abstand um Diagramm hinzu.
                              padding: const EdgeInsets.all(4.0), // 4 pixel padding all around. // 4 Pixel Abstand rundum.
                              child: Consumer(builder: (context, ref, child) { // Consumer for Riverpod state. // Consumer für Riverpod-Zustand.
                                final selectedContainerIndex = ref.watch(
                                        persistentContainerIndexProvider) ??
                                    0; // Gets selected container index or defaults to 0. // Holt ausgewählten Container-Index oder verwendet 0 als Standard.
                                final currentColor = projectColors[
                                    selectedContainerIndex %
                                        projectColors.length]; // Gets color for current project. // Holt Farbe für aktuelles Projekt.

                                return SfCartesianChart( // Syncfusion cartesian chart widget. // Syncfusion kartesisches Diagramm-Widget.
                                  backgroundColor: Colors.transparent, // Transparent background. // Transparenter Hintergrund.
                                  plotAreaBorderColor: Colors.transparent, // Transparent border around plot area. // Transparenter Rand um Plotbereich.
                                  primaryXAxis: getXAxis(), // X-axis configuration based on time frame. // X-Achsen-Konfiguration basierend auf Zeitrahmen.
                                  primaryYAxis: const NumericAxis( // Y-axis configuration. // Y-Achsen-Konfiguration.
                                    isVisible: true, // Makes Y-axis visible. // Macht Y-Achse sichtbar.
                                    axisLine: AxisLine(width: 0), // Hides axis line. // Versteckt Achsenlinie.
                                    majorTickLines: MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
                                    minorTickLines: MinorTickLines(width: 0), // Hides minor tick lines. // Versteckt kleine Tick-Linien.
                                    labelStyle: TextStyle( // Label style. // Beschriftungsstil.
                                        color: Colors.grey, // Gray label color. // Graue Beschriftungsfarbe.
                                        fontFamily: 'San Francisco'), // San Francisco font. // San Francisco-Schriftart.
                                  ),
                                  tooltipBehavior: TooltipBehavior( // Tooltip configuration. // Tooltip-Konfiguration.
                                    enable: true, // Enables tooltips. // Aktiviert Tooltips.
                                    color: Colors.white70, // Light white tooltip background. // Hellweißer Tooltip-Hintergrund.
                                    textStyle: const TextStyle( // Tooltip text style. // Tooltip-Textstil.
                                        color: Colors.black, // Black text. // Schwarzer Text.
                                        fontFamily: 'San Francisco'), // San Francisco font. // San Francisco-Schriftart.
                                    builder: (dynamic dataPoint,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) { // Custom tooltip builder. // Benutzerdefinierter Tooltip-Builder.
                                      Duration duration =
                                          durationsData[pointIndex]; // Gets duration for this data point. // Holt Dauer für diesen Datenpunkt.
                                      String formattedDuration =
                                          formatDuration(duration); // Formats the duration. // Formatiert die Dauer.
                                      if (selectedTimeFrame == 'Monthly') { // For monthly view. // Für monatliche Ansicht.
                                        DateTime date = DateFormat('dd/MM/yyyy')
                                            .parse(data.keys
                                                .toList()
                                                .reversed
                                                .toList()[pointIndex]); // Parses date from data keys. // Analysiert Datum aus Datenschlüsseln.
                                        String formattedDate = formatDate(date); // Formats the date. // Formatiert das Datum.
                                        return Container( // Tooltip container. // Tooltip-Container.
                                          padding: const EdgeInsets.all(8), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                                          decoration: BoxDecoration( // Container decoration. // Container-Dekoration.
                                            borderRadius:
                                                BorderRadius.circular(10), // Rounded corners with 10 pixel radius. // Abgerundete Ecken mit 10 Pixel Radius.
                                            color: Colors.grey[200], // Light gray background. // Hellgrauer Hintergrund.
                                          ),
                                          child: Text( // Tooltip text. // Tooltip-Text.
                                            '$formattedDate\nTime Worked: $formattedDuration', // Date and time information. // Datums- und Zeitinformationen.
                                            style: TextStyle( // Text style. // Textstil.
                                              color: Colors.grey[800], // Dark gray text color. // Dunkelgraue Textfarbe.
                                              fontFamily: 'San Francisco', // San Francisco font. // San Francisco-Schriftart.
                                              fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                            ),
                                          ),
                                        );
                                      } else { // For other views. // Für andere Ansichten.
                                        return Container( // Tooltip container. // Tooltip-Container.
                                          padding: const EdgeInsets.all(8), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                                          decoration: BoxDecoration( // Container decoration. // Container-Dekoration.
                                            borderRadius:
                                                BorderRadius.circular(10), // Rounded corners with 10 pixel radius. // Abgerundete Ecken mit 10 Pixel Radius.
                                            color: Colors.grey[200], // Light gray background. // Hellgrauer Hintergrund.
                                          ),
                                          child: Text( // Tooltip text. // Tooltip-Text.
                                            'Time Worked: $formattedDuration', // Time information only. // Nur Zeitinformationen.
                                            style: TextStyle( // Text style. // Textstil.
                                              color: Colors.grey[800], // Dark gray text color. // Dunkelgraue Textfarbe.
                                              fontFamily: 'San Francisco', // San Francisco font. // San Francisco-Schriftart.
                                              fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  series: <CartesianSeries>[ // Chart series configuration. // Diagrammserienkonfiguration.
                                    ColumnSeries<Duration, String>( // Column series for duration data. // Spaltenserie für Dauerdaten.
                                      dataSource: durationsData, // Data source for the chart. // Datenquelle für das Diagramm.
                                      color: currentColor, // Uses color of selected project. // Verwendet Farbe des ausgewählten Projekts.
                                      borderRadius: BorderRadius.circular(5), // Rounded column corners. // Abgerundete Spaltenecken.
                                      xValueMapper:
                                          (Duration duration, int index) { // Maps X values (dates/categories). // Ordnet X-Werte zu (Daten/Kategorien).
                                        if (selectedTimeFrame == 'Yearly') { // For yearly view. // Für jährliche Ansicht.

                                          final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
                                          int month = (now.month - 11 + index); // Month number (can be negative). // Monatsnummer (kann negativ sein).
                                          int year = now.year; // Current year. // Aktuelles Jahr.

                                          if (month <= 0) { // If month is 0 or negative. // Wenn Monat 0 oder negativ ist.
                                            month += 12; // Adjust month (e.g., 0 → 12, -1 → 11). // Monat anpassen (z.B. 0 → 12, -1 → 11).
                                            year -= 1; // Go to previous year. // Zum vorherigen Jahr wechseln.
                                          }

                                          final date = DateTime(year, month, 1); // First day of month. // Erster Tag des Monats.
                                          return DateFormat('MMM').format(date); // Returns short month name. // Gibt kurzen Monatsnamen zurück.
                                        } else if (selectedTimeFrame ==
                                            'Monthly') { // For monthly view. // Für monatliche Ansicht.

                                          final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
                                          final date = DateTime(now.year,
                                              now.month, now.day - index); // Date for each day in month. // Datum für jeden Tag im Monat.
                                          return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}"; // Returns "Month Day" format. // Gibt "Monat Tag"-Format zurück.

                                        } else { // For weekly view. // Für wöchentliche Ansicht.
                                          DateTime date =
                                              DateFormat('dd/MM/yyyy')
                                                  .parse(weekDays[index + 1]); // Parses date from week days list. // Analysiert Datum aus Wochentage-Liste.
                                          return formatDate(date,
                                              useShortFormat: true); // Returns formatted date in short format. // Gibt formatiertes Datum im Kurzformat zurück.
                                        }
                                      },
                                      yValueMapper: (Duration duration, _) =>
                                          duration.inSeconds / 3600.0, // Converts duration to hours for Y-axis. // Konvertiert Dauer in Stunden für Y-Achse.
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(flex: 9, child: GitHubChart()), // GitHub-style contribution chart at bottom. // GitHub-Stil-Beitragsdiagramm unten.
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
          );
        }),
      ),
    );
  }
}
