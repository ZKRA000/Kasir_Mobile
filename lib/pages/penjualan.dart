import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/penjualan_collection.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/helper/delete_dialog.dart';
import 'package:kasir/models/penjualan_model.dart';
import 'package:kasir/other/helper.dart';
import 'package:kasir/pages/penjualan_form.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPage();
}

class _PenjualanPage extends State<PenjualanPage> {
  final List<PenjualanCollection> _penjualan = [];
  final PenjualanModel penjualanModel = PenjualanModel();

  void fetchPenjualan() async {
    var response = await penjualanModel.all();
    var responseJson = jsonDecode(response.body);
    setState(() {
      for (var i in responseJson) {
        _penjualan.add(PenjualanCollection.fromJSON(i));
      }
    });
  }

  void editPenjualan(index) async {
    var updateData = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PenjualanFormPage(data: _penjualan[index])),
    );
    if (updateData != null) {
      setState(() {
        _penjualan[index] = PenjualanCollection.fromJSON(updateData);
      });
    }
  }

  void deletePenjualan(index) async {
    var response = await penjualanModel.delete({'id': _penjualan[index].id});
    if (response.body == 'true') {
      setState(() {
        _penjualan.removeAt(index);
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void showDeleteDialog(index) async {
    await deleteDialog(
      context: context,
      onDelete: () async {
        deletePenjualan(index);
      },
      title: 'Delete',
      content: 'Apakah anda yakin ingin menghapus ${_penjualan[index].nota} ?',
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Penjualan'),
      loading: false,
      onCreated: () async {
        var newData = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PenjualanFormPage()),
        );
        if (newData != null) {
          setState(() {
            _penjualan.insert(0, PenjualanCollection.fromJSON(newData));
          });
        }
      },
      child: ListView.builder(
        itemCount: _penjualan.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
            ),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              upperCaseFirst(_penjualan[index].customer),
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              _penjualan[index].status(),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: _penjualan[index].status() == 'Lunas'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Rp. ${idrCurrency(_penjualan[index].price)}',
                              style: const TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Opacity(
                              opacity: 0.5,
                              child: Text(
                                _penjualan[index].nota,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'delete') {
                            showDeleteDialog(index);
                          }

                          if (value == 'edit') {
                            editPenjualan(index);
                          }
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(
                                value: 'delete', child: Text('Delete')),
                          ];
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
