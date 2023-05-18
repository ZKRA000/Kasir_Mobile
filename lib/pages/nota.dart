import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kasir/collections/nota_collection.dart';
import 'package:kasir/components/my_list_item.dart';
import 'package:kasir/components/my_scaffold.dart';
import 'package:kasir/helper/delete_dialog.dart';
import 'package:kasir/models/nota_model.dart';
import 'package:kasir/other/env.dart';
import 'package:kasir/other/helper.dart';
import 'package:kasir/pages/nota_form.dart';

class NotaPage extends StatefulWidget {
  const NotaPage({super.key});

  @override
  State<NotaPage> createState() => _NotaPage();
}

class _NotaPage extends State<NotaPage> {
  final bool _loading = false;
  final List<NotaCollection> _nota = [];
  final NotaModel notaModel = NotaModel();

  void showDeleteDialog(index) async {
    await deleteDialog(
      context: context,
      onDelete: () async {
        await deleteNota(index);
        if (mounted) {
          Navigator.pop(context);
        }
      },
      title: 'Delete',
      content: 'Apakah anda yakin ingin menghapus ${_nota[index].name} ?',
    );
  }

  void fetchNota() async {
    var response = await notaModel.all();
    var responseJson = jsonDecode(response.body);
    setState(() {
      for (var i in responseJson) {
        _nota.add(NotaCollection.fromJSON(i));
      }
    });
  }

  void editNota(index) async {
    var updateData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotaFormPage(data: _nota[index])),
    );
    if (updateData != null) {
      setState(() {
        _nota[index] = NotaCollection.fromJSON(updateData);
      });
    }
  }

  Future<void> deleteNota(index) async {
    var response = await notaModel.delete({'id': _nota[index].id});
    var responseJson = jsonDecode(response.body);
    if (responseJson is Map) {
      if (responseJson.containsKey('warning')) {
        Fluttertoast.showToast(msg: responseJson['warning']);
      }
    } else {
      setState(() {
        _nota.removeAt(index);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchNota();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: const Text('Nota'),
      loading: _loading,
      onCreated: () async {
        var newData = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotaFormPage()),
        );
        if (newData != null) {
          setState(() {
            _nota.add(NotaCollection.fromJSON(newData));
          });
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var index = 0; index < _nota.length; index++) ...[
              MyListItem(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ListTile(
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Text(
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                            ),
                            _nota[index].name[0].toUpperCase(),
                          ),
                          //if (_nota[index].logo != null)
                          // ClipOval(
                          //   child: Image.network(
                          //     '$baseUrl/${_nota[index].logo}',
                          //     errorBuilder: (context, error, stackTrace) {
                          //       return const Text('');
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    title: Text(upperCaseFirst(_nota[index].name)),
                    subtitle: Text(upperCaseFirst(_nota[index].companyName)),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'delete') {
                          showDeleteDialog(index);
                        }

                        if (value == 'edit') {
                          editNota(index);
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
                ),
              ),
              const SizedBox(height: 12.0),
            ]
          ],
        ),
      ),
    );
  }
}
