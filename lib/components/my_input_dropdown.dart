import 'package:flutter/material.dart';
import 'package:kasir/components/my_dropdown.dart';

class MyInputDropdown<T> extends StatelessWidget {
  final String label;
  final dynamic initialValue;
  final void Function(T?) onChange;
  final List<Map<String, dynamic>> items;

  const MyInputDropdown({
    super.key,
    required this.initialValue,
    required this.label,
    required this.onChange,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        MyDropdown<T>(
            initialValue: initialValue, onChange: onChange, items: items)
      ],
    );
  }
}
