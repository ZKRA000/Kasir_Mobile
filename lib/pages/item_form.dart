import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/item_bundle_collection.dart';
import 'package:kasir/collections/item_collection.dart';
import 'package:kasir/components/my_elevated_button.dart';
import 'package:kasir/components/my_error_text.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_input_dropdown.dart';
import 'package:kasir/components/my_list_item.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/components/my_text_button.dart';
import 'package:kasir/models/item_model.dart';
import 'package:kasir/other/form.dart';
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
  final List<ItemCollection> _items = [];
  late final PageController _pageViewController;
  int? _selectedItemIndex;
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

  void fetchItem() async {
    await itemModel.all(except: widget.data?.id.toString()).then((response) {
      for (var i in jsonDecode(response.body)) {
        _items.add(ItemCollection.fromJSON(i));
      }
      setState(() {});
    });
  }

  void createItem() async {
    cleanErrorsValidation(_errors);
    getFormData();

    await itemModel.create(_formData).then((response) {
      var responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errors')) {
        errorValidation(responseJson, _errors);
      } else if (mounted && response.statusCode == 200) {
        Navigator.pop(context, responseJson);
      }
    });

    setState(() {});
  }

  void updateItem() async {
    cleanErrorsValidation(_errors);
    getFormData();

    await itemModel.update(_formData).then((response) {
      var responseJson = jsonDecode(response.body);
      if (responseJson.containsKey('errors')) {
        errorValidation(responseJson, _errors);
      } else if (mounted && response.statusCode == 200) {
        Navigator.pop(context, responseJson);
      }
    });

    setState(() {});
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

  void showModalItem() async {
    cleanErrorsValidation(_errors);
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 50,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyInputDropdown<int>(
                      label: 'Items',
                      errorText: _errors['item_bundle'],
                      initialValue: _selectedItemIndex,
                      items: List.generate(
                        _items.length,
                        (index) {
                          return {
                            'text': _items[index].nama,
                            'value': index,
                          };
                        },
                      ),
                      onChange: (val) {
                        setState(() {
                          _selectedItemIndex = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyInput(
                      label: 'Jumlah',
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          jumlah = int.parse(val);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyElevatedButton(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text('Pilih'),
                      ),
                      onPressed: () {
                        if (_selectedItemIndex != null) {
                          int selected = _selectedItemIndex ?? 0;

                          ItemBundle newItem =
                              ItemBundle.fromItem(_items[selected]);

                          Iterable<dynamic> exists = _bundle.where((e) {
                            return e.id == newItem.id;
                          });

                          if (exists.isEmpty) {
                            newItem.count = jumlah;
                            _bundle.add(newItem);
                            Navigator.pop(context);
                          } else {
                            _errors['item_bundle'] = 'Item Sudah Ada';
                          }
                        } else {
                          _errors['item_bundle'] = 'Pilih Item';
                        }

                        setState(() {});
                        setModalState(() {});
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
    return MyScaffoldForm(
      title: 'Item',
      scrollable: false,
      onSave: () {
        if (_formData['id'] != null) {
          updateItem();
        } else {
          createItem();
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyInput(
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
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Item Bundle'),
                  ),
                  const SizedBox(height: 12.0),
                  for (var index = 0; index < _bundle.length; index++) ...[
                    Dismissible(
                      key: Key(index.toString()),
                      onDismissed: (direction) {
                        setState(() {
                          _bundle.removeAt(index);
                        });
                      },
                      child: MyListItem(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: MyTextButton(
                                      color: Colors.orange,
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _bundle[index].count++;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child:
                                        Text(_bundle[index].count.toString()),
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                    width: 24.0,
                                    child: MyTextButton(
                                      color: Colors.orange,
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _bundle[index].count--;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 24.0),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Material(
                      color: const Color(0xFFE4EBE6),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalItem();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                  if (_errors['items'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: MyErrorText(errorText: _errors['items']),
                    ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
