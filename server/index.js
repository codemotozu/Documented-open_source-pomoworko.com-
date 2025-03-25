/// ExpressServerSetup
/// 
/// A Node.js Express server that handles authentication, payments, and serves a Flutter web application.
/// Ein Node.js Express-Server, der Authentifizierung, Zahlungen verarbeitet und eine Flutter-Web-Anwendung bereitstellt.
/// 
/// Features / Funktionen:
/// - MongoDB connection for data persistence / MongoDB-Verbindung für Datenpersistenz
/// - Authentication routes / Authentifizierungsrouten
/// - PayPal integration / PayPal-Integration
/// - HTTPS enforcement in production / HTTPS-Erzwingung im Produktionsmodus
/// - Static file serving for Flutter web app / Bereitstellung statischer Dateien für Flutter-Web-App
/// - Agenda job scheduler / Agenda-Job-Scheduler
/// 
/// Usage:
/// ```javascript
/// // Start the server
/// node index.js
/// ```
/// 
/// EN: Sets up a complete Express server with authentication, database connection, and payment processing.
/// DE: Richtet einen vollständigen Express-Server mit Authentifizierung, Datenbankverbindung und Zahlungsabwicklung ein.

const express = require('express');  // Import Express framework.  // Importiert das Express-Framework.
const mongoose = require('mongoose');  // Import Mongoose for MongoDB interactions.  // Importiert Mongoose für die Interaktion mit MongoDB.
const dotenv = require('dotenv');  // Import dotenv to load environment variables.  // Importiert dotenv, um Umgebungsvariablen zu laden.
dotenv.config();  // Load environment variables from .env file.  // Lädt Umgebungsvariablen aus der .env-Datei.

const path = require('path');  // Import path module to handle file paths.  // Importiert das Path-Modul zur Verarbeitung von Dateipfaden.
const cors = require('cors');  // Import CORS to enable cross-origin requests.  // Importiert CORS, um Cross-Origin-Anfragen zu ermöglichen.
const authRouter = require('./routes/auth');  // Import authentication routes.  // Importiert die Authentifizierungsrouten.

dotenv.config();  // Load environment variables again (redundant).  // Lädt erneut Umgebungsvariablen (überflüssig).

const PORT = process.env.PORT || 3001;  // Define server port from environment or default to 3001.  // Definiert den Serverport aus der Umgebung oder standardmäßig auf 3001.

const app = express();  // Create an Express application.  // Erstellt eine Express-Anwendung.

if(process.env.NODE_ENV === 'production') {  // Check if the app is in production mode.  // Überprüft, ob die App im Produktionsmodus ist.
   app.use((req, res, next) => {  // Middleware to enforce HTTPS in production.  // Middleware, um HTTPS im Produktionsmodus zu erzwingen.
     if (req.header('x-forwarded-proto') !== 'https')  // Check if request is not HTTPS.  // Prüft, ob die Anfrage nicht über HTTPS erfolgt.
       res.redirect(`https://${req.header('host')}${req.url}`)  // Redirect to HTTPS.  // Leitet auf HTTPS um.
     else  // Otherwise, proceed to next middleware.  // Andernfalls weiter zur nächsten Middleware.
       next()
   })
}

app.use(cors());  // Enable CORS for cross-origin requests.  // Aktiviert CORS für Cross-Origin-Anfragen.
app.use(express.json());  // Enable JSON parsing for request bodies.  // Aktiviert JSON-Parsing für Anfragetexte.
app.use('/auth',authRouter);  // Use authentication routes at /auth.  // Verwendet Authentifizierungsrouten unter /auth.
app.use('/paypal', paypalRouter);  // Use PayPal routes at /paypal.  // Verwendet PayPal-Routen unter /paypal.

const DB = process.env.MONGO_DB_URL;  // Get MongoDB connection string from environment variables.  // Holt die MongoDB-Verbindungszeichenfolge aus Umgebungsvariablen.

mongoose.connect(DB, {}).then(() => {  // Connect to MongoDB database.  // Stellt eine Verbindung zur MongoDB-Datenbank her.
   console.log("Connection successful");  // Log successful connection.  // Gibt eine erfolgreiche Verbindung aus.
   agendaInstance.start();  // Start the Agenda job scheduler.  // Startet den Agenda-Job-Scheduler.
   console.log('Agenda instance started');  // Log that Agenda has started.  // Gibt aus, dass die Agenda-Instanz gestartet wurde.

 }).catch((err) => {  // Handle connection errors.  // Behandelt Verbindungsfehler.
   console.log(err);  // Log error to console.  // Gibt den Fehler in der Konsole aus.
 });

// Serve static files from the Flutter web app build output directory.  // Stellt statische Dateien aus dem Flutter-Web-App-Build-Verzeichnis bereit.
app.use(express.static(path.join(__dirname,)));

// Serve the index.html file as the entry point to your Flutter web app.  // Stellt die index.html-Datei als Einstiegspunkt für die Flutter-Web-App bereit.
app.get('*', (req, res) => {  // Catch all routes and serve index.html.  // Fängt alle Routen ab und liefert index.html aus.
   res.sendFile(path.join(__dirname, 'index.html'));  // Send index.html file.  // Sendet die index.html-Datei.
});

app.listen(PORT, () => {  // Start the server and listen on the specified port.  // Startet den Server und lauscht auf dem angegebenen Port.
   console.log(`Server is running on port ${PORT}`);  // Log server start message.  // Gibt die Startnachricht des Servers aus.
});
