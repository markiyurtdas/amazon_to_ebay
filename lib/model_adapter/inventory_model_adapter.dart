import 'package:amazon_to_ebay/model/inventory_model.dart';
import 'package:hive/hive.dart';

class InventoryModelAdapter extends TypeAdapter<InventoryModel> {
  @override
  final int typeId = 1;

  @override
  InventoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as InventoryProductModel,
      fields[3] as String,
      fields[4] as Map<String, dynamic>,
    );
  }

  @override
  void write(BinaryWriter writer, InventoryModel obj) {
    writer
      ..write(obj.sku)
      ..write(obj.locale)
      ..write(obj.product)
      ..write(obj.condition)
      ..write(obj.availability);
  }
}

class InventoryProductModelAdapter extends TypeAdapter<InventoryProductModel> {
  @override
  final int typeId = 2;

  @override
  InventoryProductModel read(BinaryReader reader) {
    return InventoryProductModel()
      ..title = reader.read()
      ..aspects = reader.read()
      ..description = reader.read()
      ..brand = reader.read()
      ..mpn = reader.read()
      ..imageUrl = reader.read();
  }

  @override
  void write(BinaryWriter writer, InventoryProductModel obj) {
    writer
      ..write(obj.title)
      ..write(obj.aspects)
      ..write(obj.description)
      ..write(obj.brand)
      ..write(obj.mpn)
      ..write(obj.imageUrl);
  }
}
