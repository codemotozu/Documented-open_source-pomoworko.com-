/// ToDoPage
/// 
/// A widget that displays the todo task interface for the application. // Ein Widget, das die Todo-Aufgabenschnittstelle für die Anwendung anzeigt.
/// Used as the main interface for viewing and managing todo tasks with a header and task card. // Wird als Hauptschnittstelle für die Anzeige und Verwaltung von Todo-Aufgaben mit einer Kopfzeile und einer Aufgabenkarte verwendet.
/// 
/// Usage: 
/// ```dart
/// Scaffold(
///   body: const ToDoPage(),
/// )
/// ```
/// 
/// EN: Displays a vertically arranged todo interface with a header and expandable task card area.
/// DE: Zeigt eine vertikal angeordnete Todo-Schnittstelle mit einer Kopfzeile und einem erweiterbaren Aufgabenkartenbereich an.

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../../../../../common/widgets/domain/entities/todo_entity.dart'; // Imports the Todo entity model. // Importiert das Todo-Entitätsmodell.
import '../../../../notifiers/task_notifier.dart'; // Imports task-specific notifier for state updates. // Importiert aufgabenspezifischen Notifier für Zustandsaktualisierungen.
import '../../../../widgets/todo_widgets/card_todo_widget.dart'; // Imports the card widget for displaying todos. // Importiert das Karten-Widget für die Anzeige von Todos.
import '../../../../widgets/todo_widgets/header_title_todo.dart'; // Imports the header widget for todo page. // Importiert das Kopfzeilen-Widget für die Todo-Seite.

class ToDoPage extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const ToDoPage({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  _ToDoPageState createState() => _ToDoPageState(); // Creates the state object for this widget. // Erstellt das State-Objekt für dieses Widget.
}

class _ToDoPageState extends ConsumerState<ToDoPage> { // Defines the state class for ToDoPage widget. // Definiert die State-Klasse für das ToDoPage-Widget.
  bool isActive = false; // Flag to track if the page is active. // Flag, um zu verfolgen, ob die Seite aktiv ist.
  List<Todo> todos = []; // List to store todo items. // Liste zum Speichern von Todo-Elementen.
  @override
  void dispose() { // Called when widget is removed from widget tree. // Wird aufgerufen, wenn das Widget aus dem Widget-Baum entfernt wird.
    for (var todo in todos) { // Iterates through each todo in the list. // Iteriert durch jedes Todo in der Liste.
      todo.titleController.dispose(); // Disposes the text controller for todo title. // Entsorgt den Textcontroller für den Todo-Titel.
      todo.descriptionController.dispose(); // Disposes the text controller for todo description. // Entsorgt den Textcontroller für die Todo-Beschreibung.
    }
    super.dispose(); // Calls parent dispose method. // Ruft die Eltern-dispose-Methode auf.
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    double todoPageHeight = ref.watch(todoPageHeightProvider); // Watches the height value from the provider. // Beobachtet den Höhenwert vom Provider.

    return SizedBox( // Creates a box with specific dimensions. // Erstellt einen Kasten mit bestimmten Abmessungen.
      height: todoPageHeight, // Sets height based on the provider value. // Setzt die Höhe basierend auf dem Provider-Wert.
      child: const Scaffold( // Creates a Material Design basic page layout. // Erstellt ein Material Design-Grundseitenlayout.
        resizeToAvoidBottomInset: false, // Prevents resizing when keyboard appears. // Verhindert die Größenänderung, wenn die Tastatur erscheint.
        backgroundColor:
         Color.fromARGB(255, 0, 0, 0), // Sets background color to black. // Setzt die Hintergrundfarbe auf Schwarz.

        body: Column( // Creates a vertical layout. // Erstellt ein vertikales Layout.
          mainAxisSize: MainAxisSize.min, // Sets column to take minimum required space. // Stellt die Spalte so ein, dass sie den minimal erforderlichen Platz einnimmt.
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally. // Streckt Kinder horizontal.
          children: [ // List of widgets in the column. // Liste der Widgets in der Spalte.
            HeaderTitleTodo(), // Adds the header widget for todo page. // Fügt das Kopfzeilen-Widget für die Todo-Seite hinzu.
            Expanded( // Makes the child expand to fill available space. // Lässt das Kind expandieren, um verfügbaren Platz zu füllen.
              child: CardTodoWidget(), // Adds the card widget for displaying todos. // Fügt das Karten-Widget für die Anzeige von Todos hinzu.
            ),
          ],
        ),
      ),
    );
  }
}
