import 'dart:convert';

import 'package:kasir/collections/item_bundle_collection.dart';

class ItemCollection {
  final int id;
  final String nama;
  final int harga;
  final int version;
  final List<ItemBundle>? bundle;

  ItemCollection({
    required this.id,
    required this.nama,
    required this.harga,
    required this.version,
    required this.bundle,
  });

  factory ItemCollection.fromJSON(Map<String, dynamic> json) {
    List<ItemBundle> bundle = [];
    if (json['bundle'] != null) {
      for (var i in jsonDecode(json['bundle'])) {
        bundle.add(ItemBundle.fromJSON(i));
      }
    }
    return ItemCollection(
      id: json['id'],
      nama: json['nama'],
      harga: json['harga'],
      version: json['version'],
      bundle: bundle.isEmpty ? null : bundle,
    );
  }
}
