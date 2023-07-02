import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import '../helpers/emailverified.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class EmailVerificationScreen extends StatefulWidget {
  EmailVerificationScreen(Key? key,
      {required this.oobCode, required this.apiKey, required this.continueUrl})
      : super(key: key);
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
  String actionStringExplain = "";
  bool invalid = false;
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
      EmailVerified.setVerified(true);
      actionString = "Verified!";
      // send axios
      http.get(Uri.parse(widget.continueUrl));
      actionStringExplain =
          "Good news, your email has been verified!\nPlease log in to your Shnatter app.\nYour Shnatter Team";
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'expired-action-code') {
        actionStringExplain = "Sorry, The code is expired";
      } else if (e.code == 'invalid-action-code') {
        actionStringExplain = "Sorry, The code is invalid";
        invalid = true;
      } else if (e.code == 'user-disabled') {
        actionStringExplain = "Sorry, This user disabled";
      } else if (e.code == 'user-not-found') {
        actionStringExplain = "Sorry, We can't find user";
      } else {
        actionStringExplain = "Unknown Error";
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
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                actionString == 'Verified!'
                    ? Center(
                        child: Image.asset('assets/images/emailverified.png'),
                      )
                    : const SizedBox(),
                actionString == 'Verified!'
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            actionString,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      )
                    : SizedBox(),
                const SizedBox(
                  height: 10,
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      actionStringExplain,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                invalid
                    ? const Text(
                        'Your email was confirmed, you can now login into Shnatter!',
                        style: TextStyle(fontSize: 30),
                      )
                    : Container(),
                // SizedBox(
                //     width: 200,
                //     height: 30,
                //     child: MyPrimaryButton(
                //         onPressed: () {
                //           Navigator.pushReplacementNamed(
                //               context, RouteNames.login);
                //         },
                //         buttonName: "Login Now",
                //         color: Colors.blue))
              ],
            ));
  }
}
