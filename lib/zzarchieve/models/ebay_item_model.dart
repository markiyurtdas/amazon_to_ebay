class EbayItemModel {
  late String itemId;
  late String title;
  late String shortDescription;
  late Price price;
  late EbayImage image;

  EbayItemModel(
      this.itemId, this.title, this.shortDescription, this.price, this.image);

  factory EbayItemModel.fromJson(Map<String, dynamic> json) => EbayItemModel(
      json['itemId'],
      json['title'],
      json['shortDescription'],
      Price.fromJson(json['price']),
      EbayImage.fromJson(json['image']));
}

class Price {
  late double value;
  late String currency;

  Price(this.value, this.currency);

  factory Price.fromJson(Map<String, dynamic> json) =>
      Price(double.parse(json["value"]), json["currency"]);

  Map<String, dynamic> toJson() => {"value": value, "currency": currency};
}

class EbayImage {
  late String imageUrl;
  late int width;
  late int height;

  EbayImage(this.imageUrl, this.width, this.height);

  factory EbayImage.fromJson(Map<String, dynamic> json) =>
      EbayImage(json["imageUrl"], json["width"], json["height"]);

  Map<String, dynamic> toJson() =>
      {"imageUrl": imageUrl, "width": width, "height": height};
}
