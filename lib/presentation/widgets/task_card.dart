/// TaskCard
/// 
/// A responsive card widget that displays timer information and project selection for a Pomodoro application. // Ein responsives Karten-Widget, das Timer-Informationen und Projektauswahl für eine Pomodoro-Anwendung anzeigt.
/// Used as the main interface element to show the current timer, selected project, and project selection options with premium feature handling. // Wird als Hauptschnittstellenelement verwendet, um den aktuellen Timer, das ausgewählte Projekt und Projektauswahloptionen mit Premium-Funktionsverwaltung anzuzeigen.
/// 
/// Usage:
/// ```dart
/// const TaskCard()
/// ```
/// 
/// EN: Creates a responsive card layout showing the timer display and project selection, with different layouts based on screen width.
/// DE: Erstellt ein responsives Kartenlayout, das die Timer-Anzeige und Projektauswahl mit verschiedenen Layouts basierend auf der Bildschirmbreite zeigt.

import 'package:flutter/cupertino.dart'; // Imports Cupertino (iOS-style) widgets from Flutter. // Importiert Cupertino (iOS-Stil) Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for custom typography. // Importiert das Google Fonts-Paket für benutzerdefinierte Typografie.

import '../../common/utils/responsive_show_dialogs.dart'; // Imports utility for showing responsive dialogs. // Importiert Dienstprogramm zum Anzeigen responsiver Dialoge.
import '../notifiers/persistent_container_notifier.dart'; // Imports persistent container state management. // Importiert Verwaltung des persistenten Container-Zustands.
import '../notifiers/project_state_notifier.dart'; // Imports project state management. // Importiert Projektzustandsverwaltung.
import '../notifiers/project_time_notifier.dart'; // Imports project time tracking state management. // Importiert Projektzeitverfolgungsverwaltung.
import '../notifiers/providers.dart'; // Imports general providers for state management. // Importiert allgemeine Provider für die Zustandsverwaltung.
import '../notifiers/timer_notifier_provider.dart'; // Imports timer-specific state management. // Importiert timer-spezifische Zustandsverwaltung.
import '../pages/0.appbar_features/2_app_bar_icons/profile/ready_soon_features.dart'; // Imports premium features dialog. // Importiert Premium-Funktionen-Dialog.
import '../repository/auth_repository.dart'; // Imports authentication repository for user data. // Importiert Authentifizierungs-Repository für Benutzerdaten.
import 'add_projects.dart'; // Imports project addition widget. // Importiert Widget zum Hinzufügen von Projekten.

