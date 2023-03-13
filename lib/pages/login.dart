import 'package:askme/model/email_sender.dart';
import 'package:askme/model/mitarbeiter.dart';
import 'package:flutter/material.dart';
import 'package:askme/model/globals.dart' as global;

import '../model/globals.dart';
import '../model/login_check.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPw = TextEditingController();
  final TextEditingController _txtInfo = TextEditingController();
  final int minLengthPw = 6;

  bool _showUserPw = false;
  // die Anzahl Zeilen in der Info
  int _txtInfoLines = 0;

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    navigatorKey;
    // damit etwas dargestellt
    if (_txtInfoLines <= 0) {
      _txtInfoLines = 1;
    }
    // Testmode: Kein User eingeben
    if (global.testMode) {
      _txtEmail.text = "test1@ask.ch";
      _txtPw.text = "test11";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(global.titel),
      ),
      body: SizedBox(
        height: 500,
        width: 600,
        child: Column(
          children: [
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    controller: _txtEmail,
                    decoration: const InputDecoration(
                        labelText: "e-mail",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextField(
                    controller: _txtPw,
                    decoration: InputDecoration(
                      labelText: "Passwort",
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showUserPw = !_showUserPw;
                          });
                        },
                        child: Icon(
                          _showUserPw ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !_showUserPw,
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ElevatedButton(
                child: const Text('Login', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  _loginCheck();
                },
              ),
            ),
            OutlinedButton(
              child: const Text("Passwort vergessen"),
              onPressed: () {
                _passVergessen(context);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: const Text("Connection test"),
                    onPressed: () {
                      _testConnection(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: const Text("DB test"),
                    onPressed: () {
                      _testDB(context);
                    },
                  ),
                ),
              ]),
            ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  maxLines: _txtInfoLines,
                  controller: _txtInfo,
                  readOnly: true,
                )),
          ],
        ),
      ),
    );
  }

  /// wenn login ok, dann werden alle Mitarbeiter geladen
  /// damit die Einsatzlist schneller erstellt werden kann.
  void _loginCheck() async {
    LoginMa loginMa = LoginMa(_txtEmail.text, _txtPw.text, "");
    String respond = await LoginCheck.check(loginMa);

    // sollte idMaLogedIn erhalten wenn erfolgreich
    if (int.tryParse(respond) != null) {
      global.idMaLogedIn = int.parse(respond);
      MaAll maAll = MaAll();
      global.maAllList = await maAll.readMaAll();
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/einsatzplan', arguments: {});
    } else {
      global.idMaLogedIn = -1;
      _displayInfo(respond);
    }
  }

  // wenn Passwort vergessen
  void _passVergessen(BuildContext context) {
    if (_txtEmail.text.isEmpty || _txtEmail.text.length < minLengthPw) {
      setState(() {
        _txtInfo.text = "Bitte e-mail eingeben";
      });
    } else {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Ist die e-mail korrekt?"),
                content: Text(_txtEmail.text),
                actions: [
                  TextButton(
                      child: Text("Nein"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      }),
                  TextButton(
                      child: Text("Ja"),
                      onPressed: () {
                        _emailSenden();
                        Navigator.of(ctx).pop();
                      }),
                ],
              ));
    }
  }

  /// Die Error-Message anzeigen
  void _displayInfo(String message) {
    double zeilen = message.length / 40;
    _txtInfoLines = zeilen.round();
    if (_txtInfoLines > 6) {
      _txtInfoLines = 6;
    }
    setState(() {
      _txtInfo.text = message;
    });
  }

  // wenn Passwort vergessen
  Future _emailSenden() async {
    setState(() {
      _displayInfo("Ich sende ein email an: ${_txtEmail.text}");
    });
    EmailSender.sendEmail("ruedi.moser1@gmail.com", "xxyy");
  }

  void _testConnection(BuildContext context) async {
    String respond = await LoginCheck.testConnection();
    setState(() {
      _displayInfo(respond);
    });
  }

  void _testDB(BuildContext context) async {
    String respond = await LoginCheck.testDb();
    setState(() {
      _displayInfo(respond);
    });
  }
}
