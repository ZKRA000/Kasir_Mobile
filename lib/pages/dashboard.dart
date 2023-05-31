import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir/collections/item_collection.dart';
import 'package:kasir/collections/penjualan_collection.dart';
import 'package:kasir/collections/profile_collection.dart';
import 'package:kasir/components/my_drawer.dart';
import 'package:kasir/models/item_model.dart';
import 'package:kasir/models/penjualan_model.dart';
import 'package:kasir/models/profile_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  ProfileCollection? _user;
  List<ItemCollection> _items = [];
  List<PenjualanCollection> _penjualan = [];
  final ProfileModel _profileModel = ProfileModel();
  final ItemModel _itemModel = ItemModel();
  final PenjualanModel _penjualanModel = PenjualanModel();

  void getUserData() async {
    await _profileModel.getMyProfile().then((response) {
      if (mounted && response.statusCode == 200) {
        setState(() {
          _user = ProfileCollection.fromJSON(jsonDecode(response.body));
        });
      }
    });
  }

  void fetchItem() async {
    await _itemModel.all().then((response) {
      if (mounted && response.statusCode == 200) {
        for (var i in jsonDecode(response.body)) {
          _items.add(ItemCollection.fromJSON(i));
        }
        setState(() {});
      }
    });
  }

  void fetchPenjualan() async {
    await _penjualanModel.all().then((response) {
      if (mounted && response.statusCode == 200) {
        for (var i in jsonDecode(response.body)) {
          _penjualan.add(PenjualanCollection.fromJSON(i));
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchItem();
    fetchPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        drawer: MyDrawer(
          data: _user,
        ),
        body: Column(
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              _penjualan.length.toString(),
                              style: const TextStyle(
                                height: 0.95,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Positioned(
                            right: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: 0.3,
                              child: Icon(
                                Icons.attach_money,
                                size: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              _items.length.toString(),
                              style: const TextStyle(
                                height: 0.95,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Positioned(
                            right: 0,
                            bottom: 0,
                            child: Opacity(
                              opacity: 0.3,
                              child: Icon(
                                Icons.inventory,
                                size: 100,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: SfCartesianChart(
            //     primaryXAxis: CategoryAxis(),
            //     series: [
            //       LineSeries(
            //         dataSource: _penjualan,
            //         xValueMapper: (e, index) => e.customer,
            //         yValueMapper: (e, index) => e.price,
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
