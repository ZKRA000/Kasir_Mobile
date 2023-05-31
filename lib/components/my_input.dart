import 'package:flutter/material.dart';
import 'package:kasir/components/my_error_text.dart';

class MyInput extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool enabled;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const MyInput({
    super.key,
    this.initialValue,
    required this.label,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(12.0),
            border: const OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
        if (errorText != null) MyErrorText(errorText: errorText ?? '')
      ],
    );
  }
}
