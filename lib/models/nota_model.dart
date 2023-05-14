import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class NotaModel extends Model {
  Future<dynamic> all() async {
    return await get('$baseUrl/api/nota');
  }
}
