/// Glassmorphism
/// 
/// A reusable widget that creates a frosted glass visual effect for its child content. // Ein wiederverwendbares Widget, das einen Milchglas-Effekt für seinen Kinderinhalt erzeugt.
/// Used to create modern, translucent UI elements with a blurred background and subtle border. // Wird verwendet, um moderne, durchscheinende UI-Elemente mit verschwommenem Hintergrund und dezenter Umrandung zu erstellen.
/// 
/// Usage:
/// ```dart
/// Glassmorphism(
///   blur: 10.0,
///   opacity: 0.2,
///   radius: 15.0,
///   child: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Text('Content inside frosted glass'),
///   ),
/// )
/// ```
/// 
/// EN: Creates a container with a frosted glass effect by applying blur filters and transparent styling.
/// DE: Erstellt einen Container mit einem Milchglas-Effekt durch Anwendung von Unschärfefiltern und transparenter Gestaltung.

import 'dart:ui'; // Imports UI utilities including blur filters. // Importiert UI-Dienstprogramme einschließlich Unschärfefilter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.

class Glassmorphism extends ConsumerWidget { // Defines a stateless widget with Riverpod consumer capabilities. // Definiert ein zustandsloses Widget mit Riverpod-Consumer-Fähigkeiten.
  final double blur; // The intensity of the blur effect. // Die Intensität des Unschärfe-Effekts.
  final double opacity; // The opacity level for the glass effect. // Der Deckkraftgrad für den Glaseffekt.
  final double radius; // The corner radius of the container. // Der Eckenradius des Containers.
  final Widget child; // The widget to display inside the glass container. // Das Widget, das innerhalb des Glascontainers angezeigt wird.

  const Glassmorphism({ // Constructor for the Glassmorphism widget. // Konstruktor für das Glassmorphism-Widget.
    Key? key, // Optional key for widget identification. // Optionaler Schlüssel für Widget-Identifikation.
    required this.blur, // Required parameter for blur intensity. // Erforderlicher Parameter für Unschärfe-Intensität.
    required this.opacity, // Required parameter for opacity level. // Erforderlicher Parameter für Deckkraftgrad.
    required this.radius, // Required parameter for corner radius. // Erforderlicher Parameter für Eckenradius.
    required this.child, // Required parameter for child widget. // Erforderlicher Parameter für Kind-Widget.
  }) : super(key: key); // Passes key to parent constructor. // Übergibt Schlüssel an den übergeordneten Konstruktor.

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Builds the widget UI with access to Riverpod ref. // Baut die Widget-Benutzeroberfläche mit Zugriff auf Riverpod-Ref auf.

    return ClipRRect( // Creates a widget that clips its child using a rounded rectangle. // Erstellt ein Widget, das sein Kind mit einem abgerundeten Rechteck beschneidet.
      borderRadius: BorderRadius.circular(radius), // Sets the border radius using the provided radius value. // Setzt den Rahmenradius mit dem angegebenen Radiuswert.
      child: BackdropFilter( // Applies a filter to the existing painted content before painting its child. // Wendet einen Filter auf den vorhandenen gemalten Inhalt an, bevor sein Kind gemalt wird.
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), // Creates a Gaussian blur filter with specified intensity. // Erstellt einen Gaußschen Unschärfefilter mit angegebener Intensität.
        child: Container( // Creates a box with specified visual properties. // Erstellt einen Kasten mit bestimmten visuellen Eigenschaften.
          decoration: BoxDecoration( // Defines how the container should be painted. // Definiert, wie der Container gemalt werden soll.
            color:
             const Color.fromARGB(255, 0, 0, 0), // Sets background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
      
            borderRadius: BorderRadius.all(Radius.circular(radius)), // Applies rounded corners to the container. // Wendet abgerundete Ecken auf den Container an.
            border: Border.all( // Creates a uniform border around the container. // Erstellt einen einheitlichen Rahmen um den Container.
              width: 1.5, // Sets border width to 1.5 logical pixels. // Setzt die Rahmenbreite auf 1,5 logische Pixel.
              color: Colors.grey.withOpacity(0.2), // Creates a semi-transparent grey border. // Erstellt einen halbtransparenten grauen Rahmen.
            ),
          ),
          child: child, // Displays the provided child widget inside the container. // Zeigt das bereitgestellte Kind-Widget innerhalb des Containers an.
        ),
      ),
    );
  }
}
