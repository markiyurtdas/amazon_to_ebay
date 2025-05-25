/*import 'dart:convert';

import 'package:amazon_to_ebay/zzarchieve/ebay_search_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/result.dart';
import '../widgets/result_widget.dart';

class SearchRoute extends StatefulWidget {
  final String title;

  SearchRoute({Key? key, required this.title}) : super(key: key);

  @override
  createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  List<Result> _results = <Result>[];
  late int _currentPage;
  late int _nextPage;
  late int _totalPages;
  late String _searchText;
  final int _entriesPerPage = 50;
  ScrollController _controller = ScrollController();
  static final String findItemURL =
      'https://svcs.sandbox.ebay.com/services/search/FindingService/v1';

  void _postFindItemsByKeywords(String text) async {
    // Get search results for keyword
    http.Response response = await http.post(Uri.parse(findItemURL),
        headers: {
          'X-EBAY-SOA-SECURITY-APPNAME': WebServices.of(context)!.appID,
          'X-EBAY-SOA-OPERATION-NAME': 'findItemsByKeywords',
          'X-EBAY-SOA-REQUEST-DATA-FORMAT': 'JSON'
        },
        body: jsonEncode({
          "keywords": "$text",
          "outputSelector": "GalleryInfo",
          "paginationInput": {
            "entriesPerPage": _entriesPerPage,
            "pageNumber": _currentPage,
          },
        }));
    if (response.statusCode != 200) {
      print("Error during search ${response.body}");
      return;
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    body = body['findItemsByKeywordsResponse'][0];

    // Add the results to the _results list and display them
    _totalPages = (int.parse(body['paginationOutput'][0]['totalPages'][0]));
    if (_currentPage <= _totalPages) {
      List<dynamic> items = body['searchResult'][0]['item'];
      List<Result> results = [];
      for (var i = 0; i < items.length; ++i) {
        results.add(Result.fromJson(items[i]));
      }

      // Set the state
      setState(() {
        _results.addAll(results);
      });
      _nextPage = _currentPage + 1;
    }
  }

  void _getSearchResults(String text) {
    // Reset all variables for this search
    _results.clear();
    _currentPage = 1;
    _totalPages = 0;
    _searchText = text;
    _postFindItemsByKeywords(_searchText);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() async {
      if (_controller.position.extentAfter == 0 && _nextPage <= _totalPages) {
        _currentPage = _nextPage;
        _postFindItemsByKeywords(_searchText);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Container(
          child: TextField(
            onSubmitted: (String text) {
              _getSearchResults(text);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _controller,
            itemCount: _results.length,
            itemBuilder: (BuildContext context, int index) {
              return ResultWidget(_results[index]);
            },
          ),
        ),
      ]),
    );
  }
}
*/
