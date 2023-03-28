import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import '../helpers/helper.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/dom.dart' as dom;
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class EmailVerificationScreen extends StatefulWidget {
  EmailVerificationScreen(Key? key,
      {required this.oobCode, required this.apiKey, required this.continueUrl})
      : super(key: key) {}
  String oobCode;
  String apiKey;
  String continueUrl;
  @override
  State createState() => EmailVerificationScreenState();
}

class EmailVerificationScreenState
    extends mvc.StateMVC<EmailVerificationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  String actionString = "";
  @override
  void initState() {
    super.initState();
    isLoading = true;
    applyCode();
  }

  void applyCode() async {
    try {
      var response =
          await FirebaseAuth.instance.applyActionCode(widget.oobCode);
      isLoading = false;
      actionString = "Successfully Verified";
      // send axios
      http.get(Uri.parse(widget.continueUrl));
      print("email verification sucessfully data is");
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'expired-action-code') {
        actionString = "Sorry, The code is expired";
      } else if (e.code == 'invalid-action-code') {
        actionString = "Sorry, The code is invalid";
      } else if (e.code == 'user-disabled') {
        actionString = "Sorry, This user disabled";
      } else if (e.code == 'user-not-found') {
        actionString = "Sorry,We can't find user";
      } else {
        actionString = "Unknown Error";
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(child: buildMainWidget()));
  }

  Widget buildMainWidget() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                actionString,
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 200,
                  height: 30,
                  child: MyPrimaryButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RouteNames.login);
                      },
                      buttonName: "Login Now",
                      color: Colors.blue))
            ],
          ));
  }
}
