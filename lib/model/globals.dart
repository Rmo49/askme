library my_pri.globals;

import 'package:intl/intl.dart';
import 'ma_data.dart';

// wenn im Testmode, login ohne
const bool testMode = true;
// wenn test, dann connection auf lokal
const bool testUri = true;
// Der Titel, der angezeigt wird
const String titel = "AskMe Einsatzplan (0.1) [Prototyp]";
// Werte initialisieren 0=Internet, 1=lokal
const int initWerte = 0;
// das Datenformat in der DB
final DateFormat dateFormDb = DateFormat('yyyy-MM-dd');
// das Datenformat in Anzeige
final DateFormat dateFormDisplay = DateFormat('d.M.yyyy');
// Datumsformat für Anzeige: Tag d.M., wird in main.dart gesetzt
late DateFormat dateDisplay;
// das aktuelle Datum
final DateTime heute = DateTime.now();

// Alle Mitarbeiter, wird nach dem Login eingelesen
List<Mitarbeiter> maAllList = <Mitarbeiter>[];

// Das Schema für Web (http / https)
const String scheme = "https";
// Der Host-name für Web
const String host = "nomadus.ch";
// Der Pfad, der erweitert wird
const String pathPhp = "askme/db";
// Login für nur Leise
const String dbUserRead = "phpRead3";
// Login für Schreiben
const String dbUserWrite = "phpWrite3";
// Passwort für beide
const String dbpass = "Php.4010d";

// die ID des eingeloggten Mitarbeiters, wird gesetzt im login
int idMaLogedIn = -1;
// der Name des Benutzers
String userName = '';
