import 'package:kasir/other/helper.dart';

class ItemBundle {
  final String name;
  final int id;
  final int price;
  int count;
  int totalPrice = 0;

  ItemBundle({
    required this.name,
    required this.id,
    required this.price,
    this.count = 1,
  });

  String getPrice() {
    return idrCurrency(price);
  }

  String getTotalPrice() {
    return 'Rp.${idrCurrency(count * price)}';
  }

  factory ItemBundle.fromJSON(data) {
    return ItemBundle(
      name: data['nama'],
      id: data['id'],
      price: data['harga'],
      count: data['qty'] ?? 0,
    );
  }
}
