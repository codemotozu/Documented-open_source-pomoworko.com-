/// AnimationAndTimer
/// 
/// A complex widget that manages the timer functionality and visual animations for a Pomodoro timer application. // Ein komplexes Widget, das die Timer-Funktionalität und visuelle Animationen für eine Pomodoro-Timer-Anwendung verwaltet.
/// Used as the main screen to display and control different timer types (Pomodoro, Short Break, Long Break). // Wird als Hauptbildschirm verwendet, um verschiedene Timer-Typen (Pomodoro, Kurze Pause, Lange Pause) anzuzeigen und zu steuern.
/// 
/// Usage:
/// ```dart
/// Scaffold(
///   body: const AnimationAndTimer(),
/// )
/// ```
/// 
/// EN: Manages timer state, animations, and UI for a Pomodoro timer application with different timer modes.
/// DE: Verwaltet Timer-Zustand, Animationen und Benutzeroberfläche für eine Pomodoro-Timer-Anwendung mit verschiedenen Timer-Modi.

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../../../infrastructure/data_sources/hive_services.dart'; // Imports Hive services for persistent data storage. // Importiert Hive-Dienste für persistente Datenspeicherung.
import '../../notifiers/providers.dart'; // Imports application providers for state management. // Importiert Anwendungsprovider für die Zustandsverwaltung.
import '../../notifiers/timer_notifier_provider.dart'; // Imports specific timer notifier provider. // Importiert speziellen Timer-Notifier-Provider.
import '../../widgets/app_tab_bar.dart'; // Imports custom tab bar widget. // Importiert benutzerdefiniertes Tab-Leisten-Widget.
import '../../widgets/custom_timer_palette.dart'; // Imports custom timer visualization widget. // Importiert benutzerdefiniertes Timer-Visualisierungs-Widget.
import '../../widgets/play_pause_button_widget.dart'; // Imports play/pause button widget. // Importiert Wiedergabe/Pause-Schaltflächen-Widget.
import '../../widgets/task_card.dart'; // Imports task card widget. // Importiert Aufgabenkarten-Widget.


class AnimationAndTimer extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const AnimationAndTimer({super.key}); // Constructor that accepts a key parameter. // Konstruktor, der einen Key-Parameter akzeptiert.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState(); // Creates the state object for this widget. // Erstellt das State-Objekt für dieses Widget.
}

