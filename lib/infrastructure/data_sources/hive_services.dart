/// HiveServices
/// 
/// A utility class that manages persistent data storage for the Pomodoro timer application. // Eine Utility-Klasse, die die persistente Datenspeicherung für die Pomodoro-Timer-Anwendung verwaltet.
/// Used throughout the application to store and retrieve timer settings, user progress, theme preferences, and todo items. // Wird in der gesamten Anwendung verwendet, um Timer-Einstellungen, Benutzerfortschritte, Theme-Präferenzen und Aufgabenelemente zu speichern und abzurufen.
/// 
/// Usage:
/// ```dart
/// // Save a timer value
/// await HiveServices.saveTimerValue(HiveServices.pomodoroKey, 25);
/// 
/// // Retrieve a timer value
/// final pomodoroMinutes = await HiveServices.retrieveDefaultPomodoroTimerValue(HiveServices.pomodoroKey);
/// ```
/// 
/// EN: Provides a centralized interface to the Hive key-value database with typed methods for each data category.
/// DE: Bietet eine zentralisierte Schnittstelle zur Hive-Schlüssel-Wert-Datenbank mit typisierten Methoden für jede Datenkategorie.

import 'package:flutter/material.dart';  // Imports the core Flutter material design package. // Importiert das Flutter Material-Design-Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:hive/hive.dart';  // Imports Hive, a lightweight and fast key-value database. // Importiert Hive, eine leichte und schnelle Schlüssel-Wert-Datenbank.
import 'package:intl/intl.dart';  // Imports internationalization and formatting for dates. // Importiert Internationalisierung und Formatierung für Datumsangaben.
import 'package:shared_preferences/shared_preferences.dart';  // Imports shared preferences for simple persistent storage. // Importiert SharedPreferences für einfache persistente Speicherung.

import '../../presentation/notifiers/providers.dart';  // Imports custom providers for state management. // Importiert benutzerdefinierte Provider für die Zustandsverwaltung.


class HiveServices {  // Defines a class for Hive database services. // Definiert eine Klasse für Hive-Datenbankdienste.
  static const boxName = "timerBox";  // Constant for the Hive box name. // Konstante für den Namen der Hive-Box.
  static const pomodoroKey = "pomodoroTimer";  // Key for pomodoro timer value. // Schlüssel für den Pomodoro-Timer-Wert.
  static const shortBreakKey = "shortBreakTimer";  // Key for short break timer value. // Schlüssel für den Kurzpausen-Timer-Wert.
  static const longBreakKey = "longBreakTimer";  // Key for long break timer value. // Schlüssel für den Langpausen-Timer-Wert.
  static const longBreakIntervalKey = "longBreakInterval";  // Key for interval between long breaks. // Schlüssel für das Intervall zwischen Langpausen.
  static const alarmSoundKey = "alarmSound";  // Key for alarm sound setting. // Schlüssel für die Alarmsoundeinstellung.
  static const notificationSwitchKey = "notificationSwitch";  // Key for notification toggle. // Schlüssel für den Benachrichtigungsschalter.
  static const pomodoroColorKey = "pomodoroColor";  // Key for pomodoro color theme. // Schlüssel für das Pomodoro-Farbthema.
  static const darkPomodoroColorKey = "darkPomodoroColor";  // Key for dark mode pomodoro color. // Schlüssel für die Pomodoro-Farbe im dunklen Modus.
  static const shortBreakColorKey = "shortBreakColor";  // Key for short break color theme. // Schlüssel für das Kurzpausen-Farbthema.
  static const darkShortBreakColorKey = "darkShortBreakColor";  // Key for dark mode short break color. // Schlüssel für die Kurzpausen-Farbe im dunklen Modus.
  static const longBreakColorKey = "longBreakColor";  // Key for long break color theme. // Schlüssel für das Langpausen-Farbthema.
  static const darkLongBreakColorKey = "darkLongBreakColor";  // Key for dark mode long break color. // Schlüssel für die Langpausen-Farbe im dunklen Modus.
  static const themeModeKey = "themeMode";  // Key for app theme mode (light/dark). // Schlüssel für den App-Themenmodus (hell/dunkel).
  static const userProgressKey = "userProgress";  // Key for user's progress data. // Schlüssel für die Fortschrittsdaten des Benutzers.
  static const currentTimerTypeKey = "currentTimerType";  // Key for current active timer type. // Schlüssel für den aktuellen aktiven Timer-Typ.
  static const ongoingPomodoroKey = "ongoingPomodoro";  // Key for tracking if pomodoro is running. // Schlüssel zur Verfolgung, ob Pomodoro läuft.
  static const unfinishedPomodoroKey = "unfinishedPomodoro";  // Key for tracking incomplete pomodoros. // Schlüssel zur Verfolgung unvollständiger Pomodoros.
  static const animationProgressKey = "animationProgress";  // Key for animation progress state. // Schlüssel für den Animationsfortschrittsstatus.
  static const baseHeightKey = "baseHeight";  // Key for UI base height setting. // Schlüssel für die UI-Basishöheneinstellung.
  static const todoListLengthKey = "todoListLength";  // Key for todo list length. // Schlüssel für die Länge der Aufgabenliste.
  static const checkboxStatePrefix = "checkboxState_";  // Prefix for todo checkbox states. // Präfix für Checkbox-Zustände der Aufgaben.
  static const titlePrefix = "title_";  // Prefix for todo titles. // Präfix für Aufgabentitel.
  static const descriptionPrefix = "description_";  // Prefix for todo descriptions. // Präfix für Aufgabenbeschreibungen.
  static const _keyToken = 'x-auth-token';  // Key for authentication token. // Schlüssel für das Authentifizierungs-Token.
  static const pomodoroDurationsKey = "pomodoroDurations";  // Key for storing pomodoro session durations. // Schlüssel zum Speichern der Pomodoro-Sitzungsdauern.
  static const pomodoroTimeKey = 'pomodoroRemainingTime';  // Key for remaining pomodoro time. // Schlüssel für die verbleibende Pomodoro-Zeit.
  static const shortBreakTimeKey = 'shortBreakRemainingTime';  // Key for remaining short break time. // Schlüssel für die verbleibende Kurzpausenzeit.
  static const longBreakTimeKey = 'longBreakRemainingTime';  // Key for remaining long break time. // Schlüssel für die verbleibende Langpausenzeit.
  static const lastPomodoroDateKey = 'lastPomodoroDateKey';  // Key for date of last pomodoro. // Schlüssel für das Datum des letzten Pomodoros.
  static const pomodoroEndTimeKey = 'pomodoroEndTime';  // Key for pomodoro end time. // Schlüssel für die Pomodoro-Endzeit.
  static const shortBreakEndTimeKey = 'shortBreakEndTime';  // Key for short break end time. // Schlüssel für die Kurzpausen-Endzeit.
  static const longBreakEndTimeKey = 'longBreakEndTime';  // Key for long break end time. // Schlüssel für die Langpausen-Endzeit.

