import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/other/env.dart';
import 'package:kasir/other/form.dart';
import 'package:kasir/other/sqflite.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};
  final Model model = Model();

  void login() async {
    cleanErrorsValidation(_errors);

    Map<String, dynamic> response =
        await model.post('$baseUrl/api/login', _formData);

    if (response['body'] != null && response['body'].containsKey('errors')) {
      errorValidation(response['body'], _errors);
    } else if (context.mounted && response['res'].statusCode == 200) {
      tableTruncate('personal_token');
      tableInsert('personal_token', {'token': response['body']['token']});
      Navigator.pushReplacementNamed(context, 'dashboard');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyInput(
                label: 'Username',
                errorText: _errors['username'],
                onChanged: (val) {
                  setState(() {
                    _formData['username'] = val;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              MyInput(
                label: 'Password',
                obscureText: true,
                errorText: _errors['password'],
                onChanged: (val) {
                  setState(() {
                    _formData['password'] = val;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: TextButton(
                  onPressed: login,
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(12.0)),
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue.shade600;
                      }
                      return Colors.blue;
                    }),
                  ),
                  child: const Text(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    'Login',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
