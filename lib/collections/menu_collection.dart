class MenuCollection {
  final int id;
  final String name;

  MenuCollection({
    required this.id,
    required this.name,
  });

  factory MenuCollection.fromJSON(Map<String, dynamic> json) {
    return MenuCollection(
      id: json['id'],
      name: json['name'],
    );
  }
}
