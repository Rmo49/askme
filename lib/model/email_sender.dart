import 'package:http/http.dart' as http;
import 'my_uri.dart';

class EmailSender {
  static Future<String> sendEmail(String address, String mailCode) async {
    try {
      final http.Response response = await http.post(
          MyUri.getUri("/mailSenden.php"),
          body: {"address": address, "mailCode": mailCode});
      if (response.statusCode != 200) {
        return "Problem beim e-mail senden";
        // TODO: Probleme beim senden
      }
    } catch (e) {
      // Könnte sein, dass email nicht gesendet werden können
      return e.toString();
    }
    return "ok";
  }
}
