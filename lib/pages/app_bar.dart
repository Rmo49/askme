import 'package:flutter/material.dart';
import 'package:askme/model/globals.dart' as global;

/// Die Appbar für alle Screens
class MyAppBar {
  static PreferredSizeWidget get(BuildContext context) {
    return AppBar(
      title: Text(global.titel),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // ruft scheinbar drawer: Drawer (weiter unten) auf.
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
    );
  }
}