  static Future<Box> openBox() async {  // Opens and returns the Hive box. // Öffnet und gibt die Hive-Box zurück.
    return await Hive.openBox(boxName);  // Opens the box with the specified name. // Öffnet die Box mit dem angegebenen Namen.
  }

  static Future<void> saveTimerValue(String key, int value) async {  // Saves a timer value to the box. // Speichert einen Timer-Wert in der Box.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(key, value);  // Stores the value with the specified key. // Speichert den Wert mit dem angegebenen Schlüssel.
  }

  static Future<int> retrieveDefaultPomodoroTimerValue(String key) async {  // Gets the default pomodoro timer value. // Holt den Standard-Pomodoro-Timer-Wert.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(key, defaultValue: 25);  // Returns the value or 25 if not found. // Gibt den Wert zurück oder 25, wenn nicht gefunden.
  }
  
  /// * MONGO DB
  static Future<int> retrieveDefaultShortBreakTimerValue(String key) async {  // Gets the default short break timer value. // Holt den Standard-Kurzpausen-Timer-Wert.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(key, defaultValue: 5);  // Returns the value or 5 if not found. // Gibt den Wert zurück oder 5, wenn nicht gefunden.
  }

  static Future<int> retrieveDefaultLongBreakTimerValue(String key) async {  // Gets the default long break timer value. // Holt den Standard-Langpausen-Timer-Wert.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(key, defaultValue: 15);  // Returns the value or 15 if not found. // Gibt den Wert zurück oder 15, wenn nicht gefunden.
  }

  static Future<int> retrieveDefaultLongBreakIntervalValue(String key) async {  // Gets the default long break interval. // Holt das Standard-Langpausen-Intervall.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(key, defaultValue: 4);  // Returns the value or 4 if not found. // Gibt den Wert zurück oder 4, wenn nicht gefunden.
  }

  static Future<void> saveAllTimerValues(int pomodoro, int shortBreak,
      int longBreak, int longBreakInterval) async {  // Saves all timer values at once. // Speichert alle Timer-Werte auf einmal.
    await saveTimerValue(pomodoroKey, pomodoro);  // Saves pomodoro timer value. // Speichert den Pomodoro-Timer-Wert.
    await saveTimerValue(shortBreakKey, shortBreak);  // Saves short break timer value. // Speichert den Kurzpausen-Timer-Wert.
    await saveTimerValue(longBreakKey, longBreak);  // Saves long break timer value. // Speichert den Langpausen-Timer-Wert.
    await saveTimerValue(longBreakIntervalKey, longBreakInterval);  // Saves long break interval value. // Speichert den Langpausen-Intervall-Wert.
  }

