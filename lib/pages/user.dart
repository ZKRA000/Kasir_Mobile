import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/other/env.dart';
import 'package:kasir/other/fetch_user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  bool _loading = true;
  final List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();

    getUser((response) {
      setState(() {
        _loading = false;
        _users.addAll(jsonDecode(response.body));
      });
    });

    print(_users);
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('User'),
      loading: _loading,
      onCreated: () {
        Navigator.pushNamed(context, 'user-form');
      },
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListTile(
              leading: ClipOval(
                child: _users[index]['avatar'] != null
                    ? Image.network(baseUrl + '/' + _users[index]['avatar'])
                    : null,
              ),
              title: Text(_users[index]['name']),
              subtitle: Text('admin'),
              trailing: PopupMenuButton(
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
            ),
          );
        },
      ),
    );
  }
}
