import 'dart:convert';

import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:amazon_to_ebay/network/api_endpoints.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:amazon_to_ebay/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  UserModel _mUser = UserModel();
  NetworkManager _networkManager = NetworkManager();

  Future<String> getAccessToken(String rawUrl) async {
    String currentUrl = rawUrl;
    var token = currentUrl.substring(
        currentUrl.indexOf('&code=') + 6, currentUrl.indexOf('&expires_in'));

    String ciCs = "${_mUser.clientIdAppId}:${_mUser.clientSecretCertId}";
    List<int> encodedCiCs = utf8.encode(ciCs);
    String bs64ECiCs = base64.encode(encodedCiCs);

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Basic $bs64ECiCs"
    };

    Map<String, String> data = {
      "grant_type": "authorization_code",
      "code": Uri.decodeComponent(token),
      "redirect_uri": _mUser.runame
    };
    var result = await _networkManager.exchangeTokenToAccessToken(
        headers, data, ApiEndpoints.exchangeEndpoint);

    var json = jsonDecode(result.body);
    _mUser.ebayAccessToken = json['access_token'];
    _mUser.ebayRefreshToken = json['refresh_token'];
    _mUser.ebayRefreshTokenExpires = json['refresh_token_expires_in'];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Consts.EBAY_ACCESS_TOKEN, _mUser.ebayAccessToken);
    await prefs.setString(Consts.EBAY_REFRESH_TOKEN, _mUser.ebayRefreshToken);
    await prefs.setInt(Consts.EBAY_REFRESH_TOKEN_EXPIRE,
        _mUser.ebayRefreshTokenExpires + DateTime.now().millisecond);
    return json['access_token'];
  }
}
