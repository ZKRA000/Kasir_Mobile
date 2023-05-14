import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class MenuModel extends Model {
  Future<dynamic> all() async {
    return await get('$baseUrl/api/menu');
  }
}
