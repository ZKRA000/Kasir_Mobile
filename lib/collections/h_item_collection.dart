import 'package:kasir/collections/item_bundle_collection.dart';

class HItemCollection {
  final int itemId;
  final String nama;
  final int harga;
  final int version;

  HItemCollection({
    required this.itemId,
    required this.nama,
    required this.harga,
    required this.version,
  });

  factory HItemCollection.fromJSON(Map<String, dynamic> json) {
    return HItemCollection(
      itemId: json['item_id'],
      nama: json['nama'],
      harga: json['harga'],
      version: json['version'],
    );
  }
}
