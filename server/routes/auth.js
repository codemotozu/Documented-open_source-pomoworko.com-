/// AuthRouter
/// 
/// A comprehensive Express router that handles user authentication, account management, and productivity features. // Ein umfassender Express-Router, der Benutzerauthentifizierung, Kontoverwaltung und Produktivitätsfunktionen verwaltet.
/// Manages user signup, login, settings updates, time tracking, and Pomodoro timer configurations. // Verwaltet Benutzerregistrierung, Anmeldung, Einstellungsaktualisierungen, Zeiterfassung und Pomodoro-Timer-Konfigurationen.
/// 
/// Usage:
/// ```javascript
/// const express = require("express");
/// const app = express();
/// const authRouter = require("./routes/auth");
/// 
/// app.use("/auth", authRouter);
/// ```
/// 
/// EN: Provides a complete authentication and user settings management system for a productivity application with Pomodoro timer, project tracking, and time management features.
/// DE: Bietet ein vollständiges Authentifizierungs- und Benutzerkonfigurationssystem für eine Produktivitätsanwendung mit Pomodoro-Timer, Projektverfolgung und Zeitmanagementfunktionen.

const express = require("express");  // Import Express framework.  // Express-Framework importieren.
const User = require("../models/user");  // Import User model.  // Benutzer-Modell importieren.
const jwt = require("jsonwebtoken");  // Import JSON Web Token for authentication.  // JSON Web Token für Authentifizierung importieren.
const moment = require("moment-timezone");  // Import Moment-Timezone for time handling.  // Moment-Timezone für Zeitverwaltung importieren.
const agendaInstance = require("../config/agenda-config");  // Import agenda instance for job scheduling.  // Agenda-Instanz für Aufgabenplanung importieren.
const auth = require("../middlewares/auth");  // Import authentication middleware.  // Authentifizierungs-Middleware importieren.
const authRouter = express.Router();  // Create a new router instance.  // Eine neue Router-Instanz erstellen.
const cron = require("node-cron");  // Import node-cron for scheduled tasks.  // Node-Cron für geplante Aufgaben importieren.
let cronJobs = {};  // Store active cron jobs.  // Aktive Cron-Jobs speichern.
let cronJobForTimeZones = {};  // Store cron jobs per timezone.  // Cron-Jobs für verschiedene Zeitzonen speichern.

