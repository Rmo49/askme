import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

class PwEncrypter {

  static void encrypt(String pwText) {
    //final key = Key.fromUtf8('my 32 length key................');
    final key = Key.fromUtf8('Theater Basel: Foyer Ask-Me Team');

    final iv = IV.fromLength(16);


    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(pwText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    //final decr1 = encrypter.decrypt(encr1, iv: iv);

    print(decrypted);
    print(encrypted.base64);

    // das Passwort müsste in dieser Form gespeichert werden
    Uint8List unit8 = base64.decode("dH3miBlVcIkVOgNEKvShyA==");
    print(unit8);
    var encr1 = Encrypted(unit8);
    final decr1 = encrypter.decrypt(encr1, iv: iv);
    print ("von final: $decr1");


  }
}
