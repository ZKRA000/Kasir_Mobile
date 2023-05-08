import 'package:flutter/material.dart';

class NotaPage extends StatefulWidget {
  const NotaPage({super.key});

  @override
  State<NotaPage> createState() => _NotaPage();
}

class _NotaPage extends State<NotaPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('nota page'),
      ),
    );
  }
}
