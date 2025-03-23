/// AppBarFeatures
/// 
/// A custom app bar widget for the Pomodoro timer application. // Eine benutzerdefinierte App-Bar für die Pomodoro-Timer-Anwendung.
/// This widget handles user authentication, navigation, and provides access to various app features. // Dieses Widget behandelt Benutzerauthentifizierung, Navigation und bietet Zugriff auf verschiedene App-Funktionen.
/// 
/// Usage:
/// ```dart
/// Scaffold(
///   body: CustomScrollView(
///     slivers: [
///       AppBarFeatures(),
///       
///     ],
///   ),
/// );
/// ```
/// 
/// EN: Displays a sophisticated app bar with user profile management, settings, analytics, and premium feature access.
/// DE: Zeigt eine hochentwickelte App-Bar mit Benutzerprofilverwaltung, Einstellungen, Analysen und Zugriff auf Premium-Funktionen.

import 'package:flutter/cupertino.dart'; // Imports Cupertino (iOS-style) widgets from Flutter. // Importiert Cupertino (iOS-Stil) Widgets aus Flutter.
import 'package:flutter/material.dart'; // Imports Material Design widgets from Flutter. // Importiert Material Design Widgets aus Flutter.
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Imports Riverpod for state management. // Importiert Riverpod für die Zustandsverwaltung.
import 'package:google_fonts/google_fonts.dart'; // Imports Google Fonts package for custom typography. // Importiert das Google Fonts Paket für benutzerdefinierte Typografie.
import 'package:routemaster/routemaster.dart'; // Imports Routemaster for advanced routing capabilities. // Importiert Routemaster für erweiterte Routing-Funktionen.

import '../../../../common/utils/responsive_show_dialogs.dart'; // Imports utility for responsive dialogs. // Importiert Hilfsfunktionen für responsive Dialoge.
import '../../../repository/auth_repository.dart'; // Imports authentication repository. // Importiert das Authentifizierungs-Repository.
import '../../../screens/login_google_screen.dart'; // Imports Google login screen. // Importiert den Google-Anmeldebildschirm.
import 'check_double.dart'; // Imports CheckDouble widget. // Importiert das CheckDouble-Widget.
import 'profile/contact_developer.dart'; // Imports contact developer dialog. // Importiert den Dialog zur Kontaktaufnahme mit dem Entwickler.
import 'profile/delete_account_no_premium.dart'; // Imports delete account dialog for non-premium users. // Importiert den Dialog zum Löschen des Kontos für Nicht-Premium-Nutzer.
import 'profile/delete_account_premium.dart'; // Imports delete account dialog for premium users. // Importiert den Dialog zum Löschen des Kontos für Premium-Nutzer.
import 'profile/ready_soon_features.dart'; // Imports dialog for upcoming features. // Importiert den Dialog für kommende Funktionen.
import 'profile/subscription_details.dart'; // Imports subscription details dialog. // Importiert den Dialog mit Abonnement-Details.

class AppBarFeatures extends ConsumerStatefulWidget { // Defines a stateful widget that can access Riverpod providers. // Definiert ein Stateful-Widget, das auf Riverpod-Provider zugreifen kann.
  const AppBarFeatures({super.key}); // Constructor with optional key parameter. // Konstruktor mit optionalem Key-Parameter.

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileAppBarState(); // Creates the state object for this widget. // Erstellt das State-Objekt für dieses Widget.
}

class _ProfileAppBarState extends ConsumerState<AppBarFeatures> { // Defines the state class for AppBarFeatures widget. // Definiert die State-Klasse für das AppBarFeatures-Widget.
  final tapOffsetProvider = StateProvider<Offset?>((watch) => null); // Creates a provider to track tap position for menu placement. // Erstellt einen Provider, um die Tipp-Position für die Menüplatzierung zu verfolgen.

