import 'dart:math';  // Imports the math library for calculations.  // Importiert die Math-Bibliothek für Berechnungen.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management.  // Importiert Riverpod für die Zustandsverwaltung. 
import '../../common/widgets/domain/entities/todo_entity.dart';  // Imports the Todo entity class.  // Importiert die Todo-Entitätsklasse.
import '../../infrastructure/data_sources/hive_services.dart';  // Imports Hive services for local storage.  // Importiert Hive-Dienste für die lokale Datenspeicherung.
import 'providers.dart';  // Imports other providers from the same directory.  // Importiert andere Provider aus demselben Verzeichnis.


class TaskList extends StateNotifier<List<Todo>> {  // A class that manages a list of Todo items using StateNotifier.  // Eine Klasse, die eine Liste von Todo-Elementen mit StateNotifier verwaltet.
  TaskList(this.ref) : super(<Todo>[]) {  // Constructor that initializes with an empty list and takes a ref parameter.  // Konstruktor, der mit einer leeren Liste initialisiert wird und einen ref-Parameter annimmt.
    _initializeList();  // Calls the initialization method when created.  // Ruft die Initialisierungsmethode beim Erstellen auf.
  }
  final Ref ref;  // Reference to access other providers in the app.  // Referenz zum Zugriff auf andere Provider in der App.
  final Map<Todo, double> _taskHeights = {};  // Map to store the height of each task in the UI.  // Map zur Speicherung der Höhe jeder Aufgabe in der UI.

  _initializeList() async {  // Private method to load tasks from storage.  // Private Methode zum Laden von Aufgaben aus dem Speicher.
    List<String>? uuidList = await HiveServices.retrieveTodoUUIDList();  // Gets the list of task IDs from storage.  // Holt die Liste der Aufgaben-IDs aus dem Speicher.
    String? focusedUUID = await HiveServices.retrieveFocusedTodoUUID();  // Gets the ID of the currently focused task.  // Holt die ID der aktuell fokussierten Aufgabe.

    if (uuidList != null && uuidList.isNotEmpty) {  // If there are saved tasks.  // Wenn es gespeicherte Aufgaben gibt.
      List<Future<Todo>> futures = uuidList.map((uuid) async {  // Create a list of futures to load each task.  // Erstellt eine Liste von Futures, um jede Aufgabe zu laden.
        String? title = await HiveServices.retrieveTodoTitle(uuid);  // Load the title for this task.  // Lädt den Titel für diese Aufgabe.

        String? description = await HiveServices.retrieveTodoDescription(uuid);  // Load the description for this task.  // Lädt die Beschreibung für diese Aufgabe.
        bool? checkboxState = await HiveServices.retrieveCheckboxState(uuid);  // Load the checkbox state for this task.  // Lädt den Checkbox-Status für diese Aufgabe.

        return Todo(  // Create a Todo object with the loaded data.  // Erstellt ein Todo-Objekt mit den geladenen Daten.
          title: title ?? "",  // Use the title or empty string if null.  // Verwendet den Titel oder einen leeren String, wenn null.
          description: description ?? "",  // Use the description or empty string if null.  // Verwendet die Beschreibung oder einen leeren String, wenn null.
          id: uuid,  // Set the ID from the UUID.  // Setzt die ID aus der UUID.
          isActive: checkboxState ?? false,  // Set active state from checkbox or false if null.  // Setzt den aktiven Status aus der Checkbox oder false, wenn null.
          isFocused: uuid == focusedUUID,  // Set focused state based on matching the focused UUID.  // Setzt den fokussierten Status basierend auf der Übereinstimmung mit der fokussierten UUID.
        );
      }).toList();
      state = await Future.wait(futures);  // Wait for all tasks to load and update the state.  // Wartet, bis alle Aufgaben geladen sind, und aktualisiert den Status.
      if (focusedUUID != null) {  // If there is a focused task.  // Wenn es eine fokussierte Aufgabe gibt.
        String? focusedTitle =
            await HiveServices.retrieveTodoTitle(focusedUUID);  // Load the title of the focused task.  // Lädt den Titel der fokussierten Aufgabe.
        ref.read(focusedTaskTitleProvider.notifier).state = focusedTitle ?? '';  // Update the focused task title in the provider.  // Aktualisiert den fokussierten Aufgabentitel im Provider.
      }
    }
  }