authRouter.post("/api/signup", async (req, res) => {  // Define a POST route for user signup.  // Eine POST-Route für die Benutzerregistrierung definieren.
  try {  // Start try block to catch errors.  // Startet einen Try-Block, um Fehler abzufangen.
    const { name, email, profilePic } = req.body;  // Extract name, email, and profilePic from request body.  // Extrahiert Name, E-Mail und Profilbild aus dem Anfrage-Body.
    let user = await User.findOne({ email });  // Check if the user already exists in the database.  // Überprüft, ob der Benutzer bereits in der Datenbank existiert.

    if (!user) {  // If user does not exist, create a new user.  // Falls der Benutzer nicht existiert, erstelle einen neuen Benutzer.
      user = new User({  // Instantiate a new User object.  // Erstellt ein neues Benutzer-Objekt.
        email,  // Assign email.  // Weist die E-Mail zu.
        profilePic,  // Assign profile picture.  // Weist das Profilbild zu.
        name,  // Assign name.  // Weist den Namen zu.
        userLocalTimeZone: moment()  // Store user's local timezone.  // Speichert die lokale Zeitzone des Benutzers.
          .tz(Intl.DateTimeFormat().resolvedOptions().timeZone)  // Get timezone from system settings.  // Holt die Zeitzone aus den Systemeinstellungen.
          .format(),  // Format timezone as string.  // Formatiert die Zeitzone als Zeichenkette.
        iana: Intl.DateTimeFormat().resolvedOptions().timeZone,  // Store IANA timezone.  // Speichert die IANA-Zeitzone.
        currentTimeZoneVersion: `${moment.tz.version}-${moment.tz.dataVersion}`,  // Store Moment.js timezone version.  // Speichert die Moment.js-Zeitzonen-Version.
        convertUserLocalTimeZoneToUTC: moment()  // Convert local timezone to UTC.  // Konvertiert die lokale Zeitzone in UTC.
          .tz(Intl.DateTimeFormat().resolvedOptions().timeZone)  // Get system timezone.  // Holt die System-Zeitzone.
          .utc()  // Convert to UTC.  // Konvertiert in UTC.
          .format(),  // Format as string.  // Formatiert als Zeichenkette.
        isPremium: false,  // Set user as non-premium by default.  // Standardmäßig als Nicht-Premium-Benutzer festlegen.
        subscriptionStatusPending: true,  // Mark subscription as pending.  // Markiert das Abonnement als ausstehend.
        suscriptionStatusCancelled: false,  // Subscription is not canceled initially.  // Das Abonnement ist anfangs nicht storniert.
        subscriptionStatusConfirmed: false,  // Subscription is not confirmed initially.  // Das Abonnement ist anfangs nicht bestätigt.
        pomodoroTimer: 25,  // Set Pomodoro timer to 25 minutes.  // Setzt den Pomodoro-Timer auf 25 Minuten.
        shortBreakTimer: 5,  // Set short break timer to 5 minutes.  // Setzt den Kurzpausen-Timer auf 5 Minuten.
        longBreakTimer: 15,  // Set long break timer to 15 minutes.  // Setzt den Langpausen-Timer auf 15 Minuten.
        longBreakInterval: 4,  // Set long break interval to 4 cycles.  // Setzt das Langpausen-Intervall auf 4 Zyklen.
        selectedSound: "assets/sounds/Flashpoint.wav",  // Default notification sound.  // Standard-Benachrichtigungston.
        browserNotificationsEnabled: false,  // Disable browser notifications by default.  // Deaktiviert standardmäßig Browser-Benachrichtigungen.
        pomodoroColor: "#74F143",  // Set color for Pomodoro timer.  // Legt die Farbe für den Pomodoro-Timer fest.
        shortBreakColor: "#ff9933",  // Set color for short break.  // Legt die Farbe für die Kurzpause fest.
        longBreakColor: "#0891FF",  // Set color for long break.  // Legt die Farbe für die Langpause fest.
        pomodoroStates: [],  // Initialize empty Pomodoro state array.  // Initialisiert ein leeres Pomodoro-Status-Array.
        toDoHappySadToggle: false,  // Disable happy/sad toggle initially.  // Deaktiviert das Happy/Sad-Umschalten zunächst.
        taskDeletionByTrashIcon: false,  // Disable task deletion by trash icon.  // Deaktiviert die Aufgabenlöschung über das Papierkorbsymbol.
        taskCardTitle: "",  // Initialize task card title as empty.  // Initialisiert den Titel der Aufgabenkarte als leer.
        projectName: [],  // Initialize empty project name array.  // Initialisiert ein leeres Projektname-Array.
        selectedContainerIndex: 0,  // Set default selected container index.  // Setzt den Standardindex für den ausgewählten Container.
        weeklyTimeframes: [],  // Initialize empty weekly timeframes.  // Initialisiert leere wöchentliche Zeitrahmen.
        monthlyTimeframes: [],  // Initialize empty monthly timeframes.  // Initialisiert leere monatliche Zeitrahmen.
        yearlyTimeframes: [],  // Initialize empty yearly timeframes.  // Initialisiert leere jährliche Zeitrahmen.
      });  // Close User object creation.  // Schließt die Erstellung des Benutzerobjekts ab.
    }  // Close if block.  // Schließt den if-Block ab.  
    
user = await user.save();  // Saves the user data to the database.  // Speichert die Benutzerdaten in der Datenbank.

const token = jwt.sign(  // Creates a JSON Web Token (JWT) for user authentication.  // Erstellt ein JSON Web Token (JWT) zur Benutzerauthentifizierung.
  { id: user._id, email: user.email },  // Includes user ID and email in the token payload.  // Beinhaltet die Benutzer-ID und E-Mail im Token-Payload.
  process.env.ACCESS_TOKEN_SECRET  // Uses a secret key stored in environment variables to sign the token.  // Verwendet einen geheimen Schlüssel, der in Umgebungsvariablen gespeichert ist, um das Token zu signieren.
);

await agendaInstance.schedule("1 second", "update-timezone", {  // Schedules a job to update the user's timezone after 1 second.  // Plant einen Job, um die Zeitzone des Benutzers nach 1 Sekunde zu aktualisieren.
  userId: user._id,  // Passes the user ID as part of the job data.  // Überträgt die Benutzer-ID als Teil der Job-Daten.
});
console.log(`Scheduled job 'update-timezone' for user: ${user._id}`);  // Logs the scheduled job for the user.  // Protokolliert den geplanten Job für den Benutzer.

res.json({  // Sends a JSON response back to the client with user data and token.  // Sendet eine JSON-Antwort mit Benutzerdaten und Token an den Client zurück.
  user: {  // Contains the user's details.  // Enthält die Benutzerdaten.
    id: user._id,  // User's ID.  // Benutzer-ID.
    name: user.name,  // User's name.  // Benutzername.
    email: user.email,  // User's email.  // Benutzer-E-Mail.
    isPremium: user.isPremium,  // Indicates if the user has a premium account.  // Gibt an, ob der Benutzer ein Premium-Konto hat.
    userLocalTimeZone: user.userLocalTimeZone,  // User's local timezone.  // Benutzer lokale Zeitzone.
    pomodoroTimer: user.pomodoroTimer,  // User's Pomodoro timer setting.  // Benutzer Pomodoro-Timer-Einstellung.
    shortBreakTimer: user.shortBreakTimer,  // User's short break timer setting.  // Benutzer kurze Pausen-Timer-Einstellung.
    longBreakTimer: user.longBreakTimer,  // User's long break timer setting.  // Benutzer lange Pausen-Timer-Einstellung.
    longBreakInterval: user.longBreakInterval,  // User's long break interval setting.  // Benutzer Intervall für lange Pausen-Einstellung.
    selectedSound: user.selectedSound,  // User's selected sound for timers.  // Ausgewählter Sound des Benutzers für Timer.
    browserNotificationsEnabled: user.browserNotificationsEnabled,  // Indicates if browser notifications are enabled.  // Gibt an, ob Browser-Benachrichtigungen aktiviert sind.
    pomodoroColor: user.pomodoroColor,  // User's Pomodoro timer color setting.  // Benutzer Pomodoro-Timer-Farbeinstellung.
    shortBreakColor: user.shortBreakColor,  // User's short break color setting.  // Benutzer Farbeinstellung für kurze Pausen.
    longBreakColor: user.longBreakColor,  // User's long break color setting.  // Benutzer Farbeinstellung für lange Pausen.
    pomodoroStates: user.pomodoroStates,  // User's Pomodoro states (e.g., work, break).  // Benutzer Pomodoro-Zustände (z.B. Arbeit, Pause).
    toDoHappySadToggle: user.toDoHappySadToggle,  // User's preference for to-do list mood toggle.  // Benutzer Präferenz für To-Do-Liste Stimmungsschalter.
    taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,  // User's preference for deleting tasks via trash icon.  // Benutzer Präferenz für das Löschen von Aufgaben über das Mülleimer-Symbol.
    taskCardTitle: user.taskCardTitle,  // User's custom task card title.  // Benutzer benutzerdefinierter Titel für Aufgabenkarte.
    projectName: user.projectName,  // User's project name.  // Benutzer Projektname.
    selectedContainerIndex: user.selectedContainerIndex,  // Index of the selected container.  // Index des ausgewählten Containers.
    weeklyTimeframes: user.weeklyTimeframes,  // User's weekly timeframes for tasks.  // Benutzer wöchentliche Zeitrahmen für Aufgaben.
    monthlyTimeframes: user.monthlyTimeframes,  // User's monthly timeframes for tasks.  // Benutzer monatliche Zeitrahmen für Aufgaben.
    yearlyTimeframes: user.yearlyTimeframes,  // User's yearly timeframes for tasks.  // Benutzer jährliche Zeitrahmen für Aufgaben.
  },
  token,  // Sends the token to the client.  // Sendet das Token an den Client.
});
console.log("user/api/signup  ", user);  // Logs the user details to the console.  // Protokolliert die Benutzerdetails in der Konsole.
console.log("user/api/signup  ", token);  // Logs the token to the console.  // Protokolliert das Token in der Konsole.

} catch (e) {  // Catches any errors that occur.  // Fängt Fehler ab, die auftreten.
  console.error(e);  // Logs the error to the console.  // Protokolliert den Fehler in der Konsole.
  res.status(500).json({ error: e.message });  // Sends a 500 status code with the error message in the response.  // Sendet einen 500-Statuscode mit der Fehlermeldung in der Antwort.
}

authRouter.post("/api/login", async (req, res) => {  // Defines a POST route for the login API.  // Definiert eine POST-Route für die Login-API.
  try {  // Begins a try block to handle possible errors.  // Beginnt einen Try-Block, um mögliche Fehler zu behandeln.
    const { email, password } = req.body;  // Destructures the email and password from the request body.  // Zerstückelt die E-Mail und das Passwort aus dem Anfragekörper.
    const user = await User.findOne({ email });  // Finds a user in the database by email.  // Findet einen Benutzer in der Datenbank anhand der E-Mail.
  
    if (!user || !(await user.comparePassword(password))) {  // Checks if the user doesn't exist or the password is incorrect.  // Überprüft, ob der Benutzer nicht existiert oder das Passwort falsch ist.
      return res.status(401).json({ error: "Invalid credentials" });  // Sends a 401 error with a message if credentials are invalid.  // Sendet einen 401-Fehler mit einer Nachricht, wenn die Anmeldedaten ungültig sind.
    }
  
    const token = jwt.sign(  // Creates a JWT token with the user's ID and email.  // Erstellt ein JWT-Token mit der Benutzer-ID und E-Mail.
      { id: user._id, email: user.email },  // Includes the user’s ID and email in the token payload.  // Schließt die Benutzer-ID und E-Mail in die Payload des Tokens ein.
      process.env.ACCESS_TOKEN_SECRET  // Signs the token using the secret key from environment variables.  // Signiert das Token mit dem geheimen Schlüssel aus den Umgebungsvariablen.
    );
  
    res.json({  // Sends a JSON response with user data and token.  // Sendet eine JSON-Antwort mit Benutzerdaten und Token.
      user: {  // Starts the user object in the response.  // Beginnt das Benutzerobjekt in der Antwort.
        id: user._id,  // User's ID.  // Benutzer-ID.
        name: user.name,  // User's name.  // Benutzername.
        email: user.email,  // User's email.  // Benutzer-E-Mail.
        isPremium: user.isPremium,  // Whether the user has a premium account.  // Ob der Benutzer ein Premium-Konto hat.
        userLocalTimeZone: user.userLocalTimeZone,  // User's local time zone.  // Die lokale Zeitzone des Benutzers.
        pomodoroTimer: user.pomodoroTimer,  // User's Pomodoro timer settings.  // Benutzereinstellungen für den Pomodoro-Timer.
        shortBreakTimer: user.shortBreakTimer,  // User's short break timer settings.  // Benutzereinstellungen für den Kurzpausen-Timer.
        longBreakTimer: user.longBreakTimer,  // User's long break timer settings.  // Benutzereinstellungen für den langen Pausen-Timer.
        longBreakInterval: user.longBreakInterval,  // Interval for long breaks in Pomodoro.  // Intervall für lange Pausen im Pomodoro.
        selectedSound: user.selectedSound,  // Sound preference selected by the user.  // Vom Benutzer ausgewähltes Soundpräferenz.
        browserNotificationsEnabled: user.browserNotificationsEnabled,  // Whether browser notifications are enabled.  // Ob Benachrichtigungen im Browser aktiviert sind.
        pomodoroColor: user.pomodoroColor,  // Color settings for Pomodoro timer.  // Farbeinstellungen für den Pomodoro-Timer.
        shortBreakColor: user.shortBreakColor,  // Color settings for short break timer.  // Farbeinstellungen für den Kurzpausen-Timer.
        longBreakColor: user.longBreakColor,  // Color settings for long break timer.  // Farbeinstellungen für den langen Pausen-Timer.
        pomodoroStates: user.pomodoroStates,  // States related to Pomodoro timer.  // Zustände im Zusammenhang mit dem Pomodoro-Timer.
        toDoHappySadToggle: user.toDoHappySadToggle,  // Toggle between happy and sad states in to-do list.  // Umschalter zwischen fröhlichen und traurigen Zuständen in der To-Do-Liste.
        taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,  // Option for task deletion by trash icon.  // Option zum Löschen von Aufgaben über das Papierkorb-Symbol.
        taskCardTitle: user.taskCardTitle,  // Title settings for task cards.  // Titel-Einstellungen für Aufgaben-Karten.
        projectName: user.projectName,  // User's project name.  // Projektname des Benutzers.
        selectedContainerIndex: user.selectedContainerIndex,  // Index of the selected container.  // Index des ausgewählten Containers.
        weeklyTimeframes: user.weeklyTimeframes,  // User's weekly timeframes settings.  // Benutzer-Einstellungen für wöchentliche Zeitrahmen.
        monthlyTimeframes: user.monthlyTimeframes,  // User's monthly timeframes settings.  // Benutzer-Einstellungen für monatliche Zeitrahmen.
        yearlyTimeframes: user.yearlyTimeframes,  // User's yearly timeframes settings.  // Benutzer-Einstellungen für jährliche Zeitrahmen.
      },
      token,  // Sends the generated token in the response.  // Sendet das generierte Token in der Antwort.
    });
    console.log("user/api/login  ", user);  // Logs the user data to the console for debugging.  // Protokolliert die Benutzerdaten zur Fehlerbehebung in der Konsole.
    console.log("user/api/login  ", token);  // Logs the generated token to the console for debugging.  // Protokolliert das generierte Token zur Fehlerbehebung in der Konsole.
  } catch (e) {  // If an error occurs, the catch block is executed.  // Wenn ein Fehler auftritt, wird der Catch-Block ausgeführt.
    console.error(e);  // Logs the error to the console.  // Protokolliert den Fehler in der Konsole.
    res.status(500).json({ error: e.message });  // Sends a 500 error response with the error message.  // Sendet eine 500-Fehlerantwort mit der Fehlermeldung.
  }
});

  
authRouter.post("/update-settings", auth, async (req, res) => {  // Defines a POST route for updating settings, with authentication middleware.  // Definiert eine POST-Route zum Aktualisieren der Einstellungen mit Authentifizierungs-Middleware.
  try {
    const {  // Extracts fields from the request body.  // Extrahiert Felder aus dem Anfrage-Body.
      pomodoroTimer,
      shortBreakTimer,
      longBreakTimer,
      longBreakInterval,
      selectedSound,
      browserNotificationsEnabled,
      pomodoroColor,
      shortBreakColor,
      longBreakColor,
    } = req.body;

    const allowedSounds = [  // Defines an array of allowed sound file paths.  // Definiert ein Array zulässiger Sounddateipfade.
      "assets/sounds/Flashpoint.wav",
      "assets/sounds/Plink.wav",
      "assets/sounds/Blink.wav",
    ];

    if (!allowedSounds.includes(selectedSound)) {  // Checks if the selected sound is valid.  // Überprüft, ob der ausgewählte Sound gültig ist.
      return res.status(400).json({ error: "Invalid sound selection" });  // Returns an error if the sound is invalid.  // Gibt einen Fehler zurück, wenn der Sound ungültig ist.
    }

    if (  // Validates that all required fields are present.  // Überprüft, ob alle erforderlichen Felder vorhanden sind.
      pomodoroTimer === undefined ||
      shortBreakTimer === undefined ||
      longBreakTimer === undefined ||
      longBreakInterval === undefined ||
      selectedSound === undefined ||
      browserNotificationsEnabled === undefined ||
      pomodoroColor === undefined ||
      shortBreakColor === undefined ||
      longBreakColor === undefined
    ) {
      return res.status(400).json({  // Returns an error if any required field is missing.  // Gibt einen Fehler zurück, wenn ein erforderliches Feld fehlt.
        error:
          "pomodoroTimer, shortBreakTimer, longBreakTimer and longBreakInterval are required",
      });
    }

    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.

    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns an error if the user is not found.  // Gibt einen Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }

    user.pomodoroTimer = pomodoroTimer;  // Updates the user's pomodoro timer.  // Aktualisiert den Pomodoro-Timer des Benutzers.
    user.shortBreakTimer = shortBreakTimer;  // Updates the user's short break timer.  // Aktualisiert den Kurzpausen-Timer des Benutzers.
    user.longBreakTimer = longBreakTimer;  // Updates the user's long break timer.  // Aktualisiert den Langpausen-Timer des Benutzers.
    user.longBreakInterval = longBreakInterval;  // Updates the user's long break interval.  // Aktualisiert das Langpausen-Intervall des Benutzers.
    user.selectedSound = selectedSound;  // Updates the user's selected sound.  // Aktualisiert den ausgewählten Sound des Benutzers.
    user.browserNotificationsEnabled = browserNotificationsEnabled;  // Updates notification settings.  // Aktualisiert die Benachrichtigungseinstellungen.
    user.pomodoroColor = pomodoroColor;  // Updates the Pomodoro color setting.  // Aktualisiert die Pomodoro-Farbeinstellung.
    user.shortBreakColor = shortBreakColor;  // Updates the short break color setting.  // Aktualisiert die Kurzpausen-Farbeinstellung.
    user.longBreakColor = longBreakColor;  // Updates the long break color setting.  // Aktualisiert die Langpausen-Farbeinstellung.

    await user.save();  // Saves the updated user settings to the database.  // Speichert die aktualisierten Benutzereinstellungen in der Datenbank.

    res.json({  // Sends a response with the updated settings.  // Sendet eine Antwort mit den aktualisierten Einstellungen.
      message: "Settings updated successfully",  // Confirmation message.  // Bestätigungsnachricht.
      pomodoroTimer: user.pomodoroTimer,
      shortBreakTimer: user.shortBreakTimer,
      longBreakTimer: user.longBreakTimer,
      longBreakInterval: user.longBreakInterval,
      selectedSound: user.selectedSound,
      browserNotificationsEnabled: user.browserNotificationsEnabled,
      pomodoroColor: user.pomodoroColor,
      shortBreakColor: user.shortBreakColor,
      longBreakColor: user.longBreakColor,
    });
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error if an exception occurs.  // Gibt einen 500-Fehler zurück, wenn eine Ausnahme auftritt.
  }
});

  
authRouter.post("/update-pomodoro-states", auth, async (req, res) => {  // Defines a POST route for updating Pomodoro states, with authentication middleware.  // Definiert eine POST-Route zum Aktualisieren der Pomodoro-Zustände mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const { pomodoroStates } = req.body;  // Extracts pomodoroStates from the request body.  // Extrahiert pomodoroStates aus dem Anfrage-Body.
    if (pomodoroStates === undefined) {  // Checks if pomodoroStates is provided.  // Überprüft, ob pomodoroStates vorhanden ist.
      return res.status(400).json({  // Returns a 400 error if pomodoroStates is missing.  // Gibt einen 400-Fehler zurück, wenn pomodoroStates fehlt.
        error: "pomodoroStates is required",  // Error message for missing pomodoroStates.  // Fehlermeldung für fehlende pomodoroStates.
      });
    }
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    user.pomodoroStates = pomodoroStates;  // Updates the user's Pomodoro states.  // Aktualisiert die Pomodoro-Zustände des Benutzers.
    await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
    res.json({  // Sends a success response with updated data.  // Sendet eine Erfolgsantwort mit aktualisierten Daten.
      message: "Pomodoro states updated successfully",  // Success message.  // Erfolgsmeldung.
      pomodoroStates: user.pomodoroStates,  // Returns the updated pomodoroStates.  // Gibt die aktualisierten pomodoroStates zurück.
    });
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});

authRouter.post("/card-add-todo-task", auth, async (req, res) => {  // Defines a POST route for adding todo tasks, with authentication middleware.  // Definiert eine POST-Route zum Hinzufügen von Todo-Aufgaben mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const { toDoHappySadToggle, taskDeletionByTrashIcon, taskCardTitle } =
      req.body;  // Extracts task-related fields from the request body.  // Extrahiert aufgabenbezogene Felder aus dem Anfrage-Body.
    if (
      toDoHappySadToggle === undefined ||
      taskDeletionByTrashIcon === undefined ||
      taskCardTitle === undefined
    ) {  // Checks if all required fields are provided.  // Überprüft, ob alle erforderlichen Felder vorhanden sind.
      return res.status(400).json({  // Returns a 400 error if any required field is missing.  // Gibt einen 400-Fehler zurück, wenn ein erforderliches Feld fehlt.
        error: "toDoHappySadToggle is required",  // Error message for missing fields (note: this message is not comprehensive).  // Fehlermeldung für fehlende Felder (Hinweis: Diese Meldung ist nicht vollständig).
      });
    }
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    user.toDoHappySadToggle = toDoHappySadToggle;  // Updates the user's todo toggle state.  // Aktualisiert den ToDo-Umschaltzustand des Benutzers.
    user.taskDeletionByTrashIcon = taskDeletionByTrashIcon;  // Updates the user's task deletion preference.  // Aktualisiert die Aufgabenlöschungspräferenz des Benutzers.
    user.taskCardTitle = taskCardTitle;  // Updates the user's task card title.  // Aktualisiert den Aufgabenkartentitel des Benutzers.
    await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
    res.json({  // Sends a success response with updated data.  // Sendet eine Erfolgsantwort mit aktualisierten Daten.
      message: "Todo task added successfully",  // Success message.  // Erfolgsmeldung.
      toDoHappySadToggle: user.toDoHappySadToggle,  // Returns the updated toggle state.  // Gibt den aktualisierten Umschaltzustand zurück.
      taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,  // Returns the updated deletion preference.  // Gibt die aktualisierte Löschungspräferenz zurück.
      taskCardTitle: user.taskCardTitle,  // Returns the updated task card title.  // Gibt den aktualisierten Aufgabenkartentitel zurück.
    });
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});

 
authRouter.post("/update-project", auth, async (req, res) => {  // Defines a POST route for updating projects, with authentication middleware.  // Definiert eine POST-Route zum Aktualisieren von Projekten mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const { projectName, index } = req.body;  // Extracts projectName and index from the request body.  // Extrahiert projectName und index aus dem Anfrage-Body.
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    if (!user.projectName) {  // Checks if user.projectName array exists.  // Überprüft, ob das user.projectName-Array existiert.
      user.projectName = [];  // Initializes an empty array if projectName doesn't exist.  // Initialisiert ein leeres Array, falls projectName nicht existiert.
    }
    if (index >= user.projectName.length) {  // Checks if the provided index is beyond the current array length.  // Überprüft, ob der angegebene Index außerhalb der aktuellen Array-Länge liegt.
      user.projectName = [
        ...user.projectName,
        ...Array(index - user.projectName.length + 1).fill("add a project"),  // Expands array with placeholder values to reach the desired index.  // Erweitert das Array mit Platzhaltern, um den gewünschten Index zu erreichen.
      ];
    }
    +
    user.projectName[index] = projectName;  // Updates the project name at the specified index.  // Aktualisiert den Projektnamen am angegebenen Index.
    await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
    res.json({  // Sends a success response with updated data.  // Sendet eine Erfolgsantwort mit aktualisierten Daten.
      message: "Project name and selected index updated successfully",  // Success message.  // Erfolgsmeldung.
      projectName: user.projectName,  // Returns the updated projectName array.  // Gibt das aktualisierte projectName-Array zurück.
    });
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});

authRouter.post("/update-container-index", auth, async (req, res) => {  // Defines a POST route for updating the container index, with authentication middleware.  // Definiert eine POST-Route zum Aktualisieren des Container-Index mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const { selectedContainerIndex } = req.body;  // Extracts selectedContainerIndex from the request body.  // Extrahiert selectedContainerIndex aus dem Anfrage-Body.
    if (selectedContainerIndex === undefined) {  // Checks if selectedContainerIndex is provided.  // Überprüft, ob selectedContainerIndex vorhanden ist.
      return res.status(400).json({  // Returns a 400 error if selectedContainerIndex is missing.  // Gibt einen 400-Fehler zurück, wenn selectedContainerIndex fehlt.
        error: "selectedContainerIndex is required",  // Error message for missing selectedContainerIndex.  // Fehlermeldung für fehlendes selectedContainerIndex.
      });
    }
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    user.selectedContainerIndex = selectedContainerIndex;  // Updates the user's selectedContainerIndex.  // Aktualisiert den selectedContainerIndex des Benutzers.
    await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
    res.json({  // Sends a success response with updated data.  // Sendet eine Erfolgsantwort mit aktualisierten Daten.
      message: "selectedContainerIndex updated successfully",  // Success message.  // Erfolgsmeldung.
      selectedContainerIndex: user.selectedContainerIndex,  // Returns the updated selectedContainerIndex.  // Gibt den aktualisierten selectedContainerIndex zurück.
    });
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
}); 
  
authRouter.post("/api/timeframe/add", auth, async (req, res) => {  // Defines a POST route for adding timeframe data, with authentication middleware.  // Definiert eine POST-Route zum Hinzufügen von Zeitrahmen-Daten mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const { projectIndex, date, duration, timeframeType } = req.body;  // Extracts timeframe data from the request body.  // Extrahiert Zeitrahmen-Daten aus dem Anfrage-Body.
    
    const newTimeframe = {  // Creates a new timeframe object.  // Erstellt ein neues Zeitrahmen-Objekt.3
      projectIndex,  // Project index to associate with this timeframe.  // Projekt-Index, der mit diesem Zeitrahmen verknüpft wird.
      date: new Date(date),  // Converts the date string to a Date object.  // Konvertiert den Datums-String in ein Date-Objekt.
      duration,  // Duration of the timeframe.  // Dauer des Zeitrahmens.
    };
    const updateQuery = {};  // Initializes an empty update query for MongoDB.  // Initialisiert eine leere Update-Abfrage für MongoDB.
    const currentDate = new Date(date);  // Creates a Date object for date operations.  // Erstellt ein Date-Objekt für Datums-Operationen.
    switch (timeframeType) {  // Switches behavior based on the timeframe type.  // Unterscheidet das Verhalten basierend auf dem Zeitrahmentyp.
      case "weekly":  // For weekly timeframes.  // Für wöchentliche Zeitrahmen.
        await User.findByIdAndUpdate(req.user, {  // Removes any existing weekly timeframe for the same day and project.  // Entfernt alle bestehenden wöchentlichen Zeitrahmen für denselben Tag und dasselbe Projekt.
          $pull: {  // MongoDB operator to remove elements from an array.  // MongoDB-Operator zum Entfernen von Elementen aus einem Array.
            weeklyTimeframes: {  // Target array to modify.  // Ziel-Array, das geändert werden soll.
              projectIndex: projectIndex,  // Matches documents with this project index.  // Findet Dokumente mit diesem Projekt-Index.
              date: {  // Date range condition.  // Datumsbereichsbedingung.
                $gte: new Date(currentDate.setHours(0, 0, 0, 0)),  // Start of the day.  // Beginn des Tages.
                $lt: new Date(currentDate.setHours(23, 59, 59, 999)),  // End of the day.  // Ende des Tages.
              },
            },
          },
        });
        updateQuery.$push = { weeklyTimeframes: newTimeframe };  // Sets up query to add new timeframe to weekly array.  // Richtet die Abfrage ein, um einen neuen Zeitrahmen zum wöchentlichen Array hinzuzufügen.
        break;
      case "monthly":  // For monthly timeframes.  // Für monatliche Zeitrahmen.
        await User.findByIdAndUpdate(req.user, {  // Removes any existing monthly timeframe for the same day and project.  // Entfernt alle bestehenden monatlichen Zeitrahmen für denselben Tag und dasselbe Projekt.
          $pull: {  // MongoDB operator to remove elements from an array.  // MongoDB-Operator zum Entfernen von Elementen aus einem Array.
            monthlyTimeframes: {  // Target array to modify.  // Ziel-Array, das geändert werden soll.
              projectIndex: projectIndex,  // Matches documents with this project index.  // Findet Dokumente mit diesem Projekt-Index.
              date: {  // Date range condition.  // Datumsbereichsbedingung.
                $gte: new Date(currentDate.setHours(0, 0, 0, 0)),  // Start of the day.  // Beginn des Tages.
                $lt: new Date(currentDate.setHours(23, 59, 59, 999)),  // End of the day.  // Ende des Tages.
              },
            },
          },
        });
        updateQuery.$push = { monthlyTimeframes: newTimeframe };  // Sets up query to add new timeframe to monthly array.  // Richtet die Abfrage ein, um einen neuen Zeitrahmen zum monatlichen Array hinzuzufügen.
        break;
      case "yearly":  // For yearly timeframes.  // Für jährliche Zeitrahmen.
        await User.findByIdAndUpdate(req.user, {  // Removes any existing yearly timeframe for the same month and project.  // Entfernt alle bestehenden jährlichen Zeitrahmen für denselben Monat und dasselbe Projekt.
          $pull: {  // MongoDB operator to remove elements from an array.  // MongoDB-Operator zum Entfernen von Elementen aus einem Array.
            yearlyTimeframes: {  // Target array to modify.  // Ziel-Array, das geändert werden soll.
              projectIndex: projectIndex,  // Matches documents with this project index.  // Findet Dokumente mit diesem Projekt-Index.
              date: {  // Date range condition for the whole month.  // Datumsbereichsbedingung für den gesamten Monat.
                $gte: new Date(
                  Date.UTC(currentDate.getFullYear(), currentDate.getMonth(), 1)  // First day of the month.  // Erster Tag des Monats.
                ),
                $lt: new Date(
                  Date.UTC(
                    currentDate.getFullYear(),
                    currentDate.getMonth() + 1,
                    0
                  )  // Last day of the month.  // Letzter Tag des Monats.
                ),
              },
            },
          },
        });
        updateQuery.$push = { yearlyTimeframes: newTimeframe };  // Sets up query to add new timeframe to yearly array.  // Richtet die Abfrage ein, um einen neuen Zeitrahmen zum jährlichen Array hinzuzufügen.
        break;
      default:  // For invalid timeframe types.  // Für ungültige Zeitrahmentypen.
        return res.status(400).json({ error: "Invalid timeframe type" });  // Returns an error for invalid timeframe type.  // Gibt einen Fehler für ungültige Zeitrahmentypen zurück.
    }
    const user = await User.findByIdAndUpdate(req.user, updateQuery, {  // Updates the user document with the new timeframe.  // Aktualisiert das Benutzerdokument mit dem neuen Zeitrahmen.
      new: true,  // Returns the updated document.  // Gibt das aktualisierte Dokument zurück.
      runValidators: true,  // Runs validators on the updated document.  // Führt Validatoren für das aktualisierte Dokument aus.
    });
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    res.json({ message: "Time frame data added successfully" });  // Sends a success response.  // Sendet eine Erfolgsantwort.
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    console.error("Error in /api/timeframe/add:", e);  // Logs the error to the console.  // Protokolliert den Fehler in der Konsole.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});
 

// Get weekly time frame data endpoint  // Retrieves the weekly timeframe data for the user.  // Ruft die wöchentlichen Zeitrahmendaten für den Benutzer ab.
authRouter.get("/api/timeframe/weekly", auth, async (req, res) => {  // Defines a GET route for weekly timeframe data, with authentication middleware.  // Definiert eine GET-Route für wöchentliche Zeitrahmendaten mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    const lastWeek = new Date();  // Creates a new date object for date calculations.  // Erstellt ein neues Datumsobjekt für Datumsberechnungen.
    lastWeek.setDate(lastWeek.getDate() - 7);  // Sets the date to 7 days ago.  // Setzt das Datum auf 7 Tage zurück.
    const weeklyData = user.weeklyTimeframes.filter(  // Filters the weekly timeframes array.  // Filtert das Array der wöchentlichen Zeitrahmen.
      (timeframe) => timeframe.date >= lastWeek  // Keeps only timeframes from the last 7 days.  // Behält nur Zeitrahmen der letzten 7 Tage.
    );
    res.json(weeklyData);  // Returns the filtered weekly timeframe data.  // Gibt die gefilterten wöchentlichen Zeitrahmendaten zurück.
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});  

// Get monthly time frame data endpoint  // Retrieves the monthly timeframe data for the user.  // Ruft die monatlichen Zeitrahmendaten für den Benutzer ab.
authRouter.get("/api/timeframe/monthly", auth, async (req, res) => {  // Defines a GET route for monthly timeframe data, with authentication middleware.  // Definiert eine GET-Route für monatliche Zeitrahmendaten mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    const lastMonth = new Date();  // Creates a new date object for date calculations.  // Erstellt ein neues Datumsobjekt für Datumsberechnungen.
    lastMonth.setMonth(lastMonth.getMonth() - 1);  // Sets the date to 1 month ago.  // Setzt das Datum auf 1 Monat zurück.
    const monthlyData = user.monthlyTimeframes.filter(  // Filters the monthly timeframes array.  // Filtert das Array der monatlichen Zeitrahmen.
      (timeframe) => timeframe.date >= lastMonth  // Keeps only timeframes from the last month.  // Behält nur Zeitrahmen des letzten Monats.
    );
    res.json(monthlyData);  // Returns the filtered monthly timeframe data.  // Gibt die gefilterten monatlichen Zeitrahmendaten zurück.
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});

  
// Get yearly time frame data endpoint  // Retrieves the yearly timeframe data for the user.  // Ruft die jährlichen Zeitrahmendaten für den Benutzer ab.
authRouter.get("/api/timeframe/yearly", auth, async (req, res) => {  // Defines a GET route for yearly timeframe data, with authentication middleware.  // Definiert eine GET-Route für jährliche Zeitrahmendaten mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    const lastYear = new Date();  // Creates a new date object for date calculations.  // Erstellt ein neues Datumsobjekt für Datumsberechnungen.
    lastYear.setFullYear(lastYear.getFullYear() - 1);  // Sets the date to 1 year ago.  // Setzt das Datum auf 1 Jahr zurück.
    const yearlyData = user.yearlyTimeframes.filter(  // Filters the yearly timeframes array.  // Filtert das Array der jährlichen Zeitrahmen.
      (timeframe) => timeframe.date >= lastYear  // Keeps only timeframes from the last year.  // Behält nur Zeitrahmen des letzten Jahres.
    );
    res.json(yearlyData);  // Returns the filtered yearly timeframe data.  // Gibt die gefilterten jährlichen Zeitrahmendaten zurück.
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});

authRouter.post("/delete-project", auth, async (req, res) => {  // Defines a POST route for deleting a project, with authentication middleware.  // Definiert eine POST-Route zum Löschen eines Projekts mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const { projectIndex } = req.body;  // Extracts the projectIndex from the request body.  // Extrahiert den projectIndex aus dem Anfrage-Body.
    
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    await User.findByIdAndUpdate(req.user, {  // Updates the user document by removing timeframe data.  // Aktualisiert das Benutzerdokument, indem Zeitrahmendaten entfernt werden.
      $pull: {  // MongoDB operator to remove elements from arrays.  // MongoDB-Operator zum Entfernen von Elementen aus Arrays.
        weeklyTimeframes: { projectIndex: projectIndex },  // Removes all weekly timeframes with this project index.  // Entfernt alle wöchentlichen Zeitrahmen mit diesem Projektindex.
        monthlyTimeframes: { projectIndex: projectIndex },  // Removes all monthly timeframes with this project index.  // Entfernt alle monatlichen Zeitrahmen mit diesem Projektindex.
        yearlyTimeframes: { projectIndex: projectIndex }  // Removes all yearly timeframes with this project index.  // Entfernt alle jährlichen Zeitrahmen mit diesem Projektindex.
      }
    });
    if (projectIndex < user.projectName.length) {  // Checks if the projectIndex is within the valid range.  // Überprüft, ob der Projektindex innerhalb des gültigen Bereichs liegt.
      user.projectName[projectIndex] = "add a project";  // Resets the project name to the default value rather than removing it.  // Setzt den Projektnamen auf den Standardwert zurück, anstatt ihn zu entfernen.
    }
    await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
    
    res.json({  // Sends a success response.  // Sendet eine Erfolgsantwort.
      success: true,
      message: "Project and associated data deleted successfully"  // Success message indicating the project was deleted.  // Erfolgsmeldung, die anzeigt, dass das Projekt gelöscht wurde.
    });
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});
 

authRouter.get("/", auth, async (req, res) => {  // Defines a GET route for the root endpoint, with authentication middleware.  // Definiert eine GET-Route für den Root-Endpunkt mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    const iana = Intl.DateTimeFormat().resolvedOptions().timeZone;  // Gets the user's browser timezone.  // Ermittelt die Zeitzone des Browsers des Benutzers.
    const userLocalTimeZone = moment().tz(iana).format();  // Formats the current time in the user's timezone.  // Formatiert die aktuelle Zeit in der Zeitzone des Benutzers.
    const currentTimeZoneVersion = `${moment.tz.version}-${moment.tz.dataVersion}`;  // Creates a version string for the timezone data.  // Erstellt eine Versionszeichenfolge für die Zeitzonendaten.
    const convertUserLocalTimeZoneToUTC = moment().tz(iana).utc().format();  // Converts the user's local time to UTC.  // Konvertiert die lokale Zeit des Benutzers in UTC.
    if (
      user.currentTimeZoneVersion !== currentTimeZoneVersion ||
      user.iana !== iana ||
      user.userLocalTimeZone !== userLocalTimeZone
    ) {  // Checks if timezone information needs to be updated.  // Überprüft, ob Zeitzoneninfos aktualisiert werden müssen.
      user.iana = iana;  // Updates the user's IANA timezone.  // Aktualisiert die IANA-Zeitzone des Benutzers.
      user.userLocalTimeZone = userLocalTimeZone;  // Updates the user's local timezone.  // Aktualisiert die lokale Zeitzone des Benutzers.
      user.currentTimeZoneVersion = currentTimeZoneVersion;  // Updates the timezone version.  // Aktualisiert die Zeitzonenversion.
      user.convertUserLocalTimeZoneToUTC = convertUserLocalTimeZoneToUTC;  // Updates the UTC conversion.  // Aktualisiert die UTC-Konvertierung.
      await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
      console.log(`Updated time zone for user: ${user._id}`);  // Logs the timezone update.  // Protokolliert die Zeitzonenaktualisierung.
    }
    if (user.suscriptionStatusCancelled === true) {  // Checks if the user's subscription is cancelled.  // Überprüft, ob das Abonnement des Benutzers gekündigt wurde.
      user.getCurrentTimeAfterRefresh = new Date();  // Records the current time of this refresh.  // Zeichnet die aktuelle Zeit dieser Aktualisierung auf.
      if (user.getCurrentTimeAfterRefresh > user.nextBillingTime) {  // Checks if the subscription has expired.  // Überprüft, ob das Abonnement abgelaufen ist.
        user.isPremium = false;  // Removes premium status if subscription expired.  // Entfernt den Premium-Status, wenn das Abonnement abgelaufen ist.
        console.log(`S ubscription expir  ed for user: ${user._id}`);  // Logs subscription expiration (note: contains extra spaces).  // Protokolliert das Abonnementende (Hinweis: enthält zusätzliche Leerzeichen).
      }
      await user.save();  // Saves the updated user to the database.  // Speichert den aktualisierten Benutzer in der Datenbank.
    }
    if (!cronJobForTimeZones[user._id]) {  // Checks if a cron job exists for this user.  // Überprüft, ob für diesen Benutzer ein Cron-Job existiert.
      cronJobForTimeZones[user._id] = agendaInstance.create(  // Creates a new cron job for timezone updates.  // Erstellt einen neuen Cron-Job für Zeitzonenaktualisierungen.
        " update-time-zones",  // Job name for timezone updates.  // Aufgabenname für Zeitzonenaktualisierungen.
        { message: `Updating time zones for user ${user._id}` }  // Job data with message.  // Aufgabendaten mit Nachricht.
      );
      cronJobForTimeZones[user._id].repeatEvery("* *  **");  // Sets the job to repeat (note: pattern appears malformed).  // Legt fest, dass der Job wiederholt werden soll (Hinweis: Muster scheint fehlerhaft zu sein).
      cronJobForTimeZones[user._id].save();  // Saves the cron job.  // Speichert den Cron-Job.
      console.log(`Cron job scheduled for user ${user._id}`);  // Logs cron job scheduling.  // Protokolliert die Cron-Job-Planung.
    }
    res.json({ user, token: req.token });  // Returns the user data and token.  // Gibt die Benutzerdaten und das Token zurück.
    console.log("User data refreshed:", user);  // Logs successful user data refresh.  // Protokolliert die erfolgreiche Aktualisierung der Benutzerdaten.
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    console.error(e);  // Logs the error to the console.  // Protokolliert den Fehler in der Konsole.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});
  
authRouter.post("/api/logout", auth, async (req, res) => {  // Defines a POST route for user logout, with authentication middleware.  // Definiert eine POST-Route für die Benutzerabmeldung mit Authentifizierungs-Middleware.
  try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
    const user = await User.findById(req.user);  // Finds the user in the database by ID.  // Sucht den Benutzer in der Datenbank anhand der ID.
    if (!user) {  // Checks if the user exists.  // Überprüft, ob der Benutzer existiert.
      return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
    }
    if (cronJobForTimeZones[user._id]) {  // Checks if a cron job exists for this user.  // Überprüft, ob für diesen Benutzer ein Cron-Job existiert.
      console.log(`Clearing cron job for user ${user._id}`);  // Logs the beginning of cron job cleanup.  // Protokolliert den Beginn der Cron-Job-Bereinigung.
      cronJobForTimeZones[user._id].remove();  // Removes the cron job from the scheduler.  // Entfernt den Cron-Job aus dem Scheduler.
      delete cronJobForTimeZones[user._id];  // Deletes the job reference from the tracking object.  // Löscht die Job-Referenz aus dem Tracking-Objekt.
      console.log(`Cron job cleared for user ${user._id}`);  // Logs completion of cron job cleanup.  // Protokolliert den Abschluss der Cron-Job-Bereinigung.
    }
    res.json({ msg: "Logged out successfully" });  // Returns a success message for logout.  // Gibt eine Erfolgsmeldung für die Abmeldung zurück.
    console.log("User logged out:", user._id);  // Logs the user ID that was logged out.  // Protokolliert die Benutzer-ID, die abgemeldet wurde.
  } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
    console.error(e);  // Logs the error to the console.  // Protokolliert den Fehler in der Konsole.
    res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
  }
});

authRouter.delete(
  "/api/delete-premium-or-not-premium-user",  // Defines a DELETE route for account deletion, for both premium and non-premium users.  // Definiert eine DELETE-Route für die Kontolöschung, sowohl für Premium- als auch für Nicht-Premium-Benutzer.
  auth,  // Applies authentication middleware to ensure only authenticated users can delete accounts.  // Wendet Authentifizierungs-Middleware an, um sicherzustellen, dass nur authentifizierte Benutzer Konten löschen können.
  async (req, res) => {  // Asynchronous route handler function.  // Asynchrone Route-Handler-Funktion.
    try {  // Begins a try-catch block for error handling.  // Beginnt einen Try-Catch-Block zur Fehlerbehandlung.
      const user = await User.findByIdAndDelete(req.user);  // Finds the user by ID and deletes them from the database.  // Findet den Benutzer anhand der ID und löscht ihn aus der Datenbank.
      if (!user) {  // Checks if the user was found and deleted.  // Überprüft, ob der Benutzer gefunden und gelöscht wurde.
        return res.status(404).json({ error: "User not found" });  // Returns a 404 error if user is not found.  // Gibt einen 404-Fehler zurück, wenn der Benutzer nicht gefunden wird.
      }
      if (cronJobForTimeZones[user._id]) {  // Checks if a cron job exists for this user.  // Überprüft, ob für diesen Benutzer ein Cron-Job existiert.
        console.log(`Clearing cron job for user ${user._id}`);  // Logs the beginning of cron job cleanup.  // Protokolliert den Beginn der Cron-Job-Bereinigung.
        cronJobForTimeZones[user._id].remove();  // Removes the cron job from the scheduler.  // Entfernt den Cron-Job aus dem Scheduler.
        delete cronJobForTimeZones[user._id];  // Deletes the job reference from the tracking object.  // Löscht die Job-Referenz aus dem Tracking-Objekt.
        console.log(`Cron job cleared for user ${user._id}`);  // Logs completion of cron job cleanup.  // Protokolliert den Abschluss der Cron-Job-Bereinigung.
      }
      res.json({ msg: "Account deleted successfully" });  // Returns a success message for account deletion.  // Gibt eine Erfolgsmeldung für die Kontolöschung zurück.
    } catch (e) {  // Catches any errors that occur.  // Fängt alle auftretenden Fehler ab.
      res.status(500).json({ error: e.message });  // Returns a 500 error with the error message.  // Gibt einen 500-Fehler mit der Fehlermeldung zurück.
    }
  }
);
  
module.exports = authRouter;  // Exports the authRouter object to make it available to other files.  // Exportiert das authRouter-Objekt, um es für andere Dateien verfügbar zu machen.
