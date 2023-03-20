import 'package:askme/model/woche_data.dart';
import 'package:flutter/material.dart';

import '../model/einsatz_data.dart';
import '../model/ma_data.dart';
import '../model/globals.dart' as global;
import 'app_bar.dart';
import 'drawer_links.dart';

/// Administration der Zeiten: Montatsdaten generieren, freischalten
class AdminZeiten extends StatefulWidget {
  @override
  State<AdminZeiten> createState() => _AdminZeitenState();
}

class _AdminZeitenState extends State<AdminZeiten> {
  // damit Menu sichtbar
  final DrawerLinks _homeDrawer = DrawerLinks();

  // TODO muss noch automatisiert werden mit Kalender
  //List<String> _monatList = <String>['April', 'Mai', 'Juni'];
  List<Monat> _monatList = <Monat>[];
  //List<String> _monatListStr = <String>['April', 'Mai', 'Juni'];
  List<String> _monatListStr = <String>[];
  // Der Wert des Dropdown wenn selektiert
  String _dropdownValue = "";
  // die Liste der generierten Zeiten
  List<Einsatz> _einsatzList = [];
  // der Controller für die Liste der Zeiten
  final _zeitScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _setupMonatList();
  }

  void _setupMonatList() async {
    _monatList = await MonatList.setupMonatList();
    String mmm = _monatList.first.name;
    for (var mon in _monatList) {
      _monatListStr.add(mon.name);
    }
    setState(() {
        _dropdownValue = _monatListStr.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.get(context),
        body: Column(
          children: [
            SizedBox(
              height: 100,
              child: _showMenu(context),
            ),
            _showZeiten(context)
          ],
        ));
  }

  /// die Zeile mit Auswahl und Buttons
  Widget _showMenu(BuildContext context) {
   return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
              value: _dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  _dropdownValue = value!;
                });
              },
              items: _monatListStr.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()),
        ),
        ElevatedButton(
          child: const Text('Generieren', style: TextStyle(fontSize: 16)),
          onPressed: () {
            _genZeiten();
          },
        ),
      ],
    );
  }


  /// der Bereich mit der Anzeige aller generierten Zeiten
  Widget _showZeiten(BuildContext context) {
    return Expanded(
        child: Scrollbar(
          thickness: 10.0,
          controller: _zeitScrollController,
          child: ListView(
              scrollDirection: Axis.vertical,
              controller: _zeitScrollController,
              padding: const EdgeInsets.all(6),
              children: _showRowListZeiten(context)
          ),
        ),
      );
  }

  /// Eine Zeile der Zeiten anzeigen
  List<Widget> _showRowListZeiten (BuildContext context) {
    List<Widget> rowList = [];
    for (Einsatz einsatz in _einsatzList) {
      //rowList.add(_getRowEinsatz(context, element));
      rowList.add(
        Row(
          children: [
            Text(einsatz.datum.toString()),
            Text(einsatz.zeit!),
          ],
        )
      );
    }
    return rowList;
  }


  /// Die Liste mit den Zeiten generieren
  void _genZeiten() async {
    DateTime startDatum = _getStartDatum();
    int monat = startDatum.month;
    List<WochenTag> woche = await Woche.readWoche();
    if (woche.isEmpty) {
      // TODO Fehler anzeigen
      return;
    }
    String time1 = "10:30";
    String time2 = "18:30";

    while (startDatum.month == monat) {
      int weekday = startDatum.weekday;
      int index = mustGenerate(weekday, time1, woche);
      if (index >= 0) {
        Einsatz einsatz = Einsatz(startDatum, woche.elementAt(index).zeit);
        _einsatzList.add(einsatz);
      }
      index = mustGenerate(weekday, time2, woche);
      if (index >= 0) {
        Einsatz einsatz = Einsatz(startDatum, woche.elementAt(index).zeit);
        _einsatzList.add(einsatz);
      }
      // einen Tag weiter weiter
      startDatum = startDatum.add(Duration(days: 1));
    }
  }


  /// den selektierten Monat ermitteln
  DateTime _getStartDatum() {
    int jahrHeute = global.heute.year;
    int monatHeute = global.heute.month;
    int monatSel = _getMonat();
    if (monatSel < monatHeute) {
      jahrHeute++;
    }
    return DateTime(jahrHeute, monatSel, 1);
  }

  /// Den selektierten Monat ermitteln
  int _getMonat() {
    for (var monat in _monatList) {
      if (monat.name.compareTo(_dropdownValue) == 0) {
        return monat.nr;
      }
    }
    return -1;
  }

  /// Muss für diesen Tag generiert werden?
  /// wenn ja wird die Position in der Liste zurückgegeben
  int mustGenerate(int weekday, String time, List<WochenTag> woche) {
    int index = 0;
    while (index < woche.length) {
      WochenTag wt = woche.elementAt(index);
      if (wt.tagNr == weekday) {
        if (wt.zeit.contains(time)) {
          return index;
        }
      }
      index++;
    }
    return -1;
  }
}
