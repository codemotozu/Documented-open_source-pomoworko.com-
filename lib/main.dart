/// PomodoroApp
/// 
/// A productivity application featuring a Pomodoro timer, task management, and time tracking functionality. // Eine Produktivitätsanwendung mit Pomodoro-Timer, Aufgabenverwaltung und Zeiterfassungsfunktionalität.
/// Seamlessly synchronizes user preferences, timer settings, and project data between devices. // Synchronisiert Benutzereinstellungen, Timer-Einstellungen und Projektdaten nahtlos zwischen Geräten.
/// 
/// Features / Funktionen:
/// - Customizable Pomodoro timers with short and long breaks / Anpassbare Pomodoro-Timer mit kurzen und langen Pausen
/// - Task management with card-based interface / Aufgabenverwaltung mit kartenbasierter Benutzeroberfläche
/// - Project tracking with time statistics / Projektverfolgung mit Zeitstatistiken
/// - User authentication and cloud synchronization / Benutzerauthentifizierung und Cloud-Synchronisation
/// - Dark and light theme support / Unterstützung für dunkles und helles Thema
/// - Browser notifications / Browser-Benachrichtigungen
/// - Customizable sounds and colors / Anpassbare Töne und Farben
/// - Offline support with local storage / Offline-Unterstützung mit lokalem Speicher
/// 
/// Usage:
/// ```dart
/// void main() {
///   runApp(
///     const ProviderScope(
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
/// 
/// EN: Main entry point for the Pomodoro productivity application, handling initialization, state management, and routing.
/// DE: Haupteinstiegspunkt für die Pomodoro-Produktivitätsanwendung, die Initialisierung, Zustandsverwaltung und Routing behandelt.

import 'dart:html' as html;  // Import HTML library for web browser integration.  // Importiert die HTML-Bibliothek für die Webbrowser-Integration.

import 'package:flutter/material.dart';  // Import core Flutter material design package.  // Importiert das Flutter Material Design Kernpaket.
import 'package:flutter/rendering.dart';  // Import Flutter rendering library for debugging.  // Importiert die Flutter-Rendering-Bibliothek für Debugging.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';  // Import for local notifications.  // Importiert die Bibliothek für lokale Benachrichtigungen.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod for state management.  // Importiert Riverpod für das Statusmanagement.
import 'package:hive_flutter/hive_flutter.dart';  // Import Hive for local storage.  // Importiert Hive für lokalen Speicher.
import 'package:routemaster/routemaster.dart';  // Import Routemaster for navigation.  // Importiert Routemaster für die Navigation.
import 'infrastructure/data_sources/hive_services.dart';  // Import local Hive services.  // Importiert lokale Hive-Dienste.
import 'models/error_model.dart';  // Import error model.  // Importiert das Fehlermodell.
import 'models/user_model.dart';  // Import user model.  // Importiert das Benutzermodell.
import 'presentation/notifiers/persistent_container_notifier.dart';  // Import container state management.  // Importiert das Container-Statusmanagement.
import 'presentation/notifiers/pomodoro_notifier.dart';  // Import Pomodoro timer state management.  // Importiert das Pomodoro-Timer-Statusmanagement.
import 'presentation/notifiers/project_state_notifier.dart';  // Import project state management.  // Importiert das Projekt-Statusmanagement.
import 'presentation/notifiers/project_time_notifier.dart';  // Import project time tracking management.  // Importiert das Projektzeitverfolgungsmanagement.
import 'presentation/notifiers/providers.dart';  // Import app providers.  // Importiert App-Provider.
import 'presentation/repository/auth_repository.dart';  // Import authentication repository.  // Importiert das Authentifizierungs-Repository.
import 'router.dart';  // Import app router.  // Importiert den App-Router.

late Box box;  // Declare a late initialized Hive box for local storage.  // Deklariert eine spät initialisierte Hive-Box für lokalen Speicher.

final container = ProviderContainer();  // Create a global provider container.  // Erstellt einen globalen Provider-Container.

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();  // Initialize notifications plugin.  // Initialisiert das Benachrichtigungs-Plugin.

final notificationSelectedProvider = StateProvider<String?>((ref) => null);  // Create provider for selected notification.  // Erstellt einen Provider für ausgewählte Benachrichtigungen.

