class ApiEndpoints {
  static const String getItem = "https://api.ebay.com/buy/browse/v1/item/";
  static const String prodLoginEndpoint =
      "https://auth.ebay.com/oauth2/authorize";
  static const String exchangeEndpoint =
      "https://api.ebay.com/identity/v1/oauth2/token";
  static const String createInventoryLocationEndpoint =
      "https://api.ebay.com/sell/inventory/v1/location/";
  static const String getInventoryLocationsEndpoint =
      "https://api.ebay.com/sell/inventory/v1/location?limit=4&offset=0";
  static const String getInventoryItems =
      "https://api.ebay.com/sell/inventory/v1/inventory_item?limit=100&offset=0";
  static const String getInventoryItem =
      "https://api.ebay.com/sell/inventory/v1/inventory_item/";
  static const String createInventoryItem =
      "https://api.ebay.com/sell/inventory/v1/inventory_item/";
  static const String createOffer =
      "https://api.ebay.com/sell/inventory/v1/offer";
  static const String publishOffer =
      "https://api.ebay.com/sell/inventory/v1/offer/xxxx/publish";
  static const String getAllListings =
      "https://api.ebay.com/sell/inventory/v1/inventory_item";

  static const String SCOPE_SELL_INVENTORY =
      "https://api.ebay.com/oauth/api_scope/sell.inventory";
  static const String SCOPE_API_SCOPE = "https://api.ebay.com/oauth/api_scope";
  static const String SCOPE_SELL_ACCOUNT =
      "https://api.ebay.com/oauth/api_scope/sell.account";

  static String ebayMainDLL = "https://api.ebay.com/ws/api.dll";

  static String ebayOrderDetail =
      "https://www.ebay.com/mesh/ord/details?mode=SH&srn=441&orderid=";
  static String amazonProductLink = "https://www.amazon.com/dp/";

  static String ebayAllPermissionLink =
      "https://auth.ebay.com/oauth2/authorize?client_id=IkramYur-ProductR-PRD-d4dc5ce78-05496705&response_type=code&redirect_uri=Ikram_Yurtdas-IkramYur-Produc-ecdccbc&scope=https://api.ebay.com/oauth/api_scope https://api.ebay.com/oauth/api_scope/sell.marketing.readonly https://api.ebay.com/oauth/api_scope/sell.marketing https://api.ebay.com/oauth/api_scope/sell.inventory.readonly https://api.ebay.com/oauth/api_scope/sell.inventory https://api.ebay.com/oauth/api_scope/sell.account.readonly https://api.ebay.com/oauth/api_scope/sell.account https://api.ebay.com/oauth/api_scope/sell.fulfillment.readonly https://api.ebay.com/oauth/api_scope/sell.fulfillment https://api.ebay.com/oauth/api_scope/sell.analytics.readonly https://api.ebay.com/oauth/api_scope/sell.finances https://api.ebay.com/oauth/api_scope/sell.payment.dispute https://api.ebay.com/oauth/api_scope/commerce.identity.readonly https://api.ebay.com/oauth/api_scope/sell.reputation https://api.ebay.com/oauth/api_scope/sell.reputation.readonly https://api.ebay.com/oauth/api_scope/commerce.notification.subscription https://api.ebay.com/oauth/api_scope/commerce.notification.subscription.readonly https://api.ebay.com/oauth/api_scope/sell.stores https://api.ebay.com/oauth/api_scope/sell.stores.readonly";
}
