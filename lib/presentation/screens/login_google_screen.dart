/// LoginGoogleScreen
/// 
/// A widget that provides Google Sign-In functionality for the application. // Ein Widget, das die Google-Anmelde-Funktionalität für die Anwendung bereitstellt.
/// Handles authentication, user data synchronization, and navigation after successful login. // Verarbeitet Authentifizierung, Benutzerdatensynchronisation und Navigation nach erfolgreicher Anmeldung.
/// 
/// Usage:
/// ```dart
/// LoginGoogleScreen()
/// ```
/// 
/// EN: Displays a customized Google Sign-In button that initiates the authentication process and restores user settings.
/// DE: Zeigt eine angepasste Google-Anmeldeschaltfläche an, die den Authentifizierungsprozess startet und Benutzereinstellungen wiederherstellt.

import 'package:flutter/material.dart'; // Imports Flutter material design widgets. // Importiert Flutter Material-Design-Widgets.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for text styling. // Importiert das Google Fonts-Paket für Textstilisierung.
import 'package:routemaster/routemaster.dart'; // Imports Routemaster for navigation. // Importiert Routemaster für die Navigation.

import '../../common/widgets/domain/entities/todo_entity.dart'; // Imports Todo entity model. // Importiert Todo-Entitätsmodell.
import '../notifiers/providers.dart'; // Imports application providers. // Importiert Anwendungs-Provider.
import '../notifiers/task_notifier.dart'; // Imports task state management. // Importiert Aufgaben-Zustandsverwaltung.
import '../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.
import '../repository/local_storage_repository.dart'; // Imports local storage repository. // Importiert lokales Speicher-Repository.

class LoginGoogleScreen extends ConsumerWidget { // Defines a stateless widget with Riverpod consumer capabilities. // Definiert ein zustandsloses Widget mit Riverpod-Consumer-Fähigkeiten.
  const LoginGoogleScreen({super.key}); // Constructor with optional key parameter. // Konstruktor mit optionalem Key-Parameter.

