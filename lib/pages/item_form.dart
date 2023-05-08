import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/models/item.dart';

class ItemBundle {
  final String name;
  final int id;
  final int price;
  int count;
  int totalPrice = 0;

  ItemBundle({
    required this.name,
    required this.id,
    required this.price,
    this.count = 1,
  });

  int getTotalPrice() {
    return count * price;
  }

  factory ItemBundle.fromJSON(data) {
    return ItemBundle(
      name: data['nama'],
      id: data['id'],
      price: data['harga'],
      count: 0,
    );
  }
}

class ItemFormPage extends StatefulWidget {
  const ItemFormPage({super.key});

  @override
  State<ItemFormPage> createState() => _ItemFormPage();
}

class _ItemFormPage extends State<ItemFormPage> {
  ItemModel itemModel = ItemModel();

  // global
  final Map<String, dynamic> _formData = {};
  List<dynamic> _bundle = [];
  List<dynamic> items = [];
  late PageController _pageViewController;

  //bottomsheet
  int _selectedItemIndex = 0;
  late int jumlah;

  void fetchItem() async {
    var data = await itemModel.all();

    setState(() {
      items = jsonDecode(data.body);
    });
  }

  void createItem() async {
    if (_formData['type'] == 'bundle') {
      _formData['items'] = [];
      for (var e = 0; e < _bundle.length; e++) {
        _formData['items'].add({
          'id': _bundle[e].id,
          'qty': _bundle[e].count,
        });
      }
    }

    var response = await itemModel.create(_formData);
    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _formData['type'] = 'single';
    _pageViewController = PageController(initialPage: 0);

    fetchItem();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageViewController.dispose();
  }

  void toPage(index) {
    _pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                createItem();
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Name'),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: _formData['nama'],
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(12.0),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _formData['nama'] = value;
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
                          Text('Price'),
                          SizedBox(height: 12.0),
                          TextFormField(
                            initialValue: _formData['harga'],
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(12.0),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _formData['harga'] = value;
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
                          Text('Item Bundle'),
                          SizedBox(height: 12.0),
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
                                            '${_bundle[index].name} @(${_bundle[index].price})'),
                                        const SizedBox(height: 4.0),
                                        Text(_bundle[index]
                                            .getTotalPrice()
                                            .toString()),
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
                                                      items.length,
                                                      (index) {
                                                        return DropdownMenuItem(
                                                          value: index,
                                                          child: Text(
                                                            items[index]
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
                                                          ItemBundle.fromJSON(items[
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
