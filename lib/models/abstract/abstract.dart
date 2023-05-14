abstract class AbstractModel {
  Future<dynamic> get(url);
  Future<dynamic> post(url, formData);
}
