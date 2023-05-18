import 'dart:io';

import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class NotaModel extends Model {
  Future<dynamic> all() async {
    return await get('$baseUrl/api/nota');
  }

  Future<dynamic> create(Map<String, dynamic> body, File? file) async {
    return await postMultipart('$baseUrl/api/nota/create', body, file);
  }

  Future<dynamic> update(Map<String, dynamic> body, File? file) async {
    return await postMultipart('$baseUrl/api/nota/edit', body, file);
  }

  Future<dynamic> delete(body) async {
    return await post('$baseUrl/api/nota/delete', body);
  }
}
