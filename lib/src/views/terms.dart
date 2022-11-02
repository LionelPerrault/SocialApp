import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/widget/primaryInput.dart';

class TermsScreen extends StatefulWidget {
  TermsScreen({Key? key}) : super(key: key);
  State createState() => TermsScreenState();
}

class TermsScreenState extends mvc.StateMVC<TermsScreen> {
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
                          'Term',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      )),
                ))));
  }
}
