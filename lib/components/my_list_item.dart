import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget {
  final Widget child;
  const MyListItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
