import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/menu_collection.dart';
import 'package:kasir/collections/role_collection.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/helper/delete_dialog.dart';
import 'package:kasir/models/role_model.dart';
import 'package:kasir/other/helper.dart';
import 'package:kasir/pages/role_form.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key});

  @override
  State<RolePage> createState() => _RolePage();
}

class _RolePage extends State<RolePage> {
  bool _loading = true;
  final List<RoleCollection> _roles = [];
  final List<MenuCollection> _menus = [];
  final List<int> testing = [1, 2, 3];
  final RoleModel roleModel = RoleModel();

  void fetchRole() async {
    var response = await roleModel.all();
    var responseJson = jsonDecode(response.body);
    print(responseJson);
    setState(() {
      _loading = false;
      for (var i in responseJson['roles']) {
        _roles.add(RoleCollection.fromJSON(i));
      }
      for (var e in responseJson['menus']) {
        _menus.add(MenuCollection.fromJSON(e));
      }
    });
  }

  void editRole(index) async {
    var updateData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RoleFormPage(data: _roles[index])),
    );
    if (updateData != null) {
      setState(() {
        _roles[index] = RoleCollection.fromJSON(updateData);
      });
    }
  }

  Future<void> deleteRole(id) async {
    await roleModel.delete({'id': id});
  }

  void showDeleteDialog(index) async {
    await deleteDialog(
      context: context,
      onDelete: () async {
        await deleteRole(_roles[index].id);
        setState(() {
          _roles.removeAt(index);
        });
        if (mounted) {
          Navigator.pop(context);
        }
      },
      title: 'Delete',
      content: 'Apakah anda yakin ingin menghapus ${_roles[index].name} ?',
    );
  }

  @override
  void initState() {
    super.initState();
    fetchRole();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Role'),
      loading: _loading,
      onCreated: () async {
        var newData = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RoleFormPage()));
        if (newData != null) {
          setState(() {
            _roles.add(RoleCollection.fromJSON(newData));
          });
        }
      },
      child: ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(top: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        upperCaseFirst(_roles[index].name),
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: const EdgeInsets.only(top: 12.0),
                          height: 30.0,
                          child: Row(
                            children: [
                              for (MenuCollection m in _menus)
                                if (_roles[index].access.contains(m.id))
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
                                      m.name,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'delete') {
                      showDeleteDialog(index);
                    }

                    if (value == 'edit') {
                      editRole(index);
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
