class RoleCollection {
  final int id;
  final String name;
  final List<int> access;

  RoleCollection({
    required this.id,
    required this.name,
    required this.access,
  });

  factory RoleCollection.fromJSON(Map<String, dynamic> json) {
    List<int> access = [];
    if (json['access'] != '[]') {
      var rawAcess =
          json['access'].substring(1, json['access'].length - 1).split(',');
      for (var i in rawAcess) {
        access.add(int.parse(i));
      }
    }

    return RoleCollection(
      id: json['id'],
      name: json['name'],
      access: access,
    );
  }
}
