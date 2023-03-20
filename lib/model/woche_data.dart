import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'my_uri.dart';

import 'package:askme/model/globals.dart' as global;

/// Der Datentyp Mitarbeiter
class WochenTag {
  final int idWoche;
  final String tag;
  final int tagNr;
  String zeit;
  bool isSelected;

  WochenTag(this.idWoche, this.tag, this.tagNr, this.zeit, this.isSelected);

  WochenTag.fromMap(Map<String, dynamic> map)
      : idWoche = int.parse(map['idWoche']),
        tag = map['tag'],
        tagNr = int.parse(map['tagNr']),
        zeit = map['zeit'],
        isSelected = ((int.parse(map['isSelected']) == 0) ? false : true);

  Map<String, dynamic> toJson() =>
      {"idWoche": idWoche, "tag": tag, "tagNr": tagNr,  "zeit": zeit, "isSelected": isSelected};
}

/// Die Liste der Woche für die Generierung des Einsatzplanes
class Woche {
  static List<WochenTag> _wocheList = [];

  /// Alle Tage von der DB lesen.
  static Future<List<WochenTag>> readWoche() async {
    try {
      final response = await http.post(MyUri.getUri("/wocheRead.php"),
          body: {"dbUser": global.dbUserRead, "dbpass": global.dbpass});

      if (response.statusCode == 200) {
        List wocheFromDb = json.decode(response.body);
        _wocheList = _setWoche(wocheFromDb);
      }
    } catch (e) {
      _wocheList.add(WochenTag(-1, "fehler", -1, "fehler", false));
      return _wocheList;
    }
    return _wocheList;
  }

  /// Die Wochen Liste mit allen Werten füllen
  static List<WochenTag> _setWoche(List wocheFromDb) {
    List<WochenTag> wocheList = [];
    for (var element in wocheFromDb) {
      Map<String, dynamic> map = element;
      WochenTag ma = WochenTag.fromMap(map);
      wocheList.add(ma);
    }
    // Liste sortieren
    wocheList.sort(maComparator);
    return wocheList;
  }

  /// die Tableau gemäss Position soritieren
  static Comparator<WochenTag> maComparator =
      (a, b) => a.idWoche.compareTo(b.idWoche);

  /// die Daten in der DB speichern
  static Future<String> updateWt(WochenTag wt) async {
    //Map<String, dynamic> wtJson = wt.toJson();
    //String wtStr = wtJson.toString();
    int sel = wt.isSelected ? 1 : 0;
    try {
      final response = await http.post(MyUri.getUri("/wocheUpdate.php"), body: {
        "dbUser": global.dbUserWrite,
        "dbpass": global.dbpass,
        "idWoche": wt.idWoche.toString(),
        "zeit": wt.zeit,
        "isSelected": sel.toString()
      });

      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      return "error: $e";
    }
    return "error: beim update Wochentage";
  }
}

///
class Monat {
  int nr = -1;
  String name = "";

  Monat(this.nr, this.name);
}

/// Die Liste der Monate für die Auswahl im Einsatzplan und Admin für generieren
class MonatList {
  static Set<String> monate = {'Jan', 'Feb', 'März', 'April', 'Mai',
    'Juni', 'Juli',  'Aug', 'Sept', 'Okt', 'Nov', 'Dez'};
  // TODO muss noch automatisiert werden mit Kalender
  //static List<String> monatList = <String>['April', 'Mai', 'Juni'];
  static List<Monat> _monatList = [];

  /// Die Liste der angezeigten Monate
  static Future<List<Monat>> setupMonatList() async {
    int monatVon = 1;
    int monatBis = 12;
    DateTime dtHeute;
    // TODO muss nach erfolgreichem login eingelesen werden
    String heute = await getActualDate();
    if (heute.length < 6) {
      dtHeute = DateTime.now();
    }
    else {
      // TODO dynamisch machen
      dtHeute = DateTime.utc(2023, 5, 1);
    }
    //
    int monat = dtHeute.month;
    monatVon = monat + 9;
    if (monatVon < 12) {
      monatVon = monatVon -12;
    }
    monatBis = monat + 3;
    if (monatBis > 12) {
      monatBis - 12;
    }
    _generateList(monatVon, monatBis);
    return _monatList;
  }

  static _generateList(int monatVon, int monatBis) {
    int mon = monatVon;
    if (mon > monatBis) {
      while (mon <= 12) {
        Monat monat = Monat(mon, monate.elementAt(mon - 1));
        _monatList.add(monat);
        mon++;
      }
      mon = 1;
    }
    while (mon <= monatBis) {
      Monat monat = Monat(mon, monate.elementAt(mon - 1));
      _monatList.add(monat);
      mon++;
    }
  }

  /// das aktuelle Datum, damit alle das gleiche haben
  static Future<String> getActualDate() async {
    try {
      final response = await http.post(MyUri.getUri("/getHeute.php"));
          if (response.body.isNotEmpty) {
        Object oo = response.body;
      }
    } catch (e) {
      // Könnte sein, dass response eine Error-Message enthält
      return "";
    }
    return "";
  }

}
