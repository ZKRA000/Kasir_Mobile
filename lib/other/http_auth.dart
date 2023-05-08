import 'dart:convert';
import 'package:http/http.dart' as http;
import './env.dart';

Future<void> login(formData, callback) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/login'),
    headers: {
      'User-Agent': 'android-app',
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(formData),
  );

  print(response.body);

  return callback(response);
}
