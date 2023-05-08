import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  final String label;
  final dynamic initialValue;
  final String? errorText;
  final void Function(String) onChanged;
  final bool obscureText;

  const MyInput({
    super.key,
    this.initialValue = '',
    required this.label,
    this.errorText,
    this.obscureText = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        TextFormField(
          obscureText: obscureText,
          initialValue: initialValue,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(12.0),
            border: OutlineInputBorder(),
            errorText: errorText,
          ),
          onChanged: onChanged,
        )
      ],
    );
  }
}
