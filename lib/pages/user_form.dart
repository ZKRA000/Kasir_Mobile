import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/role_collection.dart';
import 'package:kasir/collections/user_collection.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_input_dropdown.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/models/role_model.dart';
import 'package:kasir/models/user_model.dart';
import 'package:kasir/components/my_elevated_button.dart';
import 'package:kasir/other/form.dart';

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
  final Map<String, TextEditingController> _controller = {
    'name': TextEditingController(),
    'username': TextEditingController(),
    'password': TextEditingController(),
    'new_password': TextEditingController(),
    'current_password': TextEditingController(),
    'retype_password': TextEditingController(),
  };

  void prepareForm(data) {
    setState(() {
      _formData['id'] = data.id;
      _formData['role'] = data.role.id;

      _controller['name']?.text = data.name;
      _controller['username']?.text = data.username;
    });
  }

  Map<String, dynamic> getFormData() {
    var formData = _formData;
    for (var key in _controller.keys) {
      formData[key] = _controller[key]?.text;
    }
    return formData;
  }

  void fetchRole() async {
    await roleModel.all().then((response) {
      var responseJson = jsonDecode(response.body);
      for (var i in responseJson['roles']) {
        _roles.add(RoleCollection.fromJSON(i));
      }
    });

    setState(() {});
  }

  void updatePassword() async {
    cleanErrorsValidation(_errors);
    if (_controller['new_password']?.text !=
        _controller['retype_password']?.text) {
      setState(() {
        _errors['retype_password'] = 'Re-type password tidak cocok';
      });
      return;
    }

    await userModel.updatePassword(getFormData()).then((response) {
      var responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errors')) {
        errorValidation(responseJson, _errors);
      } else if (mounted && response.statusCode == 200) {
        Navigator.pop(context, responseJson);
      }
    });

    setState(() {});
  }

  void updateUser() async {
    cleanErrorsValidation(_errors);
    await userModel.update(getFormData()).then((response) {
      var responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errors')) {
        errorValidation(responseJson, _errors);
      } else if (mounted && response.statusCode == 200) {
        Navigator.pop(context, responseJson);
      }
    });

    setState(() {});
  }

  void createUser() async {
    cleanErrorsValidation(_errors);
    // to-do
    if (_controller['password']?.text != _controller['retype_password']?.text) {
      setState(() {
        _errors['retype_password'] = 'Re-type password tidak cocok';
      });
      return;
    }
    await userModel.create(getFormData()).then((response) {
      var responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errors')) {
        errorValidation(responseJson, _errors);
      } else if (mounted && response.statusCode == 200) {
        Navigator.pop(context, responseJson);
      }
    });

    setState(() {});
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
      children: [
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: MyInput(
            label: 'Name',
            controller: _controller['name'],
            errorText: _errors['name'],
          ),
        ),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: MyInput(
            label: 'Username',
            controller: _controller['username'],
            errorText: _errors['username'],
          ),
        ),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: MyInputDropdown(
            initialValue: _formData['role'],
            errorText: _errors['role'],
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
        if (widget.data != null) ...[
          const SizedBox(height: 20.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyElevatedButton(
              color: Colors.orange,
              child: const Text('Simpan'),
              onPressed: () {
                updateUser();
              },
            ),
          ),
          const SizedBox(height: 30.0),
        ],
        Column(
          children: [
            if (widget.data == null) ...[
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'Password',
                  controller: _controller['password'],
                  errorText: _errors['password'],
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'Re-type Password',
                  obscureText: true,
                  controller: _controller['retype_password'],
                  errorText: _errors['retype_password'],
                ),
              ),
            ],
            if (widget.data != null) ...[
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'Current Password',
                  controller: _controller['current_password'],
                  errorText: _errors['current_password'],
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'New Password',
                  controller: _controller['new_password'],
                  errorText: _errors['new_password'],
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'Re-type New Password',
                  obscureText: true,
                  controller: _controller['retype_password'],
                  errorText: _errors['retype_password'],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyElevatedButton(
                  color: Colors.orange,
                  child: const Text('Ganti Password'),
                  onPressed: () {
                    updatePassword();
                  },
                ),
              ),
              const SizedBox(height: 30.0),
            ],
            if (widget.data == null) ...[
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyElevatedButton(
                  color: Colors.orange,
                  child: const Text('Buat'),
                  onPressed: () {
                    createUser();
                  },
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ],
        )
      ],
    );
  }
}
