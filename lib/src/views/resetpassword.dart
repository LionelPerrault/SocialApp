import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/utils/size_config.dart';

import '../controllers/UserController.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        body: !con.isSendResetPassword
            ? resetPasswordModal()
            : resendResetPasswordScreen());
  }

  Widget resetPasswordModal() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 60.0),
          ),
          Container(
            color: Colors.blue,
            alignment: Alignment.center,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 45.0),
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: SvgPicture.network(
                      'https://test.shnatter.com/content/themes/default/images/headers/undraw_message_sent_1030.svg'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 60.0),
                    ),
                    Text('Reset Password',
                        style: TextStyle(color: Colors.white, fontSize: 22)),
                    Text(
                        'Enter the email address you signed up with and we\'ll email you a reset link',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
                // SvgPicture.network('https://test.shnatter.com/content/themes/default/images/headers/undraw_message_sent_1030.svg'),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 7.0,
                  spreadRadius: 0.1,
                  offset: Offset(
                    1,
                    1,
                  ),
                )
              ],
            ),
            width: 340,
            height: 180,
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(top: 35),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 40.0),
                child: const Text('Email',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              Container(
                width: 260,
                height: 30,
                alignment: Alignment.center,
                child: TextFormField(
                  onChanged: (newIndex) {
                    email = newIndex;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
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
                      color: Colors.black,
                      blurRadius: 10,
                      spreadRadius: 0.01,
                      offset: Offset(
                        2,
                        2,
                      ),
                    )
                  ],
                ),
                width: 260,
                height: 35,
                child: FloatingActionButton.extended(
                  label: const Text('Send',
                      style: TextStyle(
                          color: Colors.black, fontSize: 12)), // <-- Text
                  backgroundColor: Colors.white,
                  icon: const Icon(
                    // <-- Icon
                    Icons.mail,
                    color: Color.fromARGB(255, 35, 35, 35),
                    size: 24.0,
                  ),
                  onPressed: () {
                    // con.signUp(email);
                    con.resetPassword(email: email);
                  },
                ),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60.0),
          ),
          SizedBox(
              width: 1100,
              height: 90,
              child: Container(
                margin:
                    const EdgeInsets.only(right: 170, bottom: 20, left: 170),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    text('@ 2022 Shnatter',
                        const Color.fromRGBO(150, 150, 150, 1), 11),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    Image.network(
                      'https://test-file.shnatter.com/uploads/flags/en_us.png',
                      width: 11,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    text('English', const Color.fromRGBO(150, 150, 150, 1), 11),
                    Flexible(fit: FlexFit.tight, child: SizedBox()),
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Row(children: [
                        text('About', Colors.grey, 11),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        text('Terms', Colors.grey, 11),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        text('Contact Us', Colors.grey, 11),
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        text('Directory', Colors.grey, 11),
                      ]),
                    )
                  ],
                ),
              ))
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
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 15),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                con.resetPassword(email: email);
                              }),
                      ]),
                )),
            RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Go to login Screen',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, RouteNames.login);
                          }),
                  ]),
            )
          ],
        ));
  }
}

Widget text(String title, Color color, double size) {
  return Text(title, style: TextStyle(color: color, fontSize: size));
}
