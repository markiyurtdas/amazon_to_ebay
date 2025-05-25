import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
class InventoryModel extends HiveObject {
  @HiveField(0)
  String? sku;
  @HiveField(1)
  String? locale;
  @HiveField(2)
  InventoryProductModel? product;
  @HiveField(3)
  String? condition;
  @HiveField(4)
  Map<String, dynamic>? availability;

  Map<String, dynamic> toJson() => {
        "sku": sku,
        "locale": locale,
        "product": product?.toJson(),
        "condition": condition,
        "availability": availability
      };

  InventoryModel.fromJson(Map<String, dynamic> json) {
    sku = json["sku"];
    locale = json["locale"];
    product = InventoryProductModel.fromJson(json["product"]);
    condition = json["condition"];
    availability = json["availability"];
  }

  InventoryModel(
      this.sku, this.locale, this.product, this.condition, this.availability);
}

@HiveType(typeId: 2)
class InventoryProductModel extends HiveObject {
  @HiveField(0)
  String? title;
  @HiveField(1)
  Map<String, dynamic>? aspects;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? brand;
  @HiveField(4)
  String? mpn;
  @HiveField(5)
  List<String>? imageUrl;

  Map<String, dynamic> toJson() => {
        "title": title,
        "aspects": aspects,
        "description": description,
        "brand": brand,
        "mpn": mpn,
        "imageUrl": imageUrl
      };

  InventoryProductModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    aspects = json["aspects"];
    description = json["description"];
    brand = json["brand"];
    mpn = json["mpn"];
    imageUrl = json["imageUrl"];
  }

  InventoryProductModel();
}
