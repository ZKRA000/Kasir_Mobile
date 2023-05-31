import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kasir/collections/item_collection.dart';
import 'package:kasir/components/my_list_item.dart';
import 'package:kasir/components/my_scaffold.dart';
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
    await itemModel.all().then((response) {
      for (var i in jsonDecode(response.body)) {
        _items.add(ItemCollection.fromJSON(i));
      }
      _loading = false;

      setState(() {});
    });
  }

  void deleteitem(index) async {
    await itemModel.delete({'id': _items[index].id}).then((response) {
      _items.removeAt(index);

      if (context.mounted) {
        Navigator.pop(context);
      }
    });

    setState(() {});
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
    return MyScaffold(
      title: const Text('Item'),
      onCreated: () async {
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
      loading: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var index = 0; index < _items.length; index++) ...[
              const SizedBox(height: 8.0),
              MyListItem(
                child: ListTile(
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
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ];
                    },
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
