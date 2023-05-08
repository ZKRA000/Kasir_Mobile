import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir/main.dart';
import 'package:kasir/other/sqflite.dart';
import './env.dart';

Future<void> getUser(callback) async {
  final response = await http.get(Uri.parse('$baseUrl/api/user'), headers: {
    'User-Agent': 'android-app',
    'Authorization': 'Bearer $personalToken',
    'Accept': 'application/json',
  });

  if (response.statusCode == 200) {
    return callback(response);
  } else if (response.statusCode == 401) {
    await tableTruncate('personal_token');
    navigatorKey.currentState?.pushReplacementNamed('/');
  } else {
    throw Exception('failed to get users');
  }
}

Future<void> createUser(formData, callback) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/user/create'),
    headers: {
      'User-Agent': 'android-app',
      'Authorization': 'Bearer $personalToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(formData),
  );

  if (response.statusCode == 200) {
    return callback(response);
  } else if (response.statusCode == 401) {
    await tableTruncate('personal_token');
    navigatorKey.currentState?.pushReplacementNamed('/');
  } else {
    throw Exception('failed create user');
  }
}
