/// AuthRepository
/// 
/// A comprehensive repository class for managing user authentication, data persistence, and application settings. // Eine umfassende Repository-Klasse zur Verwaltung von Benutzerauthentifizierung, Datenpersistenz und Anwendungseinstellungen.
/// Handles Google Sign-In authentication, user data synchronization, subscription management, and user preferences. // Verarbeitet Google Sign-In-Authentifizierung, Benutzerdatensynchronisation, Abonnementverwaltung und Benutzereinstellungen.
///
/// Core functionalities:
/// - Authentication with Google Sign-In // Authentifizierung mit Google Sign-In
/// - User profile data persistence // Persistenz von Benutzerprofildaten
/// - Subscription management (premium features) // Abonnementverwaltung (Premium-Funktionen)
/// - Project management and time tracking // Projektverwaltung und Zeiterfassung
/// - Pomodoro timer settings // Pomodoro-Timer-Einstellungen
/// - Task management // Aufgabenverwaltung
/// - User interface preferences // Benutzeroberflächen-Präferenzen
/// - Account management (creation, deletion) // Kontoverwaltung (Erstellung, Löschung)
/// 
/// Usage:
/// ```dart
/// final authRepo = ref.read(authRepositoryProvider);
/// 
/// // Authentication
/// final result = await authRepo.signInWithGoogle(ref);
/// 
/// // User settings
/// await authRepo.updateUserSettings(25, 5, 15, 4, selectedSound, true, pomodoroColor, shortBreakColor, longBreakColor);
/// 
/// // Project management
/// await authRepo.updateProjectName("My Project", 0);
/// 
/// // Time tracking
/// await authRepo.addTimeframeData(projectIndex: 0, date: DateTime.now(), duration: 1500, timeframeType: "weekly");
/// ```
/// 
/// EN: Manages authentication processes, user data persistence, and application settings for productivity features.
/// DE: Verwaltet Authentifizierungsprozesse, Benutzerdatenpersistenz und Anwendungseinstellungen für Produktivitätsfunktionen.


import 'dart:convert'; // Imports conversion utilities for JSON. // Importiert Konvertierungsdienstprogramme für JSON.
import 'dart:ui'; // Imports UI utilities like Color. // Importiert UI-Dienstprogramme wie Color.

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_sign_in/google_sign_in.dart'; // Imports Google Sign-In package. // Importiert das Google Sign-In-Paket.
import 'package:http/http.dart'; // Imports HTTP client for API requests. // Importiert HTTP-Client für API-Anfragen.

import '../../common/widgets/domain/entities/sound_entity.dart'; // Imports Sound entity model. // Importiert Sound-Entitätsmodell.
import '../../common/widgets/domain/entities/todo_entity.dart'; // Imports Todo entity model. // Importiert Todo-Entitätsmodell.
import '../../constants.dart'; // Imports app constants. // Importiert App-Konstanten.
import '../../models/error_model.dart'; // Imports error handling model. // Importiert Fehlerbehandlungsmodell.
import '../../models/timeframe_entry.dart'; // Imports timeframe entries model. // Importiert Zeitrahmen-Eintragsmodell.
import '../../models/user_model.dart'; // Imports user data model. // Importiert Benutzerdatenmodell.
import '../notifiers/persistent_container_notifier.dart'; // Imports container state management. // Importiert Container-Zustandsverwaltung.
import '../notifiers/pomodoro_notifier.dart'; // Imports pomodoro timer state management. // Importiert Pomodoro-Timer-Zustandsverwaltung.
import '../notifiers/project_state_notifier.dart'; // Imports project state management. // Importiert Projekt-Zustandsverwaltung.
import '../notifiers/project_time_notifier.dart'; // Imports project time tracking management. // Importiert Projekt-Zeiterfassungsverwaltung.
import '../notifiers/providers.dart'; // Imports app providers. // Importiert App-Provider.
import '../notifiers/task_notifier.dart'; // Imports task management. // Importiert Aufgabenverwaltung.
import 'local_storage_repository.dart'; // Imports local storage handling. // Importiert lokale Speicherverwaltung.

