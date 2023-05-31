import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kasir/main.dart';
import 'package:kasir/models/abstract/abstract.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kasir/other/sqflite.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<dynamic> check(res) async {
    print(res.body);
    if (res.statusCode == 401) {
      // unauthenticated
      await tableTruncate('personal_token');
      navigatorKey.currentState?.pushReplacementNamed('/');
    }

    try {
      // trigger exception if json string is invalid
      jsonDecode(res.body);
    } on FormatException catch (e) {
      throw (e);
    }

    return res;
  }

  @override
  Future<dynamic> get(url) async {
    String token = await getToken();
    Map<String, String> headers = setHeaders({
      'Authorization': 'Bearer $token',
    });
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return await check(response);
  }

  @override
  Future<dynamic> post(url, formData) async {
    String token = await getToken();
    Map<String, String> headers = setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    });
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(formData),
    );
    return await check(response);
  }

  Future<dynamic> postMultipart(
      String url, Map<String, dynamic> formData, File? file) async {
    String token = await getToken();
    Map<String, String> headers = setHeaders({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var multiPart = http.MultipartRequest('POST', Uri.parse(url));
    multiPart.headers.addAll(headers);

    formData.forEach((key, value) {
      multiPart.fields[key] = value.toString();
    });

    if (file != null) {
      // var stream = http.ByteStream(file.openRead());
      // stream.cast();
      // var length = await file.length();
      // var uploadedFile = http.MultipartFile('logo', stream, length);

      var uploadedFile = await http.MultipartFile.fromPath('logo', file.path);
      multiPart.files.add(uploadedFile);
    }

    var streamedResponse = await multiPart.send();
    var response = await http.Response.fromStream(streamedResponse);

    return await check(response);
  }
}