   void clearTasks() {  // Method to clear all tasks.  // Methode zum Löschen aller Aufgaben.
    state = [];  // Set state to empty list.  // Setzt den Status auf eine leere Liste.
    _taskHeights.clear();  // Clear the height map.  // Löscht die Höhen-Map.
    ref.read(minHeightProvider.notifier).resetHeight();  // Reset the minimum height provider.  // Setzt den Provider für die Mindesthöhe zurück.
  }


  static final initialList = <Todo>[];  // Static empty list for initial state.  // Statische leere Liste für den Anfangszustand.

  void reorderList(List<Todo> reorderedList) {  // Method to reorder the task list.  // Methode zum Neuordnen der Aufgabenliste.
    state = reorderedList;  // Update state with the reordered list.  // Aktualisiert den Status mit der neu geordneten Liste.

    List<String> reorderedUUIDs = reorderedList.map((todo) => todo.id).toList();  // Extract the IDs from the tasks.  // Extrahiert die IDs aus den Aufgaben.
    HiveServices.saveTodoUUIDList(reorderedUUIDs);  // Save the new order to storage.  // Speichert die neue Reihenfolge im Speicher.
  }

  void addTask(Todo task) {  // Method to add a new task.  // Methode zum Hinzufügen einer neuen Aufgabe.
    if (state.length >= 1) {  // If there's already a task.  // Wenn bereits eine Aufgabe vorhanden ist.
      ref.read(showSnackbarProvider.notifier).show();  // Show a notification.  // Zeigt eine Benachrichtigung an.
    } else {  // If there are no tasks yet.  // Wenn noch keine Aufgaben vorhanden sind.
      double taskHeight;  // Variable for task height.  // Variable für die Aufgabenhöhe.
      if (state.isEmpty) {  // If list is empty.  // Wenn die Liste leer ist.
        taskHeight = 300.0;  // Set height to 300.  // Setzt die Höhe auf 300.
      } else if (state.length == 1) {  // If there's one task.  // Wenn es eine Aufgabe gibt.
        taskHeight = 300.0;  // Set height to 300.  // Setzt die Höhe auf 300.
      } else if (state.length == 2) {  // If there are two tasks.  // Wenn es zwei Aufgaben gibt.
        taskHeight = 300.0;  // Set height to 300.  // Setzt die Höhe auf 300.
      } else {  // For more than two tasks.  // Für mehr als zwei Aufgaben.
        taskHeight = 0.0;  // Set height to 0.  // Setzt die Höhe auf 0.
      }
      state = [...state, task];  // Add the new task to the state.  // Fügt die neue Aufgabe zum Status hinzu.

      List<String> currentUUIDs = state.map((todo) => todo.id).toList();  // Extract IDs from all tasks.  // Extrahiert IDs aus allen Aufgaben.
      HiveServices.saveTodoUUIDList(currentUUIDs);  // Save the updated ID list.  // Speichert die aktualisierte ID-Liste.

      HiveServices.saveTodoListLength(state.length);  // Save the new list length.  // Speichert die neue Listenlänge.

      _taskHeights[task] = taskHeight;  // Store the task's height.  // Speichert die Höhe der Aufgabe.

      ref.read(minHeightProvider.notifier).increaseHeight(taskHeight);  // Increase minimum height.  // Erhöht die Mindesthöhe.
    }
  }

  double calculateTaskHeight(String title, String description) {  // Method to calculate task height based on content.  // Methode zur Berechnung der Aufgabenhöhe basierend auf dem Inhalt.
    double baseTaskHeight = 0.0;  // Base height value.  // Basis-Höhenwert.

    return baseTaskHeight;  // Return the calculated height.  // Gibt die berechnete Höhe zurück.
  }

  void updateTask(Todo originalTask, String newTitle, String newDescription) {  // Method to update a task.  // Methode zum Aktualisieren einer Aufgabe.
    int index = state.indexOf(originalTask);  // Find the task's index.  // Findet den Index der Aufgabe.
    if (index != -1) {  // If the task exists.  // Wenn die Aufgabe existiert.
      Todo updatedTask = Todo(  // Create updated task.  // Erstellt aktualisierte Aufgabe.
        id: originalTask.id,  // Keep same ID.  // Behält dieselbe ID.
        title: newTitle,  // Set new title.  // Setzt neuen Titel.
        description: newDescription,  // Set new description.  // Setzt neue Beschreibung.
      );
      state[index] = updatedTask;  // Update the task in the state.  // Aktualisiert die Aufgabe im Status.
    }
  }

