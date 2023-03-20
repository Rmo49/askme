import 'dart:async';

import 'package:flutter/material.dart';

import '../model/woche_data.dart';
import 'app_bar.dart';
import 'drawer_links.dart';

class AdminStart {}

/// Setup: Standardwoche
class AdminSetup extends StatefulWidget {
  @override
  State<AdminSetup> createState() => _AdminSetupState();
}

class _AdminSetupState extends State<AdminSetup> {
  // damit Menu sichtbar
  final DrawerLinks _homeDrawer = DrawerLinks();
  final TextEditingController _txtInfo = TextEditingController();
  // die Anzahl Zeilen in der Info
  int _txtInfoLines = 0;

  // die daten hinter der Liste, von der DB hieher kopiert
  List<WochenTag> _woche = [];
  // der Controller für die Liste der Wochentage (wt)
  final wtScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.get(context),
      body: Column(
        children: [
          _showButtons(context),
          _showWochenList(context),
        ],
      ),

      // das Menü auf der linken Seite
      drawer: _homeDrawer.getDrawer(context),
      // Disable opening the drawer with a swipe gesture.
      drawerEnableOpenDragGesture: true,
    );
  }

  /// Die Steuerung
  Widget _showButtons(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                child: const Text('Speichern', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  _wtUpdate();
                },
              ),
            ),
          ),
          TextField(
            maxLines: _txtInfoLines,
            controller: _txtInfo,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  /// die Liste mit den Wocheneinträgen
  Widget _showWochenList(BuildContext context) {
    return FutureBuilder(
        future: _readWochentage(),
        builder: (BuildContext ctx, AsyncSnapshot<List<WochenTag>> snapshot) =>
            snapshot.hasData
                ? Expanded(
                    child: Scrollbar(
                      thickness: 10.0,
                      controller: wtScrollController,
                      child: ListView(
                          scrollDirection: Axis.vertical,
                          controller: wtScrollController,
                          padding: const EdgeInsets.all(6),
                          children: _getTageList(ctx, snapshot)),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
  }

  List<Widget> _getTageList(
      BuildContext context, AsyncSnapshot<List<WochenTag>> snap) {
    // zuerst alles in eine neue Liste, damit nicht immer gelesen wird von DB
    if (_woche.isEmpty) {
      for (int i = 0; i < snap.data!.length; i++) {
        WochenTag wt = snap.data![i];
        _woche.add(wt);
      }
    }

    List<Widget> widgetList = [];
    for (var wt in _woche) {
      widgetList.add(
        Row(
          children: [
            Checkbox(
              value: wt.isSelected,
              onChanged: (bool? value) {
                _checkboxChanged(context, value, wt);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(wt.tag),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(wt.zeit),
            )
          ],
        ),
      );
    }

    return widgetList;
  }

  /// wenn Checkbox geändert wurde
  void _checkboxChanged(BuildContext context, bool? value, WochenTag wt) {
    setState(() {
      wt.isSelected = value!;
    });
  }

  /// Die Daten einlesen, nur wenn noch nicht gelesen
  Future<List<WochenTag>> _readWochentage() async {
    List<WochenTag> wt = [];
    if (_woche.isEmpty) {
      wt = await Woche.readWoche();
    }
    return wt;
  }

  /// die Liste in der DB speichern
  /// TODO: nur geänderte Einträge
  void _wtUpdate() async {
    String res = "";
    for (var wt in _woche) {
      res = await Woche.updateWt(wt);
      if (res.contains("error")) {
        _txtInfo.text = res;
        break;
      }
    }
  }
}
