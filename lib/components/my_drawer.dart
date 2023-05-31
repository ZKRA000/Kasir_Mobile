import 'package:flutter/material.dart';
import 'package:kasir/collections/profile_collection.dart';
import 'package:kasir/my_theme.dart';
import 'package:kasir/other/env.dart';
import 'package:kasir/other/helper.dart';
import 'package:kasir/pages/profile.dart';

class MyDrawer extends StatelessWidget {
  final ProfileCollection? data;

  MyDrawer({super.key, this.data});

  final List<Map<String, dynamic>> menu = [
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              var updatedData = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile(data: data)));
            },
            child: Container(
              padding: const EdgeInsets.all(16.0),
              height: 220.0,
              width: double.infinity,
              color: myPrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        height: 90.0,
                        width: 90.0,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.hardEdge,
                          height: 90.0,
                          width: 90.0,
                          child: data != null
                              ? Image.network(
                                  data?.avatar != null
                                      ? '$baseUrl/${data?.avatar}'
                                      : '',
                                  fit: BoxFit.cover,
                                )
                              : const Text('')),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    upperCaseFirst(data != null ? data?.name : ''),
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  )
                ],
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
  }
}
