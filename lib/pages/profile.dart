import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/profile_collection.dart';
import 'package:kasir/components/my_elevated_button.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/models/profile_model.dart';

class Profile extends StatefulWidget {
  final ProfileCollection? data;

  const Profile({super.key, this.data});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  final Map<String, dynamic> _formData = {};
  final Map<String, TextEditingController> _controller = {
    'name': TextEditingController(),
    'username': TextEditingController(),
  };
  final Map<String, dynamic> _errors = {};
  final ProfileModel profileModel = ProfileModel();
  bool _isEdit = false;

  void prepareForm() {
    setState(() {
      var data = widget.data;
      if (data != null) {
        _formData['id'] = data.id;
        _formData['role_name'] = data.role.name;

        _controller['name']?.text = data.name;
        _controller['username']?.text = data.username;
      }
    });
  }

  void toEditState() {
    setState(() {
      _isEdit = true;
    });
  }

  void toViewState() {
    cleanErrorsValidation();
    setState(() {
      _isEdit = false;
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

  void updateProfile() async {
    cleanErrorsValidation();

    for (var key in _controller.keys) {
      _formData[key] = _controller[key]?.text;
    }

    var response = await profileModel.update(_formData).then((value) {});

    if (response['body'].containsKey('errors')) {
      errorValidation(response['body']);
    } else if (mounted && response['res'].statusCode == 200) {
      toViewState();
    }
  }

  @override
  void initState() {
    super.initState();
    prepareForm();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Profile'),
      loading: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Container(
                height: 120,
                width: 120,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'Name',
                  enabled: _isEdit,
                  controller: _controller['name'],
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
                  enabled: _isEdit,
                  controller: _controller['username'],
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
                child: MyInput(
                  label: 'Role',
                  enabled: false,
                  initialValue: _formData['role_name'],
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isEdit == true) {
                      updateProfile();
                    } else {
                      toEditState();
                    }
                  },
                  child: Text(
                    !_isEdit ? 'Edit' : 'Simpan',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_isEdit)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MyElevatedButton(
                    color: Colors.red,
                    onPressed: () {
                      toViewState();
                      prepareForm();
                    },
                    child: const Text(
                      'Batal',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
