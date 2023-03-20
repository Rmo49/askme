import 'package:askme/model/pw_encypt.dart';
import 'package:flutter/material.dart';

class Verschluesseln extends StatelessWidget {

  final TextEditingController _txtPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _txtPw.text = 'Php.4010d';
    return Scaffold(
      body:        SizedBox(
    height: 300,
    width: 400,
    child: Column(
        children: [
          TextField(
            controller: _txtPw,
            decoration: const InputDecoration(
                labelText: "Passwort",
                border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)))),
          ),

          OutlinedButton (
            child: Text("encrypt"),
            onPressed: () {
            _doEncyption(context);
            }
          )
        ],
      ),
  )
    );}


  void _doEncyption(BuildContext context) {
    PwEncrypter.encrypt(_txtPw.text);
  }

}