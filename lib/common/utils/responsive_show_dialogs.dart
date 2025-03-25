/// ResponsiveShowDialogs
/// 
/// A wrapper widget that makes dialog content responsive across different screen sizes. // Ein Wrapper-Widget, das Dialoginhalte auf verschiedenen Bildschirmgrößen responsiv macht.
/// Used to constrain the maximum width of dialogs for better user experience on larger screens. // Wird verwendet, um die maximale Breite von Dialogen zu begrenzen, für eine bessere Benutzererfahrung auf größeren Bildschirmen.
/// 
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ResponsiveShowDialogs(
///     child: YourDialogContent(),
///   ),
/// );
/// ```
/// 
/// EN: Centers and constrains dialog content to ensure proper display across different device sizes.
/// DE: Zentriert und beschränkt Dialoginhalte, um eine korrekte Anzeige auf verschiedenen Gerätegroßen zu gewährleisten.

import 'package:flutter/material.dart';  // Imports core Flutter material design package. // Importiert das Flutter Material-Design-Paket.
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.


class ResponsiveShowDialogs extends ConsumerWidget {  // Defines a consumer widget for responsive dialogs. // Definiert ein Consumer-Widget für responsive Dialoge.
  final Widget child;  // Declares a final property to hold the child widget. // Deklariert eine finale Eigenschaft, um das Kind-Widget zu halten.
  
  const ResponsiveShowDialogs({super.key, required this.child});  // Constructor requiring a child widget. // Konstruktor, der ein Kind-Widget erfordert.

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Builds the widget with context and Riverpod reference. // Erstellt das Widget mit Kontext und Riverpod-Referenz.

    return  Center(  // Centers the dialog on screen. // Zentriert den Dialog auf dem Bildschirm.
        child: ConstrainedBox(  // Creates a box with size constraints. // Erstellt eine Box mit Größenbeschränkungen.
          constraints: const BoxConstraints(  // Sets size constraints for the dialog. // Legt Größenbeschränkungen für den Dialog fest.
            maxWidth: 450,  // Limits maximum width to 450 pixels. // Begrenzt die maximale Breite auf 450 Pixel.
          ),
          child: child,  // Displays the provided child widget. // Zeigt das bereitgestellte Kind-Widget an.
        ),
    );
  }
}