class _MainPageState extends ConsumerState<AnimationAndTimer>
    with TickerProviderStateMixin { // Extends ConsumerState and adds animation ticker capabilities. // Erweitert ConsumerState und fügt Animations-Ticker-Fähigkeiten hinzu.
  late TabController _tabController; // Controller for managing tab navigation. // Controller für die Verwaltung der Tab-Navigation.
  AnimationController? controller; // Controller for managing timer animation. // Controller für die Verwaltung der Timer-Animation.
  late Animation<double> animation; // Animation object for timer progress. // Animationsobjekt für den Timer-Fortschritt.
  late final int eventNotifierListener; // Identifier for event listener. // Kennung für den Event-Listener.

  void updateAnimationControllerDuration() { // Method to update animation duration based on timer type. // Methode zum Aktualisieren der Animationsdauer basierend auf dem Timer-Typ.
    int timerDuration; // Variable to store timer duration in minutes. // Variable zum Speichern der Timer-Dauer in Minuten.

    switch (ref.read(currentTimerTypeProvider.notifier).state) { // Checks current timer type from provider. // Prüft den aktuellen Timer-Typ vom Provider.
      case 'Pomodoro': // If timer type is Pomodoro. // Wenn Timer-Typ Pomodoro ist.
        timerDuration = ref.read(pomodoroTimerProvider.notifier).state; // Gets Pomodoro timer duration. // Holt Pomodoro-Timer-Dauer.
        break;
      case 'Short Break': // If timer type is Short Break. // Wenn Timer-Typ Kurze Pause ist.
        timerDuration = ref.read(shortBreakProvider.notifier).state; // Gets Short Break timer duration. // Holt Kurze-Pause-Timer-Dauer.
        break;
      case 'Long Break': // If timer type is Long Break. // Wenn Timer-Typ Lange Pause ist.
        timerDuration = ref.read(longBreakProvider.notifier).state; // Gets Long Break timer duration. // Holt Lange-Pause-Timer-Dauer.
        break;
      default: // If timer type is unknown. // Wenn Timer-Typ unbekannt ist.
        timerDuration = 0; // Sets duration to 0. // Setzt die Dauer auf 0.
        break;
    }

    controller?.duration = Duration(minutes: timerDuration); // Updates animation controller with new duration. // Aktualisiert den Animations-Controller mit neuer Dauer.
    controller?.stop(); // Stops any running animation. // Stoppt alle laufenden Animationen.
    controller?.reset(); // Resets animation to beginning. // Setzt die Animation auf den Anfang zurück.
  }

  @override
  void initState() { // Initialization method called when widget is first created. // Initialisierungsmethode, die aufgerufen wird, wenn das Widget zum ersten Mal erstellt wird.
    super.initState(); // Calls parent class initState. // Ruft initState der Elternklasse auf.
    HiveServices.retrieveCurrentTimerType().then((timerType) { // Retrieves saved timer type from persistent storage. // Ruft gespeicherten Timer-Typ aus persistentem Speicher ab.
      ref.read(currentTimerTypeProvider.notifier).state = timerType; // Updates current timer type in provider. // Aktualisiert aktuellen Timer-Typ im Provider.
      updateAnimationControllerDuration(); // Updates animation controller with retrieved timer type. // Aktualisiert Animations-Controller mit abgerufenem Timer-Typ.
    });
    _tabController = TabController(length: 3, vsync: this); // Initializes tab controller with 3 tabs. // Initialisiert Tab-Controller mit 3 Tabs.

    controller = AnimationController( // Creates animation controller for timer. // Erstellt Animations-Controller für Timer.
      vsync: this, // Sets this class as the ticker provider. // Setzt diese Klasse als Ticker-Provider.
      duration: Duration(minutes: ref.read(pomodoroTimerProvider)), // Sets initial duration from Pomodoro timer provider. // Setzt anfängliche Dauer vom Pomodoro-Timer-Provider.
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller!) // Creates animation that progresses from 0 to 1. // Erstellt Animation, die von 0 bis 1 fortschreitet.
      ..addListener(() { // Adds listener to animation changes. // Fügt Listener für Animationsänderungen hinzu.
        setState(() {}); // Updates UI when animation changes. // Aktualisiert UI, wenn sich die Animation ändert.
        HiveServices.saveAnimationProgress(controller!.value); // Saves current animation progress to persistent storage. // Speichert aktuellen Animationsfortschritt in persistentem Speicher.
      });

    _tabController.addListener(() { // Adds listener for tab changes. // Fügt Listener für Tab-Änderungen hinzu.
      if (_tabController.indexIsChanging) { // If tab index is changing. // Wenn sich der Tab-Index ändert.
        HiveServices.saveAnimationProgress(controller!.value); // Saves animation progress before tab change. // Speichert Animationsfortschritt vor Tab-Wechsel.

        switch (_tabController.index) { // Checks which tab is selected. // Prüft, welcher Tab ausgewählt ist.
          case 0: // If first tab (Pomodoro) is selected. // Wenn erster Tab (Pomodoro) ausgewählt ist.
            ref.read(currentTimerTypeProvider.notifier).state = 'Pomodoro'; // Updates timer type to Pomodoro. // Aktualisiert Timer-Typ auf Pomodoro.
            ref.read(timerNotifierProvider.notifier).updateDuration(0); // Resets timer duration in notifier. // Setzt Timer-Dauer im Notifier zurück.
            ref.read(timerNotifierProvider.notifier).updateColor(); // Updates color based on timer type. // Aktualisiert Farbe basierend auf Timer-Typ.
            updateAnimationControllerDuration(); // Updates animation duration. // Aktualisiert Animationsdauer.
            controller?.reset(); // Resets animation. // Setzt Animation zurück.
            break;
          case 1: // If second tab (Short Break) is selected. // Wenn zweiter Tab (Kurze Pause) ausgewählt ist.
            ref.read(currentTimerTypeProvider.notifier).state = 'Short Break'; // Updates timer type to Short Break. // Aktualisiert Timer-Typ auf Kurze Pause.
            ref.read(timerNotifierProvider.notifier).updateDuration(0); // Resets timer duration in notifier. // Setzt Timer-Dauer im Notifier zurück.
            ref.read(timerNotifierProvider.notifier).updateColor(); // Updates color based on timer type. // Aktualisiert Farbe basierend auf Timer-Typ.
            updateAnimationControllerDuration(); // Updates animation duration. // Aktualisiert Animationsdauer.
            controller?.reset(); // Resets animation. // Setzt Animation zurück.
            break;
          case 2: // If third tab (Long Break) is selected. // Wenn dritter Tab (Lange Pause) ausgewählt ist.
            ref.read(currentTimerTypeProvider.notifier).state = 'Long Break'; // Updates timer type to Long Break. // Aktualisiert Timer-Typ auf Lange Pause.
            ref.read(timerNotifierProvider.notifier).updateDuration(0); // Resets timer duration in notifier. // Setzt Timer-Dauer im Notifier zurück.
            ref.read(timerNotifierProvider.notifier).updateColor(); // Updates color based on timer type. // Aktualisiert Farbe basierend auf Timer-Typ.
            updateAnimationControllerDuration(); // Updates animation duration. // Aktualisiert Animationsdauer.
            controller?.reset(); // Resets animation. // Setzt Animation zurück.
            break;
        }
      }
    });
  }

  @override
  void didChangeDependencies() { // Called when widget dependencies change. // Wird aufgerufen, wenn sich Widget-Abhängigkeiten ändern.
    super.didChangeDependencies(); // Calls parent method. // Ruft Elternmethode auf.
    updateAnimationControllerDuration(); // Updates animation duration when dependencies change. // Aktualisiert Animationsdauer, wenn sich Abhängigkeiten ändern.
    ref.read(eventNotifierProvider.notifier).addListener((event) { // Adds listener for application events. // Fügt Listener für Anwendungsereignisse hinzu.
      if (event == "updateAnimationDuration") { // If event is to update animation duration. // Wenn das Ereignis darin besteht, die Animationsdauer zu aktualisieren.
        updateAnimationControllerDuration(); // Updates animation controller duration. // Aktualisiert die Dauer des Animations-Controllers.
        controller?.reset(); // Resets animation. // Setzt Animation zurück.
      }
    });
  }

  @override
  void dispose() { // Called when widget is removed from widget tree. // Wird aufgerufen, wenn das Widget aus dem Widget-Baum entfernt wird.
    HiveServices.saveAnimationProgress(controller!.value); // Saves current animation progress before disposal. // Speichert aktuellen Animationsfortschritt vor der Entsorgung.

    _tabController.dispose(); // Releases resources used by tab controller. // Gibt vom Tab-Controller verwendete Ressourcen frei.
    controller?.dispose(); // Releases resources used by animation controller. // Gibt vom Animations-Controller verwendete Ressourcen frei.
    super.dispose(); // Calls parent dispose method. // Ruft die Eltern-dispose-Methode auf.
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    return Consumer( // Creates a consumer widget to watch Riverpod state. // Erstellt ein Consumer-Widget, um Riverpod-Zustand zu beobachten.
      builder: (context, read, _) { // Builder function for consumer. // Builder-Funktion für Consumer.
        ref
            .read(currentTimerTypeProvider.notifier)
            .addListener((currentTimerType) { // Adds listener for timer type changes. // Fügt Listener für Timer-Typ-Änderungen hinzu.
          switch (currentTimerType) { // Checks current timer type. // Prüft den aktuellen Timer-Typ.
            case 'Pomodoro': // If timer type is Pomodoro. // Wenn Timer-Typ Pomodoro ist.
              _tabController.animateTo(0); // Animates to first tab. // Animiert zum ersten Tab.
              break;
            case 'Short Break': // If timer type is Short Break. // Wenn Timer-Typ Kurze Pause ist.
              _tabController.animateTo(1); // Animates to second tab. // Animiert zum zweiten Tab.
              break;
            case 'Long Break': // If timer type is Long Break. // Wenn Timer-Typ Lange Pause ist.
              _tabController.animateTo(2); // Animates to third tab. // Animiert zum dritten Tab.
              break;
          }
        });

        return Scaffold( // Creates a Material Design basic page layout. // Erstellt ein Material Design-Grundseitenlayout.
          backgroundColor:  const Color.fromARGB(255, 0, 0, 0), // Sets background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
          appBar: PreferredSize( // Creates a custom size app bar. // Erstellt eine App-Leiste mit benutzerdefinierter Größe.
            preferredSize: const Size.fromHeight(77.0), // Sets app bar height to 77 logical pixels. // Setzt die App-Leisten-Höhe auf 77 logische Pixel.
            child: AppBar( // Creates the app bar. // Erstellt die App-Leiste.
              backgroundColor:  const Color.fromARGB(255, 0, 0, 0), // Sets app bar background to black. // Setzt den App-Leisten-Hintergrund auf Schwarz.
              automaticallyImplyLeading: false, // Disables automatic back button. // Deaktiviert die automatische Zurück-Schaltfläche.
              elevation: 0.0, // Removes app bar shadow. // Entfernt den App-Leisten-Schatten.
              titleSpacing: 0.0, // Removes default title spacing. // Entfernt den standardmäßigen Titelabstand.
              toolbarHeight: 77.0, // Sets toolbar height to 77 logical pixels. // Setzt die Werkzeugleisten-Höhe auf 77 logische Pixel.
              bottom: AppTabBar(tabController: _tabController), // Adds custom tab bar at bottom of app bar. // Fügt benutzerdefinierte Tab-Leiste am unteren Rand der App-Leiste hinzu.
            ),
          ),
          body: Stack(children: <Widget>[ // Creates a stack layout for overlapping widgets. // Erstellt ein Stack-Layout für überlappende Widgets.
            Positioned.fill( // Creates a widget that fills its parent. // Erstellt ein Widget, das seinen Elternteil ausfüllt.
              child: CustomPaint( // Creates a custom drawing area. // Erstellt einen benutzerdefinierten Zeichenbereich.
                painter: CustomTimePainter( // Assigns custom painter for timer visualization. // Weist benutzerdefinierten Maler für Timer-Visualisierung zu.
                  animation: controller!, // Passes animation controller to painter. // Übergibt Animations-Controller an den Maler.
                  backgroundColor:
                    const Color.fromARGB(255, 0, 0, 0), // Sets background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
                  color: 
                ref.watch(currentColorProvider), // Gets current color from provider. // Holt aktuelle Farbe vom Provider.
                   
                ),
              ),
            ),
            Transform.translate( // Creates a transformation to adjust widget position. // Erstellt eine Transformation, um die Widget-Position anzupassen.
              offset: const Offset(0, -30), // Moves widget 30 pixels up. // Verschiebt Widget 30 Pixel nach oben.
              child: const TaskCard(), // Adds task card widget. // Fügt Aufgabenkarten-Widget hinzu.
            ),
            Align( // Creates an alignment container. // Erstellt einen Ausrichtungs-Container.
              alignment: Alignment.bottomCenter, // Aligns child to bottom center. // Richtet Kind unten in der Mitte aus.
              child: Padding( // Adds padding around child. // Fügt Polsterung um das Kind hinzu.
                padding: const EdgeInsets.only(left: 23, right: 23, bottom: 23), // Sets padding on left, right, and bottom. // Setzt Polsterung links, rechts und unten.
                child: PlayPauseButton(controller: controller!), // Adds play/pause button with animation controller. // Fügt Wiedergabe/Pause-Schaltfläche mit Animations-Controller hinzu.
              ),
            )
          ]),
        );
      },
    );
  }
}
