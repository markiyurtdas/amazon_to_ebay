import 'package:amazon_to_ebay/model/inventory_model.dart';
import 'package:amazon_to_ebay/model/listing_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataManager {
  static final HiveDataManager _singleton = HiveDataManager._internal();
  late Box<ListingModel> _listingBox;
  late Box<InventoryModel> _inventoryBox;

  factory HiveDataManager() {
    return _singleton;
  }
  HiveDataManager._internal();

  clearHive() {
    Hive.deleteFromDisk();
  }

  Box<ListingModel> getListingBox() {
    _listingBox = Hive.box("listings");
    return _listingBox;
  }

  Box<InventoryModel> getInventoryBox() {
    _inventoryBox = Hive.box("inventory_list");
    return _inventoryBox;
  }
}