Future main() async {  // Main entry point for the application.  // Haupteinstiegspunkt für die Anwendung.
  debugPaintSizeEnabled = false;  // Disable debug paint for UI elements.  // Deaktiviert Debug-Zeichnen für UI-Elemente.

  WidgetsFlutterBinding.ensureInitialized();  // Initialize Flutter engine.  // Initialisiert die Flutter-Engine.

  await Hive.initFlutter();  // Initialize Hive for Flutter.  // Initialisiert Hive für Flutter.

  await HiveServices.openBox();  // Open the Hive storage box.  // Öffnet die Hive-Speicherbox.


  if (html.Notification.supported) {  // Check if browser notifications are supported.  // Prüft, ob Browser-Benachrichtigungen unterstützt werden.
    bool browserNotificationsEnabled =
        html.Notification.permission == "granted";  // Check notification permission.  // Prüft die Benachrichtigungsberechtigung.
    await HiveServices.saveNotificationSwitchState(browserNotificationsEnabled);  // Save notification state.  // Speichert den Benachrichtigungsstatus.
  }

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');  // Configure Android notifications.  // Konfiguriert Android-Benachrichtigungen.
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);  // Set up notifications settings.  // Richtet Benachrichtigungseinstellungen ein.

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);  // Initialize notifications with settings.  // Initialisiert Benachrichtigungen mit Einstellungen.

  NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();  // Get launch details.  // Holt Start-Details.

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {  // Check if app was launched by notification.  // Prüft, ob die App durch eine Benachrichtigung gestartet wurde.
    debugPrint('notification payload: ');  // Log notification launch.  // Protokolliert den Benachrichtigungsstart.
  }

  runApp(  // Start the Flutter application.  // Startet die Flutter-Anwendung.
    const ProviderScope(  // Wrap app with provider scope for Riverpod.  // Umschließt die App mit einem Provider-Scope für Riverpod.
      overrides: [],  // No provider overrides.  // Keine Provider-Überschreibungen.
      child: MyApp(),  // MyApp is the root widget.  // MyApp ist das Wurzel-Widget.
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {  // Define main app as Riverpod consumer.  // Definiert die Haupt-App als Riverpod-Consumer.
  const MyApp({super.key});  // Constructor with key parameter.  // Konstruktor mit Schlüsselparameter.

  @override
  ConsumerState createState() => _MyAppState();  // Create app state.  // Erstellt den App-Status.
}

class _MyAppState extends ConsumerState {  // App state implementation.  // Implementierung des App-Status.
  ErrorModel? errorModel;  // Variable to hold user data or error.  // Variable zum Speichern von Benutzerdaten oder Fehler.

  @override
  void initState() {  // Initialize state.  // Initialisiert den Status.
    super.initState();  // Call parent method.  // Ruft Elternmethode auf.
    getUserData();  // Fetch user data.  // Holt Benutzerdaten.
  }

  void getUserData() async {  // Method to fetch and set up user data.  // Methode zum Abrufen und Einrichten von Benutzerdaten.
    errorModel = await ref.read(authRepositoryProvider).getUserData();  // Get user data from auth repository.  // Holt Benutzerdaten aus dem Auth-Repository.

      // First retrieve taskCardTitle from local storage  // Zuerst den taskCardTitle aus dem lokalen Speicher abrufen
  final localStorageRepository = ref.read(localStorageRepositoryProvider);  // Get local storage repository.  // Holt das lokale Speicher-Repository.
  final savedTaskCardTitle = await localStorageRepository.getTaskCardTitle();  // Get saved task card title.  // Holt gespeicherten Aufgabenkartentitel.
  final savedProjectNames = await localStorageRepository.getProjectNames();  // Get saved project names.  // Holt gespeicherte Projektnamen.
  final savedContainerIndex = await localStorageRepository.getSelectedContainerIndex();  // Get saved container index.  // Holt gespeicherten Container-Index.

   // Get saved timeframe data  // Holt gespeicherte Zeitrahmendaten
    final savedWeeklyTimeframes = await localStorageRepository.getWeeklyTimeframes();  // Get weekly timeframes.  // Holt wöchentliche Zeitrahmen.
    final savedMonthlyTimeframes = await localStorageRepository.getMonthlyTimeframes();  // Get monthly timeframes.  // Holt monatliche Zeitrahmen.
    final savedYearlyTimeframes = await localStorageRepository.getYearlyTimeframes();  // Get yearly timeframes.  // Holt jährliche Zeitrahmen.

    if (errorModel != null && errorModel!.data != null) {  // Check if user data exists.  // Prüft, ob Benutzerdaten existieren.
      ref.read(userProvider.notifier).update((state) => errorModel!.data);  // Update user provider with data.  // Aktualisiert den Benutzer-Provider mit Daten.
    
    
    // Set timer values from user data  // Setzt Timer-Werte aus Benutzerdaten
    ref.read(pomodoroTimerProvider.notifier).state = errorModel!.data.pomodoroTimer;  // Set Pomodoro timer duration.  // Setzt die Pomodoro-Timer-Dauer.
    ref.read(shortBreakProvider.notifier).state = errorModel!.data.shortBreakTimer;  // Set short break duration.  // Setzt die Kurzpausen-Dauer.
    ref.read(longBreakProvider.notifier).state = errorModel!.data.longBreakTimer;  // Set long break duration.  // Setzt die Langpausen-Dauer.
    ref.read(longBreakIntervalProvider.notifier).state = errorModel!.data.longBreakInterval;  // Set long break interval.  // Setzt das Langpausen-Intervall.
    ref.read(selectedSoundProvider.notifier).updateSoundFromPath(errorModel!.data.selectedSound);  // Set notification sound.  // Setzt den Benachrichtigungston.
    // Set browser notifications state  // Setzt den Browser-Benachrichtigungsstatus
    ref.read(browserNotificationsProvider.notifier).set(errorModel!.data.browserNotificationsEnabled);  // Set notifications enabled flag.  // Setzt die Benachrichtigungen-aktiviert-Flagge.
    
    ref.read(darkPomodoroColorProvider.notifier).state = Color(int.parse(errorModel!.data.pomodoroColor.substring(1), radix: 16));  // Set Pomodoro color.  // Setzt die Pomodoro-Farbe.
    ref.read(darkShortBreakColorProvider.notifier).state = Color(int.parse(errorModel!.data.shortBreakColor.substring(1), radix: 16));  // Set short break color.  // Setzt die Kurzpausen-Farbe.
    ref.read(darkLongBreakColorProvider.notifier).state = Color(int.parse(errorModel!.data.longBreakColor.substring(1), radix: 16));  // Set long break color.  // Setzt die Langpausen-Farbe.
    ref.read(pomodoroNotifierProvider.notifier).state = PomodoroState(errorModel!.data.pomodoroStates);  // Set Pomodoro state.  // Setzt den Pomodoro-Status.
    // Load toggle state from user data  // Lädt den Toggle-Status aus den Benutzerdaten
    ref.read(toDoHappySadToggleProvider.notifier).set(errorModel!.data.toDoHappySadToggle);  // Set to-do view toggle.  // Setzt den To-Do-Ansicht-Schalter.
    ref.read(taskDeletionsProvider.notifier).set(errorModel!.data.taskDeletionByTrashIcon);  // Set task deletion toggle.  // Setzt den Aufgabenlöschungs-Schalter.
    
    //add taskCardTitle  // Fügt taskCardTitle hinzu
    ref.read(taskCardTitleProvider.notifier).state = errorModel!.data.taskCardTitle;  // Set task card title.  // Setzt den Aufgabenkartentitel.

        
final taskCardTitle = errorModel!.data.taskCardTitle.isNotEmpty 
        ? errorModel!.data.taskCardTitle 
        : savedTaskCardTitle;  // Determine task card title from server data or fallback to saved value.  // Bestimmt den Aufgabenkartentitel aus Serverdaten oder greift auf gespeicherten Wert zurück.


ref.read(taskCardTitleProvider.notifier).updateTitle(taskCardTitle);  // Update the task card title in the provider.  // Aktualisiert den Aufgabenkartentitel im Provider.
localStorageRepository.setTaskCardTitle(taskCardTitle);  // Save the task card title to local storage.  // Speichert den Aufgabenkartentitel im lokalen Speicher.


// Handle project names  // Verarbeitet Projektnamen
final projectNames = errorModel!.data.projectName.isNotEmpty 
    ? errorModel!.data.projectName 
    : savedProjectNames;  // Get project names from server or use saved values as fallback.  // Holt Projektnamen vom Server oder verwendet gespeicherte Werte als Fallback.
    
ref.read(projectStateNotifierProvider.notifier).state = projectNames;  // Update project names in the provider state.  // Aktualisiert Projektnamen im Provider-State.
localStorageRepository.saveProjectNames(projectNames);  // Save project names to local storage.  // Speichert Projektnamen im lokalen Speicher.

// Set the container index  // Setzt den Container-Index
final containerIndex = errorModel!.data.selectedContainerIndex;  // Get container index from server data.  // Holt Container-Index aus Serverdaten.
ref.read(persistentContainerIndexProvider.notifier).updateIndex(containerIndex);  // Update container index in the provider.  // Aktualisiert den Container-Index im Provider.
  

// Initialize timeframe data in the provider  // Initialisiert Zeitrahmen-Daten im Provider
final projectTimesNotifier = ref.read(projectTimesProvider.notifier);  // Get the project times notifier.  // Holt den Project-Times-Notifier.
      
// Process timeframes from server or use saved data as fallback  // Verarbeitet Zeitrahmen vom Server oder verwendet gespeicherte Daten als Fallback
final weeklyTimeframes = errorModel!.data.weeklyTimeframes.isNotEmpty
    ? errorModel!.data.weeklyTimeframes
    : savedWeeklyTimeframes;  // Get weekly timeframes from server or use saved values.  // Holt wöchentliche Zeitrahmen vom Server oder verwendet gespeicherte Werte.
final monthlyTimeframes = errorModel!.data.monthlyTimeframes.isNotEmpty
    ? errorModel!.data.monthlyTimeframes
    : savedMonthlyTimeframes;  // Get monthly timeframes from server or use saved values.  // Holt monatliche Zeitrahmen vom Server oder verwendet gespeicherte Werte.
final yearlyTimeframes = errorModel!.data.yearlyTimeframes.isNotEmpty
    ? errorModel!.data.yearlyTimeframes
    : savedYearlyTimeframes;  // Get yearly timeframes from server or use saved values.  // Holt jährliche Zeitrahmen vom Server oder verwendet gespeicherte Werte.

// Update local storage with timeframe data  // Aktualisiert lokalen Speicher mit Zeitrahmen-Daten
localStorageRepository.setWeeklyTimeframes(weeklyTimeframes);  // Save weekly timeframes to local storage.  // Speichert wöchentliche Zeitrahmen im lokalen Speicher.
localStorageRepository.setMonthlyTimeframes(monthlyTimeframes);  // Save monthly timeframes to local storage.  // Speichert monatliche Zeitrahmen im lokalen Speicher.
localStorageRepository.setYearlyTimeframes(yearlyTimeframes);  // Save yearly timeframes to local storage.  // Speichert jährliche Zeitrahmen im lokalen Speicher.

// Initialize provider state with timeframe data  // Initialisiert Provider-State mit Zeitrahmen-Daten
for (var timeframe in weeklyTimeframes) {  // Iterate through each weekly timeframe.  // Iteriert durch jeden wöchentlichen Zeitrahmen.
  projectTimesNotifier.addTimeToState(
    timeframe.projectIndex,  // Project index for this timeframe.  // Projektindex für diesen Zeitrahmen.
    timeframe.date,  // Date of this timeframe.  // Datum dieses Zeitrahmens.
    Duration(seconds: timeframe.duration),  // Convert duration from seconds to Duration object.  // Konvertiert Dauer von Sekunden in ein Duration-Objekt.
  );
}
else {  // If no user data is found, initialize with defaults.  // Wenn keine Benutzerdaten gefunden werden, mit Standardwerten initialisieren.
  // Set default values if no user data is found  // Setzt Standardwerte, wenn keine Benutzerdaten gefunden werden
  ref.read(pomodoroTimerProvider.notifier).state = 25;  // Set default Pomodoro timer to 25 minutes.  // Setzt Standard-Pomodoro-Timer auf 25 Minuten.
  ref.read(shortBreakProvider.notifier).state = 5;  // Set default short break to 5 minutes.  // Setzt Standard-Kurzpause auf 5 Minuten.
  ref.read(longBreakProvider.notifier).state = 15;  // Set default long break to 15 minutes.  // Setzt Standard-Langpause auf 15 Minuten.
  ref.read(longBreakIntervalProvider.notifier).state = 4;  // Set default long break interval to 4 pomodoros.  // Setzt Standard-Langpausenintervall auf 4 Pomodoros.
  
  ref.read(selectedSoundProvider.notifier).updateSoundFromPath('assets/sounds/Flashpoint.wav');  // Set default notification sound.  // Setzt Standard-Benachrichtigungston.
  ref.read(browserNotificationsProvider.notifier).set(false);  // Disable browser notifications by default.  // Deaktiviert Browser-Benachrichtigungen standardmäßig.
  ref.read(darkPomodoroColorProvider.notifier).state = const Color(0xff74F143);  // Set default Pomodoro color to green.  // Setzt Standard-Pomodoro-Farbe auf Grün.
  ref.read(darkShortBreakColorProvider.notifier).state = const Color(0xffff9933);  // Set default short break color to orange.  // Setzt Standard-Kurzpausenfarbe auf Orange.
  ref.read(darkLongBreakColorProvider.notifier).state = const Color(0xff0891FF);  // Set default long break color to blue.  // Setzt Standard-Langpausenfarbe auf Blau.
  ref.read(pomodoroNotifierProvider.notifier).state = PomodoroState([]);  // Initialize Pomodoro states as empty.  // Initialisiert Pomodoro-Zustände als leer.
  ref.read(toDoHappySadToggleProvider.notifier).set(false);  // Disable happy/sad toggle by default.  // Deaktiviert Happy/Sad-Umschalter standardmäßig.
  ref.read(taskDeletionsProvider.notifier).set(false);  // Disable task deletion by default.  // Deaktiviert Aufgabenlöschung standardmäßig.
  ref.read(taskCardTitleProvider.notifier).updateTitle(savedTaskCardTitle);  // Set task card title from saved value.  // Setzt Aufgabenkartentitel aus gespeichertem Wert.

   
  const defaultProjects = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];  // Define default project placeholder names.  // Definiert Standard-Projektplatzhalternamen.
  ref.read(projectStateNotifierProvider.notifier).state = defaultProjects;  // Initialize default projects in provider.  // Initialisiert Standardprojekte im Provider.
  localStorageRepository.saveProjectNames(defaultProjects);  // Save default projects to local storage.  // Speichert Standardprojekte im lokalen Speicher.
  ref.read(persistentContainerIndexProvider.notifier).updateIndex(savedContainerIndex);  // Set container index from saved value.  // Setzt Container-Index aus gespeichertem Wert.
}


 @override
  void dispose() {  // Override the dispose method for cleanup.  // Überschreibt die dispose-Methode für die Bereinigung.
    Hive.close();  // Close Hive database connections.  // Schließt die Hive-Datenbankverbindungen.
    super.dispose();  // Call the parent class dispose method.  // Ruft die dispose-Methode der Elternklasse auf.
  }

  @override
  Widget build(BuildContext context) {  // Override the build method to create the UI.  // Überschreibt die build-Methode, um die Benutzeroberfläche zu erstellen.
    ref.watch(timerInitProvider);  // Watch timer initialization provider.  // Überwacht den Timer-Initialisierungsanbieter.
    ref.watch(soundInitProvider);  // Watch sound initialization provider.  // Überwacht den Sound-Initialisierungsanbieter.
    ref.watch(colorInitProvider);  // Watch color initialization provider.  // Überwacht den Farb-Initialisierungsanbieter.

    return MaterialApp.router(  // Return a MaterialApp with router configuration.  // Gibt eine MaterialApp mit Router-Konfiguration zurück.
      debugShowCheckedModeBanner: false,  // Hide debug banner in the app.  // Blendet das Debug-Banner in der App aus.
      title: 'Pomodoro Timer 2025.',  // Set app title.  // Legt den App-Titel fest.

      theme: ThemeData(  // Define light theme.  // Definiert das helle Thema.
        brightness: Brightness.light,  // Set light brightness.  // Stellt die helle Helligkeit ein.
        useMaterial3: true,  // Enable Material 3 design.  // Aktiviert Material 3 Design.
        visualDensity: VisualDensity.adaptivePlatformDensity,  // Adapt visual density to platform.  // Passt die visuelle Dichte an die Plattform an.
      ),
      darkTheme: ThemeData(  // Define dark theme.  // Definiert das dunkle Thema.
        useMaterial3: true,  // Enable Material 3 design.  // Aktiviert Material 3 Design.
        brightness: Brightness.dark,  // Set dark brightness.  // Stellt die dunkle Helligkeit ein.
        visualDensity: VisualDensity.adaptivePlatformDensity,  // Adapt visual density to platform.  // Passt die visuelle Dichte an die Plattform an.
      ),
      themeMode: ref.watch(themeModeProvider),  // Watch and apply current theme mode.  // Überwacht und wendet den aktuellen Themenmodus an.
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {  // Configure router delegate.  // Konfiguriert den Router-Delegaten.
        final user = ref.watch(userProvider);  // Watch current user state.  // Überwacht den aktuellen Benutzerzustand.

        if (user != null && user.token.isNotEmpty) {  // Check if user is authenticated.  // Prüft, ob der Benutzer authentifiziert ist.
          return loggedInRoute;  // Return routes for authenticated users.  // Gibt Routen für authentifizierte Benutzer zurück.
        }
        return loggedOutRoute;  // Return routes for unauthenticated users.  // Gibt Routen für nicht authentifizierte Benutzer zurück.
      }),
      routeInformationParser: const RoutemasterParser(),  // Set route information parser.  // Setzt den Routeninformationsparser.
    );
  }
}
