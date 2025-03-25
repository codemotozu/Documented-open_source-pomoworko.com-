/// Sound
///
/// A model class that represents a sound asset in the application. // Eine Modellklasse, die eine Klangdatei in der Anwendung repräsentiert.
/// Used for managing sound effects and alarm tones throughout the application. // Wird für die Verwaltung von Soundeffekten und Alarmtönen in der gesamten Anwendung verwendet.
///
/// Usage:
/// ```dart
/// final alarmSound = Sound(
///   path: 'assets/sounds/alarm.wav',
///   friendlyName: 'Classic Alarm',
/// );
/// ```
///
/// EN: Stores file path and display name for audio resources used in the application.
/// DE: Speichert Dateipfad und Anzeigenamen für in der Anwendung verwendete Audiodateien.

class Sound {  // Defines a model class for sound assets. // Definiert eine Modellklasse für Klangdateien.
  final String path;  // Stores the file path or asset URL of the sound. // Speichert den Dateipfad oder die Asset-URL des Klangs.
  final String friendlyName;  // Stores a human-readable name for display in the UI. // Speichert einen benutzerfreundlichen Namen zur Anzeige in der Benutzeroberfläche.

  const Sound({  // Defines a constant constructor with named parameters. // Definiert einen konstanten Konstruktor mit benannten Parametern.
    required this.path,  // Requires path parameter when creating a Sound object. // Erfordert den Pfad-Parameter bei der Erstellung eines Sound-Objekts.
    required this.friendlyName,  // Requires friendlyName parameter when creating a Sound object. // Erfordert den friendlyName-Parameter bei der Erstellung eines Sound-Objekts.
  });
}