class TaskCard extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const TaskCard({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCardState(); // Creates the state object for this widget. // Erstellt das Zustandsobjekt für dieses Widget.
}

class _TaskCardState extends ConsumerState<TaskCard> { // Defines the state class for TaskCard widget. // Definiert die Zustandsklasse für das TaskCard-Widget.
  int _hoveredIndex = -1; // Tracks which project container is being hovered over. // Verfolgt, über welchem Projektcontainer der Mauszeiger schwebt.
  @override
  Widget build(
    BuildContext context,
  ) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    final timerValue = ref.watch(timerNotifierProvider); // Gets the current timer value in seconds. // Ruft den aktuellen Timer-Wert in Sekunden ab.
    final focusedTaskTitle = ref.watch(focusedTaskTitleProvider); // Gets the currently focused task title. // Ruft den Titel der aktuell fokussierten Aufgabe ab.
    
    final taskCardTitle = ref.watch(taskCardTitleProvider); // Gets the task card title. // Ruft den Titel der Aufgabenkarte ab.
    final projectNames = ref.watch(projectStateNotifierProvider); // Gets the list of project names. // Ruft die Liste der Projektnamen ab.
    final taskDeletionByTrashIcon = ref.watch(taskDeletionsProvider); // Gets the task deletion state. // Ruft den Aufgabenlöschungszustand ab.
    final user = ref.watch(userProvider); // Gets the current user. // Ruft den aktuellen Benutzer ab.


    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets the selected project index. // Ruft den ausgewählten Projektindex ab.
    

    int currentIndex = selectedContainerIndex; // Initialize current index with selected container index. // Initialisiert den aktuellen Index mit dem ausgewählten Container-Index.
    if (currentIndex >= projectNames.length) { // If the index is out of bounds. // Wenn der Index außerhalb der Grenzen liegt.
      currentIndex = projectNames.length - 1; // Set to last available project. // Setzt auf das letzte verfügbare Projekt.
    }

    final currentProjectName = selectedContainerIndex < projectNames.length 
        ? projectNames[selectedContainerIndex] // Get project name if index is valid. // Ruft den Projektnamen ab, wenn der Index gültig ist.
        : 'Add a project'; // Default text if no project exists at that index. // Standardtext, wenn an diesem Index kein Projekt existiert.


    print('Added project: $currentProjectName'); // Debug log for added project. // Debug-Log für hinzugefügtes Projekt.
    print('Current Project Names: $projectNames'); // Debug log for all project names. // Debug-Log für alle Projektnamen.
    print('Selected Project Index: $selectedContainerIndex'); // Debug log for selected index. // Debug-Log für ausgewählten Index.
    print('Current Project Name: $currentProjectName'); // Debug log for current project name. // Debug-Log für aktuellen Projektnamen.
    
    final hoursStr =
        ((timerValue / 3600) % 60).floor().toString().padLeft(2, '0'); // Formats hours with leading zeros. // Formatiert Stunden mit führenden Nullen.
    final minutesStr =
        ((timerValue / 60) % 60).floor().toString().padLeft(2, '0'); // Formats minutes with leading zeros. // Formatiert Minuten mit führenden Nullen.
    final secondsStr = (timerValue % 60).floor().toString().padLeft(2, '0'); // Formats seconds with leading zeros. // Formatiert Sekunden mit führenden Nullen.

    return LayoutBuilder(builder: (context, constraints) { // Uses LayoutBuilder for responsive design. // Verwendet LayoutBuilder für responsives Design.
      final currentWidth = MediaQuery.of(context).size.width; // Gets current screen width. // Ruft aktuelle Bildschirmbreite ab.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Centers children vertically in the row. // Zentriert Kinder vertikal in der Zeile.
        children: [
          Flexible(
            flex: 3, // Takes 3/4 of the available space. // Nimmt 3/4 des verfügbaren Platzes ein.
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 27.0, bottom: 27.0, right: 0.0, left: 23.0), // Sets padding around the card. // Setzt Polsterung um die Karte.
              child: Center(
                child: Container(
                  height: 180, // Sets fixed height for the container. // Setzt feste Höhe für den Container.
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), // Rounds top-left corner. // Rundet die obere linke Ecke ab.
                      bottomLeft: Radius.circular(20), // Rounds bottom-left corner. // Rundet die untere linke Ecke ab.
                    ),
                    color: Color(0xFF121212), // Dark background color. // Dunkle Hintergrundfarbe.
                  ),
                  padding: const EdgeInsets.all(15.0), // Inner padding. // Innere Polsterung.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left. // Richtet Kinder links aus.
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the top. // Richtet Kinder oben aus.
                          children: [
                            const Tooltip(
                              message:
                                  "Please, click on the 'Pause' button to save the time spent", // Tooltip message. // Tooltip-Nachricht.
                              child: Icon(
                                CupertinoIcons.lightbulb, // Lightbulb icon for hint. // Glühbirnen-Symbol für Hinweis.
                                color: Color(0xffF2F2F2), // Light gray color. // Hellgraue Farbe.
                                size: 24.0, // Icon size. // Symbolgröße.
                              ),
                            ),
                            const SizedBox(width: 8), // Horizontal spacing. // Horizontaler Abstand.
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal, // Allows horizontal scrolling. // Ermöglicht horizontales Scrollen.
                                child: Text(
                                     "Project: $currentProjectName  ", // Shows project name. // Zeigt Projektname an.
                                  style: GoogleFonts.nunito(
                                      fontSize: 20.0, // Text size. // Textgröße.
                                      fontWeight: FontWeight.w500, // Medium weight. // Mittlere Schriftstärke.
                                      color: const Color(0xffF2F2F2)), // Light gray text. // Hellgrauer Text.
                                  overflow: TextOverflow.ellipsis, // Truncates overflow with ellipsis. // Kürzt Überlauf mit Auslassungspunkten.
                                  maxLines: 1, // Limits to one line. // Begrenzt auf eine Zeile.
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7), // Vertical spacing. // Vertikaler Abstand.
                      if (currentWidth <= 588) // Responsive layout for very small screens. // Responsives Layout für sehr kleine Bildschirme.
                        Center(
                          child: Container(
                            color: const Color(0xFF121212), // Dark background. // Dunkler Hintergrund.
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end, // Aligns children to the right. // Richtet Kinder rechts aus.

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr', // Timer display. // Timer-Anzeige.
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500, // Medium weight. // Mittlere Schriftstärke.
                                    letterSpacing: 8, // Space between characters. // Abstand zwischen Zeichen.
                                    fontSize: 50.0, // Large font size. // Große Schriftgröße.
                                    color: const Color(0xffF2F2F2), // Light gray text. // Hellgrauer Text.
                                  ),
                                ),
                                const SizedBox(height: 8), // Vertical spacing. // Vertikaler Abstand.
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end, // Aligns children to the right. // Richtet Kinder rechts aus.
                                  children: [
                                    Text(
                                      'Hours', // Hours label. // Stunden-Beschriftung.
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500, // Medium weight. // Mittlere Schriftstärke.
                                        fontSize: 20.0, // Text size. // Textgröße.
                                        color: const Color(0xffF2F2F2), // Light gray text. // Hellgrauer Text.
                                      ),
                                    ),
                                    const SizedBox(width: 24), // Horizontal spacing. // Horizontaler Abstand.
                                    Text(
                                      'Minutes', // Minutes label. // Minuten-Beschriftung.
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500, // Medium weight. // Mittlere Schriftstärke.
                                        fontSize: 20.0, // Text size. // Textgröße.
                                        color: const Color(0xffF2F2F2), // Light gray text. // Hellgrauer Text.
                                      ),
                                    ),
                                    const SizedBox(width: 24), // Horizontal spacing. // Horizontaler Abstand.
                                    Text(
                                      'Seconds', // Seconds label. // Sekunden-Beschriftung.
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500, // Medium weight. // Mittlere Schriftstärke.
                                        fontSize: 20.0, // Text size. // Textgröße.
                                        color: const Color(0xffF2F2F2), // Light gray text. // Hellgrauer Text.
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 648) // Responsive layout for small screens. // Responsives Layout für kleine Bildschirme.
                        // Similar patterns repeat for different screen widths, with slight adjustments to spacing. // Ähnliche Muster wiederholen sich für verschiedene Bildschirmbreiten, mit leichten Anpassungen der Abstände.
                        // Each condition adds more spacing to the right side as the screen gets wider. // Jede Bedingung fügt mehr Abstand auf der rechten Seite hinzu, wenn der Bildschirm breiter wird.
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr ', // Note the extra space at the end for wider screens. // Beachten Sie den zusätzlichen Leerzeichen am Ende für breitere Bildschirme.
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds    ', // Extra spaces for alignment. // Zusätzliche Leerzeichen für die Ausrichtung.
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      // The pattern continues for multiple screen width breakpoints. // Das Muster setzt sich für mehrere Bildschirmbreitenbreakpoints fort.
                      // I'm omitting detailed explanations for the repeated patterns, as they follow the same structure. // Ich lasse detaillierte Erklärungen für die wiederholten Muster aus, da sie der gleichen Struktur folgen.
                      else if (currentWidth <= 688)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr  ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds      ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      // Similar patterns continue for other screen widths. // Ähnliche Muster setzen sich für andere Bildschirmbreiten fort.
                      // For brevity, I'm not explaining each identical block. // Der Kürze halber erkläre ich nicht jeden identischen Block.
                      else if (currentWidth <= 780)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr  ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds       ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 1400)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Text(
                                      'Seconds             ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 1800)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Text(
                                      'Seconds            ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                     
                     
                      else if (currentWidth <= 2200)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Text(
                                      'Seconds            ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                     
                     
                     
                      else // Default layout for very large screens. // Standard-Layout für sehr große Bildschirme.
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds             ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1, // Takes 1/4 of the available space. // Nimmt 1/4 des verfügbaren Platzes ein.
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 27.0, bottom: 27.0, right: 23.0, left: 0.0), // Sets padding around the container. // Setzt Polsterung um den Container.
              child: Container(
                height: 180, // Fixed height. // Feste Höhe.
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20), // Rounds top-right corner. // Rundet die obere rechte Ecke ab.
                    bottomRight: Radius.circular(20), // Rounds bottom-right corner. // Rundet die untere rechte Ecke ab.
                  ),
                  color: Color(0xFF121212), // Dark background color. // Dunkle Hintergrundfarbe.
                ),
                padding: const EdgeInsets.all(15.0), // Inner padding. // Innere Polsterung.
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Allows horizontal scrolling for project containers. // Ermöglicht horizontales Scrollen für Projektcontainer.
                  child: Row(
                    children: [
                      _buildProjectContainer(const Color(0xffF04442), 0), // Red project container. // Roter Projektcontainer.
                      _buildProjectContainer(const Color(0xffF4A338), 1), // Orange project container. // Oranger Projektcontainer.
                      _buildProjectContainer(const Color(0xFFF8CD34), 2), // Yellow project container. // Gelber Projektcontainer.
                      _buildProjectContainer(const Color(0xff4FCE5D), 3), // Green project container. // Grüner Projektcontainer.
                      _buildProjectContainer(const Color(0xff4584DB), 4), // Blue project container. // Blauer Projektcontainer.
                      _buildProjectContainer(const Color(0xffAE73D1), 5), // Purple project container. // Lila Projektcontainer.
                      _buildProjectContainer(const Color(0xffEA73AD), 6), // Pink project container. // Rosa Projektcontainer.
                      _buildProjectContainer(const Color(0xff9B9A9E), 7), // Gray project container. // Grauer Projektcontainer.

                    
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProjectContainer(Color color, int index) { // Helper method to build project selection containers. // Hilfsmethode zum Erstellen von Projektauswahlcontainern.
    final projectNames = ref.watch(projectStateNotifierProvider); // Gets the project names. // Ruft die Projektnamen ab.
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets the selected container index. // Ruft den ausgewählten Container-Index ab.

    final user = ref.watch(userProvider.notifier).state; // Gets the current user state. // Ruft den aktuellen Benutzerzustand ab.

    bool isPremiumContainer = index >= 4; // Containers from index 4 and up are premium features. // Container ab Index 4 sind Premium-Funktionen.
    bool isUserPremium = user?.isPremium ?? false; // Checks if user has premium access. // Prüft, ob der Benutzer Premium-Zugang hat.
    bool isLocked = isPremiumContainer && !isUserPremium; // Locks premium containers for non-premium users. // Sperrt Premium-Container für Nicht-Premium-Benutzer.

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 1.5, 0.0), // Right padding between containers. // Rechte Polsterung zwischen Containern.
          child: GestureDetector(
            behavior: HitTestBehavior.opaque, // Makes the entire area tappable. // Macht den gesamten Bereich antippbar.
            onTap: () { // Project container tap handler. // Projektcontainer-Tipp-Handler.
              if (!isLocked) { // If not a locked premium feature. // Wenn keine gesperrte Premium-Funktion.
                setState(() => _hoveredIndex = -1); // Resets hover state. // Setzt Hover-Zustand zurück.
            ref.read(persistentContainerIndexProvider.notifier).updateIndex(index); // Updates selected project index. // Aktualisiert ausgewählten Projektindex.

                if (isPremiumContainer && projectNames.length <= index) { // If premium container without a project. // Wenn Premium-Container ohne Projekt.
                  _showAddDialog(context, 'Add Premium Project',
                      'Please add a project name', index); // Shows dialog to add a new project. // Zeigt Dialog zum Hinzufügen eines neuen Projekts.
                }
              } else { // If a locked premium feature. // Wenn eine gesperrte Premium-Funktion.
                _showPremiumDialog(context); // Shows premium feature dialog. // Zeigt Premium-Funktionsdialog.
              }
            },
            child: AddProyectName( // Custom widget for project name container. // Benutzerdefiniertes Widget für Projektnamen-Container.
              color, // Container color. // Container-Farbe.
              index: index, // Container index. // Container-Index.
              isEditable: !isLocked, // Editable if not locked. // Bearbeitbar, wenn nicht gesperrt.
              isEditIconVisible: _hoveredIndex == index && // Shows edit icon when hovered and has a valid project. // Zeigt Bearbeitungssymbol, wenn darüber geschwebt wird und ein gültiges Projekt vorhanden ist.
                  projectNames.isNotEmpty &&
                  projectNames.length > index &&
                  projectNames[index] != 'Add a project' &&
                  !isLocked,
              onEnterContainerHover: (p0) { // Mouse enter handler. // Maus-Eingangs-Handler.
                setState(() => _hoveredIndex = index); // Updates hovered index. // Aktualisiert den Hover-Index.
              },
              onExitContainerHover: (p0) { // Mouse exit handler. // Maus-Austritts-Handler.
                setState(() => _hoveredIndex = -1); // Resets hovered index. // Setzt den Hover-Index zurück.
              },
              icon: isLocked // Shows lock icon if locked, otherwise null. // Zeigt Schlosssymbol, wenn gesperrt, sonst null.
                  ? const Icon(
                     CupertinoIcons.lock
                    , color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ),
        if (selectedContainerIndex == index && !isLocked) // Shows indicator arrow for selected project. // Zeigt Indikatorpfeil für ausgewähltes Projekt.
        Icon(CupertinoIcons.arrow_up_circle_fill, color: color, size: 24), // Upward arrow icon in project color. // Aufwärtspfeilsymbol in Projektfarbe.
      ],
    );
  }

void _showAddDialog(BuildContext context, String title, String placeholder, int index) { // Method to show dialog for adding a project. // Methode zum Anzeigen eines Dialogs zum Hinzufügen eines Projekts.
    String projectTitle = ''; // Stores the entered project title. // Speichert den eingegebenen Projekttitel.
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider); // Gets the selected container index. // Ruft den ausgewählten Container-Index ab.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog( // Creates iOS-style dialog. // Erstellt iOS-Stil-Dialog.
          title: Text(title), // Dialog title. // Dialogtitel.
          content: Column(
            mainAxisSize: MainAxisSize.min, // Minimizes dialog size. // Minimiert Dialoggröße.
            children: [
              Text(placeholder), // Placeholder text. // Platzhaltertext.
              const SizedBox(height: 16), // Vertical spacing. // Vertikaler Abstand.
              CupertinoTextField( // iOS-style text input. // iOS-Stil-Texteingabe.
                placeholder: 'Project name', // Input placeholder. // Eingabe-Platzhalter.
                style: const TextStyle(color: Colors.white), // White text color. // Weiße Textfarbe.
                onChanged: (value) { // Input change handler. // Eingabeänderungshandler.
                  projectTitle = value; // Updates project title variable. // Aktualisiert Projekttitel-Variable.
                },
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction( // Dialog action button. // Dialog-Aktionsschaltfläche.
              child: const Text('OK'), // Button text. // Schaltflächentext.
              onPressed: () { // Button press handler. // Schaltflächen-Druck-Handler.
                if (projectTitle.isNotEmpty) { // If project title is not empty. // Wenn Projekttitel nicht leer ist.
                  ref.read(persistentContainerIndexProvider.notifier).updateIndex(index); // Updates selected index. // Aktualisiert ausgewählten Index.
                  ref.read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, index, ref); // Adds project to state. // Fügt Projekt zum Zustand hinzu.
                  ref.read(projectTimesProvider.notifier).addTime(
                      index, DateTime.now(), Duration.zero); // Initializes project time tracking. // Initialisiert Projekt-Zeiterfassung.
                }
                Navigator.pop(context); // Closes the dialog. // Schließt den Dialog.
              },
            ),
          ],
        );
      },
    );
  }


  void _showPremiumDialog(BuildContext context) { // Method to show premium feature dialog. // Methode zum Anzeigen des Premium-Funktionsdialogs.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
        

        ResponsiveShowDialogs( // Uses responsive dialog utility. // Verwendet responsives Dialog-Dienstprogramm.
          child: SimpleDialog(
            backgroundColor:
                const Color.fromARGB(0, 0, 0, 0), // Transparent background. // Transparenter Hintergrund.
            children: [
              SizedBox(
                width: MediaQuery.of( // Responsive width based on screen size. // Responsive Breite basierend auf Bildschirmgröße.
                            context)
                        .size
                        .width *
                    0.4,
                child:
                    const PremiumReadySoon(), // Shows premium feature coming soon dialog. // Zeigt Premium-Funktion-kommt-bald-Dialog.
              ),
            ],
          ),
        );
      },
    );
  }
}
