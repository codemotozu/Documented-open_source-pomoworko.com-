/// AddProyectName
/// 
/// A widget for managing project creation and editing with color-coded circular indicators. // Ein Widget zur Verwaltung der Projekterstellung und -bearbeitung mit farbcodierten kreisförmigen Indikatoren.
/// Allows users to add new projects, select existing projects, and edit project names. // Ermöglicht Benutzern, neue Projekte hinzuzufügen, bestehende Projekte auszuwählen und Projektnamen zu bearbeiten.
/// 
/// Usage:
/// ```dart
/// AddProyectName(
///   Colors.blue,
///   index: 0,
///   isEditable: true,
///   isEditIconVisible: true,
/// )
/// ```
/// 
/// EN: Displays a color-coded circle for project selection with conditional editing capabilities.
/// DE: Zeigt einen farbcodierten Kreis zur Projektauswahl mit bedingten Bearbeitungsfunktionen an.

import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets from Flutter. // Importiert Cupertino-Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter/services.dart'; // Imports system services like mouse cursors. // Importiert Systemdienste wie Mauszeiger.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../notifiers/persistent_container_notifier.dart'; // Imports container state management. // Importiert Container-Zustandsverwaltung.
import '../notifiers/project_state_notifier.dart'; // Imports project state management. // Importiert Projekt-Zustandsverwaltung.
import '../notifiers/project_time_notifier.dart'; // Imports project time tracking management. // Importiert Projekt-Zeiterfassungsverwaltung.
import '../notifiers/providers.dart'; // Imports application providers. // Importiert Anwendungs-Provider.


class AddProyectName extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod consumer capabilities. // Definiert ein Stateful-Widget mit Riverpod-Consumer-Fähigkeiten.
  final Color color; // The color of the project circle. // Die Farbe des Projektkreises.
  final Icon? icon; // Optional icon to display in the circle. // Optionales Symbol zur Anzeige im Kreis.
  final int index; // The index of this project in the list. // Der Index dieses Projekts in der Liste.
  final bool isEditable; // Whether this project can be edited. // Ob dieses Projekt bearbeitet werden kann.
  final bool isEditIconVisible; // Whether to show the edit icon. // Ob das Bearbeitungssymbol angezeigt werden soll.

  final Function(PointerEnterEvent)? onEnterContainerHover; // Callback for mouse enter event. // Callback für Maus-Eintrittsereignis.
  final Function(PointerExitEvent)? onExitContainerHover; // Callback for mouse exit event. // Callback für Maus-Austrittsereignis.

  const AddProyectName(this.color, // Constructor with required color. // Konstruktor mit erforderlicher Farbe.
      {required this.index, // Required project index. // Erforderlicher Projektindex.
      this.icon, // Optional icon. // Optionales Symbol.
      this.isEditable = false, // Default to not editable. // Standardmäßig nicht bearbeitbar.
      super.key, // Optional key for widget. // Optionaler Schlüssel für Widget.
      this.isEditIconVisible = false, // Default to hide edit icon. // Standardmäßig Bearbeitungssymbol ausblenden.
      this.onEnterContainerHover, // Optional mouse enter callback. // Optionaler Maus-Eintritts-Callback.
      this.onExitContainerHover}); // Optional mouse exit callback. // Optionaler Maus-Austritts-Callback.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProyectNameState(); // Creates the state for this widget. // Erstellt den State für dieses Widget.
}

class _AddProyectNameState extends ConsumerState<AddProyectName> { // Defines the state class for AddProyectName. // Definiert die State-Klasse für AddProyectName.
  bool _isHovered = false; // Tracks whether the edit icon is hovered. // Verfolgt, ob das Bearbeitungssymbol überfahren wird.



@override
Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
  final projectNames = ref.watch(projectStateNotifierProvider); // Gets project names from provider. // Holt Projektnamen vom Provider.
  final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets selected container index. // Holt ausgewählten Container-Index.
  bool hasProjectName = widget.index < projectNames.length &&
      projectNames[widget.index] != 'Add a project'; // Checks if project has a real name. // Prüft, ob Projekt einen echten Namen hat.

  String tooltipMessage = projectNames.isNotEmpty &&
          widget.index < projectNames.length &&
          projectNames[widget.index] != 'Add a project'
      ? ''
      : widget.isEditable ? 'Add a Project' : 'Premium Feature'; // Sets tooltip based on state. // Setzt Tooltip basierend auf Zustand.

