import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kasir/collections/nota_collection.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir/models/nota_model.dart';

class NotaFormPage extends StatefulWidget {
  final NotaCollection? data;
  const NotaFormPage({super.key, this.data});
  @override
  State<NotaFormPage> createState() => _NotaFormPage();
}

class _NotaFormPage extends State<NotaFormPage> {
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};
  final NotaModel notaModel = NotaModel();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _editedImage;

  void pickImage() async {
    final XFile? imageList =
        await _picker.pickImage(source: ImageSource.gallery);
    _image = imageList == null ? null : File(imageList.path);
    setState(() {});
  }

  void deleteImage() {
    setState(() {
      _image = null;
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

  void prepareForm() {
    NotaCollection? nota = widget.data;
    if (nota != null) {
      _formData['id'] = nota.id;
      _formData['name'] = nota.name;
      _formData['company'] = nota.companyName;
      _formData['address'] = nota.address;
      _formData['phone'] = nota.contact;
      _formData['email'] = nota.email;
    }

    setState(() {});
  }

  void createNota() async {
    cleanErrorsValidation();
    var response = await notaModel.create(_formData, _image);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(responseJson);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void updateNota() async {
    cleanErrorsValidation();
    var response = await notaModel.update(_formData, _image);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(responseJson);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void previewImage() async {
    showDialog(
      barrierColor: Colors.black,
      context: context,
      builder: (context) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 'ganti') {
                    pickImage();
                  }

                  if (value == 'hapus') {
                    deleteImage();
                    Navigator.pop(context);
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(value: 'hapus', child: Text('Hapus')),
                    PopupMenuItem(value: 'ganti', child: Text('Ganti')),
                  ];
                },
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_image != null)
                    Image.file(
                      _image ?? File(''),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    prepareForm();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffoldForm(
      title: 'Nota',
      onSave: () async {
        if (widget.data == null) {
          createNota();
        } else {
          updateNota();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Logo'),
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  if (_image != null) {
                    previewImage();
                  } else {
                    pickImage();
                  }
                },
                child: Container(
                  height: 170,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 230, 230),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _image != null
                      ? Image.file(
                          _image ?? File(''),
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.upload,
                          size: 48.0,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
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
                label: 'Company Name',
                initialValue: _formData['company'],
                errorText: _errors['company'],
                onChanged: (val) {
                  setState(() {
                    _formData['company'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Address',
                initialValue: _formData['address'],
                errorText: _errors['address'],
                onChanged: (val) {
                  setState(() {
                    _formData['address'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Phone',
                initialValue: _formData['phone'],
                keyboardType: TextInputType.phone,
                errorText: _errors['phone'],
                onChanged: (val) {
                  setState(() {
                    _formData['phone'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Email',
                initialValue: _formData['email'],
                errorText: _errors['email'],
                onChanged: (val) {
                  setState(() {
                    _formData['email'] = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
