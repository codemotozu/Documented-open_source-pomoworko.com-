/// AuthCheckScreen
/// 
/// A widget that verifies user authentication status and conditionally displays the appropriate UI. // Ein Widget, das den Benutzerauthentifizierungsstatus überprüft und bedingt die passende Benutzeroberfläche anzeigt.
/// Shows different analytics charts based on whether the user is logged in and has premium status. // Zeigt verschiedene Analyse-Diagramme an, abhängig davon, ob der Benutzer angemeldet ist und Premium-Status hat.
/// 
/// Usage:
/// ```dart
/// AuthCheckScreen()
/// ```
/// 
/// EN: Serves as an authentication gate that directs users to different views based on their auth status.
/// DE: Dient als Authentifizierungs-Gate, das Benutzer basierend auf ihrem Authentifizierungsstatus zu verschiedenen Ansichten leitet.

import 'package:flutter/material.dart'; // Imports basic Flutter material design widgets. // Importiert grundlegende Flutter Material-Design-Widgets.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import '../notifiers/providers.dart'; // Imports application providers. // Importiert Anwendungs-Provider.
import '../pages/1.app_bar_pomodoro/analytics/cartesian_chart.dart'; // Imports standard analytics chart. // Importiert Standard-Analyse-Diagramm.
import '../pages/1.app_bar_pomodoro/analytics/not_login_cartesian_chart.dart'; // Imports chart for non-logged in users. // Importiert Diagramm für nicht angemeldete Benutzer.
import '../pages/1.app_bar_pomodoro/premium_analytics/cartesian_premium.dart'; // Imports premium analytics chart. // Importiert Premium-Analyse-Diagramm.
import '../repository/auth_repository.dart'; // Imports authentication repository. // Importiert Authentifizierungs-Repository.
import '../repository/local_storage_repository.dart'; // Imports local storage repository. // Importiert lokales Speicher-Repository.

class AuthCheckScreen extends ConsumerStatefulWidget { // Defines a stateful widget with Riverpod consumer capabilities. // Definiert ein Stateful-Widget mit Riverpod-Consumer-Fähigkeiten.
  const AuthCheckScreen({super.key}); // Constructor with optional key parameter. // Konstruktor mit optionalem Key-Parameter.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthCheckScreenState(); // Creates the state for this widget. // Erstellt den State für dieses Widget.
}

class _AuthCheckScreenState extends ConsumerState<AuthCheckScreen> { // Defines the state class for AuthCheckScreen. // Definiert die State-Klasse für AuthCheckScreen.
  bool isLoading = true; // Loading state flag, initially true. // Ladezustands-Flag, anfänglich true.

  @override
  void initState() { // Initializes the widget state. // Initialisiert den Widget-State.
    super.initState(); // Calls parent initialization. // Ruft die übergeordnete Initialisierung auf.
    checkAuthStatus(); // Checks authentication status on initialization. // Überprüft den Authentifizierungsstatus bei der Initialisierung.
  }

  Future<void> checkAuthStatus() async { // Asynchronous method to verify authentication status. // Asynchrone Methode zur Überprüfung des Authentifizierungsstatus.
    final localStorageRepository = ref.read(localStorageRepositoryProvider); // Gets local storage repository from provider. // Holt lokales Speicher-Repository vom Provider.
    final token = await localStorageRepository.getToken(); // Retrieves authentication token from local storage. // Ruft Authentifizierungstoken aus dem lokalen Speicher ab.

    if (token != null && token.isNotEmpty) { // Checks if a valid token exists. // Prüft, ob ein gültiges Token existiert.
      final errorModel = await ref.read(authRepositoryProvider).getUserData(); // Fetches user data from server. // Holt Benutzerdaten vom Server.
      if (errorModel.data != null) { // Checks if data was retrieved successfully. // Prüft, ob Daten erfolgreich abgerufen wurden.
        ref.read(userProvider.notifier).update((state) => errorModel.data); // Updates user state with fetched data. // Aktualisiert den Benutzerzustand mit abgerufenen Daten.
      }
    }

    setState(() { // Updates widget state. // Aktualisiert den Widget-Zustand.
      isLoading = false; // Sets loading to false. // Setzt Laden auf false.
    });
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Erstellt die Widget-Benutzeroberfläche.
    return isLoading // Conditionally renders based on loading state. // Rendert bedingt basierend auf dem Ladezustand.
         ? Container( // Loading UI container. // Container für die Lade-UI.
          color: Colors.black, // Black background while loading. // Schwarzer Hintergrund während des Ladens.
          child: const Center( // Centers the loading indicator. // Zentriert den Ladeindikator.
            child: CircularProgressIndicator( // Shows a spinning progress indicator. // Zeigt einen drehenden Fortschrittsindikator.
              color: Colors.white, // White color for the indicator. // Weiße Farbe für den Indikator.
            ),
          ),
        )
        : Consumer( // Uses Riverpod Consumer to watch for state changes. // Verwendet Riverpod Consumer, um auf Zustandsänderungen zu achten.
            builder: (context, watch, child) { // Builder function for the Consumer. // Builder-Funktion für den Consumer.
              final user = ref.watch(userProvider); // Watches the user state provider. // Überwacht den Benutzer-State-Provider.

              if (user == null || user.token.isEmpty) { // Checks if user is not authenticated. // Prüft, ob der Benutzer nicht authentifiziert ist.
                
                return const NotLoginCartesianChart(title: ''); // Shows chart for non-logged in users. // Zeigt Diagramm für nicht angemeldete Benutzer.
              }

              if (user.isPremium) { // Checks if user has premium status. // Prüft, ob der Benutzer Premium-Status hat.
                return const CartesianPremiumChart(title: ''); // Shows premium analytics chart. // Zeigt Premium-Analyse-Diagramm.
              } else { // If user is logged in but not premium. // Wenn der Benutzer angemeldet ist, aber kein Premium-Status hat.
                return const CartesianChart(title: ''); // Shows standard analytics chart. // Zeigt Standard-Analyse-Diagramm.
              }
            },
          );
  }
}
