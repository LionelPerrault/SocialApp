import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/widget/primaryInput.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widget/mprimary_button.dart';
import './footerbar.dart';

class TermsScreen extends StatefulWidget {
  TermsScreen({Key? key}) : super(key: key);
  State createState() => TermsScreenState();
}

class TermsScreenState extends mvc.StateMVC<TermsScreen> {
  bool check1 = false;
  bool check2 = false;
  @override
  void initState() {}
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

Widget input(String label, Icon icon) {
  return Container(
    height: 38,
    padding: const EdgeInsets.only(top: 10),
    child: PrimaryInput(
      onChange: () {},
      icon: icon,
      label: label,
    ),
  );
}
