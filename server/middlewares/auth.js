/// AuthMiddleware
/// 
/// A middleware function that authenticates API requests using JSON Web Tokens (JWT). // Eine Middleware-Funktion, die API-Anfragen mithilfe von JSON Web Tokens (JWT) authentifiziert.
/// Used to protect restricted routes and verify user identity throughout the application. // Wird verwendet, um eingeschränkte Routen zu schützen und die Benutzeridentität in der gesamten Anwendung zu überprüfen.
/// 
/// Usage:
/// ```javascript
/// const auth = require('./middleware/auth');
/// 
/// // Apply to specific routes
/// router.get('/protected-route', auth, (req, res) => {
///   // Access authenticated user ID
///   const userId = req.user;
///   // Handle the request...
/// });
/// ```
/// 
/// EN: Validates JWT tokens from request headers and provides user identification for protected routes.
/// DE: Validiert JWT-Tokens aus Request-Headern und stellt Benutzeridentifikation für geschützte Routen bereit.

const jwt = require("jsonwebtoken");  // Import the jsonwebtoken library for JWT operations.  // Importiert die jsonwebtoken-Bibliothek für JWT-Operationen.
const auth = async (req, res, next) => {  // Define an async middleware function for authentication.  // Definiert eine asynchrone Middleware-Funktion für die Authentifizierung.
  try {  // Start a try block to handle potential errors.  // Startet einen try-Block, um potenzielle Fehler zu behandeln.
    const token = req.header("x-auth-token");  // Extract the JWT from the x-auth-token header.  // Extrahiert das JWT aus dem x-auth-token Header.
    console.log(token);  // Log the token for debugging purposes.  // Protokolliert das Token zu Debugging-Zwecken.
    if (!token)  // Check if the token exists.  // Prüft, ob das Token existiert.
      return res.status(401).json({ msg: "No auth token, access denied." });  // Return 401 Unauthorized if no token.  // Gibt 401 Unauthorized zurück, wenn kein Token vorhanden ist.
    const verified = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);  // Verify the token using the secret from environment variables.  // Verifiziert das Token mit dem Secret aus den Umgebungsvariablen.
    if (!verified)  // Check if verification was successful.  // Prüft, ob die Verifizierung erfolgreich war.
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });  // Return 401 if verification fails.  // Gibt 401 zurück, wenn die Verifizierung fehlschlägt.
    req.user = verified.id;  // Add the user ID from the token payload to the request object.  // Fügt die Benutzer-ID aus der Token-Payload dem Request-Objekt hinzu.
    req.token = token;  // Add the token to the request object for potential future use.  // Fügt das Token dem Request-Objekt für potenzielle zukünftige Verwendung hinzu.
    next();  // Call the next middleware in the chain.  // Ruft die nächste Middleware in der Kette auf.
  } catch (e) {  // Catch any errors that occur during token verification.  // Fängt alle Fehler ab, die während der Token-Verifizierung auftreten.
    res.status(500).json({ error: e.message });  // Return 500 Internal Server Error with the error message.  // Gibt 500 Internal Server Error mit der Fehlermeldung zurück.
  }
};
module.exports = auth;  // Export the auth middleware for use in other files.  // Exportiert die auth-Middleware zur Verwendung in anderen Dateien.
