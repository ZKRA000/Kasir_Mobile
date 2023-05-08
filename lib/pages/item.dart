import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kasir/models/abstract/model.dart';
import 'package:kasir/models/item.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPage();
}

class _ItemPage extends State<ItemPage> {
  ItemModel itemModel = ItemModel();

  List<dynamic> items = [];
  bool _loading = true;

  void fetchItem() async {
    var data = await itemModel.all();

    setState(() {
      items = jsonDecode(data.body);
      _loading = false;
    });
  }

  void deleteitem(index) async {
    var data = await itemModel.delete({'id': items[index]['id']});

    setState(() {
      items.removeAt(index);
    });

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  Future<void> deleteDialog(index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: Text(
              'Apakah anda yakin ingin menghapus ${items[index]['nama']} ?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  deleteitem(index);
                },
                child: const Text('Ya'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tidak'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Items'),
          actions: [
            IconButton(
              onPressed: () async {
                final newItem = await Navigator.pushNamed(context, 'item-form');
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Column(
          children: [
            if (_loading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[index]['nama']),
                      subtitle: Text('Rp.' + items[index]['harga'].toString()),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'delete') {
                            deleteDialog(index);
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
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
