import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class UserModel extends Model {
  Future<dynamic> all() async {
    return await get('$baseUrl/api/user');
  }

  Future<dynamic> create(body) async {
    return await post('$baseUrl/api/user/create', body);
  }

  Future<dynamic> update(body) async {
    return await post('$baseUrl/api/user/edit', body);
  }

  Future<dynamic> delete(body) async {
    return await post('$baseUrl/api/user/delete', body);
  }
}
