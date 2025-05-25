import 'package:amazon_to_ebay/model/listing_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ListingModelAdapter extends TypeAdapter<ListingModel> {
  @override
  final int typeId = 0;
  @override
  ListingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListingModel(
        fields[0] as String,
        fields[1] as String,
        fields[3] as String,
        fields[4] as String,
        fields[5] as String?,
        fields[6] as String,
        fields[7] as String,
        fields[8] as String,
        fields[9] as String,
        fields[10] as String,
        fields[10] as String);
  }

  @override
  void write(BinaryWriter writer, ListingModel obj) {
    writer
      ..write(obj.buyItNowPrice)
      ..write(obj.itemId)
      ..write(obj.listingDetails)
      ..write(obj.listingDuration)
      ..write(obj.listingType)
      ..write(obj.quantity)
      ..write(obj.quantityAvailable)
      ..write(obj.sellingStatus)
      ..write(obj.timeLeft)
      ..write(obj.title)
      ..write(obj.sku);
  }
}
