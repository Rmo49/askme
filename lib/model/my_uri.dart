import 'globals.dart' as global;

class MyUri {
  static Uri getUri(String pathTemp) {
    // nur damit ein Objekt angelegt.
    String lPath = global.pathPhp + pathTemp;
    Uri uri;

    if (global.testUri) {
      // wenn auf Testumgebung zugreifen muss
      uri = Uri(scheme: "http", host: "localhost", port: 8082, path: lPath);
    } else {
      // Im Internet
      uri = Uri(scheme: global.scheme, host: global.host, path: lPath);
    }
    return uri;
  }
}
