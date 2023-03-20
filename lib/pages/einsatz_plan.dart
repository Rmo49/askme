import 'package:flutter/material.dart';

import '../model/einsatz_data.dart';
import '../model/ma_data.dart';
import '../model/globals.dart' as global;
import 'app_bar.dart';
import 'drawer_links.dart';

class EinsatzPlan extends StatefulWidget {
  @override
  State<EinsatzPlan> createState() => _EinsatzPlanState();
}

class _EinsatzPlanState extends State<EinsatzPlan> {
  // TODO muss noch automatisiert werden mit Kalender
  List<String> monatList = <String>['April', 'Mai', 'Juni'];

  final DrawerLinks _homeDrawer = DrawerLinks();

  // Einsatz Plan  Liste aller Einsätze, Zugriff auf Date
  final EinsatzPlanData _einsatzData = EinsatzPlanData();

  // die Daten eines Monates
  List<EinsatzMa> _einsatzList = [];

  // die Höhe der Rows
  final double colH = 20.0;
  // die Breite der Rows
  final double col1 = 80.0;
  final double col2 = 100.0;
  // ab 3. Col flexibel
  final int flex3 = 1;
  final int flex4 = 10;
  final int flex5 = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.get(context),
      body: Column(
        children: [_showMenu(context), _showEinsatzPlan(context)],
      ),

      // das Menü auf der linken Seite
      drawer: _homeDrawer.getDrawer(context),
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: true,
    );
  }

  /// Das Menu mit Monatsauswahl und Buttons
  Widget _showMenu(BuildContext context) {
    String dropdownValue = monatList.first;

    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
                value: dropdownValue,
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
                    dropdownValue = value!;
                  });
                },
                items: monatList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _readData(),
              child: const Text('anzeigen'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _save(context),
              child: const Text('speichern'),
            ),
          ),
        ],
      ),
    );
  }

  /// der gesamte Einsatzplan im unteren Screeenbereich
  Widget _showEinsatzPlan(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: _showRowListEinsatz(context)),
      ),
    );
  }

  /// Die Liste aller Einsätze
  List<Widget> _showRowListEinsatz(BuildContext context) {
    List<Widget> rowList = [];
    // nur Text anzeigen, wenn keine Daten
    if (_einsatzList.isEmpty) {
      rowList.add(Row(children: [
        Text("noch keine Daten \n auf Anzeigen drücken wenn Monat gewählt")
      ]));
      return rowList;
    }
    else {
      EinsatzMa element = _einsatzList[0];
      if (element.zeit!.startsWith('error')) {
        String? fehler = element.names;
        rowList.add(Row(children: [
          Text("Fehler:  $fehler")
        ]));
        return rowList;
      }
      // alle Einsätze anzeigen
      for (EinsatzMa element in _einsatzList) {
        rowList.add(_getRowEinsatz(context, element));
      }
      return rowList;
    }
  }

  /// Eine Zeile darstellen, wenn Wochenende eeingegraut
  Widget _getRowEinsatz(BuildContext context, EinsatzMa einsatz) {
    // zuerst die Namen lesen
    String maNames = _getMaNames(einsatz.idMaList);
    // Sa/So grau
    Color? dayColor;
    int? day = einsatz.datum?.weekday;
    if (day! >= 6) {
      dayColor = Colors.grey[300];
    } else {
      dayColor = Colors.transparent;
    }

    return Container(
      height: colH,
      margin: EdgeInsets.only(right: 8.0, left: 8.0),
      color: dayColor,
      child: Row(
        children: [
          SizedBox(
              width: col1,
              child: Text(global.dateDisplay.format(einsatz.datum!))),
          SizedBox(width: col2, child: Text(einsatz.zeit!)),
          Expanded(flex: flex3, child: _getCheckbox(einsatz)),
          Expanded(flex: flex4, child: Text(maNames)),
          Expanded(flex: flex5, child: _getDelIcon(einsatz))
        ],
      ),
    );
  }

  /// Entscheidet, ob Checkbox angezeigt werden soll.
  Widget _getCheckbox(EinsatzMa einsatz) {
    if (!_isInList(global.idMaLogedIn, einsatz.idMaList) &&
        (einsatz.idMaList.isEmpty || einsatz.idMaList.length < 2)) {
      return Transform.scale(
        scale: 0.8,
        child: Checkbox(
            value: einsatz.isChecked,
            onChanged: (bool? value) {
              _checkboxChanged(context, value, einsatz);
            }),
      );
    }
    return Text("");
  }

  /// Entscheidet, ob delete Icon angezeigt werden soll.
  Widget _getDelIcon(EinsatzMa einsatz) {
    if (_isInList(global.idMaLogedIn, einsatz.idMaList)) {
      return IconButton(
        icon: Icon(Icons.delete),
        iconSize: 15.0,
        onPressed: () => _maDelete(context, einsatz),
      );
    }
    return Text("");
  }

  /// prüft, ob die SuchId in der Liste ist
  bool _isInList(int idSuch, List<int> idMaList) {
    for (int idMa in idMaList) {
      if (idSuch == idMa) {
        return true;
      }
    }
    return false;
  }

  /// Die Namen zusammensetzen
  String _getMaNames(List<int> idMaList) {
    StringBuffer name = StringBuffer();
    for (int idMa in idMaList) {
      if (name.length > 0) {
        name.write(", ");
      }
      name.write(MaAll.getName(idMa));
    }
    return name.toString();
  }

  _checkboxChanged(BuildContext context, bool? value, EinsatzMa einsatz) {
    setState(() {
      einsatz.isChecked = value!;
    });
  }

  /// löschen eines Einsatzens
  _maDelete(BuildContext context, EinsatzMa einsatz) {
    String datum;
    datum = global.dateDisplay.format(einsatz.datum!);
    // fragen
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Einsatz löschen?"),
              content: Text('vom: $datum'),
              actions: [
                TextButton(
                    child: Text("Ja"),
                    onPressed: () {
                      _maLoeschen(einsatz.idDatum);
                      Navigator.of(ctx).pop();
                    }),
                TextButton(
                    child: Text("Nein"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
              ],
            ));
  }

  void _maLoeschen(int idDatum) async {
    // ignore: unused_local_variable
    String respond = await _einsatzData.delEinsatz(idDatum, global.idMaLogedIn);

    // ignore: await_only_futures
    _einsatzList = await _readData();
    setState(() {});
  }

  /// zuerst den Einsatzplan einlesen
  Future<List<EinsatzMa>> _readData() async {
    _einsatzList = await _einsatzData.readEinsatzAll('2023-04');
    setState(() {
      _showRowListEinsatz(context);
    });
    return _einsatzList;
  }

  /// Alle Daten in die DB speichern
  void _save(BuildContext context) async {
    // ignore: unused_local_variable
    String respond = "";
    for (EinsatzMa einsatz in _einsatzList) {
      if (einsatz.isChecked) {
        respond =
            await _einsatzData.addEinsatz(einsatz.idDatum, global.idMaLogedIn);
        if (!respond.startsWith("OK")) {
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Fehler"),
                content: Text(respond),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context)),
                ],
              ));
        }
      }
    }
    // ignore: await_only_futures
    _einsatzList = await _readData();
    setState(() {});
  }
}
