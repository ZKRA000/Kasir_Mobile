import 'package:kasir/collections/role_collection.dart';

class ProfileCollection {
  final int id;
  final String name;
  final String? avatar;
  final String username;
  final RoleCollection role;

  ProfileCollection({
    required this.id,
    required this.name,
    this.avatar,
    required this.username,
    required this.role,
  });

  factory ProfileCollection.fromJSON(Map<String, dynamic> json) {
    return ProfileCollection(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      username: json['username'],
      role: RoleCollection.fromJSON(json['role']),
    );
  }
}
