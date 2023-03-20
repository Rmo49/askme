import 'package:flutter/material.dart';

import '../model/login_check.dart';

/// Die Anzeige der Einstellungen.
/// Wird angezeigt, wenn das Meun links oben selektiert wird
class DrawerLinks {
  getDrawer(BuildContext context) {
    return Drawer(
        width: 200,
        child: ListView(padding: EdgeInsets.zero, children: [
          SizedBox(
            height: 60,
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
          ),
          ListTile(
            title: const Text('Test Connection'),
            onTap: () {
              _testConnection(context);
            },
          ),
          ListTile(
            title: const Text('Test DB'),
            onTap: () {
              _testDB(context);
            },
          ),
          ListTile(
            title: const Text('Test page'),
            onTap: () {
              Navigator.pushNamed(context, '/testpage', arguments: {});
            },
          ),
          ListTile(
            title: const Text('Setup'),
            onTap: () {
              Navigator.pushNamed(context, '/adminSetup', arguments: {});
            },
          ),
          ListTile(
            title: const Text('Monat planen'),
            onTap: () {
              Navigator.pushNamed(context, '/adminZeiten', arguments: {});
            },
          ),
          ListTile(
            title: const Text('Mitarbeiter'),
            onTap: () {
              Navigator.pushNamed(context, '/adminMa', arguments: {});
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushNamed(context, '/login', arguments: {});
            },
          ),
        ])

/*
      child: Column(children: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/test', arguments: {});
          },
          child: const Text('Test page'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login', arguments: {});
          },
          child: const Text('Login'),
        )
      ]),
      */
        );
  }

  void _testConnection(BuildContext context) async {
    String respond = await LoginCheck.testConnection();
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Connection Test"),
              content: Text(respond),
              actions: [
                TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
              ],
            ));
  }

  void _testDB(BuildContext context) async {
    String respond = await LoginCheck.testDb();
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("DB Test"),
              content: Text(respond),
              actions: [
                TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    }),
              ],
            ));
  }
}
