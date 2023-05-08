import 'package:flutter/material.dart';
import 'package:kasir/components/drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        drawer: myDrawer,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
