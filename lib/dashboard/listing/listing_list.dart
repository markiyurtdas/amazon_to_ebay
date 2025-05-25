import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingList extends StatefulWidget {
  late final List<Map<String, dynamic>> itemList;

  ListingList(this.itemList);

  @override
  State<ListingList> createState() => _ListingListState(itemList);
}

class _ListingListState extends State<ListingList> {
  late final List<Map<String, dynamic>> itemList;

  _ListingListState(this.itemList);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: DataTable(
        columns: [
          DataColumn(label: Text('SKU')),
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('TITLE')),
          DataColumn(label: Text('PRICE')),
          DataColumn(label: Text('QUANTITY')),
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

  List<DataCell> getCells(Map<String, dynamic> item) {
    return [
      DataCell(Container(
        width: 100,
        child: item["SKU"].length > 12
            ? text(item["SKU"])
            : InkWell(
                child: new Text(
                  item["SKU"],
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () =>
                    launch("https://www.amazon.com/dp/${item["SKU"]}")),
      )),
      DataCell(Container(
        child: text(item["ItemID"]),
      )),
      DataCell(Container(
        child: text(item["Title"]),
      )),
      DataCell(Container(
        width: 100,
        child: text("\$${item["BuyItNowPrice"]}"),
      )),
      DataCell(GestureDetector(
        child: Container(
          width: 20,
          child: text(item["QuantityAvailable"]),
        ),
      )),
      DataCell(Container(
        width: 100,
        child: InkWell(
            child: new Text(
              'Go to Ebay',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () => launch("https://www.ebay.com/itm/${item["ItemID"]}")),
      )),
    ];
  }

  SelectableText text(String? mText) {
    return SelectableText(
      mText != null ? mText : "null",
    );
  }

  String getUrl(String mText) {
    String _url = "";
    int firstIndex = mText.indexOf("http");
    String subString = mText.substring(firstIndex + 2);
    int secondIndex = subString.indexOf("http");
    _url = mText.substring(firstIndex, firstIndex + secondIndex);
    return _url;
  }

  String getPrice(String whole, String fraction) {
    return whole + "," + fraction;
  }
}
