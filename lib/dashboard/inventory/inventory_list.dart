import 'dart:convert';

import 'package:amazon_to_ebay/model/inventory_model.dart';
import 'package:flutter/material.dart';

class InventoryList extends StatefulWidget {
  late final List<InventoryModel> itemList;

  InventoryList(this.itemList);

  @override
  State<InventoryList> createState() => _InventoryListState(itemList);
}

class _InventoryListState extends State<InventoryList> {
  late final List<InventoryModel> itemList;

  _InventoryListState(this.itemList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DataTable(
        columns: [
          DataColumn(label: Text('SKU')),
          DataColumn(label: Text('NAME')),
          DataColumn(label: Text('PRICE')),
          DataColumn(label: Text('URL')),
        ],
        rows: List.generate(
          itemList.length,
          (index) => DataRow(
            cells: getCells(itemList[index]),
          ),
        ),
      ),
    );
  }

  List<DataCell> getCells(InventoryModel item) {
    return [
      DataCell(text(item.sku)),
      DataCell(text(item.product?.title)),
      DataCell(text("99.99")),
      DataCell(text("URL")),
    ];
  }

  SelectableText text(String? mText) {
    return SelectableText(mText != null ? mText : "null");
  }

  String getPrice(String whole, String fraction) {
    return whole + "," + fraction;
  }

  @override
  void initState() {
    super.initState();
    var spaces = ' ' * 4;
    var encoder = JsonEncoder.withIndent(spaces);
    print(encoder.convert(itemList[0]));
  }
}
