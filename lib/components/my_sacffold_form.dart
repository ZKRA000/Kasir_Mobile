import 'package:flutter/material.dart';

class MyScaffoldForm extends StatelessWidget {
  final String title;
  final Widget child;
  final void Function() onSave;

  const MyScaffoldForm({
    super.key,
    required this.title,
    required this.onSave,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Create $title'),
            actions: [
              IconButton(
                onPressed: onSave,
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: child,
        ),
      ),
    );
  }
}
