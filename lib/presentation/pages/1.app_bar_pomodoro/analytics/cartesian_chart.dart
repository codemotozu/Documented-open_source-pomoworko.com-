/// CartesianChart
/// 
/// A data visualization widget for displaying Pomodoro timer analytics. // Ein Datenvisualisierungs-Widget zur Anzeige von Pomodoro-Timer-Analysen.
/// Shows user's time tracking data in different formats (weekly, monthly, yearly) with project management capabilities. // Zeigt Zeiterfassungsdaten des Benutzers in verschiedenen Formaten (wöchentlich, monatlich, jährlich) mit Projektmanagement-Funktionen an.
/// 
/// Usage:
/// ```dart
/// CartesianChart(
///   title: 'Time Tracking Analytics',
/// )
/// ```
/// 
/// EN: Displays a comprehensive analytics dashboard with charts, project selection, and time tracking statistics.
/// DE: Zeigt ein umfassendes Analyse-Dashboard mit Diagrammen, Projektauswahl und Zeiterfassungsstatistiken an.

import 'package:flutter/cupertino.dart'; // Imports iOS-style widgets from Flutter. // Importiert iOS-Stil Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.
import 'package:intl/intl.dart'; // Imports internationalization support for date formatting. // Importiert Internationalisierungsunterstützung für die Datumsformatierung.
import 'package:syncfusion_flutter_charts/charts.dart'; // Imports Syncfusion chart widgets. // Importiert Syncfusion-Diagramm-Widgets.
import '../../../../common/utils/responsive_show_dialogs.dart'; // Imports utility for responsive dialogs. // Importiert Hilfsprogramm für responsive Dialoge.
import '../../../../common/utils/responsive_web.dart'; // Imports utility for responsive web design. // Importiert Hilfsprogramm für responsives Webdesign.
import '../../../../infrastructure/data_sources/hive_services.dart'; // Imports local storage services using Hive. // Importiert lokale Speicherdienste mit Hive.
import '../../../notifiers/persistent_container_notifier.dart'; // Imports state notifier for persistent container selection. // Importiert State-Notifier für die persistente Container-Auswahl.
import '../../../notifiers/project_state_notifier.dart'; // Imports state notifier for project management. // Importiert State-Notifier für Projektverwaltung.
import '../../../notifiers/project_time_notifier.dart'; // Imports state notifier for project time tracking. // Importiert State-Notifier für Projektzeit-Tracking.
import '../../../notifiers/providers.dart'; // Imports Riverpod providers. // Importiert Riverpod-Provider.
import '../../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.
import '../../../widgets/bar_chart_project.dart'; // Imports custom bar chart widget for projects. // Importiert benutzerdefiniertes Balkendiagramm-Widget für Projekte.
import '../../0.appbar_features/2_app_bar_icons/profile/go_premium.dart'; // Imports premium feature promotion widget. // Importiert Premium-Funktions-Werbe-Widget.
import '../../0.appbar_features/2_app_bar_icons/profile/ready_soon_features.dart'; // Imports widget for upcoming features notification. // Importiert Widget für bevorstehende Funktionsbenachrichtigung.
import 'github_chart.dart'; // Imports GitHub-style contribution chart. // Importiert GitHub-Stil-Beitragsdiagramm.
import 'time_frame_pop_up_menu_button.dart'; // Imports custom popup menu for time frame selection. // Importiert benutzerdefiniertes Popup-Menü für die Zeitrahmenauswahl.

class CartesianChart extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod integration. // Definiert ein zustandsbehaftetes Widget mit Riverpod-Integration.
  final String title; // Title property for the chart. // Titel-Eigenschaft für das Diagramm.
  const CartesianChart({super.key, required this.title}); // Constructor requiring a title parameter. // Konstruktor, der einen Titel-Parameter erfordert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartesianChartState(); // Creates the mutable state for this widget. // Erstellt den veränderbaren Zustand für dieses Widget.
}

class _CartesianChartState extends ConsumerState<CartesianChart> { // Defines the state class for CartesianChart. // Definiert die Zustandsklasse für CartesianChart.
  int _hoveredIndex = -1; // Tracks which project item is being hovered over. // Verfolgt, über welches Projektelement der Mauszeiger schwebt.