  static Future<void> retrieveAllTimerValues(Ref ref) async {  // Retrieves all timer values using Riverpod. // Ruft alle Timer-Werte mit Riverpod ab.
    ref.read(pomodoroTimerProvider.notifier).state =
        await retrieveDefaultPomodoroTimerValue(pomodoroKey);  // Updates pomodoro timer provider state. // Aktualisiert den Pomodoro-Timer-Provider-Status.
    ref.read(shortBreakProvider.notifier).state =
        await retrieveDefaultShortBreakTimerValue(shortBreakKey);  // Updates short break timer provider state. // Aktualisiert den Kurzpausen-Timer-Provider-Status.
    ref.read(longBreakProvider.notifier).state =
        await retrieveDefaultLongBreakTimerValue(longBreakKey);  // Updates long break timer provider state. // Aktualisiert den Langpausen-Timer-Provider-Status.
    ref.read(longBreakIntervalProvider.notifier).state =
        await retrieveDefaultLongBreakIntervalValue(longBreakIntervalKey);  // Updates long break interval provider state. // Aktualisiert den Langpausen-Intervall-Provider-Status.
  }

  static Future<void> saveAlarmSoundValue(String value) async {  // Saves alarm sound path. // Speichert den Alarmsoundpfad.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(alarmSoundKey, value);  // Stores the sound file path. // Speichert den Sounddateipfad.
  }

  static Future<String> retrieveAlarmSoundValue() async {  // Gets the alarm sound path. // Holt den Alarmsoundpfad.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(alarmSoundKey, defaultValue: 'assets/sounds/Flashpoint.wav');  // Returns the sound path or default. // Gibt den Soundpfad oder den Standardwert zurück.
  }

  static Future<void> saveNotificationSwitchState(bool state) async {  // Saves notification toggle state. // Speichert den Benachrichtigungsschalterstand.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(notificationSwitchKey, state);  // Stores the notification toggle state. // Speichert den Zustand des Benachrichtigungsschalters.
  }

  static Future<bool> retrieveNotificationSwitchState() async {  // Gets the notification toggle state. // Holt den Benachrichtigungsschalterstand.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(notificationSwitchKey, defaultValue: false);  // Returns the toggle state or false. // Gibt den Schalterstand oder false zurück.
  }

  static Future<void> saveColorValue(String key, Color value) async {  // Saves a color value. // Speichert einen Farbwert.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(key, value.value);  // Stores the color value (as integer). // Speichert den Farbwert (als Ganzzahl).
  }

  static Future<Color> retrieveColorValue(
      String key, Color defaultValue) async {  // Retrieves a color value. // Ruft einen Farbwert ab.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    int colorValue = box.get(key, defaultValue: defaultValue.value);  // Gets the color value or default. // Holt den Farbwert oder den Standardwert.
    return Color(colorValue);  // Returns a Color object from the integer value. // Gibt ein Color-Objekt aus dem Ganzzahlwert zurück.
  }

  static Future<void> saveAllColorValues(
    
      Color darkPomodoroColor,
      Color darkShortBreakColor,
      Color darkLongBreakColor) async {  // Saves all dark mode color values. // Speichert alle Farbwerte des dunklen Modus.
    await saveColorValue(darkPomodoroColorKey, darkPomodoroColor);  // Saves dark pomodoro color. // Speichert die dunkle Pomodoro-Farbe.
    await saveColorValue(darkShortBreakColorKey, darkShortBreakColor);  // Saves dark short break color. // Speichert die dunkle Kurzpausen-Farbe.
    await saveColorValue(darkLongBreakColorKey, darkLongBreakColor);  // Saves dark long break color. // Speichert die dunkle Langpausen-Farbe.
  }

