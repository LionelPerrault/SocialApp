import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);
  @override
  State createState() => PrivacyScreenState();
}

class PrivacyScreenState extends mvc.StateMVC<PrivacyScreen> {
  bool check1 = false;
  bool check2 = false;
  @override
  void initState() {
    super.initState();
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: Container(
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          'Privacy',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      )),
                ))));
  }
}