  void removeTask(Todo task) {  // Method to remove a task.  // Methode zum Entfernen einer Aufgabe.
    int indexOfRemovedTask = state.indexOf(task);  // Find task's index.  // Findet den Index der Aufgabe.

    if (indexOfRemovedTask == -1) return;  // If task not found, do nothing.  // Wenn Aufgabe nicht gefunden, nichts tun.

    double taskHeight = _taskHeights[task] ?? 0.0;  // Get the task's height.  // Holt die Höhe der Aufgabe.

    if (indexOfRemovedTask == 0 && state.length == 3) {  // First task of three.  // Erste Aufgabe von dreien.
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);  // Decrease height by 300.  // Verringert die Höhe um 300.
    } else if (indexOfRemovedTask == 0 && state.length == 1) {  // Only task.  // Einzige Aufgabe.
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);  // Decrease height by 300.  // Verringert die Höhe um 300.
    } else if (indexOfRemovedTask == 0 && state.length == 2) {  // First task of two.  // Erste Aufgabe von zweien.
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);  // Decrease height by 300.  // Verringert die Höhe um 300.
    } else if (indexOfRemovedTask == 1 && state.length == 2) {  // Second task of two.  // Zweite Aufgabe von zweien.
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);  // Decrease height by 300.  // Verringert die Höhe um 300.
    } else if (indexOfRemovedTask == 1 && state.length == 3) {  // Second task of three.  // Zweite Aufgabe von dreien.
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);  // Decrease height by 300.  // Verringert die Höhe um 300.
    } else if (indexOfRemovedTask == 2 && state.length == 3) {  // Third task of three.  // Dritte Aufgabe von dreien.
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);  // Decrease height by 300.  // Verringert die Höhe um 300.
    } else {  // Other cases.  // Andere Fälle.
      ref.read(minHeightProvider.notifier).decreaseHeight(taskHeight);  // Decrease by task's height.  // Verringert um die Höhe der Aufgabe.
    }

    state = state.where((element) => element != task).toList();  // Remove task from state.  // Entfernt Aufgabe aus dem Status.
    _taskHeights.remove(task);  // Remove from height map.  // Entfernt aus der Höhen-Map.

    HiveServices.deleteTodoUUID(task.id);  // Delete ID from storage.  // Löscht ID aus dem Speicher.

    HiveServices.deleteTodoTitle(task.id);  // Delete title from storage.  // Löscht Titel aus dem Speicher.
    HiveServices.deleteTodoDescription(task.id);  // Delete description from storage.  // Löscht Beschreibung aus dem Speicher.

    HiveServices.deleteCheckboxState(task.id);  // Delete checkbox state from storage.  // Löscht Checkbox-Status aus dem Speicher.

    HiveServices.saveTodoListLength(state.length);  // Save updated list length.  // Speichert aktualisierte Listenlänge.

    if (task.isFocused) {  // If task was focused.  // Wenn Aufgabe fokussiert war.
      ref.read(focusedTaskTitleProvider.notifier).state = '';  // Clear focused title.  // Löscht fokussierten Titel.
      HiveServices.saveFocusedTodoUUID(null);  // Clear focused ID in storage.  // Löscht fokussierte ID im Speicher.
    }
  }
}

final taskListProvider = StateNotifierProvider<TaskList, List<Todo>>((ref) {  // Provider to access the TaskList throughout the app.  // Provider für den Zugriff auf die TaskList in der gesamten App.
  return TaskList(ref);  // Creates and returns a new TaskList instance.  // Erstellt und gibt eine neue TaskList-Instanz zurück.
});

