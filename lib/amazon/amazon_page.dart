import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AmazonPage extends StatefulWidget {
  @override
  State<AmazonPage> createState() => _AmazonPageState();
}

class _AmazonPageState extends State<AmazonPage> {
  UserModel mUser = UserModel();
  String infoText = "Info text";
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
              ),
              ElevatedButton(onPressed: getLink, child: Text('Get Link')),
              SelectableText(infoText)
            ],
          ),
        ),
      ),
    );
  }

  getLink() async {
    var response = await http.get(Uri.parse(textEditingController.text));

    String htmlToParse = "empty";
    if (response.statusCode == 200) {
      htmlToParse = response.body;
    }

    setState(() {
      infoText = htmlToParse;
    });
  }
}
