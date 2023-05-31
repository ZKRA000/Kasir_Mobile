import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';

class ProfileModel extends Model {
  Future<dynamic> getMyProfile() async {
    return await get('$baseUrl/api/profile');
  }

  Future<dynamic> update(Map<String, dynamic> body) async {
    return await post('$baseUrl/api/profile/edit', body);
  }
}
