import 'dart:convert';

import 'package:amazon_to_ebay/amazon/amazon_page.dart';
import 'package:amazon_to_ebay/dashboard/dashboard.dart';
import 'package:amazon_to_ebay/ebay/seller/seller_page.dart';
import 'package:amazon_to_ebay/ebay/web_login.dart';
import 'package:amazon_to_ebay/model/listing_model.dart';
import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:amazon_to_ebay/model_adapter/listing_model_adapter.dart';
import 'package:amazon_to_ebay/network/network_manager.dart';
import 'package:amazon_to_ebay/test.dart';
import 'package:amazon_to_ebay/utils/consts.dart';
import 'package:amazon_to_ebay/utils/hive_data_manager.dart';
import 'package:amazon_to_ebay/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ListingModelAdapter());
  //Hive.registerAdapter(InventoryModelAdapter());
  //Hive.registerAdapter(InventoryProductModelAdapter());
  await Hive.openBox<ListingModel>("listings");
  //await Hive.openBox<InventoryModel>("inventory_list");
  HiveDataManager dataManager = HiveDataManager();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController codeInputController = TextEditingController();
  String mainInfoText = "info text";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Visibility(
                  visible: shouldLoginVisible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WebLogin()));
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DashboardPage()));
                          },
                          child: Text('Login to Ebay')),
                      Visibility(
                        visible: isLoginButtonClicked,
                        child: Container(
                          width: 200,
                          height: 50,
                          child: TextField(
                            controller: codeInputController,
                            onChanged: (text) {
                              setState(() {
                                getAccessTokenButtonVisibility =
                                    text.isNotEmpty;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Enter login url here"),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: getAccessTokenButtonVisibility,
                          child: ElevatedButton(
                              onPressed: getAccessToken,
                              child: Text('Get Access Token'))),
                    ],
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EbaySellerPage()));
                    getLoginButton();
                  },
                  child: Text("Go to Ebay Seller")),
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AmazonPage()));
                    getLoginButton();
                  },
                  child: Text("Go to Amazon")),
              ElevatedButton(
                  onPressed: loginToEbayForSellACC,
                  child: Text('Login to Ebay for sell account')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage()));
                  },
                  child: Text('DashBoard')),
              ElevatedButton(
                  onPressed: () {
                    mUser.clearSharedPrefs();
                    setState(() {
                      shouldLoginVisible = true;
                    });
                  },
                  child: Text('Clear Shared Prefs')),
              Visibility(
                visible: mainInfoText.length > 12 || !mUser.accessTokenExpired,
                child: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                            ClipboardData(text: mUser.ebayAccessToken))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Access token copied to clipboard")));
                    });
                  },
                  child: Text(
                    "Click to copy access token",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyTest()));
                  },
                  child: Text('Go to Text')),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: mUser.accessTokenExpired,
        child: FloatingActionButton(
          onPressed: () async {
            String refreshToken =
                'YOUR_REFRESH_TOKEN'; // Replace with your refresh token
            Map<String, dynamic>? refreshedTokenData =
                await networkManager.refreshAccessToken(refreshToken);
            print(refreshedTokenData);
            if (refreshedTokenData != null) {
              mUser.ebayAccessToken = refreshedTokenData['access_token'];
              mUser.ebayRefreshToken = refreshedTokenData['refresh_token'];
              mUser.ebayRefreshTokenExpires =
                  refreshedTokenData['refresh_token_expires_in'];
              // Obtain shared preferences.
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setString(
                  Consts.EBAY_ACCESS_TOKEN, mUser.ebayAccessToken);
              await prefs.setString(
                  Consts.EBAY_REFRESH_TOKEN, mUser.ebayRefreshToken);
              await prefs.setInt(Consts.EBAY_REFRESH_TOKEN_EXPIRE,
                  mUser.ebayRefreshTokenExpires + DateTime.now().millisecond);
              setState(() {
                shouldLoginVisible = false;
                mUser.accessTokenExpired = false;
              });

              print("New access token: ${refreshedTokenData['access_token']}");
              print(
                  "New refresh token: ${refreshedTokenData['refresh_token']}");
              print("Token type: ${refreshedTokenData['token_type']}");
              print("Expires in: ${refreshedTokenData['expires_in']}");
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() async {
    await getEbayCredentials();
    getLoginButton();
  }

  Future<void> getEbayCredentials() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/config.json");
    final jsonResult = jsonDecode(data);
    mUser.clientIdAppId = jsonResult['client_id'];
    mUser.clientSecretCertId = jsonResult['client_secret'];
    mUser.runame = jsonResult['runame'];
    mUser.devId = jsonResult['dev_id'];
  }

  NetworkManager networkManager = NetworkManager();
  UserModel mUser = UserModel();

  Future<void> _launchUrl(Uri url) async {
    print(url);
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  loginToEbayForSellACC() {
    setState(() {
      isLoginButtonClicked = true;
    });
    var loginUrl = networkManager.ebayLaunchLoginUrlForSellAcc();
    setState(() {
      mainInfoText = loginUrl;
    });
  }

  loginToEbay() {
    setState(() {
      isLoginButtonClicked = true;
    });
    var loginUrl = networkManager.ebayLaunchLoginUrl();
    _launchUrl(Uri.parse(loginUrl));
  }

  Future<void> getAccessToken() async {
    String currentUrl = codeInputController.text;
    utils.getAccessToken(currentUrl);
    var token = await utils.getAccessToken(currentUrl);
    setState(() {
      shouldLoginVisible = false;
      mUser.accessTokenExpired = false;
      mainInfoText = token;
    });
  }

  getLoginButton() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shouldLoginVisible = prefs.getString(Consts.EBAY_ACCESS_TOKEN) == null;
    });
    mUser.accessTokenExpired = shouldLoginVisible;
    if (!shouldLoginVisible) {
      mUser.ebayAccessToken = prefs.getString(Consts.EBAY_ACCESS_TOKEN)!;
      mUser.ebayRefreshToken = prefs.getString(Consts.EBAY_REFRESH_TOKEN)!;
      mUser.ebayRefreshTokenExpires =
          prefs.getInt(Consts.EBAY_REFRESH_TOKEN_EXPIRE)!;
    }
  }

  Utils utils = Utils();
  bool shouldLoginVisible = true;
  bool getAccessTokenButtonVisibility = false;
  bool isLoginButtonClicked = false;
}
