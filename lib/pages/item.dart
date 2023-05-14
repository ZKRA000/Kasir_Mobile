import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kasir/collections/item_collection.dart';
import 'package:kasir/helper/delete_dialog.dart';
import 'package:kasir/models/item_model.dart';
import 'package:kasir/other/helper.dart';
import 'package:kasir/pages/item_form.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPage();
}

class _ItemPage extends State<ItemPage> {
  ItemModel itemModel = ItemModel();
  final List<ItemCollection> _items = [];
  bool _loading = true;

  void fetchItem() async {
    var response = await itemModel.all();
    var responseJson = jsonDecode(response.body);
    setState(() {
      for (var i in responseJson) {
        _items.add(ItemCollection.fromJSON(i));
      }
      _loading = false;
    });
  }

  void deleteitem(index) async {
    await itemModel.delete({'id': _items[index].id});

    setState(() {
      _items.removeAt(index);
    });

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void editItem(index) async {
    final updateData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemFormPage(data: _items[index]),
      ),
    );
    if (updateData != null) {
      setState(() {
        _items[index] = ItemCollection.fromJSON(updateData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  void showDeleteDialog(index) async {
    await deleteDialog(
      context: context,
      onDelete: () {
        deleteitem(index);
      },
      title: 'Delete',
      content: 'Apakah anda yakin ingin menghapus ${_items[index].nama} ?',
    );
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
                final newData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ItemFormPage()),
                );
                if (newData != null) {
                  setState(() {
                    _items.add(ItemCollection.fromJSON(newData));
                  });
                }
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
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(upperCaseFirst(_items[index].nama)),
                      subtitle: Text("Rp. ${idrCurrency(_items[index].harga)}"),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'delete') {
                            showDeleteDialog(index);
                          }
                          if (value == 'edit') {
                            editItem(index);
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
