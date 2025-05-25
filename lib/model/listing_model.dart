import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class ListingModel extends HiveObject {
  @HiveField(0)
  String? buyItNowPrice;
  @HiveField(1)
  String? itemId;
  @HiveField(2)
  String? listingDetails;
  @HiveField(3)
  String? listingDuration;
  @HiveField(4)
  String? listingType;
  @HiveField(5)
  String? quantity;
  @HiveField(6)
  String? quantityAvailable;
  @HiveField(7)
  String? sellingStatus;
  @HiveField(8)
  String? timeLeft;
  @HiveField(9)
  String? title;
  @HiveField(10)
  String? sku;

  Map<String, dynamic> toJson() => {
        "buyItNowPrice": buyItNowPrice,
        "itemId": itemId,
        "listingDetails": listingDetails,
        "listingDuration": listingDuration,
        "listingType": listingType,
        "quantitiy": quantity,
        "quantityAvailable": quantityAvailable,
        "sellingStatus": sellingStatus,
        "timeLeft": timeLeft,
        "title": title,
        "sku": sku
      };

  ListingModel.fromJson(Map<String, dynamic> json) {
    buyItNowPrice = json["BuyItNowPrice"];
    itemId = json["ItemID"];
    listingDetails = json["ListingDetails"];
    listingDuration = json["ListingDuration"];
    listingType = json["ListingType"];
    quantity = json["Quantitiy"];
    quantityAvailable = json["QuantityAvailable"];
    sellingStatus = json["SellingStatus"];
    timeLeft = json["TimeLeft"];
    title = json["Title"];
    sku = json["SKU"];
  }

  ListingModel(
      this.buyItNowPrice,
      this.itemId,
      this.listingDetails,
      this.listingDuration,
      this.listingType,
      this.quantity,
      this.quantityAvailable,
      this.sellingStatus,
      this.timeLeft,
      this.title,
      this.sku);
}
