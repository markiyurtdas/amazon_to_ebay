import 'package:amazon_to_ebay/utils/hive_data_manager.dart';
import 'package:flutter/material.dart';

class MyTest extends StatefulWidget {
  @override
  State<MyTest> createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> {
  @override
  build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          ElevatedButton(
              onPressed: createHiveBox, child: Text("Create hive box")),
          ElevatedButton(onPressed: getHiveBox, child: Text("Get hive box"))
        ]),
      ),
    );
  }

  createHiveBox() {}

  getHiveBox() {
    _hiveDataManager.clearHive();
  }

  HiveDataManager _hiveDataManager = HiveDataManager();
}
