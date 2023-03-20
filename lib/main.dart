import 'package:askme/pages/admin_ma.dart';
import 'package:askme/pages/admin_zeiten.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:askme/model/globals.dart' as global;
import 'package:askme/pages/einsatz_plan.dart';
import 'package:askme/pages/login.dart';
import 'package:askme/pages/test.dart';
import 'package:askme/pages/verschluesseln.dart';
import 'package:askme/pages/admin_setup.dart';

void main() {
  initializeDateFormatting("de_CH", null);
  global.dateDisplay = DateFormat('E d.M.', "de_CH");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Anzeige der Buttons
  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      minimumSize: const Size(120, 40),
      elevation: 5,
      textStyle: const TextStyle(fontSize: 16),
      padding: const EdgeInsets.all(16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ));

  final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue[300],
    padding: const EdgeInsets.all(16),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AskMe Theater Basel',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
//          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//          headline6: TextStyle(fontSize: 20.0),
        ),
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: elevatedButtonStyle),
        textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      ),

      initialRoute: '/login',
      routes: {
        '/login': (context) => Login(),
        '/einsatzplan': (context) => EinsatzPlan(),
        '/testpage': (context) => Test(),
        '/verschluesseln': (context) => Verschluesseln(),
        '/adminSetup': (context) => AdminSetup(),
        '/adminZeiten': (context) => AdminZeiten(),
        '/adminMa': (context) => AdminMa(),
      },
      // damit kein BuildContext across async gaps.
//      navigatorKey: global.navigatorKey,
    );
  }
}
