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


















  

authRouter.post("/update-settings", auth, async (req, res) => {
  try {
    const {
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

    const allowedSounds = [
      "assets/sounds/Flashpoint.wav",
      "assets/sounds/Plink.wav",
      "assets/sounds/Blink.wav",
    ];

    if (!allowedSounds.includes(selectedSound)) {
      return res.status(400).json({ error: "Invalid sound selection" });
    }

    if (
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
      return res.status(400).json({
        error:
          "pomodoroTimer, shortBreakTimer, longBreakTimer and longBreakInterval are required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.pomodoroTimer = pomodoroTimer;
    user.shortBreakTimer = shortBreakTimer;
    user.longBreakTimer = longBreakTimer;
    user.longBreakInterval = longBreakInterval;
    user.selectedSound = selectedSound;
    user.browserNotificationsEnabled = browserNotificationsEnabled;
    user.pomodoroColor = pomodoroColor;
    user.shortBreakColor = shortBreakColor;
    user.longBreakColor = longBreakColor;

    await user.save();

    res.json({
      message: "Settings updated successfully",
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
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-pomodoro-states", auth, async (req, res) => {
  try {
    const { pomodoroStates } = req.body;

    if (pomodoroStates === undefined) {
      return res.status(400).json({
        error: "pomodoroStates is required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.pomodoroStates = pomodoroStates;
    await user.save();

    res.json({
      message: "Pomodoro states updated successfully",
      pomodoroStates: user.pomodoroStates,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/card-add-todo-task", auth, async (req, res) => {
  try {
    const { toDoHappySadToggle, taskDeletionByTrashIcon, taskCardTitle } =
      req.body;

    if (
      toDoHappySadToggle === undefined ||
      taskDeletionByTrashIcon === undefined ||
      taskCardTitle === undefined
    ) {
      return res.status(400).json({
        error: "toDoHappySadToggle is required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.toDoHappySadToggle = toDoHappySadToggle;
    user.taskDeletionByTrashIcon = taskDeletionByTrashIcon;
    user.taskCardTitle = taskCardTitle;
    await user.save();

    res.json({
      message: "Todo task added successfully",
      toDoHappySadToggle: user.toDoHappySadToggle,
      taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,
      taskCardTitle: user.taskCardTitle,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-project", auth, async (req, res) => {
  try {
    const { projectName, index } = req.body;

    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (!user.projectName) {
      user.projectName = [];
    }

    if (index >= user.projectName.length) {
      user.projectName = [
        ...user.projectName,
        ...Array(index - user.projectName.length + 1).fill("add a project"),
      ];
    }
    user.projectName[index] = projectName;

    await user.save();

    res.json({
      message: "Project name and selected index updated successfully",
      projectName: user.projectName,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-container-index", auth, async (req, res) => {
  try {
    const { selectedContainerIndex } = req.body;

    if (selectedContainerIndex === undefined) {
      return res.status(400).json({
        error: "selectedContainerIndex is required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.selectedContainerIndex = selectedContainerIndex;

    await user.save();

    res.json({
      message: "selectedContainerIndex updated successfully",

      selectedContainerIndex: user.selectedContainerIndex,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Add timeframe data for a project
authRouter.post("/api/timeframe/add", auth, async (req, res) => {
  try {
    const { projectIndex, date, duration, timeframeType } = req.body;

    // Create new timeframe entry
    const newTimeframe = {
      projectIndex,
      date: new Date(date),
      duration, // Duration in seconds
    };

    const updateQuery = {};
    const currentDate = new Date(date);

    switch (timeframeType) {
      case "weekly":
        // First pull any existing entries
        await User.findByIdAndUpdate(req.user, {
          $pull: {
            weeklyTimeframes: {
              projectIndex: projectIndex,
              date: {
                $gte: new Date(currentDate.setHours(0, 0, 0, 0)),
                $lt: new Date(currentDate.setHours(23, 59, 59, 999)),
              },
            },
          },
        });

        // Then push the new entry
        updateQuery.$push = { weeklyTimeframes: newTimeframe };
        break;

      case "monthly":
        await User.findByIdAndUpdate(req.user, {
          $pull: {
            monthlyTimeframes: {
              projectIndex: projectIndex,
              date: {
                $gte: new Date(currentDate.setHours(0, 0, 0, 0)),
                $lt: new Date(currentDate.setHours(23, 59, 59, 999)),
              },
            },
          },
        });

        updateQuery.$push = { monthlyTimeframes: newTimeframe };
        break;

      case "yearly":
        await User.findByIdAndUpdate(req.user, {
          $pull: {
            yearlyTimeframes: {
              projectIndex: projectIndex,
              date: {
                $gte: new Date(
                  Date.UTC(currentDate.getFullYear(), currentDate.getMonth(), 1)
                ),
                $lt: new Date(
                  Date.UTC(
                    currentDate.getFullYear(),
                    currentDate.getMonth() + 1,
                    0
                  )
                ),
              },
            },
          },
        });

        updateQuery.$push = { yearlyTimeframes: newTimeframe };
        break;

      default:
        return res.status(400).json({ error: "Invalid timeframe type" });
    }

    // Execute the update
    const user = await User.findByIdAndUpdate(req.user, updateQuery, {
      new: true,
      runValidators: true,
    });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({ message: "Time frame data added successfully" });
  } catch (e) {
    console.error("Error in /api/timeframe/add:", e);
    res.status(500).json({ error: e.message });
  }
});

// Get weekly time frame data endpoint
authRouter.get("/api/timeframe/weekly", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const lastWeek = new Date();
    lastWeek.setDate(lastWeek.getDate() - 7);

    const weeklyData = user.weeklyTimeframes.filter(
      (timeframe) => timeframe.date >= lastWeek
    );

    res.json(weeklyData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get monthly time frame data endpoint
authRouter.get("/api/timeframe/monthly", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const lastMonth = new Date();
    lastMonth.setMonth(lastMonth.getMonth() - 1);

    const monthlyData = user.monthlyTimeframes.filter(
      (timeframe) => timeframe.date >= lastMonth
    );

    res.json(monthlyData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get yearly time frame data endpoint
authRouter.get("/api/timeframe/yearly", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const lastYear = new Date();
    lastYear.setFullYear(lastYear.getFullYear() - 1);

    const yearlyData = user.yearlyTimeframes.filter(
      (timeframe) => timeframe.date >= lastYear
    );

    res.json(yearlyData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


authRouter.post("/delete-project", auth, async (req, res) => {
  try {
    const { projectIndex } = req.body;
    
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    await User.findByIdAndUpdate(req.user, {
      $pull: {
        weeklyTimeframes: { projectIndex: projectIndex },
        monthlyTimeframes: { projectIndex: projectIndex },
        yearlyTimeframes: { projectIndex: projectIndex }
      }
    });

    if (projectIndex < user.projectName.length) {
      user.projectName[projectIndex] = "add a project";
    }

    await user.save();
    
    res.json({
      success: true,
      message: "Project and associated data deleted successfully"
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



authRouter.get("/", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const iana = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const userLocalTimeZone = moment().tz(iana).format();
    const currentTimeZoneVersion = `${moment.tz.version}-${moment.tz.dataVersion}`;
    const convertUserLocalTimeZoneToUTC = moment().tz(iana).utc().format();

    if (
      user.currentTimeZoneVersion !== currentTimeZoneVersion ||
      user.iana !== iana ||
      user.userLocalTimeZone !== userLocalTimeZone
    ) {
      user.iana = iana;
      user.userLocalTimeZone = userLocalTimeZone;
      user.currentTimeZoneVersion = currentTimeZoneVersion;
      user.convertUserLocalTimeZoneToUTC = convertUserLocalTimeZoneToUTC;
      await user.save();
      console.log(`Updated time zone for user: ${user._id}`);
    }

    if (user.suscriptionStatusCancelled === true) {
      user.getCurrentTimeAfterRefresh = new Date();
      if (user.getCurrentTimeAfterRefresh > user.nextBillingTime) {
        user.isPremium = false;
        console.log(`S ubscription expir  ed for user: ${user._id}`);
      }
      await user.save();
    }
    if (!cronJobForTimeZones[user._id]) {
      cronJobForTimeZones[user._id] = agendaInstance.create(
        " update-time-zones",
        { message: `Updating time zones for user ${user._id}` }
      );
      cronJobForTimeZones[user._id].repeatEvery("* * * * * *"); 
      cronJobForTimeZones[user._id].save();
      console.log(`Cron job scheduled for user ${user._id}`);
    }

    res.json({ user, token: req.token });
    console.log("User data refreshed:", user);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/logout", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (cronJobForTimeZones[user._id]) {
      console.log(`Clearing cron job for user ${user._id}`);

      cronJobForTimeZones[user._id].remove();
      delete cronJobForTimeZones[user._id];
      console.log(`Cron job cleared for user ${user._id}`);
    }

    res.json({ msg: "Logged out successfully" });
    console.log("User logged out:", user._id);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.delete(
  "/api/delete-premium-or-not-premium-user",
  auth,
  async (req, res) => {
    try {
      const user = await User.findByIdAndDelete(req.user);

      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }

      if (cronJobForTimeZones[user._id]) {
        console.log(`Clearing cron job for user ${user._id}`);

        cronJobForTimeZones[user._id].remove();
        delete cronJobForTimeZones[user._id];
        console.log(`Cron job cleared for user ${user._id}`);
      }

      res.json({ msg: "Account deleted successfully" });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

module.exports = authRouter;

authRouter.post("/update-settings", auth, async (req, res) => {
  try {
    const {
      pomodoroTimer,
      shortBreakTimer,
      longBreakTimer,
      longBreakInterval,
      selectedSound,
      browserNotificationsEnabled,
    } = req.body;

    const allowedSounds = [
      "assets/sounds/Flashpoint.wav",
      "assets/sounds/Plink.wav",
      "assets/sounds/Blink.wav",
    ];

    if (!allowedSounds.includes(selectedSound)) {
      return res.status(400).json({ error: "Invalid sound selection" });
    }

    if (
      pomodoroTimer === undefined ||
      shortBreakTimer === undefined ||
      longBreakTimer === undefined ||
      longBreakInterval === undefined ||
      selectedSound === undefined ||
      browserNotificationsEnabled === undefined
    ) {
      return res.status(400).json({
        error:
          "pomodoroTimer, shortBreakTimer, longBreakTimer and longBreakInterval are required",
      });
    }

    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.pomodoroTimer = pomodoroTimer;
    user.shortBreakTimer = shortBreakTimer;
    user.longBreakTimer = longBreakTimer;
    user.longBreakInterval = longBreakInterval;
    user.selectedSound = selectedSound;
    user.browserNotificationsEnabled = browserNotificationsEnabled;

    await user.save();

    res.json({
      message: "Settings updated successfully",
      pomodoroTimer: user.pomodoroTimer,
      shortBreakTimer: user.shortBreakTimer,
      longBreakTimer: user.longBreakTimer,
      longBreakInterval: user.longBreakInterval,
      selectedSound: user.selectedSound,
      browserNotificationsEnabled: user.browserNotificationsEnabled,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
