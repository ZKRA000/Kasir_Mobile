import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class RoleModel extends Model {
  Future<dynamic> all() async {
    return await get('$baseUrl/api/role');
  }

  Future<dynamic> create(body) async {
    return await post('$baseUrl/api/role/create', body);
  }

  Future<dynamic> update(body) async {
    return await post('$baseUrl/api/role/edit', body);
  }

  Future<dynamic> delete(body) async {
    return await post('$baseUrl/api/role/delete', body);
  }
}
