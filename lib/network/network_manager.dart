import 'dart:convert';

import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/network/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class NetworkManager {
  UserModel mUser = UserModel();
  static final NetworkManager _singleton = NetworkManager._internal();
  BaseApi baseApi = BaseApi();

  factory NetworkManager() {
    return _singleton;
  }

  NetworkManager._internal();

  Future<Map<String, dynamic>?> refreshAccessToken(String refreshToken) async {
    final String tokenEndpoint =
        'https://api.ebay.com/identity/v1/oauth2/token';
    final String clientId = mUser.clientIdAppId;
    final String clientSecret = mUser.clientSecretCertId;

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    // Make the HTTP POST request
    final http.Response response = await http.post(
      Uri.parse(tokenEndpoint),
      body: requestBody,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      print('Failed to refresh access token: ${response.body}');
      return null;
    }
  }

  String ebayLaunchLoginUrl() {
    String scope =
        '${ApiEndpoints.SCOPE_SELL_INVENTORY} ${ApiEndpoints.SCOPE_API_SCOPE}';

    String url =
        "https://auth.ebay.com/oauth2/authorize?client_id=IkramYur-ProductR-PRD-d4dc5ce78-05496705&response_type=code&redirect_uri=Ikram_Yurtdas-IkramYur-Produc-ecdccbc&scope=https://api.ebay.com/oauth/api_scope https://api.ebay.com/oauth/api_scope/sell.marketing.readonly https://api.ebay.com/oauth/api_scope/sell.marketing https://api.ebay.com/oauth/api_scope/sell.inventory.readonly https://api.ebay.com/oauth/api_scope/sell.inventory https://api.ebay.com/oauth/api_scope/sell.account.readonly https://api.ebay.com/oauth/api_scope/sell.account https://api.ebay.com/oauth/api_scope/sell.fulfillment.readonly https://api.ebay.com/oauth/api_scope/sell.fulfillment https://api.ebay.com/oauth/api_scope/sell.analytics.readonly https://api.ebay.com/oauth/api_scope/sell.finances https://api.ebay.com/oauth/api_scope/sell.payment.dispute https://api.ebay.com/oauth/api_scope/commerce.identity.readonly https://api.ebay.com/oauth/api_scope/sell.reputation https://api.ebay.com/oauth/api_scope/sell.reputation.readonly https://api.ebay.com/oauth/api_scope/commerce.notification.subscription https://api.ebay.com/oauth/api_scope/commerce.notification.subscription.readonly https://api.ebay.com/oauth/api_scope/sell.stores https://api.ebay.com/oauth/api_scope/sell.stores.readonly";
    return url;
  }

  String ebayLaunchLoginUrlForSellAcc() {
    String scope = '${ApiEndpoints.SCOPE_SELL_ACCOUNT}';

    String url =
        "${ApiEndpoints.prodLoginEndpoint}?client_id=${mUser.clientIdAppId}&redirect_uri=${mUser.runame}&response_type=code&scope=${scope}";
    return url;
  }

  Future<http.Response> exchangeTokenToAccessToken(
      Map<String, String> headers, Map data, String url) {
    return http.post(
      Uri.parse(url),
      headers: headers,
      body: data,
    );
  }

  Future<http.Response> exchangeTokenToAccessToken2(
      String url, Map<String, String> headers, Map<String, String> data) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    return baseApi.createPostMethod(url, data, headers);
  }

  Future<http.Response> getInventoryLocations(String url) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    return baseApi.createGetMethod(url, headers);
  }

  Future<http.Response> createInventoryLocation(
      String url, Map<String, dynamic> data, String id) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    return baseApi.createPostMethod(url, data, headers, id: id);
  }

  Future<http.Response> getInventoryItems(String url) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    return baseApi.createGetMethod(url, headers);
  }

  Future<http.Response> getInventoryItem(String url, String sku) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    return baseApi.createGetMethod(url, headers, id: sku);
  }

  Future<http.Response> createInventoryItem(
      String url, String data, String sku) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    headers["Content-Type"] = "application/json";
    headers["Content-Language"] = "en-US";
    return baseApi.createPutMethod(url, data, headers, id: sku);
  }

  Future<http.Response> createOffer(String url, String data) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    headers["Content-Type"] = "application/json";
    headers["Content-Language"] = "en-US";

    return baseApi.createPostMethodWithStringBody(url, data, headers);
  }

  Future<http.Response> createPublishOffer(String url) {
    Map<String, String> headers = {};
    headers["Accept"] = "application/json";
    Map<String, dynamic> data = {};
    return baseApi.createPostMethod(url, data, headers);
  }

  Future<http.Response> getAllListings(
      {int entriesPerPage = 200, int pageNumber = 1}) {
    final String requestBody = '''<?xml version="1.0" encoding="utf-8"?>
    <GetMyeBaySellingRequest xmlns="urn:ebay:apis:eBLBaseComponents">
      <RequesterCredentials>
        <eBayAuthToken>${mUser.ebayAccessToken}</eBayAuthToken>
      </RequesterCredentials>
      <ActiveList>
        <Sort>TimeLeft</Sort>
        <Pagination>
          <EntriesPerPage>$entriesPerPage</EntriesPerPage>
          <PageNumber>$pageNumber</PageNumber>
        </Pagination>
      </ActiveList>
    </GetMyeBaySellingRequest>
  ''';

    final Map<String, String> headers = {
      'X-EBAY-API-CALL-NAME': 'GetMyeBaySelling',
      'X-EBAY-API-APP-ID': mUser.runame,
      'X-EBAY-API-DEV-ID': mUser.devId,
      'X-EBAY-API-CERT-ID': mUser.clientSecretCertId,
      'X-EBAY-API-COMPATIBILITY-LEVEL': '1163',
      'X-EBAY-API-SITEID': '0', // For US eBay site
      'X-EBAY-API-IAF-TOKEN':
          mUser.ebayAccessToken, // eBay token for authentication
      'Content-Type': 'text/xml'
    };
    return baseApi.createPostMethodWithStringBody(
        ApiEndpoints.ebayMainDLL, requestBody, headers);
  }

  Future<http.Response> getOrders({DateTime? mStartTime, DateTime? mEndtime}) {
    DateTime now = DateTime.now();
    DateTime startTime = now.subtract(Duration(days: now.weekday + 6));
    DateTime endTime = now.subtract(Duration(days: now.weekday));

    if (mStartTime != null) {
      startTime = mStartTime;
    }
    if (mEndtime != null) {
      endTime = mEndtime;
    }
    String url = 'https://api.ebay.com/sell/fulfillment/v1/order';

    print(url);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-EBAY-C-MARKETPLACE-ID': 'EBAY_US',
    };
    return baseApi.createGetMethod(url, headers);
  }

  Future<http.Response> getAwaitingOrders(
      {DateTime? mStartTime, DateTime? mEndtime}) {
    DateTime now = DateTime.now();
    DateTime startTime = now.subtract(Duration(days: now.weekday + 6));
    DateTime endTime = now.subtract(Duration(days: now.weekday));

    if (mStartTime != null) {
      startTime = mStartTime;
    }
    if (mEndtime != null) {
      endTime = mEndtime;
    }
    String url =
        'https://api.ebay.com/sell/fulfillment/v1/order?filter=awaiting_shipment';

    print(url);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-EBAY-C-MARKETPLACE-ID': 'EBAY_US',
    };
    return baseApi.createGetMethod(url, headers);
  }

  Future<String> getMainPhotoOfItem(String itemId) async {
    var response = await http.post(
      Uri.parse('https://api.ebay.com/ws/api.dll'),
      headers: {
        "X-EBAY-API-CALL-NAME": "GetItem",
        "X-EBAY-API-APP-ID": mUser.clientIdAppId,
        "X-EBAY-API-DEV-ID": mUser.devId,
        "X-EBAY-API-CERT-ID": mUser.clientSecretCertId,
        "X-EBAY-API-COMPATIBILITY-LEVEL": "967",
        "X-EBAY-API-SITEID": "0",
        "Content-Type": "text/xml"
      },
      body: '<?xml version="1.0" encoding="utf-8"?>'
          '<GetItemRequest xmlns="urn:ebay:apis:eBLBaseComponents">'
          '<RequesterCredentials>'
          '<eBayAuthToken>${mUser.ebayAccessToken}</eBayAuthToken>'
          '</RequesterCredentials>'
          '<ItemID>$itemId</ItemID>'
          '</GetItemRequest>',
    );
    if (response.statusCode == 200) {
      var document = xml.XmlDocument.parse(response.body);
      var pictureUrls = document
          .findAllElements('PictureURL')
          .map((node) => node.text)
          .toList();

      // Step 3: Parse item pictures from item details
      return pictureUrls[0];
    } else {
      print("Failed to fetch item details: ${response.statusCode}");
    }

    return " ";
  }
}
