/// UserModel
/// 
/// A comprehensive data model that stores all user-related information for a Pomodoro timer application. // Ein umfassendes Datenmodell, das alle benutzerbezogenen Informationen für eine Pomodoro-Timer-Anwendung speichert.
/// Used to maintain user profile details, application preferences, subscription status, timer settings, project data, and time tracking records. // Wird verwendet, um Benutzerprofildetails, Anwendungseinstellungen, Abonnementstatus, Timer-Einstellungen, Projektdaten und Zeiterfassungsaufzeichnungen zu verwalten.
/// 
/// Usage:
/// ```dart
/// // Create a new user model
/// final user = UserModel(
///   email: 'user@example.com',
///   name: 'User Name',
///   // ... other required fields
/// );
/// 
/// // Convert user model to JSON for storage
/// final jsonString = user.toJson();
/// 
/// // Update user settings
/// final updatedUser = user.copyWith(pomodoroTimer: 25);
/// ```
/// 
/// EN: Provides a complete structure for storing and managing all user data with serialization/deserialization capabilities.
/// DE: Bietet eine vollständige Struktur zum Speichern und Verwalten aller Benutzerdaten mit Serialisierungs-/Deserialisierungsfunktionen.

import 'dart:convert'; // Imports JSON encoding and decoding functionality. // Importiert Funktionen zur JSON-Codierung und -Decodierung.

import 'timeframe_entry.dart'; // Imports the TimeframeEntry class for time tracking data. // Importiert die TimeframeEntry-Klasse für Zeiterfassungsdaten.



class UserModel { // Defines the user model class that holds all user information. // Definiert die Benutzermodellklasse, die alle Benutzerinformationen enthält.
  final String email; // User's email address for identification and login. // E-Mail-Adresse des Benutzers zur Identifikation und Anmeldung.
  final String name; // User's display name. // Anzeigename des Benutzers.
  final String profilePic; // URL or path to the user's profile picture. // URL oder Pfad zum Profilbild des Benutzers.
  final String uid; // Unique identifier for the user. // Eindeutige Kennung für den Benutzer.
  final String token; // Authentication token for API access. // Authentifizierungs-Token für API-Zugriff.
  final bool isPremium; // Indicates if the user has premium access. // Gibt an, ob der Benutzer Premiumzugang hat.
  final String subscriptionId; // ID of the user's subscription plan. // ID des Abonnementplans des Benutzers.
  final bool suscriptionStatusCancelled; // Indicates if subscription has been cancelled. // Gibt an, ob das Abonnement gekündigt wurde.
  final bool subscriptionStatusConfirmed; // Indicates if subscription is confirmed. // Gibt an, ob das Abonnement bestätigt ist.
  final bool subscriptionStatusPending; // Indicates if subscription is pending confirmation. // Gibt an, ob das Abonnement auf Bestätigung wartet.
  final DateTime? nextBillingTime; // Next billing date for the subscription (nullable). // Nächstes Abrechnungsdatum für das Abonnement (nullable).
  final DateTime? startTimeSubscriptionPayPal; // Start time of PayPal subscription (nullable). // Startzeit des PayPal-Abonnements (nullable).
  final DateTime? paypalSubscriptionCancelledAt; // Cancellation time of PayPal subscription (nullable). // Kündigungszeit des PayPal-Abonnements (nullable).
  final DateTime? userLocalTimeZone; // User's local time zone (nullable). // Lokale Zeitzone des Benutzers (nullable).
  final int pomodoroTimer; // Duration of Pomodoro work sessions in minutes. // Dauer der Pomodoro-Arbeitssitzungen in Minuten.
  final int shortBreakTimer; // Duration of short breaks in minutes. // Dauer der kurzen Pausen in Minuten.
  final int longBreakTimer; // Duration of long breaks in minutes. // Dauer der langen Pausen in Minuten.
  final int longBreakInterval; // Number of Pomodoros before a long break. // Anzahl der Pomodoros vor einer langen Pause.
  final String selectedSound; // Selected notification sound. // Ausgewählter Benachrichtigungston.
  final bool browserNotificationsEnabled; // Whether browser notifications are enabled. // Ob Browser-Benachrichtigungen aktiviert sind.
  final String pomodoroColor; // Color code for Pomodoro sessions. // Farbcode für Pomodoro-Sitzungen.
  final String shortBreakColor; // Color code for short breaks. // Farbcode für kurze Pausen.
  final String longBreakColor; // Color code for long breaks. // Farbcode für lange Pausen.
  final List<bool> pomodoroStates; // List of completed Pomodoro states (true/false). // Liste der abgeschlossenen Pomodoro-Zustände (wahr/falsch).
  final bool toDoHappySadToggle; // Toggle for happy/sad emoji display in tasks. // Umschalter für die Anzeige von fröhlichen/traurigen Emojis in Aufgaben.
  final bool taskDeletionByTrashIcon; // Whether tasks can be deleted by trash icon. // Ob Aufgaben durch das Papierkorbsymbol gelöscht werden können.
  final String taskCardTitle; // Title for the task card display. // Titel für die Aufgabenkarten-Anzeige.
  final List<String> projectName; // List of project names. // Liste der Projektnamen.
  final int selectedContainerIndex; // Index of currently selected project. // Index des aktuell ausgewählten Projekts.
  final List<TimeframeEntry> weeklyTimeframes; // Time entries for weekly view. // Zeiteinträge für die Wochenansicht.
  final List<TimeframeEntry> monthlyTimeframes; // Time entries for monthly view. // Zeiteinträge für die Monatsansicht.
  final List<TimeframeEntry> yearlyTimeframes; // Time entries for yearly view. // Zeiteinträge für die Jahresansicht.


