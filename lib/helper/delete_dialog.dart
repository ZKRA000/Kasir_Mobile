import 'package:flutter/material.dart';

Future<void> deleteDialog({
  required BuildContext context,
  required void Function() onDelete,
  required String title,
  required String content,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          content,
        ),
        actions: [
          TextButton(
            onPressed: onDelete,
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
        ],
      );
    },
  );
}
