/// CardTodoWidget
/// 
/// A reorderable task card widget for managing todo items in the application. // Ein neu anordenbares Aufgabenkarten-Widget zur Verwaltung von To-Do-Elementen in der Anwendung.
/// Allows users to view, edit, reorder, and save task titles. // Ermöglicht Benutzern das Anzeigen, Bearbeiten, Neu-Anordnen und Speichern von Aufgabentiteln.
/// 
/// Usage:
/// ```dart
/// CardTodoWidget()
/// ```
/// 
/// EN: Displays an interactive, glassmorphic task card with editing capabilities and persistence.
/// DE: Zeigt eine interaktive, glassmorphische Aufgabenkarte mit Bearbeitungsfunktionen und Datenpersistenz an.

import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets from Flutter. // Importiert Cupertino-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for text styling. // Importiert das Google Fonts-Paket für Textstilisierung.
import '../../../../../common/widgets/domain/entities/todo_entity.dart'; // Imports Todo entity model. // Importiert Todo-Entitätsmodell.
import '../../notifiers/providers.dart'; // Imports application providers. // Importiert Anwendungs-Provider.
import '../../notifiers/task_notifier.dart'; // Imports task state management. // Importiert Aufgaben-Zustandsverwaltung.
import '../../pages/6.todo_task/todo_option_1.dart/glassmorphism_screen/widget_glassmorphism.dart'; // Imports glassmorphism effect widget. // Importiert Glassmorphismus-Effekt-Widget.
import '../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.
import 'editable_task_title.dart'; // Imports editable task title component. // Importiert bearbeitbare Aufgabentitel-Komponente.
import 'null_editable_task_title.dart'; // Imports editable task title for non-logged in state. // Importiert bearbeitbare Aufgabentitel für nicht angemeldeten Zustand.
import 'todo_item_controls.dart'; // Imports todo item control buttons. // Importiert Steuerelemente für Todo-Elemente.

class CardTodoWidget extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod consumer capabilities. // Definiert ein Stateful-Widget mit Riverpod-Consumer-Fähigkeiten.
  const CardTodoWidget({super.key}); // Constructor with optional key parameter. // Konstruktor mit optionalem Key-Parameter.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardTodoWidgetState(); // Creates the state for this widget. // Erstellt den State für dieses Widget.
}

class _CardTodoWidgetState extends ConsumerState<CardTodoWidget> { // Defines the state class for CardTodoWidget. // Definiert die State-Klasse für CardTodoWidget.
  bool isActive = false; // Tracks active state of the widget. // Verfolgt den aktiven Zustand des Widgets.
  List<Todo> todos = []; // List to store todo items. // Liste zum Speichern von Todo-Elementen.
  static const String DEFAULT_TITLE = 'Write task title...'; // Default placeholder for task title. // Standardplatzhalter für Aufgabentitel.

  @override
  void initState() { // Initializes the widget state. // Initialisiert den Widget-State.
    super.initState(); // Calls parent initialization. // Ruft die übergeordnete Initialisierung auf.
    _initializeTaskCard(); // Initializes task card with data. // Initialisiert die Aufgabenkarte mit Daten.
  }

  Future<void> _initializeTaskCard() async { // Method to initialize the task card. // Methode zur Initialisierung der Aufgabenkarte.
    final user = ref.read(userProvider); // Gets current user from provider. // Holt aktuellen Benutzer vom Provider.
    if (user != null && todos.isEmpty) { // Checks if user is logged in and todos are empty. // Prüft, ob Benutzer angemeldet ist und Todos leer sind.
      if (!user.taskDeletionByTrashIcon) { // Checks task deletion preference. // Prüft Aufgabenlöschungs-Präferenz.
        var todo = Todo( // Creates new todo item. // Erstellt neues Todo-Element.
          title: user.taskCardTitle ?? DEFAULT_TITLE, // Sets title from user or default. // Setzt Titel vom Benutzer oder Standard.
          description: "", // Empty description. // Leere Beschreibung.
          isEditable: false, // Not editable by default. // Standardmäßig nicht bearbeitbar.
        );
        ref.read(taskListProvider.notifier).addTask(todo); // Adds todo to task list. // Fügt Todo zur Aufgabenliste hinzu.
      }
    }
  }

