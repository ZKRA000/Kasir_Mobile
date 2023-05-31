import 'package:kasir/collections/d_penjualan_collection.dart';
import 'package:kasir/collections/item_collection.dart';

class PenjualanCollection {
  final int id;
  final String nota;
  final Map<String, dynamic> user;
  final int notaId;
  final int price;
  final String customer;
  final String contact;
  final String? discounts;
  final int paid;
  final List<DPenjualanCollection> dPenjualan;
  final String? archivedAt;

  PenjualanCollection({
    required this.id,
    required this.nota,
    required this.user,
    required this.notaId,
    required this.price,
    required this.customer,
    required this.contact,
    required this.discounts,
    required this.paid,
    required this.archivedAt,
    required this.dPenjualan,
  });

  String status() {
    if (paid < price) {
      return 'Belum Lunas';
    } else {
      return 'Lunas';
    }
  }

  factory PenjualanCollection.fromJSON(Map<String, dynamic> json) {
    List<DPenjualanCollection>? dPenjualan = [];
    for (var i in json['d_penjualan']) {
      dPenjualan.add(DPenjualanCollection.fromJSON(i));
    }

    return PenjualanCollection(
      id: json['id'],
      nota: json['nota'],
      user: json['user'],
      notaId: json['nota_id'],
      price: json['price'],
      customer: json['customer'],
      contact: json['contact'],
      discounts: json['discounts'],
      paid: json['paid'],
      archivedAt: json['archived_at'],
      dPenjualan: dPenjualan,
    );
  }
}
