/// EditableTaskTitle
/// 
/// A widget that provides an editable text field for task titles in the application. // Ein Widget, das ein bearbeitbares Textfeld für Aufgabentitel in der Anwendung bereitstellt.
/// Synchronizes task title changes across local storage and server while providing real-time updates. // Synchronisiert Änderungen an Aufgabentiteln über lokalen Speicher und Server und bietet Echtzeit-Updates.
/// 
/// Usage:
/// ```dart
/// EditableTaskTitle(todo: todoItem)
/// ```
/// 
/// EN: Displays a text field for viewing and editing task titles with automatic saving functionality.
/// DE: Zeigt ein Textfeld zur Anzeige und Bearbeitung von Aufgabentiteln mit automatischer Speicherfunktion.

import 'package:flutter/material.dart'; // Imports basic Flutter material design widgets. // Importiert grundlegende Flutter Material-Design-Widgets.
import 'package:flutter/services.dart'; // Imports system services like text input formatters. // Importiert Systemdienste wie Texteingabeformatierer.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for text styling. // Importiert Google Fonts für die Textstilisierung.
import '../../../common/widgets/domain/entities/todo_entity.dart'; // Imports the Todo entity model. // Importiert das Todo-Entitätsmodell.
import '../../notifiers/providers.dart'; // Imports application providers. // Importiert Anwendungs-Provider.
import '../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.


class EditableTaskTitle extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod consumer capabilities. // Definiert ein Stateful-Widget mit Riverpod-Consumer-Fähigkeiten.
 final Todo todo; // The Todo item to edit. // Das zu bearbeitende Todo-Element.
 const EditableTaskTitle({required this.todo, super.key}); // Constructor requiring a Todo and optional key. // Konstruktor, der ein Todo und optionalen Schlüssel erfordert.

 @override
 ConsumerState<ConsumerStatefulWidget> createState() => _EditableTaskTitleState(); // Creates the state for this widget. // Erstellt den State für dieses Widget.
}

class _EditableTaskTitleState extends ConsumerState<EditableTaskTitle> { // Defines the state class for EditableTaskTitle. // Definiert die State-Klasse für EditableTaskTitle.
 static const String DEFAULT_HINT_TEXT = 'Write task title...'; // Default placeholder text. // Standard-Platzhaltertext.
 TextEditingController? _controller; // Controller for the text field. // Controller für das Textfeld.
 
 @override
 void initState() { // Initializes the widget state. // Initialisiert den Widget-State.
   super.initState(); // Calls parent initialization. // Ruft die übergeordnete Initialisierung auf.
   _initializeController(); // Sets up the text controller. // Richtet den Text-Controller ein.
 }


void _initializeController() { // Method to initialize the text controller. // Methode zur Initialisierung des Text-Controllers.
  final user = ref.read(userProvider); // Gets current user from provider. // Holt aktuellen Benutzer vom Provider.
  final savedTitle = user?.taskCardTitle ?? ''; // Gets saved title or empty string. // Holt gespeicherten Titel oder leeren String.
  
  _controller = TextEditingController(text: savedTitle); // Creates text controller with saved title. // Erstellt Text-Controller mit gespeichertem Titel.
  widget.todo.title = savedTitle; // Updates todo title with saved title. // Aktualisiert Todo-Titel mit gespeichertem Titel.
  
  if (savedTitle.isNotEmpty) { // Checks if saved title exists. // Prüft, ob gespeicherter Titel existiert.
    ref.read(taskCardTitleProvider.notifier).updateTitle(savedTitle); // Updates title in provider. // Aktualisiert Titel im Provider.
  }
  
  _controller?.addListener(_handleTextChange); // Adds change listener to controller. // Fügt dem Controller einen Änderungs-Listener hinzu.
}

void _handleTextChange() { // Method to handle text changes. // Methode zur Behandlung von Textänderungen.
  if (_controller != null && mounted) { // Checks if controller exists and widget is mounted. // Prüft, ob Controller existiert und Widget eingebunden ist.
    final text = _controller!.text; // Gets current text. // Holt aktuellen Text.
    final user = ref.read(userProvider); // Gets current user. // Holt aktuellen Benutzer.
    
    widget.todo.title = text; // Updates todo title. // Aktualisiert Todo-Titel.
    
    if (user != null) { // Checks if user is logged in. // Prüft, ob Benutzer angemeldet ist.
      ref.read(localStorageRepositoryProvider).setTaskCardTitle(text); // Saves title to local storage. // Speichert Titel im lokalen Speicher.
      ref.read(taskCardTitleProvider.notifier).updateTitle(text); // Updates title in provider. // Aktualisiert Titel im Provider.
      
      ref.read(authRepositoryProvider).updateCardTodoTask( // Updates task on server. // Aktualisiert Aufgabe auf dem Server.
        ref.read(toDoHappySadToggleProvider), // Gets happy/sad toggle state. // Holt Happy/Sad-Umschaltzustand.
        ref.read(taskDeletionsProvider), // Gets task deletion preference. // Holt Aufgabenlöschungs-Präferenz.
        text, // Passes the new title. // Übergibt den neuen Titel.
      );
    }
  }
}

