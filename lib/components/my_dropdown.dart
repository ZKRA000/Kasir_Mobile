import 'package:flutter/material.dart';

class MyDropdown<T> extends StatelessWidget {
  final dynamic initialValue;
  final void Function(T?) onChange;
  final List<Map<String, dynamic>> items;

  const MyDropdown({
    super.key,
    required this.initialValue,
    required this.onChange,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: items.isNotEmpty ? initialValue : null,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12.0),
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('Select'),
        ),
        for (int i = 0; i < items.length; i++)
          DropdownMenuItem(
            value: items[i]['value'],
            child: Text(items[i]['text']),
          ),
      ],
      onChanged: onChange,
    );
  }
}
