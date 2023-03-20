import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'globals.dart' as global;

import 'my_uri.dart';

/// Der Datentyp Mitarbeiter
class LoginMa {
  final String email;
  final String pw;
  final String pwRecover;

  LoginMa(this.email, this.pw, this.pwRecover);

  LoginMa.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        pw = map['pw'],
        pwRecover = map['pwRecover'];
}

class LoginCheck {
  /// Login daten prüfen, wenn ok, gibt die id des
  /// Mitarbeiters zurück
  static Future<String> check(LoginMa loginMa) async {
    String returnValue = "";
    String idMa = "";
    String error = "";
    try {
      final response = await http.post(MyUri.getUri("/loginCheck.php"),
          body: {"dbUser": global.dbUserRead, "dbpass": global.dbpass,
          "email": loginMa.email, "passwort": loginMa.pw});

      if (response.statusCode == 200) {
        List loginFromDb = json.decode(response.body);
        // wenn ok, wird die idMa zurückgegeben.
        for (var element in loginFromDb) {
          Map<String, dynamic> map = element;
          idMa = map['idMa'];
          error = map['error'];
        }
        if (idMa.isNotEmpty) {
          return idMa;
        } else {
          return error;
        }
      }
    } on Exception catch (_, e) {
      returnValue = "Fehler Connection: $e";
    }
    return returnValue;
  }

  static Future testConnection() async {
    try {
      final response = await http.post(MyUri.getUri("/testConnect.php"));

      if (response.statusCode == 200) {
        return (response.body);
      } else {
        return ('Konnte keine Verbindung aufbauen zu: '
            'Status: ${response.statusCode}');
      }
    } catch (e) {
      return ('Ist eine Internet-Verbindung vorhanden? \nFehler: $e');
    }
  }

  static Future testDb() async {
    try {
      final response = await http.post(MyUri.getUri("/testDb.php"),
          body: {"dbUser": global.dbUserRead, "dbpass": global.dbpass});

      if (response.statusCode == 200) {
        return (response.body);
      } else {
        return ('Konnte keine Verbindung aufbauen zu: '
            'Status: ${response.statusCode}');
      }
    } catch (e) {
      return ('DB nicht gefunden \nFehler: $e');
    }
  }

  static Future readKey() async {
    try {
      final response = await http.post(MyUri.getUri("/readKey.php"));

      if (response.statusCode == 200) {
        print (response.body);
        return (response.body);
      } else {
        return ('Konnte keine Verbindung aufbauen zu: '
            'Status: ${response.statusCode}');
      }
    } catch (e) {
      return ('Key nicht gefunden \nFehler: $e');
    }

  }

}
