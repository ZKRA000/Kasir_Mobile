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

  dynamic check(response) async {
    if ([200, 422].contains(response.statusCode)) {
      // success, error inpute validation

      return response;
    } else if (response.statusCode == 401) {
      // unauthenticated
      await tableTruncate('personal_token');
      navigatorKey.currentState?.pushReplacementNamed('/');
      return null;
    } else {
      // other
      print(response.body);
      throw Exception('error');
    }
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

    return check(response);
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
    return check(response);
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
    return check(response);
  }

  // Future<dynamic> postMultipart(
  //     String url, Map<String, dynamic> formData, File? file) async {
  //   String token = await getToken();
  //   Map<String, String> headers = setHeaders({
  //     'Authorization': 'Bearer $token',
  //   });

  //   if (file != null) {
  //     String fileName = file.path.split('/').last;
  //     formData.addAll({
  //       "logo": await MultipartFile.fromFile(file.path, filename: fileName)
  //     });
  //   }

  //   final dio = Dio();
  //   var response = await dio.post(url,
  //       data: FormData.fromMap(formData), options: Options(headers: headers));

  //   print(response);

  //   return check(response);
  // }
}
