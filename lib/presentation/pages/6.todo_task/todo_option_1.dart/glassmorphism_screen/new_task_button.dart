/// NewTaskButton
/// 
/// A widget that provides a button for adding new tasks to the application. // Ein Widget, das eine Schaltfläche zum Hinzufügen neuer Aufgaben zur Anwendung bereitstellt.
/// Used in task management screens to allow users to create new todo items with an emphasis on single-tasking. // Wird in Aufgabenverwaltungsbildschirmen verwendet, um Benutzern das Erstellen neuer Todo-Elemente zu ermöglichen, mit einem Schwerpunkt auf Einzelaufgaben.
/// 
/// Usage:
/// ```dart
/// NewTaskButton(
///   onNewTask: (todo) {
///     // Handle the new task
///   },
/// )
/// ```
/// 
/// EN: Displays a floating action button that creates new tasks and encourages single-tasking with helpful feedback.
/// DE: Zeigt eine schwebende Aktionsschaltfläche an, die neue Aufgaben erstellt und Einzelaufgaben mit hilfreichen Rückmeldungen fördert.

import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets from Flutter for iOS-style components. // Importiert Cupertino-Widgets aus Flutter für iOS-Stil-Komponenten.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter for Android-style components. // Importiert Material Design-Widgets aus Flutter für Android-Stil-Komponenten.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for text styling. // Importiert das Google Fonts-Paket für die Textgestaltung.
import '../../../../../common/widgets/domain/entities/todo_entity.dart'; // Imports the Todo entity model. // Importiert das Todo-Entitätsmodell.
import '../../../../notifiers/providers.dart'; // Imports application providers for state management. // Importiert Anwendungsprovider für die Zustandsverwaltung.
import '../../../../notifiers/task_notifier.dart'; // Imports task-specific notifier for state updates. // Importiert aufgabenspezifischen Notifier für Zustandsaktualisierungen.
import '../../../../repository/auth_repository.dart'; // Imports authentication repository for user operations. // Importiert Authentifizierungsrepository für Benutzeroperationen.


class NewTaskButton extends ConsumerWidget { // Defines a stateless widget that can access Riverpod providers. // Definiert ein zustandsloses Widget, das auf Riverpod-Provider zugreifen kann.
  final Function(Todo) onNewTask; // Callback function that is called when a new task is created. // Callback-Funktion, die aufgerufen wird, wenn eine neue Aufgabe erstellt wird.