  static Future<void> retrieveAllColorValues(Ref ref) async {  // Retrieves all color values using Riverpod. // Ruft alle Farbwerte mit Riverpod ab.
    ref.read(darkPomodoroColorProvider.notifier).state =
        await retrieveColorValue(darkPomodoroColorKey, const Color.fromARGB(255, 0, 0, 0));  // Updates dark pomodoro color provider state. // Aktualisiert den dunklen Pomodoro-Farb-Provider-Status.
    ref.read(darkShortBreakColorProvider.notifier).state =
        await retrieveColorValue(
            darkShortBreakColorKey, const Color.fromARGB(255, 0, 0, 0));  // Updates dark short break color provider state. // Aktualisiert den dunklen Kurzpausen-Farb-Provider-Status.

    ref.read(darkLongBreakColorProvider.notifier).state =
        await retrieveColorValue(
            darkLongBreakColorKey, const Color.fromARGB(255, 0, 0, 0));  // Updates dark long break color provider state. // Aktualisiert den dunklen Langpausen-Farb-Provider-Status.
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {  // Saves the app theme mode. // Speichert den App-Themenmodus.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(themeModeKey, mode == ThemeMode.dark ? 'dark' : 'dark');  // Stores the theme mode as string (note: always saves 'dark'). // Speichert den Themenmodus als String (Hinweis: speichert immer 'dark').
  }

  static Future<ThemeMode> retrieveThemeMode() async {  // Gets the app theme mode. // Holt den App-Themenmodus.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    String mode = box.get(themeModeKey, defaultValue: 'dark');  // Gets the theme mode string or default. // Holt den Themenmodus-String oder den Standardwert.
    return mode == 'dark' ? ThemeMode.dark : ThemeMode.light;  // Returns ThemeMode enum based on string. // Gibt ThemeMode-Enum basierend auf String zurück.
  }

  static Future<void> saveUserProgress(List<bool> progress) async {  // Saves user progress as boolean list. // Speichert den Benutzerfortschritt als Boolean-Liste.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(userProgressKey, progress);  // Stores the progress list. // Speichert die Fortschrittsliste.
  }

  static Future<List<bool>> retrieveUserProgress() async {  // Gets the user progress list. // Holt die Benutzerfortschrittsliste.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    List<dynamic> dynamicList = box.get(userProgressKey, defaultValue: []);  // Gets progress as dynamic list or empty list. // Holt den Fortschritt als dynamische Liste oder leere Liste.
    return dynamicList.cast<bool>();  // Casts to list of booleans. // Wandelt in eine Liste von Booleans um.
  }

  static Future<void> saveCurrentTimerType(String timerType) async {  // Saves current timer type. // Speichert den aktuellen Timer-Typ.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(currentTimerTypeKey, timerType);  // Stores the timer type string. // Speichert den Timer-Typ-String.
  }

  static Future<String> retrieveCurrentTimerType() async {  // Gets the current timer type. // Holt den aktuellen Timer-Typ.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(currentTimerTypeKey, defaultValue: 'Pomodoro');  // Returns timer type or 'Pomodoro'. // Gibt den Timer-Typ oder 'Pomodoro' zurück.
  }

  static Future<void> saveOngoingPomodoro(bool ongoingPomodoro) async {  // Saves ongoing pomodoro state. // Speichert den laufenden Pomodoro-Status.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(ongoingPomodoroKey, ongoingPomodoro);  // Stores the boolean state. // Speichert den Boolean-Status.
  }

  static Future<bool> retrieveOngoingPomodoro() async {  // Gets the ongoing pomodoro state. // Holt den laufenden Pomodoro-Status.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(ongoingPomodoroKey, defaultValue: false);  // Returns state or false. // Gibt den Status oder false zurück.
  }

  static Future<void> saveUnfinishedPomodoro(bool unfinishedPomodoro) async {  // Saves unfinished pomodoro state. // Speichert den unvollständigen Pomodoro-Status.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(unfinishedPomodoroKey, unfinishedPomodoro);  // Stores the boolean state. // Speichert den Boolean-Status.
  }

  static Future<bool> retrieveUnfinishedPomodoro() async {  // Gets the unfinished pomodoro state. // Holt den unvollständigen Pomodoro-Status.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(unfinishedPomodoroKey, defaultValue: false);  // Returns state or false. // Gibt den Status oder false zurück.
  }

  static Future<void> saveAnimationProgress(double progress) async {  // Saves animation progress value. // Speichert den Animationsfortschrittswert.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(animationProgressKey, progress);  // Stores the double value. // Speichert den Double-Wert.
  }

  static Future<double> retrieveAnimationProgress() async {  // Gets the animation progress value. // Holt den Animationsfortschrittswert.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(animationProgressKey, defaultValue: 0.0);  // Returns progress or 0.0. // Gibt den Fortschritt oder 0.0 zurück.
  }

  static Future<void> saveBaseHeight(double height) async {  // Saves UI base height. // Speichert die UI-Basishöhe.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(baseHeightKey, height);  // Stores the height value. // Speichert den Höhenwert.
  }

  static Future<double> retrieveBaseHeight() async {  // Gets the UI base height. // Holt die UI-Basishöhe.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(baseHeightKey, defaultValue: 0.0);  // Returns height or 0.0. // Gibt die Höhe oder 0.0 zurück.
  }

  static Future<void> saveTodoListLength(int length) async {  // Saves todo list length. // Speichert die Länge der Aufgabenliste.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(todoListLengthKey, length);  // Stores the length value. // Speichert den Längenwert.
  }

  static Future<int> retrieveTodoListLength() async {  // Gets the todo list length. // Holt die Länge der Aufgabenliste.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(todoListLengthKey, defaultValue: 0);  // Returns length or 0. // Gibt die Länge oder 0 zurück.
  }

  static Future<void> saveCheckboxState(String todoId, bool isActive) async {  // Saves checkbox state for a todo item. // Speichert den Checkbox-Zustand für ein Aufgabenelement.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(checkboxStatePrefix + todoId, isActive);  // Stores the boolean state with prefixed ID. // Speichert den Boolean-Zustand mit vorangestellter ID.
  }

  static Future<bool?> retrieveCheckboxState(String todoId) async {  // Gets the checkbox state for a todo item. // Holt den Checkbox-Zustand für ein Aufgabenelement.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    bool? value = box.get(
      checkboxStatePrefix + todoId,
    );  // Gets the checkbox state without default. // Holt den Checkbox-Zustand ohne Standardwert.
    return value;  // Returns the state or null. // Gibt den Zustand oder null zurück.
  }

