/// BarChartProject
/// 
/// A selectable project indicator widget for a bar chart visualization. // Ein auswählbares Projekt-Indikator-Widget für eine Balkendiagramm-Visualisierung.
/// Used to display and select different projects in the application, with special handling for premium features. // Wird verwendet, um verschiedene Projekte in der Anwendung anzuzeigen und auszuwählen, mit besonderer Behandlung für Premium-Funktionen.
/// 
/// Usage:
/// ```dart
/// BarChartProject(
///   Colors.blue,
///   index: 0,
///   icon: Icon(Icons.work, size: 16),
///   isEditable: true,
///   isPremiumLocked: false,
///   onEnterContainerHover: (event) => handleHover(true),
///   onExitContainerHover: (event) => handleHover(false),
/// )
/// ```
/// 
/// EN: Creates a circular project indicator that can be selected, with state management for tracking the current project.
/// DE: Erstellt einen kreisförmigen Projektindikator, der ausgewählt werden kann, mit Zustandsverwaltung zur Verfolgung des aktuellen Projekts.

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter/services.dart'; // Imports services like mouse cursors and system channels. // Importiert Dienste wie Mauszeiger und Systemkanäle.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../notifiers/persistent_container_notifier.dart'; // Imports a notifier for persistent container state. // Importiert einen Notifier für den persistenten Container-Zustand.
import '../notifiers/project_state_notifier.dart'; // Imports a notifier for project state. // Importiert einen Notifier für den Projektzustand.

final currentProjectProvider = StateProvider<String?>((ref) => null); // Creates a global state provider for the current project name. // Erstellt einen globalen Zustandsanbieter für den aktuellen Projektnamen.

class BarChartProject extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  final Color color; // The background color of the project indicator. // Die Hintergrundfarbe des Projektindikators.
  final Icon? icon; // Optional icon to display inside the indicator. // Optionales Symbol, das innerhalb des Indikators angezeigt wird.
  final int index; // The index of this project in the projects list. // Der Index dieses Projekts in der Projektliste.
  final bool isEditable; // Whether the project is editable. // Ob das Projekt bearbeitet werden kann.
  final bool isEditIconVisible; // Whether to show an edit icon. // Ob ein Bearbeitungssymbol angezeigt werden soll.
  final bool isPremiumLocked; // Whether this feature is locked for premium users only. // Ob diese Funktion nur für Premium-Benutzer freigeschaltet ist.


  final Function(PointerEnterEvent)? onEnterContainerHover; // Optional callback for mouse enter events. // Optionaler Callback für Maus-Eintritt-Ereignisse.
  final Function(PointerExitEvent)? onExitContainerHover; // Optional callback for mouse exit events. // Optionaler Callback für Maus-Austritt-Ereignisse.

  const BarChartProject(this.color, // Constructor with positional color parameter. // Konstruktor mit positionellem Farbparameter.
      {required this.index, // Required index parameter. // Erforderlicher Index-Parameter.
      this.icon, // Optional icon parameter. // Optionaler Symbol-Parameter.
      this.isEditable = false, // Optional editable flag with default value. // Optionales Bearbeitbar-Flag mit Standardwert.
      super.key, // Parent class key parameter. // Elternklassen-Key-Parameter.
      this.isEditIconVisible = false, // Optional edit icon visibility flag with default value. // Optionales Bearbeitungssymbol-Sichtbarkeits-Flag mit Standardwert.
      this.onEnterContainerHover, // Optional mouse enter callback. // Optionaler Maus-Eintritt-Callback.
      this.onExitContainerHover, // Optional mouse exit callback. // Optionaler Maus-Austritt-Callback.
        required this.isPremiumLocked, // Required premium lock status. // Erforderlicher Premium-Sperrstatus.
       });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => // Overrides createState to return a state object. // Überschreibt createState, um ein State-Objekt zurückzugeben.
      _BarChartProjectState(); // Returns instance of the state class. // Gibt eine Instanz der State-Klasse zurück.
}

