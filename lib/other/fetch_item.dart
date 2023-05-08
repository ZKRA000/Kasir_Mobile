import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir/main.dart';
import 'package:kasir/other/sqflite.dart';
import './env.dart';

Future<dynamic> getItem(callback) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/item'),
    headers: {
      'User-Agent': 'android-app',
      'Authorization': 'Bearer $personalToken',
    },
  );

  if (response.statusCode == 200) {
    return callback(response);
  } else if (response.statusCode == 401) {
    await tableTruncate('personal_token');
    navigatorKey.currentState?.pushReplacementNamed('/');
  } else {
    throw Exception('error cant get items');
  }
}

Future<dynamic> createItem(formData, callback) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/item/create'),
    headers: {
      'User-Agent': 'android-app',
      'Authorization': 'Bearer $personalToken',
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
    throw Exception('Failed to create');
  }
}

Future<dynamic> deleteItem(formData, callback) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/item/delete'),
    headers: {
      'User-Agent': 'android-app',
      'Authorization': 'Bearer $personalToken',
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
    throw Exception('Failed to delete');
  }
}
