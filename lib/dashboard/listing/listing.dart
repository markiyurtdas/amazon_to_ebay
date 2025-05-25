import 'package:amazon_to_ebay/dashboard/listing/listing_list.dart';
import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:xml/xml.dart' as xml;

class ListingPage extends StatefulWidget {
  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  NetworkManager _networkManager = NetworkManager();
  List<Map<String, dynamic>> activeListing = [];
  UserModel _userModel = UserModel();
  bool _isListActive = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isListActive
          ? ListingList(activeListing)
          : Lottie.asset('assets/animation/loading.json'),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchActiveListings();
  }

  void fetchActiveListings() async {
    try {
      var response = await _networkManager.getAllListings();

      if (response.statusCode == 200) {
        final xmlString = response.body;
        setState(() {
          activeListing = getItemsFromXml(xmlString);
          _isListActive = true;
        });
      } else {
        // Handle errors
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

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
}
