/// ServerConfig
/// 
/// A configuration file that defines the server endpoint URL for the application. // Eine Konfigurationsdatei, die die Server-Endpunkt-URL für die Anwendung definiert.
/// Toggles between development (localhost) and production (live site) environments. // Wechselt zwischen Entwicklungs- (localhost) und Produktions- (Live-Website) Umgebungen.
/// 
/// Usage:
/// ```javascript
/// import { host } from './config';
/// 
/// // Make API request to server
/// fetch(`${host}/api/endpoint`)
///   .then(response => response.json())
///   .then(data => console.log(data));
/// ```
/// 
/// EN: Centralizes server URL configuration to simplify switching between development and production environments.
/// DE: Zentralisiert die Server-URL-Konfiguration, um das Umschalten zwischen Entwicklungs- und Produktionsumgebungen zu vereinfachen.

// const host = 'http://localhost:3001';//development  // Commented-out development server URL that points to localhost port 3001.  // Auskommentierte Entwicklungsserver-URL, die auf localhost Port 3001 verweist.
const host = 'https://pomoworko.com'; //production  // Active production server URL pointing to the live website.  // Aktive Produktionsserver-URL, die auf die Live-Website verweist.
