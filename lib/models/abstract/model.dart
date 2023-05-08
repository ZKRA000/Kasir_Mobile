import 'package:kasir/main.dart';
import 'package:kasir/models/abstract/abstract.dart';
import 'package:kasir/other/sqflite.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir/other/env.dart';

class Model extends AbstractModel {
  Future<String> getToken() async {
    List<Map<String, dynamic>> data = await tableShow('personal_token');
    return data.isEmpty ? '' : data.first['token'];
  }

  Map<String, String> setHeaders([Map<String, String>? additionalHeaders]) {
    Map<String, String> headers = {
      'User-Agent': 'android-app',
      'Accept': 'application/json',
    };

    if (additionalHeaders != null) {
      for (var key in additionalHeaders.keys) {
        headers[key] = additionalHeaders[key] ?? '';
      }
    }

    return headers;
  }

  dynamic check(response) async {
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      await tableTruncate('personal_token');
      navigatorKey.currentState?.pushReplacementNamed('/');
    } else {
      print(response.body);
      throw Exception('error');
    }
  }

  @override
  Future<dynamic> get(url) async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(url),
      headers: setHeaders({
        'Authorization': 'Bearer $token',
      }),
    );

    return check(response);
  }

  @override
  Future<dynamic> post(url, formData) async {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(url),
      headers: setHeaders({
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      }),
      body: jsonEncode(formData),
    );

    return check(response);
  }
}
