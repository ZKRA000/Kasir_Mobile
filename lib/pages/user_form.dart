import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/role_collection.dart';
import 'package:kasir/collections/user_collection.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_input_dropdown.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/models/role_model.dart';
import 'package:kasir/models/user_model.dart';

class UserFormPage extends StatefulWidget {
  final UserCollection? data;
  const UserFormPage({super.key, this.data});

  @override
  State<UserFormPage> createState() => _UserFormPage();
}

class _UserFormPage extends State<UserFormPage> {
  final List<RoleCollection> _roles = [];
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};
  final UserModel userModel = UserModel();
  final RoleModel roleModel = RoleModel();

  void prepareForm(data) {
    setState(() {
      _formData['id'] = data.id;
      _formData['name'] = data.name;
      _formData['username'] = data.username;
      _formData['role'] = data.role.id;
    });
  }

  void cleanErrorsValidation() {
    setState(() {
      _errors.clear();
    });
  }

  void errorValidation(response) {
    setState(() {
      for (var key in response['errors'].keys) {
        _errors[key] = response['errors'][key].first;
      }
    });
  }

  void fetchRole() async {
    var response = await roleModel.all();
    var responseJson = jsonDecode(response.body);
    setState(() {
      for (var i in responseJson['roles']) {
        _roles.add(RoleCollection.fromJSON(i));
      }
    });
  }

  void updateUser() async {
    cleanErrorsValidation();
    var response = await userModel.update(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(responseJson);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void createUser() async {
    cleanErrorsValidation();
    // to-do
    if (_formData['password'] != _formData['retype-password']) {
      setState(() {
        _errors['retype-password'] = 'Re-type password tidak cocok';
      });
      return;
    }
    var response = await userModel.create(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(responseJson);
    } else if (mounted && _errors.isEmpty) {
      Navigator.pop(context, responseJson);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRole();
    if (widget.data != null) {
      prepareForm(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffoldForm(
      title: 'User',
      onSave: () {
        if (widget.data != null) {
          updateUser();
        } else {
          createUser();
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyInput(
              label: 'Name',
              initialValue: _formData['name'],
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
              initialValue: _formData['username'],
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
                  'text': _roles[index].name,
                  'value': _roles[index].id,
                };
              }),
            ),
          ),
          if (widget.data == null)
            Column(
              children: [
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
                    errorText: _errors['retype-password'],
                    onChanged: (val) {
                      setState(() {
                        _formData['retype-password'] = val;
                      });
                    },
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
