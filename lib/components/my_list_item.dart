import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget {
  final Widget child;
  const MyListItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0.5),
            blurRadius: 1,
            color: Color(0xFFE8E8E8),
          )
        ],
      ),
      child: child,
    );
  }
}
