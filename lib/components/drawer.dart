import 'package:flutter/material.dart';

List<Map<String, dynamic>> menu = [
  {
    'label': 'User',
    'icon': Icons.home,
    'route': 'user',
  },
  {
    'label': 'Role',
    'icon': Icons.home,
    'route': 'role',
  },
  {
    'label': 'Item',
    'icon': Icons.home,
    'route': 'item',
  },
  {
    'label': 'Penjualan',
    'icon': Icons.home,
    'route': 'penjualan',
  },
  {
    'label': 'Report',
    'icon': Icons.home,
    'route': 'report',
  },
  {
    'label': 'Nota',
    'icon': Icons.home,
    'route': 'nota',
  },
];

Widget myDrawer = Drawer(
  child: Column(
    children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        height: 200.0,
        color: Colors.blue,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            height: 90.0,
            width: 80.0,
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: menu.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, menu[index]['route']);
              },
              child: ListTile(
                leading: Icon(menu[index]['icon']),
                title: Text(menu[index]['label']),
              ),
            );
          },
        ),
      ),
    ],
  ),
);
