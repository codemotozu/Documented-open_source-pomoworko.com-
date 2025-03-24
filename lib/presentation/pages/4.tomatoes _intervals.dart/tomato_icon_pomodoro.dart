/// TomatoIconPomodoro
/// 
/// A widget that displays a horizontal row of tomato icons representing completed and pending pomodoro sessions. // Ein Widget, das eine horizontale Reihe von Tomaten-Symbolen anzeigt, die abgeschlossene und ausstehende Pomodoro-Sitzungen darstellen.
/// Used to visually track progress through a series of pomodoro work sessions in the application. // Wird verwendet, um den Fortschritt durch eine Reihe von Pomodoro-Arbeitssitzungen in der Anwendung visuell zu verfolgen.
/// 
/// Usage:
/// ```dart
/// Scaffold(
///   body: Column(
///     children: [
///       // Other widgets
///       const TomatoIconPomodoro(),
///     ],
///   ),
/// )
/// ```
/// 
/// EN: Displays a scrollable row of tomato icons with a reset button to restart pomodoro sessions.
/// DE: Zeigt eine scrollbare Reihe von Tomaten-Symbolen mit einer Reset-Taste an, um Pomodoro-Sitzungen neu zu starten.

import 'package:flutter/cupertino.dart'; // Imports Cupertino widgets from Flutter for iOS-style components. // Importiert Cupertino-Widgets aus Flutter für iOS-Stil-Komponenten.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter for Android-style components. // Importiert Material Design-Widgets aus Flutter für Android-Stil-Komponenten.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../../notifiers/providers.dart'; // Imports application providers for state management. // Importiert Anwendungsprovider für die Zustandsverwaltung.

class TomatoIconPomodoro extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const TomatoIconPomodoro({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => // Overrides createState to return a state object. // Überschreibt createState, um ein State-Objekt zurückzugeben.
      _TomatoIconPomodoroState(); // Returns instance of the state class. // Gibt eine Instanz der State-Klasse zurück.
}

class _TomatoIconPomodoroState extends ConsumerState<TomatoIconPomodoro> { // Defines the state class for TomatoIconPomodoro widget. // Definiert die State-Klasse für das TomatoIconPomodoro-Widget.
  @override
  Widget build(BuildContext context) { // Overrides build method to create the UI. // Überschreibt die build-Methode, um die Benutzeroberfläche zu erstellen.
    final pomodoroState = ref.watch(pomodoroNotifierProvider); // Watches the pomodoro state from the provider. // Beobachtet den Pomodoro-Zustand vom Provider.
    final ScrollController horizontal = ScrollController(); // Creates a controller for horizontal scrolling. // Erstellt einen Controller für horizontales Scrollen.

    return Scaffold( // Creates a Material Design basic page layout. // Erstellt ein Material Design-Grundseitenlayout.
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Sets the background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
      floatingActionButton: Transform.translate( // Creates a floating action button with position adjustment. // Erstellt eine schwebende Aktionsschaltfläche mit Positionsanpassung.
        offset: const Offset(5, 13), // Moves the button 5 pixels right and 13 pixels down. // Verschiebt die Schaltfläche 5 Pixel nach rechts und 13 Pixel nach unten.
        child: CupertinoButton( // Creates an iOS-style button. // Erstellt eine Schaltfläche im iOS-Stil.
          color: const Color.fromARGB(255, 0, 0, 0), // Sets the button color to black. // Setzt die Schaltflächenfarbe auf Schwarz.
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), // Sets padding for the button content. // Setzt den Innenabstand für den Schaltflächeninhalt.
          borderRadius: BorderRadius.circular(12), // Rounds the button corners with a 12-pixel radius. // Rundet die Schaltflächenecken mit einem Radius von 12 Pixeln.
          onPressed: () { // Function called when the button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
            ref.read(pomodoroNotifierProvider.notifier).resetPomodoros(); // Calls the reset function on the pomodoro notifier. // Ruft die Reset-Funktion am Pomodoro-Notifier auf.
          },
          child: const Tooltip( // Creates a tooltip that shows on long press. // Erstellt einen Tooltip, der bei langem Drücken angezeigt wird.
            message: 'Restart Pomodoro(s)', // Sets the tooltip message. // Setzt die Tooltip-Nachricht.
            child: Icon( // Creates an icon for the button. // Erstellt ein Symbol für die Schaltfläche.
              CupertinoIcons.arrow_counterclockwise, // Uses the counterclockwise arrow icon from Cupertino icons. // Verwendet das Pfeil-gegen-den-Uhrzeigersinn-Symbol aus den Cupertino-Symbolen.
              color: Color(0xffF2F2F2), // Sets the icon color to light gray. // Setzt die Symbolfarbe auf Hellgrau.
              size: 28.0, // Sets the icon size to 28 logical pixels. // Setzt die Symbolgröße auf 28 logische Pixel.
            ),
          ),
        ),
      ),
      body: Padding( // Adds padding around the body content. // Fügt Polsterung um den Körperinhalt hinzu.
        padding: const EdgeInsets.only(left: 23), // Adds 23 pixels of padding on the left side only. // Fügt nur auf der linken Seite 23 Pixel Polsterung hinzu.
        child: Scrollbar( // Adds a scrollbar to the scrollable area. // Fügt dem scrollbaren Bereich eine Bildlaufleiste hinzu.
          controller: horizontal, // Links the scrollbar to the horizontal scroll controller. // Verknüpft die Bildlaufleiste mit dem horizontalen Scroll-Controller.
          child: SingleChildScrollView( // Creates a scrollable widget that allows horizontal scrolling. // Erstellt ein scrollbares Widget, das horizontales Scrollen ermöglicht.
            controller: horizontal, // Sets the scroll controller for the scrollable widget. // Setzt den Scroll-Controller für das scrollbare Widget.
            scrollDirection: Axis.horizontal, // Sets the scroll direction to horizontal. // Setzt die Scrollrichtung auf horizontal.
            child: Row( // Creates a row layout for the tomato icons. // Erstellt ein Zeilenlayout für die Tomaten-Symbole.
              children: pomodoroState.pomodoros.map((isCompleted) { // Maps each pomodoro state to a widget. // Ordnet jeden Pomodoro-Zustand einem Widget zu.
                return IconButton( // Creates a button with an icon. // Erstellt eine Schaltfläche mit einem Symbol.
                  onPressed: null, // Sets the button as non-interactive (null callback). // Setzt die Schaltfläche als nicht interaktiv (null-Callback).
                  icon: isCompleted // Conditionally chooses the icon based on completion status. // Wählt das Symbol bedingt basierend auf dem Abschlussstatus aus.
                      ? Image.asset('assets/icons/tomatoDone.png') // Shows a completed tomato icon if true. // Zeigt ein abgeschlossenes Tomaten-Symbol an, wenn wahr.
                      : Image.asset('assets/icons/tomatoUndone.png'), // Shows an incomplete tomato icon if false. // Zeigt ein unvollständiges Tomaten-Symbol an, wenn falsch.
                );
              }).toList(), // Converts the mapped widgets to a list. // Konvertiert die zugeordneten Widgets in eine Liste.
            ),
          ),
        ),
      ),
    );
  }
}
