import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'my_uri.dart';

import 'package:askme/model/globals.dart' as global;

/// Der Datentyp Mitarbeiter
class Mitarbeiter {
  final int idMa;
  final String vorname;
  final String name;
  final int isAdmin;

  Mitarbeiter(this.idMa, this.vorname, this.name, this.isAdmin);

  Mitarbeiter.fromMap(Map<String, dynamic> map)
      : idMa = int.parse(map['idMa']),
        vorname = map['vorname'],
        name = map['name'],
        isAdmin = int.parse(map['isAdmin']);
}

class MaAll {
  static List<Mitarbeiter> _maList = [];

  /// Alle Mitarbeiter von der DB lesen.
  static Future<List<Mitarbeiter>> readMaAll() async {
    if (global.maAllList.isNotEmpty && global.maAllList.length > 3) {
      return global.maAllList;
    }
    try {
      final response = await http.post(MyUri.getUri("/readMaAll.php"),
          body: {"dbUser": global.dbUserRead, "dbpass": global.dbpass});

    if (response.statusCode == 200) {
        Object oo = response.body;
        print(oo);
        List maFromDb = json.decode(response.body);
        _maList = _setMaData(maFromDb);
      }
    } catch (e) {
      _maList.add(Mitarbeiter(-1, "fehler", "fehler", -1));
      return _maList;
    }
    return _maList;
  }

  /// Die MitarbeiterListe Liste mit allen Werten füllen
  static List<Mitarbeiter> _setMaData(List maFromDb) {
    List<Mitarbeiter> maList = [];
    for (var element in maFromDb) {
      Map<String, dynamic> map = element;
      Mitarbeiter ma = Mitarbeiter.fromMap(map);
      maList.add(ma);
    }
    // Liste sortieren
    maList.sort(maComparator);
    return maList;
  }

  /// die Tableau gemäss Position soritieren
  static Comparator<Mitarbeiter> maComparator =
      (a, b) => a.vorname.compareTo(b.vorname);

  /// Den Name eines Mitarbeiters lesen
  static String getName(int idMa) {
    /* einlesen, wenn nicht mehr verfügbar
    if (global.maAllList.isEmpty) {
      global.maAllList = maAll.readMaAll();
    }
    */
    for (Mitarbeiter ma in global.maAllList) {
      if (ma.idMa == idMa) {
        return "${ma.vorname} ${ma.name}";
      }
    }
    return "nicht gefunden";
  }

  /// Der Code für die email
  static setCode(int idMa, String code) {
    for (Mitarbeiter ma in global.maAllList) {
      {
        if (ma.idMa == idMa) {
          //  ma.code = code;
        }
      }
    }
  }

  // ignore: unused_element
  static String getCode(int idMa) {
    for (Mitarbeiter ma in global.maAllList) {
      {
        if (ma.idMa == idMa) {
//          return ma.code;
        }
      }
    }
    return "";
  }
}