  Future<void> _handleSave(Todo todo) async { // Method to save changes to a todo. // Methode zum Speichern von Änderungen an einem Todo.
    final user = ref.read(userProvider); // Gets current user from provider. // Holt aktuellen Benutzer vom Provider.
    if (user == null) return; // Returns if no user is logged in. // Kehrt zurück, wenn kein Benutzer angemeldet ist.

    final title = todo.titleController.text; // Gets title text from controller. // Holt Titeltext aus Controller.

    if (title == DEFAULT_TITLE) return; // Returns if title is default. // Kehrt zurück, wenn Titel der Standard ist.

    setState(() { // Updates widget state. // Aktualisiert den Widget-Zustand.
      todo.title = title; // Updates todo title. // Aktualisiert Todo-Titel.
      todo.description = todo.descriptionController.text; // Updates todo description. // Aktualisiert Todo-Beschreibung.
      todo.isEditable = false; // Sets editable state to false. // Setzt bearbeitbaren Zustand auf falsch.
    });

    await ref.read(authRepositoryProvider).updateCardTodoTask( // Updates task on server. // Aktualisiert Aufgabe auf dem Server.
          ref.read(toDoHappySadToggleProvider), // Gets happy/sad toggle state. // Holt Happy/Sad-Umschaltzustand.
          ref.read(taskDeletionsProvider), // Gets task deletion preference. // Holt Aufgabenlöschungs-Präferenz.
          title, // Passes updated title. // Übergibt aktualisierten Titel.
        );

    if (todo.isFocused) { // Checks if todo is focused. // Prüft, ob Todo fokussiert ist.
      ref.read(focusedTaskProvider.notifier).state = todo; // Updates focused task. // Aktualisiert fokussierte Aufgabe.
      ref.read(focusedTaskTitleProvider.notifier).state = title; // Updates focused task title. // Aktualisiert fokussierten Aufgabentitel.
      todo.titleController.addListener(updateFocusedTitle); // Adds title update listener. // Fügt Titelaktualisierungs-Listener hinzu.
    }
  }

  @override
  void dispose() { // Cleans up resources when widget is removed. // Bereinigt Ressourcen, wenn Widget entfernt wird.
    for (var todo in todos) { // Loops through todos. // Durchläuft Todos.
      todo.titleController.dispose(); // Disposes title controller. // Entsorgt Titel-Controller.
      todo.descriptionController.dispose(); // Disposes description controller. // Entsorgt Beschreibungs-Controller.
    }
    super.dispose(); // Calls parent disposal. // Ruft übergeordnete Entsorgung auf.
  }

  void _onReorder(int oldIndex, int newIndex) { // Handles reordering of todo items. // Verarbeitet Neuanordnung von Todo-Elementen.
    setState(() { // Updates widget state. // Aktualisiert den Widget-Zustand.
      if (newIndex > oldIndex) { // Adjusts index if moving down. // Passt Index an, wenn nach unten verschoben wird.
        newIndex -= 1; // Decrements new index. // Verringert neuen Index.
      }
    });

    final Todo item = todos.removeAt(oldIndex); // Removes item at old index. // Entfernt Element am alten Index.
    todos.insert(newIndex, item); // Inserts item at new index. // Fügt Element am neuen Index ein.
    ref.read(taskListProvider.notifier).reorderList(todos); // Updates task list with new order. // Aktualisiert Aufgabenliste mit neuer Reihenfolge.
  }

  void updateFocusedTitle() { // Updates title of focused task. // Aktualisiert Titel der fokussierten Aufgabe.
    if (ref.read(focusedTaskProvider.notifier).state != null) { // Checks if a task is focused. // Prüft, ob eine Aufgabe fokussiert ist.
      ref.read(focusedTaskTitleProvider.notifier).state =
          ref.read(focusedTaskProvider.notifier).state!.titleController.text; // Updates focused title state. // Aktualisiert fokussierten Titel-Zustand.
    }
  }

