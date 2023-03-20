import 'package:flutter/material.dart';

import '../model/einsatz_data.dart';
import '../model/ma_data.dart';
import '../model/globals.dart' as global;
import 'app_bar.dart';
import 'drawer_links.dart';

/// Administration der Mitarbeiter: CRUD
class AdminMa extends StatefulWidget {
  @override
  State<AdminMa> createState() => _AdminMaState();
}

class _AdminMaState extends State<AdminMa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.get(context),
        body: Row(
          children: [
            Column(
              children: [
                Text("xx"),
              ],
            ),
            Column(
              children: [
                Text("yy"),
              ],
            ),
          ],
        ));
  }
}
