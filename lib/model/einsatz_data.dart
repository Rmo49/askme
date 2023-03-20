import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart' as global;
import 'my_uri.dart';

/// Die Zeile eines Einsatzes für die Palnung
class Einsatz {
  int idDatum = 0;
  DateTime? datum;
  String? zeit;

  // Konstruktoren für verschiedene Bedürfinsse
  Einsatz(DateTime this.datum, String this.zeit) {
    //this.datum = DateTime.parse(datum);
  }

  // Konstruktoren für verschiedene Bedürfinsse
  Einsatz.fromString(String datum, String this.zeit) {
    this.datum = DateTime.parse(datum);
  }

  Einsatz.fromMap(Map<String, dynamic> map) {
    idDatum = int.parse(map['idDatum']);
    datum = DateTime.parse(map['datum']);
    zeit = map['zeit'];
  }

}

/// Die Zeile eines Einsatzes für den Einsatzplan
class EinsatzMa {
  int idDatum = 0;
  DateTime? datum;
  String? zeit;
  List<int> idMaList = [];
  String? names;
  bool isChecked = false;

  // Konstruktoren für verschiedene Bedürfinsse
  EinsatzMa(String datum, String this.zeit, String this.names, this.idMaList) {
    this.datum = DateTime.parse(datum);
  }

  EinsatzMa.fromMap(Map<String, dynamic> map) {
    idDatum = int.parse(map['idDatum']);
    datum = DateTime.parse(map['datum']);
    zeit = map['zeit'];
    idMaList = _getMaList(map['ma']);
  }

  // dynamische Liste in int-Liste
  _getMaList(List<dynamic> maIds) {
    idMaList = [];
    for (var element in maIds) {
      if (element == null) {
        // wenn am Ende der Liste
        return idMaList;
      }
      int nr = -1;
      nr = int.parse(element);
      if (nr >= 0) idMaList.add(nr);
    }
    return idMaList;
  }
}

/// Der gesamte Einsatzplan eines Monats
class EinsatzPlanData {
  EinsatzPlanData();

  // der Einsatzplan
  List<EinsatzMa> einsatzPlan = [];

  /// Alle Einsätze eines Monates lesen
  /// month: 04.2023
  Future<List<EinsatzMa>> readEinsatzAll(String month) async {
    try {
      final response = await http.post(MyUri.getUri("/readEinsatzplan.php"),
          body: {"dbUser": global.dbUserRead, "dbpass": global.dbpass,
          "datumVon": "2023-04-01", "datumBis": "2023-04-03"});
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          // String resp = response.body;
          List einsatzFromDb = json.decode(response.body);
          if (einsatzFromDb.isEmpty) {
            einsatzPlan = _setEinsatzError('keine Daten gefunden');
          }
          else {
            if (einsatzFromDb.length == 1) {
              // Fehler wenn nur eines?
              // TODO müsste eigentlich auf "error" prüfen
              Map<String, dynamic> meldung = einsatzFromDb.elementAt(0);
              if (meldung.containsKey('error')) {
                einsatzPlan = _setEinsatzError( meldung['error']);
              }
              else {
                einsatzPlan = _setEinsatzData(einsatzFromDb);
              }
            }
            else {
              einsatzPlan = _setEinsatzData(einsatzFromDb);
            }
          }
        }
        else {
          einsatzPlan = _setEinsatzError('keine Daten gefunden');
        }
      }
    } catch (e) {
      // Könnte sein, dass response eine Error-Message enthält
      einsatzPlan = _setEinsatzError(e.toString());
    }
    return einsatzPlan;
  }

  /// Einen Einsatz speichern
  Future<String> addEinsatz(int idDatum, int idMa) async {
    try {
      final response = await http.post(MyUri.getUri("/addEinsatz.php"),
          body: {"dbUser": global.dbUserWrite, "dbpass": global.dbpass,
          "idDatum": idDatum.toString(), "idMa": idMa.toString()});
      if (response.body.isNotEmpty) {
        return response.body.toString();
      }
    } catch (e) {
      // Könnte sein, dass response eine Error-Message enthält
      return "addEinsatz: Fehler beim Speichern";
    }
    return "OK";
  }

  Future<String> delEinsatz(int idDatum, int idMa) async {
    try {
      final response = await http.post(MyUri.getUri("/delEinsatz.php"),
          body: {"dbUser": global.dbUserWrite, "dbpass": global.dbpass,
          "idDatum": idDatum.toString(), "idMa": idMa.toString()});
      if (response.body.isNotEmpty) {
        Object oo = response.body;
        print(oo);
      }
    } catch (e) {
      // Könnte sein, dass response eine Error-Message enthält
      return "delEinsatz: Fehler beim Speichern";
    }
    return "OK";
  }

  /// Den Einsatzplan mi den entsprechenden Daten füllen
  List<EinsatzMa> _setEinsatzData(List einsatzFromDb) {
    List<EinsatzMa> einsatzPlan = [];
    for (var element in einsatzFromDb) {
      EinsatzMa einsatz = EinsatzMa.fromMap(element);
      einsatzPlan.add(einsatz);
    }
    // TODO: Liste sortieren
    // einsatzPlan.sort(einsatzComparator);
    return einsatzPlan;
  }

  /// TODO: auch Zeit vergleichen
  // Comparator<Einsatz> einsatzComparator = (a, b) => a.datum?.compareTo(b.datum);

  EinsatzPlanData.fromList(List<dynamic> einsatzList) {
    einsatzPlan = [];
    for (var element in einsatzList) {
      EinsatzMa einsatz = EinsatzMa.fromMap(element);
      einsatzPlan.add(einsatz);
    }
  }

  /// Den Einsatzplan setzen, wenn keine Daten gefunden,
  /// oder sonstige Fehler
  List<EinsatzMa> _setEinsatzError(String errorMessage) {
    EinsatzMa einsatzErr = EinsatzMa(DateTime.now().toString(), "error",
        errorMessage, []);
    List<EinsatzMa> einsatzListe = [];
    einsatzListe.add(einsatzErr);
    return einsatzListe;
  }
}