  const NewTaskButton({ // Constructor for the widget. // Konstruktor für das Widget.
    super.key, // Key parameter passed to parent class. // Key-Parameter, der an die Elternklasse übergeben wird.
    required this.onNewTask, // Required callback parameter for handling new tasks. // Erforderlicher Callback-Parameter für die Behandlung neuer Aufgaben.
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Builds the widget UI with access to Riverpod ref. // Baut die Widget-Benutzeroberfläche mit Zugriff auf Riverpod-Ref auf.
    final tasks = ref.watch(taskListProvider); // Watches the current list of tasks from the provider. // Beobachtet die aktuelle Liste der Aufgaben vom Provider.
    final user = ref.watch(userProvider); // Watches the current user from the provider. // Beobachtet den aktuellen Benutzer vom Provider.

    return Column( // Creates a column layout. // Erstellt ein Spaltenlayout.
      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches the children horizontally to fill the column. // Streckt die Kinder horizontal, um die Spalte zu füllen.
      mainAxisAlignment: MainAxisAlignment.start, // Aligns children at the start of the main axis (top). // Richtet Kinder am Anfang der Hauptachse (oben) aus.
      children: [ // List of widgets in the column. // Liste der Widgets in der Spalte.
        const Padding( // Adds padding around nothing (spacer). // Fügt Polsterung um nichts herum hinzu (Abstandshalter).
          padding: EdgeInsets.only(left: 23.0, right: 23.0), // Sets padding on left and right sides only. // Setzt Polsterung nur auf der linken und rechten Seite.
        ),
        FloatingActionButton.extended( // Creates an extended floating action button. // Erstellt eine erweiterte schwebende Aktionsschaltfläche.
          heroTag: 'fab1', // Unique tag for hero animations. // Eindeutiger Tag für Hero-Animationen.
          icon: const Icon(CupertinoIcons.add), // Uses an add icon from Cupertino icon set. // Verwendet ein Hinzufügen-Symbol aus dem Cupertino-Icon-Set.
          label: ConstrainedBox( // Creates a box with constraints for the button label. // Erstellt einen Kasten mit Beschränkungen für die Schaltflächenbeschriftung.
            constraints: const BoxConstraints(maxWidth: 100, maxHeight: 20), // Limits the size of the label. // Begrenzt die Größe der Beschriftung.
            child: Text( // Creates a text widget for the button label. // Erstellt ein Text-Widget für die Schaltflächenbeschriftung.
              'Add task', // The button text. // Der Schaltflächentext.
              style: GoogleFonts.nunito( // Applies Nunito font style from Google Fonts. // Wendet den Nunito-Schriftstil von Google Fonts an.
                color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt die Textfarbe auf Hellgrau.
                fontSize: 18, // Sets the font size to 18 logical pixels. // Setzt die Schriftgröße auf 18 logische Pixel.
                fontWeight: FontWeight.w600, // Sets the font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
              ),
            ),
          ),
          backgroundColor:
           const Color.fromARGB(255, 0, 0, 0), // Sets the button color to black. // Setzt die Schaltflächenfarbe auf Schwarz.
          onPressed: () async { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
            if (tasks.isNotEmpty) { // Checks if there are already tasks in the list. // Prüft, ob bereits Aufgaben in der Liste vorhanden sind.
              ScaffoldMessenger.of(context).showSnackBar( // Shows a snackbar message if tasks exist. // Zeigt eine Snackbar-Nachricht an, wenn Aufgaben existieren.
                SnackBar( // Creates a snackbar for displaying temporary messages. // Erstellt eine Snackbar zur Anzeige temporärer Nachrichten.
                  content: Row( // Creates a row layout for the snackbar content. // Erstellt ein Zeilenlayout für den Snackbar-Inhalt.
                    children: [ // List of widgets in the row. // Liste der Widgets in der Zeile.
                      const Icon(CupertinoIcons.lightbulb, size: 20), // Adds a lightbulb icon. // Fügt ein Glühbirnen-Symbol hinzu.
                      const SizedBox(width: 8), // Adds 8-pixel horizontal spacing. // Fügt 8 Pixel horizontalen Abstand hinzu.
                      Expanded( // Expands the child to fill available space. // Erweitert das Kind, um verfügbaren Platz zu füllen.
                        child: Text( // Creates a text widget for the message. // Erstellt ein Text-Widget für die Nachricht.
                          "Your brain loves it when you tackle one task at a time. Let's embrace the power of single-tasking, and watch how efficiently you complete it!", // Message encouraging single-tasking. // Nachricht, die Einzelaufgaben fördert.
                          style: GoogleFonts.nunito( // Applies Nunito font style. // Wendet den Nunito-Schriftstil an.
                            fontSize: 16, // Sets the font size to 16 logical pixels. // Setzt die Schriftgröße auf 16 logische Pixel.
                            color: const Color(0xffF2F2F2), // Sets text color to light gray. // Setzt die Textfarbe auf Hellgrau.
                          ),
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 8), // Sets snackbar display time to 8 seconds. // Setzt die Snackbar-Anzeigezeit auf 8 Sekunden.
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Sets snackbar background to black. // Setzt den Snackbar-Hintergrund auf Schwarz.
                ),
              );
            } else { // If there are no existing tasks. // Wenn keine vorhandenen Aufgaben existieren.

              var todo = Todo( // Creates a new Todo object. // Erstellt ein neues Todo-Objekt.
                title: '', // Sets empty title for new task. // Setzt leeren Titel für neue Aufgabe.
                description: "", // Sets empty description for new task. // Setzt leere Beschreibung für neue Aufgabe.
                isEditable: true, // Makes the new task editable. // Macht die neue Aufgabe bearbeitbar.
              );
              
              if (user != null) { // If a user is logged in. // Wenn ein Benutzer angemeldet ist.
                ref.read(taskDeletionsProvider.notifier).set(false); // Disables task deletion mode. // Deaktiviert den Aufgaben-Löschmodus.
                   ref.read(toDoHappySadToggleProvider.notifier).set(false); // Resets the happy/sad toggle state. // Setzt den Glücklich/Traurig-Umschaltzustand zurück.
                  ref.read(taskCardTitleProvider.notifier).updateTitle(''); // Clears the task card title. // Löscht den Aufgabenkartentitel.
                await ref.read(authRepositoryProvider).updateCardTodoTask( // Updates the task in the authentication repository. // Aktualisiert die Aufgabe im Authentifizierungsrepository.
                  false, // Sets first parameter to false. // Setzt ersten Parameter auf false.
                  false, // Sets second parameter to false. // Setzt zweiten Parameter auf false.
                  '' // Sets empty string for the third parameter. // Setzt leeren String für den dritten Parameter.
                );
              }
              onNewTask(todo); // Calls the callback with the new task. // Ruft den Callback mit der neuen Aufgabe auf.    
            }
          },
        ),
      ],
    );
  }
}
