import 'package:kasir/models/abstract/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir/other/env.dart';

class ItemModel extends Model {
  Future<dynamic> all() async {
    final response = await get('$baseUrl/api/item');
    return check(response);
  }

  Future<dynamic> create(body) async {
    final response = await post('$baseUrl/api/item/create', body);
    return check(response);
  }

  Future<dynamic> delete(body) async {
    final response = await post('$baseUrl/api/item/delete', body);
    return check(response);
  }
}
