import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/user_collection.dart';
import 'package:kasir/components/my_list_item.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/helper/delete_dialog.dart';
import 'package:kasir/models/role_model.dart';
import 'package:kasir/models/user_model.dart';
import 'package:kasir/other/env.dart';
import 'package:kasir/other/helper.dart';
import 'package:kasir/pages/user_form.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  bool _loading = true;
  final List<UserCollection> _users = [];
  final List<dynamic> _roles = [];
  final UserModel userModel = UserModel();
  final RoleModel roleModel = RoleModel();

  void fetchUser() async {
    await userModel.all().then((response) {
      var responseJson = jsonDecode(response.body);
      _loading = false;
      for (var i in responseJson) {
        _users.add(UserCollection.fromJSON(i));
      }
    });

    setState(() {});
  }

  void editUser(index) async {
    var updateData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserFormPage(data: _users[index]),
      ),
    );
    if (updateData != null) {
      setState(() {
        _users[index] = UserCollection.fromJSON(updateData);
      });
    }
  }

  Future<void> deleteUser(index) async {
    await userModel.delete({'id': _users[index].id}).then((response) {
      _users.removeAt(index);
      if (mounted) {
        Navigator.pop(context);
      }
    });

    setState(() {});
  }

  void showDeleteDialog(index) async {
    await deleteDialog(
      context: context,
      onDelete: () async {
        await deleteUser(index);
      },
      title: 'Delete',
      content: 'Apakah anda yakin ingin menghapus ${_users[index].name} ?',
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        title: const Text('User'),
        loading: _loading,
        onCreated: () async {
          var newData = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserFormPage()));
          if (newData != null) {
            setState(() {
              _users.add(UserCollection.fromJSON(newData));
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var index = 0; index < _users.length; index++) ...[
                const SizedBox(height: 12),
                MyListItem(
                  child: ListTile(
                    leading: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Text(
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                              _users[index].name[0].toUpperCase(),
                            ),
                            if (_users[index].avatar != null)
                              ClipOval(
                                child: Image.network(
                                    '$baseUrl/${_users[index].avatar}'),
                              ),
                          ],
                        )),
                    title: Text(upperCaseFirst(_users[index].name)),
                    subtitle: Text(upperCaseFirst(_users[index].role?.name)),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'delete') {
                          showDeleteDialog(index);
                        }

                        if (value == 'edit') {
                          editUser(index);
                        }
                      },
                      itemBuilder: (context) {
                        return const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ];
                      },
                    ),
                  ),
                )
              ]
            ],
          ),
        ));
  }
}