final authRepositoryProvider = Provider( // Defines a provider for AuthRepository instance. // Definiert einen Provider für die AuthRepository-Instanz.
  (ref) => AuthRepository( // Creates a new AuthRepository with dependencies. // Erstellt ein neues AuthRepository mit Abhängigkeiten.
    googleSignIn: GoogleSignIn(), // Provides Google Sign-In instance. // Stellt eine Google Sign-In-Instanz bereit.
    client: Client(), // Provides HTTP client. // Stellt einen HTTP-Client bereit.
    localStorageRepository: LocalStorageRepository(), // Provides local storage access. // Stellt Zugriff auf lokalen Speicher bereit.
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null); // Creates a provider for user state, initially null. // Erstellt einen Provider für den Benutzerzustand, anfänglich null.

class AuthRepository { // Class declaration for authentication repository. // Klassendeklaration für das Authentifizierungs-Repository.
  final GoogleSignIn _googleSignIn; // Private field for Google Sign-In instance. // Privates Feld für die Google Sign-In-Instanz.
  final Client _client; // Private field for HTTP client. // Privates Feld für den HTTP-Client.
  final LocalStorageRepository _localStorageRepository; // Private field for local storage. // Privates Feld für den lokalen Speicher.
  AuthRepository({ // Constructor with required dependencies. // Konstruktor mit erforderlichen Abhängigkeiten.
    required GoogleSignIn googleSignIn, // Required Google Sign-In parameter. // Erforderlicher Google Sign-In-Parameter.
    required Client client, // Required HTTP client parameter. // Erforderlicher HTTP-Client-Parameter.
    required LocalStorageRepository localStorageRepository, // Required local storage parameter. // Erforderlicher lokaler Speicher-Parameter.
  })  : _googleSignIn = googleSignIn, // Initializes private Google Sign-In field. // Initialisiert privates Google Sign-In-Feld.
        _client = client, // Initializes private HTTP client field. // Initialisiert privates HTTP-Client-Feld.
        _localStorageRepository = localStorageRepository; // Initializes private local storage field. // Initialisiert privates lokales Speicher-Feld.

  Future<ErrorModel> signInWithGoogle(WidgetRef ref) async { // Method to sign in with Google, returns future with error model. // Methode zur Anmeldung mit Google, gibt Future mit Fehlermodell zurück.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      final user = await _googleSignIn.signIn(); // Attempt Google Sign-In. // Versucht die Google-Anmeldung.
      if (user != null) { // Check if sign-in was successful. // Prüft, ob die Anmeldung erfolgreich war.
      
        final savedTaskCardTitle = await _localStorageRepository.getTaskCardTitle(); // Get saved task card title. // Holt gespeicherten Aufgabenkartentitel.
        final savedWeeklyTimeframes = await _localStorageRepository.getWeeklyTimeframes(); // Get saved weekly timeframes. // Holt gespeicherte wöchentliche Zeitrahmen.
        final savedMonthlyTimeframes = await _localStorageRepository.getMonthlyTimeframes(); // Get saved monthly timeframes. // Holt gespeicherte monatliche Zeitrahmen.
        final savedYearlyTimeframes = await _localStorageRepository.getYearlyTimeframes(); // Get saved yearly timeframes. // Holt gespeicherte jährliche Zeitrahmen.
           
        final userAcc = UserModel( // Create user model with Google account data. // Erstellt Benutzermodell mit Google-Kontodaten.
          email: user.email, // Set email from Google account. // Setzt E-Mail aus Google-Konto.
          name: user.displayName ?? '', // Set name from Google account, empty if null. // Setzt Namen aus Google-Konto, leer wenn null.
          profilePic: user.photoUrl ?? '', // Set profile picture URL, empty if null. // Setzt Profilbild-URL, leer wenn null.
          uid: '', // Empty user ID initially. // Anfänglich leere Benutzer-ID.
          token: '', // Empty token initially. // Anfänglich leeres Token.
          isPremium: user.email == '' ? false : true, // Set premium status based on email. // Setzt Premium-Status basierend auf E-Mail.
          subscriptionId: '', // Empty subscription ID initially. // Anfänglich leere Abonnement-ID.
          suscriptionStatusCancelled: 
              await _localStorageRepository.getsuscriptionStatusCancelled(), // Get subscription cancellation status. // Holt Abonnement-Kündigungsstatus.
          subscriptionStatusConfirmed:
              await _localStorageRepository.getsubscriptionStatusConfirmed(), // Get subscription confirmation status. // Holt Abonnement-Bestätigungsstatus.
          subscriptionStatusPending: user.email == '' ? false : true, // Set pending status based on email. // Setzt ausstehenden Status basierend auf E-Mail.
          nextBillingTime: null, // No next billing time initially. // Anfänglich keine nächste Abrechnungszeit.
          startTimeSubscriptionPayPal: null, // No PayPal subscription start time initially. // Anfänglich keine PayPal-Abonnement-Startzeit.
          paypalSubscriptionCancelledAt: null, // No PayPal cancellation time initially. // Anfänglich keine PayPal-Kündigungszeit.
          userLocalTimeZone: null, // No user timezone initially. // Anfänglich keine Benutzer-Zeitzone.
          pomodoroTimer: 25, // Default pomodoro timer (25 minutes). // Standard-Pomodoro-Timer (25 Minuten).
          shortBreakTimer: 5, // Default short break timer (5 minutes). // Standard-Kurzpausentimer (5 Minuten).
          longBreakTimer: 15, // Default long break timer (15 minutes). // Standard-Langpausentimer (15 Minuten).
          longBreakInterval: 4, // Default long break interval (after 4 pomodoros). // Standard-Langpausenintervall (nach 4 Pomodoros).
          selectedSound: '', // No sound selected initially. // Anfänglich kein Sound ausgewählt.
          browserNotificationsEnabled: false, // Browser notifications disabled by default. // Browser-Benachrichtigungen standardmäßig deaktiviert.
          pomodoroColor: '', // No pomodoro color set initially. // Anfänglich keine Pomodoro-Farbe gesetzt.
          shortBreakColor: '', // No short break color set initially. // Anfänglich keine Kurzpausenfarbe gesetzt.
          longBreakColor: '', // No long break color set initially. // Anfänglich keine Langpausenfarbe gesetzt.
          pomodoroStates: [], // Empty pomodoro states initially. // Anfänglich leere Pomodoro-Zustände.
          toDoHappySadToggle: false, // Happy/sad toggle disabled by default. // Happy/Sad-Umschalter standardmäßig deaktiviert.
          taskDeletionByTrashIcon: false, // Task deletion by trash icon disabled by default. // Aufgabenlöschung durch Papierkorb-Symbol standardmäßig deaktiviert.
          taskCardTitle: savedTaskCardTitle, // Set task card title from local storage. // Setzt Aufgabenkartentitel aus lokalem Speicher.
          projectName: [], // Empty project names initially. // Anfänglich leere Projektnamen.
          selectedContainerIndex: 0, // Default container index is 0. // Standard-Container-Index ist 0.
          weeklyTimeframes: savedWeeklyTimeframes, // Set weekly timeframes from local storage. // Setzt wöchentliche Zeitrahmen aus lokalem Speicher.
          monthlyTimeframes: savedMonthlyTimeframes, // Set monthly timeframes from local storage. // Setzt monatliche Zeitrahmen aus lokalem Speicher.
          yearlyTimeframes: savedYearlyTimeframes, // Set yearly timeframes from local storage. // Setzt jährliche Zeitrahmen aus lokalem Speicher.
        );
        print(
            "isPremium from auth_repository.dart : ${user.email == '' ? false : true}"); // Debug print for premium status. // Debug-Ausgabe für Premium-Status.

        var res = await _client.post(Uri.parse('$host/auth/api/signup'), // Make signup API request. // Führt Anmeldungs-API-Anfrage durch.
            body: userAcc.toJson(), // Send user model as JSON. // Sendet Benutzermodell als JSON.
            headers: {
              'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            });

        switch (res.statusCode) { // Check response status code. // Prüft Antwort-Statuscode.
          case 200: // If successful response. // Bei erfolgreicher Antwort.
            final newUser = userAcc.copyWith( // Create updated user model with response data. // Erstellt aktualisiertes Benutzermodell mit Antwortdaten.
              uid: jsonDecode(res.body)['user']['_id'], // Set user ID from response. // Setzt Benutzer-ID aus Antwort.
              token: jsonDecode(res.body)['token'], // Set authentication token from response. // Setzt Authentifizierungstoken aus Antwort.
              isPremium: jsonDecode(res.body)['user']['isPremium'], // Set premium status from response. // Setzt Premium-Status aus Antwort.
              suscriptionStatusCancelled: jsonDecode(res.body)['user']
                  ['suscriptionStatusCancelled'], // Set cancellation status from response. // Setzt Kündigungsstatus aus Antwort.
              subscriptionStatusConfirmed: jsonDecode(res.body)['user']
                  ['subscriptionStatusConfirmed'], // Set confirmation status from response. // Setzt Bestätigungsstatus aus Antwort.
              pomodoroTimer: jsonDecode(res.body)['user']['pomodoroTimer'], // Set pomodoro timer from response. // Setzt Pomodoro-Timer aus Antwort.
              shortBreakTimer: jsonDecode(res.body)['user']['shortBreakTimer'], // Set short break timer from response. // Setzt Kurzpausentimer aus Antwort.
              longBreakTimer: jsonDecode(res.body)['user']['longBreakTimer'], // Set long break timer from response. // Setzt Langpausentimer aus Antwort.
              longBreakInterval: jsonDecode(res.body)['user']
                  ['longBreakInterval'], // Set long break interval from response. // Setzt Langpausenintervall aus Antwort.
              selectedSound: jsonDecode(res.body)['user']['selectedSound'], // Set selected sound from response. // Setzt ausgewählten Sound aus Antwort.
              browserNotificationsEnabled: jsonDecode(res.body)['user']
                  ['browserNotificationsEnabled'], // Set notifications setting from response. // Setzt Benachrichtigungseinstellung aus Antwort.
              pomodoroColor: jsonDecode(res.body)['user']['pomodoroColor'], // Set pomodoro color from response. // Setzt Pomodoro-Farbe aus Antwort.
              shortBreakColor: jsonDecode(res.body)['user']['shortBreakColor'], // Set short break color from response. // Setzt Kurzpausenfarbe aus Antwort.
              longBreakColor: jsonDecode(res.body)['user']['longBreakColor'], // Set long break color from response. // Setzt Langpausenfarbe aus Antwort.
              pomodoroStates: List<bool>.from(
                  jsonDecode(res.body)['user']['pomodoroStates']), // Set pomodoro states from response. // Setzt Pomodoro-Zustände aus Antwort.
              toDoHappySadToggle: jsonDecode(res.body)['user']
                  ['toDoHappySadToggle'], // Set happy/sad toggle from response. // Setzt Happy/Sad-Umschalter aus Antwort.
              
              taskDeletionByTrashIcon: jsonDecode(res.body)['user']['taskDeletionByTrashIcon'], // Set task deletion setting from response. // Setzt Aufgabenlöschungseinstellung aus Antwort.

              taskCardTitle: jsonDecode(res.body)['user']['taskCardTitle'] ?? savedTaskCardTitle, // Set task card title, fallback to saved value. // Setzt Aufgabenkartentitel, Fallback auf gespeicherten Wert.
              projectName: List<String>.from(jsonDecode(res.body)['user']['projectName']), // Set project names from response. // Setzt Projektnamen aus Antwort.
              selectedContainerIndex: jsonDecode(res.body)['user']['selectedContainerIndex'], // Set container index from response. // Setzt Container-Index aus Antwort.
              weeklyTimeframes: List<TimeframeEntry>.from(
                  jsonDecode(res.body)['user']['weeklyTimeframes']?.map(
                          (x) => TimeframeEntry.fromMap(x)) ??
                      savedWeeklyTimeframes), // Set weekly timeframes, fallback to saved. // Setzt wöchentliche Zeitrahmen, Fallback auf gespeicherte.
              monthlyTimeframes: List<TimeframeEntry>.from(
                  jsonDecode(res.body)['user']['monthlyTimeframes']?.map(
                          (x) => TimeframeEntry.fromMap(x)) ??
                      savedMonthlyTimeframes), // Set monthly timeframes, fallback to saved. // Setzt monatliche Zeitrahmen, Fallback auf gespeicherte.
              yearlyTimeframes: List<TimeframeEntry>.from(
                  jsonDecode(res.body)['user']['yearlyTimeframes']?.map(
                          (x) => TimeframeEntry.fromMap(x)) ??
                      savedYearlyTimeframes), // Set yearly timeframes, fallback to saved. // Setzt jährliche Zeitrahmen, Fallback auf gespeicherte.
           
            );
            error = ErrorModel(error: null, data: newUser); // Update error model with user data. // Aktualisiert Fehlermodell mit Benutzerdaten.
            _localStorageRepository.setToken(newUser.token); // Save token to local storage. // Speichert Token im lokalen Speicher.
            _localStorageRepository.setIsPremium(newUser.isPremium); // Save premium status to local storage. // Speichert Premium-Status im lokalen Speicher.
            _localStorageRepository.setIssuscriptionStatusCancelled(
                newUser.suscriptionStatusCancelled); // Save cancellation status to local storage. // Speichert Kündigungsstatus im lokalen Speicher.
            _localStorageRepository.setIsubscriptionStatusConfirmed(
                newUser.subscriptionStatusConfirmed); // Save confirmation status to local storage. // Speichert Bestätigungsstatus im lokalen Speicher.
            _localStorageRepository.setPomodoroTimer(newUser.pomodoroTimer); // Save pomodoro timer to local storage. // Speichert Pomodoro-Timer im lokalen Speicher.
            _localStorageRepository.setShortBreakTimer(newUser.shortBreakTimer); // Save short break timer to local storage. // Speichert Kurzpausentimer im lokalen Speicher.
            _localStorageRepository.setLongBreakTimer(newUser.longBreakTimer); // Save long break timer to local storage. // Speichert Langpausentimer im lokalen Speicher.
            _localStorageRepository
                .setLongBreakInterval(newUser.longBreakInterval); // Save long break interval to local storage. // Speichert Langpausenintervall im lokalen Speicher.
            _localStorageRepository.setSelectedSound(newUser.selectedSound); // Save selected sound to local storage. // Speichert ausgewählten Sound im lokalen Speicher.
            _localStorageRepository.setBrowserNotificationsEnabled(
                newUser.browserNotificationsEnabled); // Save notifications setting to local storage. // Speichert Benachrichtigungseinstellung im lokalen Speicher.

            _localStorageRepository.setPomodoroColor(newUser.pomodoroColor); // Save pomodoro color to local storage. // Speichert Pomodoro-Farbe im lokalen Speicher.
            _localStorageRepository.setShortBreakColor(newUser.shortBreakColor); // Save short break color to local storage. // Speichert Kurzpausenfarbe im lokalen Speicher.
            _localStorageRepository.setLongBreakColor(newUser.longBreakColor); // Save long break color to local storage. // Speichert Langpausenfarbe im lokalen Speicher.
            _localStorageRepository.setPomodoroStates(newUser.pomodoroStates); // Save pomodoro states to local storage. // Speichert Pomodoro-Zustände im lokalen Speicher.

            _localStorageRepository.setToDoHappySadToggle(newUser.toDoHappySadToggle); // Save happy/sad toggle to local storage. // Speichert Happy/Sad-Umschalter im lokalen Speicher.

            _localStorageRepository.setTaskDeletionByTrashIcon(newUser.taskDeletionByTrashIcon); // Save task deletion setting to local storage. // Speichert Aufgabenlöschungseinstellung im lokalen Speicher.   
         
            _localStorageRepository.setTaskCardTitle(newUser.taskCardTitle); // Save task card title to local storage. // Speichert Aufgabenkartentitel im lokalen Speicher.
            _localStorageRepository.saveProjectNames(newUser.projectName); // Save project names to local storage. // Speichert Projektnamen im lokalen Speicher.
            _localStorageRepository.setSelectedContainerIndex(newUser.selectedContainerIndex); // Save container index to local storage. // Speichert Container-Index im lokalen Speicher.

            _localStorageRepository.setWeeklyTimeframes(newUser.weeklyTimeframes); // Save weekly timeframes to local storage. // Speichert wöchentliche Zeitrahmen im lokalen Speicher.
            _localStorageRepository.setMonthlyTimeframes(newUser.monthlyTimeframes); // Save monthly timeframes to local storage. // Speichert monatliche Zeitrahmen im lokalen Speicher.
            _localStorageRepository.setYearlyTimeframes(newUser.yearlyTimeframes); // Save yearly timeframes to local storage. // Speichert jährliche Zeitrahmen im lokalen Speicher.
         
            ref.read(pomodoroTimerProvider.notifier).state =
                newUser.pomodoroTimer; // Update pomodoro timer in state. // Aktualisiert Pomodoro-Timer im Zustand.
            ref.read(shortBreakProvider.notifier).state =
                newUser.shortBreakTimer; // Update short break timer in state. // Aktualisiert Kurzpausentimer im Zustand.
            ref.read(longBreakProvider.notifier).state = newUser.longBreakTimer; // Update long break timer in state. // Aktualisiert Langpausentimer im Zustand.
            ref.read(longBreakIntervalProvider.notifier).state =
                newUser.longBreakInterval; // Update long break interval in state. // Aktualisiert Langpausenintervall im Zustand.
            ref.read(selectedSoundProvider.notifier).updateSound(ref
                .read(soundListProvider)
                .firstWhere((sound) => sound.path == newUser.selectedSound)); // Update selected sound in state. // Aktualisiert ausgewählten Sound im Zustand.
            ref
                .read(browserNotificationsProvider.notifier)
                .set(newUser.browserNotificationsEnabled); // Update notifications setting in state. // Aktualisiert Benachrichtigungseinstellung im Zustand.

            ref.read(darkPomodoroColorProvider.notifier).state =
                Color(int.parse(newUser.pomodoroColor.substring(1), radix: 16)); // Update pomodoro color in state. // Aktualisiert Pomodoro-Farbe im Zustand.
            ref.read(darkShortBreakColorProvider.notifier).state = Color(
                int.parse(newUser.shortBreakColor.substring(1), radix: 16)); // Update short break color in state. // Aktualisiert Kurzpausenfarbe im Zustand.
            ref.read(darkLongBreakColorProvider.notifier).state = Color(
                int.parse(newUser.longBreakColor.substring(1), radix: 16)); // Update long break color in state. // Aktualisiert Langpausenfarbe im Zustand.
            ref.read(pomodoroNotifierProvider.notifier).state =
                PomodoroState(newUser.pomodoroStates); // Update pomodoro states in state. // Aktualisiert Pomodoro-Zustände im Zustand.

            ref.read(toDoHappySadToggleProvider.notifier).set(newUser.toDoHappySadToggle); // Update happy/sad toggle in state. // Aktualisiert Happy/Sad-Umschalter im Zustand.
            ref.read(taskDeletionsProvider.notifier).set(newUser.taskDeletionByTrashIcon); // Update task deletion setting in state. // Aktualisiert Aufgabenlöschungseinstellung im Zustand.
            ref.read(taskCardTitleProvider.notifier).updateTitle(newUser.taskCardTitle); // Update task card title in state. // Aktualisiert Aufgabenkartentitel im Zustand.
         
            ref.read(projectStateNotifierProvider.notifier).state = newUser.projectName; // Update project names in state. // Aktualisiert Projektnamen im Zustand.
            ref.read(persistentContainerIndexProvider.notifier).state = newUser.selectedContainerIndex; // Update container index in state. // Aktualisiert Container-Index im Zustand.

            final projectTimesNotifier = ref.read(projectTimesProvider.notifier); // Get project times notifier. // Holt Projektzeiten-Notifier.
            
            for (var timeframe in newUser.weeklyTimeframes) { // Loop through weekly timeframes. // Durchläuft wöchentliche Zeitrahmen.
              projectTimesNotifier.addTimeToState( // Add each timeframe to state. // Fügt jeden Zeitrahmen zum Zustand hinzu.
                timeframe.projectIndex, // Project index for the timeframe. // Projektindex für den Zeitrahmen.
                timeframe.date, // Date of the timeframe. // Datum des Zeitrahmens.
                Duration(seconds: timeframe.duration), // Duration in seconds. // Dauer in Sekunden.
              );
            }

            for (var timeframe in newUser.monthlyTimeframes) { // Loop through monthly timeframes. // Durchläuft monatliche Zeitrahmen.
              projectTimesNotifier.addTimeToState( // Add each timeframe to state. // Fügt jeden Zeitrahmen zum Zustand hinzu.
                timeframe.projectIndex, // Project index for the timeframe. // Projektindex für den Zeitrahmen.
                timeframe.date, // Date of the timeframe. // Datum des Zeitrahmens.
                Duration(seconds: timeframe.duration), // Duration in seconds. // Dauer in Sekunden.
              );
            }

            for (var timeframe in newUser.yearlyTimeframes) { // Loop through yearly timeframes. // Durchläuft jährliche Zeitrahmen.
              projectTimesNotifier.addTimeToState( // Add each timeframe to state. // Fügt jeden Zeitrahmen zum Zustand hinzu.
                timeframe.projectIndex, // Project index for the timeframe. // Projektindex für den Zeitrahmen.
                timeframe.date, // Date of the timeframe. // Datum des Zeitrahmens.
                Duration(seconds: timeframe.duration), // Duration in seconds. // Dauer in Sekunden.
              );
            }

            error = ErrorModel(error: null, data: newUser); // Update error model with user data. // Aktualisiert Fehlermodell mit Benutzerdaten.
            _localStorageRepository.setToken(newUser.token); // Save token to local storage again. // Speichert Token erneut im lokalen Speicher.
          
            await updateCardTodoTask( // Update card todo task. // Aktualisiert Karten-Todo-Aufgabe.
            newUser.toDoHappySadToggle, // Pass happy/sad toggle setting. // Übergibt Happy/Sad-Umschaltereinstellung.
            newUser.taskDeletionByTrashIcon, // Pass task deletion setting. // Übergibt Aufgabenlöschungseinstellung.
            newUser.taskCardTitle, // Pass task card title. // Übergibt Aufgabenkartentitel.
          );


      if (!newUser.taskDeletionByTrashIcon) { // If task deletion by trash icon is disabled. // Wenn Aufgabenlöschung durch Papierkorb-Symbol deaktiviert ist.
        var todo = Todo( // Create new todo item. // Erstellt neues Todo-Element.
          title: newUser.taskCardTitle ?? '', // Set title from task card title. // Setzt Titel aus Aufgabenkartentitel.
          description: "", // Empty description. // Leere Beschreibung.
          isEditable: false, // Not editable by default. // Standardmäßig nicht bearbeitbar.
        );
        ref.read(taskListProvider.notifier).addTask(todo); // Add todo to task list. // Fügt Todo zur Aufgabenliste hinzu.
        
        await updateCardTodoTask( // Update card todo task again. // Aktualisiert Karten-Todo-Aufgabe erneut.
          newUser.toDoHappySadToggle, // Pass happy/sad toggle setting. // Übergibt Happy/Sad-Umschaltereinstellung.
          false, // Force task deletion setting to false. // Erzwingt Aufgabenlöschungseinstellung auf falsch.
          newUser.taskCardTitle, // Pass task card title. // Übergibt Aufgabenkartentitel.
        );
      }

      if (newUser.taskCardTitle?.isNotEmpty == true) { // If task card title is not empty. // Wenn Aufgabenkartentitel nicht leer ist.
        ref.read(taskCardTitleProvider.notifier).updateTitle(newUser.taskCardTitle!); // Update task card title in state. // Aktualisiert Aufgabenkartentitel im Zustand.
        _localStorageRepository.setTaskCardTitle(newUser.taskCardTitle!); // Save task card title to local storage. // Speichert Aufgabenkartentitel im lokalen Speicher.
      }


    if (newUser.projectName.isEmpty) { // If project names list is empty. // Wenn Projektnamen-Liste leer ist.
      const defaultProjects = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']; // Define default project names. // Definiert Standard-Projektnamen.
      ref.read(projectStateNotifierProvider.notifier).state = defaultProjects; // Set default projects in state. // Setzt Standard-Projekte im Zustand.
      _localStorageRepository.saveProjectNames(defaultProjects); // Save default projects to local storage. // Speichert Standard-Projekte im lokalen Speicher.
      _localStorageRepository.setSelectedContainerIndex(0); // Set selected container index to 0. // Setzt ausgewählten Container-Index auf 0.
    }

            break;
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }





  Future<ErrorModel> getUserData() async { // Method to get user data from server. // Methode zum Abrufen von Benutzerdaten vom Server.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.get(Uri.parse('$host/auth'), headers: { // Make API request to get user data. // Führt API-Anfrage zum Abrufen von Benutzerdaten durch.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        });
        switch (res.statusCode) { // Check response status code. // Prüft Antwort-Statuscode.
          case 200: // If successful response. // Bei erfolgreicher Antwort.
            var newUser = UserModel.fromJson( // Create user model from response JSON. // Erstellt Benutzermodell aus Antwort-JSON.
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token); // Add token to user model. // Fügt Token zum Benutzermodell hinzu.


            error = ErrorModel(error: null, data: newUser); // Update error model with user data. // Aktualisiert Fehlermodell mit Benutzerdaten.
            _localStorageRepository.setToken(newUser.token); // Save token to local storage. // Speichert Token im lokalen Speicher.
          
            final confirmStatusResult =
                await fetchSubscriptionStatusConfirmed(); // Fetch subscription confirmation status. // Holt Abonnement-Bestätigungsstatus.
            if (confirmStatusResult.error == null) { // If status was fetched successfully. // Wenn Status erfolgreich abgerufen wurde.
              newUser = newUser.copyWith(
                subscriptionStatusConfirmed: confirmStatusResult.data as bool, // Update confirmation status in user model. // Aktualisiert Bestätigungsstatus im Benutzermodell.
              );
            }
            final cancelledStatusResult =
                await fetchSubscriptionStatusCancelled(); // Fetch subscription cancellation status. // Holt Abonnement-Kündigungsstatus.
            if (cancelledStatusResult.error == null) { // If status was fetched successfully. // Wenn Status erfolgreich abgerufen wurde.
              newUser = newUser.copyWith(
                suscriptionStatusCancelled: cancelledStatusResult.data as bool, // Update cancellation status in user model. // Aktualisiert Kündigungsstatus im Benutzermodell.
              );
            }
            var nextBillingResult = await fetchNextBillingDate(); // Fetch next billing date. // Holt nächstes Abrechnungsdatum.
            if (nextBillingResult.error == null) { // If date was fetched successfully. // Wenn Datum erfolgreich abgerufen wurde.
              newUser = newUser.copyWith(
                  nextBillingTime:
                      DateTime.parse(nextBillingResult.data).toUtc()); // Update next billing time in user model. // Aktualisiert nächste Abrechnungszeit im Benutzermodell.
            }

            var startTimeSubscriptionPaypalResult =
                await fetchstartTimeSubscriptionPayPal(); // Fetch PayPal subscription start time. // Holt PayPal-Abonnement-Startzeit.
            if (startTimeSubscriptionPaypalResult.error == null) { // If time was fetched successfully. // Wenn Zeit erfolgreich abgerufen wurde.
              newUser = newUser.copyWith(
                  startTimeSubscriptionPayPal:
                      DateTime.parse(startTimeSubscriptionPaypalResult.data)
                          .toUtc()); // Update PayPal start time in user model. // Aktualisiert PayPal-Startzeit im Benutzermodell.
            }
            var paypalSubscriptionCancelledAtResult =
                await fetchpaypalSubscriptionCancelledAt(); // Fetch PayPal cancellation time. // Holt PayPal-Kündigungszeit.
            if (paypalSubscriptionCancelledAtResult.error == null) { // If time was fetched successfully. // Wenn Zeit erfolgreich abgerufen wurde.
              newUser = newUser.copyWith(
                  paypalSubscriptionCancelledAt:
                      DateTime.parse(paypalSubscriptionCancelledAtResult.data)
                          .toUtc()); // Update PayPal cancellation time in user model. // Aktualisiert PayPal-Kündigungszeit im Benutzermodell.
            }
            error = ErrorModel(error: null, data: newUser); // Update error model with user data. // Aktualisiert Fehlermodell mit Benutzerdaten.
            _localStorageRepository.setToken(newUser.token); // Save token to local storage. // Speichert Token im lokalen Speicher.
            _localStorageRepository.setIssuscriptionStatusCancelled(
                newUser.suscriptionStatusCancelled); // Save cancellation status to local storage. // Speichert Kündigungsstatus im lokalen Speicher.
            _localStorageRepository.setIsubscriptionStatusConfirmed(
                newUser.subscriptionStatusConfirmed); // Save confirmation status to local storage. // Speichert Bestätigungsstatus im lokalen Speicher.

      
            break;
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> updateUserSettings( // Method to update user settings. // Methode zur Aktualisierung der Benutzereinstellungen.
    int pomodoroTimer, // Pomodoro timer duration. // Pomodoro-Timer-Dauer.
    int shortBreakTimer, // Short break timer duration. // Kurzpausentimer-Dauer.
    int longBreakTimer, // Long break timer duration. // Langpausentimer-Dauer.
    int longBreakInterval, // Long break interval. // Langpausenintervall.
    Sound selectedSound, // Selected sound for notifications. // Ausgewählter Sound für Benachrichtigungen.
    bool browserNotificationsEnabled, // Browser notifications enabled status. // Status für aktivierte Browser-Benachrichtigungen.
    Color pomodoroColor, // Color for pomodoro timer. // Farbe für Pomodoro-Timer.
    Color shortBreakColor, // Color for short break timer. // Farbe für Kurzpausentimer.
    Color longBreakColor, // Color for long break timer. // Farbe für Langpausentimer.
  ) async {
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.post( // Make API request to update settings. // Führt API-Anfrage zur Aktualisierung der Einstellungen durch.
          Uri.parse('$host/auth/update-settings'), // API endpoint for updating settings. // API-Endpunkt für die Aktualisierung der Einstellungen.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
          body: jsonEncode({ // Request body with settings. // Anfrage-Body mit Einstellungen.
            'pomodoroTimer': pomodoroTimer, // Pomodoro timer duration. // Pomodoro-Timer-Dauer.
            'shortBreakTimer': shortBreakTimer, // Short break timer duration. // Kurzpausentimer-Dauer.
            'longBreakTimer': longBreakTimer, // Long break timer duration. // Langpausentimer-Dauer.
            'longBreakInterval': longBreakInterval, // Long break interval. // Langpausenintervall.
            'selectedSound': selectedSound.path, // Selected sound path. // Pfad des ausgewählten Sounds.
            'browserNotificationsEnabled': browserNotificationsEnabled, // Browser notifications enabled status. // Status für aktivierte Browser-Benachrichtigungen.
            'pomodoroColor':
                '#${pomodoroColor.value.toRadixString(16).padLeft(8, '0')}', // Pomodoro color as hex string. // Pomodoro-Farbe als Hex-String.
            'shortBreakColor':
                '#${shortBreakColor.value.toRadixString(16).padLeft(8, '0')}', // Short break color as hex string. // Kurzpausenfarbe als Hex-String.
            'longBreakColor':
                '#${longBreakColor.value.toRadixString(16).padLeft(8, '0')}', // Long break color as hex string. // Langpausenfarbe als Hex-String.
          }),
        );
        switch (res.statusCode) { // Check response status code. // Prüft Antwort-Statuscode.
          case 200: // If successful response. // Bei erfolgreicher Antwort.
            error = ErrorModel(error: null, data: res.body); // Update error model with response data. // Aktualisiert Fehlermodell mit Antwortdaten.

            break;
          default: // For other status codes. // Für andere Statuscodes.
            error = ErrorModel(error: res.body, data: null); // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
            break;
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }



  Future<ErrorModel> updatePomodoroStates(List<bool> pomodoroStates) async { // Method to update pomodoro states. // Methode zur Aktualisierung der Pomodoro-Zustände.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.post( // Make API request to update pomodoro states. // Führt API-Anfrage zur Aktualisierung der Pomodoro-Zustände durch.
          Uri.parse('$host/auth/update-pomodoro-states'), // API endpoint for updating pomodoro states. // API-Endpunkt für die Aktualisierung der Pomodoro-Zustände.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
          body: jsonEncode({ // Request body with pomodoro states. // Anfrage-Body mit Pomodoro-Zuständen.
            'pomodoroStates': pomodoroStates, // List of pomodoro state booleans. // Liste von Pomodoro-Zustandsbooleanen.
          }),
        );
        switch (res.statusCode) { // Check response status code. // Prüft Antwort-Statuscode.
          case 200: // If successful response. // Bei erfolgreicher Antwort.
            error = ErrorModel(
                error: null, data: jsonDecode(res.body)['pomodoroStates']); // Update error model with pomodoro states from response. // Aktualisiert Fehlermodell mit Pomodoro-Zuständen aus der Antwort.
            break;
          default: // For other status codes. // Für andere Statuscodes.
            error = ErrorModel(error: res.body, data: null); // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
            break;
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> updateCardTodoTask( // Method to update card todo task settings. // Methode zur Aktualisierung der Karten-Todo-Aufgabeneinstellungen.
    bool toDoHappySadToggle, // Happy/sad toggle setting. // Happy/Sad-Umschaltereinstellung.
    bool taskDeletionByTrashIcon, // Task deletion by trash icon setting. // Einstellung für Aufgabenlöschung durch Papierkorb-Symbol.
    String taskCardTitle, // Task card title. // Aufgabenkartentitel.
  ) async {
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.post( // Make API request to update card todo task. // Führt API-Anfrage zur Aktualisierung der Karten-Todo-Aufgabe durch.
          Uri.parse('$host/auth/card-add-todo-task'), // API endpoint for updating card todo task. // API-Endpunkt für die Aktualisierung der Karten-Todo-Aufgabe.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
          body: jsonEncode({ // Request body with card todo task settings. // Anfrage-Body mit Karten-Todo-Aufgabeneinstellungen.
            'toDoHappySadToggle': toDoHappySadToggle, // Happy/sad toggle setting. // Happy/Sad-Umschaltereinstellung.
            'taskDeletionByTrashIcon': taskDeletionByTrashIcon, // Task deletion by trash icon setting. // Einstellung für Aufgabenlöschung durch Papierkorb-Symbol.
            'taskCardTitle': taskCardTitle, // Task card title. // Aufgabenkartentitel.
          }),
        );
        switch (res.statusCode) { // Check response status code. // Prüft Antwort-Statuscode.
          case 200: // If successful response. // Bei erfolgreicher Antwort.
            error = ErrorModel(
                error: null, 
                   data: { // Update error model with card todo task settings from response. // Aktualisiert Fehlermodell mit Karten-Todo-Aufgabeneinstellungen aus der Antwort.
                'toDoHappySadToggle': jsonDecode(res.body)['toDoHappySadToggle'], // Happy/sad toggle setting from response. // Happy/Sad-Umschaltereinstellung aus der Antwort.
                'taskDeletionByTrashIcon': jsonDecode(res.body)['taskDeletionByTrashIcon'], // Task deletion setting from response. // Aufgabenlöschungseinstellung aus der Antwort.
                'taskCardTitle': jsonDecode(res.body)['taskCardTitle'], // Task card title from response. // Aufgabenkartentitel aus der Antwort.
              });
              break; // Break from switch case. // Bricht Switch-Case ab.
          default: // For other status codes. // Für andere Statuscodes.
            error = ErrorModel(error: res.body, data: null); // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
            break;
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> updateProjectName(String projectName, int index) async { // Method to update project name. // Methode zur Aktualisierung des Projektnamens.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.post( // Make API request to update project name. // Führt API-Anfrage zur Aktualisierung des Projektnamens durch.
          Uri.parse('$host/auth/update-project'), // API endpoint for updating project. // API-Endpunkt für die Aktualisierung des Projekts.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
          body: jsonEncode({ // Request body with project details. // Anfrage-Body mit Projektdetails.
            'projectName': projectName, // Project name to update. // Zu aktualisierender Projektname.
            'index': index, // Index of the project to update. // Index des zu aktualisierenden Projekts.
          }),
        );
        
        if (res.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
          error = ErrorModel(error: null, data: jsonDecode(res.body)['projectName']); // Update error model with project name from response. // Aktualisiert Fehlermodell mit Projektnamen aus der Antwort.
        }
      
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel(error: e.toString(), data: null); // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }


Future<ErrorModel> updateUserContainerIndex(
    int selectedContainerIndex, // Container index to set as selected. // Container-Index, der als ausgewählt festgelegt werden soll.
  ) async { // Method to update user's selected container index. // Methode zur Aktualisierung des ausgewählten Container-Index des Benutzers.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.post( // Make API request to update container index. // Führt API-Anfrage zur Aktualisierung des Container-Index durch.
          Uri.parse('$host/auth/update-container-index'), // API endpoint for updating container index. // API-Endpunkt für die Aktualisierung des Container-Index.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
          body: jsonEncode({ // Request body with container index. // Anfrage-Body mit Container-Index.
            'selectedContainerIndex':
                selectedContainerIndex, // Container index to update. // Zu aktualisierender Container-Index.
            
          }),
        );
        switch (res.statusCode) { // Check response status code. // Prüft Antwort-Statuscode.
          case 200: // If successful response. // Bei erfolgreicher Antwort.
            error = ErrorModel(error: null, data: res.body); // Update error model with response body. // Aktualisiert Fehlermodell mit Antworttext.

            break;
          default: // For other status codes. // Für andere Statuscodes.
            error = ErrorModel(error: res.body, data: null); // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
            break;
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

Future<ErrorModel> deleteProject(int projectIndex) async { // Method to delete a project at specified index. // Methode zum Löschen eines Projekts am angegebenen Index.
  ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
    error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
    data: null, // No data initially. // Anfänglich keine Daten.
  );
  
  try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
    String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
    
    if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
      var res = await _client.post( // Make API request to delete project. // Führt API-Anfrage zum Löschen des Projekts durch.
        Uri.parse('$host/auth/delete-project'), // API endpoint for deleting project. // API-Endpunkt für das Löschen des Projekts.
        headers: { // Request headers. // Anfrage-Header.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        },
        body: jsonEncode({ // Request body with project index. // Anfrage-Body mit Projektindex.
          'projectIndex': projectIndex, // Index of project to delete. // Index des zu löschenden Projekts.
        }),
      );
      
      if (res.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
        await _localStorageRepository.clearProjectTimeframes(projectIndex); // Clear timeframes for deleted project. // Löscht Zeitrahmen für das gelöschte Projekt.
        error = ErrorModel(error: null, data: jsonDecode(res.body)); // Update error model with decoded response. // Aktualisiert Fehlermodell mit dekodierter Antwort.
      } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
        error = ErrorModel(error: res.body, data: null); // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
      }
    }
  } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
    error = ErrorModel(error: e.toString(), data: null); // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
  }
  return error; // Return error model. // Gibt Fehlermodell zurück.
}

  void signOut(WidgetRef ref) async { // Method to sign out user and reset app state. // Methode zum Abmelden des Benutzers und Zurücksetzen des App-Zustands.
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res =
            await _client.post(Uri.parse('$host/auth/api/logout'), headers: { // Make API request to logout. // Führt API-Anfrage zur Abmeldung durch.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        });

        if (res.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
          await _googleSignIn.signOut(); // Sign out from Google. // Meldet von Google ab.
          _localStorageRepository.setToken(''); // Clear token in local storage. // Löscht Token im lokalen Speicher.

          ref.read(pomodoroTimerProvider.notifier).state = 25; // Reset pomodoro timer to default (25 minutes). // Setzt Pomodoro-Timer auf Standard zurück (25 Minuten).
          ref.read(shortBreakProvider.notifier).state = 5; // Reset short break timer to default (5 minutes). // Setzt Kurzpausentimer auf Standard zurück (5 Minuten).
          ref.read(longBreakProvider.notifier).state = 15; // Reset long break timer to default (15 minutes). // Setzt Langpausentimer auf Standard zurück (15 Minuten).
          ref.read(longBreakIntervalProvider.notifier).state = 4; // Reset long break interval to default (4 pomodoros). // Setzt Langpausenintervall auf Standard zurück (4 Pomodoros).
          ref.read(selectedSoundProvider.notifier).updateSound(ref
              .read(soundListProvider)
              .firstWhere(
                  (sound) => sound.path == 'assets/sounds/Flashpoint.wav')); // Reset selected sound to default. // Setzt ausgewählten Sound auf Standard zurück.

          ref.read(browserNotificationsProvider.notifier).set(false); // Disable browser notifications. // Deaktiviert Browser-Benachrichtigungen.

          ref.read(darkPomodoroColorProvider.notifier).state =
              const Color(0xFF74F143); // Reset pomodoro color to default green. // Setzt Pomodoro-Farbe auf Standard-Grün zurück.
          ref.read(darkShortBreakColorProvider.notifier).state =
              const Color(0xFFFF9933); // Reset short break color to default orange. // Setzt Kurzpausenfarbe auf Standard-Orange zurück.
          ref.read(darkLongBreakColorProvider.notifier).state =
              const Color(0xFF0891FF); // Reset long break color to default blue. // Setzt Langpausenfarbe auf Standard-Blau zurück.
          _localStorageRepository.setPomodoroStates([]); // Clear pomodoro states in local storage. // Löscht Pomodoro-Zustände im lokalen Speicher.
          ref.read(pomodoroNotifierProvider.notifier).resetPomodoros(); // Reset pomodoro states in app state. // Setzt Pomodoro-Zustände im App-Zustand zurück.

          ref.read(toDoHappySadToggleProvider.notifier).set(false); // Disable happy/sad toggle. // Deaktiviert Happy/Sad-Umschalter.


          ref.read(taskDeletionsProvider.notifier).set(false); // Disable task deletion by trash icon. // Deaktiviert Aufgabenlöschung durch Papierkorb-Symbol.
      
          ref.read(taskCardTitleProvider.notifier).reset(); // Reset task card title. // Setzt Aufgabenkartentitel zurück.
          _localStorageRepository.setTaskCardTitle(''); // Clear task card title in local storage. // Löscht Aufgabenkartentitel im lokalen Speicher.           

          ref.read(taskListProvider.notifier).clearTasks(); // Clear all tasks. // Löscht alle Aufgaben.
          ref.read(projectStateNotifierProvider.notifier).state = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']; // Reset project names to defaults. // Setzt Projektnamen auf Standardwerte zurück.
          ref.read(persistentContainerIndexProvider.notifier); // Access persistent container index provider. // Greift auf persistenten Container-Index-Provider zu.
       
          List<String> defaultProjectList = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']; // Define default project list. // Definiert Standard-Projektliste.

          ref.read(projectStateNotifierProvider.notifier).state = defaultProjectList; // Set default project list in state. // Setzt Standard-Projektliste im Zustand.
          ref.read(persistentContainerIndexProvider.notifier).state = 0; // Reset selected container index to 0. // Setzt ausgewählten Container-Index auf 0 zurück.
          _localStorageRepository.saveProjectNames(defaultProjectList); // Save default project names to local storage. // Speichert Standard-Projektnamen im lokalen Speicher.


          _localStorageRepository.setWeeklyTimeframes([]); // Clear weekly timeframes in local storage. // Löscht wöchentliche Zeitrahmen im lokalen Speicher.
          _localStorageRepository.setMonthlyTimeframes([]); // Clear monthly timeframes in local storage. // Löscht monatliche Zeitrahmen im lokalen Speicher.
          _localStorageRepository.setYearlyTimeframes([]); // Clear yearly timeframes in local storage. // Löscht jährliche Zeitrahmen im lokalen Speicher.

          ref.read(projectTimesProvider.notifier).resetState(); // Reset project times state. // Setzt Projektzeiten-Zustand zurück.
    
        }
      }
    } catch (error) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      print("the error from signOut is $error"); // Print error message for debugging. // Gibt Fehlermeldung zur Fehlersuche aus.
    }
  }
 
Future<ErrorModel> addTimeframeData({ // Method to add timeframe data for project time tracking. // Methode zum Hinzufügen von Zeitrahmendaten für die Projektzeiterfassung.
    required int projectIndex, // Index of the project to add time for. // Index des Projekts, für das Zeit hinzugefügt werden soll.
    required DateTime date, // Date of the timeframe entry. // Datum des Zeitrahmeneintrags.
    required int duration, // Duration in seconds. // Dauer in Sekunden.
    required String timeframeType, // Type of timeframe (weekly, monthly, yearly). // Art des Zeitrahmens (wöchentlich, monatlich, jährlich).
  }) async {
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.post( // Make API request to add timeframe data. // Führt API-Anfrage zum Hinzufügen von Zeitrahmendaten durch.
          Uri.parse('$host/auth/api/timeframe/add'), // API endpoint for adding timeframe. // API-Endpunkt zum Hinzufügen eines Zeitrahmens.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
          body: jsonEncode({ // Request body with timeframe data. // Anfrage-Body mit Zeitrahmendaten.
            'projectIndex': projectIndex, // Project index to track time for. // Projektindex für die Zeiterfassung.
            'date': date.toIso8601String(), // Convert date to ISO string format. // Konvertiert Datum in ISO-String-Format.
            'duration': duration, // Duration in seconds. // Dauer in Sekunden.
            'timeframeType': timeframeType, // Type of timeframe. // Art des Zeitrahmens.
          }),
        );
        
        if (res.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
          error = ErrorModel(error: null, data: jsonDecode(res.body)); // Update error model with decoded response. // Aktualisiert Fehlermodell mit dekodierter Antwort.
        } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null); // Update error model with error message from response. // Aktualisiert Fehlermodell mit Fehlermeldung aus der Antwort.
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel(error: e.toString(), data: null); // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> getTimeframeData(String timeframeType) async { // Method to retrieve timeframe data by type. // Methode zum Abrufen von Zeitrahmendaten nach Typ.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.', // Default error message. // Standard-Fehlermeldung.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.

      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.get( // Make API request to get timeframe data. // Führt API-Anfrage zum Abrufen von Zeitrahmendaten durch.
          Uri.parse('$host/auth/api/timeframe/$timeframeType'), // API endpoint with timeframe type. // API-Endpunkt mit Zeitrahmentyp.
          headers: { // Request headers. // Anfrage-Header.
            'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
            'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
          },
        );
        
        if (res.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
          error = ErrorModel(error: null, data: jsonDecode(res.body)); // Update error model with decoded response. // Aktualisiert Fehlermodell mit dekodierter Antwort.
        } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null); // Update error model with error message from response. // Aktualisiert Fehlermodell mit Fehlermeldung aus der Antwort.
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel(error: e.toString(), data: null); // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }



  Future<ErrorModel> deletePremiumOrNotPremiumUser(WidgetRef ref) async { // Method to delete user account regardless of premium status. // Methode zum Löschen des Benutzerkontos unabhängig vom Premium-Status.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'Some unexpected error occurred.deletePremiumOrNotPremiumUser', // Default error message with context. // Standard-Fehlermeldung mit Kontext.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token != null) { // Check if token exists. // Prüft, ob Token existiert.
        var res = await _client.delete( // Make API request to delete user account. // Führt API-Anfrage zum Löschen des Benutzerkontos durch.
            Uri.parse('$host/auth/api/delete-premium-or-not-premium-user'), // API endpoint for deleting user. // API-Endpunkt zum Löschen des Benutzers.
            headers: { // Request headers. // Anfrage-Header.
              'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
              'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
            });
        if (res.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
          error = ErrorModel(error: null, data: "Account deleted successfully"); // Update error model with success message. // Aktualisiert Fehlermodell mit Erfolgsmeldung.
          ref.read(pomodoroTimerProvider.notifier).state = 25; // Reset pomodoro timer to default (25 minutes). // Setzt Pomodoro-Timer auf Standard zurück (25 Minuten).
          ref.read(shortBreakProvider.notifier).state = 5; // Reset short break timer to default (5 minutes). // Setzt Kurzpausentimer auf Standard zurück (5 Minuten).
          ref.read(longBreakProvider.notifier).state = 15; // Reset long break timer to default (15 minutes). // Setzt Langpausentimer auf Standard zurück (15 Minuten).
          ref.read(longBreakIntervalProvider.notifier).state = 4; // Reset long break interval to default (4 pomodoros). // Setzt Langpausenintervall auf Standard zurück (4 Pomodoros).
          ref.read(selectedSoundProvider.notifier).updateSound(ref
              .read(soundListProvider)
              .firstWhere(
                  (sound) => sound.path == 'assets/sounds/Flashpoint.wav')); // Reset selected sound to default. // Setzt ausgewählten Sound auf Standard zurück.

          ref.read(browserNotificationsProvider.notifier).set(false); // Disable browser notifications. // Deaktiviert Browser-Benachrichtigungen.

          ref.read(darkPomodoroColorProvider.notifier).state =
              const Color(0xFF74F143); // Reset pomodoro color to default green. // Setzt Pomodoro-Farbe auf Standard-Grün zurück.
          ref.read(darkShortBreakColorProvider.notifier).state =
              const Color(0xFFFF9933); // Reset short break color to default orange. // Setzt Kurzpausenfarbe auf Standard-Orange zurück.
          ref.read(darkLongBreakColorProvider.notifier).state =
              const Color(0xFF0891FF); // Reset long break color to default blue. // Setzt Langpausenfarbe auf Standard-Blau zurück.
          _localStorageRepository.setPomodoroStates([]); // Clear pomodoro states in local storage. // Löscht Pomodoro-Zustände im lokalen Speicher.
          ref.read(pomodoroNotifierProvider.notifier).resetPomodoros(); // Reset pomodoro states in app state. // Setzt Pomodoro-Zustände im App-Zustand zurück.
          ref.read(toDoHappySadToggleProvider.notifier).set(false); // Disable happy/sad toggle. // Deaktiviert Happy/Sad-Umschalter.

          ref.read(taskDeletionsProvider.notifier).set(false); // Disable task deletion by trash icon. // Deaktiviert Aufgabenlöschung durch Papierkorb-Symbol.
          ref.read(taskCardTitleProvider.notifier).updateTitle(''); // Clear task card title in state. // Löscht Aufgabenkartentitel im Zustand.

          ref.read(taskCardTitleProvider.notifier).reset(); // Reset task card title provider. // Setzt Aufgabenkartentitel-Provider zurück.
          _localStorageRepository.setTaskCardTitle(''); // Clear task card title in local storage. // Löscht Aufgabenkartentitel im lokalen Speicher.
          
          ref.read(projectStateNotifierProvider.notifier).state = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']; // Reset project names to defaults. // Setzt Projektnamen auf Standardwerte zurück.

          ref.read(persistentContainerIndexProvider.notifier); // Access persistent container index provider. // Greift auf persistenten Container-Index-Provider zu.
          
          ref.read(taskListProvider.notifier).clearTasks(); // Clear all tasks. // Löscht alle Aufgaben.

          List<String> defaultProjectList = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']; // Define default project list. // Definiert Standard-Projektliste.

          ref.read(projectStateNotifierProvider.notifier).state = defaultProjectList; // Set default project list in state. // Setzt Standard-Projektliste im Zustand.
          ref.read(persistentContainerIndexProvider.notifier).state = 0; // Reset selected container index to 0. // Setzt ausgewählten Container-Index auf 0 zurück.
          _localStorageRepository.saveProjectNames(defaultProjectList); // Save default project names to local storage. // Speichert Standard-Projektnamen im lokalen Speicher.

          _localStorageRepository.setWeeklyTimeframes([]); // Clear weekly timeframes in local storage. // Löscht wöchentliche Zeitrahmen im lokalen Speicher.
          _localStorageRepository.setMonthlyTimeframes([]); // Clear monthly timeframes in local storage. // Löscht monatliche Zeitrahmen im lokalen Speicher.
          _localStorageRepository.setYearlyTimeframes([]); // Clear yearly timeframes in local storage. // Löscht jährliche Zeitrahmen im lokalen Speicher.

          ref.read(projectTimesProvider.notifier).resetState(); // Reset project times state. // Setzt Projektzeiten-Zustand zurück.

       
          signOut(ref); // Call signOut method to complete logout process. // Ruft signOut-Methode auf, um Abmeldeprozess abzuschließen.
        } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
          error = ErrorModel(
              error:
                  "deletePremiumOrNotPremiumUser Failed to delete account $error deletePremiumOrNotPremiumUser", // Error message with context. // Fehlermeldung mit Kontext.
              data: null); // No data on error. // Keine Daten bei Fehler.
        }
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
      print("the error is $error"); // Print error for debugging. // Gibt Fehler zur Fehlersuche aus.
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }


  Future<ErrorModel> fetchNextBillingDate() async { // Method to fetch the next billing date for subscription. // Methode zum Abrufen des nächsten Abrechnungsdatums für das Abonnement.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'An unexpected error occurred. deletePremiumOrNotPremiumUser', // Default error message with context. // Standard-Fehlermeldung mit Kontext.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token == null) { // Check if token is null. // Prüft, ob Token null ist.
        throw Exception(
            "Authentication token not found (deletePremiumOrNotPremiumUser)"); // Throw exception for missing token. // Wirft Ausnahme für fehlendes Token.
      }

      final response = await _client.post( // Make API request to get next billing date. // Führt API-Anfrage zum Abrufen des nächsten Abrechnungsdatums durch.
        Uri.parse('$host/paypal/next-billing'), // API endpoint for next billing date. // API-Endpunkt für nächstes Abrechnungsdatum.
        headers: { // Request headers. // Anfrage-Header.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        },
        body: jsonEncode({'token': token}), // Request body with token. // Anfrage-Body mit Token.
      );

      if (response.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.

        final data = jsonDecode(response.body); // Decode response body. // Dekodiert Antworttext.
        final nextBillingTime = DateTime.parse(data['nextBillingTime']).toUtc(); // Parse next billing time to DateTime. // Analysiert nächste Abrechnungszeit zu DateTime.
        return ErrorModel(error: null, data: nextBillingTime); // Return error model with next billing time. // Gibt Fehlermodell mit nächster Abrechnungszeit zurück.
      } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
        error = ErrorModel( // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
          error: "Failed to load next billing date", // Error message. // Fehlermeldung.
          data: null, // No data on error. // Keine Daten bei Fehler.
        );
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> fetchstartTimeSubscriptionPayPal() async { // Method to fetch PayPal subscription start time. // Methode zum Abrufen der PayPal-Abonnement-Startzeit.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'An unexpected error occurred. fetchNextBillingDate', // Default error message with context. // Standard-Fehlermeldung mit Kontext.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token == null) { // Check if token is null. // Prüft, ob Token null ist.
        throw Exception(
            "Authentication token not found (fetchNextBillingDate)"); // Throw exception for missing token. // Wirft Ausnahme für fehlendes Token.
      }

      final response = await _client.post( // Make API request to get subscription start time. // Führt API-Anfrage zum Abrufen der Abonnement-Startzeit durch.
        Uri.parse('$host/paypal/start-time-subscription'), // API endpoint for subscription start time. // API-Endpunkt für Abonnement-Startzeit.
        headers: { // Request headers. // Anfrage-Header.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        },
        body: jsonEncode({'token': token}), // Request body with token. // Anfrage-Body mit Token.
      );

      if (response.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.

        final data = jsonDecode(response.body); // Decode response body. // Dekodiert Antworttext.
        final startTimeSubscriptionPayPal =
            DateTime.parse(data['startTimeSubscriptionPayPal']).toUtc(); // Parse start time to DateTime. // Analysiert Startzeit zu DateTime.
        return ErrorModel(error: null, data: startTimeSubscriptionPayPal); // Return error model with start time. // Gibt Fehlermodell mit Startzeit zurück.

      } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
        error = ErrorModel( // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
          error: "Failed to load next billing date", // Error message. // Fehlermeldung.
          data: null, // No data on error. // Keine Daten bei Fehler.
        );
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> cancelSubscription() async { // Method to cancel user subscription. // Methode zum Kündigen des Benutzerabonnements.
    final token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
    if (token == null) { // Check if token is null. // Prüft, ob Token null ist.
      return ErrorModel(
          error: 'Token not found, user not authenticated.', data: null); // Return error for missing token. // Gibt Fehler für fehlendes Token zurück.
    }

    final response = await _client.delete( // Make API request to cancel subscription. // Führt API-Anfrage zur Kündigung des Abonnements durch.
      Uri.parse('$host/paypal/cancel-subscription'), // API endpoint for cancelling subscription. // API-Endpunkt für die Kündigung des Abonnements.
      headers: { // Request headers. // Anfrage-Header.
        'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
        'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
      },
    );

    if (response.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
      final data = jsonDecode(response.body); // Decode response body. // Dekodiert Antworttext.

      return ErrorModel(error: null, data: data); // Return error model with response data. // Gibt Fehlermodell mit Antwortdaten zurück.
    } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
      return ErrorModel(error: 'Failed to cancel subscription.', data: null); // Return error model with error message. // Gibt Fehlermodell mit Fehlermeldung zurück.
    }
  }

  Future<ErrorModel> fetchSubscriptionStatusConfirmed() async { // Method to check if subscription is confirmed. // Methode zur Überprüfung, ob das Abonnement bestätigt ist.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'An unexpected error occurred. fetchSubscriptionStatusConfirmed', // Default error message with context. // Standard-Fehlermeldung mit Kontext.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token == null) { // Check if token is null. // Prüft, ob Token null ist.
        throw Exception(
            "Authentication token not found (fetchSubscriptionStatusConfirmed)"); // Throw exception for missing token. // Wirft Ausnahme für fehlendes Token.
      }

      final response = await _client.post( // Make API request to check subscription status. // Führt API-Anfrage zur Überprüfung des Abonnementstatus durch.
        Uri.parse('$host/paypal/update-subscription-status-confirmed'), // API endpoint for confirming subscription status. // API-Endpunkt für die Bestätigung des Abonnementstatus.
        headers: { // Request headers. // Anfrage-Header.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        },
        body: jsonEncode({'token': token}), // Request body with token. // Anfrage-Body mit Token.
      );

      if (response.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.

        const subscriptionStatusConfirmed = true; // Set confirmed status to true. // Setzt Bestätigungsstatus auf true.
        return ErrorModel(error: null, data: subscriptionStatusConfirmed); // Return error model with status. // Gibt Fehlermodell mit Status zurück.
      } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
        error = ErrorModel( // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
          error: "Failed to load next billing date", // Error message. // Fehlermeldung.
          data: null, // No data on error. // Keine Daten bei Fehler.
        );
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> fetchSubscriptionStatusCancelled() async { // Method to check if subscription is cancelled. // Methode zur Überprüfung, ob das Abonnement gekündigt wurde.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'An unexpected error occurred. fetchSubscriptionStatusCancelled', // Default error message with context. // Standard-Fehlermeldung mit Kontext.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token == null) { // Check if token is null. // Prüft, ob Token null ist.
        throw Exception(
            "Authentication token not found (fetchSubscriptionStatusCancelled)"); // Throw exception for missing token. // Wirft Ausnahme für fehlendes Token.
      }

      final response = await _client.post( // Make API request to check cancellation status. // Führt API-Anfrage zur Überprüfung des Kündigungsstatus durch.
        Uri.parse('$host/paypal/update-subscription-status-cancelled'), // API endpoint for checking cancellation status. // API-Endpunkt für die Überprüfung des Kündigungsstatus.
        headers: { // Request headers. // Anfrage-Header.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        },
        body: jsonEncode({'token': token}), // Request body with token. // Anfrage-Body mit Token.
      );

      if (response.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.
        const suscriptionStatusCancelled = true; // Set cancelled status to true. // Setzt Kündigungsstatus auf true.
        return ErrorModel(error: null, data: suscriptionStatusCancelled); // Return error model with status. // Gibt Fehlermodell mit Status zurück.

      } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
        error = ErrorModel( // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
          error: "Failed to load next billing date", // Error message. // Fehlermeldung.
          data: null, // No data on error. // Keine Daten bei Fehler.
        );
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }

  Future<ErrorModel> fetchpaypalSubscriptionCancelledAt() async { // Method to fetch when PayPal subscription was cancelled. // Methode zum Abrufen, wann das PayPal-Abonnement gekündigt wurde.
    ErrorModel error = ErrorModel( // Initialize error model with default error message. // Initialisiert Fehlermodell mit Standard-Fehlermeldung.
      error: 'An unexpected error occurred. fetchpaypalSubscriptionCancelledAt', // Default error message with context. // Standard-Fehlermeldung mit Kontext.
      data: null, // No data initially. // Anfänglich keine Daten.
    );
    try { // Try block for catching exceptions. // Try-Block zum Abfangen von Ausnahmen.
      String? token = await _localStorageRepository.getToken(); // Get token from local storage. // Holt Token aus lokalem Speicher.
      if (token == null) { // Check if token is null. // Prüft, ob Token null ist.
        throw Exception(
            "Authentication token not found (fetchpaypalSubscriptionCancelledAt)"); // Throw exception for missing token. // Wirft Ausnahme für fehlendes Token.
      }

      final response = await _client.post( // Make API request to get cancellation time. // Führt API-Anfrage zum Abrufen der Kündigungszeit durch.
        Uri.parse('$host/paypal/paypal-subscription-cancelled-at'), // API endpoint for cancellation time. // API-Endpunkt für Kündigungszeit.
        headers: { // Request headers. // Anfrage-Header.
          'Content-Type': 'application/json; charset=UTF-8', // Set content type header. // Setzt Content-Type-Header.
          'x-auth-token': token, // Set authentication token header. // Setzt Authentifizierungstoken-Header.
        },
        body: jsonEncode({'token': token}), // Request body with token. // Anfrage-Body mit Token.
      );

      if (response.statusCode == 200) { // If successful response. // Bei erfolgreicher Antwort.

        final data = jsonDecode(response.body); // Decode response body. // Dekodiert Antworttext.
        final paypalSubscriptionCancelledAt =
            DateTime.parse(data['paypalSubscriptionCancelledAt']).toUtc(); // Parse cancellation time to DateTime. // Analysiert Kündigungszeit zu DateTime.
        return ErrorModel(error: null, data: paypalSubscriptionCancelledAt); // Return error model with cancellation time. // Gibt Fehlermodell mit Kündigungszeit zurück.

      } else { // If unsuccessful response. // Bei nicht erfolgreicher Antwort.
        error = ErrorModel( // Update error model with error message. // Aktualisiert Fehlermodell mit Fehlermeldung.
          error: "Failed to load next billing date", // Error message. // Fehlermeldung.
          data: null, // No data on error. // Keine Daten bei Fehler.
        );
      }
    } catch (e) { // Catch any exceptions. // Fängt alle Ausnahmen ab.
      error = ErrorModel( // Update error model with exception message. // Aktualisiert Fehlermodell mit Ausnahmemeldung.
        error: e.toString(), // Convert exception to string. // Konvertiert Ausnahme in String.
        data: null, // No data on error. // Keine Daten bei Fehler.
      );
    }
    return error; // Return error model. // Gibt Fehlermodell zurück.
  }
}
