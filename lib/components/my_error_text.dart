import 'package:flutter/material.dart';

class MyErrorText extends StatelessWidget {
  final String errorText;

  const MyErrorText({
    super.key,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
