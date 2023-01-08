import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../helpers/helper.dart';
import '../routes/route_names.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);
  @override
  State createState() => PrivacyScreenState();
}

class PrivacyScreenState extends mvc.StateMVC<PrivacyScreen> {
  String privacyContent = '';

  @override
  void initState() {
    super.initState();
    Helper.getPrivacy()
        .then((value) => {privacyContent = value, setState(() {})});
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.topCenter, children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 13.0),
            tooltip: 'Delete',
            onPressed: () {
              Navigator.pushReplacementNamed(context, RouteNames.register);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 55),
            child: SizedBox(
              width: double.infinity,
              height: 133,
              child: Container(
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'Privacy',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  )),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 165,
            ),
            padding: const EdgeInsets.all(25),
            width: 900,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  blurRadius: 14.0,
                  spreadRadius: 4,
                  offset: Offset(
                    1,
                    3,
                  ),
                )
              ],
            ),
            child: Html(
              data: privacyContent,
              style: {
                'p': Style(
                  lineHeight: const LineHeight(1.8),
                ),
                'li': Style(lineHeight: const LineHeight(1.8))
              },
            ),
          )
        ]),
      ),
    );
  }
}