final todoPageHeightProvider = Provider<double>((ref) {  // Provider that calculates total height needed for todo page.  // Provider, der die Gesamthöhe berechnet, die für die Todo-Seite benötigt wird.
  List<Todo> todos = ref.watch(taskListProvider);  // Get the current list of todos from provider.  // Holt die aktuelle Liste von Todos vom Provider.
  double minTodoPageHeight = ref.watch(minHeightProvider);  // Get minimum height from provider.  // Holt die Mindesthöhe vom Provider.
  double todoPageHeight = minTodoPageHeight;  // Initialize page height with minimum height.  // Initialisiert die Seitenhöhe mit der Mindesthöhe.
  for (var todo in todos) {  // Loop through each todo.  // Schleife durch jedes Todo.
    todoPageHeight += ref
        .read(taskListProvider.notifier)
        .calculateTaskHeight(todo.title, todo.description);  // Add calculated height based on content.  // Fügt berechnete Höhe basierend auf dem Inhalt hinzu.
  }
  print("Current MinTodoPageHeight: $minTodoPageHeight");  // Debug print of minimum height.  // Debug-Ausgabe der Mindesthöhe.
  print("Current TodoPageHeight: $todoPageHeight");  // Debug print of total height.  // Debug-Ausgabe der Gesamthöhe.
  return max(todoPageHeight, 0.0);  // Return max of calculated height or 0.  // Gibt das Maximum aus berechneter Höhe oder 0 zurück.
});

class MinHeight extends StateNotifier<double> {  // Class to manage minimum height state.  // Klasse zur Verwaltung des Mindesthöhenzustands.
  double _baseHeight;  // Private variable for base height.  // Private Variable für die Basishöhe.
  MinHeight()
      : _baseHeight = 0.0,
        super(0.0) {  // Constructor initializes base height and state to 0.  // Konstruktor initialisiert Basishöhe und Zustand auf 0.
    _initializeBaseHeight();  // Call initialization method.  // Ruft die Initialisierungsmethode auf.
  }
  
  _initializeBaseHeight() async {  // Private method to load height from storage.  // Private Methode zum Laden der Höhe aus dem Speicher.
    _baseHeight = await HiveServices.retrieveBaseHeight();  // Get saved height from storage.  // Holt gespeicherte Höhe aus dem Speicher.
    state = _baseHeight;  // Update state with loaded height.  // Aktualisiert Zustand mit geladener Höhe.
  }
  
  void resetHeight() {  // Method to reset height to 0.  // Methode zum Zurücksetzen der Höhe auf 0.
    _baseHeight = 0.0;  // Set base height to 0.  // Setzt Basishöhe auf 0.
    state = _baseHeight;  // Update state with new height.  // Aktualisiert Zustand mit neuer Höhe.
  }
  
  void increaseHeight(double baseTaskHeight) {  // Method to increase height.  // Methode zum Erhöhen der Höhe.
    _baseHeight = 300.0;  // Set directly to 300.  // Setzt direkt auf 300.
    state = _baseHeight;  // Update state with new height.  // Aktualisiert Zustand mit neuer Höhe.
    HiveServices.saveBaseHeight(_baseHeight);  // Save new height to storage.  // Speichert neue Höhe im Speicher.
  }
  
  void decreaseHeight(double baseTaskHeight) {  // Method to decrease height.  // Methode zum Verringern der Höhe.
    _baseHeight = 0.0;  // Set directly to 0.  // Setzt direkt auf 0.
    state = _baseHeight;  // Update state with new height.  // Aktualisiert Zustand mit neuer Höhe.
    HiveServices.saveBaseHeight(_baseHeight);  // Save new height to storage.  // Speichert neue Höhe im Speicher.
  }
}

final minHeightProvider = StateNotifierProvider<MinHeight, double>((ref) {  // Provider for minimum height state.  // Provider für den Mindesthöhenzustand.
  return MinHeight();  // Return new MinHeight instance.  // Gibt neue MinHeight-Instanz zurück.
});

final showSnackbarProvider = StateNotifierProvider<ShowSnackbar, bool>((ref) {  // Provider for snackbar visibility state.  // Provider für den Sichtbarkeitszustand der Snackbar.
  return ShowSnackbar();  // Return new ShowSnackbar instance.  // Gibt neue ShowSnackbar-Instanz zurück.
});

class ShowSnackbar extends StateNotifier<bool> {  // Class to manage snackbar visibility.  // Klasse zur Verwaltung der Snackbar-Sichtbarkeit.
  ShowSnackbar() : super(false);  // Constructor initializes state to false (hidden).  // Konstruktor initialisiert Zustand auf false (versteckt).
  
  void show() {  // Method to show the snackbar.  // Methode zum Anzeigen der Snackbar.
    state = true;  // Set state to true (visible).  // Setzt Zustand auf true (sichtbar).
  }
  
  void hide() {  // Method to hide the snackbar.  // Methode zum Ausblenden der Snackbar.
    state = false;  // Set state to false (hidden).  // Setzt Zustand auf false (versteckt).
  }
}