  static Future<void> deleteCheckboxState(String todoId) async {  // Deletes a todo checkbox state. // Löscht einen Aufgaben-Checkbox-Zustand.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.delete(checkboxStatePrefix + todoId);  // Removes the entry with prefixed ID. // Entfernt den Eintrag mit vorangestellter ID.
  }

  static Future<void> saveTodoTitle(String todoId, String title) async {  // Saves todo title. // Speichert den Aufgabentitel.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(titlePrefix + todoId, title);  // Stores the title with prefixed ID. // Speichert den Titel mit vorangestellter ID.
  }

  static Future<String?> retrieveTodoTitle(String todoId) async {  // Gets the todo title. // Holt den Aufgabentitel.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(titlePrefix + todoId);  // Returns the title or null. // Gibt den Titel oder null zurück.
  }

  static Future<void> saveTodoDescription(
      String todoId, String description) async {  // Saves todo description. // Speichert die Aufgabenbeschreibung.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(descriptionPrefix + todoId, description);  // Stores the description with prefixed ID. // Speichert die Beschreibung mit vorangestellter ID.
  }

  static Future<String?> retrieveTodoDescription(String todoId) async {  // Gets the todo description. // Holt die Aufgabenbeschreibung.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get(descriptionPrefix + todoId);  // Returns the description or null. // Gibt die Beschreibung oder null zurück.
  }

  static Future<void> deleteTodoTitle(String todoId) async {  // Deletes a todo title. // Löscht einen Aufgabentitel.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.delete(titlePrefix + todoId);  // Removes the entry with prefixed ID. // Entfernt den Eintrag mit vorangestellter ID.
  }

  static Future<void> deleteTodoDescription(String todoId) async {  // Deletes a todo description. // Löscht eine Aufgabenbeschreibung.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.delete(descriptionPrefix + todoId);  // Removes the entry with prefixed ID. // Entfernt den Eintrag mit vorangestellter ID.
  }

  static Future<void> saveTodoUUIDList(List<String> uuidList) async {  // Saves list of todo UUIDs. // Speichert eine Liste von Aufgaben-UUIDs.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put('uuidList', uuidList);  // Stores the UUID list. // Speichert die UUID-Liste.
  }

  static Future<List<String>?> retrieveTodoUUIDList() async {  // Gets the list of todo UUIDs. // Holt die Liste der Aufgaben-UUIDs.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    var retrievedList = box.get('uuidList');  // Gets the UUID list. // Holt die UUID-Liste.

    if (retrievedList != null) {  // Checks if list exists. // Prüft, ob die Liste existiert.
      return List<String>.from(retrievedList);  // Casts to list of strings. // Wandelt in eine Liste von Strings um.
    }
    return null;  // Returns null if no list found. // Gibt null zurück, wenn keine Liste gefunden wurde.
  }

  static Future<void> deleteTodoUUID(String uuidToDelete) async {  // Removes a UUID from the list. // Entfernt eine UUID aus der Liste.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    var currentUUIDList = box.get('uuidList');  // Gets the UUID list. // Holt die UUID-Liste.

    if (currentUUIDList != null) {  // Checks if list exists. // Prüft, ob die Liste existiert.
      List<String> updatedList = List<String>.from(currentUUIDList);  // Creates a mutable copy of the list. // Erstellt eine veränderbare Kopie der Liste.
      updatedList.remove(uuidToDelete);  // Removes the UUID from the list. // Entfernt die UUID aus der Liste.
      box.put('uuidList', updatedList);  // Stores the updated list. // Speichert die aktualisierte Liste.
    }
  }

  static Future<void> saveFocusedTodoUUID(String? uuid) async {  // Saves UUID of focused todo item. // Speichert die UUID des fokussierten Aufgabenelements.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put('focusedUUID', uuid);  // Stores the UUID or null. // Speichert die UUID oder null.
  }

  static Future<String?> retrieveFocusedTodoUUID() async {  // Gets the UUID of focused todo item. // Holt die UUID des fokussierten Aufgabenelements.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    return box.get('focusedUUID');  // Returns the UUID or null. // Gibt die UUID oder null zurück.
  }

  static Future<void> saveTodoFocusState(String id, bool isFocused) async {  // Saves focus state of a todo item. // Speichert den Fokus-Zustand eines Aufgabenelements.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    await box.put('$id-isFocused', isFocused);  // Stores the focus state with ID-based key. // Speichert den Fokus-Zustand mit ID-basiertem Schlüssel.
  }