  UserModel({ // Constructor for creating UserModel instances. // Konstruktor zum Erstellen von UserModel-Instanzen.
    required this.email, // Required email parameter. // Erforderlicher E-Mail-Parameter.
    required this.name, // Required name parameter. // Erforderlicher Name-Parameter.
    required this.profilePic, // Required profile picture parameter. // Erforderlicher Profilbild-Parameter.
    required this.uid, // Required user ID parameter. // Erforderlicher Benutzer-ID-Parameter.
    required this.token, // Required authentication token parameter. // Erforderlicher Authentifizierungs-Token-Parameter.
    required this.isPremium, // Required premium status parameter. // Erforderlicher Premium-Status-Parameter.
    required this.subscriptionId, // Required subscription ID parameter. // Erforderlicher Abonnement-ID-Parameter.
    required this.suscriptionStatusCancelled, // Required subscription cancelled status parameter. // Erforderlicher Parameter für den Status "Abonnement gekündigt".
    required this.subscriptionStatusConfirmed, // Required subscription confirmed status parameter. // Erforderlicher Parameter für den Status "Abonnement bestätigt".
    required this.subscriptionStatusPending, // Required subscription pending status parameter. // Erforderlicher Parameter für den Status "Abonnement ausstehend".
    required this.nextBillingTime, // Required next billing time parameter (can be null). // Erforderlicher Parameter für die nächste Abrechnungszeit (kann null sein).
    required this.startTimeSubscriptionPayPal, // Required PayPal subscription start time parameter (can be null). // Erforderlicher Parameter für die Startzeit des PayPal-Abonnements (kann null sein).
    required this.paypalSubscriptionCancelledAt, // Required PayPal subscription cancellation time parameter (can be null). // Erforderlicher Parameter für die Kündigungszeit des PayPal-Abonnements (kann null sein).
    required this.userLocalTimeZone, // Required user local time zone parameter (can be null). // Erforderlicher Parameter für die lokale Zeitzone des Benutzers (kann null sein).
    required this.pomodoroTimer, // Required Pomodoro timer duration parameter. // Erforderlicher Parameter für die Pomodoro-Timer-Dauer.
    required this.shortBreakTimer, // Required short break timer duration parameter. // Erforderlicher Parameter für die Kurzpausen-Timer-Dauer.
    required this.longBreakTimer, // Required long break timer duration parameter. // Erforderlicher Parameter für die Langpausen-Timer-Dauer.
    required this.longBreakInterval, // Required long break interval parameter. // Erforderlicher Parameter für das Langpausen-Intervall.
    required this.selectedSound, // Required selected sound parameter. // Erforderlicher Parameter für den ausgewählten Ton.
    required this.browserNotificationsEnabled, // Required browser notifications status parameter. // Erforderlicher Parameter für den Browser-Benachrichtigungsstatus.
    required this.pomodoroColor, // Required Pomodoro color parameter. // Erforderlicher Parameter für die Pomodoro-Farbe.
    required this.shortBreakColor, // Required short break color parameter. // Erforderlicher Parameter für die Kurzpausen-Farbe.
    required this.longBreakColor, // Required long break color parameter. // Erforderlicher Parameter für die Langpausen-Farbe.
    required this.pomodoroStates, // Required Pomodoro states parameter. // Erforderlicher Parameter für Pomodoro-Zustände.
    required this.toDoHappySadToggle, // Required to-do happy/sad toggle parameter. // Erforderlicher Parameter für den To-Do-Fröhlich/Traurig-Umschalter.
    required this.taskDeletionByTrashIcon, // Required task deletion by trash icon parameter. // Erforderlicher Parameter für die Aufgabenlöschung durch das Papierkorbsymbol.
    required this.taskCardTitle, // Required task card title parameter. // Erforderlicher Parameter für den Aufgabenkartentitel.
    this.projectName = const ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '], // Default value for project names. // Standardwert für Projektnamen.
    required this.selectedContainerIndex, // Required selected container index parameter. // Erforderlicher Parameter für den ausgewählten Container-Index.
    required this.weeklyTimeframes, // Required weekly timeframes parameter. // Erforderlicher Parameter für wöchentliche Zeitrahmen.
    required this.monthlyTimeframes, // Required monthly timeframes parameter. // Erforderlicher Parameter für monatliche Zeitrahmen.
    required this.yearlyTimeframes, // Required yearly timeframes parameter. // Erforderlicher Parameter für jährliche Zeitrahmen.
  });

