import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kasir/collections/menu_collection.dart';
import 'package:kasir/collections/role_collection.dart';
import 'package:kasir/components/my_elevated_button.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_error_text.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/models/role_model.dart';
import 'package:kasir/other/form.dart';

class RoleFormPage extends StatefulWidget {
  final RoleCollection? data;
  const RoleFormPage({super.key, this.data});

  @override
  State<RoleFormPage> createState() => _RoleFormPage();
}

class _RoleFormPage extends State<RoleFormPage> {
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};
  final List<MenuCollection> _menus = [];
  final Map<String, dynamic> _checkbox = {};
  final RoleModel roleModel = RoleModel();
  final Map<String, TextEditingController> _controller = {
    'name': TextEditingController()
  };

  void prepareForm(data) {
    setState(() {
      _formData['id'] = data.id;
      _controller['name']?.text = data.name;
    });
  }

  Map<String, dynamic> getFormData() {
    var formData = _formData;
    for (var key in _controller.keys) {
      formData[key] = _controller[key]?.text;
    }

    formData['access'] = [];
    _checkbox.forEach((key, value) {
      if (value['value']) {
        formData['access'].add(value['id']);
      }
    });

    return formData;
  }

  void fetchRole() async {
    await roleModel.all().then((response) {
      var responseJson = jsonDecode(response.body);
      for (var i in responseJson['menus']) {
        _menus.add(MenuCollection.fromJSON(i));
        _checkbox[i['name']] = {'id': i['id'], 'value': false};
      }

      if (widget.data != null) {
        if (widget.data!.access.isNotEmpty) {
          for (var menu in _menus) {
            if (widget.data!.access.contains(menu.id)) {
              _checkbox[menu.name]['value'] = true;
            }
          }
        }
      }
    });

    setState(() {});
  }

  void createRole() async {
    cleanErrorsValidation(_errors);
    await roleModel.create(getFormData()).then((response) {
      var responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errors')) {
        errorValidation(responseJson, _errors);
      } else if (mounted && response.statusCode == 200) {
        Navigator.pop(context, responseJson);
      }
    });

    setState(() {});
  }

  void updateRole() async {
    cleanErrorsValidation(_errors);
    await roleModel.update(getFormData()).then((response) {
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
      title: 'Create Role',
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
        for (var key in _checkbox.keys)
          Row(
            children: [
              Checkbox(
                value: _checkbox[key]['value'],
                onChanged: (val) {
                  setState(() {
                    _checkbox[key]['value'] = val;
                  });
                },
              ),
              Text(key)
            ],
          ),
        if (_errors['access'] != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MyErrorText(errorText: _errors['access']),
          ),
        const SizedBox(height: 20.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: MyElevatedButton(
            color: Colors.orange,
            child: Text(widget.data == null ? 'Buat' : 'Simpan'),
            onPressed: () {
              if (widget.data == null) {
                createRole();
              } else {
                updateRole();
              }
            },
          ),
        ),
      ],
    );
  }
}
