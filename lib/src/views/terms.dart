import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../helpers/helper.dart';

class TermsScreen extends StatefulWidget {
  TermsScreen({Key? key}) : super(key: key);
  State createState() => TermsScreenState();
}

class TermsScreenState extends mvc.StateMVC<TermsScreen> {
  String termsContent = "";

  @override
  void initState() {
    super.initState();
    Helper.getTerms().then((value) => {termsContent = value, setState(() {})});
  }

  String dropdownValue = 'Male';
  @override
  Widget build(BuildContext context) {
    print(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(left: 20),
                    // alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 133,
                      child: Container(
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              'Terms',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 130,
                    ),
                    padding: const EdgeInsets.all(25),
                    width: 1000,
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
                      data: termsContent,
                      style: {
                        'p': Style(
                          lineHeight: const LineHeight(1.8),
                        ),
                        'li': Style(lineHeight: const LineHeight(1.8))
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
