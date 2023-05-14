import 'dart:convert';

import 'package:kasir/collections/role_collection.dart';

class UserCollection {
  final int id;
  final String name;
  final String? avatar;
  final String username;
  final int roleId;
  final RoleCollection role;

  const UserCollection({
    required this.id,
    required this.name,
    this.avatar,
    required this.roleId,
    required this.username,
    required this.role,
  });

  factory UserCollection.fromJSON(Map<String, dynamic> json) {
    return UserCollection(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      username: json['username'],
      roleId: json['role_id'],
      role: RoleCollection.fromJSON(json['role']),
    );
  }
}
