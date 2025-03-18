import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod for state management.  // Importiert Riverpod für die Zustandsverwaltung. 
import 'package:http/http.dart';  // Import HTTP package for network requests.  // Importiert das HTTP-Paket für Netzwerkanfragen.
import 'package:pomoworko/presentation/notifiers/providers.dart';  // Import app-specific providers.  // Importiert anwendungsspezifische Provider.
import 'dart:async';  // Import async utilities like Timer.  // Importiert asynchrone Hilfsprogramme wie Timer.
import '../repository/auth_repository.dart';  // Import authentication repository.  // Importiert das Authentifizierungs-Repository.

final projectTimesProvider = StateNotifierProvider<ProjectTimesNotifier, Map<int, Map<DateTime, Duration>>>(  // Define a Riverpod provider for project times.  // Definiert einen Riverpod-Provider für Projektzeiten.
  (ref) => ProjectTimesNotifier(ref),  // Create a new notifier with the reference.  // Erstellt einen neuen Notifier mit der Referenz.
);

class ProjectTimesNotifier extends StateNotifier<Map<int, Map<DateTime, Duration>>> {  // Create a class to manage project time state.  // Erstellt eine Klasse zur Verwaltung des Projektzeitstatus.
  final Ref _ref;  // Reference to the Riverpod container.  // Referenz zum Riverpod-Container.
  Timer? _timer;  // Timer for tracking elapsed time.  // Timer zum Verfolgen der verstrichenen Zeit.
  DateTime? _startTime;  // When the current timer session started.  // Wann die aktuelle Timer-Sitzung begann.
  Duration _accumulatedTime = Duration.zero;  // Total time accumulated in current session.  // Gesamte akkumulierte Zeit in der aktuellen Sitzung.
  final Set<String> _processedTimeframes = {};  // Set to track processed timeframes.  // Set zur Verfolgung verarbeiteter Zeitrahmen.

  ProjectTimesNotifier(this._ref) : super({}) {  // Constructor initializes with empty map and loads data.  // Konstruktor initialisiert mit leerer Map und lädt Daten.
    loadTimeframeData();  // Load existing timeframe data.  // Lädt vorhandene Zeitrahmendaten.
  }

  Future<void> loadTimeframeData() async {  // Load timeframe data from repository.  // Lädt Zeitrahmendaten aus dem Repository.
    print('📊 Loading timeframe data...');  // Debug log for loading timeframes.  // Debug-Log für das Laden von Zeitrahmen.
    final authRepository = _ref.read(authRepositoryProvider);  // Get auth repository from provider.  // Holt das Auth-Repository vom Provider.
    
    print('🔄 Loading weekly timeframes...');  // Debug log for loading weekly data.  // Debug-Log für das Laden wöchentlicher Daten.
    final result = await authRepository.getTimeframeData('weekly');  // Fetch weekly timeframe data.  // Ruft wöchentliche Zeitrahmendaten ab.
    if (result.data != null) {  // If data was successfully retrieved.  // Wenn Daten erfolgreich abgerufen wurden.
      final count = (result.data as List).length;  // Count the number of timeframes.  // Zählt die Anzahl der Zeitrahmen.
      print('✅ Loaded $count weekly timeframes');  // Debug log successful load.  // Debug-Log für erfolgreichen Ladevorgang.
    } else {  // If data retrieval failed.  // Wenn der Datenabruf fehlgeschlagen ist.
      print('❌ Failed to load weekly timeframes: ${result.error}');  // Debug log error.  // Debug-Log für Fehler.
    }
    
    print('📊 Current state after loading:');  // Debug log for state inspection.  // Debug-Log für Zustandsinspektion.
    state.forEach((projectIndex, timeEntries) {  // Iterate through each project.  // Iteriert durch jedes Projekt.
      print('Project $projectIndex: ${timeEntries.length} entries');  // Log project entries count.  // Loggt die Anzahl der Projekteinträge.
    });
  }