  return MouseRegion( // Creates a mouse-sensitive region. // Erstellt einen maussensitiven Bereich.
    onEnter: widget.onEnterContainerHover, // Sets mouse enter callback. // Setzt Maus-Eintritts-Callback.
    onExit: widget.onExitContainerHover, // Sets mouse exit callback. // Setzt Maus-Austritts-Callback.
    cursor: SystemMouseCursors.click, // Sets pointer cursor on hover. // Setzt Zeigercursor beim Überfahren.
    child: Container( // Creates a container for the project. // Erstellt einen Container für das Projekt.
      height: 66, // Sets container height. // Setzt Container-Höhe.
      width: 27, // Sets container width. // Setzt Container-Breite.
      decoration: BoxDecoration( // Sets container decoration. // Setzt Container-Dekoration.
        border: Border.all( // Adds border around container. // Fügt Rand um Container hinzu.
          color: Colors.transparent, // Makes border invisible. // Macht Rand unsichtbar.
        ),
      ),
      child: SingleChildScrollView( // Allows content to scroll if needed. // Ermöglicht Scrollen des Inhalts bei Bedarf.
        scrollDirection: Axis.horizontal, // Sets horizontal scroll direction. // Setzt horizontale Scrollrichtung.
        child: Row( // Creates a row layout. // Erstellt ein Zeilenlayout.
          children: [ // List of row children. // Liste der Zeilenkinder.
            Column( // Creates a column layout. // Erstellt ein Spaltenlayout.
              mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically. // Zentriert Kinder vertikal.
              crossAxisAlignment: CrossAxisAlignment.center, // Centers children horizontally. // Zentriert Kinder horizontal.
              children: [ // List of column children. // Liste der Spaltenkinder.
                GestureDetector( // Creates a gesture-sensitive area. // Erstellt einen gestensensitiven Bereich.
                  onTap: widget.isEditable
                      ? () {
                          ref.read(persistentContainerIndexProvider.notifier).updateIndex(widget.index); // Sets selected container to this index. // Setzt ausgewählten Container auf diesen Index.

                          if (widget.index >= projectNames.length ||
                              projectNames[widget.index] == 'Add a project') {
                            _showAddDialog(context, 'Add a Project',
                                'Please, add a name for the project'); // Shows add dialog if this is a new project. // Zeigt Hinzufügen-Dialog an, wenn dies ein neues Projekt ist.
                          }
                        }
                      : null, // Disables tap if not editable. // Deaktiviert Tippen, wenn nicht bearbeitbar.
                  child: Tooltip( // Adds tooltip to circle. // Fügt Tooltip zum Kreis hinzu.
                    message: tooltipMessage, // Sets tooltip message. // Setzt Tooltip-Nachricht.
                    child: Container( // Creates outer circle container. // Erstellt äußeren Kreiscontainer.
                      width: 24, // Sets circle width. // Setzt Kreisbreite.
                      height: 24, // Sets circle height. // Setzt Kreishöhe.
                      decoration: BoxDecoration( // Sets decoration for outer circle. // Setzt Dekoration für äußeren Kreis.
                        shape: BoxShape.circle, // Makes container circular. // Macht Container kreisförmig.
                        border: selectedContainerIndex == widget.index
                            ? Border.all(
                                color: const Color.fromARGB(255, 228, 228, 228),
                                width: 2.5) // Adds white border if selected. // Fügt weißen Rand hinzu, wenn ausgewählt.
                            : null, // No border if not selected. // Kein Rand, wenn nicht ausgewählt.
                      ),
                      child: Container( // Creates inner circle container. // Erstellt inneren Kreiscontainer.
                        decoration: BoxDecoration( // Sets decoration for inner circle. // Setzt Dekoration für inneren Kreis.
                          color: widget.color, // Sets circle color from parameter. // Setzt Kreisfarbe aus Parameter.
                          shape: BoxShape.circle, // Makes container circular. // Macht Container kreisförmig.
                          border: selectedContainerIndex == widget.index
                              ? Border.all(color: Colors.black, width: 1.0) // Adds black border if selected. // Fügt schwarzen Rand hinzu, wenn ausgewählt.
                              : null, // No border if not selected. // Kein Rand, wenn nicht ausgewählt.
                        ),
                        child: widget.icon != null
                            ? Center(child: widget.icon) // Centers icon if provided. // Zentriert Symbol, wenn vorhanden.
                            : null, // No icon if not provided. // Kein Symbol, wenn nicht vorhanden.
                      ),
                    ),
                  ),
                ),
                Visibility( // Conditionally shows edit icon. // Zeigt bedingt Bearbeitungssymbol an.
                  visible: hasProjectName &&
                      selectedContainerIndex == widget.index &&
                      widget.isEditIconVisible, // Shows edit icon if project is selected and editable. // Zeigt Bearbeitungssymbol an, wenn Projekt ausgewählt und bearbeitbar ist.
                  replacement: const SizedBox( // Shows empty space if edit icon not visible. // Zeigt leeren Raum an, wenn Bearbeitungssymbol nicht sichtbar ist.
                    height: 40, // Sets placeholder height. // Setzt Platzhalterhöhe.
                    width: 25, // Sets placeholder width. // Setzt Platzhalterbreite.
                  ),
                  child: MouseRegion( // Creates mouse-sensitive region for edit icon. // Erstellt maussensitiven Bereich für Bearbeitungssymbol.
                    onEnter: (_) => setState(() => _isHovered = true), // Sets hover state to true on mouse enter. // Setzt Hover-Zustand auf true bei Mauseintritt.
                    onExit: (_) => setState(() => _isHovered = false), // Sets hover state to false on mouse exit. // Setzt Hover-Zustand auf false bei Mausaustritt.
                    cursor: SystemMouseCursors.click, // Sets pointer cursor on hover. // Setzt Zeigercursor beim Überfahren.
                    child: Tooltip( // Adds tooltip to edit icon. // Fügt Tooltip zum Bearbeitungssymbol hinzu.
                      message: "Edit Project", // Sets tooltip message. // Setzt Tooltip-Nachricht.
                      decoration: BoxDecoration( // Sets tooltip decoration. // Setzt Tooltip-Dekoration.
                        color: Colors.white, // Sets white background for tooltip. // Setzt weißen Hintergrund für Tooltip.
                        borderRadius: BorderRadius.circular(4.0), // Rounds tooltip corners. // Rundet Tooltip-Ecken ab.
                      ),
                      child: Container( // Creates container for edit icon. // Erstellt Container für Bearbeitungssymbol.
                        decoration: BoxDecoration( // Sets decoration for edit icon container. // Setzt Dekoration für Bearbeitungssymbol-Container.
                          shape: BoxShape.circle, // Makes container circular. // Macht Container kreisförmig.
                          color: _isHovered
                              ? Colors.white30 // Semi-transparent white when hovered. // Halbtransparentes Weiß beim Überfahren.
                              : Colors.transparent, // Transparent when not hovered. // Transparent, wenn nicht überfahren.
                        ),
                        height: 40, // Sets icon container height. // Setzt Symbol-Container-Höhe.
                        width: 25, // Sets icon container width. // Setzt Symbol-Container-Breite.
                        child: GestureDetector( // Creates gesture detector for edit icon. // Erstellt Gestenerkennung für Bearbeitungssymbol.
                          onTap: () { // Function when edit icon is tapped. // Funktion, wenn Bearbeitungssymbol angetippt wird.
                            _showEditDialog(context, 'Edit Project',
                                'Please edit the project name', widget.index); // Shows edit dialog. // Zeigt Bearbeitungsdialog an.
                          },
                          child: const Icon(Icons.edit, // Uses edit pencil icon. // Verwendet Bearbeitungs-Bleistift-Symbol.
                              color: Colors.white, size: 20), // White icon, 20 pixels size. // Weißes Symbol, 20 Pixel groß.
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showAddDialog(BuildContext context, String title, String placeholder) { // Method to show add project dialog. // Methode zum Anzeigen des Projekt-Hinzufügen-Dialogs.
  String projectTitle = ''; // Variable to store new project name. // Variable zum Speichern des neuen Projektnamens.
  final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets currently selected container index. // Holt aktuell ausgewählten Container-Index.

  showDialog( // Shows dialog overlay. // Zeigt Dialogoverlay an.
    context: context, // Current build context. // Aktueller Build-Kontext.
    builder: (BuildContext context) { // Dialog builder function. // Dialog-Builder-Funktion.
      return CupertinoAlertDialog( // Creates iOS-style dialog. // Erstellt iOS-Stil-Dialog.
        title: Text(title), // Sets dialog title. // Setzt Dialogtitel.
        content: Column( // Creates column layout for content. // Erstellt Spaltenlayout für Inhalt.
          mainAxisSize: MainAxisSize.min, // Makes column as small as needed. // Macht Spalte so klein wie nötig.
          children: [ // List of column children. // Liste der Spaltenkinder.
            Text(placeholder), // Shows instruction text. // Zeigt Anweisungstext an.
            const SizedBox(height: 16), // Adds vertical spacing. // Fügt vertikalen Abstand hinzu.
            CupertinoTextField( // Creates iOS-style text field. // Erstellt iOS-Stil-Textfeld.
              placeholder: 'Project name', // Sets placeholder text. // Setzt Platzhaltertext.
              style: const TextStyle(color: Colors.white), // Sets white text color. // Setzt weiße Textfarbe.
              onChanged: (value) { // Function when text changes. // Funktion bei Textänderungen.
                projectTitle = value; // Updates project title variable. // Aktualisiert Projekttitel-Variable.
              },
            ),
          ],
        ),
        actions: [ // Dialog action buttons. // Dialog-Aktionsschaltflächen.
          CupertinoDialogAction( // Creates iOS-style button. // Erstellt iOS-Stil-Schaltfläche.
            child: const Text('OK'), // Sets button text. // Setzt Schaltflächentext.
            onPressed: () { // Function when OK is pressed. // Funktion, wenn OK gedrückt wird.
              if (projectTitle.isNotEmpty) { // Checks if project title was entered. // Prüft, ob Projekttitel eingegeben wurde.
                ref.read(projectStateNotifierProvider.notifier)
                    .addProject(projectTitle, selectedContainerIndex, ref); // Adds new project to state. // Fügt neues Projekt zum Zustand hinzu.
                ref.read(projectTimesProvider.notifier).addTime(
                    selectedContainerIndex, DateTime.now(), Duration.zero); // Initializes project time tracking. // Initialisiert Projekt-Zeiterfassung.
              }
              Navigator.pop(context); // Closes the dialog. // Schließt den Dialog.
            },
          ),
        ],
      );
    },
  );
}

void _showEditDialog(BuildContext context, String title, String placeholder, int index) { // Method to show edit project dialog. // Methode zum Anzeigen des Projekt-Bearbeiten-Dialogs.
  String projectTitle = ''; // Variable to store edited project name. // Variable zum Speichern des bearbeiteten Projektnamens.
  final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets currently selected container index. // Holt aktuell ausgewählten Container-Index.
  final projectNames = ref.watch(projectStateNotifierProvider); // Gets list of project names. // Holt Liste der Projektnamen.

  showDialog( // Shows dialog overlay. // Zeigt Dialogoverlay an.
    context: context, // Current build context. // Aktueller Build-Kontext.
    builder: (BuildContext context) { // Dialog builder function. // Dialog-Builder-Funktion.
      return CupertinoAlertDialog( // Creates iOS-style dialog. // Erstellt iOS-Stil-Dialog.
        title: Text(title), // Sets dialog title. // Setzt Dialogtitel.
        content: Column( // Creates column layout for content. // Erstellt Spaltenlayout für Inhalt.
          mainAxisSize: MainAxisSize.min, // Makes column as small as needed. // Macht Spalte so klein wie nötig.
          children: [ // List of column children. // Liste der Spaltenkinder.
            Text(placeholder), // Shows instruction text. // Zeigt Anweisungstext an.
            const SizedBox(height: 16), // Adds vertical spacing. // Fügt vertikalen Abstand hinzu.
            CupertinoTextField( // Creates iOS-style text field. // Erstellt iOS-Stil-Textfeld.
              placeholder: 'Project name', // Sets placeholder text. // Setzt Platzhaltertext.
              style: const TextStyle(color: Colors.white), // Sets white text color. // Setzt weiße Textfarbe.
              onChanged: (value) { // Function when text changes. // Funktion bei Textänderungen.
                projectTitle = value; // Updates project title variable. // Aktualisiert Projekttitel-Variable.
              },
            ),
          ],
        ),
        actions: [ // Dialog action buttons. // Dialog-Aktionsschaltflächen.
          CupertinoDialogAction( // Creates iOS-style button. // Erstellt iOS-Stil-Schaltfläche.
            child: const Text('OK'), // Sets button text. // Setzt Schaltflächentext.
            onPressed: () { // Function when OK is pressed. // Funktion, wenn OK gedrückt wird.
                    if (projectTitle.isNotEmpty) { // Checks if project title was entered. // Prüft, ob Projekttitel eingegeben wurde.
                  ref.read(persistentContainerIndexProvider.notifier).updateIndex(index); // Updates selected container index. // Aktualisiert ausgewählten Container-Index.
                  ref.read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, index, ref); // Updates project name in state. // Aktualisiert Projektnamen im Zustand.
                  ref.read(projectTimesProvider.notifier).addTime(
                      index, DateTime.now(), Duration.zero); // Updates project time tracking. // Aktualisiert Projekt-Zeiterfassung.
                }
              Navigator.pop(context); // Closes the dialog. // Schließt den Dialog.
            },
          ),
        ],
      );
    },
  );
}
}