  late TooltipBehavior _tooltipBehavior; // Configures tooltip behavior for the chart. // Konfiguriert das Tooltip-Verhalten für das Diagramm.
  String selectedTimeFrame = 'Weekly'; // Default selected time frame. // Standard ausgewählter Zeitrahmen.
  List<String> timeFrames = [ // Available time frame options. // Verfügbare Zeitrahmen-Optionen.
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  @override
  void initState() { // Initializes the widget state. // Initialisiert den Widget-Zustand.
    super.initState(); // Calls parent class initializer. // Ruft den Initialisierer der Elternklasse auf.
    _tooltipBehavior = TooltipBehavior(enable: true); // Enables tooltips on the chart. // Aktiviert Tooltips auf dem Diagramm.
  }

  String formatDuration(Duration duration) { // Formats duration into hours:minutes:seconds. // Formatiert die Dauer in Stunden:Minuten:Sekunden.
    String twoDigits(int n) => n.toString().padLeft(2, "0"); // Helper function to ensure two digits with leading zero. // Hilfsfunktion, um zwei Stellen mit führender Null sicherzustellen.
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60)); // Gets minutes part with two digits. // Holt den Minutenteil mit zwei Ziffern.
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60)); // Gets seconds part with two digits. // Holt den Sekundenteil mit zwei Ziffern.
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"; // Returns formatted duration string. // Gibt formatierte Dauer-Zeichenfolge zurück.
  }

  String formatDate(DateTime date, {bool useShortFormat = false}) { // Formats date for display in charts. // Formatiert Datum zur Anzeige in Diagrammen.
    String dayOfWeek = useShortFormat
        ? DateFormat('E').format(date) // Short day name (e.g., Mon). // Kurzer Tagesname (z.B. Mo).
        : DateFormat('EEEE').format(date); // Full day name (e.g., Monday). // Vollständiger Tagesname (z.B. Montag).
    String dayOfMonth = DateFormat('d').format(date); // Day of month (1-31). // Tag des Monats (1-31).
    String month = useShortFormat
        ? DateFormat('MMM').format(date) // Short month name (e.g., Jan). // Kurzer Monatsname (z.B. Jan).
        : DateFormat('MMMM').format(date); // Full month name (e.g., January). // Vollständiger Monatsname (z.B. Januar).
    return "$dayOfWeek \n$month $dayOfMonth"; // Returns formatted date string. // Gibt formatierte Datums-Zeichenfolge zurück.
  }

  List<String> generateWeekDays() { // Generates a list of dates for the past week. // Generiert eine Liste von Daten für die vergangene Woche.
    List<String> weekDays = []; // Empty list for week days. // Leere Liste für Wochentage.
    DateTime now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
    for (int i = -1; i <= 7; i++) { // Generates 9 days. // Generiert 9 Tage.
      String day = DateFormat('dd/MM/yyyy').format( // Formats each date as day/month/year. // Formatiert jedes Datum als Tag/Monat/Jahr.
        now.subtract(
          Duration(days: i), // Subtracts i days from now. // Subtrahiert i Tage von jetzt.
        ),
      );
      weekDays.add(day); // Adds formatted date to the list. // Fügt formatiertes Datum zur Liste hinzu.
    }
    return weekDays; // Returns the list of week days. // Gibt die Liste der Wochentage zurück.
  }

  List<String> generateMonthDays() { // Generates a list of dates for the current month. // Generiert eine Liste von Daten für den aktuellen Monat.
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

  List<String> generateYearMonths() { // Generates a list of month names for the year. // Generiert eine Liste von Monatsnamen für das Jahr.
    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.
    List<String> months = List.generate( // Generates list of all 12 months. // Generiert Liste aller 12 Monate.
      12,
      (index) => DateFormat('MMM').format( // Short month name format (Jan, Feb, etc.). // Kurzes Monatsformat (Jan, Feb, usw.).
        DateTime(now.year, index + 1), // Creates date for each month. // Erstellt Datum für jeden Monat.
      ),
    );
    return [...months.sublist(now.month), ...months.sublist(0, now.month)]; // Reorders list starting with current month. // Ordnet Liste neu, beginnend mit aktuellem Monat.
  }

  Duration calculateTotalDuration(List<Duration> weekData) { // Calculates total duration from a list of durations. // Berechnet die Gesamtdauer aus einer Liste von Dauern.
    return weekData.fold(Duration.zero, (prev, curr) => prev + curr); // Sums all durations in the list. // Summiert alle Dauern in der Liste.
  }

  List<String> generateYearMonthsGithubStyle() { // Generates month labels in GitHub contribution style. // Generiert Monatsbeschriftungen im GitHub-Contributions-Stil.
    final now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.

    List<String> months = List.generate(13, (index) { // Generates 13 months (full year + overlap). // Generiert 13 Monate (volles Jahr + Überlappung).
      int year = now.year; // Current year. // Aktuelles Jahr.
      int month = (now.month - 1 + index) % 12 + 1; // Month number with wraparound. // Monatsnummer mit Umbruch.

      if (month > now.month) year--; // Adjusts year for previous months. // Passt Jahr für vorherige Monate an.

      return DateFormat('MMM').format(DateTime(year, month)); // Returns short month name. // Gibt kurzen Monatsnamen zurück.
    });

    return months; // Returns the list of month names. // Gibt die Liste der Monatsnamen zurück.
  }

  CategoryAxis getXAxis() { // Creates appropriate X-axis based on selected time frame. // Erstellt passende X-Achse basierend auf dem ausgewählten Zeitrahmen.
    if (selectedTimeFrame == 'Weekly') { // For weekly view. // Für wöchentliche Ansicht.
      return const CategoryAxis( // Returns configured category axis for weekly view. // Gibt konfigurierte Kategorieachse für wöchentliche Ansicht zurück.
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
      List<String> monthDays = generateMonthDays(); // Gets list of days in the month. // Holt Liste der Tage im Monat.
      return CategoryAxis( // Returns configured category axis for monthly view. // Gibt konfigurierte Kategorieachse für monatliche Ansicht zurück.
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
    } else if (selectedTimeFrame == 'Github yearly chart') { // For GitHub-style yearly view. // Für GitHub-Stil jährliche Ansicht.
      return const CategoryAxis( // Returns configured category axis for GitHub yearly view. // Gibt konfigurierte Kategorieachse für GitHub-Jahresansicht zurück.
        interval: 1, // Shows label for each month. // Zeigt Beschriftung für jeden Monat.
        minimum: -0.5, // Sets minimum value for axis range. // Legt Mindestwert für Achsenbereich fest.
        maximum: 11.5, // Sets maximum for 12 months (0-11). // Legt Maximum für 12 Monate fest (0-11).
        labelPlacement: LabelPlacement.onTicks, // Places labels on tick marks. // Platziert Beschriftungen auf Tick-Marken.
        labelIntersectAction: AxisLabelIntersectAction.multipleRows, // Handles overlapping labels. // Behandelt überlappende Beschriftungen.
        axisLine: AxisLine(width: 0), // Hides axis line. // Versteckt die Achsenlinie.
        majorTickLines: MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
        rangePadding: ChartRangePadding.round, // Rounds axis range to nice values. // Rundet Achsenbereich auf schöne Werte.
      );
    } else { // For yearly view. // Für jährliche Ansicht.
      return const CategoryAxis( // Returns configured category axis for yearly view. // Gibt konfigurierte Kategorieachse für jährliche Ansicht zurück.
        interval: 1, // Shows label for each month. // Zeigt Beschriftung für jeden Monat.
        minimum: -0.5, // Sets minimum value for axis range. // Legt Mindestwert für Achsenbereich fest.
        maximum: 11.5, // Sets maximum for 12 months (0-11). // Legt Maximum für 12 Monate fest (0-11).
        labelPlacement: LabelPlacement.onTicks, // Places labels on tick marks. // Platziert Beschriftungen auf Tick-Marken.
        labelIntersectAction: AxisLabelIntersectAction.multipleRows, // Handles overlapping labels. // Behandelt überlappende Beschriftungen.
        axisLine: AxisLine(width: 0), // Hides axis line. // Versteckt die Achsenlinie.
        majorTickLines: MajorTickLines(width: 0), // Hides major tick lines. // Versteckt große Tick-Linien.
        rangePadding: ChartRangePadding.round, // Rounds axis range to nice values. // Rundet Achsenbereich auf schöne Werte.
      );
    }
  }

  void _showPremiumDialog(BuildContext context) { // Shows dialog for premium features. // Zeigt Dialog für Premium-Funktionen.
    showDialog( // Shows a dialog. // Zeigt einen Dialog.
      context: context, // Current build context. // Aktueller Build-Kontext.
      builder: (BuildContext context) { // Builder for dialog content. // Builder für Dialog-Inhalt.
        return CupertinoAlertDialog( // iOS-style alert dialog. // iOS-Stil-Alarm-Dialog.
          title: const Text('Premium Feature'), // Dialog title. // Dialog-Titel.
          content: const Text(
              'This feature is only available for premium users. Would you like to upgrade?'), // Dialog message. // Dialog-Nachricht.
          actions: [ // Dialog buttons. // Dialog-Schaltflächen.
            CupertinoDialogAction( // Cancel button. // Abbrechen-Schaltfläche.
              child: const Text('Cancel'), // Button text. // Schaltflächentext.
              onPressed: () { // Action when pressed. // Aktion bei Betätigung.
                Navigator.of(context).pop(); // Closes the dialog. // Schließt den Dialog.
              },
            ),
            CupertinoDialogAction( // Upgrade button. // Upgrade-Schaltfläche.
              child: const Text('Upgrade'), // Button text. // Schaltflächentext.
              onPressed: () { // Action when pressed. // Aktion bei Betätigung.
                Navigator.of(context).pop(); // Closes the dialog. // Schließt den Dialog.
              },
            ),
          ],
        );
      },
    );
  }

  bool isPremium = false; // User premium status flag. // Benutzer-Premium-Status-Flag.
  DateTime now = DateTime.now(); // Current date and time. // Aktuelles Datum und Uhrzeit.

  bool isSelected = false; // Selection state flag. // Auswahlzustand-Flag.


  void _showAddDialog( // Shows dialog to add a new project. // Zeigt Dialog zum Hinzufügen eines neuen Projekts.
      BuildContext context, String title, String placeholder, int index) { 
    String projectTitle = ''; // Stores new project title input. // Speichert neue Projekttitel-Eingabe.
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.

    showDialog( // Shows a dialog. // Zeigt einen Dialog.
      context: context, // Current build context. // Aktueller Build-Kontext.
      builder: (BuildContext context) { // Builder for dialog content. // Builder für Dialog-Inhalt.
        return CupertinoAlertDialog( // iOS-style alert dialog. // iOS-Stil-Alarm-Dialog.
          title: Text(title), // Dialog title from parameter. // Dialog-Titel aus Parameter.
          content: Column( // Dialog content arranged vertically. // Dialog-Inhalt vertikal angeordnet.
            mainAxisSize: MainAxisSize.min, // Minimizes column height. // Minimiert Spaltenhöhe.
            children: [
              Text(placeholder), // Instruction text. // Anweisungstext.
              const SizedBox(height: 16), // Vertical spacing. // Vertikaler Abstand.
              CupertinoTextField( // iOS-style text input field. // iOS-Stil-Texteingabefeld.
                placeholder: 'Project name', // Hint text. // Hinweistext.
                style: const TextStyle(color: Colors.white), // Text style. // Textstil.
                onChanged: (value) { // Called when text changes. // Wird aufgerufen, wenn sich der Text ändert.
                  projectTitle = value; // Updates project title variable. // Aktualisiert Projekttitel-Variable.
                },
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction( // OK button. // OK-Schaltfläche.
              child: const Text('OK'), // Button text. // Schaltflächentext.
              onPressed: () async { // Action when pressed. // Aktion bei Betätigung.
                if (projectTitle.isNotEmpty) { // Checks if title is not empty. // Prüft, ob der Titel nicht leer ist.
                  ref
                      .read(persistentContainerIndexProvider.notifier)
                      .updateIndex(index); // Updates selected container index. // Aktualisiert ausgewählten Container-Index.
                  ref
                      .read(localStorageRepositoryProvider)
                      .setSelectedContainerIndex(index); // Saves index to local storage. // Speichert Index im lokalen Speicher.
                  ref
                      .read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, index, ref); // Adds new project to state. // Fügt neues Projekt zum Zustand hinzu.
                  ref
                      .read(projectTimesProvider.notifier)
                      .addTime(index, DateTime.now(), Duration.zero); // Initializes time tracking for new project. // Initialisiert Zeiterfassung für neues Projekt.
                }
                Navigator.pop(context); // Closes the dialog. // Schließt den Dialog.
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    bool isEditIconVisible = false; // Flag for edit icon visibility. // Flag für Edit-Symbol-Sichtbarkeit.
    final currentProjectProvider = StateProvider<String?>((ref) => null); // Provider for current project name. // Provider für aktuellen Projektnamen.
    final textTheme = Theme.of(context).textTheme; // Gets current text theme. // Holt aktuelles Textthema.
    final focusedTaskTitle = ref.watch(focusedTaskTitleProvider); // Gets currently focused task title. // Holt aktuell fokussierten Aufgabentitel.
    final projectNames = ref.watch(projectStateNotifierProvider); // Gets list of project names. // Holt Liste der Projektnamen.

    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.

    int currentIndex = selectedContainerIndex; // Current index for project selection. // Aktueller Index für Projektauswahl.
    if (currentIndex >= projectNames.length) { // Ensures index is valid. // Stellt sicher, dass der Index gültig ist.
      currentIndex = projectNames.length - 1; // Sets to last valid index. // Setzt auf letzten gültigen Index.
    }

    final List<Color> projectColors = [ // List of colors for projects. // Liste von Farben für Projekte.
      const Color(0xffF04442), // Red. // Rot.
      const Color(0xffF4A338), // Orange. // Orange.
      const Color(0xFFF8CD34), // Yellow. // Gelb.
      const Color(0xff4FCE5D), // Green. // Grün.
      const Color(0xff4584DB), // Blue. // Blau.
      const Color(0xffAE73D1), // Purple. // Lila.
      const Color(0xffEA73AD), // Pink. // Rosa.
      const Color(0xff9B9A9E), // Gray. // Grau.
    ];

    final projectTimes = ref.watch(projectTimesProvider); // Gets project time tracking data. // Holt Projektzeiterfassungsdaten.
    final currentProjectName =
        projectNames.isNotEmpty ? projectNames[currentIndex] : 'Add a project'; // Gets current project name or default. // Holt aktuellen Projektnamen oder Standard.
    final currentProjectTimesMap = projectTimes[currentProjectName] ?? {}; // Gets time map for current project. // Holt Zeitübersicht für aktuelles Projekt.

    Duration getTotalDuration(Map<DateTime, Duration> timesMap) { // Calculates total duration from a map of dates to durations. // Berechnet Gesamtdauer aus einer Zuordnung von Datumsangaben zu Dauern.
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
      child: Scaffold( // Material Design layout scaffold. // Material Design Layout-Gerüst.
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
              ).fontFamily,
              color: const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
            ),
          ),
          centerTitle: true, // Centers the title. // Zentriert den Titel.
        ),
        body: Consumer(builder: (context, ref, child) { // Consumer to access Riverpod state. // Consumer für Zugriff auf Riverpod-Zustand.
          final user = ref.watch(userProvider.notifier).state; // Gets current user. // Holt aktuellen Benutzer.
          final projectNames = ref.watch(projectStateNotifierProvider); // Gets project names. // Holt Projektnamen.
          final selectedContainerIndex =
              ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.

          return FutureBuilder<Map<String, Duration>>( // Builds UI based on async data. // Erstellt UI basierend auf asynchronen Daten.
            future: futureData, // Future to wait for. // Future, auf das gewartet wird.
            builder: (context, snapshot) { // Builder function. // Builder-Funktion.
              if (snapshot.connectionState == ConnectionState.done) { // If data loading is complete. // Wenn Datenladen abgeschlossen ist.
                if (snapshot.hasData) { // If data was successfully loaded. // Wenn Daten erfolgreich geladen wurden.
                  final data = snapshot.data!; // Gets the loaded data. // Holt die geladenen Daten.
                  final projectTimesNotifier =
                      ref.read(projectTimesProvider.notifier); // Gets project times notifier. // Holt Projektzeit-Notifier.

                  var mutableProjectNames = List<String>.from(projectNames); // Creates mutable copy of project names. // Erstellt veränderbare Kopie der Projektnamen.
                  var mutableCurrentIndex = currentIndex; // Mutable copy of current index. // Veränderbare Kopie des aktuellen Index.

                  if (mutableProjectNames.isEmpty) { // If no projects exist. // Wenn keine Projekte existieren.
                    mutableProjectNames = ['Add a project']; // Sets default project name. // Setzt Standard-Projektnamen.
                    mutableCurrentIndex = 0; // Sets index to 0. // Setzt Index auf 0.
                  }

                  mutableCurrentIndex = mutableCurrentIndex.clamp(
                      0, mutableProjectNames.length - 1); // Ensures index is within valid range. // Stellt sicher, dass der Index innerhalb des gültigen Bereichs liegt.
                  final currentProjectName =
                      mutableProjectNames[mutableCurrentIndex]; // Gets current project name. // Holt aktuellen Projektnamen.

                  final selectedContainerIndex =
                      ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.

                  final currentColor = projectColors[
                      selectedContainerIndex % projectColors.length]; // Gets color for selected container. // Holt Farbe für ausgewählten Container.

                  List<Duration> durationsData = []; // List to store duration data. // Liste zum Speichern von Dauerdaten.
                  if (selectedTimeFrame == 'Weekly') { // For weekly view. // Für wöchentliche Ansicht.
                    durationsData = weekDays.skip(1).take(7).map((day) { // Maps 7 days to their durations. // Ordnet 7 Tage ihren Dauern zu.
                      final date = DateFormat('dd/MM/yyyy').parse(day); // Parses date string. // Analysiert Datumszeichenfolge.
                      return ref
                          .read(projectTimesProvider.notifier)
                          .getProjectTime(selectedContainerIndex, date); // Gets time for project on that date. // Holt Zeit für Projekt an diesem Datum.
                    }).toList();
                  } else if (selectedTimeFrame == 'Monthly') { // For monthly view. // Für monatliche Ansicht.
                    durationsData = data.values.toList().reversed.toList(); // Reverses the monthly data. // Kehrt die monatlichen Daten um.
                  } else if (selectedTimeFrame == 'Yearly') { // For yearly view. // Für jährliche Ansicht.
                    durationsData = data.values.toList(); // Uses yearly data. // Verwendet jährliche Daten.

                    Duration totalDuration =
                        calculateTotalDuration(durationsData); // Calculates total duration. // Berechnet Gesamtdauer.

                    String formattedTotalDuration =
                        formatDuration(totalDuration); // Formats the total duration. // Formatiert die Gesamtdauer.

                    return const Column(
                      children: [], // Empty column for yearly view. // Leere Spalte für jährliche Ansicht.
                    );
                  }

                  Duration totalDuration =
                      calculateTotalDuration(durationsData); // Calculates total duration from data. // Berechnet Gesamtdauer aus Daten.
                  String formattedTotalDuration = formatDuration(totalDuration); // Formats the total duration. // Formatiert die Gesamtdauer.
                  return Column(children: [ // Main layout column. // Haupt-Layout-Spalte.
                    Row( // Row for time frame selection and delete button. // Zeile für Zeitrahmenauswahl und Lösch-Schaltfläche.
                      mainAxisAlignment: MainAxisAlignment.center, // Centers row content horizontally. // Zentriert Zeileninhalt horizontal.
                      children: [
                        Flexible( // Flexible wrapper for time frame selector. // Flexibler Wrapper für Zeitrahmenwähler.
                          flex: 4, // Flex ratio. // Flex-Verhältnis.
                          child: Padding( // Padding container. // Abstand-Container.
                            padding: const EdgeInsets.all(8.0), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                            child: TimeFramePopupMenuButton( // Custom dropdown for time frames. // Benutzerdefiniertes Dropdown für Zeitrahmen.
                              timeFrames: timeFrames, // Available time frame options. // Verfügbare Zeitrahmen-Optionen.
                              currentTimeFrame: selectedTimeFrame, // Currently selected time frame. // Aktuell ausgewählter Zeitrahmen.
                              isPremium: isPremium, // User premium status. // Benutzer-Premium-Status.

                              onTimeFrameSelected: (newValue) { // Callback when time frame is selected. // Callback wenn Zeitrahmen ausgewählt wird.
                                if (newValue != selectedTimeFrame &&
                                    isPremium == true) { // If selection changed and user is premium. // Wenn Auswahl geändert und Benutzer Premium ist.
                                  setState(() { // Updates state. // Aktualisiert Zustand.
                                    selectedTimeFrame = newValue; // Updates selected time frame. // Aktualisiert ausgewählten Zeitrahmen.
                                  });
                                }

                                if (newValue != selectedTimeFrame &&
                                    isPremium == false) { // If selection changed and user is not premium. // Wenn Auswahl geändert und Benutzer nicht Premium ist.
                                  if ((newValue == 'Monthly' ||
                                          newValue == 'Yearly') &&
                                      !isPremium) { // If trying to select premium-only time frame. // Wenn versucht wird, nur Premium-Zeitrahmen auszuwählen.
                             
                                    showCupertinoDialog( // Shows premium feature dialog. // Zeigt Premium-Funktionsdialog.
                                      barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                      context: context, // Current context. // Aktueller Kontext.
                                      builder: (BuildContext context) { // Dialog builder. // Dialog-Builder.
                                        return SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                          backgroundColor:
                                              const Color.fromARGB(0, 255, 251, 254), // Transparent background. // Transparenter Hintergrund.
                                          children: [
                                            SizedBox( // Fixed size container. // Container mit fester Größe.
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4, // 40% of screen width. // 40% der Bildschirmbreite.
                                              child: const PremiumReadySoon(), // Premium feature coming soon message. // Premium-Funktion kommt bald-Nachricht.
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else { // If selecting non-premium time frame. // Wenn nicht-Premium-Zeitrahmen ausgewählt wird.
                                    setState(() { // Updates state. // Aktualisiert Zustand.
                                      selectedTimeFrame = newValue; // Updates selected time frame. // Aktualisiert ausgewählten Zeitrahmen.
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        ElevatedButton( // Delete project button. // Projekt löschen-Schaltfläche.
                          onPressed: () { // Button press handler. // Schaltflächen-Druck-Handler.
                            showDialog( // Shows confirmation dialog. // Zeigt Bestätigungsdialog.
                              context: context, // Current context. // Aktueller Kontext.
                              builder: (context) => CupertinoAlertDialog( // iOS-style alert dialog. // iOS-Stil-Alarm-Dialog.
                                title: const Text('Delete Project'), // Dialog title. // Dialog-Titel.
                                content: const Text(
                                    'Are you sure you want to delete this project? This action cannot be undone.'), // Warning message. // Warnmeldung.
                                actions: [
                                  CupertinoDialogAction( // Cancel button. // Abbrechen-Schaltfläche.
                                    child: const Text('Cancel'), // Button text. // Schaltflächentext.
                                    onPressed: () { // Action when pressed. // Aktion bei Betätigung.
                                      Navigator.of(context).pop(); // Closes dialog. // Schließt Dialog.
                                    },
                                  ),
                                  CupertinoDialogAction( // Delete button. // Löschen-Schaltfläche.
                                    isDestructiveAction: true, // Marks as destructive action (red text). // Kennzeichnet als destruktive Aktion (roter Text).
                                    child: const Text('Delete'), // Button text. // Schaltflächentext.
                                    onPressed: () async { // Action when pressed. // Aktion bei Betätigung.
                                      try {
                                        final result = await ref
                                            .read(authRepositoryProvider)
                                            .deleteProject(
                                                selectedContainerIndex); // Deletes project on server. // Löscht Projekt auf Server.

                                        if (result.error == null) { // If no error occurred. // Wenn kein Fehler aufgetreten ist.
                                          ref
                                              .read(projectStateNotifierProvider
                                                  .notifier)
                                              .deleteProject(
                                                  selectedContainerIndex); // Deletes project from state. // Löscht Projekt aus dem Zustand.
                                          ref
                                              .read(
                                                  projectTimesProvider.notifier)
                                              .clearProjectData(
                                                  selectedContainerIndex); // Clears project time data. // Löscht Projektzeit-Daten.
                                        } else { // If error occurred. // Wenn Fehler aufgetreten ist.
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
                                borderRadius: BorderRadius.circular(10), // Rounded corners. // Abgerundete Ecken.
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
                      child: Padding( // Padding container. // Abstand-Container.
                        padding: const EdgeInsets.all(8.0), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                        child: Consumer( // Consumer for Riverpod state. // Consumer für Riverpod-Zustand.
                          builder: (context, ref, child) { // Builder function. // Builder-Funktion.
                            final selectedContainerIndex =
                                ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.

                            final projectNames =
                                ref.watch(projectStateNotifierProvider); // Gets project names. // Holt Projektnamen.

                            final currentProjectName = projectNames.isEmpty
                                ? 'Add a project'
                                : projectNames[selectedContainerIndex.clamp(
                                    0, projectNames.length - 1)]; // Gets current project name. // Holt aktuellen Projektnamen.

                            final totalProjectTime = ref
                                .read(projectTimesProvider.notifier)
                                .getTotalProjectTime(selectedContainerIndex); // Gets total time for project. // Holt Gesamtzeit für Projekt.

                            return Text( // Text showing project info. // Text, der Projektinfo anzeigt.
                              'Project: $currentProjectName, Total Hours Worked: ${formatDuration(totalProjectTime)}', // Project name and total time. // Projektname und Gesamtzeit.
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
                            child: Padding( // Padding container. // Abstand-Container.
                              padding: const EdgeInsets.only(left: 30.0), // Left padding. // Linker Abstand.
                              child: Column( // Column for project list. // Spalte für Projektliste.
                                crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left. // Richtet Kinder links aus.
                                mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the top. // Richtet Kinder oben aus.
                                children: List.generate( // Generates a list of project items. // Generiert eine Liste von Projektelementen.
                                  projectColors.length, // Number of projects to show. // Anzahl der anzuzeigenden Projekte.
                                  (index) { // Builder for each project item. // Builder für jedes Projektelement.
                                    bool isPremiumContainer = index >= 4; // Determines if this is a premium container. // Bestimmt, ob dies ein Premium-Container ist.

                                    bool isUserPremium =
                                        user?.isPremium ?? false; // Checks if user has premium. // Prüft, ob Benutzer Premium hat.
                                    bool isLocked =
                                        isPremiumContainer && !isUserPremium; // Determines if container is locked. // Bestimmt, ob Container gesperrt ist.

                                    return Padding( // Padding for project item. // Abstand für Projektelement.
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0), // Horizontal and vertical padding. // Horizontaler und vertikaler Abstand.
                                    
                                        child: GestureDetector( // Touch detector for project item. // Berührungsdetektor für Projektelement.
                                        onTap: () { // Action when tapped. // Aktion bei Berührung.
                                          bool isPremiumContainer = index >= 4; // Checks if premium container. // Prüft, ob Premium-Container.
                                          bool isUserPremium =
                                              user?.isPremium ?? false; // Checks if user has premium. // Prüft, ob Benutzer Premium hat.

                                          if (isPremiumContainer &&
                                              !isUserPremium) { // If trying to access locked container. // Wenn versucht wird, auf gesperrten Container zuzugreifen.
                                            showDialog( // Shows premium feature dialog. // Zeigt Premium-Funktionsdialog.
                                              context: context, // Current context. // Aktueller Kontext.
                                              builder: (BuildContext context) { // Dialog builder. // Dialog-Builder.
                                                return ResponsiveShowDialogs( // Responsive dialog wrapper. // Responsiver Dialog-Wrapper.
                                                  child: SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            0, 0, 0, 0), // Transparent background. // Transparenter Hintergrund.
                                                    children: [
                                                      SizedBox( // Fixed size container. // Container mit fester Größe.
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4, // 40% of screen width. // 40% der Bildschirmbreite.
                                                        child:
                                                            const PremiumReadySoon(), // Premium feature coming soon message. // Premium-Funktion kommt bald-Nachricht.
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                            return; // Exits the function. // Beendet die Funktion.
                                          }

                                          if (!isPremiumContainer ||
                                              isUserPremium) { // If container is accessible. // Wenn Container zugänglich ist.
                                            setState(() => _hoveredIndex = -1); // Resets hover state. // Setzt Hover-Zustand zurück.
                                            ref
                                                .read(
                                                    persistentContainerIndexProvider
                                                        .notifier)
                                                .updateIndex(index); // Updates selected container index. // Aktualisiert ausgewählten Container-Index.
                                            ref
                                                .read(
                                                    localStorageRepositoryProvider)
                                                .setSelectedContainerIndex(
                                                    index); // Saves index to local storage. // Speichert Index im lokalen Speicher.

                                            if (projectNames.length <= index) { // If project doesn't exist yet. // Wenn Projekt noch nicht existiert.
                                              _showAddDialog(
                                                  context,
                                                  'Add a Project',
                                                  'Please, add a name for the project',
                                                  index); // Shows dialog to add new project. // Zeigt Dialog zum Hinzufügen eines neuen Projekts.
                                            }
                                          }
                                        },
                                        child: BarChartProject( // Project bar chart item. // Projekt-Balkendiagramm-Element.
                                          projectColors[index], // Color for this project. // Farbe für dieses Projekt.
                                          index: index, // Project index. // Projektindex.
                                          isEditIconVisible:
                                              _hoveredIndex == index &&
                                                  !isLocked, // Shows edit icon only when hovering and not locked. // Zeigt Bearbeitungssymbol nur beim Darüberfahren und wenn nicht gesperrt.
                                          icon: isLocked
                                              ? const Icon(CupertinoIcons.lock,
                                                  color: Colors.white, size: 16) // Lock icon for premium containers. // Schloss-Symbol für Premium-Container.
                                              : null,
                                          isPremiumLocked: isLocked, // Premium lock status. // Premium-Sperrstatus.
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible( // Flexible container for the main chart. // Flexibler Container für das Hauptdiagramm.
                            flex: 46, // Flex ratio (much wider than project list). // Flex-Verhältnis (viel breiter als Projektliste).
                            child: Padding( // Padding container. // Abstand-Container.
                              padding: const EdgeInsets.all(4.0), // 4 pixel padding all around. // 4 Pixel Abstand rundum.
                              child: Consumer(builder: (context, ref, child) { // Consumer for Riverpod state. // Consumer für Riverpod-Zustand.
                                final selectedContainerIndex =
                                    ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.
                                final isUserPremium =
                                    ref.watch(userProvider)?.isPremium ?? false; // Checks if user has premium. // Prüft, ob Benutzer Premium hat.
                                final isPremiumContainer =
                                    selectedContainerIndex >= 4; // Determines if selected container is premium. // Bestimmt, ob ausgewählter Container Premium ist.

                                if (isPremiumContainer && !isUserPremium) { // If trying to access premium container without premium. // Wenn versucht wird, auf Premium-Container ohne Premium zuzugreifen.
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) { // Schedules callback after frame is built. // Plant Callback nach dem Frame-Aufbau ein.
                                    ref
                                        .read(persistentContainerIndexProvider
                                            .notifier)
                                        .updateIndex(3); // Resets to last free container. // Setzt auf letzten freien Container zurück.
                                    ref
                                        .read(localStorageRepositoryProvider)
                                        .setSelectedContainerIndex(3); // Saves index to local storage. // Speichert Index im lokalen Speicher.
                                  });

                                  return ResponsiveShowDialogs( // Responsive dialog wrapper. // Responsiver Dialog-Wrapper.
                                    child: SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                      backgroundColor:
                                          const Color.fromARGB(0, 0, 0, 0), // Transparent background. // Transparenter Hintergrund.
                                      children: [
                                        SizedBox( // Fixed size container. // Container mit fester Größe.
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4, // 40% of screen width. // 40% der Bildschirmbreite.
                                          child: const PremiumReadySoon(), // Premium feature coming soon message. // Premium-Funktion kommt bald-Nachricht.
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return SfCartesianChart( // Syncfusion cartesian chart. // Syncfusion Kartesisches Diagramm.
                                  backgroundColor: Colors.transparent, // Transparent background. // Transparenter Hintergrund.
                                  plotAreaBorderColor: Colors.transparent, // Transparent border around plot area. // Transparenter Rand um Plotbereich.
                                  primaryXAxis: getXAxis(), // X-axis configuration. // X-Achsen-Konfiguration.
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
                                                .toList()[pointIndex]); // Parses date for this data point. // Analysiert Datum für diesen Datenpunkt.
                                        String formattedDate = formatDate(date); // Formats the date. // Formatiert das Datum.
                                        return Container( // Tooltip container. // Tooltip-Container.
                                          padding: const EdgeInsets.all(8), // 8 pixel padding all around. // 8 Pixel Abstand rundum.
                                          decoration: BoxDecoration( // Container decoration. // Container-Dekoration.
                                            borderRadius:
                                                BorderRadius.circular(10), // Rounded corners. // Abgerundete Ecken.
                                            color: Colors.grey[200], // Light gray background. // Hellgrauer Hintergrund.
                                          ),
                                          child: Text( // Tooltip text. // Tooltip-Text.
                                            '$formattedDate\nTime Worked: $formattedDuration', // Date and duration. // Datum und Dauer.
                                            style: TextStyle( // Text style. // Textstil.
                                              color: Colors.grey[800], // Dark gray text. // Dunkelgrauer Text.
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
                                                BorderRadius.circular(10), // Rounded corners. // Abgerundete Ecken.
                                            color: Colors.grey[200], // Light gray background. // Hellgrauer Hintergrund.
                                          ),
                                          child: Text( // Tooltip text. // Tooltip-Text.
                                            'Time Worked: $formattedDuration', // Duration only. // Nur Dauer.
                                            style: TextStyle( // Text style. // Textstil.
                                              color: Colors.grey[800], // Dark gray text. // Dunkelgrauer Text.
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
                                      dataSource: durationsData, // Duration data source. // Datenquelle für Dauer.
                                      color: currentColor, // Current project color. // Aktuelle Projektfarbe.
                                      borderRadius: BorderRadius.circular(5), // Rounded column corners. // Abgerundete Spaltenecken.
                                      xValueMapper:
                                          (Duration duration, int index) { // Maps X values for chart. // Ordnet X-Werte für Diagramm zu.
                                        if (selectedTimeFrame == 'Yearly') { // For yearly view. // Für jährliche Ansicht.
                                          return data.keys.toList()[index]; // Returns month name. // Gibt Monatsnamen zurück.
                                        } else if (selectedTimeFrame ==
                                            'Monthly') { // For monthly view. // Für monatliche Ansicht.
                                          DateTime date =
                                              DateFormat('dd/MM/yyyy').parse(
                                                  data.keys
                                                      .toList()
                                                      .reversed
                                                      .toList()[index]); // Parses date for this data point. // Analysiert Datum für diesen Datenpunkt.
                                          return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}"; // Returns month and day. // Gibt Monat und Tag zurück.
                                        } else { // For weekly view. // Für wöchentliche Ansicht.
                                          DateTime date =
                                              DateFormat('dd/MM/yyyy')
                                                  .parse(weekDays[index + 1]); // Parses date from week days list. // Analysiert Datum aus Wochentage-Liste.
                                          return formatDate(date,
                                              useShortFormat: true); // Returns formatted date. // Gibt formatiertes Datum zurück.
                                        }
                                      },
                                      yValueMapper: (Duration duration, _) =>
                                          duration.inSeconds / 3600.0, // Maps duration to hours for Y-axis. // Ordnet Dauer zu Stunden für Y-Achse zu.
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(flex: 9, child: GitHubChart()), // GitHub-style contribution chart. // GitHub-Stil-Beitragsdiagramm.

                  ]);
                } else { // If data loading failed. // Wenn Datenladen fehlgeschlagen ist.
                  return Text( // Error message. // Fehlermeldung.
                    "Error loading data", // Error text. // Fehlertext.
                    style: TextStyle(
                      color: Colors.grey[700], // Dark gray text. // Dunkelgrauer Text.
                    ),
                  );
                }
              } else { // If still loading data. // Wenn noch Daten geladen werden.
                return const Center(child: CircularProgressIndicator()); // Loading spinner. // Ladeanzeige.
              }
            },
          );
        }),
      ),
    );
  }
}
