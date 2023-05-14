import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/item_collection.dart';
import 'package:kasir/collections/nota_collection.dart';
import 'package:kasir/collections/penjualan_collection.dart';
import 'package:kasir/components/my_input.dart';
import 'package:kasir/components/my_input_dropdown.dart';
import 'package:kasir/components/my_sacffold_form.dart';
import 'package:kasir/components/my_text_button.dart';
import 'package:kasir/models/item_model.dart';
import 'package:kasir/models/nota_model.dart';
import 'package:kasir/models/penjualan_model.dart';
import 'package:kasir/other/helper.dart';

class PenjualanFormPage extends StatefulWidget {
  final PenjualanCollection? data;
  const PenjualanFormPage({super.key, this.data});

  @override
  State<PenjualanFormPage> createState() => _PenjualanFormPage();
}

class _PenjualanFormPage extends State<PenjualanFormPage> {
  final Map<String, dynamic> _formData = {};
  final Map<String, dynamic> _errors = {};
  final List<ItemCollection> _items = [];
  final List<NotaCollection> _nota = [];
  final List<Map<String, dynamic>> _cart = [];
  final ItemModel itemModel = ItemModel();
  final PenjualanModel penjualanModel = PenjualanModel();
  final NotaModel notaModel = NotaModel();
  int _bottomSheetSelectedIndexItem = 0;
  int _bottomSheetItemQuantity = 0;
  String _bottomSheetItemNotes = '';

  void prepareForm() {
    setState(() {
      var data = widget.data;
      if (data != null) {
        _formData['id'] = data.id;
        _formData['customer'] = data.customer;
        _formData['contact'] = data.contact;
        _formData['paid'] = data.paid;
        _formData['discount'] = data.discounts;
        _formData['nota'] = data.notaId;

        for (var i in data.dPenjualan) {
          _cart.add({
            'item': ItemCollection(
              id: i.hItem.itemId,
              nama: i.hItem.nama,
              harga: i.hItem.harga,
              version: i.hItem.version,
              bundle: null,
            ),
            'jumlah': i.quantity,
            'notes': i.notes,
          });
        }
      }
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

  void fetchItems() async {
    var response = await itemModel.all();
    var responseJson = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        for (var i in responseJson) {
          _items.add(ItemCollection.fromJSON(i));
        }
      });
    }
  }

  void fetchNota() async {
    var response = await notaModel.all();
    var responseJson = jsonDecode(response.body);
    if (mounted) {
      setState(() {
        for (var i in responseJson) {
          _nota.add(NotaCollection.fromJSON(i));
        }
      });
    }
  }

  void createPenjualan() async {
    _formData['item'] = [];
    for (var i in _cart) {
      _formData['item'].add({
        'id': i['item'].id,
        'version': i['item'].version,
        'jumlah': i['jumlah'],
        'notes': i['notes'],
      });
    }
    var response = await penjualanModel.create(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(responseJson);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  void updatePenjualan() async {
    _formData['item'] = [];
    for (var i in _cart) {
      _formData['item'].add({
        'id': i['item'].id,
        'version': i['item'].version,
        'jumlah': i['jumlah'],
        'notes': i['notes'],
      });
    }
    var response = await penjualanModel.update(_formData);
    var responseJson = jsonDecode(response.body);
    if (responseJson.containsKey('errors')) {
      errorValidation(responseJson);
    } else if (mounted) {
      Navigator.pop(context, responseJson);
    }
  }

  Widget cartItem(index) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cart[index]['item'].nama,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      idrCurrency(
                          _cart[index]['item'].harga * _cart[index]['jumlah']),
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4.0),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        '@${idrCurrency(_cart[index]['item'].harga)}',
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        initialValue: _cart[index]['jumlah'].toString(),
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
                              _cart[index]['jumlah'] = int.parse(value);
                            });
                          }
                        },
                      ),
                    ),
                    MyTextButton(
                      onPressed: () {
                        setState(() {
                          _cart.removeAt(index);
                        });
                      },
                      child: const Icon(Icons.delete),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              initialValue: _cart[index]['notes'],
              maxLines: 2,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(12.0),
                border: OutlineInputBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showCart() async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyInputDropdown<int>(
                      initialValue: _bottomSheetSelectedIndexItem,
                      label: 'Item',
                      onChange: (val) {
                        setState(() {
                          _bottomSheetSelectedIndexItem = val!;
                        });
                      },
                      items: List.generate(_items.length, (index) {
                        return {
                          'text': _items[index].nama,
                          'value': index,
                        };
                      }),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyInput(
                      label: 'Jumlah',
                      onChanged: (val) {
                        setState(() {
                          _bottomSheetItemQuantity = int.parse(val);
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MyInput(
                      label: 'Notes',
                      maxLines: 4,
                      onChanged: (val) {
                        setState(() {
                          _bottomSheetItemNotes = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 100.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: MyTextButton(
                        color: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        onPressed: () {
                          setState(() {
                            _cart.add({
                              'item': _items[_bottomSheetSelectedIndexItem],
                              'jumlah': _bottomSheetItemQuantity,
                              'notes': _bottomSheetItemNotes,
                            });
                            _bottomSheetItemQuantity = 0;
                            _bottomSheetSelectedIndexItem = 0;
                          });

                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    fetchNota();
    if (widget.data != null) {
      prepareForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffoldForm(
      title: 'Form Penjualan',
      onSave: () {
        if (widget.data != null) {
          updatePenjualan();
        } else {
          createPenjualan();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Customer',
                initialValue: _formData['customer'],
                errorText: _errors['customer'],
                onChanged: (val) {
                  setState(() {
                    _formData['customer'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Contact',
                initialValue: _formData['contact'],
                errorText: _errors['contact'],
                onChanged: (val) {
                  setState(() {
                    _formData['contact'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Paid',
                initialValue: _formData['paid'].toString(),
                errorText: _errors['paid'],
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  setState(() {
                    _formData['paid'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInput(
                label: 'Discount',
                initialValue: _formData['discount'],
                errorText: _errors['discount'],
                onChanged: (val) {
                  setState(() {
                    _formData['discount'] = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MyInputDropdown(
                initialValue: _formData['nota'],
                label: 'Nota',
                onChange: (val) {
                  setState(() {
                    _formData['nota'] = val;
                  });
                },
                items: _nota
                    .map((e) => {
                          'text': e.name,
                          'value': e.id,
                        })
                    .toList(),
              ),
            ),
            const SizedBox(height: 12.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Items'),
            ),
            const SizedBox(height: 12.0),
            for (var i = 0; i < _cart.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: cartItem(i),
              ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: MyTextButton(
                  color: const Color(0xFFE4EBE6),
                  onPressed: () async {
                    await showCart();
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100.0)
          ],
        ),
      ),
    );
  }
}
