/// CustomTimePainter 
/// 
/// A custom painter class that creates an animated filling effect for visualizing time progress. // Eine benutzerdefinierte Painter-Klasse, die einen animierten Fülleffekt zur Visualisierung des Zeitfortschritts erstellt.
/// Used to display visual countdowns or timers with a filling animation from bottom to top. // Wird verwendet, um visuelle Countdowns oder Timer mit einer Füllanimation von unten nach oben anzuzeigen.
/// 
/// Usage:
/// ```dart
/// AnimationController controller = AnimationController(
///   vsync: this,
///   duration: Duration(seconds: 60),
/// );
/// 
/// CustomPaint(
///   painter: CustomTimePainter(
///     animation: controller,
///     backgroundColor: Colors.grey,
///     color: Colors.blue,
///   ),
///   child: Container(),
/// )
/// ```
/// 
/// EN: Creates a visual time indicator that fills from bottom to top as the animation progresses.
/// DE: Erstellt einen visuellen Zeitindikator, der sich von unten nach oben füllt, während die Animation fortschreitet.

import 'dart:ui' as ui; // Imports the UI package from Dart for advanced painting operations. // Importiert das UI-Paket von Dart für erweiterte Zeichenoperationen.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.


class CustomTimePainter extends CustomPainter { // Defines a custom painter class that extends Flutter's CustomPainter. // Definiert eine benutzerdefinierte Painter-Klasse, die Flutter's CustomPainter erweitert.
  CustomTimePainter({ // Constructor for the CustomTimePainter. // Konstruktor für den CustomTimePainter.
    required this.animation, // Required animation parameter that controls the filling. // Erforderlicher Animationsparameter, der die Füllung steuert.
    required this.backgroundColor, // Required background color parameter. // Erforderlicher Hintergrundfarbenparameter.
    required this.color, // Required fill color parameter. // Erforderlicher Füllfarbenparameter.
  }) : super(repaint: animation); // Calls parent constructor with the animation as the repaint notifier. // Ruft den Elternkonstruktor mit der Animation als Repaint-Notifier auf.

  final Animation<double> animation; // Animation that drives the painting, values from 0.0 to 1.0. // Animation, die das Zeichnen steuert, Werte von 0.0 bis 1.0.
  Color backgroundColor, color; // Colors for the background and the filling indicator. // Farben für den Hintergrund und den Füllindikator.

  @override
  void paint(Canvas canvas, Size size) { // Overrides the paint method to draw on the canvas. // Überschreibt die paint-Methode, um auf der Leinwand zu zeichnen.
    var paint = Paint()..color = backgroundColor; // Creates a Paint object with the background color. // Erstellt ein Paint-Objekt mit der Hintergrundfarbe.
    canvas.clipRect(Offset.zero & size); // Clips the canvas to the size of the widget. // Beschneidet die Leinwand auf die Größe des Widgets.
    canvas.drawPaint(paint); // Fills the entire canvas with the background color. // Füllt die gesamte Leinwand mit der Hintergrundfarbe.

    final top = ui.lerpDouble(0, size.height, animation.value)!; // Calculates the top position of the fill by interpolating between 0 and height based on animation value. // Berechnet die obere Position der Füllung durch Interpolation zwischen 0 und Höhe basierend auf dem Animationswert.

    Rect rect = Rect.fromLTRB(0, 0, size.width, top); // Creates a rectangle from top-left to the calculated top position. // Erstellt ein Rechteck von oben links bis zur berechneten oberen Position.
    Path path = Path()..addRect(rect); // Creates a path from the rectangle. // Erstellt einen Pfad aus dem Rechteck.

    canvas.drawPath(path, paint..color = color); // Draws the path with the fill color. // Zeichnet den Pfad mit der Füllfarbe.
  }

  @override
  bool shouldRepaint(CustomTimePainter old) { // Determines when this painter should repaint itself. // Bestimmt, wann dieser Painter sich neu zeichnen sollte.
    return animation.value != old.animation.value || // Returns true if the animation value has changed. // Gibt true zurück, wenn sich der Animationswert geändert hat.
        color != old.color || // Returns true if the fill color has changed. // Gibt true zurück, wenn sich die Füllfarbe geändert hat.
        backgroundColor != old.backgroundColor; // Returns true if the background color has changed. // Gibt true zurück, wenn sich die Hintergrundfarbe geändert hat.
  }
}