  void startTimer(int containerIndex) {  // Start the timer for a project.  // Startet den Timer für ein Projekt.
    if (_timer?.isActive ?? false) {  // Check if timer is already running.  // Prüft, ob der Timer bereits läuft.
      print('🔴 Timer already active, ignoring start request');  // Debug log timer already running.  // Debug-Log Timer läuft bereits.
      return;  // Exit the method.  // Beendet die Methode.
    }
    
    print('\n🟢 TIMER START -------------');  // Debug log timer start.  // Debug-Log Timer-Start.
    print('⏰ Start time: ${DateTime.now()}');  // Log current time.  // Loggt die aktuelle Zeit.
    print('💾 Accumulated time before start: ${_accumulatedTime.inSeconds}s');  // Log previous accumulated time.  // Loggt die bisher akkumulierte Zeit.
    
    _startTime = DateTime.now();  // Set the start time to now.  // Setzt die Startzeit auf jetzt.
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {  // Create a timer that ticks every second.  // Erstellt einen Timer, der jede Sekunde tickt.
      if (_startTime != null) {  // If the timer has a valid start time.  // Wenn der Timer eine gültige Startzeit hat.
        final currentTime = DateTime.now();  // Get the current time.  // Holt die aktuelle Zeit.
        final elapsedSeconds = currentTime.difference(_startTime!).inSeconds;  // Calculate elapsed seconds.  // Berechnet verstrichene Sekunden.
        
        print('⏱️ Running time: ${elapsedSeconds}s');  // Log running time.  // Loggt die Laufzeit.
        print('🔄 Total time: ${(_accumulatedTime.inSeconds + elapsedSeconds)}s');  // Log total accumulated time.  // Loggt die Gesamtzeit.
      }
    });
  }

  void pauseTimer(int containerIndex) {  // Pause the timer and save elapsed time.  // Pausiert den Timer und speichert die verstrichene Zeit.
    print('\n🔴 TIMER PAUSE -------------');  // Debug log timer pause.  // Debug-Log Timer-Pause.
    
    if (_startTime == null) {  // If timer wasn't started.  // Wenn der Timer nicht gestartet wurde.
      print('❌ Cannot pause: Timer was not started');  // Log error.  // Loggt einen Fehler.
      return;  // Exit the method.  // Beendet die Methode.
    }

    final currentTime = DateTime.now();  // Get the current time.  // Holt die aktuelle Zeit.
    final rawDifference = currentTime.difference(_startTime!);  // Calculate raw time difference.  // Berechnet die rohe Zeitdifferenz.
    final elapsedSeconds = rawDifference.inSeconds;  // Convert to seconds.  // Konvertiert in Sekunden.
    
    print('⚡ Raw difference in ms: ${rawDifference.inMilliseconds}');  // Log millisecond difference.  // Loggt die Differenz in Millisekunden.
    print('⏱️ Adjusted seconds: $elapsedSeconds');  // Log adjusted seconds.  // Loggt die angepassten Sekunden.
    
    final duration = Duration(seconds: elapsedSeconds);  // Create a duration object.  // Erstellt ein Dauer-Objekt.
    
    print('⏱️ Elapsed this session: ${elapsedSeconds}s');  // Log session elapsed time.  // Loggt die in dieser Sitzung verstrichene Zeit.
    print('💾 Previous accumulated: ${_accumulatedTime.inSeconds}s');  // Log previous accumulated time.  // Loggt die zuvor akkumulierte Zeit.
    
    _accumulatedTime += duration;  // Add session time to accumulated time.  // Fügt die Sitzungszeit zur akkumulierten Zeit hinzu.
    
    print('📊 New total accumulated: ${_accumulatedTime.inSeconds}s');  // Log new total time.  // Loggt die neue Gesamtzeit.
    print('⏰ Pause time: $currentTime');  // Log the pause time.  // Loggt die Pausenzeit.
    
    addTime(containerIndex, currentTime, duration);  // Add the time to the project.  // Fügt die Zeit zum Projekt hinzu.
    
    _timer?.cancel();  // Cancel the active timer.  // Bricht den aktiven Timer ab.
    _timer = null;  // Clear the timer reference.  // Löscht die Timer-Referenz.
    _startTime = null;  // Clear the start time.  // Löscht die Startzeit.
  }

  bool isTimerActive() {  // Check if timer is currently active.  // Prüft, ob der Timer aktiv ist.
    return _timer?.isActive ?? false;  // Return true if timer is active, false otherwise.  // Gibt true zurück, wenn der Timer aktiv ist, andernfalls false.
  }

  Duration getCurrentDuration() {  // Get the current total duration.  // Holt die aktuelle Gesamtdauer.
    if (_startTime == null) return _accumulatedTime;  // If timer is not running, return accumulated time.  // Wenn der Timer nicht läuft, gibt die akkumulierte Zeit zurück.
    
    final currentTime = DateTime.now();  // Get current time.  // Holt die aktuelle Zeit.
    final elapsedSeconds = currentTime.difference(_startTime!).inSeconds;  // Calculate elapsed seconds.  // Berechnet verstrichene Sekunden.
    return _accumulatedTime + Duration(seconds: elapsedSeconds);  // Return total duration.  // Gibt die Gesamtdauer zurück.
  }

  void resetTimer() {  // Reset the timer to zero.  // Setzt den Timer auf Null zurück.
    _timer?.cancel();  // Cancel active timer.  // Bricht den aktiven Timer ab.
    _timer = null;  // Clear timer reference.  // Löscht die Timer-Referenz.
    _startTime = null;  // Clear start time.  // Löscht die Startzeit.
    _accumulatedTime = Duration.zero;  // Reset accumulated time.  // Setzt die akkumulierte Zeit zurück.
    print('🔄 Timer reset - Accumulated time: ${_accumulatedTime.inSeconds}s');  // Log timer reset.  // Loggt das Zurücksetzen des Timers.
  }

  void addTimeToState(int containerIndex, DateTime date, Duration newDuration) {  // Add time to the state.  // Fügt Zeit zum Zustand hinzu.
    final normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize date to remove time part.  // Normalisiert das Datum, um den Zeitteil zu entfernen.
    final timeframeKey = '$containerIndex-${normalizedDate.toIso8601String()}';  // Create unique key for the timeframe.  // Erstellt einen eindeutigen Schlüssel für den Zeitrahmen.
    
    // Create a new map for the entire state  // Erstellt eine neue Map für den gesamten Zustand
    Map<int, Map<DateTime, Duration>> newState = Map.from(state);  // Create a copy of the current state.  // Erstellt eine Kopie des aktuellen Zustands.
    
    // Ensure the container map exists  // Stellt sicher, dass die Container-Map existiert
    if (!newState.containsKey(containerIndex)) {  // If project doesn't exist in state.  // Wenn das Projekt nicht im Zustand existiert.
      newState[containerIndex] = {};  // Initialize empty map for project.  // Initialisiert eine leere Map für das Projekt.
    }
    
    // Get the existing duration for this date, if any  // Holt die bestehende Dauer für dieses Datum, falls vorhanden
    final existingDuration = newState[containerIndex]![normalizedDate] ?? Duration.zero;  // Get existing duration or zero.  // Holt die bestehende Dauer oder Null.
    
    // Add the new duration to the existing one  // Fügt die neue Dauer zur bestehenden hinzu
    final totalDuration = Duration(seconds: existingDuration.inSeconds + newDuration.inSeconds);  // Calculate total duration.  // Berechnet die Gesamtdauer.
    
    // Update the container map with the new total duration  // Aktualisiert die Container-Map mit der neuen Gesamtdauer
    newState[containerIndex]![normalizedDate] = totalDuration;  // Set the new total duration.  // Setzt die neue Gesamtdauer.
    
    // Update the state with the new map  // Aktualisiert den Zustand mit der neuen Map
    state = newState;  // Set the new state.  // Setzt den neuen Zustand.
    
    print('📊 Updated time for project $containerIndex on $normalizedDate:');  // Log update information.  // Loggt Aktualisierungsinformationen.
    print('➕ Added duration: ${newDuration.inSeconds}s');  // Log added duration.  // Loggt die hinzugefügte Dauer.
    print('📈 New total: ${totalDuration.inSeconds}s');  // Log new total.  // Loggt die neue Gesamtsumme.
  }

  void clearProcessedTimeframes() {  // Clear the set of processed timeframes.  // Löscht die Menge der verarbeiteten Zeitrahmen.
    _processedTimeframes.clear();  // Clear the set.  // Löscht die Menge.
  }

  Future<void> addTime(int containerIndex, DateTime date, Duration duration) async {  // Add time and persist to repository.  // Fügt Zeit hinzu und speichert sie im Repository.
    addTimeToState(containerIndex, date, duration);  // Update the local state.  // Aktualisiert den lokalen Zustand.

    try {  // Try to save to repository.  // Versucht, im Repository zu speichern.
      final authRepository = _ref.read(authRepositoryProvider);  // Get auth repository.  // Holt das Auth-Repository.
      final normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize date.  // Normalisiert das Datum.
      
      final currentContainerMap = state[containerIndex] ?? {};  // Get current map for project.  // Holt die aktuelle Map für das Projekt.
      final totalDuration = currentContainerMap[normalizedDate] ?? Duration.zero;  // Get total duration.  // Holt die Gesamtdauer.

      await authRepository.addTimeframeData(  // Call repository to save data.  // Ruft das Repository auf, um Daten zu speichern.
        projectIndex: containerIndex,  // Project index.  // Projektindex.
        date: date,  // Date of the timeframe.  // Datum des Zeitrahmens.
        duration: totalDuration.inSeconds,  // Duration in seconds.  // Dauer in Sekunden.
        timeframeType: 'weekly',  // Type of timeframe.  // Art des Zeitrahmens.
      );
    } catch (e) {  // Handle errors.  // Behandelt Fehler.
      print('❌ Error saving timeframe data: $e');  // Log error.  // Loggt den Fehler.
    }
  }

  Duration getProjectTime(int containerIndex, DateTime date) {  // Get time for a project on a specific date.  // Holt die Zeit für ein Projekt an einem bestimmten Datum.
    final normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize date.  // Normalisiert das Datum.
    return state[containerIndex]?[normalizedDate] ?? Duration.zero;  // Return duration or zero.  // Gibt die Dauer oder Null zurück.
  }

  Duration getProjectTimeForMonth(int containerIndex, DateTime date) {  // Get time for a project in a specific month.  // Holt die Zeit für ein Projekt in einem bestimmten Monat.
    final normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize date.  // Normalisiert das Datum.
    return state[containerIndex]?[normalizedDate] ?? Duration.zero;  // Return duration or zero.  // Gibt die Dauer oder Null zurück.
  }

  Duration getProjectTimeForYear(int containerIndex, DateTime date) {  // Get time for a project in a specific year.  // Holt die Zeit für ein Projekt in einem bestimmten Jahr.
    final containerMap = state[containerIndex];  // Get the map for this project.  // Holt die Map für dieses Projekt.
    if (containerMap == null) return Duration.zero;  // Return zero if no data.  // Gibt Null zurück, wenn keine Daten vorhanden sind.

    return containerMap.entries  // Process all entries.  // Verarbeitet alle Einträge.
        .where((entry) =>   // Filter by year and month.  // Filtert nach Jahr und Monat.
          entry.key.year == date.year && 
          entry.key.month == date.month)
        .fold(Duration.zero, (prev, curr) => prev + curr.value);  // Sum all durations.  // Summiert alle Dauern.
  }

  Duration getTotalProjectTime(int containerIndex) {  // Get total time for a project.  // Holt die Gesamtzeit für ein Projekt.
    final containerMap = state[containerIndex];  // Get the map for this project.  // Holt die Map für dieses Projekt.
    if (containerMap == null) return Duration.zero;  // Return zero if no data.  // Gibt Null zurück, wenn keine Daten vorhanden sind.
    return containerMap.values.fold(Duration.zero, (prev, curr) => prev + curr);  // Sum all durations.  // Summiert alle Dauern.
  }

  Duration getMonthlyDuration(int containerIndex, DateTime date) {  // Get monthly duration for visualization.  // Holt die monatliche Dauer für die Visualisierung.
    final normalizedDate = DateTime(date.year, date.month, date.day);  // Normalize date.  // Normalisiert das Datum.
    return state[containerIndex]?[normalizedDate] ?? Duration.zero;  // Return duration or zero.  // Gibt die Dauer oder Null zurück.
  }

  Duration getYearlyDuration(int containerIndex, DateTime date) {  // Get yearly duration for visualization.  // Holt die jährliche Dauer für die Visualisierung.
    final containerMap = state[containerIndex];  // Get the map for this project.  // Holt die Map für dieses Projekt.
    if (containerMap == null) return Duration.zero;  // Return zero if no data.  // Gibt Null zurück, wenn keine Daten vorhanden sind.

    final currentMonthStart = DateTime(date.year, date.month, 1);  // Start of current month.  // Beginn des aktuellen Monats.
    final nextMonthStart = DateTime(date.year, date.month + 1, 1);  // Start of next month.  // Beginn des nächsten Monats.

    return containerMap.entries  // Process all entries.  // Verarbeitet alle Einträge.
        .where((entry) =>   // Filter by date range.  // Filtert nach Datumsbereich.
          entry.key.isAfter(currentMonthStart.subtract(const Duration(days: 1))) &&
          entry.key.isBefore(nextMonthStart))
        .fold(Duration.zero, (prev, curr) => prev + curr.value);  // Sum all durations.  // Summiert alle Dauern.
  }

  List<Duration> getYearlyData(int containerIndex, DateTime now) {  // Get yearly data for charts.  // Holt jährliche Daten für Diagramme.
    return List.generate(12, (index) {  // Generate 12 months of data.  // Generiert 12 Monate an Daten.
      int month = now.month - index;  // Calculate month.  // Berechnet den Monat.
      int year = now.year;  // Start with current year.  // Beginnt mit dem aktuellen Jahr.
      
      if (month <= 0) {  // If month rolled back past January.  // Wenn der Monat vor Januar zurückrollt.
        month += 12;  // Adjust month.  // Passt den Monat an.
        year -= 1;  // Adjust year.  // Passt das Jahr an.
      }
      
      final date = DateTime(year, month, 1);  // Create date for first of month.  // Erstellt das Datum für den Ersten des Monats.
      return getProjectTimeForYear(containerIndex, date);  // Get time for this month.  // Holt die Zeit für diesen Monat.
    }).reversed.toList();  // Reverse to get chronological order.  // Kehrt um, um chronologische Reihenfolge zu erhalten.
  }

  List<Duration> getMonthlyData(int containerIndex, DateTime now) {  // Get monthly data for charts.  // Holt monatliche Daten für Diagramme.
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;  // Calculate days in month.  // Berechnet die Tage im Monat.
    
    return List.generate(daysInMonth, (index) {  // Generate data for each day.  // Generiert Daten für jeden Tag.
      final date = DateTime(now.year, now.month, daysInMonth - index);  // Calculate date.  // Berechnet das Datum.
      return getProjectTime(containerIndex, date);  // Get time for this day.  // Holt die Zeit für diesen Tag.
    });
  }

  void resetState() {  // Reset the entire state.  // Setzt den gesamten Zustand zurück.
    state = {};  // Clear the state.  // Löscht den Zustand.
    resetTimer();  // Reset the timer.  // Setzt den Timer zurück.
  }

  void clearProjectData(int projectIndex) async {  // Clear data for a specific project.  // Löscht Daten für ein bestimmtes Projekt.
    state = Map.from(state)..remove(projectIndex);  // Remove project from state.  // Entfernt das Projekt aus dem Zustand.
    await _ref.read(localStorageRepositoryProvider).clearProjectTimeframes(projectIndex);  // Clear from storage.  // Löscht aus dem Speicher.
    
    if (_startTime != null) {  // If timer is active.  // Wenn der Timer aktiv ist.
      resetTimer();  // Reset the timer.  // Setzt den Timer zurück.
    }
  }
}