  static Future<void> setToken(String token) async {  // Saves authentication token. // Speichert das Authentifizierungs-Token.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put(_keyToken, token);  // Stores the token. // Speichert das Token.
  }

  static Future<String?> getToken() async {  // Gets the authentication token. // Holt das Authentifizierungs-Token.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    String? token = box.get(_keyToken);  // Gets the token without default. // Holt das Token ohne Standardwert.
    return token;  // Returns the token or null. // Gibt das Token oder null zurück.
  }

  static Future<void> savePomodoroDuration(Duration duration) async {  // Saves completed pomodoro duration. // Speichert die abgeschlossene Pomodoro-Dauer.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});  // Gets existing durations map or empty map. // Holt die vorhandene Dauern-Map oder eine leere Map.
    Map<String, int> durations =
        rawDurations.map((key, value) => MapEntry(key as String, value as int));  // Casts to Map<String, int>. // Wandelt in Map<String, int> um.

    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());  // Gets today's date as formatted string. // Holt das heutige Datum als formatierten String.

    if (durations.containsKey(today)) {  // Checks if entry exists for today. // Prüft, ob bereits ein Eintrag für heute existiert.
      durations[today] = durations[today]! + duration.inSeconds;  // Adds duration to today's total. // Fügt die Dauer zum heutigen Gesamtwert hinzu.
    } else {
      durations[today] = duration.inSeconds;  // Creates new entry for today. // Erstellt einen neuen Eintrag für heute.
    }

