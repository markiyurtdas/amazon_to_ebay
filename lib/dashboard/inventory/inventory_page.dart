import 'dart:convert';

import 'package:amazon_to_ebay/dashboard/inventory/inventory_list.dart';
import 'package:amazon_to_ebay/model/inventory_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> jsonInventory = [];
  List<InventoryModel> inventory = [];
  NetworkManager _networkManager = NetworkManager();
  @override
  void initState() {
    super.initState();
    fetchMyInventory();
  }

  Future<void> fetchMyInventory() async {
    final response =
        await _networkManager.getInventoryItems(ApiEndpoints.getInventoryItems);

    final data = jsonDecode(response.body);

    jsonInventory = data['inventoryItems'];
    for (var item in jsonInventory) {
      var mItem = InventoryModel.fromJson(item["product"]);
      mItem.sku = item['sku'];
      inventory.add(mItem);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: inventory.isEmpty
          ? Center(
              child: Container(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: InventoryList(inventory),
            ),
    );
  }
}
