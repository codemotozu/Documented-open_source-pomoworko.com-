/// LocalStorageRepository
/// 
/// A repository class for managing local storage operations in the Flutter application. // Eine Repository-Klasse zur Verwaltung von lokalen Speicheroperationen in der Flutter-Anwendung.
/// Used to persist user settings, authentication data, timer configurations, and time tracking data. // Wird verwendet, um Benutzereinstellungen, Authentifizierungsdaten, Timer-Konfigurationen und Zeiterfassungsdaten zu speichern.
/// 
/// Usage:
/// ```dart
/// final localStorageRepo = LocalStorageRepository();
/// await localStorageRepo.setToken("auth-token-123");
/// final userToken = await localStorageRepo.getToken();
/// ```
/// 
/// EN: Manages persistent storage for user preferences and application state.
/// DE: Verwaltet persistenten Speicher für Benutzereinstellungen und Anwendungszustand.

import 'dart:convert'; // Imports JSON encoding and decoding functionality. // Importiert Funktionen zur JSON-Kodierung und -Dekodierung.

import 'package:shared_preferences/shared_preferences.dart'; // Imports shared preferences plugin for persistent storage. // Importiert das Shared Preferences-Plugin für persistenten Speicher.

import '../../models/timeframe_entry.dart'; // Imports timeframe entry model. // Importiert das Zeitrahmen-Eintragsmodell.
import '../../models/user_model.dart'; // Imports user model. // Importiert das Benutzermodell.

class LocalStorageRepository { // Class declaration for local storage repository. // Klassendeklaration für das lokale Speicher-Repository.
  void setToken(String token) async { // Method to store authentication token. // Methode zum Speichern des Authentifizierungs-Tokens.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    preferences.setString('x-auth-token', token); // Store token with key 'x-auth-token'. // Speichert Token mit Schlüssel 'x-auth-token'.
    print("$token token set from local storage"); // Debug print for token storage. // Debug-Ausgabe für Token-Speicherung.
  }

  Future<String?> getToken() async { // Method to retrieve authentication token. // Methode zum Abrufen des Authentifizierungs-Tokens.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    String? token = preferences.getString('x-auth-token'); // Retrieve token with key 'x-auth-token'. // Ruft Token mit Schlüssel 'x-auth-token' ab.
    return token; // Return the retrieved token, may be null. // Gibt das abgerufene Token zurück, kann null sein.
  }

  void setIsPremium(bool isPremium) async { // Method to store premium status. // Methode zum Speichern des Premium-Status.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setBool('isPremium', isPremium); // Store premium status with key 'isPremium'. // Speichert Premium-Status mit Schlüssel 'isPremium'.
    print(
        "setIsPremium called with value from local storage repository: $isPremium"); // Debug print for premium status. // Debug-Ausgabe für Premium-Status.
  }

  Future<bool> getIsPremium() async { // Method to retrieve premium status. // Methode zum Abrufen des Premium-Status.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getBool('isPremium') ?? false; // Return premium status, default to false if not set. // Gibt Premium-Status zurück, Standard ist false wenn nicht gesetzt.
  }

