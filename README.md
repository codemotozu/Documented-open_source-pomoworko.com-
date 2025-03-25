# Pomoworko - Modern Pomodoro Timer Application

<div align="center">
  <a href="https://pomoworko.com/">
    <img src="https://github.com/codemotozu/Documented-open_source-pomoworko.com-/blob/main/assets/images/logo_primary.png" width="200" alt="Pomoworko Logo">
  </a>
</div>

## 🌍 Languages | Sprachen

- [English](#english)
- [Deutsch](#deutsch)

---

<a id="english"></a>

# 📱 Pomoworko - Pomodoro Timer Application [English]

A modern, cross-platform Pomodoro Timer application built with Flutter that helps users manage their time efficiently using the Pomodoro Technique.

## 📋 Features

- **📊 Customizable Pomodoro Timer**: Configure work intervals, short breaks, and long breaks according to your preferences
- **🎨 Personalized UI**: Choose colors for different timer states
- **📝 Task Management**: Create, edit, and manage tasks with a built-in to-do list
- **📈 Analytics Dashboard**: Track your productivity with visual charts
- **🔔 Notifications**: Browser and system notifications for timer events
- **⚙️ Multiple Sound Options**: Choose from different alarm sounds
- **📱 Cross-Platform**: Works on web, mobile, and desktop platforms
- **☁️ Cloud Synchronization**: Save your settings and progress with Google Sign-In
- **📊 Project Time Tracking**: Track time spent on different projects
- **🌙 Dark Mode**: Optimized UI for low-light environments

## 🔧 Technical Implementation

### Architecture & Design Patterns

- **Clean Architecture**: Separation of concerns with layers for presentation, domain, and data
- **Repository Pattern**: Abstracted data access with repositories
- **State Management**: Used Riverpod for efficient, scalable state management
- **Responsive Design**: Adapts to different screen sizes with responsive layouts

### Tech Stack

- **Frontend**: Flutter, Dart
- **Backend**: Node.js, Express.js
- **Database**: MongoDB
- **Authentication**: Google Sign-In, JWT
- **State Management**: Riverpod
- **Storage**: Hive for local storage, MongoDB for cloud storage
- **Notifications**: Browser notifications API
- **Scheduling**: Agenda.js for job scheduling

### Code Organization

The codebase is organized into several key directories:

- **`lib/`**: Main application code
  - **`common/`**: Shared utilities, widgets, and models
  - **`presentation/`**: UI components and state management
  - **`infrastructure/`**: Data sources and external services
  - **`models/`**: Data models for the application
- **`server/`**: Backend implementation
  - **`models/`**: Database schemas
  - **`routes/`**: API endpoints
  - **`middlewares/`**: Auth and other middleware
  - **`config/`**: Server configuration

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Node.js and npm
- MongoDB
- Git
- Google Cloud Console project (for Google Sign-In)

### Google Sign-In Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Navigate to "APIs & Services" > "Credentials"
4. Create an OAuth 2.0 Client ID for a Web Application
5. Add authorized JavaScript origins for your local development:
   - `http://localhost:3000`
6. Add the client ID to your web/index.html file in the head section:
```html
<meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
```

### Installation

1. Download this repository:
```bash
git clone https://github.com/codemotozu/Documented-open_source-pomoworko.com-.git
```

2. Create a new Flutter project:
```bash
flutter create pomoworko_app
cd pomoworko_app
```

3. Replace and add the necessary directories:
```bash
# Replace the lib directory
rm -rf lib/
cp -r ../Documented-open_source-pomoworko.com-/lib ./

# Add the server directory
cp -r ../Documented-open_source-pomoworko.com-/server ./

# Add the assets directory
mkdir -p assets
cp -r ../Documented-open_source-pomoworko.com-/assets ./

# Replace pubspec.yaml
cp ../Documented-open_source-pomoworko.com-/pubspec.yaml ./
```

4. Install dependencies:
```bash
flutter pub get
cd server
npm install
```

5. Set up environment variables for the server:
   - Create a `.env` file in the server directory:
```
MONGO_DB_URL=your_mongodb_url
ACCESS_TOKEN_SECRET=your_jwt_secret
PORT=3001
```

6. Start the server:
```bash
npm start
```

7. In a new terminal, run the Flutter application with the specific port:
```bash
cd ..
flutter run -d chrome --web-port=3000
```

**Note:** The port number (3000) is important for Google Sign-In to work properly as it should match the authorized origins you set up in Google Cloud Console. You can choose a different port, but make sure to update your Google Cloud Console configuration accordingly.

## 📦 Deployment

The application can be deployed as:

- Web application on platforms like Firebase Hosting or Vercel
- Mobile app on iOS and Android app stores
- Desktop application for Windows, macOS, and Linux

## 🔮 Future Enhancements

- Enhanced analytics with detailed productivity reports
- Integration with calendar apps
- Team collaboration features
- Custom timer sounds upload
- Offline mode improvements

---

<a id="deutsch"></a>

# 📱 Pomoworko - Pomodoro-Timer-Anwendung [Deutsch]

Eine moderne, plattformübergreifende Pomodoro-Timer-Anwendung, entwickelt mit Flutter, die Benutzern hilft, ihre Zeit mit der Pomodoro-Technik effizient zu verwalten.

## 📋 Funktionen

- **📊 Anpassbarer Pomodoro-Timer**: Konfigurieren Sie Arbeitsintervalle, kurze Pausen und lange Pausen nach Ihren Vorlieben
- **🎨 Personalisierte Benutzeroberfläche**: Wählen Sie Farben für verschiedene Timer-Zustände
- **📝 Aufgabenverwaltung**: Erstellen, bearbeiten und verwalten Sie Aufgaben mit einer integrierten To-Do-Liste
- **📈 Analyse-Dashboard**: Verfolgen Sie Ihre Produktivität mit visuellen Diagrammen
- **🔔 Benachrichtigungen**: Browser- und Systembenachrichtigungen für Timer-Ereignisse
- **⚙️ Mehrere Tonoptionen**: Wählen Sie aus verschiedenen Alarmtönen
- **📱 Plattformübergreifend**: Funktioniert auf Web-, Mobil- und Desktop-Plattformen
- **☁️ Cloud-Synchronisierung**: Speichern Sie Ihre Einstellungen und Fortschritte mit Google Sign-In
- **📊 Projekt-Zeiterfassung**: Verfolgen Sie die Zeit, die für verschiedene Projekte aufgewendet wird
- **🌙 Dunkelmodus**: Optimierte Benutzeroberfläche für Umgebungen mit wenig Licht

## 🔧 Technische Umsetzung

### Architektur & Design-Muster

- **Clean Architecture**: Trennung der Zuständigkeiten mit Schichten für Präsentation, Domäne und Daten
- **Repository-Muster**: Abstrahierter Datenzugriff mit Repositories
- **Zustandsverwaltung**: Verwendung von Riverpod für effiziente, skalierbare Zustandsverwaltung
- **Responsives Design**: Passt sich mit responsiven Layouts an verschiedene Bildschirmgrößen an

### Technologie-Stack

- **Frontend**: Flutter, Dart
- **Backend**: Node.js, Express.js
- **Datenbank**: MongoDB
- **Authentifizierung**: Google Sign-In, JWT
- **Zustandsverwaltung**: Riverpod
- **Speicherung**: Hive für lokale Speicherung, MongoDB für Cloud-Speicherung
- **Benachrichtigungen**: Browser-Benachrichtigungs-API
- **Zeitplanung**: Agenda.js für Job-Scheduling

### Code-Organisation

Der Quellcode ist in mehrere Schlüsselverzeichnisse organisiert:

- **`lib/`**: Hauptanwendungscode
  - **`common/`**: Gemeinsam genutzte Dienstprogramme, Widgets und Modelle
  - **`presentation/`**: UI-Komponenten und Zustandsverwaltung
  - **`infrastructure/`**: Datenquellen und externe Dienste
  - **`models/`**: Datenmodelle für die Anwendung
- **`server/`**: Backend-Implementierung
  - **`models/`**: Datenbankschemata
  - **`routes/`**: API-Endpunkte
  - **`middlewares/`**: Auth und andere Middleware
  - **`config/`**: Server-Konfiguration

## 🚀 Erste Schritte

### Voraussetzungen

- Flutter SDK (neueste Version)
- Node.js und npm
- MongoDB
- Git

### Installation

1. Laden Sie dieses Repository herunter:
```bash
git clone https://github.com/codemotozu/Documented-open_source-pomoworko.com-.git
```

2. Erstellen Sie ein neues Flutter-Projekt:
```bash
flutter create pomoworko_app
cd pomoworko_app
```

3. Ersetzen und fügen Sie die notwendigen Verzeichnisse hinzu:
```bash
# Ersetzen Sie das lib-Verzeichnis
rm -rf lib/
cp -r ../Documented-open_source-pomoworko.com-/lib ./

# Fügen Sie das Server-Verzeichnis hinzu
cp -r ../Documented-open_source-pomoworko.com-/server ./

# Fügen Sie das Assets-Verzeichnis hinzu
mkdir -p assets
cp -r ../Documented-open_source-pomoworko.com-/assets ./

# Ersetzen Sie pubspec.yaml
cp ../Documented-open_source-pomoworko.com-/pubspec.yaml ./
```

4. Installieren Sie Abhängigkeiten:
```bash
flutter pub get
cd server
npm install
```

5. Richten Sie Umgebungsvariablen für den Server ein:
   - Erstellen Sie eine `.env`-Datei im Server-Verzeichnis:
```
MONGO_DB_URL=ihre_mongodb_url
ACCESS_TOKEN_SECRET=ihr_jwt_geheimnis
PORT=3001
```

6. Starten Sie den Server:
```bash
npm start
```

7. Öffnen Sie ein neues Terminal und führen Sie die Flutter-Anwendung aus:
```bash
cd ..
flutter run -d chrome
```

## 📦 Bereitstellung

Die Anwendung kann bereitgestellt werden als:

- Webanwendung auf Plattformen wie Firebase Hosting oder Vercel
- Mobile App in iOS- und Android-App-Stores
- Desktop-Anwendung für Windows, macOS und Linux

## 🔮 Zukünftige Erweiterungen

- Erweiterte Analysen mit detaillierten Produktivitätsberichten
- Integration mit Kalender-Apps
- Funktionen zur Teamzusammenarbeit
- Upload benutzerdefinierter Timer-Töne
- Verbesserungen im Offline-Modus
