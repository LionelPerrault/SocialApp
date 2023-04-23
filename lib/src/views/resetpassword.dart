import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/whiteFooter.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';

import '../controllers/UserController.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/helper.dart';
import '../routes/route_names.dart';

class ResetScreen extends StatefulWidget {
  ResetScreen({Key? key})
      : con = UserController(),
        super(key: key);
  late UserController con;
  @override
  State createState() => ResetScreenState();
}

class ResetScreenState extends mvc.StateMVC<ResetScreen> {
  bool check1 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late UserController con;
  String email = '';
  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as UserController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: resetPasswordModal(),
      ),
    );
  }

  Widget resetPasswordModal() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(3),
                    backgroundColor: Colors.white,
                    // elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    minimumSize: const Size(30, 30),
                    maximumSize: const Size(30, 30),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RouteNames.login);
                  },
                  child: const Icon(
                    Icons.logout,
                    size: 24,
                    color: Colors.grey,
                  )),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(3),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color.fromARGB(255, 102, 125, 182),
                      Color.fromARGB(255, 0, 130, 200),
                      Color.fromARGB(255, 0, 130, 200),
                      Color.fromARGB(255, 102, 125, 182),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Reset Password',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30)),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Text(
                                'Enter the email address you signed up with and we\'ll email you a reset link',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              !con.isSendResetPassword
                  ? Container(
                      width: 340,
                      height: 250,
                      margin: const EdgeInsets.only(top: 190),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 4,
                            offset: Offset(
                              2,
                              1,
                            ),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 35),
                                ),
                                Container(
                                  width: 260,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 400,
                                    height: 40,
                                    child: TextField(
                                      maxLines: 1,
                                      minLines: 1,
                                      onChanged: (newIndex) {
                                        email = newIndex;
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(top: 10, left: 10),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blue, width: 1.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 1,
                                        spreadRadius: 0.01,
                                        offset: Offset(
                                          1,
                                          1,
                                        ),
                                      )
                                    ],
                                  ),
                                  width: 260,
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      alignment: Alignment.center,
                                      backgroundColor:
                                          con.isSendResetPasswordLoading
                                              ? const Color.fromARGB(
                                                  255, 243, 243, 243)
                                              : Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                    ),
                                    onPressed: con.isSendResetPasswordLoading
                                        ? () {}
                                        : () {
                                            con.resetPassword(email: email);
                                            setState(() {});
                                          },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: con.isSendResetPasswordLoading
                                          ? Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              child:
                                                  const CircularProgressIndicator(),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.mail,
                                                  color: Color.fromARGB(
                                                      255, 35, 35, 35),
                                                  size: 24.0,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                con.isEmailExist == ''
                                    ? Container()
                                    : Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child:
                                            Helper.failAlert(con.isEmailExist)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      width: 340,
                      height: 250,
                      margin: const EdgeInsets.only(top: 190),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10.0,
                            spreadRadius: 4,
                            offset: Offset(
                              2,
                              1,
                            ),
                          )
                        ],
                      ),
                      child: resendResetPasswordScreen(),
                    ),
            ],
          ),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          rightFootbar()
        ],
      ),
    );
  }

  Widget resendResetPasswordScreen() {
    return Container(
      color: Colors.white,
      width: SizeConfig(context).screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            child: RichText(
              text: TextSpan(
                text: 'Did not receive Email?',
                style: const TextStyle(color: Colors.black, fontSize: 15),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Resend request',
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        con.resetPassword(email: email);
                        setState(() {});
                      },
                  ),
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                  text: 'Reset Email',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      con.isSendResetPassword = false;
                      setState(() {});
                    },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                TextSpan(
                  text: 'Go to login Screen',
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacementNamed(context, RouteNames.login);
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
