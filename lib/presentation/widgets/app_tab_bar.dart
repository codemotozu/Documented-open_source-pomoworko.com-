/// AppTabBar
/// 
/// A custom tab bar widget for a Pomodoro timer application. // Ein benutzerdefiniertes Tab-Leisten-Widget für eine Pomodoro-Timer-Anwendung.
/// Used to provide navigation between different timer modes: work session, short break, and long break. // Wird verwendet, um die Navigation zwischen verschiedenen Timer-Modi zu ermöglichen: Arbeitssitzung, kurze Pause und lange Pause.
/// 
/// Usage:
/// ```dart
/// TabController _tabController = TabController(length: 3, vsync: this);
/// 
/// Scaffold(
///   appBar: AppTabBar(tabController: _tabController),
///   body: TabBarView(
///     controller: _tabController,
///     children: [
///       PomodoroScreen(),
///       ShortBreakScreen(),
///       LongBreakScreen(),
///     ],
///   ),
/// );
/// ```
/// 
/// EN: Creates a styled tab bar with three tabs (Pomodoro, Short break, Long break) using custom colors, fonts, and indicators.
/// DE: Erstellt eine gestylte Tab-Leiste mit drei Tabs (Pomodoro, Kurze Pause, Lange Pause) mit benutzerdefinierten Farben, Schriften und Indikatoren.

import 'package:flutter/cupertino.dart'; // Imports Cupertino (iOS-style) widgets from Flutter. // Importiert Cupertino (iOS-Stil) Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for custom typography. // Importiert das Google Fonts-Paket für benutzerdefinierte Typografie.


class AppTabBar extends ConsumerWidget implements PreferredSizeWidget { // Defines a widget that can access Riverpod providers and specifies its preferred size. // Definiert ein Widget, das auf Riverpod-Provider zugreifen kann und seine bevorzugte Größe angibt.
  final TabController tabController; // Declares a field for the tab controller. // Deklariert ein Feld für den Tab-Controller.

  const AppTabBar({super.key, required this.tabController}); // Constructor that requires a TabController parameter. // Konstruktor, der einen TabController-Parameter erfordert.

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Overrides the build method to create the UI and accepts a WidgetRef for state access. // Überschreibt die build-Methode, um die Benutzeroberfläche zu erstellen und akzeptiert einen WidgetRef für den Zustandszugriff.

    return TabBar( // Returns a TabBar widget. // Gibt ein TabBar-Widget zurück.
      controller: tabController, // Sets the tab controller. // Setzt den Tab-Controller.
      indicator: const UnderlineTabIndicator( // Configures an underline indicator for the selected tab. // Konfiguriert einen Unterstreichungsindikator für den ausgewählten Tab.
        borderSide: BorderSide( // Defines the border style for the indicator. // Definiert den Randstil für den Indikator.
            color: Color(0xffF2F2F2), // Sets the indicator color to a light gray. // Setzt die Indikatorfarbe auf ein helles Grau.
            width: 2.0), // Sets the indicator width to 2 logical pixels. // Setzt die Indikatorbreite auf 2 logische Pixel.
      ),
      indicatorWeight: 5, // Sets the weight (thickness) of the indicator. // Setzt das Gewicht (die Dicke) des Indikators.
      indicatorSize: TabBarIndicatorSize.label, // Makes the indicator match the width of the tab label. // Lässt den Indikator mit der Breite der Tab-Beschriftung übereinstimmen.
      labelColor:  const Color(0xffF2F2F2), // Sets the color of the selected tab label to light gray. // Setzt die Farbe der ausgewählten Tab-Beschriftung auf hellgrau.
      labelStyle: GoogleFonts.nunito( // Sets the text style for selected tabs using Google Fonts. // Setzt den Textstil für ausgewählte Tabs mit Google Fonts.
        fontSize: 16.0, // Sets the font size to 16 logical pixels. // Setzt die Schriftgröße auf 16 logische Pixel.
        fontWeight: FontWeight.w500, // Sets the font weight to medium (500). // Setzt die Schriftstärke auf mittel (500).
      ),
      unselectedLabelColor: const Color.fromARGB(255, 134, 134, 134), // Sets the color of unselected tab labels to a darker gray. // Setzt die Farbe nicht ausgewählter Tab-Beschriftungen auf ein dunkleres Grau.
      tabs: const [ // Defines the list of tabs. // Definiert die Liste der Tabs.
        Tab( // First tab for the Pomodoro timer. // Erster Tab für den Pomodoro-Timer.
          text: "Pomodoro", // Sets the tab text. // Setzt den Tab-Text.
          icon: Icon(CupertinoIcons.device_laptop, size: 24), // Adds a laptop icon from Cupertino icons set. // Fügt ein Laptop-Symbol aus dem Cupertino-Symbolsatz hinzu.
        ),
        Tab( // Second tab for the short break timer. // Zweiter Tab für den Kurzpausen-Timer.
          text: "Short break", // Sets the tab text for short breaks. // Setzt den Tab-Text für kurze Pausen.
          icon: Icon(Icons.ramen_dining_outlined, size: 24), // Adds a ramen dining icon from Material icons. // Fügt ein Ramen-Essen-Symbol aus den Material-Symbolen hinzu.
        ),
        Tab( // Third tab for the long break timer. // Dritter Tab für den Langpausen-Timer.
          text: "Long break", // Sets the tab text for long breaks. // Setzt den Tab-Text für lange Pausen.
          icon: Icon(CupertinoIcons.battery_25_percent, size: 24), // Adds a low battery icon from Cupertino icons. // Fügt ein Symbol für niedrigen Batteriestand aus den Cupertino-Symbolen hinzu.
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Returns the preferred size for the widget, using the standard toolbar height. // Gibt die bevorzugte Größe für das Widget zurück, unter Verwendung der Standardhöhe der Symbolleiste.
}
