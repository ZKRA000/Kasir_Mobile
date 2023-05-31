import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class ItemModel extends Model {
  Future<dynamic> all({String? except}) async {
    return await get("$baseUrl/api/item${except != null ? '/$except' : ''}");
  }

  Future<dynamic> create(body) async {
    return await post('$baseUrl/api/item/create', body);
  }

  Future<dynamic> update(body) async {
    return await post('$baseUrl/api/item/edit', body);
  }

  Future<dynamic> delete(body) async {
    return await post('$baseUrl/api/item/delete', body);
  }
}
