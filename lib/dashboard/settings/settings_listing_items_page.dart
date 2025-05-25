import 'dart:convert';

import 'package:amazon_to_ebay/model/inventory_model.dart';
import 'package:amazon_to_ebay/model/listing_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:amazon_to_ebay/utils/hive_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xml/xml.dart' as xml;

class SettingsListingItemspage extends StatefulWidget {
  const SettingsListingItemspage({super.key});

  @override
  State<SettingsListingItemspage> createState() =>
      _SettingsListingItemspageState();
}

class _SettingsListingItemspageState extends State<SettingsListingItemspage> {
  int _localListingCount = -1;
  int _ebayListingCount = -1;
  int _localInventoryCount = -1;
  int _ebayInventoryCount = -1;
  NetworkManager _networkManager = NetworkManager();
  HiveDataManager _hiveDataManager = HiveDataManager();
  late Box<ListingModel> listingBox;
  late Box<InventoryModel> inventoryBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Listing info:"),
        Text("Local listing count: ${_localListingCount}"),
        _ebayListingCount == -1
            ? Center(
                child: const CircularProgressIndicator(),
              )
            : Text("Ebay listing count: ${_ebayListingCount}"),
        ElevatedButton(
            onPressed: updateLocalListing, child: Text("Update local listing")),
        SizedBox(
          height: 50,
        ),
        Text("Local inventory count: ${_localInventoryCount}"),
        Text("Ebay inventory count: ${_ebayInventoryCount}"),
        ElevatedButton(
            onPressed: updateLocalInventory,
            child: Text("Update local inventory")),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    setupPage();
  }

  setupPage() async {
    getLocalListingCount();
    getLocalInventoryCount();

    getEbayListingCount();
    getEbayInventoryCount();
  }

  getLocalListingCount() {
    var valueList = _hiveDataManager.getListingBox();
    setState(() {
      _localListingCount = valueList.length;
    });
  }

  getLocalInventoryCount() {
    var valueList = _hiveDataManager.getInventoryBox();
    setState(() {
      _localInventoryCount = valueList.length;
    });
  }

  getEbayListingCount() async {
    try {
      var response = await _networkManager.getAllListings(entriesPerPage: 1);

      if (response.statusCode == 200) {
        final xmlString = response.body;
        var totalEbayListingCount = await getTotalNumberOfEntities(xmlString);
        setState(() {
          _ebayListingCount = totalEbayListingCount;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  getEbayInventoryCount() async {
    final response =
        await _networkManager.getInventoryItems(ApiEndpoints.getInventoryItems);

    final data = jsonDecode(response.body);
    setState(() {
      _ebayInventoryCount = data["total"];
    });
  }

  int getTotalNumberOfEntities(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    final totalEntriesElement =
        document.findAllElements('TotalNumberOfEntries').single;
    var returnValue = totalEntriesElement.text ?? "-2";
    return int.parse(returnValue);
  }

  Future<void> updateLocalListing() async {
    var listingBox = _hiveDataManager.getListingBox();
    listingBox.clear();
    var totalPage = _ebayListingCount ~/ 200 + 2;
    for (int index = 1; index < totalPage; index++) {
      try {
        var response = await _networkManager.getAllListings(
            entriesPerPage: 200, pageNumber: index);
        if (response.statusCode == 200) {
          final xmlString = response.body;
          var activeListing = getItemsFromXml(xmlString);
          activeListing.forEach((element) {
            ListingModel listingModel = ListingModel.fromJson(element);
            listingBox.put(listingModel.sku, listingModel);
          });
        } else {
          // Handle errors
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        print('Exception occurred: $e');
      }
    }
    setState(() {
      _localListingCount = listingBox.length;
    });
  }

  void updateLocalInventory() {}

  List<Map<String, dynamic>> getItemsFromXml(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    final itemArray = document.findAllElements('ItemArray').single;

    List<Map<String, dynamic>> items = [];

    itemArray.findAllElements('Item').forEach((itemElement) {
      var singleItem = _parseItem(itemElement);
      items.add(singleItem);
    });

    return items;
  }

  Map<String, dynamic> _parseItem(xml.XmlElement itemElement) {
    Map<String, dynamic> itemMap = {};

    itemElement.children.whereType<xml.XmlElement>().forEach((node) {
      final Map<String, dynamic> attributes = {};
      node.attributes.forEach((attribute) {
        attributes[attribute.name.toString()] = attribute.value;
      });

      final textContent = node.text;

      if (textContent.trim().isNotEmpty) {
        itemMap[node.name.toString()] = textContent;
      } else {
        if (node.name.toString() == 'ListingDetails') {
          final detailsMap = _parseListingDetails(node);
          itemMap[node.name.toString()] =
              detailsMap.isNotEmpty ? detailsMap : attributes;
        } else {
          final childrenMap = _parseChildren(node);
          itemMap[node.name.toString()] =
              childrenMap.isNotEmpty ? childrenMap : attributes;
        }
      }
    });

    return itemMap;
  }

  Map<String, dynamic> _parseListingDetails(
      xml.XmlElement listingDetailsElement) {
    final detailsMap = <String, dynamic>{};

    listingDetailsElement.children
        .whereType<xml.XmlElement>()
        .forEach((childElement) {
      final Map<String, dynamic> attributes = {};
      childElement.attributes.forEach((attribute) {
        attributes[attribute.name.toString()] = attribute.value;
      });

      final textContent = childElement.text;

      if (textContent.trim().isNotEmpty) {
        detailsMap[childElement.name.toString()] = textContent;
      } else {
        final grandchildrenMap = _parseChildren(childElement);
        detailsMap[childElement.name.toString()] =
            grandchildrenMap.isNotEmpty ? grandchildrenMap : attributes;
      }
    });

    return detailsMap;
  }

  Map<String, dynamic> _parseChildren(xml.XmlElement parentElement) {
    final childrenMap = <String, dynamic>{};

    parentElement.children.whereType<xml.XmlElement>().forEach((childElement) {
      final Map<String, dynamic> attributes = {};
      childElement.attributes.forEach((attribute) {
        attributes[attribute.name.toString()] = attribute.value;
      });

      final textContent = childElement.text;

      if (textContent.trim().isNotEmpty) {
        childrenMap[childElement.name.toString()] = textContent;
      } else {
        final grandchildrenMap = _parseChildren(childElement);
        childrenMap[childElement.name.toString()] =
            grandchildrenMap.isNotEmpty ? grandchildrenMap : attributes;
      }
    });

    return childrenMap;
  }
}
