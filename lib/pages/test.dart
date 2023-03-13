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

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   //     appBar: MyAppBar.get(context),
    //    drawer: _homeDrawer.getDrawer(context),
        body: SizedBox(
          height: 500,
          width: 300,
          child: Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Entry A')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: const Center(child: Text('Entry C')),
                ),
              ],
            ),
          ),
        )
    );

  //        children: [_getMenu(context), _getRowList(context)],
  }

  Widget _getMenu(BuildContext context) {
    return Text("Menu");
  }

  Widget _getRowList(BuildContext context) {
    List<Row> rowList = [];
    rowList.add(getRow1(context));
    rowList.add(getRow2(context));
    rowList.add(getRow3(context));
    rowList.add(getRow3(context));
    rowList.add(getRow2(context));
    rowList.add(getRow2(context));
    rowList.add(getRow2(context));
    rowList.add(getRow3(context));
    rowList.add(getRow3(context));
    rowList.add(getRow3(context));

    return SizedBox(
      height: 500,
      child: ListView.builder(
        shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: rowList.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 50,
              child: Center(child: Text('Entry')),
            );
          }
      ),
    );
  }

  Row getRow1(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.0, child: Text('Datum')),
        SizedBox(width: 100.0, child: Text('Zeit')),
        SizedBox(
          width: 40.0,
        ),
        Text('Mitarbeiterinnen'),
      ],
    );
  }

  Row getRow2(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.0, child: Text('Mo 3.4')),
        SizedBox(width: 100.0, child: Text('10:30 - 14:30')),
        SizedBox(
          width: 40.0,
        ),
        Text('Marianne Jahn, Valerie Obrist'),
      ],
    );
  }

  Row getRow3(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50.0, child: Text('Di 4.4')),
        SizedBox(width: 100.0, child: Text('14:30 - 18:30')),
        SizedBox(
            width: 40.0,
            height: 20.0,
            child: Transform.scale(
              scale: 1.0,
              child: Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  }),
            )),
        Text('Ruedi Moser'),
      ],
    );
  }
}
