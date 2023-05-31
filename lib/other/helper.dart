import 'package:intl/intl.dart';

String idrCurrency(int number) {
  NumberFormat format = NumberFormat(",###");
  return format.format(number);
}

String upperCaseFirst(String? string) {
  if (string!.isNotEmpty) {
    return string[0].toUpperCase() + string.substring(1, string.length);
  }

  return '-';
}