 @override
 void dispose() { // Cleans up resources when widget is removed. // Bereinigt Ressourcen, wenn Widget entfernt wird.
   _controller?.removeListener(_handleTextChange); // Removes the change listener. // Entfernt den Änderungs-Listener.
   _controller?.dispose(); // Disposes the text controller. // Entsorgt den Text-Controller.
   super.dispose(); // Calls parent disposal. // Ruft übergeordnete Entsorgung auf.
 }

 @override
 Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
   final user = ref.watch(userProvider); // Watches user state for changes. // Überwacht Benutzerzustand auf Änderungen.
   
   return Row( // Creates a row layout. // Erstellt ein Zeilenlayout.
     mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spaces children at ends. // Verteilt Kinder an den Enden.
     children: [ // List of row children. // Liste der Zeilenkinder.
       Expanded( // Makes child expand to fill space. // Lässt Kind expandieren, um Platz zu füllen.
         child: Padding( // Adds padding. // Fügt Polsterung hinzu.
           padding: const EdgeInsets.only(left: 10, right: 10), // Sets horizontal padding. // Setzt horizontale Polsterung.
           child: SizedBox( // Creates a fixed size box. // Erstellt eine Box mit fester Größe.
             width: 80, // Sets minimum width. // Setzt Mindestbreite.
             child: TextField( // Creates a text input field. // Erstellt ein Texteingabefeld.
               controller: _controller, // Sets the text controller. // Setzt den Text-Controller.
               maxLength: 50, // Limits text to 50 characters. // Begrenzt Text auf 50 Zeichen.
               style: GoogleFonts.nunito( // Sets text style with Google Fonts. // Setzt Textstil mit Google Fonts.
                 color: const Color(0xffF2F2F2), // Sets light gray text color. // Setzt hellgraue Textfarbe.
                 fontSize: 20.0, // Sets font size. // Setzt Schriftgröße.
                 fontWeight: FontWeight.w500, // Sets medium font weight. // Setzt mittlere Schriftstärke.
               ),
               decoration: const InputDecoration( // Configures input appearance. // Konfiguriert Eingabeerscheinung.
                 border: InputBorder.none, // Removes input border. // Entfernt Eingaberahmen.
                 hintText: DEFAULT_HINT_TEXT, // Sets placeholder text. // Setzt Platzhaltertext.
                 hintStyle: TextStyle( // Sets placeholder style. // Setzt Platzhalter-Stil.
                   color: Color(0xffF2F2F2), // Sets light gray color. // Setzt hellgraue Farbe.
                 ),
                 counterStyle: TextStyle( // Sets character counter style. // Setzt Zeichenzähler-Stil.
                   color: Color(0xffF2F2F2), // Sets light gray color. // Setzt hellgraue Farbe.
                 ),
               ),
               enabled: widget.todo.isEditable, // Enables editing based on todo state. // Aktiviert Bearbeitung basierend auf Todo-Zustand.
               onChanged: (text) async { // Callback when text changes. // Callback bei Textänderungen.
                 widget.todo.title = text; // Updates todo title. // Aktualisiert Todo-Titel.
                 
                 if (user != null) { // Checks if user is logged in. // Prüft, ob Benutzer angemeldet ist.
                   ref.read(taskCardTitleProvider.notifier).updateTitle(text); // Updates title in provider. // Aktualisiert Titel im Provider.
                   ref.read(localStorageRepositoryProvider).setTaskCardTitle(text); // Saves to local storage. // Speichert im lokalen Speicher.
                  
                   try { // Try block for error handling. // Try-Block zur Fehlerbehandlung.
                     await ref.read(authRepositoryProvider).updateCardTodoTask( // Updates task on server. // Aktualisiert Aufgabe auf dem Server.
                       ref.read(toDoHappySadToggleProvider), // Gets happy/sad toggle state. // Holt Happy/Sad-Umschaltzustand.
                       ref.read(taskDeletionsProvider), // Gets task deletion preference. // Holt Aufgabenlöschungs-Präferenz.
                       text, // Passes the new title. // Übergibt den neuen Titel.
                     );
                   } catch (e) { // Catches any errors. // Fängt alle Fehler ab.
                     print('Error updating task in server: $e'); // Logs error message. // Protokolliert Fehlermeldung.
                   }
                 }


                  final focusedTaskNotifier =
                      ref.read(focusedTaskTitleProvider.notifier); // Gets focused task notifier. // Holt fokussierten Aufgaben-Notifier.
                  if (widget.todo.isFocused) { // Checks if todo is focused. // Prüft, ob Todo fokussiert ist.
                    focusedTaskNotifier.state = text; // Updates focused task title. // Aktualisiert fokussierten Aufgabentitel.
                  }

                  final authRepository = ref.read(authRepositoryProvider); // Gets auth repository. // Holt Auth-Repository.
                  final toDoHappySadToggle = ref.read(toDoHappySadToggleProvider); // Gets happy/sad toggle state. // Holt Happy/Sad-Umschaltzustand.
                  final taskDeletionByTrashIcon = ref.read(taskDeletionsProvider); // Gets task deletion preference. // Holt Aufgabenlöschungs-Präferenz.
                  
                  await authRepository.updateCardTodoTask( // Updates task on server again. // Aktualisiert Aufgabe erneut auf dem Server.
                    toDoHappySadToggle, // Passes happy/sad toggle state. // Übergibt Happy/Sad-Umschaltzustand.
                    taskDeletionByTrashIcon, // Passes task deletion preference. // Übergibt Aufgabenlöschungs-Präferenz.
                    text, // Passes the new title. // Übergibt den neuen Titel.
                  );

                 if (widget.todo.isFocused) { // Checks if todo is focused again. // Prüft erneut, ob Todo fokussiert ist.
                   ref.read(focusedTaskTitleProvider.notifier).state = text; // Updates focused task title again. // Aktualisiert fokussierten Aufgabentitel erneut.
                 }
               },
               maxLines: null, // Allows unlimited lines. // Erlaubt unbegrenzte Zeilenanzahl.
               minLines: 1, // Ensures at least one line. // Stellt mindestens eine Zeile sicher.
               scrollPhysics: const BouncingScrollPhysics(), // Sets bouncing scroll effect. // Setzt Federschroll-Effekt.
               keyboardType: TextInputType.multiline, // Enables multiline keyboard. // Aktiviert mehrzeiliges Keyboard.
               inputFormatters: [ // List of input formatters. // Liste von Eingabeformatierern.
                 FilteringTextInputFormatter.deny(RegExp(r'\n')) // Prevents newline characters. // Verhindert Zeilenumbruchzeichen.
               ],
             ),
           ),
         ),
       ),
     ],
   );
 }
}
