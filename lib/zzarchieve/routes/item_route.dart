/*import 'dart:convert';

import 'package:amazon_to_ebay/models/item.dart';
import 'package:amazon_to_ebay/models/result.dart';
import 'package:amazon_to_ebay/zzarchieve/ebay_search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemRoute extends StatefulWidget {
  final String _itemNumber;

  ItemRoute(this._itemNumber);

  @override
  createState() => _ItemRouteState();
}

class _ItemRouteState extends State<ItemRoute> {
  final String getItemURL =
      'https://api.sandbox.ebay.com/buy/browse/v1/item/get_item_by_legacy_id?legacy_item_id=';
  late Item item;
  late Future<String> future;

  Future<String> _getItem(BuildContext context) async {
    http.Response response =
        await http.get(Uri.parse(getItemURL + widget._itemNumber), headers: {
      'Authorization': 'Bearer ' + WebServices.of(context)!.token,
      'X-EBAY-C-MARKETPLACE-ID': 'EBAY_US',
      'Content-Type': 'application/json',
    });
    if (response.statusCode != 200) {
      print("Error during search ${response.body}");
      throw Exception(
          "An error occured while loading the item: ${response.body}");
    }
    Map<String, dynamic> json = jsonDecode(response.body);
    setState(() {
      item = Item.fromJson(jsonDecode(response.body));
    });
    return response.toString();
  }

  Widget _getImage() {
    if (item.imageUrl == null) {
      return Image.network(
        Result.defaultImageUrl,
        fit: BoxFit.contain,
        height: 150,
        width: 150,
      );
    }
    try {
      return Image.network(
        item.imageUrl,
        fit: BoxFit.contain,
        height: 150,
        width: 150,
      );
    } catch (Exception) {
      return Image.network(
        Result.defaultImageUrl,
        fit: BoxFit.contain,
        height: 150,
        width: 150,
      );
    }
  }

  Widget _displayItem(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                _getImage(),
                Expanded(
                  child: Text(item.title),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Price: " + item.price.toString(),
                textAlign: TextAlign.left,
              ),
              Text(
                "Condition: " + item.condition.toString(),
                textAlign: TextAlign.left,
              ),
              Text(
                "Seller: " + item.seller.toString(),
                textAlign: TextAlign.left,
              ),
              Text("Buying Options: " + item.buyingOptions.toString(),
                  textAlign: TextAlign.left),
              Text("Bid Count: " + item.bidCount.toString(),
                  textAlign: TextAlign.left),
            ],
          )
        ],
      ),
    );
  }

  Widget _loadingScreen() {
    return Container(
      child: Center(
        child: Text(
          "Loading Item",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    future = _getItem(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ebay Search App"),
      ),
      body: FutureBuilder<String>(
        future: future, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return _loadingScreen();
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return _displayItem(context);
          }
        },
      ),
    );
  }
}
*/
