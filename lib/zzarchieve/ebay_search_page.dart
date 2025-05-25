/*import 'package:amazon_to_ebay/routes/search_route.dart';
import 'package:flutter/material.dart';

class EbayPage extends StatefulWidget {
  @override
  createState() => _EbayPageState();
}

class _EbayPageState extends State<EbayPage> {
  late String _token =
      "v^1.1#i^1#p^3#I^3#r^1#f^0#t^Ul4xMF80OjE2RTQ3RkI2NzY1Q0YxRTc2NDc0MDY4MTQ4MkJENTE5XzBfMSNFXjI2MA==";
  late String _appID = "IkramYur-ProductR-PRD-d4dc5ce78-05496705";
  late String _certID = "PRD-4dc5ce785250-91d9-4f97-93c3-4c88";

  // Get auth token for making api calls

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebServices(
      _token,
      _appID,
      _certID,
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ebay Search App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SearchRoute(title: 'Ebay Search App'),
      ),
    );
  }
}

class WebServices extends InheritedWidget {
  final String token;
  final String appID;
  final String certID;

  const WebServices(this.token, this.appID, this.certID, Widget child)
      : super(child: child);

  @override
  bool updateShouldNotify(WebServices oldWidget) {
    return token != oldWidget.token;
  }

  static WebServices? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WebServices>();
  }
}
*/
