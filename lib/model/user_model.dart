import 'package:amazon_to_ebay/utils/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static final UserModel _singleton = UserModel._internal();

  factory UserModel() {
    return _singleton;
  }

  UserModel._internal();

  late String clientIdAppId;
  late String clientSecretCertId;
  late String runame;
  late String devId;

  late String ebayUserName;
  late String ebayAccessToken;
  late String ebayRefreshToken;
  late int ebayRefreshTokenExpires;
  bool accessTokenExpired = false;

  Future<void> clearSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Consts.EBAY_ACCESS_TOKEN);
    await prefs.remove(Consts.EBAY_REFRESH_TOKEN_EXPIRE);
    await prefs.remove(Consts.EBAY_REFRESH_TOKEN);
  }
}
