import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/item_bundle_collection.dart';
import 'package:kasir/collections/item_collection.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/models/item_model.dart';
import 'package:kasir/other/helper.dart';

class ItemFormPage extends StatefulWidget {
  final ItemCollection? data;
  const ItemFormPage({super.key, this.data});

  @override
  State<ItemFormPage> createState() => _ItemFormPage();
}

class _ItemFormPage extends State<ItemFormPage> {
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};
  final List<ItemBundle> _bundle = [];
  final List<dynamic> _items = [];
  late final PageController _pageViewController;
  int _selectedItemIndex = 0;
  ItemModel itemModel = ItemModel();
  late int jumlah;

  void prepareForm([data]) {
    setState(() {
      if (data != null) {
        _formData['id'] = data.id;
        _formData['nama'] = data.nama;
        _formData['type'] = data.bundle == null ? 'single' : 'bundle';

        if (_formData['type'] == 'bundle') {
          _formData['items'] = [];
          for (var i in data.bundle) {
            _bundle.add(i);
            _formData['items'].add({
              'id': i.id,
              'qty': i.count,
            });
          }
          _pageViewController = PageController(initialPage: 1);
        } else {
          _formData['harga'] = data.harga.toString();
          _pageViewController = PageController(initialPage: 0);
        }
      } else {
        _formData['type'] = 'single';
        _pageViewController = PageController(initialPage: 0);
      }
    });
  }

  void cleanErrorsValidation() {
    setState(() {
      _errors.clear();
    });
  }

  void errorValidation(response) {
    if (response.containsKey('errors')) {
      setState(() {
        for (var key in response['errors'].keys) {
          _errors[key] = response['errors'][key].first;
        }
      });
    }
  }

  void fetchItem() async {
    var response = await itemModel.all();
    if (mounted) {
      setState(() {
        _items.addAll(jsonDecode(response.body));
      });
    }
  }

  void createItem() async {
    cleanErrorsValidation();
    getFormData();
    var response = await itemModel.create(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(response);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void updateItem() async {
    cleanErrorsValidation();
    getFormData();
    var response = await itemModel.update(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(response);
    }
    if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void getFormData() {
    if (_formData['type'] == 'bundle') {
      _formData['items'] = [];
      for (var e = 0; e < _bundle.length; e++) {
        _formData['items'].add({
          'id': _bundle[e].id,
          'qty': _bundle[e].count,
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    fetchItem();

    if (widget.data != null) {
      prepareForm(widget.data);
    } else {
      prepareForm();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  void toPage(index) {
    if (_pageViewController.hasClients) {
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Item'),
          actions: [
            IconButton(
              onPressed: () {
                if (_formData['id'] != null) {
                  updateItem();
                } else {
                  createItem();
                }
              },
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 'single',
                          groupValue: _formData['type'],
                          onChanged: (val) {
                            toPage(0);

                            setState(() {
                              _formData['type'] = val;
                            });
                          },
                        ),
                        const Text('Single'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: 'bundle',
                          groupValue: _formData['type'],
                          onChanged: (val) {
                            toPage(1);

                            setState(() {
                              _formData['type'] = val;
                            });
                          },
                        ),
                        const Text('Bundle'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyInput(
                  label: 'Name',
                  initialValue: _formData['nama'],
                  errorText: _errors['nama'],
                  onChanged: (val) {
                    setState(() {
                      _formData['nama'] = val;
                    });
                  },
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageViewController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12.0),
                          MyInput(
                            label: 'Price',
                            initialValue: _formData['harga'],
                            keyboardType: TextInputType.number,
                            errorText: _errors['harga'],
                            onChanged: (val) {
                              setState(() {
                                _formData['harga'] = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Item Bundle'),
                          const SizedBox(height: 12.0),
                          ...List.generate(
                            _bundle.length,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _bundle[index].name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          _bundle[index].getTotalPrice(),
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '@${_bundle[index].getPrice()}',
                                          style: const TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4.0),
                                          width: 80,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: TextFormField(
                                            initialValue:
                                                _bundle[index].count.toString(),
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.all(0),
                                              isDense: true,
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                setState(() {
                                                  _bundle[index].count =
                                                      int.parse(value);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _bundle.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(Icons.close),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Material(
                              color: const Color(0xFFE4EBE6),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(4.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom +
                                                    12.0),
                                            child: Column(
                                              children: [
                                                DropdownButtonFormField(
                                                  value: _selectedItemIndex,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  items: [
                                                    ...List.generate(
                                                      _items.length,
                                                      (index) {
                                                        return DropdownMenuItem(
                                                          value: index,
                                                          child: Text(
                                                            _items[index]
                                                                ['nama'],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedItemIndex =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 8.0),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          hintText: 'jumlah'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      jumlah = int.parse(value);
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 8.0),
                                                Material(
                                                  color: Colors.blue,
                                                  textStyle: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(4.0),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      ItemBundle newItem =
                                                          ItemBundle.fromJSON(
                                                              _items[
                                                                  _selectedItemIndex]);

                                                      Iterable<dynamic> exists =
                                                          _bundle.where((e) {
                                                        return e.id ==
                                                            newItem.id;
                                                      });

                                                      if (exists.isEmpty) {
                                                        newItem.count = jumlah;

                                                        setState(() {
                                                          _bundle.add(newItem);
                                                        });
                                                      }

                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 20.0,
                                                      ),
                                                      width: double.infinity,
                                                      child:
                                                          const Text('Pilih'),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
