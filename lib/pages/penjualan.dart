import 'package:flutter/material.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPage();
}

class _PenjualanPage extends State<PenjualanPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('Penjualan page'),
      ),
    );
  }
}
