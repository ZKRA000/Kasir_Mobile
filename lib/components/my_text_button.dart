import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final Color? color;
  final OutlinedBorder? shape;
  final EdgeInsets padding;

  const MyTextButton({
    super.key,
    this.onPressed,
    this.color,
    this.shape,
    this.padding = const EdgeInsets.all(0.0),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(shape),
        padding: MaterialStateProperty.all(padding),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return color?.withOpacity(0.8);
            }
            return color;
          },
        ),
      ),
      child: child,
    );
  }
}
