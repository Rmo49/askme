import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'drawer_links.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  // das Menü auf der linken Seite
  final DrawerLinks _homeDrawer = DrawerLinks();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar.get(context),
        drawer: _homeDrawer.getDrawer(context),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          crossAxisCount: 4,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text('Datum'),
            Text('Zeit'),
            Checkbox(
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
            Text('Mitarbeiterinnen'),
            Text('test'),
            Text('test'),
            Text('test'),
            Text('test'),
            Text('test'),
            Text('test'),
          ],
        ));
  }
}
