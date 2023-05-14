import 'package:kasir/collections/h_item_collection.dart';

class DPenjualanCollection {
  final int penjualanId;
  final int quantity;
  final String notes;
  final HItemCollection hItem;

  DPenjualanCollection({
    required this.penjualanId,
    required this.quantity,
    required this.notes,
    required this.hItem,
  });

  factory DPenjualanCollection.fromJSON(Map<String, dynamic> json) {
    return DPenjualanCollection(
      penjualanId: json['penjualan_id'],
      quantity: json['quantity'],
      notes: json['notes'] ?? '',
      hItem: HItemCollection.fromJSON(json['h_item']),
    );
  }
}
