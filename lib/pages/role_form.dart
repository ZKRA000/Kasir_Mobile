import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/menu_collection.dart';
import 'package:kasir/collections/role_collection.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/models/role_model.dart';

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
      for (var i in responseJson['menus']) {
        _menus.add(MenuCollection.fromJSON(i));
        _checkbox[i['name']] = {'id': i['id'], 'value': false};
      }

      if (widget.data != null) {
        if (widget.data!.access.isNotEmpty) {
          for (var i in _menus) {
            if (widget.data!.access.contains(i.id)) {
              _checkbox[i.name]['value'] = true;
            }
          }
        }
      }
    });
  }

  void createRole() async {
    cleanErrorsValidation();
    _formData['access'] = _checkbox.entries.map((e) {
      return e.value['value'] ? e.value['id'] : -1;
    }).toList();
    var response = await roleModel.create(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(response);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void updateRole() async {
    cleanErrorsValidation();
    _formData['access'] = _checkbox.entries.map((e) {
      return e.value['value'] ? e.value['id'] : -1;
    }).toList();
    var response = await roleModel.update(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(response);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRole();
    if (widget.data != null) {
      _formData['id'] = widget.data?.id;
      _formData['name'] = widget.data?.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffoldForm(
      title: 'Create Role',
      onSave: () {
        if (widget.data == null) {
          createRole();
        } else {
          updateRole();
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
            )
        ],
      ),
    );
  }
}
