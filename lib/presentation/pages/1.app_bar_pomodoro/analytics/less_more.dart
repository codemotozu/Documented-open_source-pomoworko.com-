/// LessAndMoreContainerGithubChart
/// 
/// A widget that displays a legend for GitHub-style activity charts. // Ein Widget, das eine Legende für GitHub-Stil-Aktivitätsdiagramme anzeigt.
/// Shows color gradient boxes with time thresholds for activity visualization. // Zeigt Farbverlaufsfelder mit Zeitschwellen für die Aktivitätsvisualisierung.
/// 
/// Usage:
/// ```dart
/// LessAndMoreContainerGithubChart()
/// ```
/// 
/// EN: Creates a color scale legend for GitHub-style activity charts with time thresholds.
/// DE: Erstellt eine Farbskala-Legende für GitHub-Stil-Aktivitätsdiagramme mit Zeitschwellen.

import 'package:flutter/material.dart'; // Imports Material Design widgets and themes. // Importiert Material Design Widgets und Themes.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts for custom typography. // Importiert Google Fonts für benutzerdefinierte Typografie.

import '../../../notifiers/persistent_container_notifier.dart'; // Imports notifier for selected container state. // Importiert Notifier für ausgewählten Container-Zustand.
import '../../../notifiers/providers.dart'; // Imports application providers. // Importiert Anwendungs-Provider.

class LessAndMoreContainerGithubChart extends ConsumerWidget { // Defines a stateless widget with Riverpod integration. // Definiert ein zustandsloses Widget mit Riverpod-Integration.
  const LessAndMoreContainerGithubChart({super.key}); // Constructor with an optional key parameter. // Konstruktor mit einem optionalen Key-Parameter.

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Builds the widget UI using Riverpod reference. // Erstellt die Widget-UI mit Riverpod-Referenz.
    final selectedContainerIndex =
        ref.watch(persistentContainerIndexProvider) ?? 0; // Gets selected container index or defaults to 0. // Holt ausgewählten Container-Index oder verwendet 0 als Standard.

    final List<Color> projectColors = [ // Defines colors for different projects. // Definiert Farben für verschiedene Projekte.
      const Color(0xffDE6868), // Red color. // Rote Farbe.
      const Color(0xffECBB42), // Yellow color. // Gelbe Farbe.
      const Color(0xff4439B9), // Blue color. // Blaue Farbe.
      const Color(0xff34BB54), // Green color. // Grüne Farbe.
    ];

    Color currentColor =
        projectColors[selectedContainerIndex % projectColors.length]; // Gets color for current project/container. // Holt Farbe für aktuelles Projekt/Container.

    Color getColorShade(Color baseColor, double factor) { // Helper function to create color variations. // Hilfsfunktion zur Erstellung von Farbvariationen.
      int r = (baseColor.red * factor).round().clamp(0, 255); // Calculates red channel with factor and clamps to valid range. // Berechnet Rotkanal mit Faktor und begrenzt auf gültigen Bereich.
      int g = (baseColor.green * factor).round().clamp(0, 255); // Calculates green channel with factor and clamps to valid range. // Berechnet Grünkanal mit Faktor und begrenzt auf gültigen Bereich.
      int b = (baseColor.blue * factor).round().clamp(0, 255); // Calculates blue channel with factor and clamps to valid range. // Berechnet Blaukanal mit Faktor und begrenzt auf gültigen Bereich.
      return Color.fromRGBO(r, g, b, 1); // Returns new adjusted color. // Gibt neue angepasste Farbe zurück.
    }

    return Padding( // Adds padding around the legend. // Fügt Abstand um die Legende hinzu.
      padding: const EdgeInsets.only(left: 50, right: 50.0, bottom: 5), // Padding on left, right and bottom. // Abstand links, rechts und unten.
      child: Row( // Horizontal arrangement of legend items. // Horizontale Anordnung der Legendenelemente.
        mainAxisAlignment: MainAxisAlignment.end, // Aligns items to the end (right) of the row. // Richtet Elemente am Ende (rechts) der Zeile aus.
        children: [
          Padding( // Padding for "Less" text. // Abstand für "Less"-Text.
            padding: const EdgeInsets.only(right: 5.0), // Right padding for text. // Rechter Abstand für Text.
            child: Text( // Text widget. // Text-Widget.
              'Less', // Text content. // Textinhalt.
              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                color: const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
              ),
            ),
          ),
          _buildColorBox(
              context, getColorShade(currentColor, 0.2), 'At least 1 min'), // Lightest shade color box for minimal activity. // Hellstes Farbkästchen für minimale Aktivität.
          _buildColorBox(
              context, getColorShade(currentColor, 0.4), 'At least 15 min'), // Light shade color box for low activity. // Helles Farbkästchen für geringe Aktivität.
          _buildColorBox(
              context, getColorShade(currentColor, 0.6), 'At least 30 min'), // Medium shade color box for moderate activity. // Mittleres Farbkästchen für mäßige Aktivität.
          _buildColorBox(
              context, getColorShade(currentColor, 0.8), 'At least 45 min'), // Dark shade color box for high activity. // Dunkles Farbkästchen für hohe Aktivität.
          _buildColorBox(context, currentColor, 'At least 60 min'), // Full color box for maximum activity. // Vollfarbiges Kästchen für maximale Aktivität.
          Padding( // Padding for "More" text. // Abstand für "More"-Text.
            padding: const EdgeInsets.only(left: 5.0), // Left padding for text. // Linker Abstand für Text.
            child: Text( // Text widget. // Text-Widget.
              'More', // Text content. // Textinhalt.
              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                color: const Color(0xffF2F2F2), // Light gray text color. // Hellgraue Textfarbe.
                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(BuildContext context, Color color, String tooltip) { // Helper method to build a colored box with tooltip. // Hilfsmethode zum Erstellen eines farbigen Kästchens mit Tooltip.
    return Tooltip( // Tooltip widget that shows when hovering. // Tooltip-Widget, das beim Darüberfahren angezeigt wird.
      message: tooltip, // Tooltip text content. // Tooltip-Textinhalt.
      textStyle: TextStyle( // Style for tooltip text. // Stil für Tooltip-Text.
        color: Colors.grey[800], // Dark gray text color. // Dunkelgraue Textfarbe.
        fontFamily: 'San Francisco', // San Francisco font. // San Francisco-Schriftart.
        fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
      ),
      decoration: BoxDecoration( // Visual style for tooltip. // Visueller Stil für Tooltip.
        color: Colors.grey[200], // Light gray background. // Hellgrauer Hintergrund.
        borderRadius: BorderRadius.circular(10), // Rounded corners. // Abgerundete Ecken.
      ),
      child: Padding( // Padding around color box. // Abstand um das Farbkästchen.
        padding: const EdgeInsets.only(left: 2.0, right: 2.0), // Horizontal padding. // Horizontaler Abstand.
        child: Container( // Container for the color box. // Container für das Farbkästchen.
          height: 12.5, // Height of the color box. // Höhe des Farbkästchens.
          width: 12.5, // Width of the color box. // Breite des Farbkästchens.
          decoration: BoxDecoration( // Visual style for the color box. // Visueller Stil für das Farbkästchen.
            borderRadius: BorderRadius.circular(2), // Slightly rounded corners. // Leicht abgerundete Ecken.
            color: color, // Box color from parameter. // Kästchenfarbe aus Parameter.
          ),
        ),
      ),
    );
  }
}
