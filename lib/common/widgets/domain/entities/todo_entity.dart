/// Todo
///
/// A model class that represents a to-do task item in the Pomodoro application. // Eine Modellklasse, die ein To-Do-Aufgabenelement in der Pomodoro-Anwendung repräsentiert.
/// Used for creating, displaying, and managing task entries in the to-do list. // Wird für das Erstellen, Anzeigen und Verwalten von Aufgabeneinträgen in der To-Do-Liste verwendet.
///
/// Usage:
/// ```dart
/// final task = Todo(
///   title: 'Complete project documentation',
///   description: 'Finish writing the API reference docs',
/// );
/// ```
///
/// EN: Manages task data including editing state, focus state, and maintains original values for potential restoration.
/// DE: Verwaltet Aufgabendaten einschließlich Bearbeitungszustand, Fokuszustand und bewahrt Originalwerte für potenzielle Wiederherstellung.

import 'package:flutter/material.dart';  // Imports core Flutter material design package. // Importiert das Flutter Material-Design-Paket.
import 'package:uuid/uuid.dart';  // Imports UUID generation package. // Importiert das UUID-Generierungspaket.


class Todo {  // Defines a model class for to-do tasks. // Definiert eine Modellklasse für To-Do-Aufgaben.
  final String id;  // Unique identifier for the task. // Eindeutiger Identifikator für die Aufgabe.
  String title;  // Title of the task. // Titel der Aufgabe.
  String description;  // Detailed description of the task. // Detaillierte Beschreibung der Aufgabe.
  bool isActive;  // Flag indicating if the task is active/completed. // Flag, das anzeigt, ob die Aufgabe aktiv/abgeschlossen ist.
  bool isEditable;  // Flag indicating if the task is currently being edited. // Flag, das anzeigt, ob die Aufgabe gerade bearbeitet wird.
  TextEditingController titleController;  // Controller for the title text field. // Controller für das Titel-Textfeld.
  TextEditingController descriptionController;  // Controller for the description text field. // Controller für das Beschreibungs-Textfeld.

  bool isFocused = false;  // Flag indicating if the task is currently focused. // Flag, das anzeigt, ob die Aufgabe derzeit im Fokus steht.

  String originalTitle;  // Stores the original title for canceling edits. // Speichert den ursprünglichen Titel zum Abbrechen von Bearbeitungen.
  String originalDescription;  // Stores the original description for canceling edits. // Speichert die ursprüngliche Beschreibung zum Abbrechen von Bearbeitungen.
  Todo({  // Constructor with named parameters. // Konstruktor mit benannten Parametern.
    String? id,  // Optional ID parameter, null if not provided. // Optionaler ID-Parameter, null wenn nicht angegeben.
    required this.title,  // Required title parameter. // Erforderlicher Titel-Parameter.
    required this.description,  // Required description parameter. // Erforderliche Beschreibungs-Parameter.
    this.isActive = false,  // Optional active state, defaults to false. // Optionaler Aktivzustand, standardmäßig false.
    this.isFocused = false,  // Optional focus state, defaults to false. // Optionaler Fokuszustand, standardmäßig false.
    this.isEditable = false,  // Optional editable state, defaults to false. // Optionaler Bearbeitungszustand, standardmäßig false.
  })  : titleController = TextEditingController(text: title),  // Initializes title controller with the provided title. // Initialisiert den Titel-Controller mit dem angegebenen Titel.
        descriptionController = TextEditingController(text: description),  // Initializes description controller with the provided description. // Initialisiert den Beschreibungs-Controller mit der angegebenen Beschreibung.
        originalTitle = title,  // Stores the initial title as original. // Speichert den anfänglichen Titel als Original.
        originalDescription = description,  // Stores the initial description as original. // Speichert die anfängliche Beschreibung als Original.
        id = id ?? const Uuid().v4();  // Uses provided ID or generates a new UUID. // Verwendet die angegebene ID oder generiert eine neue UUID.

  Todo copyWith({  // Method to create a copy with optionally modified properties. // Methode zum Erstellen einer Kopie mit optional geänderten Eigenschaften.
    String? id,  // Optional new ID. // Optionale neue ID.
    String? title,  // Optional new title. // Optionaler neuer Titel.
    String? description,  // Optional new description. // Optionale neue Beschreibung.
    bool? isActive,  // Optional new active state. // Optionaler neuer Aktivzustand.
    bool? isEditable,  // Optional new editable state. // Optionaler neuer Bearbeitungszustand.
    TextEditingController? titleController,  // Optional new title controller. // Optionaler neuer Titel-Controller.
    TextEditingController? descriptionController,  // Optional new description controller. // Optionaler neuer Beschreibungs-Controller.
    String? originalTitle,  // Optional new original title. // Optionaler neuer Original-Titel.
    String? originalDescription,  // Optional new original description. // Optionale neue Original-Beschreibung.
  }) {
    return Todo(  // Returns a new Todo instance. // Gibt eine neue Todo-Instanz zurück.
      id: id ?? this.id,  // Uses new ID or keeps existing one. // Verwendet neue ID oder behält bestehende bei.
      title: title ?? this.title,  // Uses new title or keeps existing one. // Verwendet neuen Titel oder behält bestehenden bei.
      description: description ?? this.description,  // Uses new description or keeps existing one. // Verwendet neue Beschreibung oder behält bestehende bei.
      isActive: isActive ?? this.isActive,  // Uses new active state or keeps existing one. // Verwendet neuen Aktivzustand oder behält bestehenden bei.
      isEditable: isEditable ?? this.isEditable,  // Uses new editable state or keeps existing one. // Verwendet neuen Bearbeitungszustand oder behält bestehenden bei.
    );
  }
}
