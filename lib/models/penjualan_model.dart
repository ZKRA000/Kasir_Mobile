import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class PenjualanModel extends Model {
  Future<dynamic> all() async {
    return await get('$baseUrl/api/penjualan');
  }

  Future<dynamic> create(body) async {
    return await post('$baseUrl/api/penjualan/create', body);
  }

  Future<dynamic> update(body) async {
    return await post('$baseUrl/api/penjualan/edit', body);
  }

  Future<dynamic> delete(body) async {
    return await post('$baseUrl/api/penjualan/delete', body);
  }
}
