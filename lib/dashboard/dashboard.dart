import 'package:amazon_to_ebay/dashboard/home/home_page.dart';
import 'package:amazon_to_ebay/dashboard/inventory/inventory_page.dart';
import 'package:amazon_to_ebay/dashboard/listing/listing.dart';
import 'package:amazon_to_ebay/dashboard/settings/settings_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String title = "Dashboard";
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: getBody(),
      ),
      drawer: getDrawer(),
    );
  }

  Widget getBody() {
    Widget _body = Container();
    if (_selectedIndex == 0) {
      _body = HomePage();
    } else if (_selectedIndex == 1) {
      _body = ListingPage();
    } else if (_selectedIndex == 2) {
      _body = Container(
        width: 1400,
        height: 800,
        child: InventoryPage(),
      );
    } else if (_selectedIndex == 9) {
      _body = SettingsPage();
    } else {
      _body = HomePage();
      setState(() {
        title = "Dashboard";
      });
    }
    return _body;
  }

  Widget getDrawer() {
    return Container(
      color: Colors.white,
      width: 200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () {
              if (_selectedIndex != 0) {
                setState(() {
                  title = "Dashboard";
                  _selectedIndex = 0;
                });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(
              'Listing',
              style: TextStyle(),
            ),
            selected: _selectedIndex == 1,
            onTap: () {
              if (_selectedIndex != 1) {
                setState(() {
                  title = "Active Listings";
                  _selectedIndex = 1;
                });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(
              'Inventory',
              style: TextStyle(),
            ),
            selected: _selectedIndex == 2,
            onTap: () {
              if (_selectedIndex != 2) {
                setState(() {
                  title = "Inventory";
                  _selectedIndex = 2;
                });
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text(
              'Settings',
              style: TextStyle(),
            ),
            selected: _selectedIndex == 9,
            onTap: () {
              if (_selectedIndex != 9) {
                setState(() {
                  _selectedIndex = 9;
                  title = "Settings";
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
