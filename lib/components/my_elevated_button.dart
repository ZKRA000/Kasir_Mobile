import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final Color? color;
  final Color? textColor;
  final EdgeInsets padding;

  const MyElevatedButton({
    super.key,
    this.onPressed,
    this.color,
    this.textColor,
    this.padding = const EdgeInsets.all(0.0),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return color?.withOpacity(0.8);
            }
            return color;
          },
        ),
        textStyle: MaterialStateProperty.resolveWith(
          (states) => TextStyle(
            color: textColor,
          ),
        ),
      ),
      child: child,
    );
  }
}
