import 'dart:html' as html;  // Import Dart's HTML library for web browser functionality.  // Importiert Darts HTML-Bibliothek für Webbrowser-Funktionalität.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Import Riverpod for state management.  // Importiert Riverpod für die Zustandsverwaltung.
import '../../infrastructure/data_sources/hive_services.dart';  // Import local Hive database service.  // Importiert den lokalen Hive-Datenbankdienst.

class NotificationToggle extends StateNotifier<bool> {  // Define a class that manages notification state.  // Definiert eine Klasse, die den Benachrichtigungszustand verwaltet.
  NotificationToggle() : super(false) {  // Constructor initializes state to false.  // Konstruktor initialisiert den Zustand auf false.
    initState();  // Call initialization method.  // Ruft die Initialisierungsmethode auf.
  }

  Future<void> initState() async {  // Asynchronous initialization method.  // Asynchrone Initialisierungsmethode.
    state = await HiveServices.retrieveNotificationSwitchState();  // Load saved notification state from storage.  // Lädt den gespeicherten Benachrichtigungszustand aus dem Speicher.
  }

  void toggle() async {  // Method to toggle notification permissions.  // Methode zum Umschalten der Benachrichtigungsberechtigungen.
    bool oldState = state;  // Store current state before changes.  // Speichert den aktuellen Zustand vor Änderungen.
    state = !state;  // Toggle the state value.  // Schaltet den Zustandswert um.

    if (html.Notification.supported) {  // Check if browser supports notifications.  // Prüft, ob der Browser Benachrichtigungen unterstützt.
      if (state == true) {  // If turning notifications ON.  // Wenn Benachrichtigungen eingeschaltet werden.
        if (html.Notification.permission != "granted") {  // If permission not already granted.  // Wenn die Berechtigung noch nicht erteilt wurde.
          await html.Notification.requestPermission().then((permission) {  // Request browser permission.  // Fordert die Browser-Berechtigung an.
            if (permission != "granted") {  // If user denies permission.  // Wenn der Benutzer die Berechtigung verweigert.
              state = oldState;  // Revert to previous state.  // Kehrt zum vorherigen Zustand zurück.
            }

          });
        }
      } else {  // If turning notifications OFF.  // Wenn Benachrichtigungen ausgeschaltet werden.
        // When turning notifications OFF  // Beim Ausschalten von Benachrichtigungen
        // You can't revoke browser permissions. You can only ensure that you don't send notifications.  // Man kann Browser-Berechtigungen nicht widerrufen. Man kann nur sicherstellen, dass keine Benachrichtigungen gesendet werden.

        // You can, however, show a prompt or guide on how the user can manually disable it in browser settings.  // Man kann jedoch einen Hinweis oder eine Anleitung anzeigen, wie der Benutzer sie manuell in den Browsereinstellungen deaktivieren kann.
      }
      await HiveServices.saveNotificationSwitchState(state);  // Save the current state to storage.  // Speichert den aktuellen Zustand im Speicher.
    }
  }
}
