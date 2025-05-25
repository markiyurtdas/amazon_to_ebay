/*import 'dart:convert';

import 'package:amazon_to_ebay/models/ebay_item_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetItemRoute extends StatefulWidget {
  final String title;

  GetItemRoute({Key? key, required this.title}) : super(key: key);

  @override
  createState() => _GetItemRouteState();
}

class _GetItemRouteState extends State<GetItemRoute> {
  String getItemResult = "empty item";

  void _getItemHttp(String epid) async {
    // Get search results for keyword
    http.Response response = await http.get(
      Uri.parse(ApiEndpoints.getItem + epid),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode != 200) {
      print("Error during search ${response.body}");
      return;
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    setState(() {
      getItemResult = body.toString();
      ebayItemModel = EbayItemModel.fromJson(body);
    });
  }

  @override
  void initState() {
    super.initState();
    _getItemHttp("v1|353663781961|0");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ebayItemModel == null
            ? Text('Item getiriliyor')
            : Column(children: [
                Container(
                  height: ebayItemModel!.image.height.toDouble() * 0.3,
                  width: ebayItemModel!.image.width.toDouble() * 0.3,
                  child: Image.network(ebayItemModel!.image.imageUrl),
                ),
                Text("Price is: " +
                    ebayItemModel!.price.value.toString() +
                    " " +
                    ebayItemModel!.price.currency),
                Text(ebayItemModel!.title),
                Text(ebayItemModel!.shortDescription),
              ]),
      ),
    );
  }

  EbayItemModel? ebayItemModel;
  String _token =
      "v^1.1#i^1#r^0#I^3#p^1#f^0#t^H4sIAAAAAAAAAOVYa2wUVRTu9kWQAgYNkIboOmB47uydx053x+6GbQvdLUt37W4XqAqZnbnTDp0XM3coK0ZqFXxEAygYEx9BTCoQQ0w0IpjURzSE/hB+EDEgGBNDQA0ElIcRozO7bdlWAkg3sYn7ZzPnnnvu933nnHvvDOiuHD9vU2TTlYmucaU7ukF3qctFTADjKyvmTyorra4oAQUOrh3ds7rLe8rO1JqcIutsCzR1TTWhe50iqyabMwYxy1BZjTMlk1U5BZos4tlkeGmMJXHA6oaGNF6TMXe0IYjRfkagoOgL0CLvZ4BgW9XBmCktiAU4wPh9NJVhIFFD+kV73DQtGFVNxKkoiJGApD2A8pBUCgCWJliSwQFDtWHuNDRMSVNtFxxgoRxcNjfXKMB6c6icaUID2UGwUDS8OBkPRxsWNadqvQWxQgM6JBGHLHP4U70mQHeaky1482XMnDebtHgemibmDeVXGB6UDQ+CuQP4eakFkRT8/gzDUAwTEKiiSLlYMxQO3RyHY5EEj5hzZaGKJJS9laK2GpnVkEcDT812iGiD2/l72OJkSZSgEcQW1YVXhBMJO1anwSkrLMOTMDTB4lGLJ9HS4BFogffxsMbvAT46wNQA38BC+WgDMo9YqV5TBckRzXQ3a6gO2qjhSG2oAm1sp7gaN8IichAV+pGDGtJ0m5PUfBYt1KE6eYWKLYQ793jrDAzNRsiQMhaCQxFGDuQkCmKcrksCNnIwV4sD5bPODGIdCOms19vV1YV3UbhmtHtJAAjv8qWxJN8BFQ6zfZ1ez/tLt57gkXJUeGjPNCUWZXUbyzq7Vm0AajsWogMkRQ9mYTis0EjrPwwFnL3DO6JYHUKRfoIAAu8XMjBTQ5PF6JDQQJF6HRwww2U9Cmd0QqTLHA89vF1nlgINSWApn0hSfhF6BCYgeuiAKHoyPoHxECKEAMJMhg/4/0+NcrulnoS8AVFRar1odd7lb6WbDalVtOZzsMmbrQu0tDSH+ZYAhZahWGM2Rsfkti6qOa1Fg7fbDTckXy9LtjIpe/1iCOD0evFEiGgmgsKo6CV5TYcJTZb47NhKMGUICc5A2SSUZdswKpJhXY8WZ68uGr1/uU3cGe/inVH/0fl0Q1amU7Jji5Uz37QDcLqEOycQzmuK1+l1jbOvH455VQ71qHhL9s11TLG2SebZSkL+yonn6OLmWh43oKlZhn3bxuPODSyldULVPs+QockyNNLEqPtZUSzEZWQ41hq7CAUucWPssCVqCILw0fab5Kh48bmjdNVY25KKsRWXN97htdo7/CU/VJL7ET2uL0CPq6/U5QK14EFiJnigsqy1vKyq2pQQxCVOxE2pXbXfXQ2Id8KszklG6T0lF3duj9RXL4q/Om99Knvk9YMlVQXfGHY8BqYPfWUYX0ZMKPjkAGZcH6kgJk+bSNKAIikAaIJk2sDM66PlxNTyexsDypZvImcPtIivPfFReve3l+ILToOJQ04uV0VJeY+rpG3a3dE/l5V/fEVfcjA7YUrEeKhv1s+XXWfqZMj0dj254cOX6rTNv8c3JmacvO/EkhPb332q9ei23tMrhXM/6L+gu/6Ywcci3b9efvxabJXStDXbePhY06VHqt7fd+F4/Oxn57Tz+7ftPj91U+LTs97+potzqi7V7rPun73y6QvC5Feu7qxGiZ86Xt6a1o7QaSLVunfD4f4P2MrpCyK/pfr2W598/vVyZfaX/c/t+arhHfW7BW/92Ptow6GDC/8aF/NtfC/z4srKZ3ddPbdwTzekvt87b3Nw/cn+44H513Ydfdv9zNzI7k0HSra09045NffNvkOnj007hUf5F9aySfHKHO/zWy6/EV69Zk366qR8Lv8Gam/USf0RAAA=";
}
*/