  Map<String, dynamic> toMap() { // Method to convert the UserModel to a Map for serialization. // Methode zum Konvertieren des UserModel in eine Map zur Serialisierung.
    return { // Returns a Map with keys and values representing the UserModel. // Gibt eine Map mit Schlüsseln und Werten zurück, die das UserModel repräsentieren.
      'email': email, // Maps email field. // Ordnet das E-Mail-Feld zu.
      'name': name, // Maps name field. // Ordnet das Name-Feld zu.
      'profilePic': profilePic, // Maps profile picture field. // Ordnet das Profilbild-Feld zu.
      'uid': uid, // Maps user ID field. // Ordnet das Benutzer-ID-Feld zu.
      'token': token, // Maps token field. // Ordnet das Token-Feld zu.
      'isPremium': isPremium, // Maps premium status field. // Ordnet das Premium-Status-Feld zu.
      'subscriptionId': subscriptionId, // Maps subscription ID field. // Ordnet das Abonnement-ID-Feld zu.
      'suscriptionStatusCancelled': suscriptionStatusCancelled, // Maps subscription cancelled status field. // Ordnet das Feld für den Status "Abonnement gekündigt" zu.
      'subscriptionStatusConfirmed': subscriptionStatusConfirmed, // Maps subscription confirmed status field. // Ordnet das Feld für den Status "Abonnement bestätigt" zu.
      'subscriptionStatusPending': subscriptionStatusPending, // Maps subscription pending status field. // Ordnet das Feld für den Status "Abonnement ausstehend" zu.
      'nextBillingTime': nextBillingTime?.toIso8601String(), // Maps next billing time to ISO string if not null. // Ordnet die nächste Abrechnungszeit als ISO-String zu, wenn nicht null.
      'startTimeSubscriptionPayPal':
          startTimeSubscriptionPayPal?.toIso8601String(), // Maps PayPal subscription start time to ISO string if not null. // Ordnet die Startzeit des PayPal-Abonnements als ISO-String zu, wenn nicht null.
      'paypalSubscriptionCancelledAt':
          paypalSubscriptionCancelledAt?.toIso8601String(), // Maps PayPal subscription cancellation time to ISO string if not null. // Ordnet die Kündigungszeit des PayPal-Abonnements als ISO-String zu, wenn nicht null.
      'userLocalTimeZone': userLocalTimeZone?.toIso8601String(), // Maps user local time zone to ISO string if not null. // Ordnet die lokale Zeitzone des Benutzers als ISO-String zu, wenn nicht null.
      'pomodoroTimer': pomodoroTimer, // Maps Pomodoro timer duration field. // Ordnet das Feld für die Pomodoro-Timer-Dauer zu.
      'shortBreakTimer': shortBreakTimer, // Maps short break timer duration field. // Ordnet das Feld für die Kurzpausen-Timer-Dauer zu.
      'longBreakTimer': longBreakTimer, // Maps long break timer duration field. // Ordnet das Feld für die Langpausen-Timer-Dauer zu.
      'longBreakInterval': longBreakInterval, // Maps long break interval field. // Ordnet das Feld für das Langpausen-Intervall zu.
      'selectedSound': selectedSound, // Maps selected sound field. // Ordnet das Feld für den ausgewählten Ton zu.
      'browserNotificationsEnabled': browserNotificationsEnabled, // Maps browser notifications status field. // Ordnet das Feld für den Browser-Benachrichtigungsstatus zu.
      'pomodoroColor': pomodoroColor, // Maps Pomodoro color field. // Ordnet das Feld für die Pomodoro-Farbe zu.
      'shortBreakColor': shortBreakColor, // Maps short break color field. // Ordnet das Feld für die Kurzpausen-Farbe zu.
      'longBreakColor': longBreakColor, // Maps long break color field. // Ordnet das Feld für die Langpausen-Farbe zu.
      'pomodoroStates': pomodoroStates, // Maps Pomodoro states field. // Ordnet das Feld für Pomodoro-Zustände zu.
      'toDoHappySadToggle': toDoHappySadToggle, // Maps to-do happy/sad toggle field. // Ordnet das Feld für den To-Do-Fröhlich/Traurig-Umschalter zu.
      'taskDeletionByTrashIcon': taskDeletionByTrashIcon, // Maps task deletion by trash icon field. // Ordnet das Feld für die Aufgabenlöschung durch das Papierkorbsymbol zu.
      'taskCardTitle': taskCardTitle, // Maps task card title field. // Ordnet das Feld für den Aufgabenkartentitel zu.
      'projectName': projectName, // Maps project names field. // Ordnet das Feld für Projektnamen zu.
      'selectedContainerIndex': selectedContainerIndex, // Maps selected container index field. // Ordnet das Feld für den ausgewählten Container-Index zu.
      'weeklyTimeframes': weeklyTimeframes.map((e) => e.toMap()).toList(), // Maps each weekly timeframe to Map and collects in a list. // Ordnet jeden wöchentlichen Zeitrahmen einer Map zu und sammelt in einer Liste.
      'monthlyTimeframes': monthlyTimeframes.map((e) => e.toMap()).toList(), // Maps each monthly timeframe to Map and collects in a list. // Ordnet jeden monatlichen Zeitrahmen einer Map zu und sammelt in einer Liste.
      'yearlyTimeframes': yearlyTimeframes.map((e) => e.toMap()).toList(), // Maps each yearly timeframe to Map and collects in a list. // Ordnet jeden jährlichen Zeitrahmen einer Map zu und sammelt in einer Liste.
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) { // Factory constructor to create a UserModel from a Map. // Factory-Konstruktor zum Erstellen eines UserModel aus einer Map.
    return UserModel( // Creates and returns a new UserModel instance. // Erstellt und gibt eine neue UserModel-Instanz zurück.
      email: map['email'] ?? '', // Gets email from map, defaults to empty string if missing. // Ruft E-Mail aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      name: map['name'] ?? '', // Gets name from map, defaults to empty string if missing. // Ruft Name aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      profilePic: map['profilePic'] ?? '', // Gets profile picture from map, defaults to empty string if missing. // Ruft Profilbild aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      uid: map['_id'] ?? '', // Gets user ID from map (note the different key '_id'), defaults to empty string if missing. // Ruft Benutzer-ID aus Map ab (beachte den anderen Schlüssel '_id'), Standardwert ist leerer String, wenn nicht vorhanden.
      token: map['token'] ?? '', // Gets token from map, defaults to empty string if missing. // Ruft Token aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      isPremium: map['isPremium'] ?? false, // Gets premium status from map, defaults to false if missing. // Ruft Premium-Status aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      subscriptionId: map['subscriptionId'] ?? '', // Gets subscription ID from map, defaults to empty string if missing. // Ruft Abonnement-ID aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      suscriptionStatusCancelled: map['suscriptionStatusCancelled'] ?? false, // Gets subscription cancelled status from map, defaults to false if missing. // Ruft Status "Abonnement gekündigt" aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      subscriptionStatusConfirmed: map['subscriptionStatusConfirmed'] ?? false, // Gets subscription confirmed status from map, defaults to false if missing. // Ruft Status "Abonnement bestätigt" aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      subscriptionStatusPending: map['subscriptionStatusPending'] ?? false, // Gets subscription pending status from map, defaults to false if missing. // Ruft Status "Abonnement ausstehend" aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      nextBillingTime: map['nextBillingTime'] != null
          ? DateTime.parse(map['nextBillingTime']).toUtc() // Parses next billing time from string to DateTime and converts to UTC if present. // Analysiert die nächste Abrechnungszeit von String zu DateTime und konvertiert zu UTC, wenn vorhanden.
          : null, // Sets to null if missing. // Setzt auf null, wenn nicht vorhanden.
      startTimeSubscriptionPayPal: map['startTimeSubscriptionPayPal'] != null
          ? DateTime.parse(map['startTimeSubscriptionPayPal']).toUtc() // Parses PayPal subscription start time from string to DateTime and converts to UTC if present. // Analysiert die Startzeit des PayPal-Abonnements von String zu DateTime und konvertiert zu UTC, wenn vorhanden.
          : null, // Sets to null if missing. // Setzt auf null, wenn nicht vorhanden.
      paypalSubscriptionCancelledAt:
          map['paypalSubscriptionCancelledAt'] != null
              ? DateTime.parse(map['paypalSubscriptionCancelledAt']).toUtc() // Parses PayPal subscription cancellation time from string to DateTime and converts to UTC if present. // Analysiert die Kündigungszeit des PayPal-Abonnements von String zu DateTime und konvertiert zu UTC, wenn vorhanden.
              : null, // Sets to null if missing. // Setzt auf null, wenn nicht vorhanden.
      userLocalTimeZone: map['userLocalTimeZone'] != null
          ? DateTime.parse(map['userLocalTimeZone']).toUtc() // Parses user local time zone from string to DateTime and converts to UTC if present. // Analysiert die lokale Zeitzone des Benutzers von String zu DateTime und konvertiert zu UTC, wenn vorhanden.
          : null, // Sets to null if missing. // Setzt auf null, wenn nicht vorhanden.
      pomodoroTimer: map['pomodoroTimer'] ?? 0, // Gets Pomodoro timer duration from map, defaults to 0 if missing. // Ruft Pomodoro-Timer-Dauer aus Map ab, Standardwert ist 0, wenn nicht vorhanden.
      shortBreakTimer: map['shortBreakTimer'] ?? 0, // Gets short break timer duration from map, defaults to 0 if missing. // Ruft Kurzpausen-Timer-Dauer aus Map ab, Standardwert ist 0, wenn nicht vorhanden.
      longBreakTimer: map['longBreakTimer'] ?? 0, // Gets long break timer duration from map, defaults to 0 if missing. // Ruft Langpausen-Timer-Dauer aus Map ab, Standardwert ist 0, wenn nicht vorhanden.
      longBreakInterval: map['longBreakInterval'] ?? 0, // Gets long break interval from map, defaults to 0 if missing. // Ruft Langpausen-Intervall aus Map ab, Standardwert ist 0, wenn nicht vorhanden.
      selectedSound: map['selectedSound'] ?? '', // Gets selected sound from map, defaults to empty string if missing. // Ruft ausgewählten Ton aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      browserNotificationsEnabled: map['browserNotificationsEnabled'] ?? false, // Gets browser notifications status from map, defaults to false if missing. // Ruft Browser-Benachrichtigungsstatus aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      pomodoroColor: map['pomodoroColor'] ?? '#74F143', // Gets Pomodoro color from map, defaults to green (#74F143) if missing. // Ruft Pomodoro-Farbe aus Map ab, Standardwert ist Grün (#74F143), wenn nicht vorhanden.
      shortBreakColor: map['shortBreakColor'] ?? '#ff9933', // Gets short break color from map, defaults to orange (#ff9933) if missing. // Ruft Kurzpausen-Farbe aus Map ab, Standardwert ist Orange (#ff9933), wenn nicht vorhanden.
      longBreakColor: map['longBreakColor'] ?? '#0891FF', // Gets long break color from map, defaults to blue (#0891FF) if missing. // Ruft Langpausen-Farbe aus Map ab, Standardwert ist Blau (#0891FF), wenn nicht vorhanden.
      pomodoroStates: List<bool>.from(map['pomodoroStates'] ?? []), // Gets Pomodoro states from map, converts to a List<bool>, defaults to empty list if missing. // Ruft Pomodoro-Zustände aus Map ab, konvertiert zu einer List<bool>, Standardwert ist leere Liste, wenn nicht vorhanden.
      toDoHappySadToggle: map['toDoHappySadToggle'] ?? false, // Gets to-do happy/sad toggle from map, defaults to false if missing. // Ruft To-Do-Fröhlich/Traurig-Umschalter aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      taskDeletionByTrashIcon: map['taskDeletionByTrashIcon'] ?? false, // Gets task deletion by trash icon from map, defaults to false if missing. // Ruft Aufgabenlöschung durch Papierkorbsymbol aus Map ab, Standardwert ist false, wenn nicht vorhanden.
      taskCardTitle: map['taskCardTitle'] ?? '', // Gets task card title from map, defaults to empty string if missing. // Ruft Aufgabenkartentitel aus Map ab, Standardwert ist leerer String, wenn nicht vorhanden.
      projectName: List<String>.from(map['projectName'] ?? ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']), // Gets project names from map, converts to a List<String>, defaults to default project names if missing. // Ruft Projektnamen aus Map ab, konvertiert zu einer List<String>, Standardwert ist Standard-Projektnamen, wenn nicht vorhanden.
      selectedContainerIndex: map['selectedContainerIndex'] ?? 0, // Gets selected container index from map, defaults to 0 if missing. // Ruft ausgewählten Container-Index aus Map ab, Standardwert ist 0, wenn nicht vorhanden.
      
      weeklyTimeframes: (map['weeklyTimeframes'] as List<dynamic>? ?? []) // Gets weekly timeframes from map, defaults to empty list if missing. // Ruft wöchentliche Zeitrahmen aus Map ab, Standardwert ist leere Liste, wenn nicht vorhanden.
          .map((e) => TimeframeEntry.fromMap(e as Map<String, dynamic>)) // Converts each map to a TimeframeEntry object. // Konvertiert jede Map in ein TimeframeEntry-Objekt.
          .toList(), // Collects all converted objects into a list. // Sammelt alle konvertierten Objekte in einer Liste.
      monthlyTimeframes: (map['monthlyTimeframes'] as List<dynamic>? ?? []) // Gets monthly timeframes from map, defaults to empty list if missing. // Ruft monatliche Zeitrahmen aus Map ab, Standardwert ist leere Liste, wenn nicht vorhanden.
          .map((e) => TimeframeEntry.fromMap(e as Map<String, dynamic>)) // Converts each map to a TimeframeEntry object. // Konvertiert jede Map in ein TimeframeEntry-Objekt.
          .toList(), // Collects all converted objects into a list. // Sammelt alle konvertierten Objekte in einer Liste.
      yearlyTimeframes: (map['yearlyTimeframes'] as List<dynamic>? ?? []) // Gets yearly timeframes from map, defaults to empty list if missing. // Ruft jährliche Zeitrahmen aus Map ab, Standardwert ist leere Liste, wenn nicht vorhanden.
          .map((e) => TimeframeEntry.fromMap(e as Map<String, dynamic>)) // Converts each map to a TimeframeEntry object. // Konvertiert jede Map in ein TimeframeEntry-Objekt.
          .toList(), // Collects all converted objects into a list. // Sammelt alle konvertierten Objekte in einer Liste.
    
    );
  }

  String toJson() => json.encode(toMap()); // Converts the UserModel to a JSON string using the toMap method. // Konvertiert das UserModel in einen JSON-String mithilfe der toMap-Methode.

  factory UserModel.fromJson(String source) => // Factory constructor to create a UserModel from a JSON string. // Factory-Konstruktor zum Erstellen eines UserModel aus einem JSON-String.
      UserModel.fromMap(json.decode(source)); // Decodes the JSON string to a Map and uses fromMap to create the UserModel. // Decodiert den JSON-String in eine Map und verwendet fromMap, um das UserModel zu erstellen.

  UserModel copyWith({ // Method to create a copy of the UserModel with some fields updated. // Methode zum Erstellen einer Kopie des UserModel mit einigen aktualisierten Feldern.
    String? email, // Optional email parameter. // Optionaler E-Mail-Parameter.
    String? name, // Optional name parameter. // Optionaler Name-Parameter.
    String? profilePic, // Optional profile picture parameter. // Optionaler Profilbild-Parameter.
    String? uid, // Optional user ID parameter. // Optionaler Benutzer-ID-Parameter.
    String? token, // Optional token parameter. // Optionaler Token-Parameter.
    bool? isPremium, // Optional premium status parameter. // Optionaler Premium-Status-Parameter.
    String? subscriptionId, // Optional subscription ID parameter. // Optionaler Abonnement-ID-Parameter.
    bool? suscriptionStatusCancelled, // Optional subscription cancelled status parameter. // Optionaler Parameter für den Status "Abonnement gekündigt".
    bool? subscriptionStatusConfirmed, // Optional subscription confirmed status parameter. // Optionaler Parameter für den Status "Abonnement bestätigt".
    bool? subscriptionStatusPending, // Optional subscription pending status parameter. // Optionaler Parameter für den Status "Abonnement ausstehend".
    DateTime? nextBillingTime, // Optional next billing time parameter. // Optionaler Parameter für die nächste Abrechnungszeit.
    DateTime? startTimeSubscriptionPayPal, // Optional PayPal subscription start time parameter. // Optionaler Parameter für die Startzeit des PayPal-Abonnements.
    DateTime? paypalSubscriptionCancelledAt, // Optional PayPal subscription cancellation time parameter. // Optionaler Parameter für die Kündigungszeit des PayPal-Abonnements.
    DateTime? userLocalTimeZone, // Optional user local time zone parameter. // Optionaler Parameter für die lokale Zeitzone des Benutzers.
    int? pomodoroTimer, // Optional Pomodoro timer duration parameter. // Optionaler Parameter für die Pomodoro-Timer-Dauer.
    int? shortBreakTimer, // Optional short break timer duration parameter. // Optionaler Parameter für die Kurzpausen-Timer-Dauer.
    int? longBreakTimer, // Optional long break timer duration parameter. // Optionaler Parameter für die Langpausen-Timer-Dauer.
    int? longBreakInterval, // Optional long break interval parameter. // Optionaler Parameter für das Langpausen-Intervall.
    String? selectedSound, // Optional selected sound parameter. // Optionaler Parameter für den ausgewählten Ton.
    bool? browserNotificationsEnabled, // Optional browser notifications status parameter. // Optionaler Parameter für den Browser-Benachrichtigungsstatus.
    String? pomodoroColor, // Optional Pomodoro color parameter. // Optionaler Parameter für die Pomodoro-Farbe.
    String? shortBreakColor, // Optional short break color parameter. // Optionaler Parameter für die Kurzpausen-Farbe.
    String? longBreakColor, // Optional long break color parameter. // Optionaler Parameter für die Langpausen-Farbe.
    List<bool>? pomodoroStates, // Optional Pomodoro states parameter. // Optionaler Parameter für Pomodoro-Zustände.
    bool? toDoHappySadToggle, // Optional to-do happy/sad toggle parameter. // Optionaler Parameter für den To-Do-Fröhlich/Traurig-Umschalter.
    bool? taskDeletionByTrashIcon, // Optional task deletion by trash icon parameter. // Optionaler Parameter für die Aufgabenlöschung durch das Papierkorbsymbol.
    String? taskCardTitle, // Optional task card title parameter. // Optionaler Parameter für den Aufgabenkartentitel.
    List<String>? projectName, // Optional project names parameter. // Optionaler Parameter für Projektnamen.
    int? selectedContainerIndex, // Optional selected container index parameter. // Optionaler Parameter für den ausgewählten Container-Index.
    
    List<TimeframeEntry>? weeklyTimeframes, // Optional weekly timeframes parameter. // Optionaler Parameter für wöchentliche Zeitrahmen.
    List<TimeframeEntry>? monthlyTimeframes, // Optional monthly timeframes parameter. // Optionaler Parameter für monatliche Zeitrahmen.
    List<TimeframeEntry>? yearlyTimeframes, // Optional yearly timeframes parameter. // Optionaler Parameter für jährliche Zeitrahmen.
  }) {
    return UserModel( // Creates and returns a new UserModel with updated fields. // Erstellt und gibt ein neues UserModel mit aktualisierten Feldern zurück.
      email: email ?? this.email, // Uses provided email if not null, otherwise uses the current email. // Verwendet die angegebene E-Mail, wenn nicht null, andernfalls die aktuelle E-Mail.
      name: name ?? this.name, // Uses provided name if not null, otherwise uses the current name. // Verwendet den angegebenen Namen, wenn nicht null, andernfalls den aktuellen Namen.
      profilePic: profilePic ?? this.profilePic, // Uses provided profile picture if not null, otherwise uses the current profile picture. // Verwendet das angegebene Profilbild, wenn nicht null, andernfalls das aktuelle Profilbild.
      uid: uid ?? this.uid, // Uses provided user ID if not null, otherwise uses the current user ID. // Verwendet die angegebene Benutzer-ID, wenn nicht null, andernfalls die aktuelle Benutzer-ID.
      token: token ?? this.token, // Uses provided token if not null, otherwise uses the current token. // Verwendet den angegebenen Token, wenn nicht null, andernfalls den aktuellen Token.
      isPremium: isPremium ?? this.isPremium, // Uses provided premium status if not null, otherwise uses the current premium status. // Verwendet den angegebenen Premium-Status, wenn nicht null, andernfalls den aktuellen Premium-Status.
      subscriptionId: subscriptionId ?? this.subscriptionId, // Uses provided subscription ID if not null, otherwise uses the current subscription ID. // Verwendet die angegebene Abonnement-ID, wenn nicht null, andernfalls die aktuelle Abonnement-ID.
      suscriptionStatusCancelled:
          suscriptionStatusCancelled ?? this.suscriptionStatusCancelled, // Uses provided subscription cancelled status if not null, otherwise uses the current status. // Verwendet den angegebenen Status "Abonnement gekündigt", wenn nicht null, andernfalls den aktuellen Status.
      subscriptionStatusConfirmed:
          subscriptionStatusConfirmed ?? this.subscriptionStatusConfirmed, // Uses provided subscription confirmed status if not null, otherwise uses the current status. // Verwendet den angegebenen Status "Abonnement bestätigt", wenn nicht null, andernfalls den aktuellen Status.
      subscriptionStatusPending:
          subscriptionStatusPending ?? this.subscriptionStatusPending, // Uses provided subscription pending status if not null, otherwise uses the current status. // Verwendet den angegebenen Status "Abonnement ausstehend", wenn nicht null, andernfalls den aktuellen Status.
      nextBillingTime: nextBillingTime ?? this.nextBillingTime, // Uses provided next billing time if not null, otherwise uses the current next billing time. // Verwendet die angegebene nächste Abrechnungszeit, wenn nicht null, andernfalls die aktuelle nächste Abrechnungszeit.
      startTimeSubscriptionPayPal:
          startTimeSubscriptionPayPal ?? this.startTimeSubscriptionPayPal, // Uses provided PayPal subscription start time if not null, otherwise uses the current start time. // Verwendet die angegebene Startzeit des PayPal-Abonnements, wenn nicht null, andernfalls die aktuelle Startzeit.
      paypalSubscriptionCancelledAt:
          paypalSubscriptionCancelledAt ?? this.paypalSubscriptionCancelledAt, // Uses provided PayPal subscription cancellation time if not null, otherwise uses the current cancellation time. // Verwendet die angegebene Kündigungszeit des PayPal-Abonnements, wenn nicht null, andernfalls die aktuelle Kündigungszeit.
      userLocalTimeZone: userLocalTimeZone ?? this.userLocalTimeZone, // Uses provided user local time zone if not null, otherwise uses the current user local time zone. // Verwendet die angegebene lokale Zeitzone des Benutzers, wenn nicht null, andernfalls die aktuelle lokale Zeitzone des Benutzers.
      pomodoroTimer: pomodoroTimer ?? this.pomodoroTimer, // Uses provided Pomodoro timer duration if not null, otherwise uses the current duration. // Verwendet die angegebene Pomodoro-Timer-Dauer, wenn nicht null, andernfalls die aktuelle Dauer.
      shortBreakTimer: shortBreakTimer ?? this.shortBreakTimer, // Uses provided short break timer duration if not null, otherwise uses the current duration. // Verwendet die angegebene Kurzpausen-Timer-Dauer, wenn nicht null, andernfalls die aktuelle Dauer.
      longBreakTimer: longBreakTimer ?? this.longBreakTimer, // Uses provided long break timer duration if not null, otherwise uses the current duration. // Verwendet die angegebene Langpausen-Timer-Dauer, wenn nicht null, andernfalls die aktuelle Dauer.
      longBreakInterval: longBreakInterval ?? this.longBreakInterval, // Uses provided long break interval if not null, otherwise uses the current interval. // Verwendet das angegebene Langpausen-Intervall, wenn nicht null, andernfalls das aktuelle Intervall.
      selectedSound: selectedSound ?? this.selectedSound, // Uses provided selected sound if not null, otherwise uses the current selected sound. // Verwendet den angegebenen ausgewählten Ton, wenn nicht null, andernfalls den aktuellen ausgewählten Ton.
      browserNotificationsEnabled:
          browserNotificationsEnabled ?? this.browserNotificationsEnabled, // Uses provided browser notifications status if not null, otherwise uses the current status. // Verwendet den angegebenen Browser-Benachrichtigungsstatus, wenn nicht null, andernfalls den aktuellen Status.
      pomodoroColor: pomodoroColor ?? this.pomodoroColor, // Uses provided Pomodoro color if not null, otherwise uses the current Pomodoro color. // Verwendet die angegebene Pomodoro-Farbe, wenn nicht null, andernfalls die aktuelle Pomodoro-Farbe.
      shortBreakColor: shortBreakColor ?? this.shortBreakColor, // Uses provided short break color if not null, otherwise uses the current short break color. // Verwendet die angegebene Kurzpausen-Farbe, wenn nicht null, andernfalls die aktuelle Kurzpausen-Farbe.
      longBreakColor: longBreakColor ?? this.longBreakColor, // Uses provided long break color if not null, otherwise uses the current long break color. // Verwendet die angegebene Langpausen-Farbe, wenn nicht null, andernfalls die aktuelle Langpausen-Farbe.
      pomodoroStates: pomodoroStates ?? this.pomodoroStates, // Uses provided Pomodoro states if not null, otherwise uses the current Pomodoro states. // Verwendet die angegebenen Pomodoro-Zustände, wenn nicht null, andernfalls die aktuellen Pomodoro-Zustände.
      toDoHappySadToggle: toDoHappySadToggle ?? this.toDoHappySadToggle, // Uses provided to-do happy/sad toggle if not null, otherwise uses the current toggle. // Verwendet den angegebenen To-Do-Fröhlich/Traurig-Umschalter, wenn nicht null, andernfalls den aktuellen Umschalter.
      taskDeletionByTrashIcon:
          taskDeletionByTrashIcon ?? this.taskDeletionByTrashIcon, // Uses provided task deletion by trash icon if not null, otherwise uses the current setting. // Verwendet die angegebene Aufgabenlöschung durch Papierkorbsymbol, wenn nicht null, andernfalls die aktuelle Einstellung.
      taskCardTitle: taskCardTitle ?? this.taskCardTitle, // Uses provided task card title if not null, otherwise uses the current task card title. // Verwendet den angegebenen Aufgabenkartentitel, wenn nicht null, andernfalls den aktuellen Aufgabenkartentitel.
      projectName: projectName ?? this.projectName, // Uses provided project names if not null, otherwise uses the current project names. // Verwendet die angegebenen Projektnamen, wenn nicht null, andernfalls die aktuellen Projektnamen.
      selectedContainerIndex: selectedContainerIndex ?? this.selectedContainerIndex, // Uses provided selected container index if not null, otherwise uses the current selected container index. // Verwendet den angegebenen ausgewählten Container-Index, wenn nicht null, andernfalls den aktuellen ausgewählten Container-Index.
      weeklyTimeframes: weeklyTimeframes ?? this.weeklyTimeframes, // Uses provided weekly timeframes if not null, otherwise uses the current weekly timeframes. // Verwendet die angegebenen wöchentlichen Zeitrahmen, wenn nicht null, andernfalls die aktuellen wöchentlichen Zeitrahmen.
      monthlyTimeframes: monthlyTimeframes ?? this.monthlyTimeframes, // Uses provided monthly timeframes if not null, otherwise uses the current monthly timeframes. // Verwendet die angegebenen monatlichen Zeitrahmen, wenn nicht null, andernfalls die aktuellen monatlichen Zeitrahmen.
      yearlyTimeframes: yearlyTimeframes ?? this.yearlyTimeframes, // Uses provided yearly timeframes if not null, otherwise uses the current yearly timeframes. // Verwendet die angegebenen jährlichen Zeitrahmen, wenn nicht null, andernfalls die aktuellen jährlichen Zeitrahmen.
   
    );
  }
}
