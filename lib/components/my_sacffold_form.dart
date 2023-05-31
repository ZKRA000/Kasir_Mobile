import 'package:flutter/material.dart';
import 'package:kasir/my_theme.dart';

class MyScaffoldForm extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool scrollable;
  final void Function()? onSave;

  const MyScaffoldForm({
    super.key,
    required this.title,
    this.onSave,
    this.scrollable = true,
    required this.children,
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
            backgroundColor: myPrimary,
            title: Text(title),
            actions: [
              IconButton(
                onPressed: onSave,
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: scrollable
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                )
              : Column(
                  children: children,
                ),
        ),
      ),
    );
  }
}
