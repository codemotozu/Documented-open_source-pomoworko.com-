const mongoose = require("mongoose");  // Import the mongoose library for MongoDB interaction.  // Importiert die Mongoose-Bibliothek für die MongoDB-Interaktion.
const { DateTime } = require("luxon");  // Import the DateTime class from the luxon library for date handling.  // Importiert die DateTime-Klasse aus der Luxon-Bibliothek zur Datumsverarbeitung.

const userSchema = new mongoose.Schema({  // Create a new mongoose schema for user data.  // Erstellt ein neues Mongoose-Schema für Benutzerdaten.
  name: {  // Define the name field.  // Definiert das Namensfeld.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
  },
  email: {  // Define the email field.  // Definiert das E-Mail-Feld.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
  },
  profilePic: {  // Define the profile picture field.  // Definiert das Profilbildfeld.
    type: String,  // Field type is String (likely a URL or path).  // Feldtyp ist String (wahrscheinlich eine URL oder ein Pfad).
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    trim: true,  // Remove whitespace from both ends of the string.  // Entfernt Leerzeichen von beiden Enden der Zeichenkette.
  },
  isPremium: {  // Define premium user status field.  // Definiert das Feld für den Premium-Benutzerstatus.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  subscriptionId: {  // Define subscription ID field.  // Definiert das Abonnement-ID-Feld.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  suscriptionStatusCancelled: {  // Define subscription cancelled status field.  // Definiert das Feld für gekündigten Abonnementstatus.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  subscriptionStatusConfirmed: {  // Define subscription confirmed status field.  // Definiert das Feld für bestätigten Abonnementstatus.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  subscriptionStatusPending: {  // Define subscription pending status field.  // Definiert das Feld für ausstehenden Abonnementstatus.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  nextBillingTime: {  // Define next billing time field.  // Definiert das Feld für den nächsten Abrechnungszeitpunkt.
    type: Date,  // Field type is Date.  // Feldtyp ist Date.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  startTimeSubscriptionPayPal: {  // Define PayPal subscription start time field.  // Definiert das Feld für die PayPal-Abonnement-Startzeit.
    type: Date,  // Field type is Date.  // Feldtyp ist Date.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  paypalSubscriptionCancelledAt: {  // Define PayPal subscription cancellation time field.  // Definiert das Feld für den Zeitpunkt der PayPal-Abonnementkündigung.
    type: Date,  // Field type is Date.  // Feldtyp ist Date.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  getCurrentTimeAfterRefresh: {  // Define field for time after page refresh.  // Definiert das Feld für die Zeit nach der Seitenaktualisierung.
    type: Date,  // Field type is Date.  // Feldtyp ist Date.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  userLocalTimeZone: {  // Define user's local timezone field.  // Definiert das Feld für die lokale Zeitzone des Benutzers.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
  },
  iana: {  // Define IANA timezone identifier field.  // Definiert das Feld für den IANA-Zeitzonenbezeichner.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
  },
  convertUserLocalTimeZoneToUTC: {  // Define field for conversion to UTC.  // Definiert das Feld für die Umrechnung in UTC.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
  },
  currentTimeZoneVersion: {  // Define timezone version field.  // Definiert das Feld für die Zeitzonenversion.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
  },
  custom_id: {  // Define custom ID field.  // Definiert das benutzerdefinierte ID-Feld.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  plan_id: {  // Define subscription plan ID field.  // Definiert das Feld für die Abonnementplan-ID.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  pomodoroTimer: {  // Define Pomodoro timer duration field.  // Definiert das Feld für die Pomodoro-Timer-Dauer.
    type: Number,  // Field type is Number.  // Feldtyp ist Number.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: 25,  // Default value is 25 minutes.  // Standardwert ist 25 Minuten.
  },
  shortBreakTimer: {  // Define short break timer duration field.  // Definiert das Feld für die Dauer der kurzen Pause.
    type: Number,  // Field type is Number.  // Feldtyp ist Number.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: 5,  // Default value is 5 minutes.  // Standardwert ist 5 Minuten.
  },
  longBreakTimer: {  // Define long break timer duration field.  // Definiert das Feld für die Dauer der langen Pause.
    type: Number,  // Field type is Number.  // Feldtyp ist Number.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: 15,  // Default value is 15 minutes.  // Standardwert ist 15 Minuten.
  },
  longBreakInterval: {  // Define interval for long breaks field.  // Definiert das Feld für das Intervall der langen Pausen.
    type: Number,  // Field type is Number.  // Feldtyp ist Number.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: 4,  // Default is every 4 Pomodoros.  // Standard ist alle 4 Pomodoros.
  },
  selectedSound: {  // Define selected notification sound field.  // Definiert das Feld für den ausgewählten Benachrichtigungston.
    type: String,  // Field type is String.  // Feldtyp ist String.
    enum: ['assets/sounds/Flashpoint.wav', 'assets/sounds/Plink.wav', 'assets/sounds/Blink.wav'],  // Limited to these values.  // Auf diese Werte beschränkt.
    default: 'assets/sounds/Flashpoint.wav'  // Default sound.  // Standard-Sound.
  },
  browserNotificationsEnabled: {  // Define browser notifications toggle field.  // Definiert das Feld für den Browser-Benachrichtigungsschalter.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  pomodoroColor: {  // Define Pomodoro timer color field.  // Definiert das Feld für die Pomodoro-Timer-Farbe.
    type: String,  // Field type is String.  // Feldtyp ist String.
    default: '#74F143',  // Default is green.  // Standard ist grün.
  },
  shortBreakColor: {  // Define short break timer color field.  // Definiert das Feld für die Farbe des Kurzzeitpausen-Timers.
    type: String,  // Field type is String.  // Feldtyp ist String.
    default: '#ff9933',  // Default is orange.  // Standard ist orange.
  },
  longBreakColor: {  // Define long break timer color field.  // Definiert das Feld für die Farbe des Langzeitpausen-Timers.
    type: String,  // Field type is String.  // Feldtyp ist String.
    default: '#0891FF',  // Default is blue.  // Standard ist blau.
  },
  pomodoroStates: {  // Define array to track Pomodoro states.  // Definiert ein Array zur Verfolgung der Pomodoro-Zustände.
    type: [Boolean],  // Field type is array of Booleans.  // Feldtyp ist ein Array von Booleans.
    default: [],  // Default is empty array.  // Standard ist ein leeres Array.
  },
  toDoHappySadToggle: {  // Define to-do list toggle for happy/sad view.  // Definiert den Umschalter für die glücklich/traurig-Ansicht der To-Do-Liste.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  taskDeletionByTrashIcon: {  // Define toggle for task deletion by trash icon.  // Definiert den Umschalter für das Löschen von Aufgaben durch das Papierkorb-Symbol.
    type: Boolean,  // Field type is Boolean.  // Feldtyp ist Boolean.
    required: true,  // This field is required.  // Dieses Feld ist erforderlich.
    default: false,  // Default value is false.  // Standardwert ist false.
  },
  taskCardTitle: {  // Define task card title field.  // Definiert das Feld für den Titel der Aufgabenkarte.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  },
  projectName: [{  // Define project names array field.  // Definiert das Feld für das Array der Projektnamen.
    type: String,  // Field type is String.  // Feldtyp ist String.
    required: false,  // This field is not required.  // Dieses Feld ist nicht erforderlich.
  }],
  selectedContainerIndex: {  // Define selected container index field.  // Definiert das Feld für den Index des ausgewählten Containers.
    type: Number,  // Field type is Number.  // Feldtyp ist Number.
    default: 0  // Default value is 0.  // Standardwert ist 0.
  },
  weeklyTimeframes: [{  // Define weekly time tracking array.  // Definiert das Array für die wöchentliche Zeiterfassung.
    projectIndex: Number,  // Project index as Number.  // Projektindex als Nummer.
    date: Date,  // Date of timeframe.  // Datum des Zeitrahmens.
    duration: Number,  // Duration in seconds.  // Dauer in Sekunden.
  }],
  monthlyTimeframes: [{  // Define monthly time tracking array.  // Definiert das Array für die monatliche Zeiterfassung.
    projectIndex: Number,  // Project index as Number.  // Projektindex als Nummer.
    date: Date,  // Date of timeframe.  // Datum des Zeitrahmens.
    duration: Number,  // Duration in seconds.  // Dauer in Sekunden.
  }],
  yearlyTimeframes: [{  // Define yearly time tracking array.  // Definiert das Array für die jährliche Zeiterfassung.
    projectIndex: Number,  // Project index as Number.  // Projektindex als Nummer.
    date: Date,  // Date of timeframe.  // Datum des Zeitrahmens.
    duration: Number,  // Duration in seconds.  // Dauer in Sekunden.
  }]
});

const User = mongoose.model("User", userSchema);  // Create the User model from the schema.  // Erstellt das User-Modell aus dem Schema.
module.exports = User;  // Export the User model for use in other files.  // Exportiert das User-Modell zur Verwendung in anderen Dateien.