class _BarChartProjectState extends ConsumerState<BarChartProject> { // Defines the state class for BarChartProject widget. // Definiert die State-Klasse für das BarChartProject-Widget.
  final bool _isHovered = false; // State variable to track hover status (appears unused). // Zustandsvariable zur Verfolgung des Hover-Status (scheint unbenutzt zu sein).

  @override
  Widget build(BuildContext context) { // Overrides build method to create the UI. // Überschreibt die build-Methode, um die Benutzeroberfläche zu erstellen.
    final selectedContainerIndex = // Gets the currently selected container index from provider. // Ruft den aktuell ausgewählten Container-Index vom Provider ab.
        ref.watch(persistentContainerIndexProvider) ?? 0; // Falls back to 0 if null. // Fällt auf 0 zurück, wenn null.

    final projectNames = ref.watch(projectStateNotifierProvider); // Gets the list of project names from provider. // Ruft die Liste der Projektnamen vom Provider ab.

    bool hasProjectName = widget.index < projectNames.length && // Checks if this project has a valid name. // Überprüft, ob dieses Projekt einen gültigen Namen hat.
        projectNames[widget.index] != 'Add a project'; // Not the default "Add a project" placeholder. // Nicht der Standard "Add a project" Platzhalter.

       String tooltipMessage; // Declares variable for tooltip text. // Deklariert Variable für Tooltip-Text.
    if (widget.isPremiumLocked) { // Checks if this feature is premium-locked. // Überprüft, ob diese Funktion premium-gesperrt ist.
      tooltipMessage = 'Premium Feature'; // Sets tooltip for premium features. // Setzt Tooltip für Premium-Funktionen.
    } else if (projectNames.isNotEmpty && // Checks for valid project with a name. // Überprüft auf gültiges Projekt mit einem Namen.
        widget.index < projectNames.length &&
        projectNames[widget.index] != 'Add a project') {
      tooltipMessage = projectNames[widget.index]; // Uses project name as tooltip. // Verwendet Projektname als Tooltip.
    } else {
      tooltipMessage = 'Add a project'; // Default tooltip for empty slots. // Standard-Tooltip für leere Slots.
    }

    return MouseRegion( // Creates a region that detects mouse events. // Erstellt einen Bereich, der Mausereignisse erkennt.
      onEnter: widget.onEnterContainerHover, // Sets callback for mouse enter. // Setzt Callback für Maus-Eintritt.
      onExit: widget.onExitContainerHover, // Sets callback for mouse exit. // Setzt Callback für Maus-Austritt.
      cursor: SystemMouseCursors.click, // Changes cursor to pointer on hover. // Ändert den Cursor zum Zeiger beim Hover.
      child: SingleChildScrollView( // Adds horizontal scrolling capability. // Fügt horizontale Scrollfähigkeit hinzu.
        scrollDirection: Axis.horizontal, // Sets scroll direction to horizontal. // Setzt die Scrollrichtung auf horizontal.
        child: Row( // Creates a horizontal layout. // Erstellt ein horizontales Layout.
          children: [
            Column( // Creates a vertical layout inside the row. // Erstellt ein vertikales Layout innerhalb der Zeile.
              mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically. // Zentriert den Inhalt vertikal.
              crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally. // Zentriert den Inhalt horizontal.
              children: [
                GestureDetector( // Adds tap detection to the indicator. // Fügt Tipp-Erkennung zum Indikator hinzu.
                  onTap: () { // Defines tap handler function. // Definiert die Tipp-Handler-Funktion.
                    ref.read(persistentContainerIndexProvider.notifier).state = // Updates the selected container index. // Aktualisiert den ausgewählten Container-Index.
                        widget.index;

                    final projectNames = // Gets current project names. // Ruft aktuelle Projektnamen ab.
                        ref.watch(projectStateNotifierProvider);
                    ref
                        .read(persistentContainerIndexProvider.notifier)
                        .updateIndex(widget.index); // Updates persistent index through notifier. // Aktualisiert persistenten Index durch Notifier.

                    ref.read(selectedProjectIndexProvider.notifier).state = // Updates the selected project index state. // Aktualisiert den ausgewählten Projekt-Index-Zustand.
                        widget.index;
                    ref
                        .read(projectStateNotifierProvider.notifier)
                        .selectProject(widget.index); // Notifies the project state of selection. // Benachrichtigt den Projektzustand über die Auswahl.
                    ref.read(currentProjectProvider.notifier).state = // Updates current project provider with selected project. // Aktualisiert den aktuellen Projektanbieter mit ausgewähltem Projekt.
                        ref.read(projectStateNotifierProvider)[widget.index];

                    if (widget.index >= projectNames.length || // Checks if selected project is "Add a project". // Überprüft, ob ausgewähltes Projekt "Add a project" ist.
                        projectNames[widget.index] == 'Add a project') {
                    } else { // Empty else clause (possibly for future implementation). // Leere Else-Klausel (möglicherweise für zukünftige Implementierung).

                    }
                    if (widget.index < projectNames.length) { // Final check to ensure project exists. // Abschließende Überprüfung, um sicherzustellen, dass das Projekt existiert.
                      ref.read(currentProjectProvider.notifier).state = // Updates current project name again (seems redundant). // Aktualisiert den aktuellen Projektnamen erneut (scheint redundant zu sein).
                          projectNames[widget.index];
                    }
                  },
                  child: Tooltip( // Adds tooltip to the project indicator. // Fügt dem Projektindikator einen Tooltip hinzu.
                    message: tooltipMessage, // Sets tooltip message. // Setzt die Tooltip-Nachricht.
                    child: Container( // Creates outer container for the indicator. // Erstellt äußeren Container für den Indikator.
                      width: 24, // Sets fixed width. // Setzt feste Breite.
                      height: 24, // Sets fixed height. // Setzt feste Höhe.
                      decoration: BoxDecoration( // Adds decoration to the outer container. // Fügt dem äußeren Container Dekoration hinzu.
                        shape: BoxShape.circle, // Makes container circular. // Macht den Container kreisförmig.
                        border: selectedContainerIndex == widget.index // Checks if this container is selected. // Überprüft, ob dieser Container ausgewählt ist.
                            ? Border.all( // Adds white border for selected state. // Fügt weißen Rand für ausgewählten Zustand hinzu.
                                color: const Color.fromARGB(255, 228, 228, 228),
                                width: 2.0)
                            : null, // No border for unselected state. // Kein Rand für nicht ausgewählten Zustand.
                      ),
                      child: Container( // Creates inner container for the indicator. // Erstellt inneren Container für den Indikator.
                        decoration: BoxDecoration( // Adds decoration to the inner container. // Fügt dem inneren Container Dekoration hinzu.
                          color: widget.color, // Sets the background color to the provided color. // Setzt die Hintergrundfarbe auf die angegebene Farbe.
                          shape: BoxShape.circle, // Makes inner container circular. // Macht den inneren Container kreisförmig.
                          border: selectedContainerIndex == widget.index // Checks if this container is selected. // Überprüft, ob dieser Container ausgewählt ist.
                              ? Border.all(color: Colors.black, width: 1.0) // Adds black border for selected state. // Fügt schwarzen Rand für ausgewählten Zustand hinzu.
                              : null, // No border for unselected state. // Kein Rand für nicht ausgewählten Zustand.
                        ),
                        child: widget.icon != null // Checks if an icon was provided. // Überprüft, ob ein Symbol angegeben wurde.
                            ? Center(child: widget.icon) // Centers the icon in the container. // Zentriert das Symbol im Container.
                            : null, // No child if no icon provided. // Kein Kind, wenn kein Symbol angegeben wurde.
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