  void reorderList(List<Todo> reorderedList) {} // Empty method for list reordering, likely a placeholder. // Leere Methode für Listenneusortierung, wahrscheinlich ein Platzhalter.

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    double todoPageHeight = ref.watch(todoPageHeightProvider); // Gets todo page height from provider. // Holt Todo-Seitenhöhe vom Provider.
    todos = ref.watch(taskListProvider); // Gets todos list from provider. // Holt Todos-Liste vom Provider.
    final currentTaskCardTitle = ref.watch(taskCardTitleProvider); // Gets current task card title. // Holt aktuellen Aufgabenkartentitel.
    final user = ref.watch(userProvider); // Gets current user. // Holt aktuellen Benutzer.

    return SizedBox( // Creates a fixed size box. // Erstellt eine Box mit fester Größe.
      height: todoPageHeight, // Sets height from provider. // Setzt Höhe vom Provider.
      child: ReorderableListView( // Creates a reorderable list view. // Erstellt eine neu anordenbare Listenansicht.
        onReorder: _onReorder, // Sets reorder callback. // Setzt Callback für Neuanordnung.
        buildDefaultDragHandles: false, // Disables default drag handles. // Deaktiviert Standard-Ziehgriffe.
        children: todos.map((todo) { // Maps todos to widgets. // Wandelt Todos in Widgets um.
          if (user != null && user.taskCardTitle.isNotEmpty) { // Checks if user has task card title. // Prüft, ob Benutzer einen Aufgabenkartentitel hat.
            todo.title = user.taskCardTitle; // Updates todo title from user. // Aktualisiert Todo-Titel vom Benutzer.
            todo.titleController.text = user.taskCardTitle; // Updates title controller text. // Aktualisiert Titel-Controller-Text.
          }

          return Padding( // Adds padding around todo item. // Fügt Polsterung um Todo-Element hinzu.
            key: ValueKey(todo), // Sets key for reorderable list. // Setzt Schlüssel für neu anordenbare Liste.
            padding: const EdgeInsets.fromLTRB(23, 8, 23, 16), // Sets padding values. // Setzt Polsterungswerte.
            child: Align( // Aligns child widget. // Richtet untergeordnetes Widget aus.
              alignment: Alignment.center, // Centers alignment. // Zentriert Ausrichtung.
              child: Glassmorphism( // Adds glassmorphism effect. // Fügt Glassmorphismus-Effekt hinzu.
                blur: 5, // Sets blur amount. // Legt Unschärfemenge fest.
                opacity: 0.2, // Sets opacity level. // Legt Deckkraft fest.
                radius: 15, // Sets corner radius. // Legt Eckenradius fest.
                child: Container( // Creates a container. // Erstellt einen Container.
                  padding: const EdgeInsets.all(8), // Sets padding around content. // Setzt Polsterung um Inhalt.
                  child: Column( // Creates a column layout. // Erstellt ein Spaltenlayout.
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally. // Dehnt Kinder horizontal.
                    mainAxisAlignment: MainAxisAlignment.spaceAround, // Spaces children evenly. // Verteilt Kinder gleichmäßig.
                    children: [ // List of column children. // Liste der Spaltenkinder.
                      Column( // Nested column for header. // Verschachtelte Spalte für Kopfzeile.
                        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to start. // Richtet Kinder am Anfang aus.
                        mainAxisAlignment: MainAxisAlignment.start, // Aligns children to start vertically. // Richtet Kinder vertikal am Anfang aus.
                        children: [ // List of nested column children. // Liste der verschachtelten Spaltenkinder.
                          Row( // Creates a row layout. // Erstellt ein Zeilenlayout.
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces children at ends. // Verteilt Kinder an den Enden.
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to top. // Richtet Kinder oben aus.
                            children: [ // List of row children. // Liste der Zeilenkinder.
                              const Row( // Empty row, likely for future content. // Leere Zeile, wahrscheinlich für zukünftigen Inhalt.
                                children: [], // No children. // Keine Kinder.
                              ),
                              Padding( // Adds padding. // Fügt Polsterung hinzu.
                                padding: const EdgeInsets.only(right: 10), // Right padding only. // Nur rechte Polsterung.
                                child: Row( // Creates a row for action buttons. // Erstellt eine Zeile für Aktionsschaltflächen.
                                  children: [ // List of action buttons. // Liste der Aktionsschaltflächen.
                               
                                    IconButton( // Edit button. // Bearbeiten-Schaltfläche.
                                      color: const Color(0xffF2F2F2), // Sets light gray color. // Setzt hellgraue Farbe.
                                      icon: const Icon(CupertinoIcons.pencil), // Pencil icon. // Bleistift-Symbol.
                                      onPressed: () { // Action when pressed. // Aktion bei Betätigung.
                                        setState(() { // Updates state. // Aktualisiert Zustand.
                                          todo.isEditable = !todo.isEditable; // Toggles edit mode. // Schaltet Bearbeitungsmodus um.
                                          if (todo.isEditable) { // If entering edit mode. // Wenn in den Bearbeitungsmodus gewechselt wird.
                                            todo.titleController.text =
                                                todo.title; // Sets controller text to current title. // Setzt Controller-Text auf aktuellen Titel.
                                            todo.descriptionController.text = todo
                                                .description; // Sets description controller text. // Setzt Beschreibungs-Controller-Text.
                                          }
                                        });
                                      },
                                    ),
                                    TodoItemControllers(todo: todo), // Adds control buttons component. // Fügt Komponente für Steuerelemente hinzu.
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      if (user == null) EditableTaskTitleNull(todo: todo), // Shows title component for non-logged in users. // Zeigt Titelkomponente für nicht angemeldete Benutzer.

                      if (user != null) EditableTaskTitle(todo: todo), // Shows title component for logged in users. // Zeigt Titelkomponente für angemeldete Benutzer.

                      const SizedBox( // Adds vertical spacing. // Fügt vertikalen Abstand hinzu.
                        height: 5, // 5 logical pixels tall. // 5 logische Pixel hoch.
                      ),
                      if (todo.isEditable) // Shows save button if in edit mode. // Zeigt Speichern-Schaltfläche, wenn im Bearbeitungsmodus.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes space evenly. // Verteilt Platz gleichmäßig.
                          crossAxisAlignment: CrossAxisAlignment.center, // Centers children vertically. // Zentriert Kinder vertikal.
                          children: [
                            Expanded( // Makes child expand to fill space. // Lässt Kind expandieren, um Platz zu füllen.
                              child: ElevatedButton( // Creates elevated button. // Erstellt hervorgehobene Schaltfläche.
                                onPressed: () async { // Action when pressed. // Aktion bei Betätigung.
                               
                                  final newTitle = todo.titleController.text; // Gets new title text. // Holt neuen Titeltext.

                                  setState(() { // Updates state. // Aktualisiert Zustand.
                                    todo.title = newTitle; // Updates todo title. // Aktualisiert Todo-Titel.
                                    todo.isEditable = false; // Exits edit mode. // Verlässt Bearbeitungsmodus.
                                  });

                               
                                  ref
                                      .read(taskCardTitleProvider.notifier)
                                      .updateTitle(newTitle); // Updates card title in provider. // Aktualisiert Kartentitel im Provider.

                                  if (todo.isFocused) { // If todo is focused. // Wenn Todo fokussiert ist.
                                    ref
                                        .read(focusedTaskProvider.notifier)
                                        .state = todo; // Updates focused task. // Aktualisiert fokussierte Aufgabe.
                                    ref
                                        .read(focusedTaskTitleProvider.notifier)
                                        .state = newTitle; // Updates focused task title. // Aktualisiert fokussierten Aufgabentitel.
                                  }

                                },

                                style: ButtonStyle( // Button style configuration. // Konfiguration des Schaltflächenstils.
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(100, 50)), // Sets minimum button size. // Setzt minimale Schaltflächengröße.
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15)), // Sets button padding. // Setzt Schaltflächenpolsterung.
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color(0xff36E261)), // Sets green background color. // Setzt grüne Hintergrundfarbe.
                                  
                                
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color.fromARGB(255, 0, 0, 0)), // Sets black text color. // Setzt schwarze Textfarbe.
                                  
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30), // Sets rounded corners. // Setzt abgerundete Ecken.
                                    ),
                                  ),
                                ),                         
                                  child: Text( // Button text. // Schaltflächentext.
                                  'Save', // Save label. // Speichern-Beschriftung.
                                  style: GoogleFonts.nunito(fontSize: 18, // Uses Nunito font at size 18. // Verwendet Nunito-Schrift in Größe 18.
                                  
                                   fontWeight: FontWeight.w800 // Sets extra-bold weight. // Setzt extrastarke Schriftdicke.
                                 ),
                              ),
                            ),
                        
                        )],
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
