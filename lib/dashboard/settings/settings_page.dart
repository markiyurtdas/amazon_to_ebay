import 'package:amazon_to_ebay/dashboard/settings/settings_listing_items_page.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: 400,
            height: 400,
            child: SettingsListingItemspage(),
          )
        ],
      ),
    );
  }
}
