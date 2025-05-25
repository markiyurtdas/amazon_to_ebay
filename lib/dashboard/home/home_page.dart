import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedListKey;
  String? _selectedAreaValueKey;

  Map<String, List<Map<String, String>>> mainAreaMap = {
    "Orders": [
      {"childKey": "order_all_orders", "value": "All Orders"},
      {"childKey": "order_awaiting_payment", "value": "Awaiting Payment"},
      {"childKey": "order_awaiting_shipment", "value": "Awaiting Shipment"},
      {"childKey": "order_paid_and_shipped", "value": "Paid and Shipped"}
    ]
  };
  List<String> mainAreaList = ["Orders"];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 300,
          height: 600,
          child: getMainMenu(),
        ),
        SingleChildScrollView(
          child: getArea(),
        )
      ],
    );
  }

  Widget getMainMenu() {
    return ListView(
      children: mainAreaMap.keys.map((String key) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                key,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              selected: _selectedListKey == key,
              onTap: () {
                setState(() {
                  _selectedListKey = _selectedListKey == key ? null : key;
                });
              },
              trailing: Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  Icon(
                    _selectedListKey == key
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    size: 40,
                  ), // icon-2
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              firstCurve: Curves.easeInOut,
              secondCurve: Curves.easeInOut,
              crossFadeState: _selectedListKey == key
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: SizedBox.shrink(),
              secondChild: _selectedListKey == key
                  ? Container(
                      width: 250,
                      height: 200,
                      margin: EdgeInsets.only(left: 15),
                      child: ListView(
                        children: mainAreaMap[key]!.map((e) {
                          return ListTile(
                            title: Text(e["value"]!),
                            onTap: () {
                              setState(() {
                                _selectedAreaValueKey = e["childKey"];
                              });
                            },
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget getArea() {
    Widget area;
    if (_selectedAreaValueKey == "order_all_orders") {
      //area = GetAllOders();
    } else if (_selectedAreaValueKey == "order_awaiting_payment") {
      area = Center(
        child: Text("Select Menu order_awaiting_payment"),
      );
    } else if (_selectedAreaValueKey == "order_awaiting_shipment") {
      area = Center(
        child: Text("Select Menu order_awaiting_shipment"),
      );
    } else if (_selectedAreaValueKey == "order_paid_and_shipped") {
      area = Center(
        child: Text("Select Menu order_paid_and_shipped"),
      );
    } else {
      area = Center(
        child: Text("Select Menu Item"),
      );
    }

    //return area;
    return Container();
  }
}