  void setIssuscriptionStatusCancelled(bool suscriptionStatusCancelled) async { // Method to store subscription cancellation status. // Methode zum Speichern des Abonnement-Kündigungsstatus.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setBool(
        'suscriptionStatusCancelled', suscriptionStatusCancelled); // Store cancellation status. // Speichert Kündigungsstatus.
    print(
        "setIssuscriptionStatusCancelled called with value from local storage repository: $suscriptionStatusCancelled"); // Debug print for cancellation status. // Debug-Ausgabe für Kündigungsstatus.
  }

  Future<bool> getsuscriptionStatusCancelled() async { // Method to retrieve subscription cancellation status. // Methode zum Abrufen des Abonnement-Kündigungsstatus.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getBool('suscriptionStatusCancelled') ?? false; // Return cancellation status, default to false if not set. // Gibt Kündigungsstatus zurück, Standard ist false wenn nicht gesetzt.
  }

  void setIsubscriptionStatusConfirmed(bool subscriptionStatusConfirmed) async { // Method to store subscription confirmation status. // Methode zum Speichern des Abonnement-Bestätigungsstatus.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setBool(
        'subscriptionStatusConfirmed', subscriptionStatusConfirmed); // Store confirmation status. // Speichert Bestätigungsstatus.
    print(
        "setIsPremium called with value from local storage repository: $subscriptionStatusConfirmed"); // Debug print for confirmation status. // Debug-Ausgabe für Bestätigungsstatus.
  }

  Future<bool> getsubscriptionStatusConfirmed() async { // Method to retrieve subscription confirmation status. // Methode zum Abrufen des Abonnement-Bestätigungsstatus.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getBool('subscriptionStatusConfirmed') ?? false; // Return confirmation status, default to false if not set. // Gibt Bestätigungsstatus zurück, Standard ist false wenn nicht gesetzt.
  }

  void setPomodoroTimer(int pomodoroTimer) async { // Method to store pomodoro timer duration. // Methode zum Speichern der Pomodoro-Timer-Dauer.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setInt('pomodoroTimer', pomodoroTimer); // Store pomodoro timer value. // Speichert Pomodoro-Timer-Wert.
    print("setPomodoroTimer called with value: $pomodoroTimer"); // Debug print for pomodoro timer. // Debug-Ausgabe für Pomodoro-Timer.
  }

  Future<int> getPomodoroTimer() async { // Method to retrieve pomodoro timer duration. // Methode zum Abrufen der Pomodoro-Timer-Dauer.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    int pomodoroTimer = preferences.getInt('pomodoroTimer') ?? 25; // Get pomodoro timer, default to 25 if not set. // Holt Pomodoro-Timer, Standard ist 25 wenn nicht gesetzt.
    print("getPomodoroTimer returned value: $pomodoroTimer"); // Debug print for retrieved timer value. // Debug-Ausgabe für abgerufenen Timer-Wert.
    return pomodoroTimer; // Return the timer value. // Gibt den Timer-Wert zurück.
  }

  void setShortBreakTimer(int shortBreakTimer) async { // Method to store short break timer duration. // Methode zum Speichern der Kurzpausen-Timer-Dauer.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setInt('shortBreakTimer', shortBreakTimer); // Store short break timer value. // Speichert Kurzpausen-Timer-Wert.
    print("setShortBreakTimer called with value: $shortBreakTimer"); // Debug print for short break timer. // Debug-Ausgabe für Kurzpausen-Timer.
  }

  Future<int> getShortBreakTimer() async { // Method to retrieve short break timer duration. // Methode zum Abrufen der Kurzpausen-Timer-Dauer.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    int shortBreakTimer = preferences.getInt('shortBreakTimer') ?? 5; // Get short break timer, default to 5 if not set. // Holt Kurzpausen-Timer, Standard ist 5 wenn nicht gesetzt.
    print("getShortBreakTimer returned value: $shortBreakTimer"); // Debug print for retrieved timer value. // Debug-Ausgabe für abgerufenen Timer-Wert.
    return shortBreakTimer; // Return the timer value. // Gibt den Timer-Wert zurück.
  }

  void setLongBreakTimer(int longBreakTimer) async { // Method to store long break timer duration. // Methode zum Speichern der Langpausen-Timer-Dauer.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setInt('longBreakTimer', longBreakTimer); // Store long break timer value. // Speichert Langpausen-Timer-Wert.
    print("setLongBreakTimer called with value: $longBreakTimer"); // Debug print for long break timer. // Debug-Ausgabe für Langpausen-Timer.
  }

  Future<int> getLongBreakTimer() async { // Method to retrieve long break timer duration. // Methode zum Abrufen der Langpausen-Timer-Dauer.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    int longBreakTimer = preferences.getInt('longBreakTimer') ?? 5; // Get long break timer, default to 5 if not set. // Holt Langpausen-Timer, Standard ist 5 wenn nicht gesetzt.
    print("getLongBreakTimer returned value: $longBreakTimer"); // Debug print for retrieved timer value. // Debug-Ausgabe für abgerufenen Timer-Wert.
    return longBreakTimer; // Return the timer value. // Gibt den Timer-Wert zurück.
  }

  void setLongBreakInterval(int longBreakInterval) async { // Method to store long break interval. // Methode zum Speichern des Langpausen-Intervalls.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setInt('longBreakInterval', longBreakInterval); // Store long break interval value. // Speichert Langpausen-Intervall-Wert.
    print("setLongBreakInterval called with value: $longBreakInterval"); // Debug print for long break interval. // Debug-Ausgabe für Langpausen-Intervall.
  }

  Future<int> getLongBreakInterval() async { // Method to retrieve long break interval. // Methode zum Abrufen des Langpausen-Intervalls.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    int longBreakInterval = preferences.getInt('longBreakInterval') ?? 4; // Get long break interval, default to 4 if not set. // Holt Langpausen-Intervall, Standard ist 4 wenn nicht gesetzt.
    print("getLongBreakInterval returned value: $longBreakInterval"); // Debug print for retrieved interval value. // Debug-Ausgabe für abgerufenen Intervall-Wert.
    return longBreakInterval; // Return the interval value. // Gibt den Intervall-Wert zurück.
  }

  void setSelectedSound(String selectedSound) async { // Method to store selected sound path. // Methode zum Speichern des ausgewählten Sound-Pfades.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setString('selectedSound', selectedSound); // Store selected sound path. // Speichert ausgewählten Sound-Pfad.
  }

  Future<String> getSelectedSound() async { // Method to retrieve selected sound path. // Methode zum Abrufen des ausgewählten Sound-Pfades.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getString('selectedSound') ??
        'assets/sounds/Flashpoint.wav'; // Return sound path, default if not set. // Gibt Sound-Pfad zurück, Standard wenn nicht gesetzt.
  }

  void setBrowserNotificationsEnabled(bool browserNotificationsEnabled) async { // Method to store browser notifications setting. // Methode zum Speichern der Browser-Benachrichtigungseinstellung.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setBool(
        'browserNotificationsEnabled', browserNotificationsEnabled); // Store notifications setting. // Speichert Benachrichtigungseinstellung.
    print(
        "setBrowserNotificationsEnabled called with value: $browserNotificationsEnabled"); // Debug print for notifications setting. // Debug-Ausgabe für Benachrichtigungseinstellung.
  }

  Future<bool> getBrowserNotificationsEnabled() async { // Method to retrieve browser notifications setting. // Methode zum Abrufen der Browser-Benachrichtigungseinstellung.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getBool('browserNotificationsEnabled') ?? false; // Return setting, default to false if not set. // Gibt Einstellung zurück, Standard ist false wenn nicht gesetzt.
  }

  void setPomodoroColor(String color) async { // Method to store pomodoro timer color. // Methode zum Speichern der Pomodoro-Timer-Farbe.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setString('pomodoroColor', color); // Store pomodoro color value. // Speichert Pomodoro-Farbwert.
  }

  Future<String> getPomodoroColor() async { // Method to retrieve pomodoro timer color. // Methode zum Abrufen der Pomodoro-Timer-Farbe.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getString('pomodoroColor') ?? '#74F143'; // Return color value, default to green if not set. // Gibt Farbwert zurück, Standard ist Grün wenn nicht gesetzt.
  }

  void setShortBreakColor(String color) async { // Method to store short break timer color. // Methode zum Speichern der Kurzpausen-Timer-Farbe.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setString('shortBreakColor', color); // Store short break color value. // Speichert Kurzpausen-Farbwert.
  }

  Future<String> getShortBreakColor() async { // Method to retrieve short break timer color. // Methode zum Abrufen der Kurzpausen-Timer-Farbe.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getString('shortBreakColor') ?? '#ff9933'; // Return color value, default to orange if not set. // Gibt Farbwert zurück, Standard ist Orange wenn nicht gesetzt.
  }

  void setLongBreakColor(String color) async { // Method to store long break timer color. // Methode zum Speichern der Langpausen-Timer-Farbe.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setString('longBreakColor', color); // Store long break color value. // Speichert Langpausen-Farbwert.
  }

  Future<String> getLongBreakColor() async { // Method to retrieve long break timer color. // Methode zum Abrufen der Langpausen-Timer-Farbe.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getString('longBreakColor') ?? '#0891FF'; // Return color value, default to blue if not set. // Gibt Farbwert zurück, Standard ist Blau wenn nicht gesetzt.
  }

  void setPomodoroStates(List<bool> states) async { // Method to store pomodoro states list. // Methode zum Speichern der Pomodoro-Zustandsliste.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setString('pomodoroStates', jsonEncode(states)); // Store states list as JSON string. // Speichert Zustandsliste als JSON-Zeichenfolge.
  }

  Future<List<bool>> getPomodoroStates() async { // Method to retrieve pomodoro states list. // Methode zum Abrufen der Pomodoro-Zustandsliste.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    String? statesString = preferences.getString('pomodoroStates'); // Get stored JSON string. // Holt gespeicherte JSON-Zeichenfolge.
    if (statesString != null) { // Check if states are stored. // Prüft, ob Zustände gespeichert sind.
      List<dynamic> decodedList = jsonDecode(statesString); // Decode JSON to list. // Dekodiert JSON zu Liste.
      return decodedList.cast<bool>(); // Cast list to boolean list and return. // Wandelt Liste in Boolean-Liste um und gibt sie zurück.
    }
    return []; // Return empty list if no states stored. // Gibt leere Liste zurück, wenn keine Zustände gespeichert sind.
  }

  void setToDoHappySadToggle(bool toDoHappySadToggle) async { // Method to store to-do happy/sad toggle setting. // Methode zum Speichern der To-Do-Glücklich/Traurig-Umschalteinstellung.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setBool(
        'toDoHappySadToggle', toDoHappySadToggle); // Store toggle setting. // Speichert Umschalteinstellung.
    print(
        "setToDoHappySadToggle called with value: $toDoHappySadToggle"); // Debug print for toggle setting. // Debug-Ausgabe für Umschalteinstellung.
  }

  Future<bool> getToDoHappySadToggle() async { // Method to retrieve to-do happy/sad toggle setting. // Methode zum Abrufen der To-Do-Glücklich/Traurig-Umschalteinstellung.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getBool('ToDoHappySadToggle') ?? false; // Return setting, default to false if not set. // Gibt Einstellung zurück, Standard ist false wenn nicht gesetzt.
  }

  void setTaskDeletionByTrashIcon(bool taskDeletionByTrashIcon) async { // Method to store task deletion by trash icon setting. // Methode zum Speichern der Aufgabenlöschung-durch-Papierkorb-Symbol-Einstellung.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setBool('taskDeletionByTrashIcon', taskDeletionByTrashIcon); // Store deletion setting. // Speichert Löscheinstellung.
    print("setTaskDeletionByTrashIcon called with value: $taskDeletionByTrashIcon"); // Debug print for deletion setting. // Debug-Ausgabe für Löscheinstellung.
  }

  Future<bool> getTaskDeletionByTrashIcon() async { // Method to retrieve task deletion by trash icon setting. // Methode zum Abrufen der Aufgabenlöschung-durch-Papierkorb-Symbol-Einstellung.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getBool('taskDeletionByTrashIcon') ?? false; // Return setting, default to false if not set. // Gibt Einstellung zurück, Standard ist false wenn nicht gesetzt.
  }

  Future<void> saveTaskDeletionHistory(String taskId, String userId, bool deletedByTrashIcon) async { // Method to save task deletion history. // Methode zum Speichern der Aufgabenlöschungsverlaufs.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final String key = 'taskDeletion_${userId}_$taskId'; // Generate unique key for deletion record. // Generiert eindeutigen Schlüssel für Löschdatensatz.
    final Map<String, dynamic> deletionInfo = { // Create deletion info map. // Erstellt Löschinfo-Map.
      'timestamp': DateTime.now().toIso8601String(), // Store deletion timestamp. // Speichert Löschzeitstempel.
      'deletedByTrashIcon': deletedByTrashIcon, // Store deletion method. // Speichert Löschmethode.
    };
    await preferences.setString(key, json.encode(deletionInfo)); // Store deletion info as JSON. // Speichert Löschinfo als JSON.
  }

  Future<Map<String, dynamic>?> getTaskDeletionHistory(String taskId, String userId) async { // Method to retrieve task deletion history. // Methode zum Abrufen des Aufgabenlöschungsverlaufs.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final String key = 'taskDeletion_${userId}_$taskId'; // Generate key for deletion record. // Generiert Schlüssel für Löschdatensatz.
    final String? deletionInfo = preferences.getString(key); // Get stored deletion info. // Holt gespeicherte Löschinfo.
    if (deletionInfo != null) { // Check if deletion info exists. // Prüft, ob Löschinfo existiert.
      return json.decode(deletionInfo); // Decode and return deletion info. // Dekodiert und gibt Löschinfo zurück.
    }
    return null; // Return null if no deletion info found. // Gibt null zurück, wenn keine Löschinfo gefunden wurde.
  }

  void setTaskCardTitle(String taskCardTitle) async { // Method to store task card title. // Methode zum Speichern des Aufgabenkartentitels.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setString('taskCardTitle', taskCardTitle); // Store task card title. // Speichert Aufgabenkartentitel.
    print("setTaskCardTitle called with value: $taskCardTitle"); // Debug print for task card title. // Debug-Ausgabe für Aufgabenkartentitel.
  }

  Future<String> getTaskCardTitle() async { // Method to retrieve task card title. // Methode zum Abrufen des Aufgabenkartentitels.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getString('taskCardTitle') ?? ''; // Return title, default to empty if not set. // Gibt Titel zurück, Standard ist leer wenn nicht gesetzt.
  }
  
  void saveProjectNames(List<String> projectNames) async { // Method to store list of project names. // Methode zum Speichern der Liste von Projektnamen.
    final prefs = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await prefs.setStringList('projectNames', projectNames); // Store project names list. // Speichert Projektnamen-Liste.
  }

  Future<List<String>> getProjectNames() async { // Method to retrieve list of project names. // Methode zum Abrufen der Liste von Projektnamen.
    final prefs = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return prefs.getStringList('projectNames') ?? 
      ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']; // Return names, default if not set. // Gibt Namen zurück, Standard wenn nicht gesetzt.
  }

  void setSelectedContainerIndex(int index) async { // Method to store selected container index. // Methode zum Speichern des ausgewählten Container-Index.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    await preferences.setInt('selectedContainerIndex', index); // Store index value. // Speichert Indexwert.
  }

  Future<int> getSelectedContainerIndex() async { // Method to retrieve selected container index. // Methode zum Abrufen des ausgewählten Container-Index.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    return preferences.getInt('selectedContainerIndex') ?? 0; // Return index, default to 0 if not set. // Gibt Index zurück, Standard ist 0 wenn nicht gesetzt.
  }

  void setWeeklyTimeframes(List<TimeframeEntry> timeframes) async { // Method to store weekly timeframe entries. // Methode zum Speichern wöchentlicher Zeitrahmeneinträge.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final List<Map<String, dynamic>> timeframesMap = 
        timeframes.map((entry) => entry.toMap()).toList(); // Convert entries to maps. // Konvertiert Einträge in Maps.
    await preferences.setString('weeklyTimeframes', jsonEncode(timeframesMap)); // Store as JSON string. // Speichert als JSON-Zeichenfolge.
    print("setWeeklyTimeframes called with ${timeframes.length} entries"); // Debug print for entries count. // Debug-Ausgabe für Eintragsanzahl.
  }

  Future<List<TimeframeEntry>> getWeeklyTimeframes() async { // Method to retrieve weekly timeframe entries. // Methode zum Abrufen wöchentlicher Zeitrahmeneinträge.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final String? timeframesString = preferences.getString('weeklyTimeframes'); // Get stored JSON string. // Holt gespeicherte JSON-Zeichenfolge.
    if (timeframesString != null) { // Check if timeframes are stored. // Prüft, ob Zeitrahmen gespeichert sind.
      final List<dynamic> decodedList = jsonDecode(timeframesString); // Decode JSON to list. // Dekodiert JSON zu Liste.
      return decodedList
          .map((entry) => TimeframeEntry.fromMap(entry as Map<String, dynamic>)) // Convert maps to entries. // Konvertiert Maps in Einträge.
          .toList(); // Return as list. // Gibt als Liste zurück.
    }
    return []; // Return empty list if no entries stored. // Gibt leere Liste zurück, wenn keine Einträge gespeichert sind.
  }

  void setMonthlyTimeframes(List<TimeframeEntry> timeframes) async { // Method to store monthly timeframe entries. // Methode zum Speichern monatlicher Zeitrahmeneinträge.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final List<Map<String, dynamic>> timeframesMap = 
        timeframes.map((entry) => entry.toMap()).toList(); // Convert entries to maps. // Konvertiert Einträge in Maps.
    await preferences.setString('monthlyTimeframes', jsonEncode(timeframesMap)); // Store as JSON string. // Speichert als JSON-Zeichenfolge.
    print("setMonthlyTimeframes called with ${timeframes.length} entries"); // Debug print for entries count. // Debug-Ausgabe für Eintragsanzahl.
  }

  Future<List<TimeframeEntry>> getMonthlyTimeframes() async { // Method to retrieve monthly timeframe entries. // Methode zum Abrufen monatlicher Zeitrahmeneinträge.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final String? timeframesString = preferences.getString('monthlyTimeframes'); // Get stored JSON string. // Holt gespeicherte JSON-Zeichenfolge.
    if (timeframesString != null) { // Check if timeframes are stored. // Prüft, ob Zeitrahmen gespeichert sind.
      final List<dynamic> decodedList = jsonDecode(timeframesString); // Decode JSON to list. // Dekodiert JSON zu Liste.
      return decodedList
          .map((entry) => TimeframeEntry.fromMap(entry as Map<String, dynamic>)) // Convert maps to entries. // Konvertiert Maps in Einträge.
          .toList(); // Return as list. // Gibt als Liste zurück.
    }
    return []; // Return empty list if no entries stored. // Gibt leere Liste zurück, wenn keine Einträge gespeichert sind.
  }

  void setYearlyTimeframes(List<TimeframeEntry> timeframes) async { // Method to store yearly timeframe entries. // Methode zum Speichern jährlicher Zeitrahmeneinträge.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final List<Map<String, dynamic>> timeframesMap = 
        timeframes.map((entry) => entry.toMap()).toList(); // Convert entries to maps. // Konvertiert Einträge in Maps.
    await preferences.setString('yearlyTimeframes', jsonEncode(timeframesMap)); // Store as JSON string. // Speichert als JSON-Zeichenfolge.
    print("setYearlyTimeframes called with ${timeframes.length} entries"); // Debug print for entries count. // Debug-Ausgabe für Eintragsanzahl.
  }

  Future<List<TimeframeEntry>> getYearlyTimeframes() async { // Method to retrieve yearly timeframe entries. // Methode zum Abrufen jährlicher Zeitrahmeneinträge.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    final String? timeframesString = preferences.getString('yearlyTimeframes'); // Get stored JSON string. // Holt gespeicherte JSON-Zeichenfolge.
    if (timeframesString != null) { // Check if timeframes are stored. // Prüft, ob Zeitrahmen gespeichert sind.
      final List<dynamic> decodedList = jsonDecode(timeframesString); // Decode JSON to list. // Dekodiert JSON zu Liste.
      return decodedList
          .map((entry) => TimeframeEntry.fromMap(entry as Map<String, dynamic>)) // Convert maps to entries. // Konvertiert Maps in Einträge.
          .toList(); // Return as list. // Gibt als Liste zurück.
    }
    return []; // Return empty list if no entries stored. // Gibt leere Liste zurück, wenn keine Einträge gespeichert sind.
  }

  Future<void> clearProjectTimeframes(int projectIndex) async { // Method to clear timeframes for a specific project. // Methode zum Löschen von Zeitrahmen für ein bestimmtes Projekt.
    SharedPreferences preferences = await SharedPreferences.getInstance(); // Get shared preferences instance. // Holt Shared Preferences-Instanz.
    
    final weeklyTimeframes = await getWeeklyTimeframes(); // Get current weekly timeframes. // Holt aktuelle wöchentliche Zeitrahmen.
    final filteredWeekly = weeklyTimeframes.where((tf) => tf.projectIndex != projectIndex).toList(); // Filter out project timeframes. // Filtert Projekt-Zeitrahmen heraus.
    setWeeklyTimeframes(filteredWeekly); // Save filtered weekly timeframes. // Speichert gefilterte wöchentliche Zeitrahmen.
    
    final monthlyTimeframes = await getMonthlyTimeframes(); // Get current monthly timeframes. // Holt aktuelle monatliche Zeitrahmen.
    final filteredMonthly = monthlyTimeframes.where((tf) => tf.projectIndex != projectIndex).toList(); // Filter out project timeframes. // Filtert Projekt-Zeitrahmen heraus.
    setMonthlyTimeframes(filteredMonthly); // Save filtered monthly timeframes. // Speichert gefilterte monatliche Zeitrahmen.
    
    final yearlyTimeframes = await getYearlyTimeframes(); // Get current yearly timeframes. // Holt aktuelle jährliche Zeitrahmen.
    final filteredYearly = yearlyTimeframes.where((tf) => tf.projectIndex != projectIndex).toList(); // Filter out project timeframes. // Filtert Projekt-Zeitrahmen heraus.
    setYearlyTimeframes(filteredYearly); // Save filtered yearly timeframes. // Speichert gefilterte jährliche Zeitrahmen.
  }
}
