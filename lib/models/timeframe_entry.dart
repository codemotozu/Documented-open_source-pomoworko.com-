/// TimeframeEntry
/// 
/// A data model class for storing time tracking information for projects. // Eine Datenmodellklasse zur Speicherung von Zeiterfassungsinformationen für Projekte.
/// Used to record when and how long a user worked on a specific project, enabling time analytics and reports. // Wird verwendet, um aufzuzeichnen, wann und wie lange ein Benutzer an einem bestimmten Projekt gearbeitet hat, was Zeitanalysen und Berichte ermöglicht.
/// 
/// Usage:
/// ```dart
/// // Create a new time entry
/// final entry = TimeframeEntry(
///   projectIndex: 2,
///   date: DateTime.now(),
///   duration: 3600, // 1 hour in seconds
/// );
/// 
/// // Convert to Map for storage
/// final map = entry.toMap();
/// 
/// // Restore from Map
/// final restoredEntry = TimeframeEntry.fromMap(map);
/// ```
/// 
/// EN: Provides a structure for tracking time spent on projects with serialization/deserialization capabilities.
/// DE: Bietet eine Struktur zur Verfolgung der für Projekte aufgewendeten Zeit mit Serialisierungs-/Deserialisierungsfunktionen.


class TimeframeEntry { // Defines a class for tracking time entries for projects. // Definiert eine Klasse zur Verfolgung von Zeiteinträgen für Projekte.
  final int projectIndex; // The index identifying which project this time entry belongs to. // Der Index, der angibt, zu welchem Projekt dieser Zeiteintrag gehört.
  final DateTime date; // The date and time when this time tracking occurred. // Das Datum und die Uhrzeit, wann diese Zeiterfassung stattfand.
  final int duration; // The duration of the time entry in seconds. // Die Dauer des Zeiteintrags in Sekunden.
  
  TimeframeEntry({ // Constructor for creating TimeframeEntry instances. // Konstruktor zum Erstellen von TimeframeEntry-Instanzen.
    required this.projectIndex, // Requires the project index to be provided. // Erfordert, dass der Projektindex angegeben wird.
    required this.date, // Requires the date to be provided. // Erfordert, dass das Datum angegeben wird.
    required this.duration, // Requires the duration to be provided. // Erfordert, dass die Dauer angegeben wird.
  });

  Map<String, dynamic> toMap() { // Method to convert the TimeframeEntry to a Map for serialization. // Methode zum Konvertieren des TimeframeEntry in eine Map zur Serialisierung.
    return { // Returns a Map with keys and values representing the TimeframeEntry. // Gibt eine Map mit Schlüsseln und Werten zurück, die den TimeframeEntry repräsentieren.
      'projectIndex': projectIndex, // Stores the project index with key 'projectIndex'. // Speichert den Projektindex mit dem Schlüssel 'projectIndex'.
      'date': date.toIso8601String(), // Converts the date to ISO 8601 string format for storage. // Konvertiert das Datum für die Speicherung in das ISO 8601-Stringformat.
      'duration': duration, // Stores the duration in seconds with key 'duration'. // Speichert die Dauer in Sekunden mit dem Schlüssel 'duration'.
    };
  }

  factory TimeframeEntry.fromMap(Map<String, dynamic> map) { // Factory constructor to create a TimeframeEntry from a Map. // Factory-Konstruktor zum Erstellen eines TimeframeEntry aus einer Map.
    return TimeframeEntry( // Creates and returns a new TimeframeEntry instance. // Erstellt und gibt eine neue TimeframeEntry-Instanz zurück.
      projectIndex: map['projectIndex'] ?? 0, // Gets projectIndex from map, defaults to 0 if missing. // Ruft projectIndex aus der Map ab, Standardwert ist 0, wenn nicht vorhanden.
      date: DateTime.parse(map['date']).toUtc(), // Parses the ISO 8601 date string and converts to UTC. // Analysiert den ISO 8601-Datumsstring und konvertiert ihn zu UTC.
      duration: map['duration'] ?? 0, // Gets duration from map, defaults to 0 if missing. // Ruft die Dauer aus der Map ab, Standardwert ist 0, wenn nicht vorhanden.
    );
  }
}
