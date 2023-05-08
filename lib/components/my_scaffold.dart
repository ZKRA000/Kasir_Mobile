import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget title;
  final Widget child;
  final bool loading;
  final void Function() onCreated;

  const MyScaffold({
    super.key,
    required this.title,
    required this.loading,
    required this.onCreated,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: title,
          actions: [
            IconButton(
              onPressed: onCreated,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Column(
          children: [
            if (loading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
