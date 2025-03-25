/// ErrorModel
/// 
/// A data model class for handling operation results with possible errors. // Eine Datenmodellklasse zur Behandlung von Operationsergebnissen mit möglichen Fehlern.
/// Used throughout the application to standardize error handling and data returns from API calls or operations. // Wird in der gesamten Anwendung verwendet, um die Fehlerbehandlung und Datenrückgaben von API-Aufrufen oder Operationen zu standardisieren.
/// 
/// Usage:
/// ```dart
/// // Success case
/// ErrorModel response = ErrorModel(error: null, data: userData);
/// 
/// // Error case
/// ErrorModel response = ErrorModel(error: "User not found", data: null);
/// ```
/// 
/// EN: Provides a consistent structure for operation results, including both potential error information and returned data.
/// DE: Bietet eine einheitliche Struktur für Operationsergebnisse, einschließlich potenzieller Fehlerinformationen und zurückgegebener Daten.

class ErrorModel { // Defines a class named ErrorModel to represent operation results. // Definiert eine Klasse namens ErrorModel, um Operationsergebnisse darzustellen.
  final String? error; // A nullable string that contains error message if present, null otherwise. // Ein nullbarer String, der eine Fehlermeldung enthält, wenn vorhanden, sonst null.
  final dynamic data; // A dynamic type field that can hold any type of data returned by an operation. // Ein dynamisches Typfeld, das jeden Datentyp aufnehmen kann, der von einer Operation zurückgegeben wird.
  ErrorModel({ // Constructor for creating instances of ErrorModel. // Konstruktor zum Erstellen von Instanzen von ErrorModel.
    required this.error, // Requires the error parameter to be provided (can be null). // Erfordert, dass der error-Parameter angegeben wird (kann null sein).
    required this.data, // Requires the data parameter to be provided (can be any type). // Erfordert, dass der data-Parameter angegeben wird (kann ein beliebiger Typ sein).
  });
}