    box.put(pomodoroDurationsKey, durations);  // Stores the updated durations map. // Speichert die aktualisierte Dauern-Map.
  }


  static Future<Map<String, Duration>>
      retrievePomodoroDurationsForWeek() async {  // Gets pomodoro durations for the past week. // Holt die Pomodoro-Dauern für die vergangene Woche.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});  // Gets durations map or empty map. // Holt die Dauern-Map oder eine leere Map.
    DateTime now = DateTime.now();  // Gets current date/time. // Holt das aktuelle Datum/Uhrzeit.
    DateTime lastWeek = now.subtract(const Duration(days: 7));  // Calculates date 7 days ago. // Berechnet das Datum vor 7 Tagen.

    Map<String, Duration> weeklyData = {};  // Creates map for filtered data. // Erstellt eine Map für gefilterte Daten.
    rawDurations.forEach((key, value) {  // Iterates through all duration entries. // Iteriert durch alle Dauereinträge.
      DateTime date = DateFormat('dd/MM/yyyy').parse(key);  // Parses string date to DateTime. // Analysiert das String-Datum zu DateTime.
      if (date.isAfter(lastWeek)) {  // Checks if date is within last week. // Prüft, ob das Datum innerhalb der letzten Woche liegt.
        weeklyData[key as String] = Duration(seconds: value as int);  // Adds entry to weekly data. // Fügt den Eintrag zu den Wochendaten hinzu.
      }
    });
    return weeklyData;  // Returns filtered data for last week. // Gibt gefilterte Daten für die letzte Woche zurück.
  }

  static Future<Map<String, Duration>>
      retrievePomodoroDurationsForMonth() async {  // Gets pomodoro durations for the past month. // Holt die Pomodoro-Dauern für den vergangenen Monat.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});  // Gets durations map or empty map. // Holt die Dauern-Map oder eine leere Map.
    DateTime now = DateTime.now();  // Gets current date/time. // Holt das aktuelle Datum/Uhrzeit.
    DateTime startDate = DateTime(now.year, now.month - 1, now.day);  // Calculates date one month ago. // Berechnet das Datum vor einem Monat.

    Map<String, Duration> monthlyData = {};  // Creates map for monthly data. // Erstellt eine Map für monatliche Daten.
    Map<String, Duration> yearlyData = {};  // Creates map for yearly data (unused). // Erstellt eine Map für jährliche Daten (ungenutzt).

    for (int i = 0; i <= now.difference(startDate).inDays; i++) {  // Iterates through each day in the month. // Iteriert durch jeden Tag im Monat.
      String key =
          DateFormat('dd/MM/yyyy').format(startDate.add(Duration(days: i)));  // Formats date string for each day. // Formatiert den Datumsstring für jeden Tag.
      if (rawDurations.containsKey(key)) {  // Checks if data exists for this day. // Prüft, ob Daten für diesen Tag existieren.
        monthlyData[key] = Duration(seconds: rawDurations[key] as int);  // Adds actual duration. // Fügt die tatsächliche Dauer hinzu.
      } else {
        monthlyData[key] = Duration.zero;  // Adds zero duration for days without data. // Fügt die Dauer Null für Tage ohne Daten hinzu.
      }
    }
    for (int i = 0; i < 7 * 53; i++) {  // Iterates through days for a year (unused). // Iteriert durch Tage für ein Jahr (ungenutzt).
      DateTime date = DateTime.now().subtract(Duration(days: i));  // Calculates date for each day. // Berechnet das Datum für jeden Tag.
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);  // Formats date string. // Formatiert den Datumsstring.
      yearlyData[formattedDate] = const Duration(seconds: 0);  // Sets zero duration (unused). // Setzt die Dauer Null (ungenutzt).
    }

    return monthlyData;  // Returns monthly data. // Gibt die monatlichen Daten zurück.
  }

  static Future<Map<String, Duration>>
      retrievePomodoroDurationsForYear() async {  // Gets pomodoro durations for the current year. // Holt die Pomodoro-Dauern für das aktuelle Jahr.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});  // Gets durations map or empty map. // Holt die Dauern-Map oder eine leere Map.
    DateTime now = DateTime.now();  // Gets current date/time. // Holt das aktuelle Datum/Uhrzeit.

    Map<int, Duration> monthlyData = {};  // Creates map for monthly totals. // Erstellt eine Map für monatliche Gesamtwerte.
    for (var i = 1; i <= 12; i++) {  // Initializes all months with zero duration. // Initialisiert alle Monate mit der Dauer Null.
      monthlyData[i] = Duration.zero;
    }

    rawDurations.forEach((key, value) {  // Iterates through all duration entries. // Iteriert durch alle Dauereinträge.
      DateTime date = DateFormat('dd/MM/yyyy').parse(key);  // Parses string date to DateTime. // Analysiert das String-Datum zu DateTime.
      if (date.year == now.year) {  // Checks if date is in current year. // Prüft, ob das Datum im aktuellen Jahr liegt.
        monthlyData[date.month] =
            monthlyData[date.month]! + Duration(seconds: value as int);  // Adds duration to monthly total. // Fügt die Dauer zum monatlichen Gesamtwert hinzu.
      }
    });

    Map<String, Duration> result = {};  // Creates map with month names. // Erstellt eine Map mit Monatsnamen.
    monthlyData.forEach((month, duration) {  // Converts month numbers to names. // Wandelt Monatszahlen in Namen um.
      String monthName = DateFormat('MMM').format(DateTime(now.year, month));  // Gets short month name. // Holt den kurzen Monatsnamen.
      result[monthName] = duration;  // Adds entry with month name. // Fügt den Eintrag mit Monatsnamen hinzu.
    });

    Map<String, Duration> sortedResult = {};  // Creates map for sorted result. // Erstellt eine Map für das sortierte Ergebnis.
    List<String> sortedMonths = generateYearMonths();  // Gets sorted month names. // Holt sortierte Monatsnamen.
    for (var month in sortedMonths) {  // Reorders months in desired sequence. // Ordnet die Monate in der gewünschten Reihenfolge an.
      if (result.containsKey(month)) {  // Checks if month exists in result. // Prüft, ob der Monat im Ergebnis existiert.
        sortedResult[month] = result[month]!;  // Adds month to sorted result. // Fügt den Monat zum sortierten Ergebnis hinzu.
      }
    }

    return sortedResult;  // Returns sorted yearly data by month. // Gibt sortierte Jahresdaten nach Monat zurück.
  }

  static List<String> generateYearMonths() {  // Generates a list of month names in specific order. // Generiert eine Liste von Monatsnamen in bestimmter Reihenfolge.
    final now = DateTime.now();  // Gets current date/time. // Holt das aktuelle Datum/Uhrzeit.
    List<String> months = List.generate(
      12,
      (index) => DateFormat('MMM').format(
        DateTime(now.year, index + 1),
      ),  // Generates all 12 month names. // Generiert alle 12 Monatsnamen.
    );
    return [...months.sublist(now.month), ...months.sublist(0, now.month)];  // Orders months from current to end, then start to current. // Ordnet Monate vom aktuellen bis zum Ende, dann vom Anfang bis zum aktuellen.
  }



  static Future<Map<String, Duration>> retrieveGithubYearlyChartData() async {  // Gets data for GitHub-style year chart. // Holt Daten für ein GitHub-Stil-Jahresdiagramm.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    Map<dynamic, dynamic> rawData =
        box.get(pomodoroDurationsKey, defaultValue: {});  // Gets durations map or empty map. // Holt die Dauern-Map oder eine leere Map.

    DateTime today = DateTime.now();  // Gets current date/time. // Holt das aktuelle Datum/Uhrzeit.
    Map<String, Duration> yearlyData = {};  // Creates map for yearly data. // Erstellt eine Map für jährliche Daten.

    for (int i = 0; i < 365; i++) {  // Initializes 365 days with zero duration. // Initialisiert 365 Tage mit der Dauer Null.
      DateTime date = today.subtract(Duration(days: i));  // Calculates date for each day. // Berechnet das Datum für jeden Tag.
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);  // Formats date string. // Formatiert den Datumsstring.
      yearlyData[formattedDate] = const Duration(seconds: 0);  // Sets zero duration initially. // Setzt anfänglich die Dauer Null.
    }

    rawData.forEach((key, value) {  // Updates with actual data where exists. // Aktualisiert mit tatsächlichen Daten, wo vorhanden.
      DateTime date = DateFormat('dd/MM/yyyy').parse(key as String);  // Parses string date to DateTime. // Analysiert das String-Datum zu DateTime.
      String dateKey = DateFormat('dd/MM/yyyy').format(date);  // Reformats date string. // Formatiert den Datumsstring neu.
      yearlyData.update(
          dateKey, (existing) => existing + Duration(seconds: value as int),
          ifAbsent: () => Duration(seconds: value as int));  // Updates or adds duration. // Aktualisiert oder fügt die Dauer hinzu.
    });

    return yearlyData;  // Returns data for all days in past year. // Gibt Daten für alle Tage im vergangenen Jahr zurück.
  }



  static Future<void> saveRemainingTimerValue(
      String timerType, int value) async {  // Saves remaining time for a timer type. // Speichert die verbleibende Zeit für einen Timer-Typ.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    String key;  // Declares key variable. // Deklariert die Schlüsselvariable.
    switch (timerType) {  // Determines key based on timer type. // Bestimmt den Schlüssel basierend auf dem Timer-Typ.
      case 'Pomodoro':
        key = pomodoroTimeKey;  // Sets key for pomodoro timer. // Setzt den Schlüssel für den Pomodoro-Timer.
        break;
      case 'Short Break':
        key = shortBreakTimeKey;  // Sets key for short break timer. // Setzt den Schlüssel für den Kurzpausen-Timer.
        break;
      case 'Long Break':
        key = longBreakTimeKey;  // Sets key for long break timer. // Setzt den Schlüssel für den Langpausen-Timer.
        break;
      default:
        return;  // Exits if invalid timer type. // Beendet, wenn ungültiger Timer-Typ.
    }
    box.put(key, value);  // Stores the time value. // Speichert den Zeitwert.
  }

  static Future<int> retrieveRemainingTimerValue(String timerType) async {  // Gets remaining time for a timer type. // Holt die verbleibende Zeit für einen Timer-Typ.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    String? key;  // Declares key variable. // Deklariert die Schlüsselvariable.
    switch (timerType) {  // Determines key based on timer type. // Bestimmt den Schlüssel basierend auf dem Timer-Typ.
      case 'Pomodoro':
        key = pomodoroTimeKey;  // Sets key for pomodoro timer. // Setzt den Schlüssel für den Pomodoro-Timer.
        break;
      case 'Short Break':
        key = shortBreakTimeKey;  // Sets key for short break timer. // Setzt den Schlüssel für den Kurzpausen-Timer.
        break;
      case 'Long Break':
        key = longBreakTimeKey;  // Sets key for long break timer. // Setzt den Schlüssel für den Langpausen-Timer.
        break;
      default:
        key = null;  // Sets null for invalid timer type. // Setzt null für ungültigen Timer-Typ.
    }
    if (key == null) {  // Checks if key is valid. // Prüft, ob der Schlüssel gültig ist.
      throw Exception('Unsupported timer type: $timerType');  // Throws exception for invalid type. // Wirft eine Ausnahme für ungültigen Typ.
    }
    return box.get(key);  // Returns the time value. // Gibt den Zeitwert zurück.
  }

  static Future<void> saveStartTime(DateTime startTime) async {  // Saves timer start time. // Speichert die Timer-Startzeit.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    box.put('startTimeKey', startTime.toIso8601String());  // Stores time as ISO string. // Speichert die Zeit als ISO-String.
  }

  static Future<DateTime?> retrieveStartTime() async {  // Gets timer start time. // Holt die Timer-Startzeit.
    final box = await openBox();  // Gets the Hive box. // Holt die Hive-Box.
    String? isoDate = box.get('startTimeKey');  // Gets ISO date string. // Holt den ISO-Datumsstring.
    if (isoDate != null) {  // Checks if date exists. // Prüft, ob das Datum existiert.
      return DateTime.parse(isoDate);  // Parses string to DateTime. // Analysiert den String zu DateTime.
    }
    return null;  // Returns null if no date found. // Gibt null zurück, wenn kein Datum gefunden wurde.
  }

  Future<void> setCsrfToken(String csrfToken) async {  // Saves CSRF token using SharedPreferences. // Speichert das CSRF-Token mit SharedPreferences.
    final prefs = await SharedPreferences.getInstance();  // Gets SharedPreferences instance. // Holt die SharedPreferences-Instanz.
    await prefs.setString('csrfToken', csrfToken);  // Stores the token. // Speichert das Token.
  }

  Future<String?> getCsrfToken() async {  // Gets CSRF token from SharedPreferences. // Holt das CSRF-Token aus SharedPreferences.
    final prefs = await SharedPreferences.getInstance();  // Gets SharedPreferences instance. // Holt die SharedPreferences-Instanz.
    return prefs.getString('csrfToken');  // Returns the token or null. // Gibt das Token oder null zurück.
  }
}
