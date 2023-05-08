import 'package:http/http.dart' as http;
import 'package:kasir/main.dart';
import 'package:kasir/other/env.dart';
import 'package:kasir/other/sqflite.dart';

Future<void> getRole(callback) async {
  final response = await http.get(Uri.parse('$baseUrl/api/role'), headers: {
    'User-Agent': 'android-app',
    'Authorization': 'Bearer $personalToken',
    'Accept': 'application/json'
  });

  if (response.statusCode == 200) {
    return callback(response);
  } else if (response.statusCode == 401) {
    await tableTruncate('personal_token');
    navigatorKey.currentState?.pushReplacementNamed('/');
  } else {
    throw Exception('failed to get role');
  }
}
