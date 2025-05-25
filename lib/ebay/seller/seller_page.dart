import 'dart:convert';

import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:amazon_to_ebay/utils/error_codes.dart';
import 'package:flutter/material.dart';

class EbaySellerPage extends StatefulWidget {
  @override
  State<EbaySellerPage> createState() => _EbaySellerPageState();
}

class _EbaySellerPageState extends State<EbaySellerPage> {
  UserModel mUser = UserModel();
  String inventoryLocationName = "Getting ...";
  String infoText = "info";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(inventoryLocationName),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: getInventoryItems, child: Text('Get Inventory items')),
          ElevatedButton(
              onPressed: getInventoryItem, child: Text('Get Inventory item')),
          ElevatedButton(
              onPressed: createInventoryItem,
              child: Text('Create Inventory item')),
          ElevatedButton(
              onPressed: createOffer, child: Text('Create Offer item')),
          ElevatedButton(
              onPressed: publishoffer, child: Text('Publish Offer item')),
          SelectableText(infoText)
        ],
      ),
    );
  }

  getInventoryLocations() async {
    var res = await networkManager
        .getInventoryLocations(ApiEndpoints.getInventoryLocationsEndpoint);
    var json = jsonDecode(res.body);
    if (json['errors'] != null) {
      var jsonError = json['errors'];
      String errorMessage = jsonError[0]['message'];
      if (errorMessage == ErrorCode.InvalidAccessToken) {
        //TODO
        print("zxcErr: Access token süresi bitmiş");
        mUser.clearSharedPrefs();
        mUser.accessTokenExpired = true;
        Navigator.of(context).pop();
      }
    } else {
      List locationlist = json['locations'];
      if (locationlist.length == 0) {
        setState(() {
          inventoryLocationName =
              "Location not found please create a location first";
        });
      } else {
        setState(() {
          inventoryLocationName = locationlist[0]['name'];
          getInventoryLocationsButtonVisibility = false;
        });
      }
    }
    setState(() {
      infoText = mUser.ebayAccessToken;
    });
  }

  createInventoryLocation() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/createInventoryLocation.json");
    Map<String, dynamic> jsonData = jsonDecode(data);
    var res = await networkManager.createInventoryLocation(
        ApiEndpoints.createInventoryLocationEndpoint, jsonData, "Warehouse-1");
    print(res.body);
  }

  createInventoryItem() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/real/1Item.json");
    var res = await networkManager.createInventoryItem(
        ApiEndpoints.createInventoryItem, data, "NEWITEM");
    setState(() {
      infoText = res.body;
    });
  }

  createOffer() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/real/1offer.json");
    var res = await networkManager.createOffer(ApiEndpoints.createOffer, data);
    setState(() {
      infoText = res.body;
    });

    if (res.statusCode == 200) {
      infoText += "Başarılı ";
      var json = jsonDecode(res.body);
      publishoffer();
    }
  }

  publishoffer() async {
    String url = ApiEndpoints.publishOffer;

    var res = await networkManager
        .createPublishOffer(url.replaceAll("xxxx", '417821568016'));
    setState(() {
      infoText = res.body;
    });
    if (res.statusCode == 200) {
      infoText += "Başarılı";
    }
  }

  @override
  void initState() {
    super.initState();
    getInventoryLocations();
  }

  bool getInventoryLocationsButtonVisibility = true;
  NetworkManager networkManager = NetworkManager();

  void getInventoryItems() async {
    var res =
        await networkManager.getInventoryItems(ApiEndpoints.getInventoryItems);
    print(res.body);
  }

  void getInventoryItem() async {
    var res = await networkManager.getInventoryItem(
        ApiEndpoints.getInventoryItem, "BAMZNKKK");
    print(res.body);
    setState(() {
      infoText = res.body;
    });
    setState(() {
      infoText = mUser.ebayAccessToken;
    });
  }
}
