import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyInAppBrowser extends InAppBrowser {
  UserModel mUser = UserModel();
  _WebLoginState? _myTestState;

  void setMyTestStateReference(_WebLoginState myTestState) {
    _myTestState = myTestState;
  }

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {}

  @override
  Future onLoadStop(url) async {
    print("zxc Stopped $url");
    if (url.toString().contains(
        "https://auth.ebay.com/oauth2/ThirdPartyAuthSucessFailure?isAuthSuccessful=true")) {
      _myTestState?.closeBrowserTokenFetched(url!.rawValue);
    }
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    print("Can't load ${request.url}.. Error: ${error.description}");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}

class WebLogin extends StatefulWidget {
  const WebLogin({super.key});

  @override
  State<WebLogin> createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  late final MyInAppBrowser browser;
  Utils _utils = Utils();

  final settings = InAppBrowserClassSettings(
      browserSettings: InAppBrowserSettings(hideUrlBar: false),
      webViewSettings: InAppWebViewSettings(
          javaScriptEnabled: true, isInspectable: kDebugMode));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebay Token'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              browser.openUrlRequest(
                  urlRequest: URLRequest(
                      url: WebUri(ApiEndpoints.ebayAllPermissionLink)),
                  settings: settings);
            },
            child: const Text("Open InAppBrowser to fetch Ebay token")),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    browser = MyInAppBrowser();
    browser.setMyTestStateReference(this);
  }

  void closeBrowserTokenFetched(String? tokenUrl) {
    _utils.getAccessToken(tokenUrl!);
    browser.close();
    browser.dispose();
    Navigator.of(context).pop();
  }
}
