/// HomePage
/// 
/// The main screen of the Pomodoro timer application. // Der Hauptbildschirm der Pomodoro-Timer-Anwendung.
/// Contains all core components including timer, task list, and app controls. // Enthält alle Kernkomponenten einschließlich Timer, Aufgabenliste und App-Steuerelemente.
/// 
/// Usage:
/// ```dart
/// MaterialApp(
///   home: HomePage(),
/// )
/// ```
/// 
/// EN: Displays a vertically scrollable layout with Pomodoro timer, animation, and task management features.
/// DE: Zeigt ein vertikal scrollbares Layout mit Pomodoro-Timer, Animation und Aufgabenverwaltungsfunktionen an.

import 'package:flutter/material.dart';  // Imports core Flutter material design package. // Importiert das Flutter Material-Design-Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../common/utils/responsive_web.dart';  // Imports responsive web utilities. // Importiert Hilfsfunktionen für responsive Webdesign.
import '../presentation/notifiers/task_notifier.dart';  // Imports task state management. // Importiert die Aufgaben-Zustandsverwaltung.
import '../presentation/pages/0.appbar_features/2_app_bar_icons/app_bar_features.dart';  // Imports app bar components. // Importiert App-Bar-Komponenten.
import '../presentation/pages/3.chips_blog/1.chips_blog.dart';  // Imports chips blog component. // Importiert die Chips-Blog-Komponente.
import '../presentation/pages/4.tomatoes _intervals.dart/tomato_icon_pomodoro.dart';  // Imports tomato icon component. // Importiert die Tomaten-Icon-Komponente.
import '../presentation/pages/5_animation_timer.dart/animation_timer.dart';  // Imports animation timer component. // Importiert die Animations-Timer-Komponente.
import '../presentation/pages/6.todo_task/todo_option_1.dart/glassmorphism_screen/new_task_button.dart';  // Imports new task button. // Importiert die Neue-Aufgabe-Schaltfläche.
import '../presentation/pages/6.todo_task/todo_option_1.dart/glassmorphism_screen/todo_page.dart';  // Imports todo page component. // Importiert die Aufgabenseiten-Komponente.

class HomePage extends ConsumerStatefulWidget {  // Defines the main page as a stateful widget with Riverpod consumer. // Definiert die Hauptseite als Stateful-Widget mit Riverpod-Consumer.
  const HomePage({super.key});  // Constructor with optional key parameter. // Konstruktor mit optionalem Key-Parameter.

  @override
  _HomePageState createState() => _HomePageState();  // Creates the state for this widget. // Erstellt den State für dieses Widget.
}

class _HomePageState extends ConsumerState<HomePage> {  // Defines the state class for HomePage. // Definiert die State-Klasse für HomePage.
  @override
  void initState() {  // Initializes the state. // Initialisiert den Zustand.
    super.initState();  // Calls parent initState method. // Ruft die übergeordnete initState-Methode auf.
  }

  @override
  Widget build(BuildContext context) {  // Builds the UI for this widget. // Erstellt die Benutzeroberfläche für dieses Widget.
    double appBarHeight = 95;  // Sets the app bar height. // Legt die Höhe der App-Bar fest.
    double tomatoIconPomodoroHeight = 50;  // Sets the tomato icon height. // Legt die Höhe des Tomaten-Icons fest.
    double animationAndTimerPageHeight = 402;  // Sets the animation and timer section height. // Legt die Höhe des Animations- und Timer-Bereichs fest.

    return SafeArea(  // Ensures the app is displayed in the safe area of the device. // Stellt sicher, dass die App im sicheren Bereich des Geräts angezeigt wird.
      child: ResponsiveWeb(  // Wraps content in responsive container. // Wickelt den Inhalt in einen responsiven Container.
        child: Scaffold(  // Creates a basic material design layout. // Erstellt ein grundlegendes Material-Design-Layout.
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),  // Sets black background color. // Legt schwarze Hintergrundfarbe fest.
          body: LayoutBuilder(  // Uses a LayoutBuilder to adapt to available space. // Verwendet einen LayoutBuilder, um sich an den verfügbaren Platz anzupassen.
              builder: (BuildContext context, BoxConstraints constraints) {  // Builder function with context and constraints. // Builder-Funktion mit Kontext und Constraints.
            return ListView(children: [  // Creates a scrollable list view. // Erstellt eine scrollbare Listenansicht.
              Column(  // Arranges widgets vertically. // Ordnet Widgets vertikal an.
                children: [  // List of child widgets. // Liste der Kind-Widgets.
                  SizedBox(  // Creates a fixed-height box for app bar. // Erstellt eine Box mit fester Höhe für die App-Bar.
                    height: appBarHeight,  // Sets height from the variable. // Legt die Höhe aus der Variablen fest.
                    child: const AppBarFeatures(),  // Adds the app bar components. // Fügt die App-Bar-Komponenten hinzu.
                  ),
                  const ChipsBlog(),  // Adds the chips blog section. // Fügt den Chips-Blog-Bereich hinzu.
                  SizedBox(  // Creates a fixed-height box for tomato icon. // Erstellt eine Box mit fester Höhe für das Tomaten-Icon.
                    height: tomatoIconPomodoroHeight,  // Sets height from the variable. // Legt die Höhe aus der Variablen fest.
                    child: const TomatoIconPomodoro(),  // Adds the tomato icon component. // Fügt die Tomaten-Icon-Komponente hinzu.
                  ),
                  SizedBox(  // Creates a fixed-height box for animation and timer. // Erstellt eine Box mit fester Höhe für Animation und Timer.
                    height: animationAndTimerPageHeight,  // Sets height from the variable. // Legt die Höhe aus der Variablen fest.
                    child: const AnimationAndTimer(),  // Adds the animation and timer component. // Fügt die Animations- und Timer-Komponente hinzu.
                  ),
                  const ToDoPage(),  // Adds the todo list page. // Fügt die Aufgabenlisten-Seite hinzu.
                  Container(  // Creates a container for the new task button. // Erstellt einen Container für die Neue-Aufgabe-Schaltfläche.
                    color: const Color.fromARGB(255, 0, 0, 0),  // Sets black background color. // Legt schwarze Hintergrundfarbe fest.
                    height: 79,  // Sets container height to 79 pixels. // Legt die Container-Höhe auf 79 Pixel fest.
                    child: Padding(  // Adds padding around the new task button. // Fügt Polsterung um die Neue-Aufgabe-Schaltfläche hinzu.
                      padding: const EdgeInsets.only(
                          left: 23.0, right: 23.0, bottom: 23.0),  // Sets padding on left, right, and bottom. // Legt Polsterung links, rechts und unten fest.
                      child: NewTaskButton(onNewTask: (  // Adds new task button with callback. // Fügt Neue-Aufgabe-Schaltfläche mit Callback hinzu.
                        todo,  // Todo parameter passed to callback. // Todo-Parameter, der an den Callback übergeben wird.
                      ) {
                        ref.read(taskListProvider.notifier).addTask(  // Accesses task list provider to add a task. // Greift auf den Aufgabenlisten-Provider zu, um eine Aufgabe hinzuzufügen.
                              todo,  // Adds the todo to the task list. // Fügt das Todo zur Aufgabenliste hinzu.
                            );
                        setState(() {});  // Triggers UI update. // Löst UI-Aktualisierung aus.
                      }),
                    ),
                  ),
                ],
              ),
            ]);
          }),
        ),
      ),
    );
  }
}
