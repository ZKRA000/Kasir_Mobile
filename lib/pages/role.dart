import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/other/fetch_role.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePage();
}

class _RolePage extends State<RolePage> {
  bool _loading = true;
  final List<dynamic> _roles = [];
  final List<dynamic> _menus = [];
  final List<int> testing = [1, 2, 3];

  @override
  void initState() {
    super.initState();

    getRole((response) {
      setState(() {
        _loading = false;
        var jsonResponse = jsonDecode(response.body);

        _menus.addAll(jsonResponse['menus']);

        for (var i = 0; i < jsonResponse['roles'].length; i++) {
          _roles.add(jsonResponse['roles'][i]);

          var extract = _roles[i]['access'];
          extract = extract.replaceAll('[', '');
          extract = extract.replaceAll(']', '');
          var accessIds = extract.split(',');

          _roles[i]['menu_access'] = [];
          for (var x = 0; x < accessIds.length; x++) {
            _roles[i]['menu_access'].add(_menus
                .where((e) => e['id'].toString() == accessIds[x].toString())
                .first['name']);
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Role'),
      loading: _loading,
      onCreated: () {},
      child: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _roles[index]['name'],
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (int i = 0;
                                i < _roles[index]['menu_access'].length;
                                i++)
                              Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  _roles[index]['menu_access'][i].toString(),
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'delete') {
                      //deleteDialog(index);
                    }
                  },
                  itemBuilder: (context) {
                    return const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ];
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
