/*import 'dart:convert';

import 'package:amazon_to_ebay/model/old_models/order_line_item.dart';
import 'package:amazon_to_ebay/model/old_models/order_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class GetAllOders extends StatefulWidget {
  State<GetAllOders> createState() => _GetAllOrdersState();
}

class _GetAllOrdersState extends State<GetAllOders> {
  NetworkManager _networkManager = NetworkManager();
  List<dynamic> _orderJsonList = [];
  List<OrderModel> _orders = [];
  bool orderErrorOccur = false;
  String orderErrorText = "";
  int totalItemNums = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      // Calculate start and end dates for last week
      DateTime now = DateTime.now();

      var response = await _networkManager.getOrders();

      if (response.statusCode == 200) {
        setState(() {
          _orderJsonList = json.decode(response.body)['orders'];
          for (var orderJson in _orderJsonList) {
            final OrderModel order = OrderModel.fromJson(orderJson);
            _orders.add(order);
          }
        });
      } else {
        print('Failed to load orders ${response.body}');
        setState(() {
          orderErrorText = response.body;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        orderErrorText = e.toString();
      });
    }
  }

  Widget getBody() {
    return orderErrorOccur
        ? Center(
            child: Text(
            "Error while fetching orders;\n"
            "$orderErrorText",
            style: TextStyle(color: Colors.red),
          ))
        : _orders.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : DataTable(
                dataRowMaxHeight: double.infinity, // Code to be changed.
                dataRowMinHeight: 60,
                columns: const <DataColumn>[
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Order',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Detail',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Quantity',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Total',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Order Earning',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
                  DataColumn(
                      label: Expanded(
                    child: Text(
                      'Date sold',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )),
                ],
                rows: List<DataRow>.generate(
                  _orders.length,
                  (int index) => DataRow(
                    color: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (index.isEven) {
                        return Colors.grey.withOpacity(0.3);
                      }
                      return null; // Use default value for other states and odd rows.
                    }),
                    cells: orderView(_orders[index]),
                  ),
                ),
              );
  }

  List<DataCell> orderView(OrderModel orderModel) {
    OrderLineItem item = orderModel.lineItems![0];
    return [
      DataCell(Column(
        children: [
          InkWell(
              child: new Text(
                'Go to order',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () => _launchUrl(
                  ApiEndpoints.ebayOrderDetail + orderModel.legacyOrderId!)),
          Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.all(4),
              child: buildCachedNetworkImage(item.legacyItemId!))
        ],
      )),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 250,
            child: SelectableText(item.title!),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: SelectableText(item.legacyItemId!),
          ),
          InkWell(
              child: new Text(
                item.sku!,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () =>
                  _launchUrl(ApiEndpoints.amazonProductLink + item.sku!)),
        ],
      )),
      DataCell(Column(
        children: [Text("${item.quantity}")],
      )),
      DataCell(Column(children: [Text("\$${item.lineItemCost?.value}")])),
      DataCell(Column(
        children: [
          Text("\$${orderModel.paymentSummary?.totalDueSeller?.value}")
        ],
      )),
      DataCell(Column(
        children: [Text(convertDateToString(orderModel.creationDate!))],
      )),
    ];
  }

  String getItemLink(String itemId) {
    String link = "";
    return link;
  }

  String convertDateToString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat.yMMMMd().add_jms().format(dateTime);
    return formattedDate;
  }

  Widget buildCachedNetworkImage(String itemId) {
    return FutureBuilder<String>(
      future: _networkManager
          .getMainPhotoOfItem(itemId), // Call your future method here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
        }
      },
    );
  }

  Future<void> _launchUrl(String murl) async {
    Uri url = Uri.parse(murl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
*/
