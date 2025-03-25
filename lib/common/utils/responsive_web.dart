/// ResponsiveWeb
/// 
/// A wrapper widget that makes web content responsive across different screen sizes. // Ein Wrapper-Widget, das Webinhalte auf verschiedenen Bildschirmgrößen responsiv macht.
/// Used to constrain the maximum width of the application content for better readability on larger screens. // Wird verwendet, um die maximale Breite des Anwendungsinhalts zu begrenzen, für eine bessere Lesbarkeit auf größeren Bildschirmen.
/// 
/// Usage:
/// ```dart
/// ResponsiveWeb(
///   child: YourAppContent(),
/// )
/// ```
/// 
/// EN: Centers and constrains application content to a maximum width of 900 pixels for optimal display on web and desktop platforms.
/// DE: Zentriert und beschränkt Anwendungsinhalte auf eine maximale Breite von 900 Pixeln für optimale Anzeige auf Web- und Desktop-Plattformen.

import 'package:flutter/material.dart';  // Imports core Flutter material design package. // Importiert das Flutter Material-Design-Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.

class ResponsiveWeb extends ConsumerWidget {  // Defines a consumer widget for responsive web layout. // Definiert ein Consumer-Widget für responsives Web-Layout.
  final Widget child;  // Declares a final property to hold the child widget. // Deklariert eine finale Eigenschaft, um das Kind-Widget zu halten.
  const ResponsiveWeb({super.key, required this.child});  // Constructor requiring a child widget. // Konstruktor, der ein Kind-Widget erfordert.

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Builds the widget with context and Riverpod reference. // Erstellt das Widget mit Kontext und Riverpod-Referenz.
    return Scaffold(  // Creates a basic material design visual layout structure. // Erstellt eine grundlegende Material-Design-Layoutstruktur.
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),  // Sets background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
      body: Center(  // Centers the content horizontally and vertically. // Zentriert den Inhalt horizontal und vertikal.
        child: ConstrainedBox(  // Creates a box with size constraints. // Erstellt eine Box mit Größenbeschränkungen.
          constraints: const BoxConstraints(  // Sets size constraints for the content. // Legt Größenbeschränkungen für den Inhalt fest.
            maxWidth: 900,  // Limits maximum width to 900 pixels. // Begrenzt die maximale Breite auf 900 Pixel.
          ),
          child: child,  // Displays the provided child widget. // Zeigt das bereitgestellte Kind-Widget an.
        ),
      ),
    );
  }
}