  void signInWithGoogle(WidgetRef ref, BuildContext context) async { // Method to handle Google Sign-In process. // Methode zur Verarbeitung des Google-Anmeldeprozesses.

    print('Attempting to sign in with Google...'); // Debug log for sign-in attempt. // Debug-Protokoll für Anmeldeversuch.
    try { // Start of try block to catch errors. // Beginn des Try-Blocks, um Fehler abzufangen.
      final sMessenger = ScaffoldMessenger.of(context); // Gets scaffold messenger for showing messages. // Holt Scaffold-Messenger zum Anzeigen von Nachrichten.
      final navigator = Routemaster.of(context); // Gets navigation controller. // Holt Navigationscontroller.
      
      final localStorageRepository = ref.read(localStorageRepositoryProvider); // Gets local storage repository. // Holt lokales Speicher-Repository.
      final savedTaskCardTitle = await localStorageRepository.getTaskCardTitle(); // Retrieves saved task card title. // Ruft gespeicherten Aufgabenkartentitel ab.
      print('Saved taskCardTitle before sign in: $savedTaskCardTitle'); // Debug log for saved title. // Debug-Protokoll für gespeicherten Titel.

      final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle(ref); // Initiates Google Sign-In process. // Startet Google-Anmeldeprozess.
      
      if (errorModel.error == null) { // Checks if sign-in was successful. // Prüft, ob die Anmeldung erfolgreich war.
        final user = errorModel.data; // Gets user data from result. // Holt Benutzerdaten aus dem Ergebnis.
        print('User data after sign in: ${user.toJson()}'); // Debug log for user data. // Debug-Protokoll für Benutzerdaten.
        
        if (user.taskCardTitle.isNotEmpty) { // Checks if user has a task card title. // Prüft, ob Benutzer einen Aufgabenkartentitel hat.
          print('Setting taskCardTitle from user: ${user.taskCardTitle}'); // Debug log for using user's title. // Debug-Protokoll für die Verwendung des Benutzertitels.
          ref.read(taskCardTitleProvider.notifier).updateTitle(user.taskCardTitle); // Updates task card title with user's title. // Aktualisiert Aufgabenkartentitel mit dem Titel des Benutzers.
        } else if (savedTaskCardTitle.isNotEmpty) { // Checks if there's a locally saved title. // Prüft, ob ein lokal gespeicherter Titel vorhanden ist.
          print('Setting saved taskCardTitle: $savedTaskCardTitle'); // Debug log for using saved title. // Debug-Protokoll für die Verwendung des gespeicherten Titels.
          ref.read(taskCardTitleProvider.notifier).updateTitle(savedTaskCardTitle); // Updates with saved title. // Aktualisiert mit gespeichertem Titel.
          await ref.read(authRepositoryProvider).updateCardTodoTask( // Updates task card settings on server. // Aktualisiert Aufgabenkarten-Einstellungen auf dem Server.
            user.toDoHappySadToggle, // Passes user's happy/sad toggle setting. // Übergibt die Happy/Sad-Umschalteinstellung des Benutzers.
            user.taskDeletionByTrashIcon, // Passes user's deletion method setting. // Übergibt die Löschmethoden-Einstellung des Benutzers.
            savedTaskCardTitle, // Passes saved task title. // Übergibt gespeicherten Aufgabentitel.
          );
        }

        ref.read(userProvider.notifier).update((state) => user); // Updates user state with signed-in user. // Aktualisiert Benutzerzustand mit angemeldetem Benutzer.

        if (!user.taskDeletionByTrashIcon) { // Checks if task deletion by trash icon is disabled. // Prüft, ob Aufgabenlöschung durch Papierkorb-Symbol deaktiviert ist.
          final todoTitle = user.taskCardTitle.isNotEmpty 
              ? user.taskCardTitle 
              : savedTaskCardTitle; // Determines which title to use. // Bestimmt, welcher Titel verwendet werden soll.
              
          var todo = Todo( // Creates new todo item. // Erstellt neues Todo-Element.
            title: user.taskCardTitle, // Sets title from user's title. // Setzt Titel aus dem Benutzertitel.
            description: "", // Empty description. // Leere Beschreibung.
            isEditable: false, // Not editable by default. // Standardmäßig nicht bearbeitbar.
          );
          
          print('Creating new todo with title: $todoTitle'); // Debug log for todo creation. // Debug-Protokoll für Todo-Erstellung.
          ref.read(taskListProvider.notifier).addTask(todo); // Adds todo to task list. // Fügt Todo zur Aufgabenliste hinzu.
        }

        ref.read(toDoHappySadToggleProvider.notifier).set(user.toDoHappySadToggle); // Sets happy/sad toggle state. // Setzt Happy/Sad-Umschaltzustand.
        ref.read(taskDeletionsProvider.notifier).set(user.taskDeletionByTrashIcon); // Sets task deletion method state. // Setzt Aufgabenlöschungsmethoden-Zustand.

        final localStorageRepository = LocalStorageRepository(); // Creates new local storage repository instance. // Erstellt neue Instanz des lokalen Speicher-Repositorys.
        final savedPomodoroColor = await localStorageRepository.getPomodoroColor(); // Gets saved pomodoro color. // Holt gespeicherte Pomodoro-Farbe.
        final savedShortBreakColor = await localStorageRepository.getShortBreakColor(); // Gets saved short break color. // Holt gespeicherte Kurzpausen-Farbe.
        final savedLongBreakColor = await localStorageRepository.getLongBreakColor(); // Gets saved long break color. // Holt gespeicherte Langpausen-Farbe.

        if (savedPomodoroColor == '#74F143' && savedShortBreakColor == '#ff9933' && savedLongBreakColor == '#0891FF') { // Checks if default colors are used. // Prüft, ob Standardfarben verwendet werden.
          ref.read(darkPomodoroColorProvider.notifier).state = const Color(0xFF74F143); // Sets default pomodoro color. // Setzt Standard-Pomodoro-Farbe.
          ref.read(darkShortBreakColorProvider.notifier).state = const Color(0xFFFF9933); // Sets default short break color. // Setzt Standard-Kurzpausen-Farbe.
          ref.read(darkLongBreakColorProvider.notifier).state = const Color(0xFF0891FF); // Sets default long break color. // Setzt Standard-Langpausen-Farbe.
        } else { // If user has custom colors. // Wenn Benutzer benutzerdefinierte Farben hat.
          ref.read(darkPomodoroColorProvider.notifier).state = Color(int.parse(savedPomodoroColor.substring(1), radix: 16)); // Sets custom pomodoro color. // Setzt benutzerdefinierte Pomodoro-Farbe.
          ref.read(darkShortBreakColorProvider.notifier).state = Color(int.parse(savedShortBreakColor.substring(1), radix: 16)); // Sets custom short break color. // Setzt benutzerdefinierte Kurzpausen-Farbe.
          ref.read(darkLongBreakColorProvider.notifier).state = Color(int.parse(savedLongBreakColor.substring(1), radix: 16)); // Sets custom long break color. // Setzt benutzerdefinierte Langpausen-Farbe.
        }

        await ref.read(authRepositoryProvider).updateUserSettings( // Updates user settings on server. // Aktualisiert Benutzereinstellungen auf dem Server.
          user.pomodoroTimer, // Pomodoro timer duration. // Pomodoro-Timer-Dauer.
          user.shortBreakTimer, // Short break timer duration. // Kurzpausen-Timer-Dauer.
          user.longBreakTimer, // Long break timer duration. // Langpausen-Timer-Dauer.
          user.longBreakInterval, // Long break interval. // Langpausen-Intervall.
          ref.read(selectedSoundProvider), // Selected notification sound. // Ausgewählter Benachrichtigungston.
          user.browserNotificationsEnabled, // Browser notifications setting. // Browser-Benachrichtigungseinstellung.
          ref.read(darkPomodoroColorProvider), // Pomodoro timer color. // Pomodoro-Timer-Farbe.
          ref.read(darkShortBreakColorProvider), // Short break timer color. // Kurzpausen-Timer-Farbe.
          ref.read(darkLongBreakColorProvider), // Long break timer color. // Langpausen-Timer-Farbe.
        );

        navigator.replace('/'); // Navigates to home screen. // Navigiert zum Hauptbildschirm.
        Navigator.of(context).pop(); // Closes the current screen or dialog. // Schließt den aktuellen Bildschirm oder Dialog.
      } else { // If sign-in failed. // Wenn die Anmeldung fehlgeschlagen ist.
        sMessenger.showSnackBar( // Shows error message. // Zeigt Fehlermeldung an.
          SnackBar(
            content: Text(errorModel.error!), // Displays error message from result. // Zeigt Fehlermeldung aus dem Ergebnis an.
          ),
        );
      }
    } catch (error) { // Catches any errors during sign-in. // Fängt alle Fehler während der Anmeldung ab.
      print('Error signing in with Google: $error'); // Debug log for error. // Debug-Protokoll für Fehler.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    return ElevatedButton.icon( // Creates an elevated button with an icon. // Erstellt eine hervorgehobene Schaltfläche mit einem Symbol.
      onPressed: () { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
        print('Google sign-in button pressed.'); // Debug log for button press. // Debug-Protokoll für Schaltflächendruck.
        signInWithGoogle(ref, context); // Calls sign-in method. // Ruft Anmeldemethode auf.
      },
      icon: Image.asset( // Button icon. // Schaltflächensymbol.
        'assets/images/google_logo.png', // Path to Google logo image. // Pfad zum Google-Logo-Bild.
        height: 20, // Icon height. // Symbolhöhe.
      ),
      label: Text( // Button text. // Schaltflächentext.
        'Continue with Google', // Button label text. // Schaltflächenbeschriftungstext.
        style: GoogleFonts.nunito( // Text style using Google Fonts. // Textstil mit Google Fonts.
            color: const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
            fontSize: 15.5, // Font size. // Schriftgröße.
            fontWeight: FontWeight.w600), // Semi-bold font weight. // Halbfette Schriftstärke.
      ),
      style: ElevatedButton.styleFrom( // Button style configuration. // Konfiguration des Schaltflächenstils.
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Black background color. // Schwarze Hintergrundfarbe.
        minimumSize: const Size(double.infinity, 50), // Full width, 50px height. // Volle Breite, 50px Höhe.
      ),
    );
  }
}
