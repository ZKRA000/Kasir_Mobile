import 'package:flutter/material.dart';

class MyInput extends StatelessWidget {
  final String label;
  final dynamic initialValue;
  final String? errorText;
  final void Function(String) onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;

  const MyInput({
    super.key,
    this.initialValue = '',
    required this.label,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(12.0),
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
          onChanged: onChanged,
        )
      ],
    );
  }
}
