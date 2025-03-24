/// SmileFaceCheckbox
/// 
/// A custom animated checkbox widget that displays as a happy or sad face depending on its state. // Ein benutzerdefiniertes animiertes Checkbox-Widget, das je nach Zustand als glückliches oder trauriges Gesicht angezeigt wird.
/// Used to provide an engaging and visual way for users to toggle between two states. // Wird verwendet, um Benutzern eine ansprechende und visuelle Möglichkeit zu bieten, zwischen zwei Zuständen zu wechseln.
/// 
/// Usage:
/// ```dart
/// SmileFaceCheckbox( 
///   isActive: _isHappy,
///   onPress: () {
///     setState(() {
///       _isHappy = !_isHappy;
///     });
///   },
/// )
/// ```
/// 
/// EN: Creates an animated switch that displays a happy face (green) when active and a sad face (red) when inactive.
/// DE: Erstellt einen animierten Schalter, der ein glückliches Gesicht (grün) anzeigt, wenn aktiv, und ein trauriges Gesicht (rot), wenn inaktiv.

import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design-Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.

class SmileFaceCheckbox extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  final double height; // The height of the checkbox. // Die Höhe der Checkbox.
  final bool isActive; // Whether the checkbox is in active/happy state. // Ob die Checkbox im aktiven/glücklichen Zustand ist.
  final VoidCallback onPress; // Function to call when checkbox is pressed. // Funktion, die aufgerufen wird, wenn die Checkbox gedrückt wird.
  final Color activeColor; // Color when checkbox is active. // Farbe, wenn die Checkbox aktiv ist.
  final Color deactiveColor; // Color when checkbox is inactive. // Farbe, wenn die Checkbox inaktiv ist.

  const SmileFaceCheckbox({ // Constructor for the SmileFaceCheckbox. // Konstruktor für die SmileFaceCheckbox.
    super.key, // Key parameter passed to parent class. // Key-Parameter, der an die Elternklasse übergeben wird.
    this.height = 24.0, // Default height of 24 logical pixels. // Standardhöhe von 24 logischen Pixeln.
    required this.isActive, // Required parameter for active state. // Erforderlicher Parameter für den aktiven Zustand.
    required this.onPress, // Required parameter for press callback. // Erforderlicher Parameter für den Druck-Callback.
  })  : activeColor = const Color.fromARGB(255, 34, 161, 66), // Initializes active color to green. // Initialisiert die aktive Farbe auf Grün.
        deactiveColor = const Color(0xffFA4332); // Initializes inactive color to red. // Initialisiert die inaktive Farbe auf Rot.

  @override
  _SmileFaceCheckboxState createState() => _SmileFaceCheckboxState(); // Creates the state object for this widget. // Erstellt das State-Objekt für dieses Widget.
}

