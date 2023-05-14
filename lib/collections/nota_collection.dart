class NotaCollection {
  final int id;
  final String name;
  final String companyName;
  final String address;
  final String contact;
  final String email;
  final String? logo;

  NotaCollection({
    required this.id,
    required this.name,
    required this.companyName,
    required this.address,
    required this.contact,
    required this.email,
    required this.logo,
  });

  factory NotaCollection.fromJSON(Map<String, dynamic> json) {
    return NotaCollection(
      id: json['id'],
      name: json['name'],
      companyName: json['company_name'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      logo: json['logo'],
    );
  }
}