  @override
  Widget build(BuildContext context) { // Builds the UI for this widget. // Erstellt die Benutzeroberfläche für dieses Widget.
    var tapOffset = ref.watch(tapOffsetProvider); // Watches the tap offset provider for changes. // Beobachtet den Tipp-Offset-Provider auf Änderungen.

    final user = ref.watch(userProvider.notifier).state; // Gets the current user state from the user provider. // Holt den aktuellen Benutzerzustand vom Benutzer-Provider.

    return ProviderScope( // Creates a new scope for providers. // Erstellt einen neuen Bereich für Provider.
      child: SafeArea( // Ensures content is visible and not obscured by device notches/bars. // Stellt sicher, dass der Inhalt sichtbar und nicht durch Geräteeinschnitte/-leisten verdeckt ist.
        child: Builder( // Provides a new BuildContext. // Stellt einen neuen BuildContext bereit.
          builder: (
            BuildContext context,
          ) {
            return Scaffold( // Creates a basic Material Design layout structure. // Erstellt eine grundlegende Material Design-Layoutstruktur.
              backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Sets the background color to black. // Setzt die Hintergrundfarbe auf Schwarz.
              body: CustomScrollView( // Creates a scrollable view with custom scroll behavior. // Erstellt eine scrollbare Ansicht mit benutzerdefiniertem Scrollverhalten.
                slivers: [ // List of sliver widgets (scrollable components). // Liste von Sliver-Widgets (scrollbare Komponenten).
                  SliverAppBar.medium( // Creates a medium-sized app bar that collapses to a toolbar. // Erstellt eine mittelgroße App-Bar, die zu einer Symbolleiste zusammenklappt.
                    pinned: true, // Keeps the app bar visible at top when scrolling. // Hält die App-Bar beim Scrollen oben sichtbar.
                    floating: false, // App bar doesn't float/appear when scrolling up. // App-Bar schwebt/erscheint nicht beim Scrollen nach oben.
                    expandedHeight: 95, // Sets the expanded height of the app bar. // Legt die erweiterte Höhe der App-Bar fest.
                    backgroundColor:
                        const Color.fromARGB(255, 0, 0, 0), // Sets app bar background to black. // Setzt den App-Bar-Hintergrund auf Schwarz.
                    leading: const CheckDoubleIcon(), // Sets the leading widget to CheckDoubleIcon. // Setzt das führende Widget auf CheckDoubleIcon.
                    flexibleSpace: Stack( // Creates a stack of widgets for the flexible space area. // Erstellt einen Stapel von Widgets für den flexiblen Bereich.
                      alignment: Alignment.bottomRight, // Aligns the stack content to bottom right. // Richtet den Stack-Inhalt unten rechts aus.
                      children: [
                        Padding( // Adds padding around its child. // Fügt Polsterung um sein Kind hinzu.
                          padding: const EdgeInsets.only(left: 13), // Applies 13 logical pixel padding on the left. // Wendet 13 logische Pixel Polsterung auf der linken Seite an.
                          child: Align( // Aligns its child within itself. // Richtet sein Kind innerhalb von sich selbst aus.
                            alignment: Alignment.bottomLeft, // Aligns to bottom left. // Richtet sich unten links aus.
                            child: Transform.translate( // Applies a translation transformation to its child. // Wendet eine Übersetzungstransformation auf sein Kind an.
                              offset: const Offset(0, -8), // Shifts the child 8 pixels up. // Verschiebt das Kind 8 Pixel nach oben.
                              child: Text.rich( // Creates a rich text with multiple styles. // Erstellt einen formatierten Text mit mehreren Stilen.
                                TextSpan( // Root text span for rich text. // Stamm-TextSpan für formatierten Text.
                                  text: ' pomo', // First part of the app title. // Erster Teil des App-Titels.
                                  style: GoogleFonts.nunito( // Applies Nunito font from Google Fonts. // Wendet die Nunito-Schriftart von Google Fonts an.
                                    fontSize: 22, // Sets font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                                    color: const Color(0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochenweiß.
                                    fontWeight: FontWeight.w600, // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                                  ),
                                  children: <TextSpan>[ // List of additional text spans. // Liste zusätzlicher TextSpans.
                                    TextSpan( // Second part of the app title with underline. // Zweiter Teil des App-Titels mit Unterstreichung.
                                      text: 'work', // The text to display. // Der anzuzeigende Text.
                                      style: GoogleFonts.nunito( // Applies Nunito font styling. // Wendet Nunito-Schriftstil an.
                                        fontSize: 22, // Sets font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                                        color: const Color(0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochenweiß.
                                        decoration: TextDecoration.underline, // Adds underline decoration. // Fügt Unterstreichungsdekoration hinzu.
                                        decorationColor:
                                            const Color(0xffF2F2F2), // Sets underline color to off-white. // Setzt die Unterstreichungsfarbe auf Gebrochenweiß.
                                        decorationThickness: 3, // Sets underline thickness to 3. // Setzt die Unterstreichungsdicke auf 3.
                                        fontWeight: FontWeight.w600, // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                                      ),
                                    ),
                                    TextSpan( // Third part of the app title. // Dritter Teil des App-Titels.
                                      text: 'o.com ', // The text to display. // Der anzuzeigende Text.
                                      style: GoogleFonts.nunito( // Applies Nunito font styling. // Wendet Nunito-Schriftstil an.
                                          fontSize: 22, // Sets font size to 22 logical pixels. // Setzt die Schriftgröße auf 22 logische Pixel.
                                          color: const Color(0xffF2F2F2), // Sets text color to off-white. // Setzt die Textfarbe auf Gebrochenweiß.
                                          fontWeight: FontWeight.w600), // Sets font weight to semi-bold. // Setzt die Schriftstärke auf halbfett.
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tooltip( // Creates a tooltip that shows text when hovered. // Erstellt einen Tooltip, der Text anzeigt, wenn man darüber schwebt.
                          message: 'Chat with the developer', // Text shown in the tooltip. // Text, der im Tooltip angezeigt wird.
                          child: Semantics( // Adds semantic information for accessibility. // Fügt semantische Informationen für die Barrierefreiheit hinzu.
                            label: 'Toggle Dark Mode', // Accessibility label for screen readers. // Barrierefreiheit-Label für Screenreader.
                            enabled: true, // Marks the widget as enabled. // Markiert das Widget als aktiviert.
                            readOnly: true, // Marks the widget as read-only. // Markiert das Widget als schreibgeschützt.
                            child: Consumer( // Widget that can watch Riverpod providers. // Widget, das Riverpod-Provider überwachen kann.
                              builder: (context, watch, child) { // Builder function for Consumer. // Builder-Funktion für Consumer.
                                final userModel = ref.watch( // Watches the user model from provider. // Beobachtet das Benutzermodell vom Provider.
                                  userProvider,
                                );
                                if (user != null) { // Checks if a user is logged in. // Prüft, ob ein Benutzer angemeldet ist.
                                  if (userModel != null &&
                                      userModel.profilePic.isNotEmpty) { // Checks if user has a profile picture. // Prüft, ob der Benutzer ein Profilbild hat.
                                    return Consumer( // Another Consumer widget for nested provider watch. // Ein weiteres Consumer-Widget für die verschachtelte Provider-Beobachtung.
                                      builder: (context, ref, child) {
                                        return Padding( // Adds padding around the chat icon. // Fügt Polsterung um das Chat-Symbol hinzu.
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 18, 0), // Adds 18 logical pixels padding on the right. // Fügt 18 logische Pixel Polsterung auf der rechten Seite hinzu.
                                          child: IconButton( // Creates a button with an icon. // Erstellt eine Schaltfläche mit einem Symbol.
                                            icon: const Icon( // The icon to display. // Das anzuzeigende Symbol.
                                              CupertinoIcons.chat_bubble, // Chat bubble icon from Cupertino icons. // Chat-Blasen-Symbol aus Cupertino-Symbolen.
                                              color: Color(0xffF2F2F2), // Sets icon color to off-white. // Setzt die Symbolfarbe auf Gebrochenweiß.
                                              size: 28, // Sets icon size to 28 logical pixels. // Setzt die Symbolgröße auf 28 logische Pixel.
                                              semanticLabel: 'Toggle Dark Mode', // Accessibility label (inconsistent with tooltip). // Barrierefreiheit-Label (inkonsistent mit Tooltip).
                                            ),
                                            onPressed: () { // Function called when button is pressed. // Funktion, die beim Drücken der Schaltfläche aufgerufen wird.
                                              showCupertinoDialog( // Shows an iOS-style dialog. // Zeigt einen Dialog im iOS-Stil an.
                                                barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                                context: context, // Current build context. // Aktueller Build-Kontext.
                                                builder: (context) => // Builder for dialog content. // Builder für Dialog-Inhalt.

                                            ResponsiveShowDialogs( // Custom responsive dialog wrapper. // Benutzerdefinierter responsiver Dialog-Wrapper.
                                                    child: SimpleDialog( // Simple dialog with a title and content. // Einfacher Dialog mit einem Titel und Inhalt.
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0), // Sets dialog background to black. // Setzt den Dialog-Hintergrund auf Schwarz.
                                                      children: [ // List of widgets in the dialog. // Liste von Widgets im Dialog.
                                                        SizedBox( // Fixed size box for layout. // Festgelegtes Größenfeld für Layout.
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // Sets width to 40% of screen width. // Setzt die Breite auf 40% der Bildschirmbreite.
                                                          child:
                                                              const ContactDeveloper(), // Contact developer form widget. // Kontaktformular-Widget für Entwickler.
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else { // If user has no profile picture. // Wenn der Benutzer kein Profilbild hat.
                                    return const SizedBox( // Empty box of zero height. // Leeres Feld mit Höhe Null.
                                      height: 0,
                                    );
                                  }
                                } else { // If no user is logged in. // Wenn kein Benutzer angemeldet ist.
                                  return const SizedBox( // Empty box of zero height. // Leeres Feld mit Höhe Null.
                                    height: 0,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [ // Widgets to display in the app bar's action area. // Widgets, die im Aktionsbereich der App-Bar angezeigt werden sollen.
                      Row( // Horizontal arrangement of widgets. // Horizontale Anordnung von Widgets.
                        mainAxisAlignment: MainAxisAlignment.spaceAround, // Distributes space evenly between children. // Verteilt den Raum gleichmäßig zwischen den Kindern.
                        children: [
                          Tooltip( // Settings tooltip. // Einstellungen-Tooltip.
                            message: 'Settings', // Text shown when hovered. // Text, der beim Darüberfahren angezeigt wird.
                            child: Semantics( // Accessibility wrapper. // Wrapper für Barrierefreiheit.
                              label: 'Pomodoro timer settings', // Screen reader label. // Screenreader-Label.
                              enabled: true, // Widget is enabled. // Widget ist aktiviert.
                              readOnly: true, // Widget is read-only. // Widget ist schreibgeschützt.
                              child: IconButton( // Button with an icon. // Schaltfläche mit einem Symbol.
                                icon: const Icon( // The icon to display. // Das anzuzeigende Symbol.
                                  CupertinoIcons.gear_alt, // Gear/settings icon. // Zahnrad/Einstellungen-Symbol.
                                  color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                  size: 28, // Icon size is 28 logical pixels. // Symbolgröße ist 28 logische Pixel.
                                  semanticLabel: 'Pomodoro timer Settings', // Screen reader description. // Screenreader-Beschreibung.
                                ),
                                onPressed: () { // Function called when pressed. // Funktion, die beim Drücken aufgerufen wird.
                                  Routemaster.of(context)
                                      .push('/pomodoro-technique-settings'); // Navigates to settings page. // Navigiert zur Einstellungsseite.
                                },
                              ),
                            ),
                          ),
                          GestureDetector( // Detects gestures (here, for tap position). // Erkennt Gesten (hier für Tipp-Position).
                            behavior: HitTestBehavior.translucent, // Makes entire area respond to touches. // Lässt den gesamten Bereich auf Berührungen reagieren.
                            onTapDown: (details) { // Called when tap begins, with position details. // Wird aufgerufen, wenn ein Tipp beginnt, mit Positionsdetails.
                              tapOffset = details.globalPosition; // Stores the tap position. // Speichert die Tipp-Position.
                            },
                            child: IconButton( // Button with analytics icon. // Schaltfläche mit Analysen-Symbol.
                              onPressed: () { // Function called when pressed. // Funktion, die beim Drücken aufgerufen wird.
                                Routemaster.of(context)
                                    .push('/time-management-analytics'); // Navigates to analytics page. // Navigiert zur Analyseseite.
                              },
                              icon: Tooltip( // Tooltip for the analytics icon. // Tooltip für das Analysen-Symbol.
                                message: 'Analytics', // Tooltip text. // Tooltip-Text.
                                child: Semantics( // Accessibility wrapper. // Wrapper für Barrierefreiheit.
                                  label: 'Pomodoro timer 2023 Analytics', // Screen reader label. // Screenreader-Label.
                                  enabled: true, // Widget is enabled. // Widget ist aktiviert.
                                  readOnly: true, // Widget is read-only. // Widget ist schreibgeschützt.
                                  child: const Icon( // The analytics icon. // Das Analysen-Symbol.
                                    CupertinoIcons.chart_bar, // Bar chart icon. // Balkendiagramm-Symbol.
                                    color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                    size: 28, // Icon size is 28 logical pixels. // Symbolgröße ist 28 logische Pixel.
                                    semanticLabel: 'Pomodoro timer More', // Screen reader description (inconsistent with visual). // Screenreader-Beschreibung (inkonsistent mit visuell).
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector( // Detects gestures for the profile menu. // Erkennt Gesten für das Profilmenü.
                            behavior: HitTestBehavior.translucent, // Makes entire area respond to touches. // Lässt den gesamten Bereich auf Berührungen reagieren.
                            onTapDown: (details) { // Called when tap begins. // Wird aufgerufen, wenn ein Tipp beginnt.
                              ref.read(tapOffsetProvider.notifier).state =
                                  details.globalPosition; // Stores tap position in the provider. // Speichert die Tipp-Position im Provider.
                            },
                            child: Semantics( // Accessibility wrapper. // Wrapper für Barrierefreiheit.
                              label: 'Pomodoro timer profile', // Screen reader label. // Screenreader-Label.
                              enabled: true, // Widget is enabled. // Widget ist aktiviert.
                              readOnly: true, // Widget is read-only. // Widget ist schreibgeschützt.
                              child: IconButton( // Profile menu button. // Profilmenü-Schaltfläche.
                                onPressed: () { // Function called when pressed. // Funktion, die beim Drücken aufgerufen wird.
                                  final tapOffset = ref.read(tapOffsetProvider); // Gets the stored tap position. // Holt die gespeicherte Tipp-Position.
                                  final userModel = ref.read( // Gets the user model. // Holt das Benutzermodell.
                                    userProvider,
                                  );
                                  List<PopupMenuItem> menuItems; // List for menu items. // Liste für Menüpunkte.

                                  if (userModel != null) { // If user is logged in. // Wenn der Benutzer angemeldet ist.
                                    menuItems = [ // Menu items for logged-in users. // Menüpunkte für angemeldete Benutzer.
                                      PopupMenuItem( // Logout menu item. // Abmelden-Menüpunkt.
                                        child: ListTile( // List tile for the menu item. // Listenelement für den Menüpunkt.
                                            title: Text( // Menu item text. // Menüpunkt-Text.
                                              'Log out', // Text to display. // Anzuzeigender Text.
                                              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                                                color: const Color(0xffF2F2F2), // Text color is off-white. // Textfarbe ist Gebrochenweiß.
                                                fontSize: 16.0, // Font size is 16 logical pixels. // Schriftgröße ist 16 logische Pixel.
                                                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                              ),
                                            ),
                                            trailing: const Icon( // Icon at the end of the list tile. // Symbol am Ende des Listenelements.
                                              Icons.logout_outlined, // Logout icon. // Abmelden-Symbol.
                                              color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                              size: 20, // Icon size is 20 logical pixels. // Symbolgröße ist 20 logische Pixel.
                                              semanticLabel:
                                                  'Pomodoro timer Log out', // Screen reader description. // Screenreader-Beschreibung.
                                            ),
                                            contentPadding: EdgeInsets.zero, // Removes default padding. // Entfernt die Standardpolsterung.
                                            onTap: () { // Function called when tapped. // Funktion, die beim Tippen aufgerufen wird.
                                              ref
                                                  .read(authRepositoryProvider)
                                                  .signOut(ref); // Signs out the user. // Meldet den Benutzer ab.
                                              ref
                                                  .read(userProvider.notifier)
                                                  .state = null; // Clears user state. // Löscht den Benutzerzustand.

                                              Navigator.of(context).pop(); // Closes the menu. // Schließt das Menü.
                                            }),
                                      ),
                                      if (user != null &&
                                          user.isPremium == true) // Conditional menu item for premium users. // Bedingter Menüpunkt für Premium-Benutzer.
                                        PopupMenuItem( // Subscription details menu item. // Abonnementdetails-Menüpunkt.
                                          child: ListTile( // List tile for subscription details. // Listenelement für Abonnementdetails.
                                            title: Text( // Menu item text. // Menüpunkt-Text.
                                              'Subscription details', // Text to display. // Anzuzeigender Text.
                                              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                                                color: const Color(0xffF2F2F2), // Text color is off-white. // Textfarbe ist Gebrochenweiß.
                                                fontSize: 16.0, // Font size is 16 logical pixels. // Schriftgröße ist 16 logische Pixel.
                                                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                              ),
                                            ),
                                            trailing: const Icon( // Icon at the end of the list tile. // Symbol am Ende des Listenelements.
                                              CupertinoIcons.doc_text_search, // Document search icon. // Dokumentensuche-Symbol.
                                              color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                              size: 20, // Icon size is 20 logical pixels. // Symbolgröße ist 20 logische Pixel.
                                              semanticLabel:
                                                  'Pomodoro timer premium feature', // Screen reader description. // Screenreader-Beschreibung.
                                            ),
                                            contentPadding: EdgeInsets.zero, // Removes default padding. // Entfernt die Standardpolsterung.
                                            onTap: () { // Function called when tapped. // Funktion, die beim Tippen aufgerufen wird.
                                              Navigator.of(context).pop(); // Closes the menu. // Schließt das Menü.
                                              showCupertinoDialog( // Shows subscription details dialog. // Zeigt den Dialog mit Abonnementdetails an.
                                                barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                                context: context, // Current build context. // Aktueller Build-Kontext.
                                                builder:
                                                    (BuildContext context) { // Builder for dialog content. // Builder für Dialog-Inhalt.
                                                  return ResponsiveShowDialogs( // Responsive dialog wrapper. // Responsiver Dialog-Wrapper.
                                                    child: SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0), // Dialog background is black. // Dialog-Hintergrund ist Schwarz.
                                                      children: [ // Dialog children. // Dialog-Kinder.
                                                        SizedBox( // Fixed size box. // Festgelegtes Größenfeld.
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // Width is 40% of screen width. // Breite ist 40% der Bildschirmbreite.
                                                          child:
                                                              const SubscriptionDetails(), // Subscription details widget. // Abonnementdetails-Widget.
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (user != null &&
                                          user.isPremium == false) // Conditional menu item for non-premium users. // Bedingter Menüpunkt für Nicht-Premium-Benutzer.
                                        PopupMenuItem( // Premium features menu item. // Premium-Funktionen-Menüpunkt.
                                          child: ListTile( // List tile for premium features. // Listenelement für Premium-Funktionen.
                                            title: Text( // Menu item text. // Menüpunkt-Text.
                                              'Premium ', // Text to display. // Anzuzeigender Text.
                                              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                                                color: const Color(0xffF2F2F2), // Text color is off-white. // Textfarbe ist Gebrochenweiß.
                                                fontSize: 16.0, // Font size is 16 logical pixels. // Schriftgröße ist 16 logische Pixel.
                                                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                              ),
                                            ),
                                            trailing: const Icon( // Icon at the end of the list tile. // Symbol am Ende des Listenelements.
                                              CupertinoIcons.checkmark_seal, // Checkmark seal icon. // Häkchen-Siegel-Symbol.
                                              color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                              size: 20, // Icon size is 20 logical pixels. // Symbolgröße ist 20 logische Pixel.
                                              semanticLabel:
                                                  'Pomodoro timer premium feature', // Screen reader description. // Screenreader-Beschreibung.
                                            ),
                                            contentPadding: EdgeInsets.zero, // Removes default padding. // Entfernt die Standardpolsterung.
                                            onTap: () { // Function called when tapped. // Funktion, die beim Tippen aufgerufen wird.
                                              Navigator.of(context).pop(); // Closes the menu. // Schließt das Menü.
                                              showCupertinoDialog( // Shows premium features dialog. // Zeigt den Dialog für Premium-Funktionen an.
                                                barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                                context: context, // Current build context. // Aktueller Build-Kontext.
                                                builder:
                                                    (BuildContext context) { // Builder for dialog content. // Builder für Dialog-Inhalt.
                                                  return ResponsiveShowDialogs( // Responsive dialog wrapper. // Responsiver Dialog-Wrapper.
                                                    child: SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              0, 0, 0, 0), // Transparent dialog background. // Transparenter Dialog-Hintergrund.
                                                      children: [ // Dialog children. // Dialog-Kinder.
                                                        SizedBox( // Fixed size box. // Festgelegtes Größenfeld.
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // Width is 40% of screen width. // Breite ist 40% der Bildschirmbreite.
                                                          child:
                                                              const PremiumReadySoon(), // Widget for upcoming premium features. // Widget für kommende Premium-Funktionen.
                                                        
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (user != null &&
                                          user.isPremium == true) // Conditional menu item for premium users. // Bedingter Menüpunkt für Premium-Benutzer.
                                        PopupMenuItem( // Delete account menu item for premium users. // Konto löschen-Menüpunkt für Premium-Benutzer.
                                          child: ListTile( // List tile for delete account. // Listenelement für Konto löschen.
                                            title: Text( // Menu item text. // Menüpunkt-Text.
                                              'Delete account', // Text to display. // Anzuzeigender Text.
                                              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                                                color: const Color(0xffF2F2F2), // Text color is off-white. // Textfarbe ist Gebrochenweiß.
                                                fontSize: 16.0, // Font size is 16 logical pixels. // Schriftgröße ist 16 logische Pixel.
                                                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                              ),
                                            ),
                                            trailing: const Icon( // Icon at the end of the list tile. // Symbol am Ende des Listenelements.
                                              CupertinoIcons.trash, // Trash/delete icon. // Papierkorb/Löschen-Symbol.
                                              color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                              size: 20, // Icon size is 20 logical pixels. // Symbolgröße ist 20 logische Pixel.
                                              semanticLabel:
                                                  'Pomodoro timer Delete account', // Screen reader description. // Screenreader-Beschreibung.
                                            ),
                                            contentPadding: EdgeInsets.zero, // Removes default padding. // Entfernt die Standardpolsterung.
                                            onTap: () { // Function called when tapped. // Funktion, die beim Tippen aufgerufen wird.
                                              Navigator.of(context).pop(); // Closes the menu. // Schließt das Menü.
                                              showCupertinoDialog( // Shows delete account dialog for premium users. // Zeigt den Dialog zum Löschen des Kontos für Premium-Benutzer an.
                                                barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                                context: context, // Current build context. // Aktueller Build-Kontext.
                                                builder:
                                                    (BuildContext context) { // Builder for dialog content. // Builder für Dialog-Inhalt.
                                                  return ResponsiveShowDialogs( // Responsive dialog wrapper. // Responsiver Dialog-Wrapper.
                                                    child: SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0), // Dialog background is black. // Dialog-Hintergrund ist Schwarz.
                                                      children: [ // Dialog children. // Dialog-Kinder.
                                                        SizedBox( // Fixed size box. // Festgelegtes Größenfeld.
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // Width is 40% of screen width. // Breite ist 40% der Bildschirmbreite.
                                                          child:
                                                              const DeleteAccountPremium(), // Widget for deleting a premium account. // Widget zum Löschen eines Premium-Kontos.
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (user != null &&
                                          user.isPremium == false) // Conditional menu item for non-premium users. // Bedingter Menüpunkt für Nicht-Premium-Benutzer.
                                        PopupMenuItem( // Delete account menu item for non-premium users. // Konto löschen-Menüpunkt für Nicht-Premium-Benutzer.
                                          child: ListTile( // List tile for delete account. // Listenelement für Konto löschen.
                                            title: Text( // Menu item text. // Menüpunkt-Text.
                                              'Delete account', // Text to display. // Anzuzeigender Text.
                                              style: GoogleFonts.nunito( // Nunito font styling. // Nunito-Schriftstil.
                                                color: const Color(0xffF2F2F2), // Text color is off-white. // Textfarbe ist Gebrochenweiß.
                                                fontSize: 16.0, // Font size is 16 logical pixels. // Schriftgröße ist 16 logische Pixel.
                                                fontWeight: FontWeight.w500, // Medium font weight. // Mittlere Schriftstärke.
                                              ),
                                            ),
                                            trailing: const Icon( // Icon at the end of the list tile. // Symbol am Ende des Listenelements.
                                              CupertinoIcons.trash, // Trash/delete icon. // Papierkorb/Löschen-Symbol.
                                              color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                              size: 20, // Icon size is 20 logical pixels. // Symbolgröße ist 20 logische Pixel.
                                              semanticLabel:
                                                  'Pomodoro timer Delete account', // Screen reader description. // Screenreader-Beschreibung.
                                            ),
                                            contentPadding: EdgeInsets.zero, // Removes default padding. // Entfernt die Standardpolsterung.
                                            onTap: () { // Function called when tapped. // Funktion, die beim Tippen aufgerufen wird.
                                              Navigator.of(context).pop(); // Closes the menu. // Schließt das Menü.
                                              showCupertinoDialog( // Shows delete account dialog for non-premium users. // Zeigt den Dialog zum Löschen des Kontos für Nicht-Premium-Benutzer an.
                                                barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                                context: context, // Current build context. // Aktueller Build-Kontext.
                                                builder:
                                                    (BuildContext context) { // Builder for dialog content. // Builder für Dialog-Inhalt.
                                                  return ResponsiveShowDialogs( // Responsive dialog wrapper. // Responsiver Dialog-Wrapper.
                                                    child: SimpleDialog( // Simple dialog widget. // Einfaches Dialog-Widget.
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0), // Dialog background is black. // Dialog-Hintergrund ist Schwarz.
                                                      children: [ // Dialog children. // Dialog-Kinder.
                                                        SizedBox( // Fixed size box. // Festgelegtes Größenfeld.
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // Width is 40% of screen width. // Breite ist 40% der Bildschirmbreite.
                                                          child:
                                                              const DeleteAccountNoPremium(), // Widget for deleting a non-premium account. // Widget zum Löschen eines Nicht-Premium-Kontos.
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )
                                    ];
                                  } else { // If no user is logged in. // Wenn kein Benutzer angemeldet ist.
                                    menuItems = []; // Empty menu items list. // Leere Menüpunkte-Liste.
                                  }
                                  showMenu( // Shows the popup menu. // Zeigt das Popup-Menü an.
                                    color: const Color.fromARGB(255, 0, 0, 0), // Menu background is black. // Menü-Hintergrund ist Schwarz.
                                    position: RelativeRect.fromLTRB( // Position of the menu. // Position des Menüs.
                                      tapOffset!.dx - 150, // X position adjusted left by 150 pixels. // X-Position um 150 Pixel nach links angepasst.
                                      64, // Y position from top. // Y-Position von oben.
                                      tapOffset.dx, // Right edge at tap position. // Rechter Rand an der Tipp-Position.
                                      0, // Bottom edge constraint (0 means no constraint). // Unterer Rand-Beschränkung (0 bedeutet keine Beschränkung).
                                    ),
                                    constraints: const BoxConstraints( // Constraints for the menu. // Beschränkungen für das Menü.
                                      maxWidth: 600, // Maximum width of 600 logical pixels. // Maximale Breite von 600 logischen Pixeln.
                                    ),
                                    context: context, // Current build context. // Aktueller Build-Kontext.
                                    shape: RoundedRectangleBorder( // Shape of the menu. // Form des Menüs.
                                      borderRadius: BorderRadius.circular(10), // Rounded corners with 10 logical pixel radius. // Abgerundete Ecken mit 10 logischen Pixeln Radius.
                                    ),
                                    items: menuItems, // Menu items to display. // Anzuzeigende Menüpunkte.
                                  );
                                },
                                icon: Consumer( // Icon widget with Riverpod consumer. // Symbol-Widget mit Riverpod-Consumer.
                                  builder: (context, read, child) { // Builder function for Consumer. // Builder-Funktion für Consumer.
                                    final userModel = ref.watch( // Watches user model from provider. // Beobachtet das Benutzermodell vom Provider.
                                      userProvider,
                                    );

                                    if (userModel != null &&
                                        userModel.profilePic.isNotEmpty) { // If user has a profile picture. // Wenn der Benutzer ein Profilbild hat.
                                      return CircleAvatar( // Circular avatar for profile picture. // Kreisförmiger Avatar für Profilbild.
                                        radius: 16.5, // Avatar radius is 16.5 logical pixels. // Avatar-Radius ist 16,5 logische Pixel.
                                        backgroundImage:
                                            NetworkImage(userModel.profilePic), // Profile picture from network URL. // Profilbild von Netzwerk-URL.
                                      );
                                    } else { // If no profile picture or no user. // Wenn kein Profilbild oder kein Benutzer.
                                      return Semantics( // Accessibility wrapper. // Wrapper für Barrierefreiheit.
                                        label: 'Pomodoro timer Log in', // Screen reader label. // Screenreader-Label.
                                        enabled: true, // Widget is enabled. // Widget ist aktiviert.
                                        readOnly: true, // Widget is read-only. // Widget ist schreibgeschützt.
                                        child: Tooltip( // Tooltip for login icon. // Tooltip für das Anmelden-Symbol.
                                          message: 'Log in', // Tooltip text. // Tooltip-Text.
                                          child: IconButton( // Button with person icon. // Schaltfläche mit Personen-Symbol.
                                            icon: const Icon( // The icon to display. // Das anzuzeigende Symbol.
                                              Icons.person_outline_outlined, // Person outline icon. // Personenumriss-Symbol.
                                              size: 28, // Icon size is 28 logical pixels. // Symbolgröße ist 28 logische Pixel.
                                              color: Color(0xffF2F2F2), // Icon color is off-white. // Symbolfarbe ist Gebrochenweiß.
                                            ),
                                            onPressed: () { // Function called when pressed. // Funktion, die beim Drücken aufgerufen wird.
                                              showCupertinoDialog( // Shows login dialog. // Zeigt den Anmeldedialog an.
                                                barrierDismissible: true, // Dialog can be dismissed by tapping outside. // Dialog kann durch Tippen außerhalb geschlossen werden.
                                                context: context, // Current build context. // Aktueller Build-Kontext.
                                                builder: (context) =>
                                                    CupertinoAlertDialog( // iOS-style alert dialog. // Dialog im iOS-Stil.
                                                  title: const Text( // Dialog title. // Dialog-Titel.
                                                    'Log in', // Title text. // Titel-Text.
                                                    style: TextStyle( // Style for the title. // Stil für den Titel.
                                                        fontWeight:
                                                            FontWeight.bold, // Bold font weight. // Fette Schriftstärke.
                                                        fontSize: 18, // Font size is 18 logical pixels. // Schriftgröße ist 18 logische Pixel.
                                                        fontFamily:
                                                            'San Francisco'), // iOS system font. // iOS-Systemschriftart.
                                                  ),
                                                  content:
                                                      const LoginGoogleScreen(), // Google login screen widget. // Google-Anmeldebildschirm-Widget.
                                                  actions: [ // Dialog actions. // Dialog-Aktionen.
                                                    CupertinoDialogAction( // iOS-style dialog action. // Dialog-Aktion im iOS-Stil.
                                                      child: const Text( // Action button text. // Aktionsschaltflächen-Text.
                                                        "Cancel", // Text to display. // Anzuzeigender Text.
                                                        style: TextStyle( // Style for the button text. // Stil für den Schaltflächentext.
                                                          fontWeight:
                                                              FontWeight.bold, // Bold font weight. // Fette Schriftstärke.
                                                          fontSize: 18, // Font size is 18 logical pixels. // Schriftgröße ist 18 logische Pixel.
                                                          fontFamily:
                                                              'San Francisco', // iOS system font. // iOS-Systemschriftart.
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255), // Text color is white. // Textfarbe ist Weiß.
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(), // Closes the dialog. // Schließt den Dialog.
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 13), // Empty space with width 13 logical pixels. // Leerer Raum mit 13 logischen Pixeln Breite.
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
