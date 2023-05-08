import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_input_dropdown.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/other/fetch_role.dart';
import 'package:kasir/other/fetch_user.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPage();
}

class _UserFormPage extends State<UserFormPage> {
  final List<dynamic> _roles = [];
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};

  @override
  void initState() {
    super.initState();

    getRole((response) {
      setState(() {
        _roles.addAll(jsonDecode(response.body)['roles']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffoldForm(
      title: 'User',
      onSave: () {
        setState(() {
          _errors.clear();
        });

        if (_formData['password'] != _formData['retype-password']) {
          setState(() {
            _errors['retype-password'] = 'Re-type password tidak cocok';
          });
        }

        createUser(_formData, (response) {
          var body = jsonDecode(response.body);
          if (body.containsKey('errors')) {
            setState(() {
              for (var key in body['errors'].keys) {
                _errors[key] = body['errors'][key].first;
              }
            });
            return;
          }
          Navigator.pop(context);
        });
      },
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyInput(
              label: 'Name',
              errorText: _errors['name'],
              onChanged: (val) {
                setState(() {
                  _formData['name'] = val;
                });
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyInput(
              label: 'Username',
              errorText: _errors['username'],
              onChanged: (val) {
                setState(() {
                  _formData['username'] = val;
                });
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyInputDropdown(
              initialValue: _formData['role'],
              label: 'Role',
              onChange: (val) {
                setState(() {
                  _formData['role'] = val;
                });
              },
              items: List.generate(_roles.length, (index) {
                return {
                  'text': _roles[index]['name'],
                  'value': _roles[index]['id'],
                };
              }),
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyInput(
              label: 'Password',
              errorText: _errors['password'],
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  _formData['password'] = val;
                });
              },
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyInput(
              label: 'Re-type Password',
              obscureText: true,
              errorText: _errors['retypr-password'],
              onChanged: (val) {
                setState(() {
                  _formData['retype-password'] = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