class _SmileFaceCheckboxState extends ConsumerState<SmileFaceCheckbox>
    with SingleTickerProviderStateMixin { // Extends ConsumerState and adds animation ticker capabilities. // Erweitert ConsumerState und fügt Animations-Ticker-Fähigkeiten hinzu.
  late AnimationController _animationController; // Controller for managing animations. // Controller für die Verwaltung von Animationen.
  late Animation<double> _animationValue; // Animation object for smooth transitions. // Animationsobjekt für sanfte Übergänge.

  void setupAnimation() { // Method to set up animation controller and curve. // Methode zum Einrichten von Animations-Controller und -Kurve.
    _animationController = AnimationController( // Creates animation controller. // Erstellt Animations-Controller.
      vsync: this, // Sets this class as the ticker provider. // Setzt diese Klasse als Ticker-Provider.
      duration: const Duration(milliseconds: 300), // Animation duration of 300 milliseconds. // Animationsdauer von 300 Millisekunden.
    );

    _animationValue = CurvedAnimation( // Creates curved animation for smoother motion. // Erstellt kurvige Animation für sanftere Bewegung.
      parent: _animationController, // Sets controller as parent. // Setzt Controller als übergeordnetes Element.
      curve: const Interval(0.0, 1.0), // Linear animation over the full interval. // Lineare Animation über das gesamte Intervall.
    );
  }

  @override
  void initState() { // Called when widget is first created. // Wird aufgerufen, wenn das Widget zum ersten Mal erstellt wird.
    setupAnimation(); // Initializes animation components. // Initialisiert Animationskomponenten.
    super.initState(); // Calls parent initState. // Ruft übergeordnetes initState auf.
  }

  @override
  void dispose() { // Called when widget is removed from widget tree. // Wird aufgerufen, wenn das Widget aus dem Widget-Baum entfernt wird.
    _animationController.dispose(); // Releases resources used by animation controller. // Gibt vom Animations-Controller verwendete Ressourcen frei.
    super.dispose(); // Calls parent dispose method. // Ruft die übergeordnete dispose-Methode auf.
  }

  @override
  Widget build(BuildContext context) { // Builds the widget UI. // Baut die Widget-Benutzeroberfläche auf.
    final height = widget.height; // Gets height from widget properties. // Holt Höhe aus Widget-Eigenschaften.
    final width = height * 2; // Sets width to twice the height. // Setzt Breite auf das Doppelte der Höhe.
    final largeRadius = (height * 0.9) / 2; // Calculates radius for main circle (face). // Berechnet Radius für den Hauptkreis (Gesicht).
    final smallRadius = (height * 0.2) / 2; // Calculates radius for eyes and mouth. // Berechnet Radius für Augen und Mund.
    return GestureDetector( // Creates a widget that detects gestures. // Erstellt ein Widget, das Gesten erkennt.
      onTap: widget.onPress, // Calls provided callback when tapped. // Ruft den bereitgestellten Callback auf, wenn getippt wird.
      child: AnimatedBuilder( // Creates a widget that rebuilds when animation changes. // Erstellt ein Widget, das neu aufgebaut wird, wenn sich die Animation ändert.
        animation: _animationController, // Sets animation controller as the animation source. // Setzt Animations-Controller als Animationsquelle.
        builder: (context, _) { // Builder function for creating animated content. // Builder-Funktion zum Erstellen animierter Inhalte.
          if (widget.isActive) { // If checkbox is active/happy. // Wenn Checkbox aktiv/glücklich ist.
            _animationController.forward(); // Moves animation forward toward end value. // Bewegt Animation vorwärts zum Endwert.
          } else { // If checkbox is inactive/sad. // Wenn Checkbox inaktiv/traurig ist.
            _animationController.reverse(); // Reverses animation toward start value. // Kehrt Animation zum Startwert um.
          }
          return Container( // Creates the main container for the checkbox. // Erstellt den Hauptcontainer für die Checkbox.
            height: height, // Sets container height. // Setzt Container-Höhe.
            width: width, // Sets container width. // Setzt Container-Breite.
            decoration: BoxDecoration( // Defines visual properties of the container. // Definiert visuelle Eigenschaften des Containers.
              borderRadius: BorderRadius.circular(80.0), // Rounds corners to create pill shape. // Rundet Ecken ab, um Pillenform zu erstellen.
              color:
                  widget.isActive ? widget.activeColor : widget.deactiveColor, // Sets background color based on state. // Setzt Hintergrundfarbe basierend auf Zustand.
            ),
            child: Stack( // Creates a stack to position face elements. // Erstellt einen Stapel, um Gesichtselemente zu positionieren.
              alignment: Alignment.center, // Centers children in the stack. // Zentriert Kinder im Stapel.
              children: [ // List of stacked widgets. // Liste gestapelter Widgets.
                Transform.translate( // Creates a translation transformation. // Erstellt eine Übersetzungstransformation.
                  offset: Offset(
                      -largeRadius + largeRadius * 2 * _animationValue.value,
                      0), // Calculates horizontal position for face animation. // Berechnet horizontale Position für Gesichtsanimation.
                  child: Container( // Creates the face container. // Erstellt den Gesichtscontainer.
                    width: largeRadius * 2, // Sets face width. // Setzt Gesichtsbreite.
                    height: largeRadius * 2, // Sets face height. // Setzt Gesichtshöhe.
                    decoration: const BoxDecoration( // Defines visual properties of the face. // Definiert visuelle Eigenschaften des Gesichts.
                      color: Colors.white, // Sets face color to white. // Setzt Gesichtsfarbe auf Weiß.
                      shape: BoxShape.circle, // Creates circular shape for face. // Erstellt kreisförmige Form für Gesicht.
                    ),
                    child: Stack( // Creates a stack for positioning facial features. // Erstellt einen Stapel für die Positionierung von Gesichtsmerkmalen.
                      alignment: Alignment.center, // Centers children in the stack. // Zentriert Kinder im Stapel.
                      children: [ // List of facial feature widgets. // Liste von Gesichtsmerkmal-Widgets.
                        Transform.translate( // Creates a translation for eyes. // Erstellt eine Übersetzung für die Augen.
                          offset: Offset(0, -smallRadius), // Positions eyes above center. // Positioniert Augen über der Mitte.
                          child: Row( // Creates a row layout for the eyes. // Erstellt ein Zeilenlayout für die Augen.
                            mainAxisAlignment: MainAxisAlignment.spaceAround, // Spaces eyes evenly. // Verteilt Augen gleichmäßig.
                            children: [ // List of eye widgets. // Liste von Augen-Widgets.
                              Container( // Creates container for left eye. // Erstellt Container für linkes Auge.
                                width: smallRadius * 2, // Sets eye width. // Setzt Augenbreite.
                                height: smallRadius * 2, // Sets eye height. // Setzt Augenhöhe.
                                decoration: BoxDecoration( // Defines visual properties of the eye. // Definiert visuelle Eigenschaften des Auges.
                                  color: widget.isActive
                                      ? widget.activeColor
                                      : widget.deactiveColor, // Sets eye color based on state. // Setzt Augenfarbe basierend auf Zustand.
                                  shape: BoxShape.circle, // Creates circular shape for eye. // Erstellt kreisförmige Form für Auge.
                                ),
                              ),
                              Container( // Creates container for right eye. // Erstellt Container für rechtes Auge.
                                width: smallRadius * 2, // Sets eye width. // Setzt Augenbreite.
                                height: smallRadius * 2, // Sets eye height. // Setzt Augenhöhe.
                                decoration: BoxDecoration( // Defines visual properties of the eye. // Definiert visuelle Eigenschaften des Auges.
                                  color: widget.isActive
                                      ? widget.activeColor
                                      : widget.deactiveColor, // Sets eye color based on state. // Setzt Augenfarbe basierend auf Zustand.
                                  shape: BoxShape.circle, // Creates circular shape for eye. // Erstellt kreisförmige Form für Auge.
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate( // Creates a translation for mouth. // Erstellt eine Übersetzung für den Mund.
                          offset: Offset(0, smallRadius * 2), // Positions mouth below center. // Positioniert Mund unter der Mitte.
                          child: Container( // Creates container for mouth. // Erstellt Container für Mund.
                            width: smallRadius * 4, // Sets mouth width. // Setzt Mundbreite.
                            height:
                                widget.isActive ? smallRadius * 2 : smallRadius, // Sets mouth height based on state (taller when happy). // Setzt Mundhöhe basierend auf Zustand (höher wenn glücklich).
                            decoration: BoxDecoration( // Defines visual properties of the mouth. // Definiert visuelle Eigenschaften des Mundes.
                              color: widget.isActive
                                  ? widget.activeColor
                                  : widget.deactiveColor, // Sets mouth color based on state. // Setzt Mundfarbe basierend auf Zustand.
                              borderRadius: !widget.isActive
                                  ? BorderRadius.circular(22.0) // Sad mouth has uniform rounding. // Trauriger Mund hat einheitliche Rundung.
                                  : const BorderRadius.only( // Happy mouth has special rounded bottom corners. // Glücklicher Mund hat spezielle abgerundete untere Ecken.
                                      bottomLeft: Radius.circular(40.0), // Rounds bottom left corner. // Rundet untere linke Ecke ab.
                                      bottomRight: Radius.circular(40.0), // Rounds bottom right corner. // Rundet untere rechte Ecke ab.
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
